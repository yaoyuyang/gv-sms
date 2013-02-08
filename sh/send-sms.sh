#!/bin/bash

#------------------------------------------------------------------------------#
# Sends a text message using Google Voice! The recipient phone number is the 
#  first argument and the contents of the text are the second argument.
#  Note that the password for your account will be in plaintext here, so don't 
#  put this file in a public place. There is probably a way to do this without 
#  a plaintext password.
#
# Example:
# ./send-sms.sh 1234567890 "Hello, World"
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# CONFIGURE - YOUR LOGIN INFO
#------------------------------------------------------------------------------#

# Your credentials for your Google account. You must have google voice 
#  activated. Note that authentication doesn't seem to work with Google Apps
#  accounts, so if you're using an Apps account you may need to sign up for
#  an ordinary Google account as well.

email="youraccount@gmail.com"
passwd="yourpassword"

# Get this number by looking at the POST request that's used when you send a 
#  text using a browser. The field is called "_rnr_se". It apparently 
#  doesn't change.

rnrse="Replace this string with _rnr_se"

# This is supposed to be some descriptor for your application, can be whatever
#  you want.

app="texting-for-fun-and-profit" 

#------------------------------------------------------------------------------#
# Authorize and send text
#------------------------------------------------------------------------------#

#TODO: Validate arguments

# URL encode the text message (sort of)
# TODO: Determine when/if this needs to be done
msg="$(echo $2 | sed s/\ /%20/g | sed s/\&/%26/g | sed s/?/%3F/g)"

# Display preformatted and formatted SMS string
echo -e "\n$2\n$msg\n"

# Login to Google account (grandcentral)
#TODO: Only reauthorize if existing credentials fail during SMS send request
curl -d \
 "accountType=GOOGLE&Email=$email&Passwd=$passwd&service=grandcentral&source=$app"\
 https://www.google.com/accounts/clientLogin >auth.txt

# Extract just the Auth= field, and remove "Auth=" 
auth="$(cat auth.txt | grep Auth= | sed s/^Auth=//)"

# Send the text. Header will include Auth= line from above.
curl -H "Authorization: GoogleLogin auth=$auth" \
    -d "id=&phoneNumber=$1&text=$msg&_rnr_se=$rnrse" \
    https://www.google.com/voice/sms/send/

echo -e "\n"

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
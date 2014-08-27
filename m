Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbaH0Tpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:45:30 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:52078 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaH0Tp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <53FE330F.8070601@infradead.org>
References: <CAGhpvooRXZTsWL58hFReD0b+2Wf-iRmW_b-uV+aihpRNVWj1WA@mail.gmail.com>
	<53FE330F.8070601@infradead.org>
Date: Wed, 27 Aug 2014 22:45:25 +0300
Message-ID: <CAGhpvoq5X2s8oFPuJsJWwmkyQKFb+kLAkgiW81eDwkTRdwmUSg@mail.gmail.com>
Subject: Re: [PATCH v2] i2c documentation: rename variable "register" to "reg"
From: =?UTF-8?B?Sm9zw6kgTWFudWVsIEFsYXJjw7NuIFJvbGTDoW4=?= 
	<jose.alarcon.roldan@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: wsa@the-dreams.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-27 22:35 GMT+03:00 Randy Dunlap <rdunlap@infradead.org>:
> On 08/27/14 11:12, José Manuel Alarcón Roldán wrote:
>> The example code provided with the i2c device interface documentation
>> won't compile since it uses the reserved word "register" to name a
>> variable.
>>
>> The compiler fails with this error message:
>>
>>  error: expected identifier or '(' before '=' token
>>    __u8 register = 0x20; /* Device register to access */
>>                  ^
>>
>> Rename the variable "register" to simply "reg"
>> in the example code.
>>
>> Another couple of typos has been fixed as well.
>>
>>
>> Signed-off-by: Jose Alarcon Roldan <jose.alarcon.roldan@gmail.com>
>> ---
>>  Documentation/i2c/dev-interface | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/i2c/dev-interface b/Documentation/i2c/dev-interface
>> index 3e742ba..744ce70 100644
>> --- a/Documentation/i2c/dev-interface
>> +++ b/Documentation/i2c/dev-interface
>> @@ -57,12 +57,12 @@ Well, you are all set up now. You can now use
>> SMBus commands or plain
>
> The 2 lines above should have been on one line.  Looks like your mail client is
> splitting lines where they shouldn't be split.  Some clients have config
> options for that...   (I fixed it in your patch.)
> Please see if Documentation/email-clients.txt can help you any.
>
>>  I2C to communicate with your device. SMBus commands are preferred if
>>  the device supports them. Both are illustrated below.
>>
>> -  __u8 register = 0x10; /* Device register to access */
>> +  __u8 reg = 0x10; /* Device register to access */
>>    __s32 res;
>>    char buf[10];
>>
>>    /* Using SMBus commands */
>> -  res = i2c_smbus_read_word_data(file, register);
>> +  res = i2c_smbus_read_word_data(file, reg);
>>    if (res < 0) {
>>      /* ERROR HANDLING: i2c transaction failed */
>>    } else {
>> @@ -70,11 +70,11 @@ the device supports them. Both are illustrated below.
>>    }
>>
>>    /* Using I2C Write, equivalent of
>
> The line above should end with a space character as in the current source file
> that is being patched.  Maybe your email client stripped it.  Please fix your
> email client for future patches.
>
>> -     i2c_smbus_write_word_data(file, register, 0x6543) */
>> -  buf[0] = register;
>> +  i2c_smbus_write_word_data(file, reg, 0x6543) */
>
> The line above should be indented more since it is a continuation
> of the comment above it.  I fixed that.
>
>> +  buf[0] = reg;
>>    buf[1] = 0x43;
>>    buf[2] = 0x65;
>> -  if (write(file, buf, 3) ! =3) {
>> +  if (write(file, buf, 3) != 3) {
>>      /* ERROR HANDLING: i2c transaction failed */
>>    }
>>
>
> Patch applied.  Or would you like to see if you can send the patch
> with all of these minor annoying problems fixed?

Thanks Randy for your comments. I will send a new patch.

Hope to get it right this time :-)


>
> Thanks.
>
> --
> ~Randy

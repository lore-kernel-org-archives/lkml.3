Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbbAKKe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:34:27 -0500
Received: from mx02.posteo.de ([89.146.194.165]:41853 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbbAKKeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:34:24 -0500
Message-ID: <54B251A7.3000403@posteo.de>
Date: Sun, 11 Jan 2015 11:34:15 +0100
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: peterz@infradead.org, mingo@kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] hwmon: jc42: use bitops' sign_extend16
References: <1418660317-21750-1-git-send-email-martink@posteo.de> <1418660317-21750-4-git-send-email-martink@posteo.de> <20141215212948.GA23765@roeck-us.net> <548FDC85.3060400@posteo.de>
In-Reply-To: <548FDC85.3060400@posteo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-12-16 um 08:17 schrieb Martin Kepplinger:
> Am 2014-12-15 um 22:29 schrieb Guenter Roeck:
>> On Mon, Dec 15, 2014 at 05:18:34PM +0100, Martin Kepplinger wrote:
>>> ---
>>
>> Some description would be nice. Also, please consider adding
>> relevant subsystem mailing lists and maintainers to your patches.
>>
> 
> I shouldn't have added the Signed-off-by line to some of them. Sorry.
> 
> The driver-patches are meant to be examples of what can be changed if
> the sign_extend functions are added. I don't know if they are taken and
> planned to post the driver patches (probably more) thereafter, and of
> course to the relevant people.

Is this sign_extendXX() set of functions considered to be added to
bitops.h ?

Just checking if I can prepare some driver-patches (the ones I posted
are just examples, meant to be re-sent to relevant maintainers when it's
time), or not.

thanks

> 
>>>  drivers/hwmon/jc42.c | 5 ++---
>>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
>>> index 388f8bc..335a2de 100644
>>> --- a/drivers/hwmon/jc42.c
>>> +++ b/drivers/hwmon/jc42.c
>>> @@ -31,6 +31,7 @@
>>>  #include <linux/hwmon-sysfs.h>
>>>  #include <linux/err.h>
>>>  #include <linux/mutex.h>
>>> +#include <linux/bitops.h>
>>>  
>>>  /* Addresses to scan */
>>>  static const unsigned short normal_i2c[] = {
>>> @@ -215,9 +216,7 @@ static int jc42_temp_from_reg(s16 reg)
>>>  {
>>>  	reg &= 0x1fff;
>>>  
>> If I understand the code in sign_extend16 correctly, the above mask
>> should no longer be necessary.
> 
> exactly. The mask would then be shifting. Thanks!
> 
>>
>> Thanks,
>> Guenter
>>
>>> -	/* sign extend register */
>>> -	if (reg & 0x1000)
>>> -		reg |= 0xf000;
>>> +	reg = sign_extend16(reg, 12);
>>>  
>>>  	/* convert from 0.0625 to 0.001 resolution */
>>>  	return reg * 125 / 2;
>>> -- 
>>> 2.1.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
> 


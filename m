Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaHCQgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 12:36:47 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62163 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaHCQgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 12:36:46 -0400
Message-ID: <53DE6667.8070901@gmail.com>
Date: Sun, 03 Aug 2014 18:42:15 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>, kreijack@inwind.it
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net
Subject: Re: [PATCH 4/4] Return the fan speed via sysfs
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>	<1406901650-20841-5-git-send-email-kreijack@inwind.it>	<20140803161738.485f3f60@endymion.delvare>	<53DE54D5.2050806@inwind.it> <20140803175901.27519306@endymion.delvare>
In-Reply-To: <20140803175901.27519306@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2014 05:59 PM, Jean Delvare wrote:
> On Sun, 03 Aug 2014 17:27:17 +0200, Goffredo Baroncelli wrote:
>> On 08/03/2014 04:17 PM, Jean Delvare wrote:
>>> On Fri,  1 Aug 2014 14:00:50 +0000, Goffredo Baroncelli wrote:
>>>> Return the fan speed via sysfs:
>>>> /sys/devices/temperature/fan_level
>>>
>>> Good idea. Even better would be if the driver would expose a standard
>>> hwmon interface for the temperature values. Fan level could go in
>>> attribute "pwm1" after proper scaling.
>>
>> I tought the same. But until now the value logged is an integer value
>> between 1 and 11. So I preferred to leave it as is.
>>
>> The thing that I can do is to *add* a further attribute called pwm1.
>> ( I have to check how adm1031.c computes its pwm), because is a 
>> more standard interface.
> 
> The temperature attributes in hwmon would need different names and
> units too (temp1_input and temp2_input, in millidegree C.) The
> advantage is that all monitoring applications out there would pick up
> these values automatically.

Are you suggesting to add also a "temp1_input" attribute ?

> 
>> I even thought to allow to change the fan speed from user space....
> 
> Ben will never let you do that ;-)

What would be the risk ?. When the CPU temperature goes behind the limit, 
then the computer is switched off by an hardware protection (I am sure because
I had to changed a cpu board because a drift of the temperature sensor).

I am not suggesting to allow to change the fan speed, I am only asking which would
be the risk.

> 
>>>> @@ -265,6 +271,7 @@ setup_hardware( void )
>>>>  
>>>>  	err = device_create_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
>>>>  	err |= device_create_file( &x.of_dev->dev, &dev_attr_case_temperature );
>>>> +	err |= device_create_file( &x.of_dev->dev, &dev_attr_fan_level );
>>>>  	if (err)
>>>>  		printk(KERN_WARNING
>>>>  			"Failed to create temperature attribute file(s).\n");
>>>
>>> That's not your fault but please note that this construct is broken.
>>> You can't "or" error codes together, the result if two or more calls
>>> fail with different error codes is pretty random. Instead, each error
>>> must be tested individually. I know checkpatch.pl will complain if you
>>> do that but you can ignore it as is it the right thing to do in that
>>> case.
>>
>> The really question is what we should do if the 2nd device_create_file()
>> would fail: we should fails the driver initialization ? or we should
>> continue, because even if there aren't some sysfs attributes the driver
>> work enough ?
> 
> I would log a warning and continue because it's a secondary feature of
> the driver. Exactly as the driver already does - no change here.
> 
> In practice it's never going to happen so it doesn't really matter. I
> just wanted to point out that the construct used in the driver was
> dangerous. In this specific case it's harmless because the value of
> "err" is never used (other than the fact that it's non-zero.) But if
> the error code was included in the log message for example (which is
> recommended), it would possibly make no sense.
> 
> Feel free to ignore this problem in this patch, it's not so important.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

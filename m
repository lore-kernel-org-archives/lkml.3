Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3AaVXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:23:42 -0500
Received: from us-mx2.synaptics.com ([12.239.216.76]:12102 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3AaVXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:23:39 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 16:23:39 EST
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 31 Jan 2013 12:26:53 -0800
Message-ID: <510ADEA2.1080407@synaptics.com>
Date: Thu, 31 Jan 2013 13:14:10 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 04/05] input: RMI4 F01 device control
References: <1358557965-29065-1-git-send-email-cheiny@synaptics.com> <1358557965-29065-5-git-send-email-cheiny@synaptics.com> <20130131080859.GA4356@core.coreip.homeip.net>
In-Reply-To: <20130131080859.GA4356@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 12:08 AM, Dmitry Torokhov wrote:
> Hi Chris,
>
> On Fri, Jan 18, 2013 at 05:12:44PM -0800, Christopher Heiny wrote:
>> In addition to the changes described in 0/0 of this patchset, this patch
>> includes device serialization updated to conform to the latest RMI4
>> specification.
>
> I was looking at the various aspects of the RMI4 patchset, trying to
> fix the issues that I see, but there is one big issue that I simply do
> not have time to tackle - the driver is completely broken on big endian
> architectures due to reliance on bitfileds when exchanging the data with
> the device.

Grumble.  I brought this up during the original development, but was 
assured that it would work fine per the C language spec.  I'll have to 
revisit that discussion and report back.

Also, I noticed you merged F01 header into F01.  That's going to have to 
be backed out, because F05, F34, and F54 are also interested in the F01 
stuff, as is the (proposed) F01 diagnostic module.  We just aren't 
submitting that code right now in order to keep the code down to a 
managable size.

> Consider the following structures:
>
>>   struct f01_device_status {
>> -	u8 status_code:4;
>> +	enum rmi_device_status status_code:4;
>>   	u8 reserved:2;
>>   	u8 flash_prog:1;
>>   	u8 unconfigured:1;
>> @@ -159,4 +136,113 @@ struct f01_device_control_0 {
>>   	u8 configured:1;
>>   } __attribute__((__packed__));
>>
>> +/**
>> + * @reset - set this bit to force a firmware reset of the sensor.
>> + */
>> +struct f01_device_commands {
>> +	u8 reset:1;
>> +	u8 reserved:7;
>> +};
>> +
>
> To make this work on BE boxes you either need to add #ifdefs to the
> structures reversing the order of fields or use bit shifts and masks to
> get/set specific bits in bytes.
>
> I tried converting F01 code (you can see the [likely broken as I can't
> test] result in my tree), but I really do not have time for F11.
>
> Thanks.
>


-- 

Christopher Heiny
Senior Staff Firmware Engineer
Synaptics Incorporated

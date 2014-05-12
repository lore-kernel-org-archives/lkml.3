Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbaELCVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:21:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62506 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaELCVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 22:21:07 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5370300A.8070102@roeck-us.net>
Date: Sun, 11 May 2014 19:20:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atx.name>, jdelvare@suse.de
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] drivers/hwmon/emc1403.c: add support for
 emc1412
References: <20140511130023.GA501@dashie> <536FFC55.2080009@roeck-us.net>
In-Reply-To: <536FFC55.2080009@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 03:40 PM, Guenter Roeck wrote:
[ ... ]

>>
>>       id = i2c_smbus_read_byte_data(client, THERMAL_REVISION_REG);
>> -    if (id != 0x01)
>> +    if (id != 0x01 && id != 0x04) {
>>           return -ENODEV;
>
> This should be a separate patch, as it applies to emc1403/emc1404 as well,
> so we can backport it into -stable.
>

Also, the chip datasheet suggests that chip revision 3 exists as well.
Given that, I would suggest to replace the revision number check with
something like
	if (id < 0x01 || id > 0x04)
		return -ENODEV;

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441AbbA1G2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:28:24 -0500
Received: from bes.se.axis.com ([195.60.68.10]:35818 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbbA1G2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:28:22 -0500
Message-ID: <54C88176.8070107@axis.com>
Date: Wed, 28 Jan 2015 07:28:06 +0100
From: Robert Rosengren <robert.rosengren@axis.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Johan Adolfsson <johana@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval configurable
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>	<54B92596.2040206@roeck-us.net>	<20150116183020.GA6262@roeck-us.net>	<54C74567.9020201@axis.com>	<54C79B87.8040607@roeck-us.net>	<4BEA3FF3CAA35E408EA55C7BE2E61D05943B6DD753@xmail3.se.axis.com>	<20150127200553.GA5689@roeck-us.net> <20150127233455.0c62457e@endymion.delvare> <54C86035.9080605@roeck-us.net> <54C87F3C.2020105@axis.com>
In-Reply-To: <54C87F3C.2020105@axis.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous mail got blocked by mailing lists for some reasons, so 
trying once more. I apologize if spamming.

On 01/28/2015 07:18 AM, Robert Rosengren wrote:
> On 01/28/2015 05:06 AM, Guenter Roeck wrote:
>> On 01/27/2015 02:34 PM, Jean Delvare wrote:
>>> >On Tue, 27 Jan 2015 12:05:53 -0800, Guenter Roeck wrote:
>>>> >>On Tue, Jan 27, 2015 at 08:54:34PM +0100, Robert Rosengren wrote:
>>>>> >>>Guenter and Jean,
>>>>> >>>
>>>>> >>>To sum up, my problems was related my kernel and hardware configuration, and it now works. Many thanks for your input!
>>>>> >>>
>>>>> >>>However, the values retrieved from hwmon sysfs is not the same as before the regmap patch. Guenter, the byte swap for the regval retrieved by regmap_read. In what order is the bits returned from that function, because it seems as if I disabled that code I get values as I expect (i.e. before the regmap patch).
>>>>> >>>
>>>> >>Trying to understand. Are you saying everything works as expected
>>>> >>if you keep byte_swap set to false ?
> Yes it works as expected, i.e. I can get values from sysfs. The 
> problems I experienced was actually due to moving from an old 
> ads7828-implementation where specific i2c addresses where scanned from 
> the driver, and I first missed to set the correct i2c address for the 
> new driver in the board info.
>
>>>> >>
>>>> >>That might well be, though it might mean that regmap has a bug
>>>> >>in how it treats i2c word read operations. I'll have to look into it
>>>> >>some more.
>>> >
>>> >Remember that SMBus specifies that the LSB comes first (and i2c-core
>>> >implement things that way) while real I2C devices typically send the MSB
>>> >first. This has always caused confusion. This is why a lot of drivers
>>> >need byte-swapping.
>>> >
>> regmap specifies "normal" i2c accesses as MSB first. When SMBus accesses
>> are used, it specifies LSB first. I guess that means that regmap assumes
>> the more common case of MSB first, meaning the driver would not need a byte
>> swap since the chip reports data with MSB first.
>>
>> I just hope I interpret it correctly this time.
>>
>> There is also a configuration flag "val_format_endian" which can be set to
>> REGMAP_ENDIAN_BIG or REGMAP_ENDIAN_LITTLE. Maybe that can be used as well
>> if needed. Either case I'll wait for the samples before I send an updated
>> version of the patch.
>>
>> Guenter
>>
> I tested the driver on 3.15 version of the kernel. Having looked in 
> the git log of regmap.c and regmap-i2c.c, there has been some 
> endianess-related patches going into the kernel in newer versions. 
> Maybe that is the reason for me seeing this problem? I will try to 
> look into that further.
>
> I my test I only disabled following two lines of code
> +	if (data->byte_swap)
> +		regval = swab16(regval);
>
> BR, Robert
>


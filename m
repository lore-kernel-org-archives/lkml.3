Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbbA1EGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:06:21 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:54728 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbbA1EGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:06:19 -0500
Message-ID: <54C86035.9080605@roeck-us.net>
Date: Tue, 27 Jan 2015 20:06:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Robert Rosengren <robert.rosengren@axis.com>, lm-sensors@lm-sensors.org,
        Johan Adolfsson <johana@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval configurable
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>	<54B92596.2040206@roeck-us.net>	<20150116183020.GA6262@roeck-us.net>	<54C74567.9020201@axis.com>	<54C79B87.8040607@roeck-us.net>	<4BEA3FF3CAA35E408EA55C7BE2E61D05943B6DD753@xmail3.se.axis.com>	<20150127200553.GA5689@roeck-us.net> <20150127233455.0c62457e@endymion.delvare>
In-Reply-To: <20150127233455.0c62457e@endymion.delvare>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C86039.0188,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 02:34 PM, Jean Delvare wrote:
> On Tue, 27 Jan 2015 12:05:53 -0800, Guenter Roeck wrote:
>> On Tue, Jan 27, 2015 at 08:54:34PM +0100, Robert Rosengren wrote:
>>> Guenter and Jean,
>>>
>>> To sum up, my problems was related my kernel and hardware configuration, and it now works. Many thanks for your input!
>>>
>>> However, the values retrieved from hwmon sysfs is not the same as before the regmap patch. Guenter, the byte swap for the regval retrieved by regmap_read. In what order is the bits returned from that function, because it seems as if I disabled that code I get values as I expect (i.e. before the regmap patch).
>>>
>> Trying to understand. Are you saying everything works as expected
>> if you keep byte_swap set to false ?
>>
>> That might well be, though it might mean that regmap has a bug
>> in how it treats i2c word read operations. I'll have to look into it
>> some more.
>
> Remember that SMBus specifies that the LSB comes first (and i2c-core
> implement things that way) while real I2C devices typically send the MSB
> first. This has always caused confusion. This is why a lot of drivers
> need byte-swapping.
>

regmap specifies "normal" i2c accesses as MSB first. When SMBus accesses
are used, it specifies LSB first. I guess that means that regmap assumes
the more common case of MSB first, meaning the driver would not need a byte
swap since the chip reports data with MSB first.

I just hope I interpret it correctly this time.

There is also a configuration flag "val_format_endian" which can be set to
REGMAP_ENDIAN_BIG or REGMAP_ENDIAN_LITTLE. Maybe that can be used as well
if needed. Either case I'll wait for the samples before I send an updated
version of the patch.

Guenter


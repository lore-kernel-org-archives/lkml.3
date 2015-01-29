Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbbA2OKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:10:33 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:36408 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbbA2OKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:10:32 -0500
Message-ID: <54CA3F53.70107@roeck-us.net>
Date: Thu, 29 Jan 2015 06:10:27 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Robert Rosengren <robert.rosengren@axis.com>,
        Jean Delvare <jdelvare@suse.de>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Johan Adolfsson <johana@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval configurable
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>	<54B92596.2040206@roeck-us.net>	<20150116183020.GA6262@roeck-us.net>	<54C74567.9020201@axis.com>	<54C79B87.8040607@roeck-us.net>	<4BEA3FF3CAA35E408EA55C7BE2E61D05943B6DD753@xmail3.se.axis.com>	<20150127200553.GA5689@roeck-us.net> <20150127233455.0c62457e@endymion.delvare> <54C86035.9080605@roeck-us.net> <54C87F3C.2020105@axis.com> <54C8F73D.4040808@roeck-us.net> <54C9DA9D.3010802@axis.com> <54C9DBD5.5030808@roeck-us.net> <54CA226E.6080505@axis.com>
In-Reply-To: <54CA226E.6080505@axis.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54CA3F57.0139,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/29/2015 04:07 AM, Robert Rosengren wrote:
> On 01/29/2015 08:05 AM, Guenter Roeck wrote:
>> Ah, don't bother then. I should hopefully get the samples in a couple of days.
>
> i2cdump was easily built, so here is the output:
>       0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
> 00: 1301 1301 1301 1301 1301 1301 1301 1301
> 08: 4101 6901 6a01 6901 6901 6901 6901 6901
> 10: 0200 0100 0100 0100 0100 0100 0100 0100
> 18: 0100 0100 0100 0100 0100 0100 0100 0100
> 20: 0200 0100 0100 0100 0100 0100 0100 0100
> 28: 0100 0100 0100 0100 0100 0100 0100 0100
> 30: 0200 0100 0100 0100 0100 0100 0100 0100
> 38: 0100 0100 0100 0100 0100 0100 0100 0100
> 40: 0000 0000 0000 0000 0000 0000 0000 0000
> 48: 0000 0000 0000 0000 0000 0000 0000 0000
> 50: 0200 0100 0100 0100 0100 0100 0100 0100
> 58: 0100 0100 0100 0100 0100 0100 0200 0100
> 60: 0100 0100 0100 0100 0100 0100 0100 0100
> 68: 0100 0100 0100 0100 0100 0100 0100 0100
> 70: 0200 0100 0100 0100 0100 0100 0100 0100
> 78: 0100 0100 0100 0100 0100 0100 0100 0100
> 80: 6501 2401 1701 1401 1301 1301 1301 1301
> 88: 4201 6901 6901 6901 6901 6901 6901 6901
> 90: 0200 0100 0100 0100 0100 0100 0100 0100
> 98: 0100 0100 0100 0100 0100 0100 0100 0100
> a0: 6701 2501 1901 1601 1501 1501 1501 1501
> a8: 4401 6c01 6c01 6c01 6c01 6c01 6c01 6c01
> b0: 0200 0100 0100 0100 0100 0100 0100 0100
> b8: 0100 0100 0100 0100 0100 0100 0100 0100
> c0: 0200 0100 0100 0100 0100 0100 0100 0100
> c8: 0100 0100 0100 0100 0100 0100 0100 0100
> d0: 0200 0100 0100 0100 0100 0100 0100 0100
> d8: 0100 0100 0100 0100 0100 0100 0100 0100
> e0: 6701 2801 1b01 1701 1601 1501 1501 1501
> e8: 4401 6c01 6c01 6c01 6c01 6c01 6c01 6c01
> f0: 0200 0100 0100 0100 0100 0100 0100 0100
> f8: 0100 0100 0100 0100 0100 0100 0100 0100
>
> I checked the value at 0x84 (channel 0, and using single-ended and external reference). I got 222 when reading from corresponding sysfs, and 0x131 * lsb_resolution (806) / 1000 is 222 in decimal. So it seems as data above is correct.
>
> Is the data what you expected?
>
Yes and no. With the above data, the old version of the driver
(non-regmap) works as expected. The driver supporting regmap,
however, needs the byte swap to work correctly.

Guenter


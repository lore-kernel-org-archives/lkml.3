Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbbA2MHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:07:16 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:55912 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbbA2MHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:07:13 -0500
Message-ID: <54CA226E.6080505@axis.com>
Date: Thu, 29 Jan 2015 13:07:10 +0100
From: Robert Rosengren <robert.rosengren@axis.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Johan Adolfsson <johana@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval configurable
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>	<54B92596.2040206@roeck-us.net>	<20150116183020.GA6262@roeck-us.net>	<54C74567.9020201@axis.com>	<54C79B87.8040607@roeck-us.net>	<4BEA3FF3CAA35E408EA55C7BE2E61D05943B6DD753@xmail3.se.axis.com>	<20150127200553.GA5689@roeck-us.net> <20150127233455.0c62457e@endymion.delvare> <54C86035.9080605@roeck-us.net> <54C87F3C.2020105@axis.com> <54C8F73D.4040808@roeck-us.net> <54C9DA9D.3010802@axis.com> <54C9DBD5.5030808@roeck-us.net>
In-Reply-To: <54C9DBD5.5030808@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2015 08:05 AM, Guenter Roeck wrote:
> Ah, don't bother then. I should hopefully get the samples in a couple of days.

i2cdump was easily built, so here is the output:
      0,8  1,9  2,a  3,b  4,c  5,d  6,e  7,f
00: 1301 1301 1301 1301 1301 1301 1301 1301
08: 4101 6901 6a01 6901 6901 6901 6901 6901
10: 0200 0100 0100 0100 0100 0100 0100 0100
18: 0100 0100 0100 0100 0100 0100 0100 0100
20: 0200 0100 0100 0100 0100 0100 0100 0100
28: 0100 0100 0100 0100 0100 0100 0100 0100
30: 0200 0100 0100 0100 0100 0100 0100 0100
38: 0100 0100 0100 0100 0100 0100 0100 0100
40: 0000 0000 0000 0000 0000 0000 0000 0000
48: 0000 0000 0000 0000 0000 0000 0000 0000
50: 0200 0100 0100 0100 0100 0100 0100 0100
58: 0100 0100 0100 0100 0100 0100 0200 0100
60: 0100 0100 0100 0100 0100 0100 0100 0100
68: 0100 0100 0100 0100 0100 0100 0100 0100
70: 0200 0100 0100 0100 0100 0100 0100 0100
78: 0100 0100 0100 0100 0100 0100 0100 0100
80: 6501 2401 1701 1401 1301 1301 1301 1301
88: 4201 6901 6901 6901 6901 6901 6901 6901
90: 0200 0100 0100 0100 0100 0100 0100 0100
98: 0100 0100 0100 0100 0100 0100 0100 0100
a0: 6701 2501 1901 1601 1501 1501 1501 1501
a8: 4401 6c01 6c01 6c01 6c01 6c01 6c01 6c01
b0: 0200 0100 0100 0100 0100 0100 0100 0100
b8: 0100 0100 0100 0100 0100 0100 0100 0100
c0: 0200 0100 0100 0100 0100 0100 0100 0100
c8: 0100 0100 0100 0100 0100 0100 0100 0100
d0: 0200 0100 0100 0100 0100 0100 0100 0100
d8: 0100 0100 0100 0100 0100 0100 0100 0100
e0: 6701 2801 1b01 1701 1601 1501 1501 1501
e8: 4401 6c01 6c01 6c01 6c01 6c01 6c01 6c01
f0: 0200 0100 0100 0100 0100 0100 0100 0100
f8: 0100 0100 0100 0100 0100 0100 0100 0100

I checked the value at 0x84 (channel 0, and using single-ended and 
external reference). I got 222 when reading from corresponding sysfs, 
and 0x131 * lsb_resolution (806) / 1000 is 222 in decimal. So it seems 
as data above is correct.

Is the data what you expected?

>
> Is your hardware big endian or little endian ?
CONFIG_CPU_LITTLE_ENDIAN=y

BR,
Robert


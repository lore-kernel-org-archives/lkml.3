Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3KIP4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:56:32 -0500
Received: from mic92-1-81-57-185-249.fbx.proxad.net ([81.57.185.249]:59630
	"EHLO smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3KIP43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:56:29 -0500
From: arno@natisbad.org (Arnaud Ebalard)
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCHv0] hwmon: Add support for GMT G751 Temp. Sensor and Thermal Watchdog
References: <87ob5uv5bv.fsf@natisbad.org> <527D9286.4080009@roeck-us.net>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131109:pawel.moll@arm.com::IpPhn3ZKoOz1RqAi:00000000000000000000000000000000000000000000lK8
X-Hashcash: 1:20:131109:lm-sensors@lm-sensors.org::cvbA58LAzCUw5TvF:0000000000000000000000000000000000000Dx7
X-Hashcash: 1:20:131109:grant.likely@linaro.org::F/YNpSwElg9gfPvJ:0000000000000000000000000000000000000008Va
X-Hashcash: 1:20:131109:rob.herring@calxeda.com::ee6AKvw7/L6hL/28:0000000000000000000000000000000000000003B2
X-Hashcash: 1:20:131109:ijc+devicetree@hellion.org.uk::EHY8nESYxdSkuyOF:000000000000000000000000000000001t6b
X-Hashcash: 1:20:131109:linux-doc@vger.kernel.org::e/6OWFStzB/MLjyQ:0000000000000000000000000000000000001wWw
X-Hashcash: 1:20:131109:linux@roeck-us.net::6gBAhJUNNqngc56D:00000000000000000000000000000000000000000002VHb
X-Hashcash: 1:20:131109:devicetree@vger.kernel.org::pvTbbDPV2zMFA3mL:000000000000000000000000000000000002xAk
X-Hashcash: 1:20:131109:mark.rutland@arm.com::vz4mYDKHBkoKwC4J:000000000000000000000000000000000000000003I8H
X-Hashcash: 1:20:131109:rob@landley.net::m09I83zb4zHuaUVa:003o/A
X-Hashcash: 1:20:131109:arnd@arndb.de::HCfUsPxUJaMwUBS2:00006Sjf
X-Hashcash: 1:20:131109:khali@linux-fr.org::APyzp7E6jvuWo1AR:00000000000000000000000000000000000000000006Ijc
X-Hashcash: 1:20:131109:swarren@wwwdotorg.org::wV3teSygbZZQy9ac:00000000000000000000000000000000000000006neX
X-Hashcash: 1:20:131109:linux-kernel@vger.kernel.org::CMM6d8lmr6zHjQYW:0000000000000000000000000000000006Pnf
X-Hashcash: 1:20:131109:linus.walleij@linaro.org::g2tpzWrD3ayuDy3S:0000000000000000000000000000000000000GC1v
Date: Sat, 09 Nov 2013 16:56:06 +0100
In-Reply-To: <527D9286.4080009@roeck-us.net> (Guenter Roeck's message of "Fri,
	08 Nov 2013 17:40:22 -0800")
Message-ID: <87siv5bmcp.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Guenter Roeck <linux@roeck-us.net> writes:

> On 11/08/2013 03:31 PM, Arnaud Ebalard wrote:
>>
>> This patch adds support for GMT G751 Temperature Sensor and Thermal
>> Watchdog I2C chip. It has been tested via DT on a Netgear ReadyNAS
>> 2120 (Marvell Armada XP based ARM device).
>>
>> Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
>
> Arnaud,
>
> unless I am missing something, this is just an lm75 with a different
> name. 

Sadly (for me), you are not: I compared the GMT G751 datasheet to an
original (1996) National semiconductor LM75 datasheet and they are
identical. I mean both the structure and full content (text, diagrams,
etc) is the same. Lesson learned: next time I start a driver, I will ask
if it ressembles an existing supported chip beforehand.

> Please use the lm75 driver and add the g751 parameters to it.

I will test if the driver does indeed work as expected to drive the G751
and will send a patch to document compatibility w/ GMT G751 (Kconfig,
i2c_device_id struct and lm75_detect function). While I am at it, if you
see something in the patch I pushed which could be useful for current
lm75 driver (doc, sysfs, of_ part for polarity, ...), just tell me.

Cheers,

a+

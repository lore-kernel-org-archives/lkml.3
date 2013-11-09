Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3KIR3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:29:14 -0500
Received: from mic92-1-81-57-185-249.fbx.proxad.net ([81.57.185.249]:59702
	"EHLO smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3KIR3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:29:11 -0500
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
	<87siv5bmcp.fsf@natisbad.org> <527E6908.2000703@roeck-us.net>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:131109:arnd@arndb.de::vCTFGAwRgyf/sH4Z:00000CSr
X-Hashcash: 1:20:131109:linux-doc@vger.kernel.org::8g2e3DpDlUrOFWyW:0000000000000000000000000000000000000UD4
X-Hashcash: 1:20:131109:grant.likely@linaro.org::WCtpkSQSqk9yvk1q:000000000000000000000000000000000000000TX8
X-Hashcash: 1:20:131109:lm-sensors@lm-sensors.org::g4wYkwSSvxensqPl:00000000000000000000000000000000000013pE
X-Hashcash: 1:20:131109:rob@landley.net::ecl/uRILTpLZoBMh:000XOw
X-Hashcash: 1:20:131109:mark.rutland@arm.com::7n1sTR4oT3gKnC6N:000000000000000000000000000000000000000000qbV
X-Hashcash: 1:20:131109:khali@linux-fr.org::3ehR6bviWGYr6vu6:000000000000000000000000000000000000000000032py
X-Hashcash: 1:20:131109:linus.walleij@linaro.org::pcbsCIVncpKzziVu:00000000000000000000000000000000000002DQ8
X-Hashcash: 1:20:131109:linux@roeck-us.net::Y7qxzgDyAiNKOo3u:00000000000000000000000000000000000000000004eqQ
X-Hashcash: 1:20:131109:ijc+devicetree@hellion.org.uk::msTkW9GGpn/OU2Ez:000000000000000000000000000000004PlQ
X-Hashcash: 1:20:131109:devicetree@vger.kernel.org::FN9DroYVCE/gwf3C:000000000000000000000000000000000003qMz
X-Hashcash: 1:20:131109:swarren@wwwdotorg.org::LI4dxCRYPwPq/0zo:00000000000000000000000000000000000000005baf
X-Hashcash: 1:20:131109:rob.herring@calxeda.com::mhlTroldy2w4zTOx:000000000000000000000000000000000000005weT
X-Hashcash: 1:20:131109:linux-kernel@vger.kernel.org::VK+bSoakccyEHboK:0000000000000000000000000000000008Ag/
X-Hashcash: 1:20:131109:pawel.moll@arm.com::oOWI5NLIMxsjZOKK:0000000000000000000000000000000000000000000GGLd
Date: Sat, 09 Nov 2013 18:28:46 +0100
In-Reply-To: <527E6908.2000703@roeck-us.net> (Guenter Roeck's message of "Sat,
	09 Nov 2013 08:55:36 -0800")
Message-ID: <87fvr5h4c1.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Guenter Roeck <linux@roeck-us.net> writes:

>> Sadly (for me), you are not: I compared the GMT G751 datasheet to an
>> original (1996) National semiconductor LM75 datasheet and they are
>> identical. I mean both the structure and full content (text, diagrams,
>> etc) is the same. Lesson learned: next time I start a driver, I will ask
>> if it ressembles an existing supported chip beforehand.
>>
>
> Hi Arnaud,
>
> that is interesting; I thought it is Yet Another Clone, not really exactly
> the same chip.

If you want to compare:

http://www.ieap.uni-kiel.de/surface/ag-berndt/lehre/fpmc/ns/lm75.pdf
http://natisbad.org/NAS4/refs/GMT_G751.pdf

>>> Please use the lm75 driver and add the g751 parameters to it.
>>
>> I will test if the driver does indeed work as expected to drive the G751
>> and will send a patch to document compatibility w/ GMT G751 (Kconfig,
>> i2c_device_id struct and lm75_detect function). While I am at it, if you
>> see something in the patch I pushed which could be useful for current
>> lm75 driver (doc, sysfs, of_ part for polarity, ...), just tell me.
>>
>
> Depends on what you need. The fault_queue and mode sysfs attributes are neither
> necessary nor  acceptable - hwmon has well defined attributes, and new ones
> are only added after discussion. If you _need_ to configure polarity,
> interrupt mode, or fault queue depth in your application to anything but
> the default, we might discuss adding those as devicetree properties.
> However, you would have to make sure that it does not negatively affect
> the other chips supported by the driver, and we should then discuss
> if other properties should be supported as well. Overall, I strongly suspect
> that the HW is happy with the default configuration. If so, we should just leave
> it alone.

Let's keep lm75 in I2C trivial devices list.

> Power control (the shutdown attribute) should be handled through the PM
> subsystem; see CONFIG_PM / CONFIG_PM_SLEEP in other drivers. If your hardware
> can sleep (which may be somewhat unlikely for a NAS),

lm75 driver does have #ifdef CONFIG_PM (or am I missing something?), but
you are right, I don't think the NAS can take advantage of it ATM.

I just finished the a first version of a patch for lm75 to reference
g751. I'll send it in a separate email.

Anyway, thanks for the quick feedback.

Cheers,

a+

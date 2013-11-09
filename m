Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3KIQzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:55:40 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59928 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab3KIQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:55:38 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <527E6908.2000703@roeck-us.net>
Date: Sat, 09 Nov 2013 08:55:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnaud Ebalard <arno@natisbad.org>
CC: Jean Delvare <khali@linux-fr.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCHv0] hwmon: Add support for GMT G751 Temp. Sensor and Thermal
 Watchdog
References: <87ob5uv5bv.fsf@natisbad.org> <527D9286.4080009@roeck-us.net> <87siv5bmcp.fsf@natisbad.org>
In-Reply-To: <87siv5bmcp.fsf@natisbad.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2013 07:56 AM, Arnaud Ebalard wrote:
> Hi,
>
> Guenter Roeck <linux@roeck-us.net> writes:
>
>> On 11/08/2013 03:31 PM, Arnaud Ebalard wrote:
>>>
>>> This patch adds support for GMT G751 Temperature Sensor and Thermal
>>> Watchdog I2C chip. It has been tested via DT on a Netgear ReadyNAS
>>> 2120 (Marvell Armada XP based ARM device).
>>>
>>> Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
>>
>> Arnaud,
>>
>> unless I am missing something, this is just an lm75 with a different
>> name.
>
> Sadly (for me), you are not: I compared the GMT G751 datasheet to an
> original (1996) National semiconductor LM75 datasheet and they are
> identical. I mean both the structure and full content (text, diagrams,
> etc) is the same. Lesson learned: next time I start a driver, I will ask
> if it ressembles an existing supported chip beforehand.
>

Hi Arnaud,

that is interesting; I thought it is Yet Another Clone, not really exactly
the same chip.

>> Please use the lm75 driver and add the g751 parameters to it.
>
> I will test if the driver does indeed work as expected to drive the G751
> and will send a patch to document compatibility w/ GMT G751 (Kconfig,
> i2c_device_id struct and lm75_detect function). While I am at it, if you
> see something in the patch I pushed which could be useful for current
> lm75 driver (doc, sysfs, of_ part for polarity, ...), just tell me.
>

Depends on what you need. The fault_queue and mode sysfs attributes are neither
necessary nor  acceptable - hwmon has well defined attributes, and new ones
are only added after discussion. If you _need_ to configure polarity,
interrupt mode, or fault queue depth in your application to anything but
the default, we might discuss adding those as devicetree properties.
However, you would have to make sure that it does not negatively affect
the other chips supported by the driver, and we should then discuss
if other properties should be supported as well. Overall, I strongly suspect
that the HW is happy with the default configuration. If so, we should just leave
it alone.

Power control (the shutdown attribute) should be handled through the PM
subsystem; see CONFIG_PM / CONFIG_PM_SLEEP in other drivers. If your hardware
can sleep (which may be somewhat unlikely for a NAS), you could add support
for it to the driver. That is the one improvement I could think of that
might make sense.

Thanks,
Guenter


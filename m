Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3BRANt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:13:49 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:44501 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab3BRANs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:13:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130216230010.GG1741@lizard.sbx05280.losalca.wayport.net>
References: <1361038560-3690-1-git-send-email-andrea.adami@gmail.com>
	<20130216230010.GG1741@lizard.sbx05280.losalca.wayport.net>
Date: Mon, 18 Feb 2013 01:13:46 +0100
Message-ID: <CAAQYJAt0CGi3ZLO8eoYj64Ay06Yry_w8A6aPHHH1tpeyp=Ns4g@mail.gmail.com>
Subject: Re: [RFC] ARM: sa1100: collie-battery.c: include platform_device.h directly
From: Andrea Adami <andrea.adami@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 12:00 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> Hi Andrea,
>
> On Sat, Feb 16, 2013 at 07:16:00PM +0100, Andrea Adami wrote:
>> Initial try to fix compilation error
>
> Things are a bit more complex...
>
>> linux/include/linux/mfd/mcp.h:22:16: error: field 'attached_device' has incomplete type
>
> You have to add #include <linux/device.h> into mfd/mcp.h. This will add
> struct device and...
>
Bingo.Adding it solves all following errors, no need for further inclusions.

>> linux/include/linux/mfd/mcp.h:48:23: error: field 'drv' has incomplete type
>
> struct device_driver.
>
>> linux/include/linux/mfd/ucb1x00.h:137:17: error: field 'dev' has incomplete type
>
> Same here, the file ucb1x00.h needs #include <linux/device.h>.
>
Seems not needed, mcp.h is included by ucb1x00.h

>> linux/drivers/power/collie_battery.c:290:56: error: unknown type name 'pm_message_t'
>
> #include <linux/pm.h> into collie_battery.c
>
Seems not needed, is included in mcp-sa11x0.c (included by collie_battery.c)

The warning remains, though:
 linux/drivers/power/collie_battery.c:372:2: warning: initialization
from incompatible pointer type [enabled by default]

> Thanks,
>
> Anton
>

Thank you for your attention

Regards

Andrea



Thanks
>> linux/drivers/power/collie_battery.c:371:13: error: 'collie_bat_suspend' undeclared here (not in a function)
>> | make[4]: *** [drivers/power/collie_battery.o] Error 1
>> | make[3]: *** [drivers/power] Error 2
>>
>> As seen in Arnd Bergmann patches on LAKML
>> [PATCH 7/9] ARM defconfigs: add missing inclusions of linux/platform_device.h
>> [PATCH 1/9] ARM: sa1100/assabet: include platform_device.h directly
>>
>> Compilation is still not clean, two warnings:
>> linux/drivers/power/collie_battery.c:372:2: warning: initialization from incompatible pointer type [enabled by default]
>> linux/drivers/power/collie_battery.c:372:2: warning: (near initialization for 'collie_bat_driver.suspend') [enabled by default]
>>
>> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
>> ---
>>  drivers/power/collie_battery.c            |      1 +
>>  drivers/video/logo/logo_linux_clut224.ppm | 232006 ++++++++++++++++++++++++++-
>>  2 files changed, 230404 insertions(+), 1603 deletions(-)
>>
>> diff --git a/drivers/power/collie_battery.c b/drivers/power/collie_battery.c
>> index c58d0e3..52cbab3 100644
>> --- a/drivers/power/collie_battery.c
>> +++ b/drivers/power/collie_battery.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/module.h>
>>  #include <linux/power_supply.h>
>>  #include <linux/delay.h>
>> +#include <linux/platform_device.h>
>
> I don't see anywhere in the driver which would need platform_device.h...
> But pm.h, yes.
>
Sorry, I'm not a kernel developer. It was a desperate try to unbrick build.
I'm just maintaining the layer needed to build Zaurus images using
Yocto toolchain.
Up to now, I could only build a working linux-as-bootloader kernel
(kexecboot) for collie with old 2.6.31+ sources:
userspace is not a problem now but the poor device is suffering some
serious bitrot :/

>>  #include <linux/spinlock.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/gpio.h>
>> --
>> 1.7.12.4

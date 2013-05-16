Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3EPNhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:37:20 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53667 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3EPNhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <201305151516.52389.arnd@arndb.de>
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com>
	<201303181503.49491.arnd@arndb.de>
	<CACmBeS1empYyoaKidgTrYwUFCw447OKndxZjT98TvYfKVWB00A@mail.gmail.com>
	<201305151516.52389.arnd@arndb.de>
Date: Thu, 16 May 2013 15:37:16 +0200
Message-ID: <CACmBeS3JZ8bm6jJbmrKTfmZqshezN6QKdmyPCKdQ2HUwzY7ggA@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2013 15:16, Arnd Bergmann <arnd@arndb.de> wrote:
> The part that I don't understand at all is the "timer0" part. Is that a string
> from the data sheet?

I have next to no data sheets or documentation on the SoC itself. What
I know is from looking at old sources, which suggest there are more
than one timer (the rest were never implemented).

It only needs one for timer_tick? Does it make sense to just call it "timer"?

> Can you provide some more detail why what PMU registers are used here? Is that
> a "Performance Measurement Unit", "Power Management Unit" or something else?
> Are you sure that those registers are only ever needed for GPIO?

It's "Power Management Unit". The MMC driver uses it to read system
clock and write it to clock control, but I suspect it can be removed.
It's code under #ifdef MSD_SUPPORT_GET_CLOCK but I think the else is
perfectly acceptable.
GPIO uses it only to enable or disable pins.

>> diff --git a/arch/arm/mach-moxart/Makefile.boot
>> b/arch/arm/mach-moxart/Makefile.boot
>> new file mode 100644
>> index 0000000..760a0ef
>> --- /dev/null
>> +++ b/arch/arm/mach-moxart/Makefile.boot
>> @@ -0,0 +1,3 @@
>> +   zreladdr-y        += 0x00008000
>> +params_phys-y        := 0x00000100
>> +initrd_phys-y        := 0x00800000
>
> Is this still used?

Looks like this is no longer needed. Boots without it. Removed.

> You can leave out moxart_init() now, it's the default implementation.
> moxart_init_irq, moxart_handle_irq and nr_irqs should be obsolete if
> you did the irqchip driver correctly, same for moxart_timer_init and
> the clocksource driver.
>
> I think the only part remaining here is moxart_restart, but that is
> broken as long as reg_wdt does not get initialized. I think you could
> move that function into the watchdog driver and assign it to
> arm_pm_restart when you add that driver.

All removed. It boots after some additions to clocksource and irqchip.
arm_pm_restart is set in watchdog.


What I haven't commented on should already be fixed @
https://code.google.com/p/linux-3-10-rc1-moxart/

I'll send new patches.

Best regards,
Jonas

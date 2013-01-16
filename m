Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab3APWMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:12:12 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54685 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab3APWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:12:10 -0500
MIME-Version: 1.0
In-Reply-To: <20130116220447.GA20148@rhlx01.hs-esslingen.de>
References: <1358345841-29136-1-git-send-email-fweisbec@gmail.com>
	<20130116220447.GA20148@rhlx01.hs-esslingen.de>
Date: Wed, 16 Jan 2013 23:12:09 +0100
Message-ID: <CAFTL4hzeCGR2ygqqB8mxuVzduVbx7YOOm98EMoxR25x5pFiYHA@mail.gmail.com>
Subject: Re: [GIT PULL] irq_work changes for 3.9
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/16 Andreas Mohr <andi@lisas.de>:
> Hi,
>
>> These three patches are general fixes for irq work. The two first
>> patches fix tight races on global irq work claiming that prevent the irq work
>> subsystem from dropping a work enqueuing attempt because it thinks it's
>> already pending while it may be already executing or executed.
>
> Would that one happen to be one that would fix my system dropping
> dead on sound output (looping the existing buffer ad infinitum)
> every couple idle minutes when using my sound card's
> PulseAudio IRQ-less playback patch (to-be-submitted),
> and which seems to have started (or got quite a bit worse
> so as to let me notice?) once I added my
> "quirks: enable APIC De-Assert Message bit for VIA 8235, too."
> (to-be-submitted) commit?
> (which reduces IRQs from duplicate to single - thereby probably
> reducing the opportunities for the system to notice that work is pending)
>
> Of course a lone kick to the mouse always fixes it...
>
> (-rc2 here)
>
> Hell yeah that does sound like a potential candidate to me.
>
> Andreas Mohr

I doubt it. I don't see a sound driver using struct irq_work:

$git grep -F "struct irq_work" drivers/ sound/

drivers/acpi/apei/ghes.c:static struct irq_work ghes_proc_irq_work;
drivers/acpi/apei/ghes.c:static void ghes_proc_in_irq(struct irq_work *irq_work)
drivers/extcon/extcon-max77693.c:       struct work_struct irq_work;
drivers/extcon/extcon-max8997.c:        struct work_struct irq_work;
drivers/net/ethernet/microchip/enc28j60.c:      struct work_struct irq_work;
drivers/net/wireless/ti/wl1251/wl1251.h:        struct work_struct irq_work;
drivers/staging/iio/trigger/iio-trig-sysfs.c:   struct irq_work work;
drivers/staging/iio/trigger/iio-trig-sysfs.c:static void
iio_sysfs_trigger_work(struct irq_work *work)
drivers/thermal/exynos_thermal.c:       struct work_struct irq_work;

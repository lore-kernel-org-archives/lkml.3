Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3FCIxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:53:00 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:47753 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:52:58 -0400
Date: Mon, 3 Jun 2013 11:52:51 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/6] Make ARM's sched_clock generic + 64 bit friendly
Message-ID: <20130603085251.GQ11798@tarshish>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, Jun 01, 2013 at 11:39:37PM -0700, Stephen Boyd wrote:
> This is mostly a resend of a patch series I sent a little over a month
> ago. I've reordered the patches so that John can pick up the first three
> and get a generic sched_clock layer without having to take the 64 bit
> patches. The last three patches add 64 bit support and move the architected
> timers on ARM64 and ARM to use it.

You can have my

Build-tested-by: Baruch Siach <baruch@tkos.co.il>

for xtensa target, with the dw_apb_timer driver (no real hardware yet).

Thanks for pushing this series.

baruch

> Stephen Boyd (6):
>   ARM: sched_clock: Remove unused needs_suspend member
>   ARM: sched_clock: Return suspended count earlier
>   sched_clock: Make ARM's sched_clock generic for all architectures
>   sched_clock: Add support for >32 bit sched_clock
>   ARM: arch_timer: Move to setup_sched_clock_64()
>   arm64: Move to generic sched_clock infrastructure
> 
>  arch/arm/Kconfig                                   |   1 +
>  arch/arm/common/timer-sp.c                         |   2 +-
>  arch/arm/kernel/Makefile                           |   2 +-
>  arch/arm/kernel/arch_timer.c                       |  16 +--
>  arch/arm/kernel/time.c                             |   4 +-
>  arch/arm/mach-davinci/time.c                       |   2 +-
>  arch/arm/mach-imx/time.c                           |   2 +-
>  arch/arm/mach-integrator/integrator_ap.c           |   2 +-
>  arch/arm/mach-ixp4xx/common.c                      |   2 +-
>  arch/arm/mach-mmp/time.c                           |   2 +-
>  arch/arm/mach-msm/timer.c                          |   2 +-
>  arch/arm/mach-omap1/time.c                         |   2 +-
>  arch/arm/mach-omap2/timer.c                        |   2 +-
>  arch/arm/mach-pxa/time.c                           |   2 +-
>  arch/arm/mach-sa1100/time.c                        |   2 +-
>  arch/arm/mach-u300/timer.c                         |   2 +-
>  arch/arm/plat-iop/time.c                           |   2 +-
>  arch/arm/plat-omap/counter_32k.c                   |   2 +-
>  arch/arm/plat-orion/time.c                         |   2 +-
>  arch/arm/plat-samsung/samsung-time.c               |   2 +-
>  arch/arm/plat-versatile/sched-clock.c              |   2 +-
>  arch/arm64/Kconfig                                 |   1 +
>  arch/arm64/kernel/time.c                           |  11 +-
>  drivers/clocksource/bcm2835_timer.c                |   2 +-
>  drivers/clocksource/clksrc-dbx500-prcmu.c          |   3 +-
>  drivers/clocksource/dw_apb_timer_of.c              |   2 +-
>  drivers/clocksource/mxs_timer.c                    |   2 +-
>  drivers/clocksource/nomadik-mtu.c                  |   2 +-
>  drivers/clocksource/samsung_pwm_timer.c            |   2 +-
>  drivers/clocksource/tegra20_timer.c                |   2 +-
>  drivers/clocksource/time-armada-370-xp.c           |   2 +-
>  drivers/clocksource/timer-marco.c                  |   2 +-
>  drivers/clocksource/timer-prima2.c                 |   2 +-
>  .../include/asm => include/linux}/sched_clock.h    |  14 ++-
>  init/Kconfig                                       |   3 +
>  init/main.c                                        |   2 +
>  kernel/time/Makefile                               |   1 +
>  {arch/arm/kernel => kernel/time}/sched_clock.c     | 114 +++++++++++++++------
>  38 files changed, 132 insertions(+), 92 deletions(-)
>  rename {arch/arm/include/asm => include/linux}/sched_clock.h (62%)
>  rename {arch/arm/kernel => kernel/time}/sched_clock.c (74%)
> 
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

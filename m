Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaALQdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 11:33:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47178 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaALQdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 11:33:22 -0500
Date: Sun, 12 Jan 2014 17:33:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource : new material for 3.14
Message-ID: <20140112163318.GA21054@gmail.com>
References: <52C1479E.80808@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C1479E.80808@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> 
> Hi Thomas and Ingo,
> 
> here is the new material for 3.14. I created a branch for Simon
> Horman as requested [1] where he can pull from and merged it in the
> clockevents/3.14 branch.	
> 
>  * Axel Lin removed an unused structure defining the ids for the bcm
> kona driver
> 
>  * Ezequiel Garcia enabled the timer divider only when the 25MHz
> timer is not used for the armada 370 XP
> 
>  * Jingoo Han removed a pointless platform data initialization for
> the sh_mtu and sh_mtu2
> 
>  * Laurent Pinchart added the clk_prepare/clk_unprepare for sh_cmt
> 
>  * Linus Walleij added an useful warning in clk_of when no clocks
> are found while the old behavior was to silently hang at boot time
> 
>  * Maxime Ripard added the high speed timer drivers for the
> Allwinner SoCs (A10, A13, A20). He increased the rating, shared the
> irq across all available cpus and fixed the clockevent's irq
> initialization for the sun4i
> 
>  * Michael Opdenacker removed the usage of the IRQF_DISABLED for the
> all the timers driver located in drivers/clocksource
> 
>  * Stephen Boyd switched to sched_clock_register for the
> arm_global_timer, cadence_ttc, sun4i and orion timers
> 
> 
> Resolved conflicts:
> 
>  * (31f8ad387) "sun7i: a20: Add support for the High Speed Timers"
> and (428abbb8) "Enable the I2C controllers"
> 
>  * (67905540) "clocksource: Add Allwinner SoCs HS timers driver" and
> (b788beda) "Order Kconfig options alphabetically"
> 
> Thanks and happy new year !
> 
>   -- Daniel
> 
> [1] http://www.spinics.net/lists/linux-sh/msg26645.html
> 
> -------------------------------------------------------------------------
> 
> The following changes since commit 0e6601eee039893a3f6420596ae4588d90d13cbe:
> 
>   Merge branch 'timers/posix-timers-for-tip-v2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks
> into timers/core (2013-12-10 12:32:36 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.linaro.org/people/daniel.lezcano/linux.git clockevents/3.14
> 
> for you to fetch changes up to 98aefbe72ec6015f90fe045ed16c5cf755da283d:
> 
>   Merge branch 'clockevents/for-Simon-3.13-rc2' into
> clockevents/3.14 (2013-12-18 15:14:36 +0100)
> 
> ----------------------------------------------------------------
> 
> Axel Lin (1):
>       clocksource: bcm_kona_timer: Remove unused bcm_timer_ids
> 
> Daniel Lezcano (1):
>       Merge branch 'clockevents/for-Simon-3.13-rc2' into clockevents/3.14
> 
> Ezequiel Garcia (1):
>       clocksource: armada-370-xp: Enable timer divider only when needed
> 
> Jingoo Han (2):
>       clocksource: sh_tmu: Remove unnecessary platform_set_drvdata()
>       clocksource: sh_mtu2: Remove unnecessary platform_set_drvdata()
> 
> Laurent Pinchart (1):
>       clocksource: sh_cmt: Add clk_prepare/unprepare support
> 
> Linus Walleij (1):
>       clocksource: clksrc-of: Warn if no clock sources are found
> 
> Maxime Ripard (7):
>       clockevent: sun4i: Fill the irq field in the clockevent structure
>       clocksource: sun4i: Change CPU mask to cpu_possible_mask
>       clocksource: sun4i: Increase a bit the clock event and sources rating
>       clocksource: Add Allwinner SoCs HS timers driver
>       ARM: sun5i: a10s: Add support for the High Speed Timers
>       ARM: sun5i: a13: Add support for the High Speed Timers
>       ARM: sun7i: a20: Add support for the High Speed Timers
> 
> Michael Opdenacker (3):
>       clocksource: misc drivers: Remove deprecated IRQF_DISABLED
>       clocksource: tegra: Remove deprecated IRQF_DISABLED
>       clocksource: vt8500: Remove deprecated IRQF_DISABLED
> 
> Stephen Boyd (4):
>       clocksource: arm_global_timer: Switch to sched_clock_register()
>       clocksource: cadence_ttc_timer: Switch to sched_clock_register()
>       clocksource: sun4i: Switch to sched_clock_register()
>       clocksource: orion: Switch to sched_clock_register()
> 
>  .../bindings/timer/allwinner,sun5i-a13-hstimer.txt |   22 +++
>  arch/arm/boot/dts/sun5i-a10s.dtsi                  |    7 +
>  arch/arm/boot/dts/sun5i-a13.dtsi                   |    7 +
>  arch/arm/boot/dts/sun7i-a20.dtsi                   |   10 +
>  arch/arm/mach-sunxi/Kconfig                        |    1 +
>  drivers/clocksource/Kconfig                        |    4 +
>  drivers/clocksource/Makefile                       |    1 +
>  drivers/clocksource/arm_global_timer.c             |    4 +-
>  drivers/clocksource/bcm_kona_timer.c               |    6 -
>  drivers/clocksource/cadence_ttc_timer.c            |    7 +-
>  drivers/clocksource/clksrc-of.c                    |    4 +
>  drivers/clocksource/cs5535-clockevt.c              |    2 +-
>  drivers/clocksource/dw_apb_timer.c                 |    3 +-
>  drivers/clocksource/nomadik-mtu.c                  |    2 +-
>  drivers/clocksource/samsung_pwm_timer.c            |    2 +-
>  drivers/clocksource/sh_cmt.c                       |   23 ++-
>  drivers/clocksource/sh_mtu2.c                      |    4 +-
>  drivers/clocksource/sh_tmu.c                       |    4 +-
>  drivers/clocksource/sun4i_timer.c                  |   11 +-
>  drivers/clocksource/tegra20_timer.c                |    2 +-
>  drivers/clocksource/time-armada-370-xp.c           |   18 +-
>  drivers/clocksource/time-orion.c                   |    4 +-
>  drivers/clocksource/timer-sun5i.c                  |  192
> ++++++++++++++++++++
>  drivers/clocksource/vt8500_timer.c                 |    2 +-
>  24 files changed, 295 insertions(+), 47 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
>  create mode 100644 drivers/clocksource/timer-sun5i.c

Pulled into tip:timers/core, thanks Daniel!

Note that there was a conflict in drivers/clocksource/clksrc-of.c, 
caused by interaction with this commit:

  4c4b053235fa clocksource: clksrc-of: Do not drop unheld reference on device node

I've resolved it, but please double check the end result once I've 
pushed it all out.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3GXOo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:44:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57295 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3GXOoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:44:25 -0400
Message-ID: <51EFE845.6010805@codeaurora.org>
Date: Wed, 24 Jul 2013 10:44:21 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Barry Song <Baohua.Song@csr.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jingchang Lu <b35083@freescale.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v4 00/17] 64-bit friendly generic sched_clock()
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 07:21 PM, Stephen Boyd wrote:
> This patchset adds support for 64 bit counters in the generic
> sched_clock code and converts drivers over to use it. Based
> on v3.11-rc1.
> 
> Changes since v3:
>  * Move to use seqcount to fix issues with 64-bit cyc counters
>  * Move to hrtimer to fix underflow/overflow errors in wraparound
>    calculation
>  * Use of 1 hour in clocks_calc_mult_shift
>  * Converted over drivers in drivers/clocksource
> 
> Stephen Boyd (17):
>   clocksource: Extract max nsec calculation into separate function
>   sched_clock: Use seqcount instead of rolling our own
>   sched_clock: Use an hrtimer instead of timer
>   sched_clock: Add support for >32 bit sched_clock
>   arch_timer: Move to generic sched_clock framework
>   sched_clock: Remove sched_clock_func() hook
>   clocksource: bcm2835: Switch to sched_clock_register()
>   ocksource: dbx500-prcmu: Switch to sched_clock_register()
>   clocksource: dw_apb_timer_of: Switch to sched_clock_register()
>   clocksource: mxs_timer: Switch to sched_clock_register()
>   clocksource: nomadik: Switch to sched_clock_register()
>   clocksource: samsung_pwm_timer: Switch to sched_clock_register()
>   clocksource: tegra: Switch to sched_clock_register()
>   clocksource: time-armada-370-xp: Switch to sched_clock_register()
>   clocksource: sirf: Switch to sched_clock_register() and use 64 bits
>   clocksource: vf_pit_timer: Switch to sched_clock_register()
>   sched_clock: Deprecate setup_sched_clock()
> 
>  arch/arm/kernel/arch_timer.c              |  14 ----
>  arch/arm64/Kconfig                        |   1 +
>  arch/arm64/kernel/time.c                  |  10 ---
>  drivers/clocksource/arm_arch_timer.c      |   4 ++
>  drivers/clocksource/bcm2835_timer.c       |   4 +-
>  drivers/clocksource/clksrc-dbx500-prcmu.c |   5 +-
>  drivers/clocksource/dw_apb_timer_of.c     |   4 +-
>  drivers/clocksource/mxs_timer.c           |   4 +-
>  drivers/clocksource/nomadik-mtu.c         |   4 +-
>  drivers/clocksource/samsung_pwm_timer.c   |   4 +-
>  drivers/clocksource/tegra20_timer.c       |   4 +-
>  drivers/clocksource/time-armada-370-xp.c  |   4 +-
>  drivers/clocksource/timer-prima2.c        |   6 +-
>  drivers/clocksource/vf_pit_timer.c        |   4 +-
>  include/linux/clocksource.h               |   2 +
>  include/linux/sched_clock.h               |   7 +-
>  kernel/time/clocksource.c                 |  45 ++++++++-----
>  kernel/time/sched_clock.c                 | 105 +++++++++++++++---------------
>  18 files changed, 116 insertions(+), 115 deletions(-)
> 

I ran 32-bit and 64-bit kernels with these patches on the Versatile Express
software model and things looked fine, so for the applicable patches,

Tested-by: Christopher Covington <cov@codeaurora.org>

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

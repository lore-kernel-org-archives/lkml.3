Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3FCHMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:12:47 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:59252 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:12:40 -0400
Date: Mon, 3 Jun 2013 10:12:35 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 3/6] sched_clock: Make ARM's sched_clock generic for
 all architectures
Message-ID: <20130603071235.GO11798@tarshish>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
 <1370155183-31421-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370155183-31421-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, Jun 01, 2013 at 11:39:40PM -0700, Stephen Boyd wrote:
> Nothing about the sched_clock implementation in the ARM port is
> specific to the architecture. Generalize the code so that other
> architectures can use it by selecting GENERIC_SCHED_CLOCK.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/Kconfig                                      | 1 +
>  arch/arm/common/timer-sp.c                            | 2 +-
>  arch/arm/kernel/Makefile                              | 2 +-
>  arch/arm/kernel/arch_timer.c                          | 2 +-
>  arch/arm/kernel/time.c                                | 4 +---
>  arch/arm/mach-davinci/time.c                          | 2 +-
>  arch/arm/mach-imx/time.c                              | 2 +-
>  arch/arm/mach-integrator/integrator_ap.c              | 2 +-
>  arch/arm/mach-ixp4xx/common.c                         | 2 +-
>  arch/arm/mach-mmp/time.c                              | 2 +-
>  arch/arm/mach-msm/timer.c                             | 2 +-
>  arch/arm/mach-omap1/time.c                            | 2 +-
>  arch/arm/mach-omap2/timer.c                           | 2 +-
>  arch/arm/mach-pxa/time.c                              | 2 +-
>  arch/arm/mach-sa1100/time.c                           | 2 +-
>  arch/arm/mach-u300/timer.c                            | 2 +-
>  arch/arm/plat-iop/time.c                              | 2 +-
>  arch/arm/plat-omap/counter_32k.c                      | 2 +-
>  arch/arm/plat-orion/time.c                            | 2 +-
>  arch/arm/plat-samsung/samsung-time.c                  | 2 +-
>  arch/arm/plat-versatile/sched-clock.c                 | 2 +-
>  drivers/clocksource/bcm2835_timer.c                   | 2 +-
>  drivers/clocksource/clksrc-dbx500-prcmu.c             | 3 +--
>  drivers/clocksource/dw_apb_timer_of.c                 | 2 +-
>  drivers/clocksource/mxs_timer.c                       | 2 +-
>  drivers/clocksource/nomadik-mtu.c                     | 2 +-
>  drivers/clocksource/samsung_pwm_timer.c               | 2 +-
>  drivers/clocksource/tegra20_timer.c                   | 2 +-
>  drivers/clocksource/time-armada-370-xp.c              | 2 +-
>  drivers/clocksource/timer-marco.c                     | 2 +-
>  drivers/clocksource/timer-prima2.c                    | 2 +-
>  {arch/arm/include/asm => include/linux}/sched_clock.h | 9 +++++++--

Shouldn't we just merge this header into the existing linux/sched.h?

baruch

>  init/Kconfig                                          | 3 +++
>  init/main.c                                           | 2 ++
>  kernel/time/Makefile                                  | 1 +
>  {arch/arm/kernel => kernel/time}/sched_clock.c        | 3 +--
>  36 files changed, 45 insertions(+), 37 deletions(-)
>  rename {arch/arm/include/asm => include/linux}/sched_clock.h (75%)
>  rename {arch/arm/kernel => kernel/time}/sched_clock.c (99%)

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

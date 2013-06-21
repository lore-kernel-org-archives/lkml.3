Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422930Ab3FUPqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:46:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61860 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3FUPqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:46:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 3/6] sched_clock: Make ARM's sched_clock generic for all architectures
Date: Fri, 21 Jun 2013 17:45:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <1370155183-31421-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1370155183-31421-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306211745.57528.arnd@arndb.de>
X-Provags-ID: V02:K0:cwNKCkN3JtLwJNouV22IVDfaQosr+66sSkPAAB56D9A
 Fw3xNo+iUqIc01gT7Sv0XgZ52w5kWjASr8olKudKTizS/BDaK2
 iieDwt/gIE1RrhIjej5YpNvcnldDlkuaWTWZfWSkrSYbDvVXSu
 96pZtdk0p9r+8nrGo666Tsgx9XNqw+p2wTvndjsXpJZc13ETlL
 OPFOfcBPlqyhXOKmkOM8N4bxihWH65q7z8Jab8FW8e36e/p7FN
 n0ysPyPo7lw+OCwgz//+FMVswBqmzNeppMfI0Dw5gp4navMjdp
 Fyod+IO5nGm/+Kb52ewNE/s6Q3pgYGsYL2KBfg2gSVegn7oFN/
 n0//FKD0OwQCZ5MVcnFQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 June 2013, Stephen Boyd wrote:
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
>  init/Kconfig                                          | 3 +++
>  init/main.c                                           | 2 ++
>  kernel/time/Makefile                                  | 1 +
>  {arch/arm/kernel => kernel/time}/sched_clock.c        | 3 +--

This causes build failures when doing a simple merge with the arm-soc
tree:

==> build/clps711x_defconfig/faillog <==
/git/arm-soc/arch/arm/mach-clps711x/common.c:37:29: fatal error: asm/sched_clock.h: No such file or directory
 #include <asm/sched_clock.h>
                             ^
==> build/imx_v6_v7_defconfig/faillog <==
/git/arm-soc/drivers/clocksource/vf_pit_timer.c:15:29: fatal error: asm/sched_clock.h: No such file or directory
 #include <asm/sched_clock.h>

How about adding back a temporary arch/arm/include/asm/sched_clock.h
that only contains "#include <linux/sched_clock.h>" so we can change
those two files after the merge and still get a bisectible history?

	Arnd

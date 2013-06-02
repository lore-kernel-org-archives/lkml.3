Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3FBGjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:39:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35532 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3FBGjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:39:46 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 0/6] Make ARM's sched_clock generic + 64 bit friendly
Date: Sat,  1 Jun 2013 23:39:37 -0700
Message-Id: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly a resend of a patch series I sent a little over a month
ago. I've reordered the patches so that John can pick up the first three
and get a generic sched_clock layer without having to take the 64 bit
patches. The last three patches add 64 bit support and move the architected
timers on ARM64 and ARM to use it.

Stephen Boyd (6):
  ARM: sched_clock: Remove unused needs_suspend member
  ARM: sched_clock: Return suspended count earlier
  sched_clock: Make ARM's sched_clock generic for all architectures
  sched_clock: Add support for >32 bit sched_clock
  ARM: arch_timer: Move to setup_sched_clock_64()
  arm64: Move to generic sched_clock infrastructure

 arch/arm/Kconfig                                   |   1 +
 arch/arm/common/timer-sp.c                         |   2 +-
 arch/arm/kernel/Makefile                           |   2 +-
 arch/arm/kernel/arch_timer.c                       |  16 +--
 arch/arm/kernel/time.c                             |   4 +-
 arch/arm/mach-davinci/time.c                       |   2 +-
 arch/arm/mach-imx/time.c                           |   2 +-
 arch/arm/mach-integrator/integrator_ap.c           |   2 +-
 arch/arm/mach-ixp4xx/common.c                      |   2 +-
 arch/arm/mach-mmp/time.c                           |   2 +-
 arch/arm/mach-msm/timer.c                          |   2 +-
 arch/arm/mach-omap1/time.c                         |   2 +-
 arch/arm/mach-omap2/timer.c                        |   2 +-
 arch/arm/mach-pxa/time.c                           |   2 +-
 arch/arm/mach-sa1100/time.c                        |   2 +-
 arch/arm/mach-u300/timer.c                         |   2 +-
 arch/arm/plat-iop/time.c                           |   2 +-
 arch/arm/plat-omap/counter_32k.c                   |   2 +-
 arch/arm/plat-orion/time.c                         |   2 +-
 arch/arm/plat-samsung/samsung-time.c               |   2 +-
 arch/arm/plat-versatile/sched-clock.c              |   2 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/kernel/time.c                           |  11 +-
 drivers/clocksource/bcm2835_timer.c                |   2 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c          |   3 +-
 drivers/clocksource/dw_apb_timer_of.c              |   2 +-
 drivers/clocksource/mxs_timer.c                    |   2 +-
 drivers/clocksource/nomadik-mtu.c                  |   2 +-
 drivers/clocksource/samsung_pwm_timer.c            |   2 +-
 drivers/clocksource/tegra20_timer.c                |   2 +-
 drivers/clocksource/time-armada-370-xp.c           |   2 +-
 drivers/clocksource/timer-marco.c                  |   2 +-
 drivers/clocksource/timer-prima2.c                 |   2 +-
 .../include/asm => include/linux}/sched_clock.h    |  14 ++-
 init/Kconfig                                       |   3 +
 init/main.c                                        |   2 +
 kernel/time/Makefile                               |   1 +
 {arch/arm/kernel => kernel/time}/sched_clock.c     | 114 +++++++++++++++------
 38 files changed, 132 insertions(+), 92 deletions(-)
 rename {arch/arm/include/asm => include/linux}/sched_clock.h (62%)
 rename {arch/arm/kernel => kernel/time}/sched_clock.c (74%)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


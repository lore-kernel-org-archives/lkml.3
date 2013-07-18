Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639Ab3GRXVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:21:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58670 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464Ab3GRXVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:21:34 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Barry Song <Baohua.Song@csr.com>,
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
Subject: [PATCH v4 00/17] 64-bit friendly generic sched_clock()
Date: Thu, 18 Jul 2013 16:21:13 -0700
Message-Id: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for 64 bit counters in the generic
sched_clock code and converts drivers over to use it. Based
on v3.11-rc1.

Changes since v3:
 * Move to use seqcount to fix issues with 64-bit cyc counters
 * Move to hrtimer to fix underflow/overflow errors in wraparound
   calculation
 * Use of 1 hour in clocks_calc_mult_shift
 * Converted over drivers in drivers/clocksource

Stephen Boyd (17):
  clocksource: Extract max nsec calculation into separate function
  sched_clock: Use seqcount instead of rolling our own
  sched_clock: Use an hrtimer instead of timer
  sched_clock: Add support for >32 bit sched_clock
  arch_timer: Move to generic sched_clock framework
  sched_clock: Remove sched_clock_func() hook
  clocksource: bcm2835: Switch to sched_clock_register()
  ocksource: dbx500-prcmu: Switch to sched_clock_register()
  clocksource: dw_apb_timer_of: Switch to sched_clock_register()
  clocksource: mxs_timer: Switch to sched_clock_register()
  clocksource: nomadik: Switch to sched_clock_register()
  clocksource: samsung_pwm_timer: Switch to sched_clock_register()
  clocksource: tegra: Switch to sched_clock_register()
  clocksource: time-armada-370-xp: Switch to sched_clock_register()
  clocksource: sirf: Switch to sched_clock_register() and use 64 bits
  clocksource: vf_pit_timer: Switch to sched_clock_register()
  sched_clock: Deprecate setup_sched_clock()

 arch/arm/kernel/arch_timer.c              |  14 ----
 arch/arm64/Kconfig                        |   1 +
 arch/arm64/kernel/time.c                  |  10 ---
 drivers/clocksource/arm_arch_timer.c      |   4 ++
 drivers/clocksource/bcm2835_timer.c       |   4 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c |   5 +-
 drivers/clocksource/dw_apb_timer_of.c     |   4 +-
 drivers/clocksource/mxs_timer.c           |   4 +-
 drivers/clocksource/nomadik-mtu.c         |   4 +-
 drivers/clocksource/samsung_pwm_timer.c   |   4 +-
 drivers/clocksource/tegra20_timer.c       |   4 +-
 drivers/clocksource/time-armada-370-xp.c  |   4 +-
 drivers/clocksource/timer-prima2.c        |   6 +-
 drivers/clocksource/vf_pit_timer.c        |   4 +-
 include/linux/clocksource.h               |   2 +
 include/linux/sched_clock.h               |   7 +-
 kernel/time/clocksource.c                 |  45 ++++++++-----
 kernel/time/sched_clock.c                 | 105 +++++++++++++++---------------
 18 files changed, 116 insertions(+), 115 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3JBKuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:50:05 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46942 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3JBKuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:50:01 -0400
Message-ID: <524BFA57.6070506@linaro.org>
Date: Wed, 02 Oct 2013 12:49:59 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL - resend ] clocksource: new material for 3.13
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Ingo

this pull request has the following content:

  - Soren added FEAT_PERCPU to a clock device when it is local per cpu.
This feature prevents the clock framework to choose a per cpu timer as
a broadcast timer. This problem arised when the ARM global timer is
used when switching to the broadcast timer which is the case now on 
Xillinx with its cpuidle driver.

  - Stephen extended the generic sched_clock code to support 64bit
counters and removes the setup_sched_clock deprecation, as that causes
lots of warnings since there's still users in the arch/arm tree. He 
added also the CLOCK_SOURCE_SUSPEND_NONSTOP flag on the architected 
timer as they continue counting during suspend.

  - Uwe added some missing __init sections and consolidated the code by 
moving the of_node_put call from the drivers to the function 
clocksource_of_init.

Sorry for the last crappy pull request, I hope all is good now.

Thanks !

   -- Daniel

ps: Is it possible to update timers/core to v3.12-rc2/3 ?

The following changes since commit 389e067032fbb96e439abafae848dd447e4cafb4:

   Merge branch 'fortglx/3.12/time' into fortglx/3.13/time (2013-09-16 
18:54:07 -0700)

are available in the git repository at:


   git://git.linaro.org/people/dlezcano/linux.git clockevents/3.13

for you to fetch changes up to 4fbcdc813fb9c0324fcff4c75414e717569d965e:

   clocksource: arm_arch_timer: Use clocksource for suspend timekeeping 
(2013-10-02 11:43:17 +0200)

----------------------------------------------------------------
John Stultz (1):
       Merge remote-tracking branch 'tip/timers/core' into 
fordlezcano/3.13/sched-clock64-conversion

Soren Brinkmann (4):
       clockchips: Add FEAT_PERCPU clockevent flag
       clocksource/arm_global_timer: Set FEAT_PERCPU flag
       tick: broadcast: Deny per-cpu clockevents from being broadcast 
sources
       arm: zynq: Enable arm_global_timer

Stephen Boyd (11):
       clocksource: bcm2835: Switch to sched_clock_register()
       clocksource: dbx500-prcmu: Switch to sched_clock_register()
       clocksource: dw_apb_timer_of: Switch to sched_clock_register()
       clocksource: mxs_timer: Switch to sched_clock_register()
       clocksource: nomadik: Switch to sched_clock_register()
       clocksource: samsung_pwm_timer: Switch to sched_clock_register()
       clocksource: tegra: Switch to sched_clock_register()
       clocksource: time-armada-370-xp: Switch to sched_clock_register()
       clocksource: sirf: Switch to sched_clock_register() and use 64 bits
       clocksource: vf_pit_timer: Switch to sched_clock_register()
       clocksource: arm_arch_timer: Use clocksource for suspend timekeeping

Uwe Kleine-König (2):
       clocksource: Put nodes passed to CLOCKSOURCE_OF_DECLARE callbacks 
centrally
       clocksource: dw_apb_timer_of: Mark a few more functions as __init

  arch/arm/boot/dts/zynq-7000.dtsi          |    8 ++++++++
  arch/arm/mach-msm/timer.c                 |    1 -
  arch/arm/mach-zynq/Kconfig                |    1 +
  drivers/clocksource/arm_arch_timer.c      |    2 +-
  drivers/clocksource/arm_global_timer.c    |    3 ++-
  drivers/clocksource/bcm2835_timer.c       |    4 ++--
  drivers/clocksource/clksrc-dbx500-prcmu.c |    5 ++---
  drivers/clocksource/clksrc-of.c           |    1 +
  drivers/clocksource/dw_apb_timer_of.c     |   16 +++++++---------
  drivers/clocksource/mxs_timer.c           |    4 ++--
  drivers/clocksource/nomadik-mtu.c         |    4 ++--
  drivers/clocksource/samsung_pwm_timer.c   |    4 ++--
  drivers/clocksource/tegra20_timer.c       |    8 ++------
  drivers/clocksource/time-armada-370-xp.c  |    4 ++--
  drivers/clocksource/timer-prima2.c        |    6 +++---
  drivers/clocksource/vf_pit_timer.c        |    4 ++--
  drivers/clocksource/vt8500_timer.c        |    2 --
  include/linux/clockchips.h                |    1 +
  kernel/time/tick-broadcast.c              |    1 +
  19 files changed, 41 insertions(+), 38 deletions(-)

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


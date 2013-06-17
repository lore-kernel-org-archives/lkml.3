Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FQShs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:37:48 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35110 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:37:47 -0400
Message-ID: <51BF5779.9010104@linaro.org>
Date: Mon, 17 Jun 2013 11:37:45 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Timekeeping changes for 3.11 (part 2)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Here's the second chunk of changes I have pending for 3.11. Its 
mostly the changes to make arm's sched_clock implementation generic.

Let me know if you have any objection.

thanks
-john



The following changes since commit 762cf9695d714d312ef7369bed1b9f9467c9e64e:

   Merge branch 'timers/clockevents' of 
git://git.linaro.org/people/dlezcano/clockevents into timers/core 
(2013-06-08 22:58:27 +0200)

are available in the git repository at:


   git://git.linaro.org/people/jstultz/linux.git fortglx/3.11/time

for you to fetch changes up to 38ff87f77af0b5a93fc8581cff1d6e5692ab8970:

   sched_clock: Make ARM's sched_clock generic for all architectures 
(2013-06-12 14:02:13 -0700)

----------------------------------------------------------------
Marcus Gelderie (1):
       alarmtimer: Export symbols of functions declared in 
linux/alarmtimer.h

Stephen Boyd (3):
       ARM: sched_clock: Remove unused needs_suspend member
       ARM: sched_clock: Return suspended count earlier
       sched_clock: Make ARM's sched_clock generic for all architectures

  arch/arm/Kconfig                                      |  1 +
  arch/arm/common/timer-sp.c                            |  2 +-
  arch/arm/kernel/Makefile                              |  2 +-
  arch/arm/kernel/arch_timer.c                          |  2 +-
  arch/arm/kernel/time.c                                |  4 +---
  arch/arm/mach-davinci/time.c                          |  2 +-
  arch/arm/mach-imx/time.c                              |  2 +-
  arch/arm/mach-integrator/integrator_ap.c              |  2 +-
  arch/arm/mach-ixp4xx/common.c                         |  2 +-
  arch/arm/mach-mmp/time.c                              |  2 +-
  arch/arm/mach-msm/timer.c                             |  2 +-
  arch/arm/mach-omap1/time.c                            |  2 +-
  arch/arm/mach-omap2/timer.c                           |  2 +-
  arch/arm/mach-pxa/time.c                              |  2 +-
  arch/arm/mach-sa1100/time.c                           |  2 +-
  arch/arm/mach-u300/timer.c                            |  2 +-
  arch/arm/plat-iop/time.c                              |  2 +-
  arch/arm/plat-omap/counter_32k.c                      |  2 +-
  arch/arm/plat-orion/time.c                            |  2 +-
  arch/arm/plat-samsung/samsung-time.c                  |  2 +-
  arch/arm/plat-versatile/sched-clock.c                 |  2 +-
  drivers/clocksource/bcm2835_timer.c                   |  2 +-
  drivers/clocksource/clksrc-dbx500-prcmu.c             |  3 +--
  drivers/clocksource/dw_apb_timer_of.c                 |  3 +--
  drivers/clocksource/mxs_timer.c                       |  2 +-
  drivers/clocksource/nomadik-mtu.c                     |  2 +-
  drivers/clocksource/samsung_pwm_timer.c               |  2 +-
  drivers/clocksource/tegra20_timer.c                   |  2 +-
  drivers/clocksource/time-armada-370-xp.c              |  2 +-
  drivers/clocksource/timer-marco.c                     |  2 +-
  drivers/clocksource/timer-prima2.c                    |  2 +-
  {arch/arm/include/asm => include/linux}/sched_clock.h |  9 +++++++--
  init/Kconfig                                          |  3 +++
  init/main.c                                           |  2 ++
  kernel/time/Makefile                                  |  1 +
  kernel/time/alarmtimer.c                              | 10 +++++++++-
  {arch/arm/kernel => kernel/time}/sched_clock.c        | 10 ++++------
  37 files changed, 57 insertions(+), 43 deletions(-)
  rename {arch/arm/include/asm => include/linux}/sched_clock.h (75%)
  rename {arch/arm/kernel => kernel/time}/sched_clock.c (99%)

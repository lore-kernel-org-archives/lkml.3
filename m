Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3IZT0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:26:04 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44087 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3IZT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:26:01 -0400
Message-ID: <52448A46.9020207@linaro.org>
Date: Thu, 26 Sep 2013 12:25:58 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL v2] drivers/clocksource: sched_clock_register() conversion
 for 3.13 (via tip/timers/core)
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Daniel,
    Here's the sched_clock_register conversion that Stephen did earlier
this summer, as part of extending the generic sched_clock code to
support 64bit counters. Unfortunately the prereqs for this series missed
getting into tip/timers/core for 3.12, so I never sent out this pull
request. But now that the prereqs are in tip/timers/core for 3.13, I've
merge it up and I wanted to go ahead and send this out.

This v2 pull request removes the setup_sched_clock deprecation, as that
causes lots of warnings since there's still users in the arch/arm tree.

Let me know if you have any issues or concerns.

thanks
-john


The following changes since commit 389e067032fbb96e439abafae848dd447e4cafb4:

  Merge branch 'fortglx/3.12/time' into fortglx/3.13/time (2013-09-16 18:54:07 -0700)

are available in the git repository at:


  git://git.linaro.org/people/jstultz/linux.git fordlezcano/3.13/sched-clock64-conversion

for you to fetch changes up to 17deb9c2db01c7813611291d251d8c7dbdfd3c9d:

  Merge remote-tracking branch 'tip/timers/core' into fordlezcano/3.13/sched-clock64-conversion (2013-09-26 12:05:54 -0700)

----------------------------------------------------------------

John Stultz (1):
      Merge remote-tracking branch 'tip/timers/core' into fordlezcano/3.13/sched-clock64-conversion

Stephen Boyd (10):
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

 drivers/clocksource/bcm2835_timer.c       | 4 ++--
 drivers/clocksource/clksrc-dbx500-prcmu.c | 5 ++---
 drivers/clocksource/dw_apb_timer_of.c     | 4 ++--
 drivers/clocksource/mxs_timer.c           | 4 ++--
 drivers/clocksource/nomadik-mtu.c         | 4 ++--
 drivers/clocksource/samsung_pwm_timer.c   | 4 ++--
 drivers/clocksource/tegra20_timer.c       | 4 ++--
 drivers/clocksource/time-armada-370-xp.c  | 4 ++--
 drivers/clocksource/timer-prima2.c        | 6 +++---
 drivers/clocksource/vf_pit_timer.c        | 4 ++--
 10 files changed, 21 insertions(+), 22 deletions(-)


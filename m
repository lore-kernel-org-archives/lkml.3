Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab3JJEJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:09:09 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34762 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3JJEJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:09:07 -0400
Message-ID: <5256285F.7060705@linaro.org>
Date: Wed, 09 Oct 2013 21:09:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] More timekeeping items for 3.13
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
    Just wanted to send along the few minor time related items I've got
left for 3.13.

* Small cleanup in the clocksource code.

* Fix for rtc-pl031 to let it work with alarmtimers

* Move arm64 to using the generic sched_clock framework & resulting
cleanup in the generic sched_clock code.


thanks
-john


The following changes since commit 389e067032fbb96e439abafae848dd447e4cafb4:

  Merge branch 'fortglx/3.12/time' into fortglx/3.13/time (2013-09-16
18:54:07 -0700)

are available in the git repository at:


  git://git.linaro.org/people/jstultz/linux.git fortglx/3.13/time

for you to fetch changes up to b4042ceaabbd913bc5b397ddd1e396eeb312d72f:

  sched_clock: Remove sched_clock_func() hook (2013-10-09 16:54:39 -0700)

----------------------------------------------------------------
Elad Wexler (1):
      clocksource: Fix 'ret' data type of sysfs_override_clocksource()
and sysfs_unbind_clocksource()

John Stultz (1):
      rtc: rtc-pl031: Set wakeup flag prior to registering rtcdev

Stephen Boyd (2):
      arch_timer: Move to generic sched_clock framework
      sched_clock: Remove sched_clock_func() hook

 arch/arm/kernel/arch_timer.c         | 14 --------------
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/kernel/time.c             | 10 ----------
 drivers/clocksource/arm_arch_timer.c | 10 ++++++++++
 drivers/rtc/rtc-pl031.c              |  3 +--
 include/linux/sched_clock.h          |  2 --
 kernel/time/clocksource.c            |  4 ++--
 kernel/time/sched_clock.c            |  9 +--------
 8 files changed, 15 insertions(+), 38 deletions(-)

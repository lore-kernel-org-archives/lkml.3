Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3C2R5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:57:36 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51119 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3C2R5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:57:34 -0400
Message-ID: <5155D60C.1060106@linaro.org>
Date: Fri, 29 Mar 2013 10:57:32 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Timekeeping changes for 3.10
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Just wanted to send you the first chunk of work I'd like you to 
queue for 3.10. I still would like to get the ntp locking and shadow 
time changes in, but wanted to get this chunk queued first.

Let me know if you have any comments or objections.

thanks
-john



The following changes since commit 7c6baa304b841673d3a55ea4fcf9a5cbf7a1674b:

   Merge branch 'perf-urgent-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-03-11 
07:54:29 -0700)

are available in the git repository at:


   git://git.linaro.org/people/jstultz/linux.git fortglx/3.10/time

for you to fetch changes up to 8011657b9e63cb2e914b9a0f75233b910c1854cb:

   ARM: bcm281xx: Add timer driver (driver portion) (2013-03-28 10:58:55 
-0700)

----------------------------------------------------------------
Christian Daudt (1):
       ARM: bcm281xx: Add timer driver (driver portion)

Dong Zhu (1):
       timekeeping: Avoid adjust kernel time once hwclock kept in UTC time

Feng Tang (4):
       x86: Add cpu capability flag X86_FEATURE_NONSTOP_TSC_S3
       clocksource: Add new feature flag CLOCK_SOURCE_SUSPEND_NONSTOP
       x86: tsc: Add support for new S3_NONSTOP feature
       timekeeping: utilize the suspend-nonstop clocksource to count 
suspended time

Fengguang Wu (1):
       timekeeping: __timekeeping_set_tai_offset can be static

John Stultz (4):
       timekeeping: Use inject_offset in warp_clock
       timekeeping: Move TAI managment into timekeeping core from ntp
       timekeeping: Add CLOCK_TAI clockid
       hrtimer: Add hrtimer support for CLOCK_TAI

Prarit Bhargava (1):
       x86: Do full rtc synchronization with ntp

Thomas Gleixner (4):
       timekeeping: Calc stuff once
       timekeeping: Make jiffies_lock internal
       timekeeping: Move lock out of timekeeper struct
       timekeeping: Split timekeeper_lock into lock and seqcount

  arch/arm/mach-bcm/Kconfig            |    1 +
  arch/arm/mach-bcm/board_bcm.c        |    7 +-
  arch/x86/Kconfig                     |    1 +
  arch/x86/include/asm/cpufeature.h    |    1 +
  arch/x86/kernel/cpu/intel.c          |   12 ++
  arch/x86/kernel/rtc.c                |   69 ++-------
  arch/x86/kernel/tsc.c                |    6 +-
  arch/x86/platform/efi/efi.c          |   24 ++-
  arch/x86/platform/mrst/vrtc.c        |   44 +++---
  drivers/clocksource/Makefile         |    1 +
  drivers/clocksource/bcm_kona_timer.c |  211 +++++++++++++++++++++++++
  include/linux/clocksource.h          |    1 +
  include/linux/hrtimer.h              |    5 +-
  include/linux/jiffies.h              |    1 -
  include/linux/time.h                 |    3 +
  include/linux/timekeeper_internal.h  |    7 +-
  include/uapi/linux/time.h            |    6 +-
  kernel/hrtimer.c                     |   14 +-
  kernel/posix-timers.c                |   16 ++
  kernel/time.c                        |   11 +-
  kernel/time/ntp.c                    |   18 ++-
  kernel/time/tick-internal.h          |    2 +
  kernel/time/timekeeping.c            |  282 
++++++++++++++++++++++++++--------
  23 files changed, 566 insertions(+), 177 deletions(-)
  create mode 100644 drivers/clocksource/bcm_kona_timer.c

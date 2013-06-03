Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148Ab3FCW7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:59:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38389 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3FCW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:59:34 -0400
Message-ID: <51AD1FD3.4040907@linaro.org>
Date: Mon, 03 Jun 2013 15:59:31 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>, Colin Cross <ccross@android.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Liu Ying <Ying.Liu@freescale.com>, Pavel Machek <pavel@ucw.cz>,
        Todd Poynor <toddpoynor@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [GIT PULL] Time changes for 3.11 (first chunk)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas (sorry for the dup, forgot to cc everyone before originally 
sending),
     Just wanted to send along my current queue for 3.11 for 
tip/timers/core. I've still got a few more items to queue in my inbox, 
but wanted to get these out there in the meantime for testing in -next.

Let me know if you have any objections.

thanks
-john

The following changes since commit 1eaff67266b6b6c97bbd33cf2c20577822836413:

   clocksource: Implement clocksource_select_fallback() for 
CONFIG_ARCH_USES_GETTIMEOFFSET=y (2013-05-28 09:48:46 +0200)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.11/time

for you to fetch changes up to ce0b098981544d9f4e910ea48f3af3e726ca6d6b:

   x86: Fix vrtc_get_time/set_mmss to use new timespec interface 
(2013-05-29 12:57:35 -0700)

----------------------------------------------------------------
Baruch Siach (1):
       clocksource: dw_apb: Remove unused header

Colin Cross (1):
       power: Add option to log time spent in suspend

Daniel Borkmann (1):
       ktime: Add __must_check prefix to ktime_to_timespec_cond

David Vrabel (1):
       x86: Increase precision of x86_platform.get/set_wallclock()

John Stultz (1):
       x86: Fix vrtc_get_time/set_mmss to use new timespec interface

Liu Ying (1):
       ktime: Use macro NSEC_PER_USEC where appropriate

Pavel Machek (1):
       dw_apb_timer_of.c: Remove parts that were picoxcell-specific

Todd Poynor (2):
       alarmtimer: Add functions for timerfd support
       timerfd: Add alarm timers

  arch/arm/mach-picoxcell/common.h      |   2 -
  arch/x86/include/asm/mc146818rtc.h    |   4 +-
  arch/x86/include/asm/mrst-vrtc.h      |   4 +-
  arch/x86/include/asm/x86_init.h       |   6 +-
  arch/x86/kernel/kvmclock.c            |   9 +--
  arch/x86/kernel/rtc.c                 |  17 ++---
  arch/x86/lguest/boot.c                |   4 +-
  arch/x86/platform/efi/efi.c           |  10 +--
  arch/x86/platform/mrst/vrtc.c         |  11 +--
  arch/x86/xen/time.c                   |  19 ++---
  drivers/clocksource/dw_apb_timer.c    |   6 --
  drivers/clocksource/dw_apb_timer_of.c |  53 ++++++--------
  fs/timerfd.c                          | 131 
++++++++++++++++++++++++++++------
  include/linux/alarmtimer.h            |   4 ++
  include/linux/dw_apb_timer.h          |   6 ++
  include/linux/efi.h                   |   4 +-
  include/linux/ktime.h                 |  10 +--
  kernel/time/Makefile                  |   1 +
  kernel/time/alarmtimer.c              |  39 +++++++++-
  kernel/time/timekeeping.c             |   2 +
  kernel/time/timekeeping_debug.c       |  72 +++++++++++++++++++
  kernel/time/timekeeping_internal.h    |  14 ++++
  22 files changed, 314 insertions(+), 114 deletions(-)
  create mode 100644 kernel/time/timekeeping_debug.c
  create mode 100644 kernel/time/timekeeping_internal.h

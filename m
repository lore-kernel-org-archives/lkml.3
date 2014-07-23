Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899AbaGWWSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:18:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37290 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933831AbaGWWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:18:03 -0400
Message-ID: <53D03499.9030901@linaro.org>
Date: Wed, 23 Jul 2014 15:18:01 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Riley <davidriley@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [GIT PULL] Big timekeeping changes for 3.17
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,

  Here is my current 3.17 queue. Its quite large. The main components are:

1) udelay test module / script (David Riley)

2) Updating core timekeeping/ktime infrastructure to be 2038 safe (Me w/
tweaks from tglx)

3) Lots of timespec/ktime_t cleanups in both the core code and by
in-kernel users (tglx)

4) Optimizing the timekeeping data structures for cache layout (tglx)

5) NMI safe accessor to clock monotonic (tglx w/ improvements from
Mathieu Desnoyers)

6) Improved NOHZ freq steering (Me w/ inspiration from Miroslav)

7) New general clocksource/clockevents/sched_clock documentation (Linus
Walleij)


I've run testing w/ x86_64, i386, arm and arm64. Thomas has also done
quite a bit of testing as well (including ppc, ppc64, mips and mips64).

There's a few more things that have been lingering in my inbox that I
have to send as well, but this chunk likely needs the most time in -next
for testing.

Let me know if you have any issues or problems with this set.

thanks
-john


The following changes since commit 1af447bd8cbfb808a320885d214555fb2d32e6e6:

  Merge branch 'clockevents/3.17' of
git://git.linaro.org/people/daniel.lezcano/linux into timers/core
(2014-07-23 13:27:23 +0200)

are available in the git repository at:


  git://git.linaro.org/people/john.stultz/linux.git fortglx/3.17/time

for you to fetch changes up to 7806f60e1d205db46eca6ad24429b3f86eda2588:

  clocksource: document some basic timekeeping concepts (2014-07-23
15:07:13 -0700)

----------------------------------------------------------------
David Riley (2):
      kernel: time: Add udelay_test module to validate udelay
      tools: add script to test udelay

John Stultz (9):
      hrtimer: Cleanup hrtimer accessors to the timekepeing state
      ktime: Kill non-scalar ktime_t implementation for 2038
      ktime: Change ktime_set() to take 64bit seconds value
      time64: Add time64.h header and define struct timespec64
      time: More core infrastructure for timespec64
      timekeeping: Convert timekeeping core to use timespec64s
      timekeeping: Minor fixup for timespec64->timespec assignment
      timekeeping: Rework frequency adjustments to work better w/ nohz
      timekeeping: Use cached ntp_tick_length when accumulating error

Linus Walleij (1):
      clocksource: document some basic timekeeping concepts

Mathieu Desnoyers (1):
      seqcount: Add raw_write_seqcount_latch()

Thomas Gleixner (57):
      tile: Convert VDSO timekeeping to the precise mechanism
      timekeeping: Simplify arch_gettimeoffset()
      ktime: Sanitize ktime_to_us/ms conversion
      time: Consolidate the time accessor prototypes
      timekeeping: Provide timespec64 based interfaces
      timekeeper: Move tk_xtime to core code
      timekeeping: Cache optimize struct timekeeper
      timekeeping: Use timekeeping_update() instead of memcpy()
      timekeeping: Provide internal ktime_t based data
      timekeeping: Use ktime_t based data for ktime_get()
      timekeeping: Provide ktime_get_with_offset()
      timekeeping: Use ktime_t based data for ktime_get_real()
      timekeeping; Use ktime_t based data for ktime_get_boottime()
      timekeeping: Use ktime_t based data for ktime_get_clocktai()
      timekeeping: Use ktime_t data for ktime_get_update_offsets_now()
      timekeeping; Use ktime based data for ktime_get_update_offsets_tick()
      timekeeping: Provide ktime_mono_to_any()
      timerfd: Use ktime_mono_to_real()
      input: evdev: Use ktime_mono_to_real()
      drm: Use ktime_mono_to_real()
      timekeeping: Remove ktime_get_monotonic_offset()
      timekeeping: Provide ktime_get[*]_ns() helpers
      time: Export nsecs_to_jiffies()
      sched: Make task->real_start_time nanoseconds based
      sched: Make task->start_time nanoseconds based
      delayacct: Make accounting nanosecond based
      delayacct: Remove braindamaged type conversions
      powerpc: cell: Use ktime_get_ns()
      connector: Use ktime_get_ns()
      mfd: cros_ec_spi: Use ktime_get_ns()
      misc: ioc4: Use ktime_get_ns()
      net: mlx5: Use ktime_get_ns()
      fs: lockd: Use ktime_get_ns()
      hwmon: ibmaem: Use ktime_get_ns()
      iio: Use ktime_get_real_ns()
      arm: bL_switcher:k Use ktime_get_real_ns()
      x86: kvm: Use ktime_get_boot_ns()
      x86: kvm: Make kvm_get_time_and_clockread() nanoseconds based
      timekeeping: Remove monotonic_to_bootbased
      timekeeping: Use ktime_get_boottime() for get_monotonic_boottime()
      timekeeping: Simplify getboottime()
      timekeeping: Remove timekeeper.total_sleep_time
      timekeeping: Simplify timekeeping_clocktai()
      hangcheck-timer: Use ktime_get_ns()
      timekeeping: Provide ktime_get_raw()
      drm: i915: Use nsec based interfaces
      drm: vmwgfx: Use nsec based interfaces
      wireless: ath9k: Get rid of timespec conversions
      clocksource: Make delta calculation a function
      clocksource: Move cycle_last validation to core code
      clocksource: Get rid of cycle_last
      timekeeping: Restructure the timekeeper some more
      timekeeping: Create struct tk_read_base and use it in struct
timekeeper
      timekeeping: Use tk_read_base as argument for timekeeping_get_ns()
      seqcount: Provide raw_read_seqcount()
      timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC
      ftrace: Provide trace clocks monotonic

 Documentation/timers/00-INDEX                 |    2 +
 Documentation/timers/timekeeping.txt          |  179 ++++
 arch/arm/Kconfig                              |    1 -
 arch/arm/common/bL_switcher.c                 |   16 +-
 arch/arm64/kernel/vdso.c                      |   10 +-
 arch/hexagon/Kconfig                          |    1 -
 arch/ia64/kernel/time.c                       |    4 +-
 arch/powerpc/kernel/time.c                    |    4 +-
 arch/powerpc/platforms/cell/spu_base.c        |   11 +-
 arch/powerpc/platforms/cell/spufs/context.c   |    4 +-
 arch/powerpc/platforms/cell/spufs/file.c      |    4 +-
 arch/powerpc/platforms/cell/spufs/sched.c     |    4 +-
 arch/s390/Kconfig                             |    1 -
 arch/s390/kernel/time.c                       |   16 +-
 arch/tile/kernel/time.c                       |   13 +-
 arch/tile/kernel/vdso/vgettimeofday.c         |    7 +-
 arch/x86/Kconfig                              |    2 +-
 arch/x86/kernel/tsc.c                         |   21 +-
 arch/x86/kernel/vsyscall_gtod.c               |   23 +-
 arch/x86/kvm/x86.c                            |   62 +-
 drivers/char/hangcheck-timer.c                |   33 +-
 drivers/connector/cn_proc.c                   |   36 +-
 drivers/gpu/drm/drm_irq.c                     |   16 +-
 drivers/gpu/drm/i915/i915_drv.h               |    2 +-
 drivers/gpu/drm/i915/i915_gem.c               |   33 +-
 drivers/gpu/drm/i915/intel_pm.c               |   12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h           |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c        |   44 +-
 drivers/hwmon/ibmaem.c                        |    6 +-
 drivers/input/evdev.c                         |    7 +-
 drivers/mfd/cros_ec_spi.c                     |    8 +-
 drivers/misc/ioc4.c                           |    7 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   16 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    7 +-
 fs/lockd/mon.c                                |    4 +-
 fs/proc/array.c                               |    7 +-
 fs/timerfd.c                                  |    6 +-
 include/linux/clocksource.h                   |    2 -
 include/linux/hrtimer.h                       |   14 -
 include/linux/iio/iio.h                       |    9 +-
 include/linux/ktime.h                         |  228 +----
 include/linux/mlx5/driver.h                   |    4 +-
 include/linux/sched.h                         |    8 +-
 include/linux/seqlock.h                       |   27 +
 include/linux/time.h                          |   65 +-
 include/linux/time64.h                        |  190 ++++
 include/linux/timekeeper_internal.h           |  150 ++--
 include/linux/timekeeping.h                   |  209 +++++
 kernel/acct.c                                 |   10 +-
 kernel/delayacct.c                            |   52 +-
 kernel/fork.c                                 |    5 +-
 kernel/time/Kconfig                           |    9 +-
 kernel/time/Makefile                          |    2 +
 kernel/time/clocksource.c                     |   12 +-
 kernel/time/hrtimer.c                         |   76 +-
 kernel/time/ntp.c                             |   15 +-
 kernel/time/ntp_internal.h                    |    2 +-
 kernel/time/posix-timers.c                    |    2 +
 kernel/time/tick-internal.h                   |    2 +
 kernel/time/time.c                            |   64 ++
 kernel/time/timekeeping.c                     | 1147
+++++++++++++------------
 kernel/time/timekeeping.h                     |   20 +
 kernel/time/timekeeping_debug.c               |    2 +-
 kernel/time/timekeeping_internal.h            |   17 +-
 kernel/time/udelay_test.c                     |  168 ++++
 kernel/trace/trace.c                          |   11 +-
 kernel/tsacct.c                               |   19 +-
 lib/Kconfig.debug                             |    9 +
 tools/time/udelay_test.sh                     |   66 ++
 69 files changed, 1926 insertions(+), 1323 deletions(-)
 create mode 100644 Documentation/timers/timekeeping.txt
 create mode 100644 include/linux/time64.h
 create mode 100644 include/linux/timekeeping.h
 create mode 100644 kernel/time/timekeeping.h
 create mode 100644 kernel/time/udelay_test.c
 create mode 100755 tools/time/udelay_test.sh

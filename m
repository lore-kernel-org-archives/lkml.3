Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaHEVvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:51:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:38471 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaHEVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:51:00 -0400
Date: Tue, 5 Aug 2014 23:50:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] time[r] updates for 3.17
Message-ID: <alpine.DEB.2.10.1408052323220.3323@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

A rather large update of timers, timekeeping & co with a few trivial
merge conflicts for your pleasure.

 * Core timekeeping code is 2038 safe now for 32bit machines. Now we
   just need to fix all in kernel users and the gazillion of user
   space interfaces which rely on timespec/timeval :)

 * Better cache layout for the timekeeping internal data structures.

 * Proper nanosecond based interfaces for in kernel users.

 * Tree wide cleanup of code which wants nanoseconds but does hoops
   and loops to convert back and forth from timespecs. Some of it
   definitely belongs into the ugly code museum.

 * Consolidation of the timekeeping interface zoo.

 * A fast NMI safe accessor to clock monotonic for tracing. This is a
   long standing request to support correlated user/kernel space
   traces. With proper NTP frequency correction it's also suitable for
   correlation of traces accross separate machines.

 * Checkpoint/restart support for timerfd.

 * A few NOHZ[_FULL] improvements in the [hr]timer code.

 * Code move from kernel to kernel/time of all time* related code.

 * New clocksource/event drivers from the ARM universe. I'm really
   impressed that despite an architected timer in the newer chips SoC
   manufacturers insist on inventing new and differently broken SoC
   specific timers.

 * Another round of code move from arch to drivers. Looks like most of
   the legacy mess in ARM regarding timers is sorted out except for a
   few obnoxious strongholds.

 * The usual updates and fixlets all over the place

Thanks,

	tglx

------------------>
Alexander Shiyan (2):
      clocksource: clps711x: Add CLPS711X clocksource driver
      clocksource: clps711x: Add DT bindings documentation

Chen Gang (1):
      clocksource: Kconfig: Let EM_TIMER_STI depend on HAS_IOMEM

Cyrill Gorcunov (3):
      timerfd: Implement show_fdinfo method
      docs: Procfs -- Document timerfd output
      timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks, v3

David Riley (2):
      kernel: time: Add udelay_test module to validate udelay
      tools: add script to test udelay

Doug Anderson (2):
      clocksource: exynos_mct: Use readl_relaxed/writel_relaxed
      clocksource: exynos_mct: Only use 32-bits where possible

Jean Delvare (1):
      clocksource: Add a Kconfig menu

John Stultz (10):
      hrtimer: Cleanup hrtimer accessors to the timekepeing state
      ktime: Kill non-scalar ktime_t implementation for 2038
      ktime: Change ktime_set() to take 64bit seconds value
      time64: Add time64.h header and define struct timespec64
      time: More core infrastructure for timespec64
      timekeeping: Convert timekeeping core to use timespec64s
      timekeeping: Minor fixup for timespec64->timespec assignment
      timekeeping: Rework frequency adjustments to work better w/ nohz
      timekeeping: Use cached ntp_tick_length when accumulating error
      timekeeping: Fixup typo in update_vsyscall_old definition

Kuninori Morimoto (1):
      clocksource: sh_mtu2: Tidy up Kconfig typo for MTU2

Laurent Pinchart (10):
      clocksource: sh_cmt: Drop support for legacy platform data
      clocksource: sh_cmt: Replace global spinlock with a per-device spinlock
      clocksource: sh_tmu: Drop support for legacy platform data
      clocksource: sh_tmu: Replace global spinlock with a per-device spinlock
      clocksource: sh_mtu2: Drop support for legacy platform data
      clocksource: sh_mtu2: Replace global spinlock with a per-device spinlock
      clocksource: shmobile: Remove unused sh_timer_config members
      clocksource: sh_cmt: Add DT support
      clocksource: sh_tmu: Add DT support
      clocksource: sh_mtu2: Add DT support

Linus Walleij (1):
      clocksource: document some basic timekeeping concepts

Masanari Iida (1):
      Documentation: Docbook: Fix files location change of kernel/[hr]timer.c

Mathieu Desnoyers (1):
      seqcount: Add raw_write_seqcount_latch()

Matthias Brugger (4):
      of: Provide a function to request and map memory
      clocksource: Add support for the Mediatek SoCs
      dt-bindings: Add mtk-timer bindings
      vendor-prefixes: Add prefix for Mediatek Inc.

Robert Jarzmik (4):
      clocksource: pxa: Move PXA timer to clocksource framework
      clocksource: pxa: Add device-tree support for PXA timer
      ARM: pxa: Add CLKSRC_OF dependency
      ARM: pxa: Add non device-tree timer link to clocksource

Thomas Gleixner (65):
      acct: Use ktime_get_ts()
      delayacct: Use ktime_get_ts()
      tsacct: Use ktime_get_ts()
      kdb: Use ktime_get_ts()
      firewire: Use ktime_get_ts()
      fork: Use ktime_get_ts()
      tomoyo: Use sensible time interface
      time/timers: Move all time(r) related files into kernel/time
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
      timekeeping: Create struct tk_read_base and use it in struct timekeeper
      timekeeping: Use tk_read_base as argument for timekeeping_get_ns()
      seqcount: Provide raw_read_seqcount()
      timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC
      ftrace: Provide trace clocks monotonic

Viresh Kumar (5):
      timer: Store cpu-number in struct tvec_base
      timer: Kick dynticks targets on mod_timer*() calls
      hrtimer: Store cpu-number in struct hrtimer_cpu_base
      hrtimer: Kick lowres dynticks targets on timer enqueue
      hrtimer: Remove hrtimer_enqueue_reprogram()

Zhiwu Song (1):
      clocksource: sirf: Fix incorrect clock enable counter for timer


 Documentation/DocBook/device-drivers.tmpl          |    4 +-
 .../bindings/timer/cirrus,clps711x-timer.txt       |   29 +
 .../bindings/timer/mediatek,mtk-timer.txt          |   17 +
 .../devicetree/bindings/timer/renesas,cmt.txt      |   47 +
 .../devicetree/bindings/timer/renesas,mtu2.txt     |   39 +
 .../devicetree/bindings/timer/renesas,tmu.txt      |   39 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/filesystems/proc.txt                 |   19 +
 Documentation/timers/00-INDEX                      |    2 +
 Documentation/timers/timekeeping.txt               |  179 +++
 MAINTAINERS                                        |    6 +-
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/common/bL_switcher.c                      |   16 +-
 arch/arm/mach-pxa/Makefile                         |    2 +-
 arch/arm/mach-pxa/generic.c                        |   11 +
 arch/arm/mach-pxa/time.c                           |  162 ---
 arch/arm64/kernel/vdso.c                           |   10 +-
 arch/hexagon/Kconfig                               |    1 -
 arch/ia64/kernel/time.c                            |    4 +-
 arch/powerpc/kernel/time.c                         |    4 +-
 arch/powerpc/platforms/cell/spu_base.c             |   11 +-
 arch/powerpc/platforms/cell/spufs/context.c        |    4 +-
 arch/powerpc/platforms/cell/spufs/file.c           |    4 +-
 arch/powerpc/platforms/cell/spufs/sched.c          |    4 +-
 arch/s390/Kconfig                                  |    1 -
 arch/s390/kernel/time.c                            |   16 +-
 arch/tile/kernel/time.c                            |   13 +-
 arch/tile/kernel/vdso/vgettimeofday.c              |    7 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/kernel/tsc.c                              |   21 +-
 arch/x86/kernel/vsyscall_gtod.c                    |   23 +-
 arch/x86/kvm/x86.c                                 |   62 +-
 drivers/char/hangcheck-timer.c                     |   33 +-
 drivers/clocksource/Kconfig                        |   14 +-
 drivers/clocksource/Makefile                       |    3 +
 drivers/clocksource/clps711x-timer.c               |  131 +++
 drivers/clocksource/exynos_mct.c                   |   63 +-
 drivers/clocksource/mtk_timer.c                    |  261 +++++
 drivers/clocksource/pxa_timer.c                    |  227 ++++
 drivers/clocksource/sh_cmt.c                       |  233 ++--
 drivers/clocksource/sh_mtu2.c                      |  146 +--
 drivers/clocksource/sh_tmu.c                       |  127 +--
 drivers/clocksource/timer-marco.c                  |    3 +
 drivers/clocksource/timer-prima2.c                 |    3 +
 drivers/connector/cn_proc.c                        |   36 +-
 drivers/firewire/core-cdev.c                       |    6 +-
 drivers/gpu/drm/drm_irq.c                          |   16 +-
 drivers/gpu/drm/i915/i915_drv.h                    |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   33 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c             |   44 +-
 drivers/hwmon/ibmaem.c                             |    6 +-
 drivers/input/evdev.c                              |    7 +-
 drivers/mfd/cros_ec_spi.c                          |    8 +-
 drivers/misc/ioc4.c                                |    7 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   16 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    7 +-
 drivers/of/address.c                               |   36 +
 fs/lockd/mon.c                                     |    4 +-
 fs/proc/array.c                                    |    7 +-
 fs/timerfd.c                                       |   77 +-
 include/clocksource/pxa.h                          |   18 +
 include/linux/clocksource.h                        |    2 -
 include/linux/hrtimer.h                            |   16 +-
 include/linux/iio/iio.h                            |    9 +-
 include/linux/io.h                                 |    2 +
 include/linux/ktime.h                              |  228 +---
 include/linux/mlx5/driver.h                        |    4 +-
 include/linux/of_address.h                         |   11 +
 include/linux/sched.h                              |    8 +-
 include/linux/seqlock.h                            |   27 +
 include/linux/sh_timer.h                           |    5 -
 include/linux/time.h                               |   65 +-
 include/linux/time64.h                             |  190 ++++
 include/linux/timekeeper_internal.h                |  150 +--
 include/linux/timekeeping.h                        |  209 ++++
 include/linux/timerfd.h                            |    5 +
 kernel/Makefile                                    |   25 +-
 kernel/acct.c                                      |   10 +-
 kernel/debug/kdb/kdb_main.c                        |    2 +-
 kernel/delayacct.c                                 |   62 +-
 kernel/fork.c                                      |    5 +-
 kernel/time/Kconfig                                |    9 +-
 kernel/time/Makefile                               |   19 +
 kernel/time/clocksource.c                          |   12 +-
 kernel/{ => time}/hrtimer.c                        |  125 +--
 kernel/{ => time}/itimer.c                         |    0
 kernel/time/ntp.c                                  |   15 +-
 kernel/time/ntp_internal.h                         |    2 +-
 kernel/{ => time}/posix-cpu-timers.c               |    0
 kernel/{ => time}/posix-timers.c                   |    2 +
 kernel/time/tick-internal.h                        |    2 +
 kernel/{ => time}/time.c                           |   64 ++
 kernel/{ => time}/timeconst.bc                     |    0
 kernel/time/timekeeping.c                          | 1147 +++++++++++---------
 kernel/time/timekeeping.h                          |   20 +
 kernel/time/timekeeping_debug.c                    |    2 +-
 kernel/time/timekeeping_internal.h                 |   17 +-
 kernel/{ => time}/timer.c                          |   34 +-
 kernel/time/udelay_test.c                          |  168 +++
 kernel/trace/trace.c                               |   11 +-
 kernel/tsacct.c                                    |   19 +-
 lib/Kconfig.debug                                  |    9 +
 lib/devres.c                                       |    2 -
 security/tomoyo/audit.c                            |    8 +-
 security/tomoyo/common.c                           |    4 +-
 tools/time/udelay_test.sh                          |   66 ++
 108 files changed, 3221 insertions(+), 1923 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/renesas,cmt.txt
 create mode 100644 Documentation/devicetree/bindings/timer/renesas,mtu2.txt
 create mode 100644 Documentation/devicetree/bindings/timer/renesas,tmu.txt
 create mode 100644 Documentation/timers/timekeeping.txt
 delete mode 100644 arch/arm/mach-pxa/time.c
 create mode 100644 drivers/clocksource/clps711x-timer.c
 create mode 100644 drivers/clocksource/mtk_timer.c
 create mode 100644 drivers/clocksource/pxa_timer.c
 create mode 100644 include/clocksource/pxa.h
 create mode 100644 include/linux/time64.h
 create mode 100644 include/linux/timekeeping.h
 rename kernel/{ => time}/hrtimer.c (94%)
 rename kernel/{ => time}/itimer.c (100%)
 rename kernel/{ => time}/posix-cpu-timers.c (100%)
 rename kernel/{ => time}/posix-timers.c (99%)
 rename kernel/{ => time}/time.c (92%)
 rename kernel/{ => time}/timeconst.bc (100%)
 create mode 100644 kernel/time/timekeeping.h
 rename kernel/{ => time}/timer.c (99%)
 create mode 100644 kernel/time/udelay_test.c
 create mode 100755 tools/time/udelay_test.sh

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index cc63f30..6e06ebd 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -54,7 +54,7 @@
 !Ikernel/sched/cpupri.c
 !Ikernel/sched/fair.c
 !Iinclude/linux/completion.h
-!Ekernel/timer.c
+!Ekernel/time/timer.c
      </sect1>
      <sect1><title>Wait queues and Wake events</title>
 !Iinclude/linux/wait.h
@@ -63,7 +63,7 @@
      <sect1><title>High-resolution timers</title>
 !Iinclude/linux/ktime.h
 !Iinclude/linux/hrtimer.h
-!Ekernel/hrtimer.c
+!Ekernel/time/hrtimer.c
      </sect1>
      <sect1><title>Workqueues and Kevents</title>
 !Ekernel/workqueue.c
diff --git a/Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt b/Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt
new file mode 100644
index 0000000..cd55b52
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/cirrus,clps711x-timer.txt
@@ -0,0 +1,29 @@
+* Cirrus Logic CLPS711X Timer Counter
+
+Required properties:
+- compatible: Shall contain "cirrus,clps711x-timer".
+- reg       : Address and length of the register set.
+- interrupts: The interrupt number of the timer.
+- clocks    : phandle of timer reference clock.
+
+Note: Each timer should have an alias correctly numbered in "aliases" node.
+
+Example:
+	aliases {
+		timer0 = &timer1;
+		timer1 = &timer2;
+	};
+
+	timer1: timer@80000300 {
+		compatible = "cirrus,ep7312-timer", "cirrus,clps711x-timer";
+		reg = <0x80000300 0x4>;
+		interrupts = <8>;
+		clocks = <&clks 5>;
+	};
+
+	timer2: timer@80000340 {
+		compatible = "cirrus,ep7312-timer", "cirrus,clps711x-timer";
+		reg = <0x80000340 0x4>;
+		interrupts = <9>;
+		clocks = <&clks 6>;
+	};
diff --git a/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
new file mode 100644
index 0000000..7c4408f
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
@@ -0,0 +1,17 @@
+Mediatek MT6577, MT6572 and MT6589 Timers
+---------------------------------------
+
+Required properties:
+- compatible: Should be "mediatek,mt6577-timer"
+- reg: Should contain location and length for timers register.
+- clocks: Clocks driving the timer hardware. This list should include two
+	clocks. The order is system clock and as second clock the RTC clock.
+
+Examples:
+
+	timer@10008000 {
+		compatible = "mediatek,mt6577-timer";
+		reg = <0x10008000 0x80>;
+		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&system_clk>, <&rtc_clk>;
+	};
diff --git a/Documentation/devicetree/bindings/timer/renesas,cmt.txt b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
new file mode 100644
index 0000000..a17418b
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
@@ -0,0 +1,47 @@
+* Renesas R-Car Compare Match Timer (CMT)
+
+The CMT is a multi-channel 16/32/48-bit timer/counter with configurable clock
+inputs and programmable compare match.
+
+Channels share hardware resources but their counter and compare match value
+are independent. A particular CMT instance can implement only a subset of the
+channels supported by the CMT model. Channel indices represent the hardware
+position of the channel in the CMT and don't match the channel numbers in the
+datasheets.
+
+Required Properties:
+
+  - compatible: must contain one of the following.
+    - "renesas,cmt-32" for the 32-bit CMT
+		(CMT0 on sh7372, sh73a0 and r8a7740)
+    - "renesas,cmt-32-fast" for the 32-bit CMT with fast clock support
+		(CMT[234] on sh7372, sh73a0 and r8a7740)
+    - "renesas,cmt-48" for the 48-bit CMT
+		(CMT1 on sh7372, sh73a0 and r8a7740)
+    - "renesas,cmt-48-gen2" for the second generation 48-bit CMT
+		(CMT[01] on r8a73a4, r8a7790 and r8a7791)
+
+  - reg: base address and length of the registers block for the timer module.
+  - interrupts: interrupt-specifier for the timer, one per channel.
+  - clocks: a list of phandle + clock-specifier pairs, one for each entry
+    in clock-names.
+  - clock-names: must contain "fck" for the functional clock.
+
+  - renesas,channels-mask: bitmask of the available channels.
+
+
+Example: R8A7790 (R-Car H2) CMT0 node
+
+	CMT0 on R8A7790 implements hardware channels 5 and 6 only and names
+	them channels 0 and 1 in the documentation.
+
+	cmt0: timer@ffca0000 {
+		compatible = "renesas,cmt-48-gen2";
+		reg = <0 0xffca0000 0 0x1004>;
+		interrupts = <0 142 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 142 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7790_CLK_CMT0>;
+		clock-names = "fck";
+
+		renesas,channels-mask = <0x60>;
+	};
diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
new file mode 100644
index 0000000..917453f
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
@@ -0,0 +1,39 @@
+* Renesas R-Car Multi-Function Timer Pulse Unit 2 (MTU2)
+
+The MTU2 is a multi-purpose, multi-channel timer/counter with configurable
+clock inputs and programmable compare match.
+
+Channels share hardware resources but their counter and compare match value
+are independent. The MTU2 hardware supports five channels indexed from 0 to 4.
+
+Required Properties:
+
+  - compatible: must contain "renesas,mtu2"
+
+  - reg: base address and length of the registers block for the timer module.
+
+  - interrupts: interrupt specifiers for the timer, one for each entry in
+    interrupt-names.
+  - interrupt-names: must contain one entry named "tgi?a" for each enabled
+    channel, where "?" is the channel index expressed as one digit from "0" to
+    "4".
+
+  - clocks: a list of phandle + clock-specifier pairs, one for each entry
+    in clock-names.
+  - clock-names: must contain "fck" for the functional clock.
+
+
+Example: R7S72100 (RZ/A1H) MTU2 node
+
+	mtu2: timer@fcff0000 {
+		compatible = "renesas,mtu2";
+		reg = <0xfcff0000 0x400>;
+		interrupts = <0 139 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 146 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 150 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 154 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 159 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "tgi0a", "tgi1a", "tgi2a", "tgi3a", "tgi4a";
+		clocks = <&mstp3_clks R7S72100_CLK_MTU2>;
+		clock-names = "fck";
+	};
diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
new file mode 100644
index 0000000..425d0c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
@@ -0,0 +1,39 @@
+* Renesas R-Car Timer Unit (TMU)
+
+The TMU is a 32-bit timer/counter with configurable clock inputs and
+programmable compare match.
+
+Channels share hardware resources but their counter and compare match value
+are independent. The TMU hardware supports up to three channels.
+
+Required Properties:
+
+  - compatible: must contain "renesas,tmu"
+
+  - reg: base address and length of the registers block for the timer module.
+
+  - interrupts: interrupt-specifier for the timer, one per channel.
+
+  - clocks: a list of phandle + clock-specifier pairs, one for each entry
+    in clock-names.
+  - clock-names: must contain "fck" for the functional clock.
+
+Optional Properties:
+
+  - #renesas,channels: number of channels implemented by the timer, must be 2
+    or 3 (if not specified the value defaults to 3).
+
+
+Example: R8A7779 (R-Car H1) TMU0 node
+
+	tmu0: timer@ffd80000 {
+		compatible = "renesas,tmu";
+		reg = <0xffd80000 0x30>;
+		interrupts = <0 32 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 33 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 34 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp0_clks R8A7779_CLK_TMU0>;
+		clock-names = "fck";
+
+		#renesas,channels = <3>;
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 46a311e..dd5bce8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -77,6 +77,7 @@ lsi	LSI Corp. (LSI Logic)
 lltc	Linear Technology Corporation
 marvell	Marvell Technology Group Ltd.
 maxim	Maxim Integrated Products
+mediatek	MediaTek Inc.
 micrel	Micrel Inc.
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index ddc531a..eb8a10e 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1743,6 +1743,25 @@ pair provide additional information particular to the objects they represent.
 	While the first three lines are mandatory and always printed, the rest is
 	optional and may be omitted if no marks created yet.
 
+	Timerfd files
+	~~~~~~~~~~~~~
+
+	pos:	0
+	flags:	02
+	mnt_id:	9
+	clockid: 0
+	ticks: 0
+	settime flags: 01
+	it_value: (0, 49406829)
+	it_interval: (1, 0)
+
+	where 'clockid' is the clock type and 'ticks' is the number of the timer expirations
+	that have occurred [see timerfd_create(2) for details]. 'settime flags' are
+	flags in octal form been used to setup the timer [see timerfd_settime(2) for
+	details]. 'it_value' is remaining time until the timer exiration.
+	'it_interval' is the interval for the timer. Note the timer might be set up
+	with TIMER_ABSTIME option which will be shown in 'settime flags', but 'it_value'
+	still exhibits timer's remaining time.
 
 ------------------------------------------------------------------------------
 Configuring procfs
diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
index 6d042dc..ee212a2 100644
--- a/Documentation/timers/00-INDEX
+++ b/Documentation/timers/00-INDEX
@@ -12,6 +12,8 @@ Makefile
 	- Build and link hpet_example
 NO_HZ.txt
 	- Summary of the different methods for the scheduler clock-interrupts management.
+timekeeping.txt
+	- Clock sources, clock events, sched_clock() and delay timer notes
 timers-howto.txt
 	- how to insert delays in the kernel the right (tm) way.
 timer_stats.txt
diff --git a/Documentation/timers/timekeeping.txt b/Documentation/timers/timekeeping.txt
new file mode 100644
index 0000000..f3a8cf2
--- /dev/null
+++ b/Documentation/timers/timekeeping.txt
@@ -0,0 +1,179 @@
+Clock sources, Clock events, sched_clock() and delay timers
+-----------------------------------------------------------
+
+This document tries to briefly explain some basic kernel timekeeping
+abstractions. It partly pertains to the drivers usually found in
+drivers/clocksource in the kernel tree, but the code may be spread out
+across the kernel.
+
+If you grep through the kernel source you will find a number of architecture-
+specific implementations of clock sources, clockevents and several likewise
+architecture-specific overrides of the sched_clock() function and some
+delay timers.
+
+To provide timekeeping for your platform, the clock source provides
+the basic timeline, whereas clock events shoot interrupts on certain points
+on this timeline, providing facilities such as high-resolution timers.
+sched_clock() is used for scheduling and timestamping, and delay timers
+provide an accurate delay source using hardware counters.
+
+
+Clock sources
+-------------
+
+The purpose of the clock source is to provide a timeline for the system that
+tells you where you are in time. For example issuing the command 'date' on
+a Linux system will eventually read the clock source to determine exactly
+what time it is.
+
+Typically the clock source is a monotonic, atomic counter which will provide
+n bits which count from 0 to 2^(n-1) and then wraps around to 0 and start over.
+It will ideally NEVER stop ticking as long as the system is running. It
+may stop during system suspend.
+
+The clock source shall have as high resolution as possible, and the frequency
+shall be as stable and correct as possible as compared to a real-world wall
+clock. It should not move unpredictably back and forth in time or miss a few
+cycles here and there.
+
+It must be immune to the kind of effects that occur in hardware where e.g.
+the counter register is read in two phases on the bus lowest 16 bits first
+and the higher 16 bits in a second bus cycle with the counter bits
+potentially being updated in between leading to the risk of very strange
+values from the counter.
+
+When the wall-clock accuracy of the clock source isn't satisfactory, there
+are various quirks and layers in the timekeeping code for e.g. synchronizing
+the user-visible time to RTC clocks in the system or against networked time
+servers using NTP, but all they do basically is update an offset against
+the clock source, which provides the fundamental timeline for the system.
+These measures does not affect the clock source per se, they only adapt the
+system to the shortcomings of it.
+
+The clock source struct shall provide means to translate the provided counter
+into a nanosecond value as an unsigned long long (unsigned 64 bit) number.
+Since this operation may be invoked very often, doing this in a strict
+mathematical sense is not desirable: instead the number is taken as close as
+possible to a nanosecond value using only the arithmetic operations
+multiply and shift, so in clocksource_cyc2ns() you find:
+
+  ns ~= (clocksource * mult) >> shift
+
+You will find a number of helper functions in the clock source code intended
+to aid in providing these mult and shift values, such as
+clocksource_khz2mult(), clocksource_hz2mult() that help determine the
+mult factor from a fixed shift, and clocksource_register_hz() and
+clocksource_register_khz() which will help out assigning both shift and mult
+factors using the frequency of the clock source as the only input.
+
+For real simple clock sources accessed from a single I/O memory location
+there is nowadays even clocksource_mmio_init() which will take a memory
+location, bit width, a parameter telling whether the counter in the
+register counts up or down, and the timer clock rate, and then conjure all
+necessary parameters.
+
+Since a 32-bit counter at say 100 MHz will wrap around to zero after some 43
+seconds, the code handling the clock source will have to compensate for this.
+That is the reason why the clock source struct also contains a 'mask'
+member telling how many bits of the source are valid. This way the timekeeping
+code knows when the counter will wrap around and can insert the necessary
+compensation code on both sides of the wrap point so that the system timeline
+remains monotonic.
+
+
+Clock events
+------------
+
+Clock events are the conceptual reverse of clock sources: they take a
+desired time specification value and calculate the values to poke into
+hardware timer registers.
+
+Clock events are orthogonal to clock sources. The same hardware
+and register range may be used for the clock event, but it is essentially
+a different thing. The hardware driving clock events has to be able to
+fire interrupts, so as to trigger events on the system timeline. On an SMP
+system, it is ideal (and customary) to have one such event driving timer per
+CPU core, so that each core can trigger events independently of any other
+core.
+
+You will notice that the clock event device code is based on the same basic
+idea about translating counters to nanoseconds using mult and shift
+arithmetic, and you find the same family of helper functions again for
+assigning these values. The clock event driver does not need a 'mask'
+attribute however: the system will not try to plan events beyond the time
+horizon of the clock event.
+
+
+sched_clock()
+-------------
+
+In addition to the clock sources and clock events there is a special weak
+function in the kernel called sched_clock(). This function shall return the
+number of nanoseconds since the system was started. An architecture may or
+may not provide an implementation of sched_clock() on its own. If a local
+implementation is not provided, the system jiffy counter will be used as
+sched_clock().
+
+As the name suggests, sched_clock() is used for scheduling the system,
+determining the absolute timeslice for a certain process in the CFS scheduler
+for example. It is also used for printk timestamps when you have selected to
+include time information in printk for things like bootcharts.
+
+Compared to clock sources, sched_clock() has to be very fast: it is called
+much more often, especially by the scheduler. If you have to do trade-offs
+between accuracy compared to the clock source, you may sacrifice accuracy
+for speed in sched_clock(). It however requires some of the same basic
+characteristics as the clock source, i.e. it should be monotonic.
+
+The sched_clock() function may wrap only on unsigned long long boundaries,
+i.e. after 64 bits. Since this is a nanosecond value this will mean it wraps
+after circa 585 years. (For most practical systems this means "never".)
+
+If an architecture does not provide its own implementation of this function,
+it will fall back to using jiffies, making its maximum resolution 1/HZ of the
+jiffy frequency for the architecture. This will affect scheduling accuracy
+and will likely show up in system benchmarks.
+
+The clock driving sched_clock() may stop or reset to zero during system
+suspend/sleep. This does not matter to the function it serves of scheduling
+events on the system. However it may result in interesting timestamps in
+printk().
+
+The sched_clock() function should be callable in any context, IRQ- and
+NMI-safe and return a sane value in any context.
+
+Some architectures may have a limited set of time sources and lack a nice
+counter to derive a 64-bit nanosecond value, so for example on the ARM
+architecture, special helper functions have been created to provide a
+sched_clock() nanosecond base from a 16- or 32-bit counter. Sometimes the
+same counter that is also used as clock source is used for this purpose.
+
+On SMP systems, it is crucial for performance that sched_clock() can be called
+independently on each CPU without any synchronization performance hits.
+Some hardware (such as the x86 TSC) will cause the sched_clock() function to
+drift between the CPUs on the system. The kernel can work around this by
+enabling the CONFIG_HAVE_UNSTABLE_SCHED_CLOCK option. This is another aspect
+that makes sched_clock() different from the ordinary clock source.
+
+
+Delay timers (some architectures only)
+--------------------------------------
+
+On systems with variable CPU frequency, the various kernel delay() functions
+will sometimes behave strangely. Basically these delays usually use a hard
+loop to delay a certain number of jiffy fractions using a "lpj" (loops per
+jiffy) value, calibrated on boot.
+
+Let's hope that your system is running on maximum frequency when this value
+is calibrated: as an effect when the frequency is geared down to half the
+full frequency, any delay() will be twice as long. Usually this does not
+hurt, as you're commonly requesting that amount of delay *or more*. But
+basically the semantics are quite unpredictable on such systems.
+
+Enter timer-based delays. Using these, a timer read may be used instead of
+a hard-coded loop for providing the desired delay.
+
+This is done by declaring a struct delay_timer and assigning the appropriate
+function pointers and rate settings for this delay timer.
+
+This is available on some architectures like OpenRISC or ARM.
diff --git a/MAINTAINERS b/MAINTAINERS
index e31c874..1d287ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4205,7 +4205,7 @@ L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Maintained
 F:	Documentation/timers/
-F:	kernel/hrtimer.c
+F:	kernel/time/hrtimer.c
 F:	kernel/time/clockevents.c
 F:	kernel/time/tick*.*
 F:	kernel/time/timer_*.c
@@ -7022,10 +7022,10 @@ POSIX CLOCKS and TIMERS
 M:	Thomas Gleixner <tglx@linutronix.de>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
-S:	Supported
+S:	Maintained
 F:	fs/timerfd.c
 F:	include/linux/timer*
-F:	kernel/*timer*
+F:	kernel/time/*timer*
 
 POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
 M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 245058b..b9f6728 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -64,7 +64,6 @@ config ARM
 	select HAVE_UID16
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select IRQ_FORCED_THREADING
-	select KTIME_SCALAR
 	select MODULES_USE_ELF_REL
 	select NO_BOOTMEM
 	select OLD_SIGACTION
@@ -634,6 +633,7 @@ config ARCH_PXA
 	select AUTO_ZRELADDR
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
+	select CLKSRC_OF
 	select GENERIC_CLOCKEVENTS
 	select GPIO_PXA
 	select HAVE_IDE
diff --git a/arch/arm/common/bL_switcher.c b/arch/arm/common/bL_switcher.c
index 490f3dc..6eaddc4 100644
--- a/arch/arm/common/bL_switcher.c
+++ b/arch/arm/common/bL_switcher.c
@@ -58,16 +58,6 @@ static int read_mpidr(void)
 }
 
 /*
- * Get a global nanosecond time stamp for tracing.
- */
-static s64 get_ns(void)
-{
-	struct timespec ts;
-	getnstimeofday(&ts);
-	return timespec_to_ns(&ts);
-}
-
-/*
  * bL switcher core code.
  */
 
@@ -224,7 +214,7 @@ static int bL_switch_to(unsigned int new_cluster_id)
 	 */
 	local_irq_disable();
 	local_fiq_disable();
-	trace_cpu_migrate_begin(get_ns(), ob_mpidr);
+	trace_cpu_migrate_begin(ktime_get_real_ns(), ob_mpidr);
 
 	/* redirect GIC's SGIs to our counterpart */
 	gic_migrate_target(bL_gic_id[ib_cpu][ib_cluster]);
@@ -267,7 +257,7 @@ static int bL_switch_to(unsigned int new_cluster_id)
 					  tdev->evtdev->next_event, 1);
 	}
 
-	trace_cpu_migrate_finish(get_ns(), ib_mpidr);
+	trace_cpu_migrate_finish(ktime_get_real_ns(), ib_mpidr);
 	local_fiq_enable();
 	local_irq_enable();
 
@@ -558,7 +548,7 @@ int bL_switcher_get_logical_index(u32 mpidr)
 
 static void bL_switcher_trace_trigger_cpu(void *__always_unused info)
 {
-	trace_cpu_migrate_current(get_ns(), read_mpidr());
+	trace_cpu_migrate_current(ktime_get_real_ns(), read_mpidr());
 }
 
 int bL_switcher_trace_trigger(void)
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 648867a..2fe1824 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -4,7 +4,7 @@
 
 # Common support (must be linked before board specific support)
 obj-y				+= clock.o devices.o generic.o irq.o \
-				   time.o reset.o
+				   reset.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 
 # Generic drivers that other drivers may depend upon
diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 4225417..6f38e1a 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -25,11 +25,13 @@
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 
+#include <mach/irqs.h>
 #include <mach/reset.h>
 #include <mach/smemc.h>
 #include <mach/pxa3xx-regs.h>
 
 #include "generic.h"
+#include <clocksource/pxa.h>
 
 void clear_reset_status(unsigned int mask)
 {
@@ -57,6 +59,15 @@ unsigned long get_clock_tick_rate(void)
 EXPORT_SYMBOL(get_clock_tick_rate);
 
 /*
+ * For non device-tree builds, keep legacy timer init
+ */
+void pxa_timer_init(void)
+{
+	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x40a00000),
+			    get_clock_tick_rate());
+}
+
+/*
  * Get the clock frequency as reflected by CCCR and the turbo flag.
  * We assume these values have been applied via a fcs.
  * If info is not 0 we also display the current settings.
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
deleted file mode 100644
index fca174e..0000000
--- a/arch/arm/mach-pxa/time.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- * arch/arm/mach-pxa/time.c
- *
- * PXA clocksource, clockevents, and OST interrupt handlers.
- * Copyright (c) 2007 by Bill Gatliff <bgat@billgatliff.com>.
- *
- * Derived from Nicolas Pitre's PXA timer handler Copyright (c) 2001
- * by MontaVista Software, Inc.  (Nico, your code rocks!)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/clockchips.h>
-#include <linux/sched_clock.h>
-
-#include <asm/div64.h>
-#include <asm/mach/irq.h>
-#include <asm/mach/time.h>
-#include <mach/regs-ost.h>
-#include <mach/irqs.h>
-
-/*
- * This is PXA's sched_clock implementation. This has a resolution
- * of at least 308 ns and a maximum value of 208 days.
- *
- * The return value is guaranteed to be monotonic in that range as
- * long as there is always less than 582 seconds between successive
- * calls to sched_clock() which should always be the case in practice.
- */
-
-static u64 notrace pxa_read_sched_clock(void)
-{
-	return readl_relaxed(OSCR);
-}
-
-
-#define MIN_OSCR_DELTA 16
-
-static irqreturn_t
-pxa_ost0_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *c = dev_id;
-
-	/* Disarm the compare/match, signal the event. */
-	writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-	writel_relaxed(OSSR_M0, OSSR);
-	c->event_handler(c);
-
-	return IRQ_HANDLED;
-}
-
-static int
-pxa_osmr0_set_next_event(unsigned long delta, struct clock_event_device *dev)
-{
-	unsigned long next, oscr;
-
-	writel_relaxed(readl_relaxed(OIER) | OIER_E0, OIER);
-	next = readl_relaxed(OSCR) + delta;
-	writel_relaxed(next, OSMR0);
-	oscr = readl_relaxed(OSCR);
-
-	return (signed)(next - oscr) <= MIN_OSCR_DELTA ? -ETIME : 0;
-}
-
-static void
-pxa_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *dev)
-{
-	switch (mode) {
-	case CLOCK_EVT_MODE_ONESHOT:
-		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-		writel_relaxed(OSSR_M0, OSSR);
-		break;
-
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		/* initializing, released, or preparing for suspend */
-		writel_relaxed(readl_relaxed(OIER) & ~OIER_E0, OIER);
-		writel_relaxed(OSSR_M0, OSSR);
-		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-	case CLOCK_EVT_MODE_PERIODIC:
-		break;
-	}
-}
-
-#ifdef CONFIG_PM
-static unsigned long osmr[4], oier, oscr;
-
-static void pxa_timer_suspend(struct clock_event_device *cedev)
-{
-	osmr[0] = readl_relaxed(OSMR0);
-	osmr[1] = readl_relaxed(OSMR1);
-	osmr[2] = readl_relaxed(OSMR2);
-	osmr[3] = readl_relaxed(OSMR3);
-	oier = readl_relaxed(OIER);
-	oscr = readl_relaxed(OSCR);
-}
-
-static void pxa_timer_resume(struct clock_event_device *cedev)
-{
-	/*
-	 * Ensure that we have at least MIN_OSCR_DELTA between match
-	 * register 0 and the OSCR, to guarantee that we will receive
-	 * the one-shot timer interrupt.  We adjust OSMR0 in preference
-	 * to OSCR to guarantee that OSCR is monotonically incrementing.
-	 */
-	if (osmr[0] - oscr < MIN_OSCR_DELTA)
-		osmr[0] += MIN_OSCR_DELTA;
-
-	writel_relaxed(osmr[0], OSMR0);
-	writel_relaxed(osmr[1], OSMR1);
-	writel_relaxed(osmr[2], OSMR2);
-	writel_relaxed(osmr[3], OSMR3);
-	writel_relaxed(oier, OIER);
-	writel_relaxed(oscr, OSCR);
-}
-#else
-#define pxa_timer_suspend NULL
-#define pxa_timer_resume NULL
-#endif
-
-static struct clock_event_device ckevt_pxa_osmr0 = {
-	.name		= "osmr0",
-	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.rating		= 200,
-	.set_next_event	= pxa_osmr0_set_next_event,
-	.set_mode	= pxa_osmr0_set_mode,
-	.suspend	= pxa_timer_suspend,
-	.resume		= pxa_timer_resume,
-};
-
-static struct irqaction pxa_ost0_irq = {
-	.name		= "ost0",
-	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= pxa_ost0_interrupt,
-	.dev_id		= &ckevt_pxa_osmr0,
-};
-
-void __init pxa_timer_init(void)
-{
-	unsigned long clock_tick_rate = get_clock_tick_rate();
-
-	writel_relaxed(0, OIER);
-	writel_relaxed(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
-
-	sched_clock_register(pxa_read_sched_clock, 32, clock_tick_rate);
-
-	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
-
-	setup_irq(IRQ_OST0, &pxa_ost0_irq);
-
-	clocksource_mmio_init(OSCR, "oscr0", clock_tick_rate, 200, 32,
-		clocksource_mmio_readl_up);
-	clockevents_config_and_register(&ckevt_pxa_osmr0, clock_tick_rate,
-		MIN_OSCR_DELTA * 2, 0x7fffffff);
-}
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 50384fe..8296f7f 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -211,7 +211,7 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 void update_vsyscall(struct timekeeper *tk)
 {
 	struct timespec xtime_coarse;
-	u32 use_syscall = strcmp(tk->clock->name, "arch_sys_counter");
+	u32 use_syscall = strcmp(tk->tkr.clock->name, "arch_sys_counter");
 
 	++vdso_data->tb_seq_count;
 	smp_wmb();
@@ -224,11 +224,11 @@ void update_vsyscall(struct timekeeper *tk)
 	vdso_data->wtm_clock_nsec		= tk->wall_to_monotonic.tv_nsec;
 
 	if (!use_syscall) {
-		vdso_data->cs_cycle_last	= tk->clock->cycle_last;
+		vdso_data->cs_cycle_last	= tk->tkr.cycle_last;
 		vdso_data->xtime_clock_sec	= tk->xtime_sec;
-		vdso_data->xtime_clock_nsec	= tk->xtime_nsec;
-		vdso_data->cs_mult		= tk->mult;
-		vdso_data->cs_shift		= tk->shift;
+		vdso_data->xtime_clock_nsec	= tk->tkr.xtime_nsec;
+		vdso_data->cs_mult		= tk->tkr.mult;
+		vdso_data->cs_shift		= tk->tkr.shift;
 	}
 
 	smp_wmb();
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 0fd6138..4dc89d1 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -23,7 +23,6 @@ config HEXAGON
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select STACKTRACE_SUPPORT
-	select KTIME_SCALAR
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select MODULES_USE_ELF_RELA
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 71c52bc..3e71ef8 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -441,7 +441,7 @@ void update_vsyscall_tz(void)
 }
 
 void update_vsyscall_old(struct timespec *wall, struct timespec *wtm,
-			struct clocksource *c, u32 mult)
+			 struct clocksource *c, u32 mult, cycle_t cycle_last)
 {
 	write_seqcount_begin(&fsyscall_gtod_data.seq);
 
@@ -450,7 +450,7 @@ void update_vsyscall_old(struct timespec *wall, struct timespec *wtm,
         fsyscall_gtod_data.clk_mult = mult;
         fsyscall_gtod_data.clk_shift = c->shift;
         fsyscall_gtod_data.clk_fsys_mmio = c->archdata.fsys_mmio;
-        fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
+        fsyscall_gtod_data.clk_cycle_last = cycle_last;
 
 	/* copy kernel time structures */
         fsyscall_gtod_data.wall_time.tv_sec = wall->tv_sec;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 9fff9cd..368ab37 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -741,7 +741,7 @@ static cycle_t timebase_read(struct clocksource *cs)
 }
 
 void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
-			struct clocksource *clock, u32 mult)
+			 struct clocksource *clock, u32 mult, cycle_t cycle_last)
 {
 	u64 new_tb_to_xs, new_stamp_xsec;
 	u32 frac_sec;
@@ -774,7 +774,7 @@ void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
 	 * We expect the caller to have done the first increment of
 	 * vdso_data->tb_update_count already.
 	 */
-	vdso_data->tb_orig_stamp = clock->cycle_last;
+	vdso_data->tb_orig_stamp = cycle_last;
 	vdso_data->stamp_xsec = new_stamp_xsec;
 	vdso_data->tb_to_xs = new_tb_to_xs;
 	vdso_data->wtom_clock_sec = wtm->tv_sec;
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index f85db3a..2930d1e 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -611,7 +611,6 @@ static int __init create_spu(void *data)
 	int ret;
 	static int number;
 	unsigned long flags;
-	struct timespec ts;
 
 	ret = -ENOMEM;
 	spu = kzalloc(sizeof (*spu), GFP_KERNEL);
@@ -652,8 +651,7 @@ static int __init create_spu(void *data)
 	mutex_unlock(&spu_full_list_mutex);
 
 	spu->stats.util_state = SPU_UTIL_IDLE_LOADED;
-	ktime_get_ts(&ts);
-	spu->stats.tstamp = timespec_to_ns(&ts);
+	spu->stats.tstamp = ktime_get_ns();
 
 	INIT_LIST_HEAD(&spu->aff_list);
 
@@ -676,7 +674,6 @@ static const char *spu_state_names[] = {
 static unsigned long long spu_acct_time(struct spu *spu,
 		enum spu_utilization_state state)
 {
-	struct timespec ts;
 	unsigned long long time = spu->stats.times[state];
 
 	/*
@@ -684,10 +681,8 @@ static unsigned long long spu_acct_time(struct spu *spu,
 	 * statistics are not updated.  Apply the time delta from the
 	 * last recorded state of the spu.
 	 */
-	if (spu->stats.util_state == state) {
-		ktime_get_ts(&ts);
-		time += timespec_to_ns(&ts) - spu->stats.tstamp;
-	}
+	if (spu->stats.util_state == state)
+		time += ktime_get_ns() - spu->stats.tstamp;
 
 	return time / NSEC_PER_MSEC;
 }
diff --git a/arch/powerpc/platforms/cell/spufs/context.c b/arch/powerpc/platforms/cell/spufs/context.c
index 9c6790d..3b4152f 100644
--- a/arch/powerpc/platforms/cell/spufs/context.c
+++ b/arch/powerpc/platforms/cell/spufs/context.c
@@ -36,7 +36,6 @@ atomic_t nr_spu_contexts = ATOMIC_INIT(0);
 struct spu_context *alloc_spu_context(struct spu_gang *gang)
 {
 	struct spu_context *ctx;
-	struct timespec ts;
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
@@ -67,8 +66,7 @@ struct spu_context *alloc_spu_context(struct spu_gang *gang)
 	__spu_update_sched_info(ctx);
 	spu_set_timeslice(ctx);
 	ctx->stats.util_state = SPU_UTIL_IDLE_LOADED;
-	ktime_get_ts(&ts);
-	ctx->stats.tstamp = timespec_to_ns(&ts);
+	ctx->stats.tstamp = ktime_get_ns();
 
 	atomic_inc(&nr_spu_contexts);
 	goto out;
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 9098692..d966bbe 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -2338,7 +2338,6 @@ static const char *ctx_state_names[] = {
 static unsigned long long spufs_acct_time(struct spu_context *ctx,
 		enum spu_utilization_state state)
 {
-	struct timespec ts;
 	unsigned long long time = ctx->stats.times[state];
 
 	/*
@@ -2351,8 +2350,7 @@ static unsigned long long spufs_acct_time(struct spu_context *ctx,
 	 * of the spu context.
 	 */
 	if (ctx->spu && ctx->stats.util_state == state) {
-		ktime_get_ts(&ts);
-		time += timespec_to_ns(&ts) - ctx->stats.tstamp;
+		time += ktime_get_ns() - ctx->stats.tstamp;
 	}
 
 	return time / NSEC_PER_MSEC;
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 4a0a64f..998f632 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -1039,13 +1039,11 @@ void spuctx_switch_state(struct spu_context *ctx,
 {
 	unsigned long long curtime;
 	signed long long delta;
-	struct timespec ts;
 	struct spu *spu;
 	enum spu_utilization_state old_state;
 	int node;
 
-	ktime_get_ts(&ts);
-	curtime = timespec_to_ns(&ts);
+	curtime = ktime_get_ns();
 	delta = curtime - ctx->stats.tstamp;
 
 	WARN_ON(!mutex_is_locked(&ctx->state_mutex));
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bb63499..1afc7a6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -137,7 +137,6 @@ config S390
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16 if 32BIT
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select KTIME_SCALAR if 32BIT
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
 	select OLD_SIGACTION
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 0931b11..4cef607 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -214,26 +214,26 @@ void update_vsyscall(struct timekeeper *tk)
 {
 	u64 nsecps;
 
-	if (tk->clock != &clocksource_tod)
+	if (tk->tkr.clock != &clocksource_tod)
 		return;
 
 	/* Make userspace gettimeofday spin until we're done. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = tk->clock->cycle_last;
+	vdso_data->xtime_tod_stamp = tk->tkr.cycle_last;
 	vdso_data->xtime_clock_sec = tk->xtime_sec;
-	vdso_data->xtime_clock_nsec = tk->xtime_nsec;
+	vdso_data->xtime_clock_nsec = tk->tkr.xtime_nsec;
 	vdso_data->wtom_clock_sec =
 		tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
-	vdso_data->wtom_clock_nsec = tk->xtime_nsec +
-		+ ((u64) tk->wall_to_monotonic.tv_nsec << tk->shift);
-	nsecps = (u64) NSEC_PER_SEC << tk->shift;
+	vdso_data->wtom_clock_nsec = tk->tkr.xtime_nsec +
+		+ ((u64) tk->wall_to_monotonic.tv_nsec << tk->tkr.shift);
+	nsecps = (u64) NSEC_PER_SEC << tk->tkr.shift;
 	while (vdso_data->wtom_clock_nsec >= nsecps) {
 		vdso_data->wtom_clock_nsec -= nsecps;
 		vdso_data->wtom_clock_sec++;
 	}
-	vdso_data->tk_mult = tk->mult;
-	vdso_data->tk_shift = tk->shift;
+	vdso_data->tk_mult = tk->tkr.mult;
+	vdso_data->tk_shift = tk->tkr.shift;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 462dcd0..d8fbc28 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -260,9 +260,8 @@ void update_vsyscall_tz(void)
 
 void update_vsyscall(struct timekeeper *tk)
 {
-	struct timespec wall_time = tk_xtime(tk);
 	struct timespec *wtm = &tk->wall_to_monotonic;
-	struct clocksource *clock = tk->clock;
+	struct clocksource *clock = tk->tkr.clock;
 
 	if (clock != &cycle_counter_cs)
 		return;
@@ -270,13 +269,13 @@ void update_vsyscall(struct timekeeper *tk)
 	/* Userspace gettimeofday will spin while this value is odd. */
 	++vdso_data->tb_update_count;
 	smp_wmb();
-	vdso_data->xtime_tod_stamp = clock->cycle_last;
-	vdso_data->xtime_clock_sec = wall_time.tv_sec;
-	vdso_data->xtime_clock_nsec = wall_time.tv_nsec;
+	vdso_data->xtime_tod_stamp = tk->tkr.cycle_last;
+	vdso_data->xtime_clock_sec = tk->xtime_sec;
+	vdso_data->xtime_clock_nsec = tk->tkr.xtime_nsec;
 	vdso_data->wtom_clock_sec = wtm->tv_sec;
 	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
-	vdso_data->mult = clock->mult;
-	vdso_data->shift = clock->shift;
+	vdso_data->mult = tk->tkr.mult;
+	vdso_data->shift = tk->tkr.shift;
 	smp_wmb();
 	++vdso_data->tb_update_count;
 }
diff --git a/arch/tile/kernel/vdso/vgettimeofday.c b/arch/tile/kernel/vdso/vgettimeofday.c
index 51ec8e4..e933fb9 100644
--- a/arch/tile/kernel/vdso/vgettimeofday.c
+++ b/arch/tile/kernel/vdso/vgettimeofday.c
@@ -83,10 +83,11 @@ int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 		if (count & 1)
 			continue;
 
-		cycles = (get_cycles() - vdso_data->xtime_tod_stamp);
-		ns = (cycles * vdso_data->mult) >> vdso_data->shift;
 		sec = vdso_data->xtime_clock_sec;
-		ns += vdso_data->xtime_clock_nsec;
+		cycles = get_cycles() - vdso_data->xtime_tod_stamp;
+		ns = (cycles * vdso_data->mult) + vdso_data->xtime_clock_nsec;
+		ns >>= vdso_data->shift;
+
 		if (ns >= NSEC_PER_SEC) {
 			ns -= NSEC_PER_SEC;
 			sec += 1;
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..d08e061 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -109,9 +109,9 @@ config X86
 	select CLOCKSOURCE_WATCHDOG
 	select GENERIC_CLOCKEVENTS
 	select ARCH_CLOCKSOURCE_DATA
+	select CLOCKSOURCE_VALIDATE_LAST_CYCLE
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_TIME_VSYSCALL
-	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57e5ce1..456c0e6 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -951,7 +951,7 @@ core_initcall(cpufreq_tsc);
 static struct clocksource clocksource_tsc;
 
 /*
- * We compare the TSC to the cycle_last value in the clocksource
+ * We used to compare the TSC to the cycle_last value in the clocksource
  * structure to avoid a nasty time-warp. This can be observed in a
  * very small window right after one CPU updated cycle_last under
  * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
@@ -961,26 +961,23 @@ static struct clocksource clocksource_tsc;
  * due to the unsigned delta calculation of the time keeping core
  * code, which is necessary to support wrapping clocksources like pm
  * timer.
+ *
+ * This sanity check is now done in the core timekeeping code.
+ * checking the result of read_tsc() - cycle_last for being negative.
+ * That works because CLOCKSOURCE_MASK(64) does not mask out any bit.
  */
 static cycle_t read_tsc(struct clocksource *cs)
 {
-	cycle_t ret = (cycle_t)get_cycles();
-
-	return ret >= clocksource_tsc.cycle_last ?
-		ret : clocksource_tsc.cycle_last;
-}
-
-static void resume_tsc(struct clocksource *cs)
-{
-	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
-		clocksource_tsc.cycle_last = 0;
+	return (cycle_t)get_cycles();
 }
 
+/*
+ * .mask MUST be CLOCKSOURCE_MASK(64). See comment above read_tsc()
+ */
 static struct clocksource clocksource_tsc = {
 	.name                   = "tsc",
 	.rating                 = 300,
 	.read                   = read_tsc,
-	.resume			= resume_tsc,
 	.mask                   = CLOCKSOURCE_MASK(64),
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
index 9531fbb..c7d791f 100644
--- a/arch/x86/kernel/vsyscall_gtod.c
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -31,29 +31,30 @@ void update_vsyscall(struct timekeeper *tk)
 	gtod_write_begin(vdata);
 
 	/* copy vsyscall data */
-	vdata->vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->cycle_last	= tk->clock->cycle_last;
-	vdata->mask		= tk->clock->mask;
-	vdata->mult		= tk->mult;
-	vdata->shift		= tk->shift;
+	vdata->vclock_mode	= tk->tkr.clock->archdata.vclock_mode;
+	vdata->cycle_last	= tk->tkr.cycle_last;
+	vdata->mask		= tk->tkr.mask;
+	vdata->mult		= tk->tkr.mult;
+	vdata->shift		= tk->tkr.shift;
 
 	vdata->wall_time_sec		= tk->xtime_sec;
-	vdata->wall_time_snsec		= tk->xtime_nsec;
+	vdata->wall_time_snsec		= tk->tkr.xtime_nsec;
 
 	vdata->monotonic_time_sec	= tk->xtime_sec
 					+ tk->wall_to_monotonic.tv_sec;
-	vdata->monotonic_time_snsec	= tk->xtime_nsec
+	vdata->monotonic_time_snsec	= tk->tkr.xtime_nsec
 					+ ((u64)tk->wall_to_monotonic.tv_nsec
-						<< tk->shift);
+						<< tk->tkr.shift);
 	while (vdata->monotonic_time_snsec >=
-					(((u64)NSEC_PER_SEC) << tk->shift)) {
+					(((u64)NSEC_PER_SEC) << tk->tkr.shift)) {
 		vdata->monotonic_time_snsec -=
-					((u64)NSEC_PER_SEC) << tk->shift;
+					((u64)NSEC_PER_SEC) << tk->tkr.shift;
 		vdata->monotonic_time_sec++;
 	}
 
 	vdata->wall_time_coarse_sec	= tk->xtime_sec;
-	vdata->wall_time_coarse_nsec	= (long)(tk->xtime_nsec >> tk->shift);
+	vdata->wall_time_coarse_nsec	= (long)(tk->tkr.xtime_nsec >>
+						 tk->tkr.shift);
 
 	vdata->monotonic_time_coarse_sec =
 		vdata->wall_time_coarse_sec + tk->wall_to_monotonic.tv_sec;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f644933..b7e5794 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -984,9 +984,8 @@ struct pvclock_gtod_data {
 		u32	shift;
 	} clock;
 
-	/* open coded 'struct timespec' */
-	u64		monotonic_time_snsec;
-	time_t		monotonic_time_sec;
+	u64		boot_ns;
+	u64		nsec_base;
 };
 
 static struct pvclock_gtod_data pvclock_gtod_data;
@@ -994,27 +993,21 @@ static struct pvclock_gtod_data pvclock_gtod_data;
 static void update_pvclock_gtod(struct timekeeper *tk)
 {
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
+	u64 boot_ns;
+
+	boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
 
 	write_seqcount_begin(&vdata->seq);
 
 	/* copy pvclock gtod data */
-	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
-	vdata->clock.cycle_last		= tk->clock->cycle_last;
-	vdata->clock.mask		= tk->clock->mask;
-	vdata->clock.mult		= tk->mult;
-	vdata->clock.shift		= tk->shift;
-
-	vdata->monotonic_time_sec	= tk->xtime_sec
-					+ tk->wall_to_monotonic.tv_sec;
-	vdata->monotonic_time_snsec	= tk->xtime_nsec
-					+ (tk->wall_to_monotonic.tv_nsec
-						<< tk->shift);
-	while (vdata->monotonic_time_snsec >=
-					(((u64)NSEC_PER_SEC) << tk->shift)) {
-		vdata->monotonic_time_snsec -=
-					((u64)NSEC_PER_SEC) << tk->shift;
-		vdata->monotonic_time_sec++;
-	}
+	vdata->clock.vclock_mode	= tk->tkr.clock->archdata.vclock_mode;
+	vdata->clock.cycle_last		= tk->tkr.cycle_last;
+	vdata->clock.mask		= tk->tkr.mask;
+	vdata->clock.mult		= tk->tkr.mult;
+	vdata->clock.shift		= tk->tkr.shift;
+
+	vdata->boot_ns			= boot_ns;
+	vdata->nsec_base		= tk->tkr.xtime_nsec;
 
 	write_seqcount_end(&vdata->seq);
 }
@@ -1109,11 +1102,7 @@ static void kvm_get_time_scale(uint32_t scaled_khz, uint32_t base_khz,
 
 static inline u64 get_kernel_ns(void)
 {
-	struct timespec ts;
-
-	ktime_get_ts(&ts);
-	monotonic_to_bootbased(&ts);
-	return timespec_to_ns(&ts);
+	return ktime_get_boot_ns();
 }
 
 #ifdef CONFIG_X86_64
@@ -1375,23 +1364,22 @@ static inline u64 vgettsc(cycle_t *cycle_now)
 	return v * gtod->clock.mult;
 }
 
-static int do_monotonic(struct timespec *ts, cycle_t *cycle_now)
+static int do_monotonic_boot(s64 *t, cycle_t *cycle_now)
 {
+	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
 	unsigned long seq;
-	u64 ns;
 	int mode;
-	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
+	u64 ns;
 
-	ts->tv_nsec = 0;
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
-		ts->tv_sec = gtod->monotonic_time_sec;
-		ns = gtod->monotonic_time_snsec;
+		ns = gtod->nsec_base;
 		ns += vgettsc(cycle_now);
 		ns >>= gtod->clock.shift;
+		ns += gtod->boot_ns;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-	timespec_add_ns(ts, ns);
+	*t = ns;
 
 	return mode;
 }
@@ -1399,19 +1387,11 @@ static int do_monotonic(struct timespec *ts, cycle_t *cycle_now)
 /* returns true if host is using tsc clocksource */
 static bool kvm_get_time_and_clockread(s64 *kernel_ns, cycle_t *cycle_now)
 {
-	struct timespec ts;
-
 	/* checked again under seqlock below */
 	if (pvclock_gtod_data.clock.vclock_mode != VCLOCK_TSC)
 		return false;
 
-	if (do_monotonic(&ts, cycle_now) != VCLOCK_TSC)
-		return false;
-
-	monotonic_to_bootbased(&ts);
-	*kernel_ns = timespec_to_ns(&ts);
-
-	return true;
+	return do_monotonic_boot(kernel_ns, cycle_now) == VCLOCK_TSC;
 }
 #endif
 
diff --git a/drivers/char/hangcheck-timer.c b/drivers/char/hangcheck-timer.c
index f953c96..ebc4c73 100644
--- a/drivers/char/hangcheck-timer.c
+++ b/drivers/char/hangcheck-timer.c
@@ -49,7 +49,7 @@
 #include <asm/uaccess.h>
 #include <linux/sysrq.h>
 #include <linux/timer.h>
-#include <linux/time.h>
+#include <linux/hrtimer.h>
 
 #define VERSION_STR "0.9.1"
 
@@ -117,24 +117,7 @@ __setup("hcheck_reboot", hangcheck_parse_reboot);
 __setup("hcheck_dump_tasks", hangcheck_parse_dump_tasks);
 #endif /* not MODULE */
 
-#if defined(CONFIG_S390)
-# define HAVE_MONOTONIC
-# define TIMER_FREQ 1000000000ULL
-#else
-# define TIMER_FREQ 1000000000ULL
-#endif
-
-#ifdef HAVE_MONOTONIC
-extern unsigned long long monotonic_clock(void);
-#else
-static inline unsigned long long monotonic_clock(void)
-{
-	struct timespec ts;
-	getrawmonotonic(&ts);
-	return timespec_to_ns(&ts);
-}
-#endif  /* HAVE_MONOTONIC */
-
+#define TIMER_FREQ 1000000000ULL
 
 /* Last time scheduled */
 static unsigned long long hangcheck_tsc, hangcheck_tsc_margin;
@@ -143,12 +126,11 @@ static void hangcheck_fire(unsigned long);
 
 static DEFINE_TIMER(hangcheck_ticktock, hangcheck_fire, 0, 0);
 
-
 static void hangcheck_fire(unsigned long data)
 {
 	unsigned long long cur_tsc, tsc_diff;
 
-	cur_tsc = monotonic_clock();
+	cur_tsc = ktime_get_ns();
 
 	if (cur_tsc > hangcheck_tsc)
 		tsc_diff = cur_tsc - hangcheck_tsc;
@@ -177,7 +159,7 @@ static void hangcheck_fire(unsigned long data)
 			tsc_diff, tsc_diff - hangcheck_tick*TIMER_FREQ);
 #endif
 	mod_timer(&hangcheck_ticktock, jiffies + (hangcheck_tick*HZ));
-	hangcheck_tsc = monotonic_clock();
+	hangcheck_tsc = ktime_get_ns();
 }
 
 
@@ -185,16 +167,11 @@ static int __init hangcheck_init(void)
 {
 	printk("Hangcheck: starting hangcheck timer %s (tick is %d seconds, margin is %d seconds).\n",
 	       VERSION_STR, hangcheck_tick, hangcheck_margin);
-#if defined (HAVE_MONOTONIC)
-	printk("Hangcheck: Using monotonic_clock().\n");
-#else
-	printk("Hangcheck: Using getrawmonotonic().\n");
-#endif  /* HAVE_MONOTONIC */
 	hangcheck_tsc_margin =
 		(unsigned long long)(hangcheck_margin + hangcheck_tick);
 	hangcheck_tsc_margin *= (unsigned long long)TIMER_FREQ;
 
-	hangcheck_tsc = monotonic_clock();
+	hangcheck_tsc = ktime_get_ns();
 	mod_timer(&hangcheck_ticktock, jiffies + (hangcheck_tick*HZ));
 
 	return 0;
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 065131c..cfd6519 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -1,3 +1,5 @@
+menu "Clock Source drivers"
+
 config CLKSRC_OF
 	bool
 
@@ -125,6 +127,7 @@ config CLKSRC_METAG_GENERIC
 
 config CLKSRC_EXYNOS_MCT
 	def_bool y if ARCH_EXYNOS
+	depends on !ARM64
 	help
 	  Support for Multi Core Timer controller on Exynos SoCs.
 
@@ -149,6 +152,11 @@ config VF_PIT_TIMER
 config SYS_SUPPORTS_SH_CMT
         bool
 
+config MTK_TIMER
+	select CLKSRC_OF
+	select CLKSRC_MMIO
+	bool
+
 config SYS_SUPPORTS_SH_MTU2
         bool
 
@@ -173,7 +181,7 @@ config SH_TIMER_MTU2
 	default SYS_SUPPORTS_SH_MTU2
 	help
 	  This enables build of a clockevent driver for the Multi-Function
-	  Timer Pulse Unit 2 (TMU2) hardware available on SoCs from Renesas.
+	  Timer Pulse Unit 2 (MTU2) hardware available on SoCs from Renesas.
 	  This hardware comes with 16 bit-timer registers.
 
 config SH_TIMER_TMU
@@ -187,7 +195,7 @@ config SH_TIMER_TMU
 
 config EM_TIMER_STI
 	bool "Renesas STI timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_EM_STI
 	help
 	  This enables build of a clocksource and clockevent driver for
@@ -207,3 +215,5 @@ config CLKSRC_VERSATILE
 	  counter available in the "System Registers" block of
 	  ARM Versatile, RealView and Versatile Express reference
 	  platforms.
+
+endmenu
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 800b130..7fd9fd1 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -16,9 +16,11 @@ obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+= clksrc-dbx500-prcmu.o
 obj-$(CONFIG_ARMADA_370_XP_TIMER)	+= time-armada-370-xp.o
 obj-$(CONFIG_ORION_TIMER)	+= time-orion.o
 obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
+obj-$(CONFIG_ARCH_CLPS711X)	+= clps711x-timer.o
 obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
+obj-$(CONFIG_ARCH_PXA)		+= pxa_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
@@ -34,6 +36,7 @@ obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
 obj-$(CONFIG_FSL_FTM_TIMER)	+= fsl_ftm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
 obj-$(CONFIG_CLKSRC_QCOM)	+= qcom-timer.o
+obj-$(CONFIG_MTK_TIMER)		+= mtk_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
diff --git a/drivers/clocksource/clps711x-timer.c b/drivers/clocksource/clps711x-timer.c
new file mode 100644
index 0000000..d83ec1f
--- /dev/null
+++ b/drivers/clocksource/clps711x-timer.c
@@ -0,0 +1,131 @@
+/*
+ *  Cirrus Logic CLPS711X clocksource driver
+ *
+ *  Copyright (C) 2014 Alexander Shiyan <shc_work@mail.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/sched_clock.h>
+#include <linux/slab.h>
+
+enum {
+	CLPS711X_CLKSRC_CLOCKSOURCE,
+	CLPS711X_CLKSRC_CLOCKEVENT,
+};
+
+static void __iomem *tcd;
+
+static u64 notrace clps711x_sched_clock_read(void)
+{
+	return ~readw(tcd);
+}
+
+static int __init _clps711x_clksrc_init(struct clk *clock, void __iomem *base)
+{
+	unsigned long rate;
+
+	if (!base)
+		return -ENOMEM;
+	if (IS_ERR(clock))
+		return PTR_ERR(clock);
+
+	rate = clk_get_rate(clock);
+
+	tcd = base;
+
+	clocksource_mmio_init(tcd, "clps711x-clocksource", rate, 300, 16,
+			      clocksource_mmio_readw_down);
+
+	sched_clock_register(clps711x_sched_clock_read, 16, rate);
+
+	return 0;
+}
+
+static irqreturn_t clps711x_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static void clps711x_clockevent_set_mode(enum clock_event_mode mode,
+					 struct clock_event_device *evt)
+{
+}
+
+static int __init _clps711x_clkevt_init(struct clk *clock, void __iomem *base,
+					unsigned int irq)
+{
+	struct clock_event_device *clkevt;
+	unsigned long rate;
+
+	if (!irq)
+		return -EINVAL;
+	if (!base)
+		return -ENOMEM;
+	if (IS_ERR(clock))
+		return PTR_ERR(clock);
+
+	clkevt = kzalloc(sizeof(*clkevt), GFP_KERNEL);
+	if (!clkevt)
+		return -ENOMEM;
+
+	rate = clk_get_rate(clock);
+
+	/* Set Timer prescaler */
+	writew(DIV_ROUND_CLOSEST(rate, HZ), base);
+
+	clkevt->name = "clps711x-clockevent";
+	clkevt->rating = 300;
+	clkevt->features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_C3STOP;
+	clkevt->set_mode = clps711x_clockevent_set_mode;
+	clkevt->cpumask = cpumask_of(0);
+	clockevents_config_and_register(clkevt, HZ, 0, 0);
+
+	return request_irq(irq, clps711x_timer_interrupt, IRQF_TIMER,
+			   "clps711x-timer", clkevt);
+}
+
+void __init clps711x_clksrc_init(void __iomem *tc1_base, void __iomem *tc2_base,
+				 unsigned int irq)
+{
+	struct clk *tc1 = clk_get_sys("clps711x-timer.0", NULL);
+	struct clk *tc2 = clk_get_sys("clps711x-timer.1", NULL);
+
+	BUG_ON(_clps711x_clksrc_init(tc1, tc1_base));
+	BUG_ON(_clps711x_clkevt_init(tc2, tc2_base, irq));
+}
+
+#ifdef CONFIG_CLKSRC_OF
+static void __init clps711x_timer_init(struct device_node *np)
+{
+	unsigned int irq = irq_of_parse_and_map(np, 0);
+	struct clk *clock = of_clk_get(np, 0);
+	void __iomem *base = of_iomap(np, 0);
+
+	switch (of_alias_get_id(np, "timer")) {
+	case CLPS711X_CLKSRC_CLOCKSOURCE:
+		BUG_ON(_clps711x_clksrc_init(clock, base));
+		break;
+	case CLPS711X_CLKSRC_CLOCKEVENT:
+		BUG_ON(_clps711x_clkevt_init(clock, base, irq));
+		break;
+	default:
+		break;
+	}
+}
+CLOCKSOURCE_OF_DECLARE(clps711x, "cirrus,clps711x-timer", clps711x_timer_init);
+#endif
diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index ab51bf20a..9403061 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -94,7 +94,7 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 	u32 mask;
 	u32 i;
 
-	__raw_writel(value, reg_base + offset);
+	writel_relaxed(value, reg_base + offset);
 
 	if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
 		stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
@@ -144,8 +144,8 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 
 	/* Wait maximum 1 ms until written values are applied */
 	for (i = 0; i < loops_per_jiffy / 1000 * HZ; i++)
-		if (__raw_readl(reg_base + stat_addr) & mask) {
-			__raw_writel(mask, reg_base + stat_addr);
+		if (readl_relaxed(reg_base + stat_addr) & mask) {
+			writel_relaxed(mask, reg_base + stat_addr);
 			return;
 		}
 
@@ -157,28 +157,51 @@ static void exynos4_mct_frc_start(void)
 {
 	u32 reg;
 
-	reg = __raw_readl(reg_base + EXYNOS4_MCT_G_TCON);
+	reg = readl_relaxed(reg_base + EXYNOS4_MCT_G_TCON);
 	reg |= MCT_G_TCON_START;
 	exynos4_mct_write(reg, EXYNOS4_MCT_G_TCON);
 }
 
-static cycle_t notrace _exynos4_frc_read(void)
+/**
+ * exynos4_read_count_64 - Read all 64-bits of the global counter
+ *
+ * This will read all 64-bits of the global counter taking care to make sure
+ * that the upper and lower half match.  Note that reading the MCT can be quite
+ * slow (hundreds of nanoseconds) so you should use the 32-bit (lower half
+ * only) version when possible.
+ *
+ * Returns the number of cycles in the global counter.
+ */
+static u64 exynos4_read_count_64(void)
 {
 	unsigned int lo, hi;
-	u32 hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
+	u32 hi2 = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_U);
 
 	do {
 		hi = hi2;
-		lo = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
-		hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
+		lo = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_L);
+		hi2 = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_U);
 	} while (hi != hi2);
 
 	return ((cycle_t)hi << 32) | lo;
 }
 
+/**
+ * exynos4_read_count_32 - Read the lower 32-bits of the global counter
+ *
+ * This will read just the lower 32-bits of the global counter.  This is marked
+ * as notrace so it can be used by the scheduler clock.
+ *
+ * Returns the number of cycles in the global counter (lower 32 bits).
+ */
+static u32 notrace exynos4_read_count_32(void)
+{
+	return readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_L);
+}
+
 static cycle_t exynos4_frc_read(struct clocksource *cs)
 {
-	return _exynos4_frc_read();
+	return exynos4_read_count_32();
 }
 
 static void exynos4_frc_resume(struct clocksource *cs)
@@ -190,21 +213,23 @@ struct clocksource mct_frc = {
 	.name		= "mct-frc",
 	.rating		= 400,
 	.read		= exynos4_frc_read,
-	.mask		= CLOCKSOURCE_MASK(64),
+	.mask		= CLOCKSOURCE_MASK(32),
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= exynos4_frc_resume,
 };
 
 static u64 notrace exynos4_read_sched_clock(void)
 {
-	return _exynos4_frc_read();
+	return exynos4_read_count_32();
 }
 
 static struct delay_timer exynos4_delay_timer;
 
 static cycles_t exynos4_read_current_timer(void)
 {
-	return _exynos4_frc_read();
+	BUILD_BUG_ON_MSG(sizeof(cycles_t) != sizeof(u32),
+			 "cycles_t needs to move to 32-bit for ARM64 usage");
+	return exynos4_read_count_32();
 }
 
 static void __init exynos4_clocksource_init(void)
@@ -218,14 +243,14 @@ static void __init exynos4_clocksource_init(void)
 	if (clocksource_register_hz(&mct_frc, clk_rate))
 		panic("%s: can't register clocksource\n", mct_frc.name);
 
-	sched_clock_register(exynos4_read_sched_clock, 64, clk_rate);
+	sched_clock_register(exynos4_read_sched_clock, 32, clk_rate);
 }
 
 static void exynos4_mct_comp0_stop(void)
 {
 	unsigned int tcon;
 
-	tcon = __raw_readl(reg_base + EXYNOS4_MCT_G_TCON);
+	tcon = readl_relaxed(reg_base + EXYNOS4_MCT_G_TCON);
 	tcon &= ~(MCT_G_TCON_COMP0_ENABLE | MCT_G_TCON_COMP0_AUTO_INC);
 
 	exynos4_mct_write(tcon, EXYNOS4_MCT_G_TCON);
@@ -238,14 +263,14 @@ static void exynos4_mct_comp0_start(enum clock_event_mode mode,
 	unsigned int tcon;
 	cycle_t comp_cycle;
 
-	tcon = __raw_readl(reg_base + EXYNOS4_MCT_G_TCON);
+	tcon = readl_relaxed(reg_base + EXYNOS4_MCT_G_TCON);
 
 	if (mode == CLOCK_EVT_MODE_PERIODIC) {
 		tcon |= MCT_G_TCON_COMP0_AUTO_INC;
 		exynos4_mct_write(cycles, EXYNOS4_MCT_G_COMP0_ADD_INCR);
 	}
 
-	comp_cycle = exynos4_frc_read(&mct_frc) + cycles;
+	comp_cycle = exynos4_read_count_64() + cycles;
 	exynos4_mct_write((u32)comp_cycle, EXYNOS4_MCT_G_COMP0_L);
 	exynos4_mct_write((u32)(comp_cycle >> 32), EXYNOS4_MCT_G_COMP0_U);
 
@@ -327,7 +352,7 @@ static void exynos4_mct_tick_stop(struct mct_clock_event_device *mevt)
 	unsigned long mask = MCT_L_TCON_INT_START | MCT_L_TCON_TIMER_START;
 	unsigned long offset = mevt->base + MCT_L_TCON_OFFSET;
 
-	tmp = __raw_readl(reg_base + offset);
+	tmp = readl_relaxed(reg_base + offset);
 	if (tmp & mask) {
 		tmp &= ~mask;
 		exynos4_mct_write(tmp, offset);
@@ -349,7 +374,7 @@ static void exynos4_mct_tick_start(unsigned long cycles,
 	/* enable MCT tick interrupt */
 	exynos4_mct_write(0x1, mevt->base + MCT_L_INT_ENB_OFFSET);
 
-	tmp = __raw_readl(reg_base + mevt->base + MCT_L_TCON_OFFSET);
+	tmp = readl_relaxed(reg_base + mevt->base + MCT_L_TCON_OFFSET);
 	tmp |= MCT_L_TCON_INT_START | MCT_L_TCON_TIMER_START |
 	       MCT_L_TCON_INTERVAL_MODE;
 	exynos4_mct_write(tmp, mevt->base + MCT_L_TCON_OFFSET);
@@ -401,7 +426,7 @@ static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
 		exynos4_mct_tick_stop(mevt);
 
 	/* Clear the MCT tick interrupt */
-	if (__raw_readl(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
+	if (readl_relaxed(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
 		exynos4_mct_write(0x1, mevt->base + MCT_L_INT_CSTAT_OFFSET);
 		return 1;
 	} else {
diff --git a/drivers/clocksource/mtk_timer.c b/drivers/clocksource/mtk_timer.c
new file mode 100644
index 0000000..32a3d25
--- /dev/null
+++ b/drivers/clocksource/mtk_timer.c
@@ -0,0 +1,261 @@
+/*
+ * Mediatek SoCs General-Purpose Timer handling.
+ *
+ * Copyright (C) 2014 Matthias Brugger
+ *
+ * Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqreturn.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/slab.h>
+
+#define GPT_IRQ_EN_REG		0x00
+#define GPT_IRQ_ENABLE(val)	BIT((val) - 1)
+#define GPT_IRQ_ACK_REG		0x08
+#define GPT_IRQ_ACK(val)	BIT((val) - 1)
+
+#define TIMER_CTRL_REG(val)	(0x10 * (val))
+#define TIMER_CTRL_OP(val)	(((val) & 0x3) << 4)
+#define TIMER_CTRL_OP_ONESHOT	(0)
+#define TIMER_CTRL_OP_REPEAT	(1)
+#define TIMER_CTRL_OP_FREERUN	(3)
+#define TIMER_CTRL_CLEAR	(2)
+#define TIMER_CTRL_ENABLE	(1)
+#define TIMER_CTRL_DISABLE	(0)
+
+#define TIMER_CLK_REG(val)	(0x04 + (0x10 * (val)))
+#define TIMER_CLK_SRC(val)	(((val) & 0x1) << 4)
+#define TIMER_CLK_SRC_SYS13M	(0)
+#define TIMER_CLK_SRC_RTC32K	(1)
+#define TIMER_CLK_DIV1		(0x0)
+#define TIMER_CLK_DIV2		(0x1)
+
+#define TIMER_CNT_REG(val)	(0x08 + (0x10 * (val)))
+#define TIMER_CMP_REG(val)	(0x0C + (0x10 * (val)))
+
+#define GPT_CLK_EVT	1
+#define GPT_CLK_SRC	2
+
+struct mtk_clock_event_device {
+	void __iomem *gpt_base;
+	u32 ticks_per_jiffy;
+	struct clock_event_device dev;
+};
+
+static inline struct mtk_clock_event_device *to_mtk_clk(
+				struct clock_event_device *c)
+{
+	return container_of(c, struct mtk_clock_event_device, dev);
+}
+
+static void mtk_clkevt_time_stop(struct mtk_clock_event_device *evt, u8 timer)
+{
+	u32 val;
+
+	val = readl(evt->gpt_base + TIMER_CTRL_REG(timer));
+	writel(val & ~TIMER_CTRL_ENABLE, evt->gpt_base +
+			TIMER_CTRL_REG(timer));
+}
+
+static void mtk_clkevt_time_setup(struct mtk_clock_event_device *evt,
+				unsigned long delay, u8 timer)
+{
+	writel(delay, evt->gpt_base + TIMER_CMP_REG(timer));
+}
+
+static void mtk_clkevt_time_start(struct mtk_clock_event_device *evt,
+		bool periodic, u8 timer)
+{
+	u32 val;
+
+	/* Acknowledge interrupt */
+	writel(GPT_IRQ_ACK(timer), evt->gpt_base + GPT_IRQ_ACK_REG);
+
+	val = readl(evt->gpt_base + TIMER_CTRL_REG(timer));
+
+	/* Clear 2 bit timer operation mode field */
+	val &= ~TIMER_CTRL_OP(0x3);
+
+	if (periodic)
+		val |= TIMER_CTRL_OP(TIMER_CTRL_OP_REPEAT);
+	else
+		val |= TIMER_CTRL_OP(TIMER_CTRL_OP_ONESHOT);
+
+	writel(val | TIMER_CTRL_ENABLE | TIMER_CTRL_CLEAR,
+	       evt->gpt_base + TIMER_CTRL_REG(timer));
+}
+
+static void mtk_clkevt_mode(enum clock_event_mode mode,
+				struct clock_event_device *clk)
+{
+	struct mtk_clock_event_device *evt = to_mtk_clk(clk);
+
+	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		mtk_clkevt_time_setup(evt, evt->ticks_per_jiffy, GPT_CLK_EVT);
+		mtk_clkevt_time_start(evt, true, GPT_CLK_EVT);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* Timer is enabled in set_next_event */
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	default:
+		/* No more interrupts will occur as source is disabled */
+		break;
+	}
+}
+
+static int mtk_clkevt_next_event(unsigned long event,
+				   struct clock_event_device *clk)
+{
+	struct mtk_clock_event_device *evt = to_mtk_clk(clk);
+
+	mtk_clkevt_time_stop(evt, GPT_CLK_EVT);
+	mtk_clkevt_time_setup(evt, event, GPT_CLK_EVT);
+	mtk_clkevt_time_start(evt, false, GPT_CLK_EVT);
+
+	return 0;
+}
+
+static irqreturn_t mtk_timer_interrupt(int irq, void *dev_id)
+{
+	struct mtk_clock_event_device *evt = dev_id;
+
+	/* Acknowledge timer0 irq */
+	writel(GPT_IRQ_ACK(GPT_CLK_EVT), evt->gpt_base + GPT_IRQ_ACK_REG);
+	evt->dev.event_handler(&evt->dev);
+
+	return IRQ_HANDLED;
+}
+
+static void mtk_timer_global_reset(struct mtk_clock_event_device *evt)
+{
+	/* Disable all interrupts */
+	writel(0x0, evt->gpt_base + GPT_IRQ_EN_REG);
+	/* Acknowledge all interrupts */
+	writel(0x3f, evt->gpt_base + GPT_IRQ_ACK_REG);
+}
+
+static void
+mtk_timer_setup(struct mtk_clock_event_device *evt, u8 timer, u8 option)
+{
+	writel(TIMER_CTRL_CLEAR | TIMER_CTRL_DISABLE,
+		evt->gpt_base + TIMER_CTRL_REG(timer));
+
+	writel(TIMER_CLK_SRC(TIMER_CLK_SRC_SYS13M) | TIMER_CLK_DIV1,
+			evt->gpt_base + TIMER_CLK_REG(timer));
+
+	writel(0x0, evt->gpt_base + TIMER_CMP_REG(timer));
+
+	writel(TIMER_CTRL_OP(option) | TIMER_CTRL_ENABLE,
+			evt->gpt_base + TIMER_CTRL_REG(timer));
+}
+
+static void mtk_timer_enable_irq(struct mtk_clock_event_device *evt, u8 timer)
+{
+	u32 val;
+
+	val = readl(evt->gpt_base + GPT_IRQ_EN_REG);
+	writel(val | GPT_IRQ_ENABLE(timer),
+			evt->gpt_base + GPT_IRQ_EN_REG);
+}
+
+static void __init mtk_timer_init(struct device_node *node)
+{
+	struct mtk_clock_event_device *evt;
+	struct resource res;
+	unsigned long rate = 0;
+	struct clk *clk;
+
+	evt = kzalloc(sizeof(*evt), GFP_KERNEL);
+	if (!evt) {
+		pr_warn("Can't allocate mtk clock event driver struct");
+		return;
+	}
+
+	evt->dev.name = "mtk_tick";
+	evt->dev.rating = 300;
+	evt->dev.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT;
+	evt->dev.set_mode = mtk_clkevt_mode;
+	evt->dev.set_next_event = mtk_clkevt_next_event;
+	evt->dev.cpumask = cpu_possible_mask;
+
+	evt->gpt_base = of_io_request_and_map(node, 0, "mtk-timer");
+	if (IS_ERR(evt->gpt_base)) {
+		pr_warn("Can't get resource\n");
+		return;
+	}
+
+	evt->dev.irq = irq_of_parse_and_map(node, 0);
+	if (evt->dev.irq <= 0) {
+		pr_warn("Can't parse IRQ");
+		goto err_mem;
+	}
+
+	clk = of_clk_get(node, 0);
+	if (IS_ERR(clk)) {
+		pr_warn("Can't get timer clock");
+		goto err_irq;
+	}
+
+	if (clk_prepare_enable(clk)) {
+		pr_warn("Can't prepare clock");
+		goto err_clk_put;
+	}
+	rate = clk_get_rate(clk);
+
+	if (request_irq(evt->dev.irq, mtk_timer_interrupt,
+			IRQF_TIMER | IRQF_IRQPOLL, "mtk_timer", evt)) {
+		pr_warn("failed to setup irq %d\n", evt->dev.irq);
+		goto err_clk_disable;
+	}
+
+	evt->ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
+
+	mtk_timer_global_reset(evt);
+
+	/* Configure clock source */
+	mtk_timer_setup(evt, GPT_CLK_SRC, TIMER_CTRL_OP_FREERUN);
+	clocksource_mmio_init(evt->gpt_base + TIMER_CNT_REG(GPT_CLK_SRC),
+			node->name, rate, 300, 32, clocksource_mmio_readl_up);
+
+	/* Configure clock event */
+	mtk_timer_setup(evt, GPT_CLK_EVT, TIMER_CTRL_OP_REPEAT);
+	mtk_timer_enable_irq(evt, GPT_CLK_EVT);
+
+	clockevents_config_and_register(&evt->dev, rate, 0x3,
+					0xffffffff);
+	return;
+
+err_clk_disable:
+	clk_disable_unprepare(clk);
+err_clk_put:
+	clk_put(clk);
+err_irq:
+	irq_dispose_mapping(evt->dev.irq);
+err_mem:
+	iounmap(evt->gpt_base);
+	of_address_to_resource(node, 0, &res);
+	release_mem_region(res.start, resource_size(&res));
+}
+CLOCKSOURCE_OF_DECLARE(mtk_mt6577, "mediatek,mt6577-timer", mtk_timer_init);
diff --git a/drivers/clocksource/pxa_timer.c b/drivers/clocksource/pxa_timer.c
new file mode 100644
index 0000000..941f3f3
--- /dev/null
+++ b/drivers/clocksource/pxa_timer.c
@@ -0,0 +1,227 @@
+/*
+ * arch/arm/mach-pxa/time.c
+ *
+ * PXA clocksource, clockevents, and OST interrupt handlers.
+ * Copyright (c) 2007 by Bill Gatliff <bgat@billgatliff.com>.
+ *
+ * Derived from Nicolas Pitre's PXA timer handler Copyright (c) 2001
+ * by MontaVista Software, Inc.  (Nico, your code rocks!)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/sched_clock.h>
+
+#include <asm/div64.h>
+
+#define OSMR0		0x00	/* OS Timer 0 Match Register */
+#define OSMR1		0x04	/* OS Timer 1 Match Register */
+#define OSMR2		0x08	/* OS Timer 2 Match Register */
+#define OSMR3		0x0C	/* OS Timer 3 Match Register */
+
+#define OSCR		0x10	/* OS Timer Counter Register */
+#define OSSR		0x14	/* OS Timer Status Register */
+#define OWER		0x18	/* OS Timer Watchdog Enable Register */
+#define OIER		0x1C	/* OS Timer Interrupt Enable Register */
+
+#define OSSR_M3		(1 << 3)	/* Match status channel 3 */
+#define OSSR_M2		(1 << 2)	/* Match status channel 2 */
+#define OSSR_M1		(1 << 1)	/* Match status channel 1 */
+#define OSSR_M0		(1 << 0)	/* Match status channel 0 */
+
+#define OIER_E0		(1 << 0)	/* Interrupt enable channel 0 */
+
+/*
+ * This is PXA's sched_clock implementation. This has a resolution
+ * of at least 308 ns and a maximum value of 208 days.
+ *
+ * The return value is guaranteed to be monotonic in that range as
+ * long as there is always less than 582 seconds between successive
+ * calls to sched_clock() which should always be the case in practice.
+ */
+
+#define timer_readl(reg) readl_relaxed(timer_base + (reg))
+#define timer_writel(val, reg) writel_relaxed((val), timer_base + (reg))
+
+static void __iomem *timer_base;
+
+static u64 notrace pxa_read_sched_clock(void)
+{
+	return timer_readl(OSCR);
+}
+
+
+#define MIN_OSCR_DELTA 16
+
+static irqreturn_t
+pxa_ost0_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *c = dev_id;
+
+	/* Disarm the compare/match, signal the event. */
+	timer_writel(timer_readl(OIER) & ~OIER_E0, OIER);
+	timer_writel(OSSR_M0, OSSR);
+	c->event_handler(c);
+
+	return IRQ_HANDLED;
+}
+
+static int
+pxa_osmr0_set_next_event(unsigned long delta, struct clock_event_device *dev)
+{
+	unsigned long next, oscr;
+
+	timer_writel(timer_readl(OIER) | OIER_E0, OIER);
+	next = timer_readl(OSCR) + delta;
+	timer_writel(next, OSMR0);
+	oscr = timer_readl(OSCR);
+
+	return (signed)(next - oscr) <= MIN_OSCR_DELTA ? -ETIME : 0;
+}
+
+static void
+pxa_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *dev)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		timer_writel(timer_readl(OIER) & ~OIER_E0, OIER);
+		timer_writel(OSSR_M0, OSSR);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		/* initializing, released, or preparing for suspend */
+		timer_writel(timer_readl(OIER) & ~OIER_E0, OIER);
+		timer_writel(OSSR_M0, OSSR);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_PERIODIC:
+		break;
+	}
+}
+
+#ifdef CONFIG_PM
+static unsigned long osmr[4], oier, oscr;
+
+static void pxa_timer_suspend(struct clock_event_device *cedev)
+{
+	osmr[0] = timer_readl(OSMR0);
+	osmr[1] = timer_readl(OSMR1);
+	osmr[2] = timer_readl(OSMR2);
+	osmr[3] = timer_readl(OSMR3);
+	oier = timer_readl(OIER);
+	oscr = timer_readl(OSCR);
+}
+
+static void pxa_timer_resume(struct clock_event_device *cedev)
+{
+	/*
+	 * Ensure that we have at least MIN_OSCR_DELTA between match
+	 * register 0 and the OSCR, to guarantee that we will receive
+	 * the one-shot timer interrupt.  We adjust OSMR0 in preference
+	 * to OSCR to guarantee that OSCR is monotonically incrementing.
+	 */
+	if (osmr[0] - oscr < MIN_OSCR_DELTA)
+		osmr[0] += MIN_OSCR_DELTA;
+
+	timer_writel(osmr[0], OSMR0);
+	timer_writel(osmr[1], OSMR1);
+	timer_writel(osmr[2], OSMR2);
+	timer_writel(osmr[3], OSMR3);
+	timer_writel(oier, OIER);
+	timer_writel(oscr, OSCR);
+}
+#else
+#define pxa_timer_suspend NULL
+#define pxa_timer_resume NULL
+#endif
+
+static struct clock_event_device ckevt_pxa_osmr0 = {
+	.name		= "osmr0",
+	.features	= CLOCK_EVT_FEAT_ONESHOT,
+	.rating		= 200,
+	.set_next_event	= pxa_osmr0_set_next_event,
+	.set_mode	= pxa_osmr0_set_mode,
+	.suspend	= pxa_timer_suspend,
+	.resume		= pxa_timer_resume,
+};
+
+static struct irqaction pxa_ost0_irq = {
+	.name		= "ost0",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= pxa_ost0_interrupt,
+	.dev_id		= &ckevt_pxa_osmr0,
+};
+
+static void pxa_timer_common_init(int irq, unsigned long clock_tick_rate)
+{
+	timer_writel(0, OIER);
+	timer_writel(OSSR_M0 | OSSR_M1 | OSSR_M2 | OSSR_M3, OSSR);
+
+	sched_clock_register(pxa_read_sched_clock, 32, clock_tick_rate);
+
+	ckevt_pxa_osmr0.cpumask = cpumask_of(0);
+
+	setup_irq(irq, &pxa_ost0_irq);
+
+	clocksource_mmio_init(timer_base + OSCR, "oscr0", clock_tick_rate, 200,
+			      32, clocksource_mmio_readl_up);
+	clockevents_config_and_register(&ckevt_pxa_osmr0, clock_tick_rate,
+					MIN_OSCR_DELTA * 2, 0x7fffffff);
+}
+
+static void __init pxa_timer_dt_init(struct device_node *np)
+{
+	struct clk *clk;
+	int irq;
+
+	/* timer registers are shared with watchdog timer */
+	timer_base = of_iomap(np, 0);
+	if (!timer_base)
+		panic("%s: unable to map resource\n", np->name);
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		pr_crit("%s: unable to get clk\n", np->name);
+		return;
+	}
+	clk_prepare_enable(clk);
+
+	/* we are only interested in OS-timer0 irq */
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq <= 0) {
+		pr_crit("%s: unable to parse OS-timer0 irq\n", np->name);
+		return;
+	}
+
+	pxa_timer_common_init(irq, clk_get_rate(clk));
+}
+CLOCKSOURCE_OF_DECLARE(pxa_timer, "marvell,pxa-timer", pxa_timer_dt_init);
+
+/*
+ * Legacy timer init for non device-tree boards.
+ */
+void __init pxa_timer_nodt_init(int irq, void __iomem *base,
+	unsigned long clock_tick_rate)
+{
+	struct clk *clk;
+
+	timer_base = base;
+	clk = clk_get(NULL, "OSTIMER0");
+	if (clk && !IS_ERR(clk))
+		clk_prepare_enable(clk);
+	else
+		pr_crit("%s: unable to get clk\n", __func__);
+
+	pxa_timer_common_init(irq, clock_tick_rate);
+}
diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index dfa7803..2bd13b5 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -114,14 +115,15 @@ struct sh_cmt_device {
 	struct platform_device *pdev;
 
 	const struct sh_cmt_info *info;
-	bool legacy;
 
-	void __iomem *mapbase_ch;
 	void __iomem *mapbase;
 	struct clk *clk;
 
+	raw_spinlock_t lock; /* Protect the shared start/stop register */
+
 	struct sh_cmt_channel *channels;
 	unsigned int num_channels;
+	unsigned int hw_channels;
 
 	bool has_clockevent;
 	bool has_clocksource;
@@ -301,14 +303,12 @@ static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
 	return v2;
 }
 
-static DEFINE_RAW_SPINLOCK(sh_cmt_lock);
-
 static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 {
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
-	raw_spin_lock_irqsave(&sh_cmt_lock, flags);
+	raw_spin_lock_irqsave(&ch->cmt->lock, flags);
 	value = sh_cmt_read_cmstr(ch);
 
 	if (start)
@@ -317,7 +317,7 @@ static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 		value &= ~(1 << ch->timer_bit);
 
 	sh_cmt_write_cmstr(ch, value);
-	raw_spin_unlock_irqrestore(&sh_cmt_lock, flags);
+	raw_spin_unlock_irqrestore(&ch->cmt->lock, flags);
 }
 
 static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
@@ -792,7 +792,7 @@ static int sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 	int irq;
 	int ret;
 
-	irq = platform_get_irq(ch->cmt->pdev, ch->cmt->legacy ? 0 : ch->index);
+	irq = platform_get_irq(ch->cmt->pdev, ch->index);
 	if (irq < 0) {
 		dev_err(&ch->cmt->pdev->dev, "ch%u: failed to get irq\n",
 			ch->index);
@@ -863,33 +863,26 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	 * Compute the address of the channel control register block. For the
 	 * timers with a per-channel start/stop register, compute its address
 	 * as well.
-	 *
-	 * For legacy configuration the address has been mapped explicitly.
 	 */
-	if (cmt->legacy) {
-		ch->ioctrl = cmt->mapbase_ch;
-	} else {
-		switch (cmt->info->model) {
-		case SH_CMT_16BIT:
-			ch->ioctrl = cmt->mapbase + 2 + ch->hwidx * 6;
-			break;
-		case SH_CMT_32BIT:
-		case SH_CMT_48BIT:
-			ch->ioctrl = cmt->mapbase + 0x10 + ch->hwidx * 0x10;
-			break;
-		case SH_CMT_32BIT_FAST:
-			/*
-			 * The 32-bit "fast" timer has a single channel at hwidx
-			 * 5 but is located at offset 0x40 instead of 0x60 for
-			 * some reason.
-			 */
-			ch->ioctrl = cmt->mapbase + 0x40;
-			break;
-		case SH_CMT_48BIT_GEN2:
-			ch->iostart = cmt->mapbase + ch->hwidx * 0x100;
-			ch->ioctrl = ch->iostart + 0x10;
-			break;
-		}
+	switch (cmt->info->model) {
+	case SH_CMT_16BIT:
+		ch->ioctrl = cmt->mapbase + 2 + ch->hwidx * 6;
+		break;
+	case SH_CMT_32BIT:
+	case SH_CMT_48BIT:
+		ch->ioctrl = cmt->mapbase + 0x10 + ch->hwidx * 0x10;
+		break;
+	case SH_CMT_32BIT_FAST:
+		/*
+		 * The 32-bit "fast" timer has a single channel at hwidx 5 but
+		 * is located at offset 0x40 instead of 0x60 for some reason.
+		 */
+		ch->ioctrl = cmt->mapbase + 0x40;
+		break;
+	case SH_CMT_48BIT_GEN2:
+		ch->iostart = cmt->mapbase + ch->hwidx * 0x100;
+		ch->ioctrl = ch->iostart + 0x10;
+		break;
 	}
 
 	if (cmt->info->width == (sizeof(ch->max_match_value) * 8))
@@ -900,12 +893,7 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	ch->match_value = ch->max_match_value;
 	raw_spin_lock_init(&ch->lock);
 
-	if (cmt->legacy) {
-		ch->timer_bit = ch->hwidx;
-	} else {
-		ch->timer_bit = cmt->info->model == SH_CMT_48BIT_GEN2
-			      ? 0 : ch->hwidx;
-	}
+	ch->timer_bit = cmt->info->model == SH_CMT_48BIT_GEN2 ? 0 : ch->hwidx;
 
 	ret = sh_cmt_register(ch, dev_name(&cmt->pdev->dev),
 			      clockevent, clocksource);
@@ -938,75 +926,65 @@ static int sh_cmt_map_memory(struct sh_cmt_device *cmt)
 	return 0;
 }
 
-static int sh_cmt_map_memory_legacy(struct sh_cmt_device *cmt)
-{
-	struct sh_timer_config *cfg = cmt->pdev->dev.platform_data;
-	struct resource *res, *res2;
-
-	/* map memory, let mapbase_ch point to our channel */
-	res = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&cmt->pdev->dev, "failed to get I/O memory\n");
-		return -ENXIO;
-	}
-
-	cmt->mapbase_ch = ioremap_nocache(res->start, resource_size(res));
-	if (cmt->mapbase_ch == NULL) {
-		dev_err(&cmt->pdev->dev, "failed to remap I/O memory\n");
-		return -ENXIO;
-	}
-
-	/* optional resource for the shared timer start/stop register */
-	res2 = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 1);
-
-	/* map second resource for CMSTR */
-	cmt->mapbase = ioremap_nocache(res2 ? res2->start :
-				       res->start - cfg->channel_offset,
-				       res2 ? resource_size(res2) : 2);
-	if (cmt->mapbase == NULL) {
-		dev_err(&cmt->pdev->dev, "failed to remap I/O second memory\n");
-		iounmap(cmt->mapbase_ch);
-		return -ENXIO;
-	}
-
-	/* identify the model based on the resources */
-	if (resource_size(res) == 6)
-		cmt->info = &sh_cmt_info[SH_CMT_16BIT];
-	else if (res2 && (resource_size(res2) == 4))
-		cmt->info = &sh_cmt_info[SH_CMT_48BIT_GEN2];
-	else
-		cmt->info = &sh_cmt_info[SH_CMT_32BIT];
+static const struct platform_device_id sh_cmt_id_table[] = {
+	{ "sh-cmt-16", (kernel_ulong_t)&sh_cmt_info[SH_CMT_16BIT] },
+	{ "sh-cmt-32", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT] },
+	{ "sh-cmt-32-fast", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT_FAST] },
+	{ "sh-cmt-48", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT] },
+	{ "sh-cmt-48-gen2", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT_GEN2] },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, sh_cmt_id_table);
 
-	return 0;
-}
+static const struct of_device_id sh_cmt_of_table[] __maybe_unused = {
+	{ .compatible = "renesas,cmt-32", .data = &sh_cmt_info[SH_CMT_32BIT] },
+	{ .compatible = "renesas,cmt-32-fast", .data = &sh_cmt_info[SH_CMT_32BIT_FAST] },
+	{ .compatible = "renesas,cmt-48", .data = &sh_cmt_info[SH_CMT_48BIT] },
+	{ .compatible = "renesas,cmt-48-gen2", .data = &sh_cmt_info[SH_CMT_48BIT_GEN2] },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sh_cmt_of_table);
 
-static void sh_cmt_unmap_memory(struct sh_cmt_device *cmt)
+static int sh_cmt_parse_dt(struct sh_cmt_device *cmt)
 {
-	iounmap(cmt->mapbase);
-	if (cmt->mapbase_ch)
-		iounmap(cmt->mapbase_ch);
+	struct device_node *np = cmt->pdev->dev.of_node;
+
+	return of_property_read_u32(np, "renesas,channels-mask",
+				    &cmt->hw_channels);
 }
 
 static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	const struct platform_device_id *id = pdev->id_entry;
-	unsigned int hw_channels;
+	unsigned int mask;
+	unsigned int i;
 	int ret;
 
 	memset(cmt, 0, sizeof(*cmt));
 	cmt->pdev = pdev;
+	raw_spin_lock_init(&cmt->lock);
+
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		const struct of_device_id *id;
+
+		id = of_match_node(sh_cmt_of_table, pdev->dev.of_node);
+		cmt->info = id->data;
 
-	if (!cfg) {
+		ret = sh_cmt_parse_dt(cmt);
+		if (ret < 0)
+			return ret;
+	} else if (pdev->dev.platform_data) {
+		struct sh_timer_config *cfg = pdev->dev.platform_data;
+		const struct platform_device_id *id = pdev->id_entry;
+
+		cmt->info = (const struct sh_cmt_info *)id->driver_data;
+		cmt->hw_channels = cfg->channels_mask;
+	} else {
 		dev_err(&cmt->pdev->dev, "missing platform data\n");
 		return -ENXIO;
 	}
 
-	cmt->info = (const struct sh_cmt_info *)id->driver_data;
-	cmt->legacy = cmt->info ? false : true;
-
 	/* Get hold of clock. */
-	cmt->clk = clk_get(&cmt->pdev->dev, cmt->legacy ? "cmt_fck" : "fck");
+	cmt->clk = clk_get(&cmt->pdev->dev, "fck");
 	if (IS_ERR(cmt->clk)) {
 		dev_err(&cmt->pdev->dev, "cannot get clock\n");
 		return PTR_ERR(cmt->clk);
@@ -1016,28 +994,13 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	if (ret < 0)
 		goto err_clk_put;
 
-	/*
-	 * Map the memory resource(s). We need to support both the legacy
-	 * platform device configuration (with one device per channel) and the
-	 * new version (with multiple channels per device).
-	 */
-	if (cmt->legacy)
-		ret = sh_cmt_map_memory_legacy(cmt);
-	else
-		ret = sh_cmt_map_memory(cmt);
-
+	/* Map the memory resource(s). */
+	ret = sh_cmt_map_memory(cmt);
 	if (ret < 0)
 		goto err_clk_unprepare;
 
 	/* Allocate and setup the channels. */
-	if (cmt->legacy) {
-		cmt->num_channels = 1;
-		hw_channels = 0;
-	} else {
-		cmt->num_channels = hweight8(cfg->channels_mask);
-		hw_channels = cfg->channels_mask;
-	}
-
+	cmt->num_channels = hweight8(cmt->hw_channels);
 	cmt->channels = kzalloc(cmt->num_channels * sizeof(*cmt->channels),
 				GFP_KERNEL);
 	if (cmt->channels == NULL) {
@@ -1045,35 +1008,21 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 		goto err_unmap;
 	}
 
-	if (cmt->legacy) {
-		ret = sh_cmt_setup_channel(&cmt->channels[0],
-					   cfg->timer_bit, cfg->timer_bit,
-					   cfg->clockevent_rating != 0,
-					   cfg->clocksource_rating != 0, cmt);
+	/*
+	 * Use the first channel as a clock event device and the second channel
+	 * as a clock source. If only one channel is available use it for both.
+	 */
+	for (i = 0, mask = cmt->hw_channels; i < cmt->num_channels; ++i) {
+		unsigned int hwidx = ffs(mask) - 1;
+		bool clocksource = i == 1 || cmt->num_channels == 1;
+		bool clockevent = i == 0;
+
+		ret = sh_cmt_setup_channel(&cmt->channels[i], i, hwidx,
+					   clockevent, clocksource, cmt);
 		if (ret < 0)
 			goto err_unmap;
-	} else {
-		unsigned int mask = hw_channels;
-		unsigned int i;
 
-		/*
-		 * Use the first channel as a clock event device and the second
-		 * channel as a clock source. If only one channel is available
-		 * use it for both.
-		 */
-		for (i = 0; i < cmt->num_channels; ++i) {
-			unsigned int hwidx = ffs(mask) - 1;
-			bool clocksource = i == 1 || cmt->num_channels == 1;
-			bool clockevent = i == 0;
-
-			ret = sh_cmt_setup_channel(&cmt->channels[i], i, hwidx,
-						   clockevent, clocksource,
-						   cmt);
-			if (ret < 0)
-				goto err_unmap;
-
-			mask &= ~(1 << hwidx);
-		}
+		mask &= ~(1 << hwidx);
 	}
 
 	platform_set_drvdata(pdev, cmt);
@@ -1082,7 +1031,7 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 
 err_unmap:
 	kfree(cmt->channels);
-	sh_cmt_unmap_memory(cmt);
+	iounmap(cmt->mapbase);
 err_clk_unprepare:
 	clk_unprepare(cmt->clk);
 err_clk_put:
@@ -1132,22 +1081,12 @@ static int sh_cmt_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
-static const struct platform_device_id sh_cmt_id_table[] = {
-	{ "sh_cmt", 0 },
-	{ "sh-cmt-16", (kernel_ulong_t)&sh_cmt_info[SH_CMT_16BIT] },
-	{ "sh-cmt-32", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT] },
-	{ "sh-cmt-32-fast", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT_FAST] },
-	{ "sh-cmt-48", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT] },
-	{ "sh-cmt-48-gen2", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT_GEN2] },
-	{ }
-};
-MODULE_DEVICE_TABLE(platform, sh_cmt_id_table);
-
 static struct platform_driver sh_cmt_device_driver = {
 	.probe		= sh_cmt_probe,
 	.remove		= sh_cmt_remove,
 	.driver		= {
 		.name	= "sh_cmt",
+		.of_match_table = of_match_ptr(sh_cmt_of_table),
 	},
 	.id_table	= sh_cmt_id_table,
 };
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 188d4e0..3d88698 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -23,6 +23,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -37,7 +38,6 @@ struct sh_mtu2_channel {
 	unsigned int index;
 
 	void __iomem *base;
-	int irq;
 
 	struct clock_event_device ced;
 };
@@ -48,15 +48,14 @@ struct sh_mtu2_device {
 	void __iomem *mapbase;
 	struct clk *clk;
 
+	raw_spinlock_t lock; /* Protect the shared registers */
+
 	struct sh_mtu2_channel *channels;
 	unsigned int num_channels;
 
-	bool legacy;
 	bool has_clockevent;
 };
 
-static DEFINE_RAW_SPINLOCK(sh_mtu2_lock);
-
 #define TSTR -1 /* shared register */
 #define TCR  0 /* channel register */
 #define TMDR 1 /* channel register */
@@ -162,12 +161,8 @@ static inline unsigned long sh_mtu2_read(struct sh_mtu2_channel *ch, int reg_nr)
 {
 	unsigned long offs;
 
-	if (reg_nr == TSTR) {
-		if (ch->mtu->legacy)
-			return ioread8(ch->mtu->mapbase);
-		else
-			return ioread8(ch->mtu->mapbase + 0x280);
-	}
+	if (reg_nr == TSTR)
+		return ioread8(ch->mtu->mapbase + 0x280);
 
 	offs = mtu2_reg_offs[reg_nr];
 
@@ -182,12 +177,8 @@ static inline void sh_mtu2_write(struct sh_mtu2_channel *ch, int reg_nr,
 {
 	unsigned long offs;
 
-	if (reg_nr == TSTR) {
-		if (ch->mtu->legacy)
-			return iowrite8(value, ch->mtu->mapbase);
-		else
-			return iowrite8(value, ch->mtu->mapbase + 0x280);
-	}
+	if (reg_nr == TSTR)
+		return iowrite8(value, ch->mtu->mapbase + 0x280);
 
 	offs = mtu2_reg_offs[reg_nr];
 
@@ -202,7 +193,7 @@ static void sh_mtu2_start_stop_ch(struct sh_mtu2_channel *ch, int start)
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
-	raw_spin_lock_irqsave(&sh_mtu2_lock, flags);
+	raw_spin_lock_irqsave(&ch->mtu->lock, flags);
 	value = sh_mtu2_read(ch, TSTR);
 
 	if (start)
@@ -211,7 +202,7 @@ static void sh_mtu2_start_stop_ch(struct sh_mtu2_channel *ch, int start)
 		value &= ~(1 << ch->index);
 
 	sh_mtu2_write(ch, TSTR, value);
-	raw_spin_unlock_irqrestore(&sh_mtu2_lock, flags);
+	raw_spin_unlock_irqrestore(&ch->mtu->lock, flags);
 }
 
 static int sh_mtu2_enable(struct sh_mtu2_channel *ch)
@@ -331,7 +322,6 @@ static void sh_mtu2_register_clockevent(struct sh_mtu2_channel *ch,
 					const char *name)
 {
 	struct clock_event_device *ced = &ch->ced;
-	int ret;
 
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
@@ -344,24 +334,12 @@ static void sh_mtu2_register_clockevent(struct sh_mtu2_channel *ch,
 	dev_info(&ch->mtu->pdev->dev, "ch%u: used for clock events\n",
 		 ch->index);
 	clockevents_register_device(ced);
-
-	ret = request_irq(ch->irq, sh_mtu2_interrupt,
-			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
-			  dev_name(&ch->mtu->pdev->dev), ch);
-	if (ret) {
-		dev_err(&ch->mtu->pdev->dev, "ch%u: failed to request irq %d\n",
-			ch->index, ch->irq);
-		return;
-	}
 }
 
-static int sh_mtu2_register(struct sh_mtu2_channel *ch, const char *name,
-			    bool clockevent)
+static int sh_mtu2_register(struct sh_mtu2_channel *ch, const char *name)
 {
-	if (clockevent) {
-		ch->mtu->has_clockevent = true;
-		sh_mtu2_register_clockevent(ch, name);
-	}
+	ch->mtu->has_clockevent = true;
+	sh_mtu2_register_clockevent(ch, name);
 
 	return 0;
 }
@@ -372,40 +350,32 @@ static int sh_mtu2_setup_channel(struct sh_mtu2_channel *ch, unsigned int index,
 	static const unsigned int channel_offsets[] = {
 		0x300, 0x380, 0x000,
 	};
-	bool clockevent;
+	char name[6];
+	int irq;
+	int ret;
 
 	ch->mtu = mtu;
 
-	if (mtu->legacy) {
-		struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
-
-		clockevent = cfg->clockevent_rating != 0;
-
-		ch->irq = platform_get_irq(mtu->pdev, 0);
-		ch->base = mtu->mapbase - cfg->channel_offset;
-		ch->index = cfg->timer_bit;
-	} else {
-		char name[6];
-
-		clockevent = true;
-
-		sprintf(name, "tgi%ua", index);
-		ch->irq = platform_get_irq_byname(mtu->pdev, name);
-		ch->base = mtu->mapbase + channel_offsets[index];
-		ch->index = index;
-	}
-
-	if (ch->irq < 0) {
+	sprintf(name, "tgi%ua", index);
+	irq = platform_get_irq_byname(mtu->pdev, name);
+	if (irq < 0) {
 		/* Skip channels with no declared interrupt. */
-		if (!mtu->legacy)
-			return 0;
+		return 0;
+	}
 
-		dev_err(&mtu->pdev->dev, "ch%u: failed to get irq\n",
-			ch->index);
-		return ch->irq;
+	ret = request_irq(irq, sh_mtu2_interrupt,
+			  IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING,
+			  dev_name(&ch->mtu->pdev->dev), ch);
+	if (ret) {
+		dev_err(&ch->mtu->pdev->dev, "ch%u: failed to request irq %d\n",
+			index, irq);
+		return ret;
 	}
 
-	return sh_mtu2_register(ch, dev_name(&mtu->pdev->dev), clockevent);
+	ch->base = mtu->mapbase + channel_offsets[index];
+	ch->index = index;
+
+	return sh_mtu2_register(ch, dev_name(&mtu->pdev->dev));
 }
 
 static int sh_mtu2_map_memory(struct sh_mtu2_device *mtu)
@@ -422,46 +392,21 @@ static int sh_mtu2_map_memory(struct sh_mtu2_device *mtu)
 	if (mtu->mapbase == NULL)
 		return -ENXIO;
 
-	/*
-	 * In legacy platform device configuration (with one device per channel)
-	 * the resource points to the channel base address.
-	 */
-	if (mtu->legacy) {
-		struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
-		mtu->mapbase += cfg->channel_offset;
-	}
-
 	return 0;
 }
 
-static void sh_mtu2_unmap_memory(struct sh_mtu2_device *mtu)
-{
-	if (mtu->legacy) {
-		struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
-		mtu->mapbase -= cfg->channel_offset;
-	}
-
-	iounmap(mtu->mapbase);
-}
-
 static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 			 struct platform_device *pdev)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	const struct platform_device_id *id = pdev->id_entry;
 	unsigned int i;
 	int ret;
 
 	mtu->pdev = pdev;
-	mtu->legacy = id->driver_data;
 
-	if (mtu->legacy && !cfg) {
-		dev_err(&mtu->pdev->dev, "missing platform data\n");
-		return -ENXIO;
-	}
+	raw_spin_lock_init(&mtu->lock);
 
 	/* Get hold of clock. */
-	mtu->clk = clk_get(&mtu->pdev->dev, mtu->legacy ? "mtu2_fck" : "fck");
+	mtu->clk = clk_get(&mtu->pdev->dev, "fck");
 	if (IS_ERR(mtu->clk)) {
 		dev_err(&mtu->pdev->dev, "cannot get clock\n");
 		return PTR_ERR(mtu->clk);
@@ -479,10 +424,7 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 	}
 
 	/* Allocate and setup the channels. */
-	if (mtu->legacy)
-		mtu->num_channels = 1;
-	else
-		mtu->num_channels = 3;
+	mtu->num_channels = 3;
 
 	mtu->channels = kzalloc(sizeof(*mtu->channels) * mtu->num_channels,
 				GFP_KERNEL);
@@ -491,16 +433,10 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 		goto err_unmap;
 	}
 
-	if (mtu->legacy) {
-		ret = sh_mtu2_setup_channel(&mtu->channels[0], 0, mtu);
+	for (i = 0; i < mtu->num_channels; ++i) {
+		ret = sh_mtu2_setup_channel(&mtu->channels[i], i, mtu);
 		if (ret < 0)
 			goto err_unmap;
-	} else {
-		for (i = 0; i < mtu->num_channels; ++i) {
-			ret = sh_mtu2_setup_channel(&mtu->channels[i], i, mtu);
-			if (ret < 0)
-				goto err_unmap;
-		}
 	}
 
 	platform_set_drvdata(pdev, mtu);
@@ -509,7 +445,7 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 
 err_unmap:
 	kfree(mtu->channels);
-	sh_mtu2_unmap_memory(mtu);
+	iounmap(mtu->mapbase);
 err_clk_unprepare:
 	clk_unprepare(mtu->clk);
 err_clk_put:
@@ -560,17 +496,23 @@ static int sh_mtu2_remove(struct platform_device *pdev)
 }
 
 static const struct platform_device_id sh_mtu2_id_table[] = {
-	{ "sh_mtu2", 1 },
 	{ "sh-mtu2", 0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, sh_mtu2_id_table);
 
+static const struct of_device_id sh_mtu2_of_table[] __maybe_unused = {
+	{ .compatible = "renesas,mtu2" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sh_mtu2_of_table);
+
 static struct platform_driver sh_mtu2_device_driver = {
 	.probe		= sh_mtu2_probe,
 	.remove		= sh_mtu2_remove,
 	.driver		= {
 		.name	= "sh_mtu2",
+		.of_match_table = of_match_ptr(sh_mtu2_of_table),
 	},
 	.id_table	= sh_mtu2_id_table,
 };
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 6bd17a8..0f665b8 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -32,7 +33,6 @@
 #include <linux/spinlock.h>
 
 enum sh_tmu_model {
-	SH_TMU_LEGACY,
 	SH_TMU,
 	SH_TMU_SH3,
 };
@@ -62,6 +62,8 @@ struct sh_tmu_device {
 
 	enum sh_tmu_model model;
 
+	raw_spinlock_t lock; /* Protect the shared start/stop register */
+
 	struct sh_tmu_channel *channels;
 	unsigned int num_channels;
 
@@ -69,8 +71,6 @@ struct sh_tmu_device {
 	bool has_clocksource;
 };
 
-static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
-
 #define TSTR -1 /* shared register */
 #define TCOR  0 /* channel register */
 #define TCNT 1 /* channel register */
@@ -91,8 +91,6 @@ static inline unsigned long sh_tmu_read(struct sh_tmu_channel *ch, int reg_nr)
 
 	if (reg_nr == TSTR) {
 		switch (ch->tmu->model) {
-		case SH_TMU_LEGACY:
-			return ioread8(ch->tmu->mapbase);
 		case SH_TMU_SH3:
 			return ioread8(ch->tmu->mapbase + 2);
 		case SH_TMU:
@@ -115,8 +113,6 @@ static inline void sh_tmu_write(struct sh_tmu_channel *ch, int reg_nr,
 
 	if (reg_nr == TSTR) {
 		switch (ch->tmu->model) {
-		case SH_TMU_LEGACY:
-			return iowrite8(value, ch->tmu->mapbase);
 		case SH_TMU_SH3:
 			return iowrite8(value, ch->tmu->mapbase + 2);
 		case SH_TMU:
@@ -137,7 +133,7 @@ static void sh_tmu_start_stop_ch(struct sh_tmu_channel *ch, int start)
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
-	raw_spin_lock_irqsave(&sh_tmu_lock, flags);
+	raw_spin_lock_irqsave(&ch->tmu->lock, flags);
 	value = sh_tmu_read(ch, TSTR);
 
 	if (start)
@@ -146,7 +142,7 @@ static void sh_tmu_start_stop_ch(struct sh_tmu_channel *ch, int start)
 		value &= ~(1 << ch->index);
 
 	sh_tmu_write(ch, TSTR, value);
-	raw_spin_unlock_irqrestore(&sh_tmu_lock, flags);
+	raw_spin_unlock_irqrestore(&ch->tmu->lock, flags);
 }
 
 static int __sh_tmu_enable(struct sh_tmu_channel *ch)
@@ -476,27 +472,12 @@ static int sh_tmu_channel_setup(struct sh_tmu_channel *ch, unsigned int index,
 		return 0;
 
 	ch->tmu = tmu;
+	ch->index = index;
 
-	if (tmu->model == SH_TMU_LEGACY) {
-		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
-
-		/*
-		 * The SH3 variant (SH770x, SH7705, SH7710 and SH7720) maps
-		 * channel registers blocks at base + 2 + 12 * index, while all
-		 * other variants map them at base + 4 + 12 * index. We can
-		 * compute the index by just dividing by 12, the 2 bytes or 4
-		 * bytes offset being hidden by the integer division.
-		 */
-		ch->index = cfg->channel_offset / 12;
-		ch->base = tmu->mapbase + cfg->channel_offset;
-	} else {
-		ch->index = index;
-
-		if (tmu->model == SH_TMU_SH3)
-			ch->base = tmu->mapbase + 4 + ch->index * 12;
-		else
-			ch->base = tmu->mapbase + 8 + ch->index * 12;
-	}
+	if (tmu->model == SH_TMU_SH3)
+		ch->base = tmu->mapbase + 4 + ch->index * 12;
+	else
+		ch->base = tmu->mapbase + 8 + ch->index * 12;
 
 	ch->irq = platform_get_irq(tmu->pdev, index);
 	if (ch->irq < 0) {
@@ -526,46 +507,53 @@ static int sh_tmu_map_memory(struct sh_tmu_device *tmu)
 	if (tmu->mapbase == NULL)
 		return -ENXIO;
 
-	/*
-	 * In legacy platform device configuration (with one device per channel)
-	 * the resource points to the channel base address.
-	 */
-	if (tmu->model == SH_TMU_LEGACY) {
-		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
-		tmu->mapbase -= cfg->channel_offset;
-	}
-
 	return 0;
 }
 
-static void sh_tmu_unmap_memory(struct sh_tmu_device *tmu)
+static int sh_tmu_parse_dt(struct sh_tmu_device *tmu)
 {
-	if (tmu->model == SH_TMU_LEGACY) {
-		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
-		tmu->mapbase += cfg->channel_offset;
+	struct device_node *np = tmu->pdev->dev.of_node;
+
+	tmu->model = SH_TMU;
+	tmu->num_channels = 3;
+
+	of_property_read_u32(np, "#renesas,channels", &tmu->num_channels);
+
+	if (tmu->num_channels != 2 && tmu->num_channels != 3) {
+		dev_err(&tmu->pdev->dev, "invalid number of channels %u\n",
+			tmu->num_channels);
+		return -EINVAL;
 	}
 
-	iounmap(tmu->mapbase);
+	return 0;
 }
 
 static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	const struct platform_device_id *id = pdev->id_entry;
 	unsigned int i;
 	int ret;
 
-	if (!cfg) {
+	tmu->pdev = pdev;
+
+	raw_spin_lock_init(&tmu->lock);
+
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
+		ret = sh_tmu_parse_dt(tmu);
+		if (ret < 0)
+			return ret;
+	} else if (pdev->dev.platform_data) {
+		const struct platform_device_id *id = pdev->id_entry;
+		struct sh_timer_config *cfg = pdev->dev.platform_data;
+
+		tmu->model = id->driver_data;
+		tmu->num_channels = hweight8(cfg->channels_mask);
+	} else {
 		dev_err(&tmu->pdev->dev, "missing platform data\n");
 		return -ENXIO;
 	}
 
-	tmu->pdev = pdev;
-	tmu->model = id->driver_data;
-
 	/* Get hold of clock. */
-	tmu->clk = clk_get(&tmu->pdev->dev,
-			   tmu->model == SH_TMU_LEGACY ? "tmu_fck" : "fck");
+	tmu->clk = clk_get(&tmu->pdev->dev, "fck");
 	if (IS_ERR(tmu->clk)) {
 		dev_err(&tmu->pdev->dev, "cannot get clock\n");
 		return PTR_ERR(tmu->clk);
@@ -583,11 +571,6 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	}
 
 	/* Allocate and setup the channels. */
-	if (tmu->model == SH_TMU_LEGACY)
-		tmu->num_channels = 1;
-	else
-		tmu->num_channels = hweight8(cfg->channels_mask);
-
 	tmu->channels = kzalloc(sizeof(*tmu->channels) * tmu->num_channels,
 				GFP_KERNEL);
 	if (tmu->channels == NULL) {
@@ -595,23 +578,15 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 		goto err_unmap;
 	}
 
-	if (tmu->model == SH_TMU_LEGACY) {
-		ret = sh_tmu_channel_setup(&tmu->channels[0], 0,
-					   cfg->clockevent_rating != 0,
-					   cfg->clocksource_rating != 0, tmu);
+	/*
+	 * Use the first channel as a clock event device and the second channel
+	 * as a clock source.
+	 */
+	for (i = 0; i < tmu->num_channels; ++i) {
+		ret = sh_tmu_channel_setup(&tmu->channels[i], i,
+					   i == 0, i == 1, tmu);
 		if (ret < 0)
 			goto err_unmap;
-	} else {
-		/*
-		 * Use the first channel as a clock event device and the second
-		 * channel as a clock source.
-		 */
-		for (i = 0; i < tmu->num_channels; ++i) {
-			ret = sh_tmu_channel_setup(&tmu->channels[i], i,
-						   i == 0, i == 1, tmu);
-			if (ret < 0)
-				goto err_unmap;
-		}
 	}
 
 	platform_set_drvdata(pdev, tmu);
@@ -620,7 +595,7 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 
 err_unmap:
 	kfree(tmu->channels);
-	sh_tmu_unmap_memory(tmu);
+	iounmap(tmu->mapbase);
 err_clk_unprepare:
 	clk_unprepare(tmu->clk);
 err_clk_put:
@@ -671,18 +646,24 @@ static int sh_tmu_remove(struct platform_device *pdev)
 }
 
 static const struct platform_device_id sh_tmu_id_table[] = {
-	{ "sh_tmu", SH_TMU_LEGACY },
 	{ "sh-tmu", SH_TMU },
 	{ "sh-tmu-sh3", SH_TMU_SH3 },
 	{ }
 };
 MODULE_DEVICE_TABLE(platform, sh_tmu_id_table);
 
+static const struct of_device_id sh_tmu_of_table[] __maybe_unused = {
+	{ .compatible = "renesas,tmu" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sh_tmu_of_table);
+
 static struct platform_driver sh_tmu_device_driver = {
 	.probe		= sh_tmu_probe,
 	.remove		= sh_tmu_remove,
 	.driver		= {
 		.name	= "sh_tmu",
+		.of_match_table = of_match_ptr(sh_tmu_of_table),
 	},
 	.id_table	= sh_tmu_id_table,
 };
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index dbd3039..330e930 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -260,6 +260,9 @@ static void __init sirfsoc_marco_timer_init(struct device_node *np)
 
 	clk = of_clk_get(np, 0);
 	BUG_ON(IS_ERR(clk));
+
+	BUG_ON(clk_prepare_enable(clk));
+
 	rate = clk_get_rate(clk);
 
 	BUG_ON(rate < MARCO_CLOCK_FREQ);
diff --git a/drivers/clocksource/timer-prima2.c b/drivers/clocksource/timer-prima2.c
index a722aac..ce18d57 100644
--- a/drivers/clocksource/timer-prima2.c
+++ b/drivers/clocksource/timer-prima2.c
@@ -200,6 +200,9 @@ static void __init sirfsoc_prima2_timer_init(struct device_node *np)
 
 	clk = of_clk_get(np, 0);
 	BUG_ON(IS_ERR(clk));
+
+	BUG_ON(clk_prepare_enable(clk));
+
 	rate = clk_get_rate(clk);
 
 	BUG_ON(rate < PRIMA2_CLOCK_FREQ);
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index ccdd4c7..15d06fc 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -69,7 +69,6 @@ void proc_fork_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 	struct task_struct *parent;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -79,8 +78,7 @@ void proc_fork_connector(struct task_struct *task)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_FORK;
 	rcu_read_lock();
 	parent = rcu_dereference(task->real_parent);
@@ -102,7 +100,6 @@ void proc_exec_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -112,8 +109,7 @@ void proc_exec_connector(struct task_struct *task)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_EXEC;
 	ev->event_data.exec.process_pid = task->pid;
 	ev->event_data.exec.process_tgid = task->tgid;
@@ -130,7 +126,6 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 	const struct cred *cred;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -156,8 +151,7 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	}
 	rcu_read_unlock();
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
@@ -170,7 +164,6 @@ void proc_sid_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -180,8 +173,7 @@ void proc_sid_connector(struct task_struct *task)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_SID;
 	ev->event_data.sid.process_pid = task->pid;
 	ev->event_data.sid.process_tgid = task->tgid;
@@ -197,7 +189,6 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -207,8 +198,7 @@ void proc_ptrace_connector(struct task_struct *task, int ptrace_id)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_PTRACE;
 	ev->event_data.ptrace.process_pid  = task->pid;
 	ev->event_data.ptrace.process_tgid = task->tgid;
@@ -232,7 +222,6 @@ void proc_comm_connector(struct task_struct *task)
 {
 	struct cn_msg *msg;
 	struct proc_event *ev;
-	struct timespec ts;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
@@ -242,8 +231,7 @@ void proc_comm_connector(struct task_struct *task)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
@@ -261,7 +249,6 @@ void proc_coredump_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -270,8 +257,7 @@ void proc_coredump_connector(struct task_struct *task)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_COREDUMP;
 	ev->event_data.coredump.process_pid = task->pid;
 	ev->event_data.coredump.process_tgid = task->tgid;
@@ -288,7 +274,6 @@ void proc_exit_connector(struct task_struct *task)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -297,8 +282,7 @@ void proc_exit_connector(struct task_struct *task)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	get_seq(&msg->seq, &ev->cpu);
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->what = PROC_EVENT_EXIT;
 	ev->event_data.exit.process_pid = task->pid;
 	ev->event_data.exit.process_tgid = task->tgid;
@@ -325,7 +309,6 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 	struct cn_msg *msg;
 	struct proc_event *ev;
 	__u8 buffer[CN_PROC_MSG_SIZE] __aligned(8);
-	struct timespec ts;
 
 	if (atomic_read(&proc_event_num_listeners) < 1)
 		return;
@@ -334,8 +317,7 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
 	ev = (struct proc_event *)msg->data;
 	memset(&ev->event_data, 0, sizeof(ev->event_data));
 	msg->seq = rcvd_seq;
-	ktime_get_ts(&ts); /* get high res monotonic timestamp */
-	ev->timestamp_ns = timespec_to_ns(&ts);
+	ev->timestamp_ns = ktime_get_ns();
 	ev->cpu = -1;
 	ev->what = PROC_EVENT_NONE;
 	ev->event_data.ack.err = err;
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index d7d5c8a..5d997a3 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1214,9 +1214,9 @@ static int ioctl_get_cycle_timer2(struct client *client, union ioctl_arg *arg)
 	cycle_time = card->driver->read_csr(card, CSR_CYCLE_TIME);
 
 	switch (a->clk_id) {
-	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
-	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
-	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
+	case CLOCK_REALTIME:      getnstimeofday(&ts);	break;
+	case CLOCK_MONOTONIC:     ktime_get_ts(&ts);	break;
+	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);	break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 0de123a..08ba120 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -542,8 +542,8 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 					  const struct drm_crtc *refcrtc,
 					  const struct drm_display_mode *mode)
 {
-	ktime_t stime, etime, mono_time_offset;
 	struct timeval tv_etime;
+	ktime_t stime, etime;
 	int vbl_status;
 	int vpos, hpos, i;
 	int framedur_ns, linedur_ns, pixeldur_ns, delta_ns, duration_ns;
@@ -588,13 +588,6 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 		vbl_status = dev->driver->get_scanout_position(dev, crtc, flags, &vpos,
 							       &hpos, &stime, &etime);
 
-		/*
-		 * Get correction for CLOCK_MONOTONIC -> CLOCK_REALTIME if
-		 * CLOCK_REALTIME is requested.
-		 */
-		if (!drm_timestamp_monotonic)
-			mono_time_offset = ktime_get_monotonic_offset();
-
 		/* Return as no-op if scanout query unsupported or failed. */
 		if (!(vbl_status & DRM_SCANOUTPOS_VALID)) {
 			DRM_DEBUG("crtc %d : scanoutpos query failed [%d].\n",
@@ -633,7 +626,7 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 	delta_ns = vpos * linedur_ns + hpos * pixeldur_ns;
 
 	if (!drm_timestamp_monotonic)
-		etime = ktime_sub(etime, mono_time_offset);
+		etime = ktime_mono_to_real(etime);
 
 	/* save this only for debugging purposes */
 	tv_etime = ktime_to_timeval(etime);
@@ -664,10 +657,7 @@ static struct timeval get_drm_timestamp(void)
 {
 	ktime_t now;
 
-	now = ktime_get();
-	if (!drm_timestamp_monotonic)
-		now = ktime_sub(now, ktime_get_monotonic_offset());
-
+	now = drm_timestamp_monotonic ? ktime_get() : ktime_get_real();
 	return ktime_to_timeval(now);
 }
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 374f964..1f77008 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -931,7 +931,7 @@ struct intel_ilk_power_mgmt {
 	unsigned long last_time1;
 	unsigned long chipset_power;
 	u64 last_count2;
-	struct timespec last_time2;
+	u64 last_time2;
 	unsigned long gfx_power;
 	u8 corr;
 
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index f361263..74531ca 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1149,16 +1149,16 @@ static bool can_wait_boost(struct drm_i915_file_private *file_priv)
 static int __wait_seqno(struct intel_engine_cs *ring, u32 seqno,
 			unsigned reset_counter,
 			bool interruptible,
-			struct timespec *timeout,
+			s64 *timeout,
 			struct drm_i915_file_private *file_priv)
 {
 	struct drm_device *dev = ring->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	const bool irq_test_in_progress =
 		ACCESS_ONCE(dev_priv->gpu_error.test_irq_rings) & intel_ring_flag(ring);
-	struct timespec before, now;
 	DEFINE_WAIT(wait);
 	unsigned long timeout_expire;
+	s64 before, now;
 	int ret;
 
 	WARN(dev_priv->pm.irqs_disabled, "IRQs disabled\n");
@@ -1166,7 +1166,7 @@ static int __wait_seqno(struct intel_engine_cs *ring, u32 seqno,
 	if (i915_seqno_passed(ring->get_seqno(ring, true), seqno))
 		return 0;
 
-	timeout_expire = timeout ? jiffies + timespec_to_jiffies_timeout(timeout) : 0;
+	timeout_expire = timeout ? jiffies + nsecs_to_jiffies((u64)*timeout) : 0;
 
 	if (INTEL_INFO(dev)->gen >= 6 && can_wait_boost(file_priv)) {
 		gen6_rps_boost(dev_priv);
@@ -1181,7 +1181,7 @@ static int __wait_seqno(struct intel_engine_cs *ring, u32 seqno,
 
 	/* Record current time in case interrupted by signal, or wedged */
 	trace_i915_gem_request_wait_begin(ring, seqno);
-	getrawmonotonic(&before);
+	before = ktime_get_raw_ns();
 	for (;;) {
 		struct timer_list timer;
 
@@ -1230,7 +1230,7 @@ static int __wait_seqno(struct intel_engine_cs *ring, u32 seqno,
 			destroy_timer_on_stack(&timer);
 		}
 	}
-	getrawmonotonic(&now);
+	now = ktime_get_raw_ns();
 	trace_i915_gem_request_wait_end(ring, seqno);
 
 	if (!irq_test_in_progress)
@@ -1239,10 +1239,9 @@ static int __wait_seqno(struct intel_engine_cs *ring, u32 seqno,
 	finish_wait(&ring->irq_queue, &wait);
 
 	if (timeout) {
-		struct timespec sleep_time = timespec_sub(now, before);
-		*timeout = timespec_sub(*timeout, sleep_time);
-		if (!timespec_valid(timeout)) /* i.e. negative time remains */
-			set_normalized_timespec(timeout, 0, 0);
+		s64 tres = *timeout - (now - before);
+
+		*timeout = tres < 0 ? 0 : tres;
 	}
 
 	return ret;
@@ -2753,16 +2752,10 @@ i915_gem_wait_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	struct drm_i915_gem_wait *args = data;
 	struct drm_i915_gem_object *obj;
 	struct intel_engine_cs *ring = NULL;
-	struct timespec timeout_stack, *timeout = NULL;
 	unsigned reset_counter;
 	u32 seqno = 0;
 	int ret = 0;
 
-	if (args->timeout_ns >= 0) {
-		timeout_stack = ns_to_timespec(args->timeout_ns);
-		timeout = &timeout_stack;
-	}
-
 	ret = i915_mutex_lock_interruptible(dev);
 	if (ret)
 		return ret;
@@ -2787,9 +2780,9 @@ i915_gem_wait_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 		 goto out;
 
 	/* Do this after OLR check to make sure we make forward progress polling
-	 * on this IOCTL with a 0 timeout (like busy ioctl)
+	 * on this IOCTL with a timeout <=0 (like busy ioctl)
 	 */
-	if (!args->timeout_ns) {
+	if (args->timeout_ns <= 0) {
 		ret = -ETIME;
 		goto out;
 	}
@@ -2798,10 +2791,8 @@ i915_gem_wait_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	reset_counter = atomic_read(&dev_priv->gpu_error.reset_counter);
 	mutex_unlock(&dev->struct_mutex);
 
-	ret = __wait_seqno(ring, seqno, reset_counter, true, timeout, file->driver_priv);
-	if (timeout)
-		args->timeout_ns = timespec_to_ns(timeout);
-	return ret;
+	return __wait_seqno(ring, seqno, reset_counter, true, &args->timeout_ns,
+			    file->driver_priv);
 
 out:
 	drm_gem_object_unreference(&obj->base);
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index ee72807..f1233f5 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2993,7 +2993,7 @@ static void ironlake_enable_drps(struct drm_device *dev)
 		I915_READ(0x112e0);
 	dev_priv->ips.last_time1 = jiffies_to_msecs(jiffies);
 	dev_priv->ips.last_count2 = I915_READ(0x112f4);
-	getrawmonotonic(&dev_priv->ips.last_time2);
+	dev_priv->ips.last_time2 = ktime_get_raw_ns();
 
 	spin_unlock_irq(&mchdev_lock);
 }
@@ -4314,18 +4314,16 @@ static u16 pvid_to_extvid(struct drm_i915_private *dev_priv, u8 pxvid)
 
 static void __i915_update_gfx_val(struct drm_i915_private *dev_priv)
 {
-	struct timespec now, diff1;
-	u64 diff;
-	unsigned long diffms;
+	u64 now, diff, diffms;
 	u32 count;
 
 	assert_spin_locked(&mchdev_lock);
 
-	getrawmonotonic(&now);
-	diff1 = timespec_sub(now, dev_priv->ips.last_time2);
+	now = ktime_get_raw_ns();
+	diffms = now - dev_priv->ips.last_time2;
+	do_div(diffms, NSEC_PER_MSEC);
 
 	/* Don't divide by 0 */
-	diffms = diff1.tv_sec * 1000 + diff1.tv_nsec / 1000000;
 	if (!diffms)
 		return;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 6b252a8..c886c02 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -159,8 +159,8 @@ struct vmw_surface {
 
 struct vmw_marker_queue {
 	struct list_head head;
-	struct timespec lag;
-	struct timespec lag_time;
+	u64 lag;
+	u64 lag_time;
 	spinlock_t lock;
 };
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c b/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
index 8a8725c2..efd1ffd 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
@@ -31,14 +31,14 @@
 struct vmw_marker {
 	struct list_head head;
 	uint32_t seqno;
-	struct timespec submitted;
+	u64 submitted;
 };
 
 void vmw_marker_queue_init(struct vmw_marker_queue *queue)
 {
 	INIT_LIST_HEAD(&queue->head);
-	queue->lag = ns_to_timespec(0);
-	getrawmonotonic(&queue->lag_time);
+	queue->lag = 0;
+	queue->lag_time = ktime_get_raw_ns();
 	spin_lock_init(&queue->lock);
 }
 
@@ -62,7 +62,7 @@ int vmw_marker_push(struct vmw_marker_queue *queue,
 		return -ENOMEM;
 
 	marker->seqno = seqno;
-	getrawmonotonic(&marker->submitted);
+	marker->submitted = ktime_get_raw_ns();
 	spin_lock(&queue->lock);
 	list_add_tail(&marker->head, &queue->head);
 	spin_unlock(&queue->lock);
@@ -74,14 +74,14 @@ int vmw_marker_pull(struct vmw_marker_queue *queue,
 		   uint32_t signaled_seqno)
 {
 	struct vmw_marker *marker, *next;
-	struct timespec now;
 	bool updated = false;
+	u64 now;
 
 	spin_lock(&queue->lock);
-	getrawmonotonic(&now);
+	now = ktime_get_raw_ns();
 
 	if (list_empty(&queue->head)) {
-		queue->lag = ns_to_timespec(0);
+		queue->lag = 0;
 		queue->lag_time = now;
 		updated = true;
 		goto out_unlock;
@@ -91,7 +91,7 @@ int vmw_marker_pull(struct vmw_marker_queue *queue,
 		if (signaled_seqno - marker->seqno > (1 << 30))
 			continue;
 
-		queue->lag = timespec_sub(now, marker->submitted);
+		queue->lag = now - marker->submitted;
 		queue->lag_time = now;
 		updated = true;
 		list_del(&marker->head);
@@ -104,27 +104,13 @@ out_unlock:
 	return (updated) ? 0 : -EBUSY;
 }
 
-static struct timespec vmw_timespec_add(struct timespec t1,
-					struct timespec t2)
+static u64 vmw_fifo_lag(struct vmw_marker_queue *queue)
 {
-	t1.tv_sec += t2.tv_sec;
-	t1.tv_nsec += t2.tv_nsec;
-	if (t1.tv_nsec >= 1000000000L) {
-		t1.tv_sec += 1;
-		t1.tv_nsec -= 1000000000L;
-	}
-
-	return t1;
-}
-
-static struct timespec vmw_fifo_lag(struct vmw_marker_queue *queue)
-{
-	struct timespec now;
+	u64 now;
 
 	spin_lock(&queue->lock);
-	getrawmonotonic(&now);
-	queue->lag = vmw_timespec_add(queue->lag,
-				      timespec_sub(now, queue->lag_time));
+	now = ktime_get_raw_ns();
+	queue->lag += now - queue->lag_time;
 	queue->lag_time = now;
 	spin_unlock(&queue->lock);
 	return queue->lag;
@@ -134,11 +120,9 @@ static struct timespec vmw_fifo_lag(struct vmw_marker_queue *queue)
 static bool vmw_lag_lt(struct vmw_marker_queue *queue,
 		       uint32_t us)
 {
-	struct timespec lag, cond;
+	u64 cond = (u64) us * NSEC_PER_USEC;
 
-	cond = ns_to_timespec((s64) us * 1000);
-	lag = vmw_fifo_lag(queue);
-	return (timespec_compare(&lag, &cond) < 1);
+	return vmw_fifo_lag(queue) <= cond;
 }
 
 int vmw_wait_lag(struct vmw_private *dev_priv,
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index 632f1dc..7a8a6fb 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -842,11 +842,10 @@ static ssize_t aem_show_power(struct device *dev,
 	struct aem_data *data = dev_get_drvdata(dev);
 	u64 before, after, delta, time;
 	signed long leftover;
-	struct timespec b, a;
 
 	mutex_lock(&data->lock);
 	update_aem_energy_one(data, attr->index);
-	getnstimeofday(&b);
+	time = ktime_get_ns();
 	before = data->energy[attr->index];
 
 	leftover = schedule_timeout_interruptible(
@@ -858,11 +857,10 @@ static ssize_t aem_show_power(struct device *dev,
 	}
 
 	update_aem_energy_one(data, attr->index);
-	getnstimeofday(&a);
+	time = ktime_get_ns() - time;
 	after = data->energy[attr->index];
 	mutex_unlock(&data->lock);
 
-	time = timespec_to_ns(&a) - timespec_to_ns(&b);
 	delta = (after - before) * UJ_PER_MJ;
 
 	return sprintf(buf, "%llu\n",
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index fd325ec..de05545 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -108,9 +108,8 @@ static void evdev_queue_syn_dropped(struct evdev_client *client)
 	struct input_event ev;
 	ktime_t time;
 
-	time = ktime_get();
-	if (client->clkid != CLOCK_MONOTONIC)
-		time = ktime_sub(time, ktime_get_monotonic_offset());
+	time = (client->clkid == CLOCK_MONOTONIC) ?
+		ktime_get() : ktime_get_real();
 
 	ev.time = ktime_to_timeval(time);
 	ev.type = EV_SYN;
@@ -202,7 +201,7 @@ static void evdev_events(struct input_handle *handle,
 	ktime_t time_mono, time_real;
 
 	time_mono = ktime_get();
-	time_real = ktime_sub(time_mono, ktime_get_monotonic_offset());
+	time_real = ktime_mono_to_real(time_mono);
 
 	rcu_read_lock();
 
diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 0b8d328..8c1c7cc 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -225,7 +225,6 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 	u8 *ptr;
 	int sum;
 	int ret = 0, final_ret;
-	struct timespec ts;
 
 	/*
 	 * We have the shared ec_dev buffer plus we do lots of separate spi_sync
@@ -239,11 +238,9 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 
 	/* If it's too soon to do another transaction, wait */
 	if (ec_spi->last_transfer_ns) {
-		struct timespec ts;
 		unsigned long delay;	/* The delay completed so far */
 
-		ktime_get_ts(&ts);
-		delay = timespec_to_ns(&ts) - ec_spi->last_transfer_ns;
+		delay = ktime_get_ns() - ec_spi->last_transfer_ns;
 		if (delay < EC_SPI_RECOVERY_TIME_NS)
 			ndelay(EC_SPI_RECOVERY_TIME_NS - delay);
 	}
@@ -280,8 +277,7 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 	}
 
 	final_ret = spi_sync(ec_spi->spi, &msg);
-	ktime_get_ts(&ts);
-	ec_spi->last_transfer_ns = timespec_to_ns(&ts);
+	ec_spi->last_transfer_ns = ktime_get_ns();
 	if (!ret)
 		ret = final_ret;
 	if (ret < 0) {
diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 06f6ad2..3336ddc 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -145,7 +145,6 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 	union ioc4_int_out int_out;
 	union ioc4_gpcr gpcr;
 	unsigned int state, last_state = 1;
-	struct timespec start_ts, end_ts;
 	uint64_t start, end, period;
 	unsigned int count = 0;
 
@@ -174,10 +173,10 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 		if (!last_state && state) {
 			count++;
 			if (count == IOC4_CALIBRATE_END) {
-				ktime_get_ts(&end_ts);
+				end = ktime_get_ns();
 				break;
 			} else if (count == IOC4_CALIBRATE_DISCARD)
-				ktime_get_ts(&start_ts);
+				start = ktime_get_ns();
 		}
 		last_state = state;
 	} while (1);
@@ -192,8 +191,6 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 	 *    by which the IOC4 generates the square wave, to get the
 	 *    period of an IOC4 INT_OUT count.
 	 */
-	end = end_ts.tv_sec * NSEC_PER_SEC + end_ts.tv_nsec;
-	start = start_ts.tv_sec * NSEC_PER_SEC + start_ts.tv_nsec;
 	period = (end - start) /
 		(IOC4_CALIBRATE_CYCLES * 2 * (IOC4_CALIBRATE_COUNT + 1));
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 87d1b01..67f8f5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -548,7 +548,7 @@ static void cmd_work_handler(struct work_struct *work)
 	lay->status_own = CMD_OWNER_HW;
 	set_signature(ent, !cmd->checksum_disabled);
 	dump_command(dev, ent, 1);
-	ktime_get_ts(&ent->ts1);
+	ent->ts1 = ktime_get_ns();
 
 	/* ring doorbell after the descriptor is valid */
 	wmb();
@@ -637,7 +637,6 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 	struct mlx5_cmd_work_ent *ent;
-	ktime_t t1, t2, delta;
 	struct mlx5_cmd_stats *stats;
 	int err = 0;
 	s64 ds;
@@ -668,10 +667,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		if (err == -ETIMEDOUT)
 			goto out;
 
-		t1 = timespec_to_ktime(ent->ts1);
-		t2 = timespec_to_ktime(ent->ts2);
-		delta = ktime_sub(t2, t1);
-		ds = ktime_to_ns(delta);
+		ds = ent->ts2 - ent->ts1;
 		op = be16_to_cpu(((struct mlx5_inbox_hdr *)in->first.data)->opcode);
 		if (op < ARRAY_SIZE(cmd->stats)) {
 			stats = &cmd->stats[op];
@@ -1135,7 +1131,6 @@ void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, unsigned long vector)
 	void *context;
 	int err;
 	int i;
-	ktime_t t1, t2, delta;
 	s64 ds;
 	struct mlx5_cmd_stats *stats;
 	unsigned long flags;
@@ -1149,7 +1144,7 @@ void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, unsigned long vector)
 				sem = &cmd->pages_sem;
 			else
 				sem = &cmd->sem;
-			ktime_get_ts(&ent->ts2);
+			ent->ts2 = ktime_get_ns();
 			memcpy(ent->out->first.data, ent->lay->out, sizeof(ent->lay->out));
 			dump_command(dev, ent, 0);
 			if (!ent->ret) {
@@ -1163,10 +1158,7 @@ void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, unsigned long vector)
 			}
 			free_ent(cmd, ent->idx);
 			if (ent->callback) {
-				t1 = timespec_to_ktime(ent->ts1);
-				t2 = timespec_to_ktime(ent->ts2);
-				delta = ktime_sub(t2, t1);
-				ds = ktime_to_ns(delta);
+				ds = ent->ts2 - ent->ts1;
 				if (ent->op < ARRAY_SIZE(cmd->stats)) {
 					stats = &cmd->stats[ent->op];
 					spin_lock_irqsave(&stats->lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a8ed83..14b80b1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1734,7 +1734,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   struct ath9k_hw_cal_data *caldata, bool fastcc)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct timespec ts;
 	u32 saveLedState;
 	u32 saveDefAntenna;
 	u32 macStaId1;
@@ -1784,8 +1783,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	/* Save TSF before chip reset, a cold reset clears it */
 	tsf = ath9k_hw_gettsf64(ah);
-	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
+	usec = ktime_to_us(ktime_get_raw());
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
 		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
@@ -1818,8 +1816,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	/* Restore TSF */
-	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000 - usec;
+	usec = ktime_to_us(ktime_get_raw()) - usec;
 	ath9k_hw_settsf64(ah, tsf + usec);
 
 	if (AR_SREV_9280_20_OR_LATER(ah))
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 5edfcb0..e371825 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -702,6 +702,42 @@ void __iomem *of_iomap(struct device_node *np, int index)
 }
 EXPORT_SYMBOL(of_iomap);
 
+/*
+ * of_io_request_and_map - Requests a resource and maps the memory mapped IO
+ *			   for a given device_node
+ * @device:	the device whose io range will be mapped
+ * @index:	index of the io range
+ * @name:	name of the resource
+ *
+ * Returns a pointer to the requested and mapped memory or an ERR_PTR() encoded
+ * error code on failure. Usage example:
+ *
+ *	base = of_io_request_and_map(node, 0, "foo");
+ *	if (IS_ERR(base))
+ *		return PTR_ERR(base);
+ */
+void __iomem *of_io_request_and_map(struct device_node *np, int index,
+					char *name)
+{
+	struct resource res;
+	void __iomem *mem;
+
+	if (of_address_to_resource(np, index, &res))
+		return IOMEM_ERR_PTR(-EINVAL);
+
+	if (!request_mem_region(res.start, resource_size(&res), name))
+		return IOMEM_ERR_PTR(-EBUSY);
+
+	mem = ioremap(res.start, resource_size(&res));
+	if (!mem) {
+		release_mem_region(res.start, resource_size(&res));
+		return IOMEM_ERR_PTR(-ENOMEM);
+	}
+
+	return mem;
+}
+EXPORT_SYMBOL(of_io_request_and_map);
+
 /**
  * of_dma_get_range - Get DMA range info
  * @np:		device node to get DMA range info
diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 1812f02..daa8e75 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -306,11 +306,9 @@ static struct nsm_handle *nsm_lookup_priv(const struct nsm_private *priv)
 static void nsm_init_private(struct nsm_handle *nsm)
 {
 	u64 *p = (u64 *)&nsm->sm_priv.data;
-	struct timespec ts;
 	s64 ns;
 
-	ktime_get_ts(&ts);
-	ns = timespec_to_ns(&ts);
+	ns = ktime_get_ns();
 	put_unaligned(ns, p);
 	put_unaligned((unsigned long)nsm, p + 1);
 }
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 64db2bc..d7f9199 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -473,13 +473,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	priority = task_prio(task);
 	nice = task_nice(task);
 
-	/* Temporary variable needed for gcc-2.96 */
-	/* convert timespec -> nsec*/
-	start_time =
-		(unsigned long long)task->real_start_time.tv_sec * NSEC_PER_SEC
-				+ task->real_start_time.tv_nsec;
 	/* convert nsec -> ticks */
-	start_time = nsec_to_clock_t(start_time);
+	start_time = nsec_to_clock_t(task->real_start_time);
 
 	seq_printf(m, "%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
 	seq_put_decimal_ll(m, ' ', ppid);
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 0013142..80c3502 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -35,8 +35,9 @@ struct timerfd_ctx {
 	ktime_t moffs;
 	wait_queue_head_t wqh;
 	u64 ticks;
-	int expired;
 	int clockid;
+	short unsigned expired;
+	short unsigned settime_flags;	/* to show in fdinfo */
 	struct rcu_head rcu;
 	struct list_head clist;
 	bool might_cancel;
@@ -92,7 +93,7 @@ static enum alarmtimer_restart timerfd_alarmproc(struct alarm *alarm,
  */
 void timerfd_clock_was_set(void)
 {
-	ktime_t moffs = ktime_get_monotonic_offset();
+	ktime_t moffs = ktime_mono_to_real((ktime_t){ .tv64 = 0 });
 	struct timerfd_ctx *ctx;
 	unsigned long flags;
 
@@ -125,7 +126,7 @@ static bool timerfd_canceled(struct timerfd_ctx *ctx)
 {
 	if (!ctx->might_cancel || ctx->moffs.tv64 != KTIME_MAX)
 		return false;
-	ctx->moffs = ktime_get_monotonic_offset();
+	ctx->moffs = ktime_mono_to_real((ktime_t){ .tv64 = 0 });
 	return true;
 }
 
@@ -196,6 +197,8 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 		if (timerfd_canceled(ctx))
 			return -ECANCELED;
 	}
+
+	ctx->settime_flags = flags & TFD_SETTIME_FLAGS;
 	return 0;
 }
 
@@ -284,11 +287,77 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int timerfd_show(struct seq_file *m, struct file *file)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	struct itimerspec t;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	t.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
+	t.it_interval = ktime_to_timespec(ctx->tintv);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return seq_printf(m,
+			  "clockid: %d\n"
+			  "ticks: %llu\n"
+			  "settime flags: 0%o\n"
+			  "it_value: (%llu, %llu)\n"
+			  "it_interval: (%llu, %llu)\n",
+			  ctx->clockid, (unsigned long long)ctx->ticks,
+			  ctx->settime_flags,
+			  (unsigned long long)t.it_value.tv_sec,
+			  (unsigned long long)t.it_value.tv_nsec,
+			  (unsigned long long)t.it_interval.tv_sec,
+			  (unsigned long long)t.it_interval.tv_nsec);
+}
+#else
+#define timerfd_show NULL
+#endif
+
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	int ret = 0;
+
+	switch (cmd) {
+	case TFD_IOC_SET_TICKS: {
+		u64 ticks;
+
+		if (copy_from_user(&ticks, (u64 __user *)arg, sizeof(ticks)))
+			return -EFAULT;
+		if (!ticks)
+			return -EINVAL;
+
+		spin_lock_irq(&ctx->wqh.lock);
+		if (!timerfd_canceled(ctx)) {
+			ctx->ticks = ticks;
+			if (ticks)
+				wake_up_locked(&ctx->wqh);
+		} else
+			ret = -ECANCELED;
+		spin_unlock_irq(&ctx->wqh.lock);
+		break;
+	}
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
+#else
+#define timerfd_ioctl NULL
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
+	.show_fdinfo	= timerfd_show,
+	.unlocked_ioctl	= timerfd_ioctl,
 };
 
 static int timerfd_fget(int fd, struct fd *p)
@@ -336,7 +405,7 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	else
 		hrtimer_init(&ctx->t.tmr, clockid, HRTIMER_MODE_ABS);
 
-	ctx->moffs = ktime_get_monotonic_offset();
+	ctx->moffs = ktime_mono_to_real((ktime_t){ .tv64 = 0 });
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
 			       O_RDWR | (flags & TFD_SHARED_FCNTL_FLAGS));
diff --git a/include/clocksource/pxa.h b/include/clocksource/pxa.h
new file mode 100644
index 0000000..1efbe5a
--- /dev/null
+++ b/include/clocksource/pxa.h
@@ -0,0 +1,18 @@
+/*
+ * PXA clocksource, clockevents, and OST interrupt handlers.
+ *
+ * Copyright (C) 2014 Robert Jarzmik
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ */
+
+#ifndef _CLOCKSOURCE_PXA_H
+#define _CLOCKSOURCE_PXA_H
+
+extern void pxa_timer_nodt_init(int irq, void __iomem *base,
+			   unsigned long clock_tick_rate);
+
+#endif
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index a16b497..653f0e2 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -162,7 +162,6 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
- * @cycle_last:		most recent cycle counter value seen by ::read()
  * @owner:		module reference, must be set by clocksource in modules
  */
 struct clocksource {
@@ -171,7 +170,6 @@ struct clocksource {
 	 * clocksource itself is cacheline aligned.
 	 */
 	cycle_t (*read)(struct clocksource *cs);
-	cycle_t cycle_last;
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index e7a8d3f..a036d05 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
+ * @cpu:		cpu number
  * @active_bases:	Bitfield to mark bases with active timers
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
@@ -179,6 +180,7 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
+	unsigned int			cpu;
 	unsigned int			active_bases;
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -324,14 +326,6 @@ static inline void timerfd_clock_was_set(void) { }
 #endif
 extern void hrtimers_resume(void);
 
-extern ktime_t ktime_get(void);
-extern ktime_t ktime_get_real(void);
-extern ktime_t ktime_get_boottime(void);
-extern ktime_t ktime_get_monotonic_offset(void);
-extern ktime_t ktime_get_clocktai(void);
-extern ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
-					 ktime_t *offs_tai);
-
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
 
@@ -452,12 +446,6 @@ extern void hrtimer_run_pending(void);
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
-#if BITS_PER_LONG < 64
-extern u64 ktime_divns(const ktime_t kt, s64 div);
-#else /* BITS_PER_LONG < 64 */
-# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
-#endif
-
 /* Show pending timers: */
 extern void sysrq_timer_list_show(void);
 
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index ccde917..15dc6bc 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -277,14 +277,7 @@ static inline bool iio_channel_has_info(const struct iio_chan_spec *chan,
  **/
 static inline s64 iio_get_time_ns(void)
 {
-	struct timespec ts;
-	/*
-	 * calls getnstimeofday.
-	 * If hrtimers then up to ns accurate, if not microsecond.
-	 */
-	ktime_get_real_ts(&ts);
-
-	return timespec_to_ns(&ts);
+	return ktime_get_real_ns();
 }
 
 /* Device operating modes */
diff --git a/include/linux/io.h b/include/linux/io.h
index b76e6e5..d5fc9b8 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -58,6 +58,8 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 }
 #endif
 
+#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
+
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			    unsigned long size);
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index de9e46e..c9d645a 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -27,43 +27,19 @@
 /*
  * ktime_t:
  *
- * On 64-bit CPUs a single 64-bit variable is used to store the hrtimers
+ * A single 64-bit variable is used to store the hrtimers
  * internal representation of time values in scalar nanoseconds. The
  * design plays out best on 64-bit CPUs, where most conversions are
  * NOPs and most arithmetic ktime_t operations are plain arithmetic
  * operations.
  *
- * On 32-bit CPUs an optimized representation of the timespec structure
- * is used to avoid expensive conversions from and to timespecs. The
- * endian-aware order of the tv struct members is chosen to allow
- * mathematical operations on the tv64 member of the union too, which
- * for certain operations produces better code.
- *
- * For architectures with efficient support for 64/32-bit conversions the
- * plain scalar nanosecond based representation can be selected by the
- * config switch CONFIG_KTIME_SCALAR.
  */
 union ktime {
 	s64	tv64;
-#if BITS_PER_LONG != 64 && !defined(CONFIG_KTIME_SCALAR)
-	struct {
-# ifdef __BIG_ENDIAN
-	s32	sec, nsec;
-# else
-	s32	nsec, sec;
-# endif
-	} tv;
-#endif
 };
 
 typedef union ktime ktime_t;		/* Kill this */
 
-/*
- * ktime_t definitions when using the 64-bit scalar representation:
- */
-
-#if (BITS_PER_LONG == 64) || defined(CONFIG_KTIME_SCALAR)
-
 /**
  * ktime_set - Set a ktime_t variable from a seconds/nanoseconds value
  * @secs:	seconds to set
@@ -71,13 +47,12 @@ typedef union ktime ktime_t;		/* Kill this */
  *
  * Return: The ktime_t representation of the value.
  */
-static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
+static inline ktime_t ktime_set(const s64 secs, const unsigned long nsecs)
 {
-#if (BITS_PER_LONG == 64)
 	if (unlikely(secs >= KTIME_SEC_MAX))
 		return (ktime_t){ .tv64 = KTIME_MAX };
-#endif
-	return (ktime_t) { .tv64 = (s64)secs * NSEC_PER_SEC + (s64)nsecs };
+
+	return (ktime_t) { .tv64 = secs * NSEC_PER_SEC + (s64)nsecs };
 }
 
 /* Subtract two ktime_t variables. rem = lhs -rhs: */
@@ -108,6 +83,12 @@ static inline ktime_t timespec_to_ktime(struct timespec ts)
 	return ktime_set(ts.tv_sec, ts.tv_nsec);
 }
 
+/* convert a timespec64 to ktime_t format: */
+static inline ktime_t timespec64_to_ktime(struct timespec64 ts)
+{
+	return ktime_set(ts.tv_sec, ts.tv_nsec);
+}
+
 /* convert a timeval to ktime_t format: */
 static inline ktime_t timeval_to_ktime(struct timeval tv)
 {
@@ -117,159 +98,15 @@ static inline ktime_t timeval_to_ktime(struct timeval tv)
 /* Map the ktime_t to timespec conversion to ns_to_timespec function */
 #define ktime_to_timespec(kt)		ns_to_timespec((kt).tv64)
 
+/* Map the ktime_t to timespec conversion to ns_to_timespec function */
+#define ktime_to_timespec64(kt)		ns_to_timespec64((kt).tv64)
+
 /* Map the ktime_t to timeval conversion to ns_to_timeval function */
 #define ktime_to_timeval(kt)		ns_to_timeval((kt).tv64)
 
 /* Convert ktime_t to nanoseconds - NOP in the scalar storage format: */
 #define ktime_to_ns(kt)			((kt).tv64)
 
-#else	/* !((BITS_PER_LONG == 64) || defined(CONFIG_KTIME_SCALAR)) */
-
-/*
- * Helper macros/inlines to get the ktime_t math right in the timespec
- * representation. The macros are sometimes ugly - their actual use is
- * pretty okay-ish, given the circumstances. We do all this for
- * performance reasons. The pure scalar nsec_t based code was nice and
- * simple, but created too many 64-bit / 32-bit conversions and divisions.
- *
- * Be especially aware that negative values are represented in a way
- * that the tv.sec field is negative and the tv.nsec field is greater
- * or equal to zero but less than nanoseconds per second. This is the
- * same representation which is used by timespecs.
- *
- *   tv.sec < 0 and 0 >= tv.nsec < NSEC_PER_SEC
- */
-
-/* Set a ktime_t variable to a value in sec/nsec representation: */
-static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
-{
-	return (ktime_t) { .tv = { .sec = secs, .nsec = nsecs } };
-}
-
-/**
- * ktime_sub - subtract two ktime_t variables
- * @lhs:	minuend
- * @rhs:	subtrahend
- *
- * Return: The remainder of the subtraction.
- */
-static inline ktime_t ktime_sub(const ktime_t lhs, const ktime_t rhs)
-{
-	ktime_t res;
-
-	res.tv64 = lhs.tv64 - rhs.tv64;
-	if (res.tv.nsec < 0)
-		res.tv.nsec += NSEC_PER_SEC;
-
-	return res;
-}
-
-/**
- * ktime_add - add two ktime_t variables
- * @add1:	addend1
- * @add2:	addend2
- *
- * Return: The sum of @add1 and @add2.
- */
-static inline ktime_t ktime_add(const ktime_t add1, const ktime_t add2)
-{
-	ktime_t res;
-
-	res.tv64 = add1.tv64 + add2.tv64;
-	/*
-	 * performance trick: the (u32) -NSEC gives 0x00000000Fxxxxxxx
-	 * so we subtract NSEC_PER_SEC and add 1 to the upper 32 bit.
-	 *
-	 * it's equivalent to:
-	 *   tv.nsec -= NSEC_PER_SEC
-	 *   tv.sec ++;
-	 */
-	if (res.tv.nsec >= NSEC_PER_SEC)
-		res.tv64 += (u32)-NSEC_PER_SEC;
-
-	return res;
-}
-
-/**
- * ktime_add_ns - Add a scalar nanoseconds value to a ktime_t variable
- * @kt:		addend
- * @nsec:	the scalar nsec value to add
- *
- * Return: The sum of @kt and @nsec in ktime_t format.
- */
-extern ktime_t ktime_add_ns(const ktime_t kt, u64 nsec);
-
-/**
- * ktime_sub_ns - Subtract a scalar nanoseconds value from a ktime_t variable
- * @kt:		minuend
- * @nsec:	the scalar nsec value to subtract
- *
- * Return: The subtraction of @nsec from @kt in ktime_t format.
- */
-extern ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec);
-
-/**
- * timespec_to_ktime - convert a timespec to ktime_t format
- * @ts:		the timespec variable to convert
- *
- * Return: A ktime_t variable with the converted timespec value.
- */
-static inline ktime_t timespec_to_ktime(const struct timespec ts)
-{
-	return (ktime_t) { .tv = { .sec = (s32)ts.tv_sec,
-			   	   .nsec = (s32)ts.tv_nsec } };
-}
-
-/**
- * timeval_to_ktime - convert a timeval to ktime_t format
- * @tv:		the timeval variable to convert
- *
- * Return: A ktime_t variable with the converted timeval value.
- */
-static inline ktime_t timeval_to_ktime(const struct timeval tv)
-{
-	return (ktime_t) { .tv = { .sec = (s32)tv.tv_sec,
-				   .nsec = (s32)(tv.tv_usec *
-						 NSEC_PER_USEC) } };
-}
-
-/**
- * ktime_to_timespec - convert a ktime_t variable to timespec format
- * @kt:		the ktime_t variable to convert
- *
- * Return: The timespec representation of the ktime value.
- */
-static inline struct timespec ktime_to_timespec(const ktime_t kt)
-{
-	return (struct timespec) { .tv_sec = (time_t) kt.tv.sec,
-				   .tv_nsec = (long) kt.tv.nsec };
-}
-
-/**
- * ktime_to_timeval - convert a ktime_t variable to timeval format
- * @kt:		the ktime_t variable to convert
- *
- * Return: The timeval representation of the ktime value.
- */
-static inline struct timeval ktime_to_timeval(const ktime_t kt)
-{
-	return (struct timeval) {
-		.tv_sec = (time_t) kt.tv.sec,
-		.tv_usec = (suseconds_t) (kt.tv.nsec / NSEC_PER_USEC) };
-}
-
-/**
- * ktime_to_ns - convert a ktime_t variable to scalar nanoseconds
- * @kt:		the ktime_t variable to convert
- *
- * Return: The scalar nanoseconds representation of @kt.
- */
-static inline s64 ktime_to_ns(const ktime_t kt)
-{
-	return (s64) kt.tv.sec * NSEC_PER_SEC + kt.tv.nsec;
-}
-
-#endif	/* !((BITS_PER_LONG == 64) || defined(CONFIG_KTIME_SCALAR)) */
 
 /**
  * ktime_equal - Compares two ktime_t variables to see if they are equal
@@ -328,16 +165,20 @@ static inline bool ktime_before(const ktime_t cmp1, const ktime_t cmp2)
 	return ktime_compare(cmp1, cmp2) < 0;
 }
 
+#if BITS_PER_LONG < 64
+extern u64 ktime_divns(const ktime_t kt, s64 div);
+#else /* BITS_PER_LONG < 64 */
+# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
+#endif
+
 static inline s64 ktime_to_us(const ktime_t kt)
 {
-	struct timeval tv = ktime_to_timeval(kt);
-	return (s64) tv.tv_sec * USEC_PER_SEC + tv.tv_usec;
+	return ktime_divns(kt, NSEC_PER_USEC);
 }
 
 static inline s64 ktime_to_ms(const ktime_t kt)
 {
-	struct timeval tv = ktime_to_timeval(kt);
-	return (s64) tv.tv_sec * MSEC_PER_SEC + tv.tv_usec / USEC_PER_MSEC;
+	return ktime_divns(kt, NSEC_PER_MSEC);
 }
 
 static inline s64 ktime_us_delta(const ktime_t later, const ktime_t earlier)
@@ -381,6 +222,25 @@ static inline __must_check bool ktime_to_timespec_cond(const ktime_t kt,
 	}
 }
 
+/**
+ * ktime_to_timespec64_cond - convert a ktime_t variable to timespec64
+ *			    format only if the variable contains data
+ * @kt:		the ktime_t variable to convert
+ * @ts:		the timespec variable to store the result in
+ *
+ * Return: %true if there was a successful conversion, %false if kt was 0.
+ */
+static inline __must_check bool ktime_to_timespec64_cond(const ktime_t kt,
+						       struct timespec64 *ts)
+{
+	if (kt.tv64) {
+		*ts = ktime_to_timespec64(kt);
+		return true;
+	} else {
+		return false;
+	}
+}
+
 /*
  * The resolution of the clocks. The resolution value is returned in
  * the clock_getres() system call to give application programmers an
@@ -390,12 +250,6 @@ static inline __must_check bool ktime_to_timespec_cond(const ktime_t kt,
 #define LOW_RES_NSEC		TICK_NSEC
 #define KTIME_LOW_RES		(ktime_t){ .tv64 = LOW_RES_NSEC }
 
-/* Get the monotonic time in timespec format: */
-extern void ktime_get_ts(struct timespec *ts);
-
-/* Get the real (wall-) time in timespec format: */
-#define ktime_get_real_ts(ts)	getnstimeofday(ts)
-
 static inline ktime_t ns_to_ktime(u64 ns)
 {
 	static const ktime_t ktime_zero = { .tv64 = 0 };
@@ -410,4 +264,6 @@ static inline ktime_t ms_to_ktime(u64 ms)
 	return ktime_add_ms(ktime_zero, ms);
 }
 
+# include <linux/timekeeping.h>
+
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2bce4aa..52d631c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -604,8 +604,8 @@ struct mlx5_cmd_work_ent {
 	int			page_queue;
 	u8			status;
 	u8			token;
-	struct timespec		ts1;
-	struct timespec		ts2;
+	u64			ts1;
+	u64			ts2;
 	u16			op;
 };
 
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index c13b878..fb7b722 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -109,7 +109,12 @@ static inline bool of_dma_is_coherent(struct device_node *np)
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
 void __iomem *of_iomap(struct device_node *node, int index);
+void __iomem *of_io_request_and_map(struct device_node *device,
+					int index, char *name);
 #else
+
+#include <linux/io.h>
+
 static inline int of_address_to_resource(struct device_node *dev, int index,
 					 struct resource *r)
 {
@@ -120,6 +125,12 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
 {
 	return NULL;
 }
+
+static inline void __iomem *of_io_request_and_map(struct device_node *device,
+					int index, char *name)
+{
+	return IOMEM_ERR_PTR(-EINVAL);
+}
 #endif
 
 #if defined(CONFIG_OF_ADDRESS) && defined(CONFIG_PCI)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0..653744a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -813,7 +813,7 @@ struct task_delay_info {
 	 * associated with the operation is added to XXX_delay.
 	 * XXX_delay contains the accumulated delay time in nanoseconds.
 	 */
-	struct timespec blkio_start, blkio_end;	/* Shared by blkio, swapin */
+	u64 blkio_start;	/* Shared by blkio, swapin */
 	u64 blkio_delay;	/* wait for sync block io completion */
 	u64 swapin_delay;	/* wait for swapin block io completion */
 	u32 blkio_count;	/* total count of the number of sync block */
@@ -821,7 +821,7 @@ struct task_delay_info {
 	u32 swapin_count;	/* total count of the number of swapin block */
 				/* io operations performed */
 
-	struct timespec freepages_start, freepages_end;
+	u64 freepages_start;
 	u64 freepages_delay;	/* wait for memory reclaim */
 	u32 freepages_count;	/* total count of memory reclaim */
 };
@@ -1367,8 +1367,8 @@ struct task_struct {
 	} vtime_snap_whence;
 #endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
-	struct timespec start_time; 		/* monotonic time */
-	struct timespec real_start_time;	/* boot based time */
+	u64 start_time;		/* monotonic time in nsec */
+	u64 real_start_time;	/* boot based time in nsec */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
 
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 535f158..cce6e74 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -117,6 +117,22 @@ repeat:
 }
 
 /**
+ * raw_read_seqcount - Read the raw seqcount
+ * @s: pointer to seqcount_t
+ * Returns: count to be passed to read_seqcount_retry
+ *
+ * raw_read_seqcount opens a read critical section of the given
+ * seqcount without any lockdep checking and without checking or
+ * masking the LSB. Calling code is responsible for handling that.
+ */
+static inline unsigned raw_read_seqcount(const seqcount_t *s)
+{
+	unsigned ret = ACCESS_ONCE(s->sequence);
+	smp_rmb();
+	return ret;
+}
+
+/**
  * raw_read_seqcount_begin - start seq-read critical section w/o lockdep
  * @s: pointer to seqcount_t
  * Returns: count to be passed to read_seqcount_retry
@@ -220,6 +236,17 @@ static inline void raw_write_seqcount_end(seqcount_t *s)
 }
 
 /*
+ * raw_write_seqcount_latch - redirect readers to even/odd copy
+ * @s: pointer to seqcount_t
+ */
+static inline void raw_write_seqcount_latch(seqcount_t *s)
+{
+       smp_wmb();      /* prior stores before incrementing "sequence" */
+       s->sequence++;
+       smp_wmb();      /* increment "sequence" before following stores */
+}
+
+/*
  * Sequence counter only version assumes that callers are using their
  * own mutexing.
  */
diff --git a/include/linux/sh_timer.h b/include/linux/sh_timer.h
index 8e1e036..64638b0 100644
--- a/include/linux/sh_timer.h
+++ b/include/linux/sh_timer.h
@@ -2,11 +2,6 @@
 #define __SH_TIMER_H__
 
 struct sh_timer_config {
-	char *name;
-	long channel_offset;
-	int timer_bit;
-	unsigned long clockevent_rating;
-	unsigned long clocksource_rating;
 	unsigned int channels_mask;
 };
 
diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..8c42cf8 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -4,19 +4,10 @@
 # include <linux/cache.h>
 # include <linux/seqlock.h>
 # include <linux/math64.h>
-#include <uapi/linux/time.h>
+# include <linux/time64.h>
 
 extern struct timezone sys_tz;
 
-/* Parameters used to convert the timespec values: */
-#define MSEC_PER_SEC	1000L
-#define USEC_PER_MSEC	1000L
-#define NSEC_PER_USEC	1000L
-#define NSEC_PER_MSEC	1000000L
-#define USEC_PER_SEC	1000000L
-#define NSEC_PER_SEC	1000000000L
-#define FSEC_PER_SEC	1000000000000000LL
-
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
 
 static inline int timespec_equal(const struct timespec *a,
@@ -84,13 +75,6 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 	return ts_delta;
 }
 
-#define KTIME_MAX			((s64)~((u64)1 << 63))
-#if (BITS_PER_LONG == 64)
-# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-#else
-# define KTIME_SEC_MAX			LONG_MAX
-#endif
-
 /*
  * Returns true if the timespec is norm, false if denorm:
  */
@@ -115,27 +99,7 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 	return true;
 }
 
-extern bool persistent_clock_exist;
-
-static inline bool has_persistent_clock(void)
-{
-	return persistent_clock_exist;
-}
-
-extern void read_persistent_clock(struct timespec *ts);
-extern void read_boot_clock(struct timespec *ts);
-extern int persistent_clock_is_local;
-extern int update_persistent_clock(struct timespec now);
-void timekeeping_init(void);
-extern int timekeeping_suspended;
-
-unsigned long get_seconds(void);
-struct timespec current_kernel_time(void);
-struct timespec __current_kernel_time(void); /* does not take xtime_lock */
-struct timespec get_monotonic_coarse(void);
-void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
-				struct timespec *wtom, struct timespec *sleep);
-void timekeeping_inject_sleeptime(struct timespec *delta);
+extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
@@ -153,33 +117,14 @@ void timekeeping_inject_sleeptime(struct timespec *delta);
 extern u32 (*arch_gettimeoffset)(void);
 #endif
 
-extern void do_gettimeofday(struct timeval *tv);
-extern int do_settimeofday(const struct timespec *tv);
-extern int do_sys_settimeofday(const struct timespec *tv,
-			       const struct timezone *tz);
-#define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
-extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 struct itimerval;
 extern int do_setitimer(int which, struct itimerval *value,
 			struct itimerval *ovalue);
-extern unsigned int alarm_setitimer(unsigned int seconds);
 extern int do_getitimer(int which, struct itimerval *value);
-extern int __getnstimeofday(struct timespec *tv);
-extern void getnstimeofday(struct timespec *tv);
-extern void getrawmonotonic(struct timespec *ts);
-extern void getnstime_raw_and_real(struct timespec *ts_raw,
-		struct timespec *ts_real);
-extern void getboottime(struct timespec *ts);
-extern void monotonic_to_bootbased(struct timespec *ts);
-extern void get_monotonic_boottime(struct timespec *ts);
 
-extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
-extern int timekeeping_valid_for_hres(void);
-extern u64 timekeeping_max_deferment(void);
-extern int timekeeping_inject_offset(struct timespec *ts);
-extern s32 timekeeping_get_tai_offset(void);
-extern void timekeeping_set_tai_offset(s32 tai_offset);
-extern void timekeeping_clocktai(struct timespec *ts);
+extern unsigned int alarm_setitimer(unsigned int seconds);
+
+extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/include/linux/time64.h b/include/linux/time64.h
new file mode 100644
index 0000000..a383147
--- /dev/null
+++ b/include/linux/time64.h
@@ -0,0 +1,190 @@
+#ifndef _LINUX_TIME64_H
+#define _LINUX_TIME64_H
+
+#include <uapi/linux/time.h>
+
+typedef __s64 time64_t;
+
+/*
+ * This wants to go into uapi/linux/time.h once we agreed about the
+ * userspace interfaces.
+ */
+#if __BITS_PER_LONG == 64
+# define timespec64 timespec
+#else
+struct timespec64 {
+	time64_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
+};
+#endif
+
+/* Parameters used to convert the timespec values: */
+#define MSEC_PER_SEC	1000L
+#define USEC_PER_MSEC	1000L
+#define NSEC_PER_USEC	1000L
+#define NSEC_PER_MSEC	1000000L
+#define USEC_PER_SEC	1000000L
+#define NSEC_PER_SEC	1000000000L
+#define FSEC_PER_SEC	1000000000000000LL
+
+/* Located here for timespec[64]_valid_strict */
+#define KTIME_MAX			((s64)~((u64)1 << 63))
+#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+
+#if __BITS_PER_LONG == 64
+
+static inline struct timespec timespec64_to_timespec(const struct timespec64 ts64)
+{
+	return ts64;
+}
+
+static inline struct timespec64 timespec_to_timespec64(const struct timespec ts)
+{
+	return ts;
+}
+
+# define timespec64_equal		timespec_equal
+# define timespec64_compare		timespec_compare
+# define set_normalized_timespec64	set_normalized_timespec
+# define timespec64_add_safe		timespec_add_safe
+# define timespec64_add			timespec_add
+# define timespec64_sub			timespec_sub
+# define timespec64_valid		timespec_valid
+# define timespec64_valid_strict	timespec_valid_strict
+# define timespec64_to_ns		timespec_to_ns
+# define ns_to_timespec64		ns_to_timespec
+# define timespec64_add_ns		timespec_add_ns
+
+#else
+
+static inline struct timespec timespec64_to_timespec(const struct timespec64 ts64)
+{
+	struct timespec ret;
+
+	ret.tv_sec = (time_t)ts64.tv_sec;
+	ret.tv_nsec = ts64.tv_nsec;
+	return ret;
+}
+
+static inline struct timespec64 timespec_to_timespec64(const struct timespec ts)
+{
+	struct timespec64 ret;
+
+	ret.tv_sec = ts.tv_sec;
+	ret.tv_nsec = ts.tv_nsec;
+	return ret;
+}
+
+static inline int timespec64_equal(const struct timespec64 *a,
+				   const struct timespec64 *b)
+{
+	return (a->tv_sec == b->tv_sec) && (a->tv_nsec == b->tv_nsec);
+}
+
+/*
+ * lhs < rhs:  return <0
+ * lhs == rhs: return 0
+ * lhs > rhs:  return >0
+ */
+static inline int timespec64_compare(const struct timespec64 *lhs, const struct timespec64 *rhs)
+{
+	if (lhs->tv_sec < rhs->tv_sec)
+		return -1;
+	if (lhs->tv_sec > rhs->tv_sec)
+		return 1;
+	return lhs->tv_nsec - rhs->tv_nsec;
+}
+
+extern void set_normalized_timespec64(struct timespec64 *ts, time64_t sec, s64 nsec);
+
+/*
+ * timespec64_add_safe assumes both values are positive and checks for
+ * overflow. It will return TIME_T_MAX if the returned value would be
+ * smaller then either of the arguments.
+ */
+extern struct timespec64 timespec64_add_safe(const struct timespec64 lhs,
+					 const struct timespec64 rhs);
+
+
+static inline struct timespec64 timespec64_add(struct timespec64 lhs,
+						struct timespec64 rhs)
+{
+	struct timespec64 ts_delta;
+	set_normalized_timespec64(&ts_delta, lhs.tv_sec + rhs.tv_sec,
+				lhs.tv_nsec + rhs.tv_nsec);
+	return ts_delta;
+}
+
+/*
+ * sub = lhs - rhs, in normalized form
+ */
+static inline struct timespec64 timespec64_sub(struct timespec64 lhs,
+						struct timespec64 rhs)
+{
+	struct timespec64 ts_delta;
+	set_normalized_timespec64(&ts_delta, lhs.tv_sec - rhs.tv_sec,
+				lhs.tv_nsec - rhs.tv_nsec);
+	return ts_delta;
+}
+
+/*
+ * Returns true if the timespec64 is norm, false if denorm:
+ */
+static inline bool timespec64_valid(const struct timespec64 *ts)
+{
+	/* Dates before 1970 are bogus */
+	if (ts->tv_sec < 0)
+		return false;
+	/* Can't have more nanoseconds then a second */
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return false;
+	return true;
+}
+
+static inline bool timespec64_valid_strict(const struct timespec64 *ts)
+{
+	if (!timespec64_valid(ts))
+		return false;
+	/* Disallow values that could overflow ktime_t */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+		return false;
+	return true;
+}
+
+/**
+ * timespec64_to_ns - Convert timespec64 to nanoseconds
+ * @ts:		pointer to the timespec64 variable to be converted
+ *
+ * Returns the scalar nanosecond representation of the timespec64
+ * parameter.
+ */
+static inline s64 timespec64_to_ns(const struct timespec64 *ts)
+{
+	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
+}
+
+/**
+ * ns_to_timespec64 - Convert nanoseconds to timespec64
+ * @nsec:	the nanoseconds value to be converted
+ *
+ * Returns the timespec64 representation of the nsec parameter.
+ */
+extern struct timespec64 ns_to_timespec64(const s64 nsec);
+
+/**
+ * timespec64_add_ns - Adds nanoseconds to a timespec64
+ * @a:		pointer to timespec64 to be incremented
+ * @ns:		unsigned nanoseconds value to be added
+ *
+ * This must always be inlined because its used from the x86-64 vdso,
+ * which cannot call other kernel functions.
+ */
+static __always_inline void timespec64_add_ns(struct timespec64 *a, u64 ns)
+{
+	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
+	a->tv_nsec = ns;
+}
+
+#endif
+
+#endif /* _LINUX_TIME64_H */
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index c1825eb..95640dc 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -10,77 +10,100 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 
-/* Structure holding internal timekeeping values. */
-struct timekeeper {
-	/* Current clocksource used for timekeeping. */
+/**
+ * struct tk_read_base - base structure for timekeeping readout
+ * @clock:	Current clocksource used for timekeeping.
+ * @read:	Read function of @clock
+ * @mask:	Bitmask for two's complement subtraction of non 64bit clocks
+ * @cycle_last: @clock cycle value at last update
+ * @mult:	NTP adjusted multiplier for scaled math conversion
+ * @shift:	Shift value for scaled math conversion
+ * @xtime_nsec: Shifted (fractional) nano seconds offset for readout
+ * @base_mono:  ktime_t (nanoseconds) base time for readout
+ *
+ * This struct has size 56 byte on 64 bit. Together with a seqcount it
+ * occupies a single 64byte cache line.
+ *
+ * The struct is separate from struct timekeeper as it is also used
+ * for a fast NMI safe accessor to clock monotonic.
+ */
+struct tk_read_base {
 	struct clocksource	*clock;
-	/* NTP adjusted clock multiplier */
+	cycle_t			(*read)(struct clocksource *cs);
+	cycle_t			mask;
+	cycle_t			cycle_last;
 	u32			mult;
-	/* The shift value of the current clocksource. */
 	u32			shift;
-	/* Number of clock cycles in one NTP interval. */
+	u64			xtime_nsec;
+	ktime_t			base_mono;
+};
+
+/**
+ * struct timekeeper - Structure holding internal timekeeping values.
+ * @tkr:		The readout base structure
+ * @xtime_sec:		Current CLOCK_REALTIME time in seconds
+ * @wall_to_monotonic:	CLOCK_REALTIME to CLOCK_MONOTONIC offset
+ * @offs_real:		Offset clock monotonic -> clock realtime
+ * @offs_boot:		Offset clock monotonic -> clock boottime
+ * @offs_tai:		Offset clock monotonic -> clock tai
+ * @tai_offset:		The current UTC to TAI offset in seconds
+ * @base_raw:		Monotonic raw base time in ktime_t format
+ * @raw_time:		Monotonic raw base time in timespec64 format
+ * @cycle_interval:	Number of clock cycles in one NTP interval
+ * @xtime_interval:	Number of clock shifted nano seconds in one NTP
+ *			interval.
+ * @xtime_remainder:	Shifted nano seconds left over when rounding
+ *			@cycle_interval
+ * @raw_interval:	Raw nano seconds accumulated per NTP interval.
+ * @ntp_error:		Difference between accumulated time and NTP time in ntp
+ *			shifted nano seconds.
+ * @ntp_error_shift:	Shift conversion between clock shifted nano seconds and
+ *			ntp shifted nano seconds.
+ *
+ * Note: For timespec(64) based interfaces wall_to_monotonic is what
+ * we need to add to xtime (or xtime corrected for sub jiffie times)
+ * to get to monotonic time.  Monotonic is pegged at zero at system
+ * boot time, so wall_to_monotonic will be negative, however, we will
+ * ALWAYS keep the tv_nsec part positive so we can use the usual
+ * normalization.
+ *
+ * wall_to_monotonic is moved after resume from suspend for the
+ * monotonic time not to jump. We need to add total_sleep_time to
+ * wall_to_monotonic to get the real boot based time offset.
+ *
+ * wall_to_monotonic is no longer the boot time, getboottime must be
+ * used instead.
+ */
+struct timekeeper {
+	struct tk_read_base	tkr;
+	u64			xtime_sec;
+	struct timespec64	wall_to_monotonic;
+	ktime_t			offs_real;
+	ktime_t			offs_boot;
+	ktime_t			offs_tai;
+	s32			tai_offset;
+	ktime_t			base_raw;
+	struct timespec64	raw_time;
+
+	/* The following members are for timekeeping internal use */
 	cycle_t			cycle_interval;
-	/* Last cycle value (also stored in clock->cycle_last) */
-	cycle_t			cycle_last;
-	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64			xtime_interval;
-	/* shifted nano seconds left over when rounding cycle_interval */
 	s64			xtime_remainder;
-	/* Raw nano seconds accumulated per NTP interval. */
 	u32			raw_interval;
-
-	/* Current CLOCK_REALTIME time in seconds */
-	u64			xtime_sec;
-	/* Clock shifted nano seconds */
-	u64			xtime_nsec;
-
+	/* The ntp_tick_length() value currently being used.
+	 * This cached copy ensures we consistently apply the tick
+	 * length for an entire tick, as ntp_tick_length may change
+	 * mid-tick, and we don't want to apply that new value to
+	 * the tick in progress.
+	 */
+	u64			ntp_tick;
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64			ntp_error;
-	/* Shift conversion between clock shifted nano seconds and
-	 * ntp shifted nano seconds. */
 	u32			ntp_error_shift;
-
-	/*
-	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
-	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
-	 * at zero at system boot time, so wall_to_monotonic will be negative,
-	 * however, we will ALWAYS keep the tv_nsec part positive so we can use
-	 * the usual normalization.
-	 *
-	 * wall_to_monotonic is moved after resume from suspend for the
-	 * monotonic time not to jump. We need to add total_sleep_time to
-	 * wall_to_monotonic to get the real boot based time offset.
-	 *
-	 * - wall_to_monotonic is no longer the boot time, getboottime must be
-	 * used instead.
-	 */
-	struct timespec		wall_to_monotonic;
-	/* Offset clock monotonic -> clock realtime */
-	ktime_t			offs_real;
-	/* time spent in suspend */
-	struct timespec		total_sleep_time;
-	/* Offset clock monotonic -> clock boottime */
-	ktime_t			offs_boot;
-	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
-	struct timespec		raw_time;
-	/* The current UTC to TAI offset in seconds */
-	s32			tai_offset;
-	/* Offset clock monotonic -> clock tai */
-	ktime_t			offs_tai;
-
+	u32			ntp_err_mult;
 };
 
-static inline struct timespec tk_xtime(struct timekeeper *tk)
-{
-	struct timespec ts;
-
-	ts.tv_sec = tk->xtime_sec;
-	ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);
-	return ts;
-}
-
-
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 
 extern void update_vsyscall(struct timekeeper *tk);
@@ -89,17 +112,10 @@ extern void update_vsyscall_tz(void);
 #elif defined(CONFIG_GENERIC_TIME_VSYSCALL_OLD)
 
 extern void update_vsyscall_old(struct timespec *ts, struct timespec *wtm,
-				struct clocksource *c, u32 mult);
+				struct clocksource *c, u32 mult,
+				cycle_t cycle_last);
 extern void update_vsyscall_tz(void);
 
-static inline void update_vsyscall(struct timekeeper *tk)
-{
-	struct timespec xt;
-
-	xt = tk_xtime(tk);
-	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->clock, tk->mult);
-}
-
 #else
 
 static inline void update_vsyscall(struct timekeeper *tk)
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
new file mode 100644
index 0000000..1caa6b0
--- /dev/null
+++ b/include/linux/timekeeping.h
@@ -0,0 +1,209 @@
+#ifndef _LINUX_TIMEKEEPING_H
+#define _LINUX_TIMEKEEPING_H
+
+/* Included from linux/ktime.h */
+
+void timekeeping_init(void);
+extern int timekeeping_suspended;
+
+/*
+ * Get and set timeofday
+ */
+extern void do_gettimeofday(struct timeval *tv);
+extern int do_settimeofday(const struct timespec *tv);
+extern int do_sys_settimeofday(const struct timespec *tv,
+			       const struct timezone *tz);
+
+/*
+ * Kernel time accessors
+ */
+unsigned long get_seconds(void);
+struct timespec current_kernel_time(void);
+/* does not take xtime_lock */
+struct timespec __current_kernel_time(void);
+
+/*
+ * timespec based interfaces
+ */
+struct timespec get_monotonic_coarse(void);
+extern void getrawmonotonic(struct timespec *ts);
+extern void ktime_get_ts64(struct timespec64 *ts);
+
+extern int __getnstimeofday64(struct timespec64 *tv);
+extern void getnstimeofday64(struct timespec64 *tv);
+
+#if BITS_PER_LONG == 64
+static inline int __getnstimeofday(struct timespec *ts)
+{
+	return __getnstimeofday64(ts);
+}
+
+static inline void getnstimeofday(struct timespec *ts)
+{
+	getnstimeofday64(ts);
+}
+
+static inline void ktime_get_ts(struct timespec *ts)
+{
+	ktime_get_ts64(ts);
+}
+
+static inline void ktime_get_real_ts(struct timespec *ts)
+{
+	getnstimeofday64(ts);
+}
+
+#else
+static inline int __getnstimeofday(struct timespec *ts)
+{
+	struct timespec64 ts64;
+	int ret = __getnstimeofday64(&ts64);
+
+	*ts = timespec64_to_timespec(ts64);
+	return ret;
+}
+
+static inline void getnstimeofday(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	getnstimeofday64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+
+static inline void ktime_get_ts(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	ktime_get_ts64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+
+static inline void ktime_get_real_ts(struct timespec *ts)
+{
+	struct timespec64 ts64;
+
+	getnstimeofday64(&ts64);
+	*ts = timespec64_to_timespec(ts64);
+}
+#endif
+
+extern void getboottime(struct timespec *ts);
+
+#define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
+#define ktime_get_real_ts64(ts)	getnstimeofday64(ts)
+
+/*
+ * ktime_t based interfaces
+ */
+
+enum tk_offsets {
+	TK_OFFS_REAL,
+	TK_OFFS_BOOT,
+	TK_OFFS_TAI,
+	TK_OFFS_MAX,
+};
+
+extern ktime_t ktime_get(void);
+extern ktime_t ktime_get_with_offset(enum tk_offsets offs);
+extern ktime_t ktime_mono_to_any(ktime_t tmono, enum tk_offsets offs);
+extern ktime_t ktime_get_raw(void);
+
+/**
+ * ktime_get_real - get the real (wall-) time in ktime_t format
+ */
+static inline ktime_t ktime_get_real(void)
+{
+	return ktime_get_with_offset(TK_OFFS_REAL);
+}
+
+/**
+ * ktime_get_boottime - Returns monotonic time since boot in ktime_t format
+ *
+ * This is similar to CLOCK_MONTONIC/ktime_get, but also includes the
+ * time spent in suspend.
+ */
+static inline ktime_t ktime_get_boottime(void)
+{
+	return ktime_get_with_offset(TK_OFFS_BOOT);
+}
+
+/**
+ * ktime_get_clocktai - Returns the TAI time of day in ktime_t format
+ */
+static inline ktime_t ktime_get_clocktai(void)
+{
+	return ktime_get_with_offset(TK_OFFS_TAI);
+}
+
+/**
+ * ktime_mono_to_real - Convert monotonic time to clock realtime
+ */
+static inline ktime_t ktime_mono_to_real(ktime_t mono)
+{
+	return ktime_mono_to_any(mono, TK_OFFS_REAL);
+}
+
+static inline u64 ktime_get_ns(void)
+{
+	return ktime_to_ns(ktime_get());
+}
+
+static inline u64 ktime_get_real_ns(void)
+{
+	return ktime_to_ns(ktime_get_real());
+}
+
+static inline u64 ktime_get_boot_ns(void)
+{
+	return ktime_to_ns(ktime_get_boottime());
+}
+
+static inline u64 ktime_get_raw_ns(void)
+{
+	return ktime_to_ns(ktime_get_raw());
+}
+
+extern u64 ktime_get_mono_fast_ns(void);
+
+/*
+ * Timespec interfaces utilizing the ktime based ones
+ */
+static inline void get_monotonic_boottime(struct timespec *ts)
+{
+	*ts = ktime_to_timespec(ktime_get_boottime());
+}
+
+static inline void timekeeping_clocktai(struct timespec *ts)
+{
+	*ts = ktime_to_timespec(ktime_get_clocktai());
+}
+
+/*
+ * RTC specific
+ */
+extern void timekeeping_inject_sleeptime(struct timespec *delta);
+
+/*
+ * PPS accessor
+ */
+extern void getnstime_raw_and_real(struct timespec *ts_raw,
+				   struct timespec *ts_real);
+
+/*
+ * Persistent clock related interfaces
+ */
+extern bool persistent_clock_exist;
+extern int persistent_clock_is_local;
+
+static inline bool has_persistent_clock(void)
+{
+	return persistent_clock_exist;
+}
+
+extern void read_persistent_clock(struct timespec *ts);
+extern void read_boot_clock(struct timespec *ts);
+extern int update_persistent_clock(struct timespec now);
+
+
+#endif
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index d3b57fa..bd36ce4 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
@@ -11,6 +11,9 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
+/* For _IO helpers */
+#include <linux/ioctl.h>
+
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
@@ -29,4 +32,6 @@
 /* Flags for timerfd_settime.  */
 #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
+#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
+
 #endif /* _LINUX_TIMERFD_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index f2a8b62..973a40c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -3,12 +3,11 @@
 #
 
 obj-y     = fork.o exec_domain.o panic.o \
-	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
-	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
+	    cpu.o exit.o softirq.o resource.o \
+	    sysctl.o sysctl_binary.o capability.o ptrace.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
-	    extable.o params.o posix-timers.o \
-	    kthread.o sys_ni.o posix-cpu-timers.o \
-	    hrtimer.o nsproxy.o \
+	    extable.o params.o \
+	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o smpboot.o
 
@@ -110,22 +109,6 @@ targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call filechk,ikconfiggz)
 
-$(obj)/time.o: $(obj)/timeconst.h
-
-quiet_cmd_hzfile = HZFILE  $@
-      cmd_hzfile = echo "hz=$(CONFIG_HZ)" > $@
-
-targets += hz.bc
-$(obj)/hz.bc: $(objtree)/include/config/hz.h FORCE
-	$(call if_changed,hzfile)
-
-quiet_cmd_bc  = BC      $@
-      cmd_bc  = bc -q $(filter-out FORCE,$^) > $@
-
-targets += timeconst.h
-$(obj)/timeconst.h: $(obj)/hz.bc $(src)/timeconst.bc FORCE
-	$(call if_changed,bc)
-
 ###############################################################################
 #
 # Roll all the X.509 certificates that we can find together and pull them into
diff --git a/kernel/acct.c b/kernel/acct.c
index 808a86f..a1844f1 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -458,9 +458,7 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	acct_t ac;
 	mm_segment_t fs;
 	unsigned long flim;
-	u64 elapsed;
-	u64 run_time;
-	struct timespec uptime;
+	u64 elapsed, run_time;
 	struct tty_struct *tty;
 	const struct cred *orig_cred;
 
@@ -484,10 +482,8 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	strlcpy(ac.ac_comm, current->comm, sizeof(ac.ac_comm));
 
 	/* calculate run_time in nsec*/
-	do_posix_clock_monotonic_gettime(&uptime);
-	run_time = (u64)uptime.tv_sec*NSEC_PER_SEC + uptime.tv_nsec;
-	run_time -= (u64)current->group_leader->start_time.tv_sec * NSEC_PER_SEC
-		       + current->group_leader->start_time.tv_nsec;
+	run_time = ktime_get_ns();
+	run_time -= current->group_leader->start_time;
 	/* convert nsec -> AHZ */
 	elapsed = nsec_to_AHZ(run_time);
 #if ACCT_VERSION==3
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 2f7c760..379650b 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2472,7 +2472,7 @@ static void kdb_gmtime(struct timespec *tv, struct kdb_tm *tm)
 static void kdb_sysinfo(struct sysinfo *val)
 {
 	struct timespec uptime;
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	memset(val, 0, sizeof(*val));
 	val->uptime = uptime.tv_sec;
 	val->loads[0] = avenrun[0];
diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 54996b7..ef90b04 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -46,42 +46,25 @@ void __delayacct_tsk_init(struct task_struct *tsk)
 }
 
 /*
- * Start accounting for a delay statistic using
- * its starting timestamp (@start)
+ * Finish delay accounting for a statistic using its timestamps (@start),
+ * accumalator (@total) and @count
  */
-
-static inline void delayacct_start(struct timespec *start)
+static void delayacct_end(u64 *start, u64 *total, u32 *count)
 {
-	do_posix_clock_monotonic_gettime(start);
-}
-
-/*
- * Finish delay accounting for a statistic using
- * its timestamps (@start, @end), accumalator (@total) and @count
- */
-
-static void delayacct_end(struct timespec *start, struct timespec *end,
-				u64 *total, u32 *count)
-{
-	struct timespec ts;
-	s64 ns;
+	s64 ns = ktime_get_ns() - *start;
 	unsigned long flags;
 
-	do_posix_clock_monotonic_gettime(end);
-	ts = timespec_sub(*end, *start);
-	ns = timespec_to_ns(&ts);
-	if (ns < 0)
-		return;
-
-	spin_lock_irqsave(&current->delays->lock, flags);
-	*total += ns;
-	(*count)++;
-	spin_unlock_irqrestore(&current->delays->lock, flags);
+	if (ns > 0) {
+		spin_lock_irqsave(&current->delays->lock, flags);
+		*total += ns;
+		(*count)++;
+		spin_unlock_irqrestore(&current->delays->lock, flags);
+	}
 }
 
 void __delayacct_blkio_start(void)
 {
-	delayacct_start(&current->delays->blkio_start);
+	current->delays->blkio_start = ktime_get_ns();
 }
 
 void __delayacct_blkio_end(void)
@@ -89,35 +72,29 @@ void __delayacct_blkio_end(void)
 	if (current->delays->flags & DELAYACCT_PF_SWAPIN)
 		/* Swapin block I/O */
 		delayacct_end(&current->delays->blkio_start,
-			&current->delays->blkio_end,
 			&current->delays->swapin_delay,
 			&current->delays->swapin_count);
 	else	/* Other block I/O */
 		delayacct_end(&current->delays->blkio_start,
-			&current->delays->blkio_end,
 			&current->delays->blkio_delay,
 			&current->delays->blkio_count);
 }
 
 int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 {
-	s64 tmp;
-	unsigned long t1;
-	unsigned long long t2, t3;
-	unsigned long flags;
-	struct timespec ts;
 	cputime_t utime, stime, stimescaled, utimescaled;
+	unsigned long long t2, t3;
+	unsigned long flags, t1;
+	s64 tmp;
 
-	tmp = (s64)d->cpu_run_real_total;
 	task_cputime(tsk, &utime, &stime);
-	cputime_to_timespec(utime + stime, &ts);
-	tmp += timespec_to_ns(&ts);
+	tmp = (s64)d->cpu_run_real_total;
+	tmp += cputime_to_nsecs(utime + stime);
 	d->cpu_run_real_total = (tmp < (s64)d->cpu_run_real_total) ? 0 : tmp;
 
-	tmp = (s64)d->cpu_scaled_run_real_total;
 	task_cputime_scaled(tsk, &utimescaled, &stimescaled);
-	cputime_to_timespec(utimescaled + stimescaled, &ts);
-	tmp += timespec_to_ns(&ts);
+	tmp = (s64)d->cpu_scaled_run_real_total;
+	tmp += cputime_to_nsecs(utimescaled + stimescaled);
 	d->cpu_scaled_run_real_total =
 		(tmp < (s64)d->cpu_scaled_run_real_total) ? 0 : tmp;
 
@@ -169,13 +146,12 @@ __u64 __delayacct_blkio_ticks(struct task_struct *tsk)
 
 void __delayacct_freepages_start(void)
 {
-	delayacct_start(&current->delays->freepages_start);
+	current->delays->freepages_start = ktime_get_ns();
 }
 
 void __delayacct_freepages_end(void)
 {
 	delayacct_end(&current->delays->freepages_start,
-			&current->delays->freepages_end,
 			&current->delays->freepages_delay,
 			&current->delays->freepages_count);
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 6a13c46..627b7f8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1262,9 +1262,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	posix_cpu_timers_init(p);
 
-	do_posix_clock_monotonic_gettime(&p->start_time);
-	p->real_start_time = p->start_time;
-	monotonic_to_bootbased(&p->real_start_time);
+	p->start_time = ktime_get_ns();
+	p->real_start_time = ktime_get_boot_ns();
 	p->io_context = NULL;
 	p->audit_context = NULL;
 	if (clone_flags & CLONE_THREAD)
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index f448513..d626dc9 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -12,6 +12,11 @@ config CLOCKSOURCE_WATCHDOG
 config ARCH_CLOCKSOURCE_DATA
 	bool
 
+# Clocksources require validation of the clocksource against the last
+# cycle update - x86/TSC misfeature
+config CLOCKSOURCE_VALIDATE_LAST_CYCLE
+	bool
+
 # Timekeeping vsyscall support
 config GENERIC_TIME_VSYSCALL
 	bool
@@ -20,10 +25,6 @@ config GENERIC_TIME_VSYSCALL
 config GENERIC_TIME_VSYSCALL_OLD
 	bool
 
-# ktime_t scalar 64bit nsec representation
-config KTIME_SCALAR
-	bool
-
 # Old style timekeeping
 config ARCH_USES_GETTIMEOFFSET
 	bool
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 57a413f..7347426 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,3 +1,4 @@
+obj-y += time.o timer.o hrtimer.o itimer.o posix-timers.o posix-cpu-timers.o
 obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o
 obj-y += timeconv.o posix-clock.o alarmtimer.o
 
@@ -12,3 +13,21 @@ obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
+obj-$(CONFIG_TEST_UDELAY)			+= udelay_test.o
+
+$(obj)/time.o: $(obj)/timeconst.h
+
+quiet_cmd_hzfile = HZFILE  $@
+      cmd_hzfile = echo "hz=$(CONFIG_HZ)" > $@
+
+targets += hz.bc
+$(obj)/hz.bc: $(objtree)/include/config/hz.h FORCE
+	$(call if_changed,hzfile)
+
+quiet_cmd_bc  = BC      $@
+      cmd_bc  = bc -q $(filter-out FORCE,$^) > $@
+
+targets += timeconst.h
+$(obj)/timeconst.h: $(obj)/hz.bc $(src)/timeconst.bc FORCE
+	$(call if_changed,bc)
+
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ba3e502..2e949cc 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -32,6 +32,7 @@
 #include <linux/kthread.h>
 
 #include "tick-internal.h"
+#include "timekeeping_internal.h"
 
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
@@ -249,7 +250,7 @@ void clocksource_mark_unstable(struct clocksource *cs)
 static void clocksource_watchdog(unsigned long data)
 {
 	struct clocksource *cs;
-	cycle_t csnow, wdnow;
+	cycle_t csnow, wdnow, delta;
 	int64_t wd_nsec, cs_nsec;
 	int next_cpu, reset_pending;
 
@@ -282,11 +283,12 @@ static void clocksource_watchdog(unsigned long data)
 			continue;
 		}
 
-		wd_nsec = clocksource_cyc2ns((wdnow - cs->wd_last) & watchdog->mask,
-					     watchdog->mult, watchdog->shift);
+		delta = clocksource_delta(wdnow, cs->wd_last, watchdog->mask);
+		wd_nsec = clocksource_cyc2ns(delta, watchdog->mult,
+					     watchdog->shift);
 
-		cs_nsec = clocksource_cyc2ns((csnow - cs->cs_last) &
-					     cs->mask, cs->mult, cs->shift);
+		delta = clocksource_delta(csnow, cs->cs_last, cs->mask);
+		cs_nsec = clocksource_cyc2ns(delta, cs->mult, cs->shift);
 		cs->cs_last = csnow;
 		cs->wd_last = wdnow;
 
diff --git a/kernel/hrtimer.c b/kernel/time/hrtimer.c
similarity index 94%
rename from kernel/hrtimer.c
rename to kernel/time/hrtimer.c
index 3ab2899..1c2fe7d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -54,6 +54,8 @@
 
 #include <trace/events/timer.h>
 
+#include "timekeeping.h"
+
 /*
  * The timer bases:
  *
@@ -114,21 +116,18 @@ static inline int hrtimer_clockid_to_base(clockid_t clock_id)
  */
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
-	ktime_t xtim, mono, boot;
-	struct timespec xts, tom, slp;
-	s32 tai_offset;
+	ktime_t xtim, mono, boot, tai;
+	ktime_t off_real, off_boot, off_tai;
 
-	get_xtime_and_monotonic_and_sleep_offset(&xts, &tom, &slp);
-	tai_offset = timekeeping_get_tai_offset();
+	mono = ktime_get_update_offsets_tick(&off_real, &off_boot, &off_tai);
+	boot = ktime_add(mono, off_boot);
+	xtim = ktime_add(mono, off_real);
+	tai = ktime_add(xtim, off_tai);
 
-	xtim = timespec_to_ktime(xts);
-	mono = ktime_add(xtim, timespec_to_ktime(tom));
-	boot = ktime_add(mono, timespec_to_ktime(slp));
 	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
 	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time = mono;
 	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time = boot;
-	base->clock_base[HRTIMER_BASE_TAI].softirq_time =
-				ktime_add(xtim,	ktime_set(tai_offset, 0));
+	base->clock_base[HRTIMER_BASE_TAI].softirq_time = tai;
 }
 
 /*
@@ -264,60 +263,6 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
  * too large for inlining:
  */
 #if BITS_PER_LONG < 64
-# ifndef CONFIG_KTIME_SCALAR
-/**
- * ktime_add_ns - Add a scalar nanoseconds value to a ktime_t variable
- * @kt:		addend
- * @nsec:	the scalar nsec value to add
- *
- * Returns the sum of kt and nsec in ktime_t format
- */
-ktime_t ktime_add_ns(const ktime_t kt, u64 nsec)
-{
-	ktime_t tmp;
-
-	if (likely(nsec < NSEC_PER_SEC)) {
-		tmp.tv64 = nsec;
-	} else {
-		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
-
-		/* Make sure nsec fits into long */
-		if (unlikely(nsec > KTIME_SEC_MAX))
-			return (ktime_t){ .tv64 = KTIME_MAX };
-
-		tmp = ktime_set((long)nsec, rem);
-	}
-
-	return ktime_add(kt, tmp);
-}
-
-EXPORT_SYMBOL_GPL(ktime_add_ns);
-
-/**
- * ktime_sub_ns - Subtract a scalar nanoseconds value from a ktime_t variable
- * @kt:		minuend
- * @nsec:	the scalar nsec value to subtract
- *
- * Returns the subtraction of @nsec from @kt in ktime_t format
- */
-ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
-{
-	ktime_t tmp;
-
-	if (likely(nsec < NSEC_PER_SEC)) {
-		tmp.tv64 = nsec;
-	} else {
-		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
-
-		tmp = ktime_set((long)nsec, rem);
-	}
-
-	return ktime_sub(kt, tmp);
-}
-
-EXPORT_SYMBOL_GPL(ktime_sub_ns);
-# endif /* !CONFIG_KTIME_SCALAR */
-
 /*
  * Divide a ktime value by a nanosecond value
  */
@@ -337,6 +282,7 @@ u64 ktime_divns(const ktime_t kt, s64 div)
 
 	return dclc;
 }
+EXPORT_SYMBOL_GPL(ktime_divns);
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
@@ -602,6 +548,11 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
  * timers, we have to check, whether it expires earlier than the timer for
  * which the clock event device was armed.
  *
+ * Note, that in case the state has HRTIMER_STATE_CALLBACK set, no reprogramming
+ * and no expiry check happens. The timer gets enqueued into the rbtree. The
+ * reprogramming and expiry check is done in the hrtimer_interrupt or in the
+ * softirq.
+ *
  * Called with interrupts disabled and base->cpu_base.lock held
  */
 static int hrtimer_reprogram(struct hrtimer *timer,
@@ -662,25 +613,13 @@ static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
 	base->hres_active = 0;
 }
 
-/*
- * When High resolution timers are active, try to reprogram. Note, that in case
- * the state has HRTIMER_STATE_CALLBACK set, no reprogramming and no expiry
- * check happens. The timer gets enqueued into the rbtree. The reprogramming
- * and expiry check is done in the hrtimer_interrupt or in the softirq.
- */
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
-{
-	return base->cpu_base->hres_active && hrtimer_reprogram(timer, base);
-}
-
 static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
 {
 	ktime_t *offs_real = &base->clock_base[HRTIMER_BASE_REALTIME].offset;
 	ktime_t *offs_boot = &base->clock_base[HRTIMER_BASE_BOOTTIME].offset;
 	ktime_t *offs_tai = &base->clock_base[HRTIMER_BASE_TAI].offset;
 
-	return ktime_get_update_offsets(offs_real, offs_boot, offs_tai);
+	return ktime_get_update_offsets_now(offs_real, offs_boot, offs_tai);
 }
 
 /*
@@ -755,8 +694,8 @@ static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
-static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+static inline int hrtimer_reprogram(struct hrtimer *timer,
+				    struct hrtimer_clock_base *base)
 {
 	return 0;
 }
@@ -1013,14 +952,25 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	leftmost = enqueue_hrtimer(timer, new_base);
 
-	/*
-	 * Only allow reprogramming if the new base is on this CPU.
-	 * (it might still be on another CPU if the timer was pending)
-	 *
-	 * XXX send_remote_softirq() ?
-	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
-		&& hrtimer_enqueue_reprogram(timer, new_base)) {
+	if (!leftmost) {
+		unlock_hrtimer_base(timer, &flags);
+		return ret;
+	}
+
+	if (!hrtimer_is_hres_active(timer)) {
+		/*
+		 * Kick to reschedule the next tick to handle the new timer
+		 * on dynticks target.
+		 */
+		wake_up_nohz_cpu(new_base->cpu_base->cpu);
+	} else if (new_base->cpu_base == &__get_cpu_var(hrtimer_bases) &&
+			hrtimer_reprogram(timer, new_base)) {
+		/*
+		 * Only allow reprogramming if the new base is on this CPU.
+		 * (it might still be on another CPU if the timer was pending)
+		 *
+		 * XXX send_remote_softirq() ?
+		 */
 		if (wakeup) {
 			/*
 			 * We need to drop cpu_base->lock to avoid a
@@ -1680,6 +1630,7 @@ static void init_hrtimers_cpu(int cpu)
 		timerqueue_init_head(&cpu_base->clock_base[i].active);
 	}
 
+	cpu_base->cpu = cpu;
 	hrtimer_init_hres(cpu_base);
 }
 
diff --git a/kernel/itimer.c b/kernel/time/itimer.c
similarity index 100%
rename from kernel/itimer.c
rename to kernel/time/itimer.c
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 33db43a..87a346f 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -466,7 +466,8 @@ static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
 static void sync_cmos_clock(struct work_struct *work)
 {
-	struct timespec now, next;
+	struct timespec64 now;
+	struct timespec next;
 	int fail = 1;
 
 	/*
@@ -485,9 +486,9 @@ static void sync_cmos_clock(struct work_struct *work)
 		return;
 	}
 
-	getnstimeofday(&now);
+	getnstimeofday64(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec * 5) {
-		struct timespec adjust = now;
+		struct timespec adjust = timespec64_to_timespec(now);
 
 		fail = -ENODEV;
 		if (persistent_clock_is_local)
@@ -531,7 +532,7 @@ void ntp_notify_cmos_timer(void) { }
 /*
  * Propagate a new txc->status value into the NTP state:
  */
-static inline void process_adj_status(struct timex *txc, struct timespec *ts)
+static inline void process_adj_status(struct timex *txc, struct timespec64 *ts)
 {
 	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
 		time_state = TIME_OK;
@@ -554,7 +555,7 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 
 
 static inline void process_adjtimex_modes(struct timex *txc,
-						struct timespec *ts,
+						struct timespec64 *ts,
 						s32 *time_tai)
 {
 	if (txc->modes & ADJ_STATUS)
@@ -640,7 +641,7 @@ int ntp_validate_timex(struct timex *txc)
  * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
-int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
+int __do_adjtimex(struct timex *txc, struct timespec64 *ts, s32 *time_tai)
 {
 	int result;
 
@@ -684,7 +685,7 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	txc->time.tv_sec = ts->tv_sec;
+	txc->time.tv_sec = (time_t)ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec /= NSEC_PER_USEC;
diff --git a/kernel/time/ntp_internal.h b/kernel/time/ntp_internal.h
index 1950cb4..bbd102a 100644
--- a/kernel/time/ntp_internal.h
+++ b/kernel/time/ntp_internal.h
@@ -7,6 +7,6 @@ extern void ntp_clear(void);
 extern u64 ntp_tick_length(void);
 extern int second_overflow(unsigned long secs);
 extern int ntp_validate_timex(struct timex *);
-extern int __do_adjtimex(struct timex *, struct timespec *, s32 *);
+extern int __do_adjtimex(struct timex *, struct timespec64 *, s32 *);
 extern void __hardpps(const struct timespec *, const struct timespec *);
 #endif /* _LINUX_NTP_INTERNAL_H */
diff --git a/kernel/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
similarity index 100%
rename from kernel/posix-cpu-timers.c
rename to kernel/time/posix-cpu-timers.c
diff --git a/kernel/posix-timers.c b/kernel/time/posix-timers.c
similarity index 99%
rename from kernel/posix-timers.c
rename to kernel/time/posix-timers.c
index 424c2d4..42b463a 100644
--- a/kernel/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -49,6 +49,8 @@
 #include <linux/export.h>
 #include <linux/hashtable.h>
 
+#include "timekeeping.h"
+
 /*
  * Management arrays for POSIX timers. Timers are now kept in static hash table
  * with 512 entries.
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 7ab92b1..c19c1d8 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -4,6 +4,8 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
+#include "timekeeping.h"
+
 extern seqlock_t jiffies_lock;
 
 #define CS_NAME_LEN	32
diff --git a/kernel/time.c b/kernel/time/time.c
similarity index 92%
rename from kernel/time.c
rename to kernel/time/time.c
index 7c7964c..f0294ba 100644
--- a/kernel/time.c
+++ b/kernel/time/time.c
@@ -42,6 +42,7 @@
 #include <asm/unistd.h>
 
 #include "timeconst.h"
+#include "timekeeping.h"
 
 /*
  * The timezone where the local system is located.  Used as a default by some
@@ -420,6 +421,68 @@ struct timeval ns_to_timeval(const s64 nsec)
 }
 EXPORT_SYMBOL(ns_to_timeval);
 
+#if BITS_PER_LONG == 32
+/**
+ * set_normalized_timespec - set timespec sec and nsec parts and normalize
+ *
+ * @ts:		pointer to timespec variable to be set
+ * @sec:	seconds to set
+ * @nsec:	nanoseconds to set
+ *
+ * Set seconds and nanoseconds field of a timespec variable and
+ * normalize to the timespec storage format
+ *
+ * Note: The tv_nsec part is always in the range of
+ *	0 <= tv_nsec < NSEC_PER_SEC
+ * For negative values only the tv_sec field is negative !
+ */
+void set_normalized_timespec64(struct timespec64 *ts, time64_t sec, s64 nsec)
+{
+	while (nsec >= NSEC_PER_SEC) {
+		/*
+		 * The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation. See
+		 * also __iter_div_u64_rem() in include/linux/time.h
+		 */
+		asm("" : "+rm"(nsec));
+		nsec -= NSEC_PER_SEC;
+		++sec;
+	}
+	while (nsec < 0) {
+		asm("" : "+rm"(nsec));
+		nsec += NSEC_PER_SEC;
+		--sec;
+	}
+	ts->tv_sec = sec;
+	ts->tv_nsec = nsec;
+}
+EXPORT_SYMBOL(set_normalized_timespec64);
+
+/**
+ * ns_to_timespec64 - Convert nanoseconds to timespec64
+ * @nsec:       the nanoseconds value to be converted
+ *
+ * Returns the timespec64 representation of the nsec parameter.
+ */
+struct timespec64 ns_to_timespec64(const s64 nsec)
+{
+	struct timespec64 ts;
+	s32 rem;
+
+	if (!nsec)
+		return (struct timespec64) {0, 0};
+
+	ts.tv_sec = div_s64_rem(nsec, NSEC_PER_SEC, &rem);
+	if (unlikely(rem < 0)) {
+		ts.tv_sec--;
+		rem += NSEC_PER_SEC;
+	}
+	ts.tv_nsec = rem;
+
+	return ts;
+}
+EXPORT_SYMBOL(ns_to_timespec64);
+#endif
 /*
  * When we convert to jiffies then we interpret incoming values
  * the following way:
@@ -694,6 +757,7 @@ unsigned long nsecs_to_jiffies(u64 n)
 {
 	return (unsigned long)nsecs_to_jiffies64(n);
 }
+EXPORT_SYMBOL_GPL(nsecs_to_jiffies);
 
 /*
  * Add two timespec values and do a safety check for overflow.
diff --git a/kernel/timeconst.bc b/kernel/time/timeconst.bc
similarity index 100%
rename from kernel/timeconst.bc
rename to kernel/time/timeconst.bc
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 32d8d6a..f36b028 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -32,11 +32,34 @@
 #define TK_MIRROR		(1 << 1)
 #define TK_CLOCK_WAS_SET	(1 << 2)
 
-static struct timekeeper timekeeper;
+/*
+ * The most important data for readout fits into a single 64 byte
+ * cache line.
+ */
+static struct {
+	seqcount_t		seq;
+	struct timekeeper	timekeeper;
+} tk_core ____cacheline_aligned;
+
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
-static seqcount_t timekeeper_seq;
 static struct timekeeper shadow_timekeeper;
 
+/**
+ * struct tk_fast - NMI safe timekeeper
+ * @seq:	Sequence counter for protecting updates. The lowest bit
+ *		is the index for the tk_read_base array
+ * @base:	tk_read_base array. Access is indexed by the lowest bit of
+ *		@seq.
+ *
+ * See @update_fast_timekeeper() below.
+ */
+struct tk_fast {
+	seqcount_t		seq;
+	struct tk_read_base	base[2];
+};
+
+static struct tk_fast tk_fast_mono ____cacheline_aligned;
+
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
@@ -45,49 +68,54 @@ bool __read_mostly persistent_clock_exist = false;
 
 static inline void tk_normalize_xtime(struct timekeeper *tk)
 {
-	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
-		tk->xtime_nsec -= (u64)NSEC_PER_SEC << tk->shift;
+	while (tk->tkr.xtime_nsec >= ((u64)NSEC_PER_SEC << tk->tkr.shift)) {
+		tk->tkr.xtime_nsec -= (u64)NSEC_PER_SEC << tk->tkr.shift;
 		tk->xtime_sec++;
 	}
 }
 
-static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
+static inline struct timespec64 tk_xtime(struct timekeeper *tk)
+{
+	struct timespec64 ts;
+
+	ts.tv_sec = tk->xtime_sec;
+	ts.tv_nsec = (long)(tk->tkr.xtime_nsec >> tk->tkr.shift);
+	return ts;
+}
+
+static void tk_set_xtime(struct timekeeper *tk, const struct timespec64 *ts)
 {
 	tk->xtime_sec = ts->tv_sec;
-	tk->xtime_nsec = (u64)ts->tv_nsec << tk->shift;
+	tk->tkr.xtime_nsec = (u64)ts->tv_nsec << tk->tkr.shift;
 }
 
-static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
+static void tk_xtime_add(struct timekeeper *tk, const struct timespec64 *ts)
 {
 	tk->xtime_sec += ts->tv_sec;
-	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
+	tk->tkr.xtime_nsec += (u64)ts->tv_nsec << tk->tkr.shift;
 	tk_normalize_xtime(tk);
 }
 
-static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
+static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec64 wtm)
 {
-	struct timespec tmp;
+	struct timespec64 tmp;
 
 	/*
 	 * Verify consistency of: offset_real = -wall_to_monotonic
 	 * before modifying anything
 	 */
-	set_normalized_timespec(&tmp, -tk->wall_to_monotonic.tv_sec,
+	set_normalized_timespec64(&tmp, -tk->wall_to_monotonic.tv_sec,
 					-tk->wall_to_monotonic.tv_nsec);
-	WARN_ON_ONCE(tk->offs_real.tv64 != timespec_to_ktime(tmp).tv64);
+	WARN_ON_ONCE(tk->offs_real.tv64 != timespec64_to_ktime(tmp).tv64);
 	tk->wall_to_monotonic = wtm;
-	set_normalized_timespec(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
-	tk->offs_real = timespec_to_ktime(tmp);
+	set_normalized_timespec64(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
+	tk->offs_real = timespec64_to_ktime(tmp);
 	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tk->tai_offset, 0));
 }
 
-static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
+static inline void tk_update_sleep_time(struct timekeeper *tk, ktime_t delta)
 {
-	/* Verify consistency before modifying */
-	WARN_ON_ONCE(tk->offs_boot.tv64 != timespec_to_ktime(tk->total_sleep_time).tv64);
-
-	tk->total_sleep_time	= t;
-	tk->offs_boot		= timespec_to_ktime(t);
+	tk->offs_boot = ktime_add(tk->offs_boot, delta);
 }
 
 /**
@@ -107,9 +135,11 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 	u64 tmp, ntpinterval;
 	struct clocksource *old_clock;
 
-	old_clock = tk->clock;
-	tk->clock = clock;
-	tk->cycle_last = clock->cycle_last = clock->read(clock);
+	old_clock = tk->tkr.clock;
+	tk->tkr.clock = clock;
+	tk->tkr.read = clock->read;
+	tk->tkr.mask = clock->mask;
+	tk->tkr.cycle_last = tk->tkr.read(clock);
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -133,78 +163,212 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 	if (old_clock) {
 		int shift_change = clock->shift - old_clock->shift;
 		if (shift_change < 0)
-			tk->xtime_nsec >>= -shift_change;
+			tk->tkr.xtime_nsec >>= -shift_change;
 		else
-			tk->xtime_nsec <<= shift_change;
+			tk->tkr.xtime_nsec <<= shift_change;
 	}
-	tk->shift = clock->shift;
+	tk->tkr.shift = clock->shift;
 
 	tk->ntp_error = 0;
 	tk->ntp_error_shift = NTP_SCALE_SHIFT - clock->shift;
+	tk->ntp_tick = ntpinterval << tk->ntp_error_shift;
 
 	/*
 	 * The timekeeper keeps its own mult values for the currently
 	 * active clocksource. These value will be adjusted via NTP
 	 * to counteract clock drifting.
 	 */
-	tk->mult = clock->mult;
+	tk->tkr.mult = clock->mult;
+	tk->ntp_err_mult = 0;
 }
 
 /* Timekeeper helper functions. */
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-u32 (*arch_gettimeoffset)(void);
-
-u32 get_arch_timeoffset(void)
-{
-	if (likely(arch_gettimeoffset))
-		return arch_gettimeoffset();
-	return 0;
-}
+static u32 default_arch_gettimeoffset(void) { return 0; }
+u32 (*arch_gettimeoffset)(void) = default_arch_gettimeoffset;
 #else
-static inline u32 get_arch_timeoffset(void) { return 0; }
+static inline u32 arch_gettimeoffset(void) { return 0; }
 #endif
 
-static inline s64 timekeeping_get_ns(struct timekeeper *tk)
+static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
 {
-	cycle_t cycle_now, cycle_delta;
-	struct clocksource *clock;
+	cycle_t cycle_now, delta;
 	s64 nsec;
 
 	/* read clocksource: */
-	clock = tk->clock;
-	cycle_now = clock->read(clock);
+	cycle_now = tkr->read(tkr->clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
 
-	nsec = cycle_delta * tk->mult + tk->xtime_nsec;
-	nsec >>= tk->shift;
+	nsec = delta * tkr->mult + tkr->xtime_nsec;
+	nsec >>= tkr->shift;
 
 	/* If arch requires, add in get_arch_timeoffset() */
-	return nsec + get_arch_timeoffset();
+	return nsec + arch_gettimeoffset();
 }
 
 static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 {
-	cycle_t cycle_now, cycle_delta;
-	struct clocksource *clock;
+	struct clocksource *clock = tk->tkr.clock;
+	cycle_t cycle_now, delta;
 	s64 nsec;
 
 	/* read clocksource: */
-	clock = tk->clock;
-	cycle_now = clock->read(clock);
+	cycle_now = tk->tkr.read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
 
 	/* convert delta to nanoseconds. */
-	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
 
 	/* If arch requires, add in get_arch_timeoffset() */
-	return nsec + get_arch_timeoffset();
+	return nsec + arch_gettimeoffset();
+}
+
+/**
+ * update_fast_timekeeper - Update the fast and NMI safe monotonic timekeeper.
+ * @tk:		The timekeeper from which we take the update
+ * @tkf:	The fast timekeeper to update
+ * @tbase:	The time base for the fast timekeeper (mono/raw)
+ *
+ * We want to use this from any context including NMI and tracing /
+ * instrumenting the timekeeping code itself.
+ *
+ * So we handle this differently than the other timekeeping accessor
+ * functions which retry when the sequence count has changed. The
+ * update side does:
+ *
+ * smp_wmb();	<- Ensure that the last base[1] update is visible
+ * tkf->seq++;
+ * smp_wmb();	<- Ensure that the seqcount update is visible
+ * update(tkf->base[0], tk);
+ * smp_wmb();	<- Ensure that the base[0] update is visible
+ * tkf->seq++;
+ * smp_wmb();	<- Ensure that the seqcount update is visible
+ * update(tkf->base[1], tk);
+ *
+ * The reader side does:
+ *
+ * do {
+ *	seq = tkf->seq;
+ *	smp_rmb();
+ *	idx = seq & 0x01;
+ *	now = now(tkf->base[idx]);
+ *	smp_rmb();
+ * } while (seq != tkf->seq)
+ *
+ * As long as we update base[0] readers are forced off to
+ * base[1]. Once base[0] is updated readers are redirected to base[0]
+ * and the base[1] update takes place.
+ *
+ * So if a NMI hits the update of base[0] then it will use base[1]
+ * which is still consistent. In the worst case this can result is a
+ * slightly wrong timestamp (a few nanoseconds). See
+ * @ktime_get_mono_fast_ns.
+ */
+static void update_fast_timekeeper(struct timekeeper *tk)
+{
+	struct tk_read_base *base = tk_fast_mono.base;
+
+	/* Force readers off to base[1] */
+	raw_write_seqcount_latch(&tk_fast_mono.seq);
+
+	/* Update base[0] */
+	memcpy(base, &tk->tkr, sizeof(*base));
+
+	/* Force readers back to base[0] */
+	raw_write_seqcount_latch(&tk_fast_mono.seq);
+
+	/* Update base[1] */
+	memcpy(base + 1, base, sizeof(*base));
 }
 
+/**
+ * ktime_get_mono_fast_ns - Fast NMI safe access to clock monotonic
+ *
+ * This timestamp is not guaranteed to be monotonic across an update.
+ * The timestamp is calculated by:
+ *
+ *	now = base_mono + clock_delta * slope
+ *
+ * So if the update lowers the slope, readers who are forced to the
+ * not yet updated second array are still using the old steeper slope.
+ *
+ * tmono
+ * ^
+ * |    o  n
+ * |   o n
+ * |  u
+ * | o
+ * |o
+ * |12345678---> reader order
+ *
+ * o = old slope
+ * u = update
+ * n = new slope
+ *
+ * So reader 6 will observe time going backwards versus reader 5.
+ *
+ * While other CPUs are likely to be able observe that, the only way
+ * for a CPU local observation is when an NMI hits in the middle of
+ * the update. Timestamps taken from that NMI context might be ahead
+ * of the following timestamps. Callers need to be aware of that and
+ * deal with it.
+ */
+u64 notrace ktime_get_mono_fast_ns(void)
+{
+	struct tk_read_base *tkr;
+	unsigned int seq;
+	u64 now;
+
+	do {
+		seq = raw_read_seqcount(&tk_fast_mono.seq);
+		tkr = tk_fast_mono.base + (seq & 0x01);
+		now = ktime_to_ns(tkr->base_mono) + timekeeping_get_ns(tkr);
+
+	} while (read_seqcount_retry(&tk_fast_mono.seq, seq));
+	return now;
+}
+EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
+
+#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
+
+static inline void update_vsyscall(struct timekeeper *tk)
+{
+	struct timespec xt;
+
+	xt = timespec64_to_timespec(tk_xtime(tk));
+	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->tkr.clock, tk->tkr.mult,
+			    tk->tkr.cycle_last);
+}
+
+static inline void old_vsyscall_fixup(struct timekeeper *tk)
+{
+	s64 remainder;
+
+	/*
+	* Store only full nanoseconds into xtime_nsec after rounding
+	* it up and add the remainder to the error difference.
+	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
+	* by truncating the remainder in vsyscalls. However, it causes
+	* additional work to be done in timekeeping_adjust(). Once
+	* the vsyscall implementations are converted to use xtime_nsec
+	* (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
+	* users are removed, this can be killed.
+	*/
+	remainder = tk->tkr.xtime_nsec & ((1ULL << tk->tkr.shift) - 1);
+	tk->tkr.xtime_nsec -= remainder;
+	tk->tkr.xtime_nsec += 1ULL << tk->tkr.shift;
+	tk->ntp_error += remainder << tk->ntp_error_shift;
+	tk->ntp_error -= (1ULL << tk->tkr.shift) << tk->ntp_error_shift;
+}
+#else
+#define old_vsyscall_fixup(tk)
+#endif
+
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
 static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
@@ -217,7 +381,7 @@ static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
  */
 int pvclock_gtod_register_notifier(struct notifier_block *nb)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 	int ret;
 
@@ -247,6 +411,29 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
+/*
+ * Update the ktime_t based scalar nsec members of the timekeeper
+ */
+static inline void tk_update_ktime_data(struct timekeeper *tk)
+{
+	s64 nsec;
+
+	/*
+	 * The xtime based monotonic readout is:
+	 *	nsec = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec + now();
+	 * The ktime based monotonic readout is:
+	 *	nsec = base_mono + now();
+	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
+	 */
+	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
+	nsec *= NSEC_PER_SEC;
+	nsec += tk->wall_to_monotonic.tv_nsec;
+	tk->tkr.base_mono = ns_to_ktime(nsec);
+
+	/* Update the monotonic raw base */
+	tk->base_raw = timespec64_to_ktime(tk->raw_time);
+}
+
 /* must hold timekeeper_lock */
 static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 {
@@ -257,8 +444,13 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 	update_vsyscall(tk);
 	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
+	tk_update_ktime_data(tk);
+
 	if (action & TK_MIRROR)
-		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
+		memcpy(&shadow_timekeeper, &tk_core.timekeeper,
+		       sizeof(tk_core.timekeeper));
+
+	update_fast_timekeeper(tk);
 }
 
 /**
@@ -270,49 +462,48 @@ static void timekeeping_update(struct timekeeper *tk, unsigned int action)
  */
 static void timekeeping_forward_now(struct timekeeper *tk)
 {
-	cycle_t cycle_now, cycle_delta;
-	struct clocksource *clock;
+	struct clocksource *clock = tk->tkr.clock;
+	cycle_t cycle_now, delta;
 	s64 nsec;
 
-	clock = tk->clock;
-	cycle_now = clock->read(clock);
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	tk->cycle_last = clock->cycle_last = cycle_now;
+	cycle_now = tk->tkr.read(clock);
+	delta = clocksource_delta(cycle_now, tk->tkr.cycle_last, tk->tkr.mask);
+	tk->tkr.cycle_last = cycle_now;
 
-	tk->xtime_nsec += cycle_delta * tk->mult;
+	tk->tkr.xtime_nsec += delta * tk->tkr.mult;
 
 	/* If arch requires, add in get_arch_timeoffset() */
-	tk->xtime_nsec += (u64)get_arch_timeoffset() << tk->shift;
+	tk->tkr.xtime_nsec += (u64)arch_gettimeoffset() << tk->tkr.shift;
 
 	tk_normalize_xtime(tk);
 
-	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
-	timespec_add_ns(&tk->raw_time, nsec);
+	nsec = clocksource_cyc2ns(delta, clock->mult, clock->shift);
+	timespec64_add_ns(&tk->raw_time, nsec);
 }
 
 /**
- * __getnstimeofday - Returns the time of day in a timespec.
+ * __getnstimeofday64 - Returns the time of day in a timespec64.
  * @ts:		pointer to the timespec to be set
  *
  * Updates the time of day in the timespec.
  * Returns 0 on success, or -ve when suspended (timespec will be undefined).
  */
-int __getnstimeofday(struct timespec *ts)
+int __getnstimeofday64(struct timespec64 *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	s64 nsecs = 0;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		ts->tv_sec = tk->xtime_sec;
-		nsecs = timekeeping_get_ns(tk);
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsecs);
+	timespec64_add_ns(ts, nsecs);
 
 	/*
 	 * Do not bail out early, in case there were callers still using
@@ -322,116 +513,138 @@ int __getnstimeofday(struct timespec *ts)
 		return -EAGAIN;
 	return 0;
 }
-EXPORT_SYMBOL(__getnstimeofday);
+EXPORT_SYMBOL(__getnstimeofday64);
 
 /**
- * getnstimeofday - Returns the time of day in a timespec.
+ * getnstimeofday64 - Returns the time of day in a timespec64.
  * @ts:		pointer to the timespec to be set
  *
  * Returns the time of day in a timespec (WARN if suspended).
  */
-void getnstimeofday(struct timespec *ts)
+void getnstimeofday64(struct timespec64 *ts)
 {
-	WARN_ON(__getnstimeofday(ts));
+	WARN_ON(__getnstimeofday64(ts));
 }
-EXPORT_SYMBOL(getnstimeofday);
+EXPORT_SYMBOL(getnstimeofday64);
 
 ktime_t ktime_get(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
-	s64 secs, nsecs;
+	ktime_t base;
+	s64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
-		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
+		seq = read_seqcount_begin(&tk_core.seq);
+		base = tk->tkr.base_mono;
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
-	/*
-	 * Use ktime_set/ktime_add_ns to create a proper ktime on
-	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
-	 */
-	return ktime_add_ns(ktime_set(secs, 0), nsecs);
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return ktime_add_ns(base, nsecs);
 }
 EXPORT_SYMBOL_GPL(ktime_get);
 
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
+static ktime_t *offsets[TK_OFFS_MAX] = {
+	[TK_OFFS_REAL]	= &tk_core.timekeeper.offs_real,
+	[TK_OFFS_BOOT]	= &tk_core.timekeeper.offs_boot,
+	[TK_OFFS_TAI]	= &tk_core.timekeeper.offs_tai,
+};
+
+ktime_t ktime_get_with_offset(enum tk_offsets offs)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct timespec tomono;
-	s64 nsec;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
+	ktime_t base, *offset = offsets[offs];
+	s64 nsecs;
 
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-		ts->tv_sec = tk->xtime_sec;
-		nsec = timekeeping_get_ns(tk);
-		tomono = tk->wall_to_monotonic;
+		seq = read_seqcount_begin(&tk_core.seq);
+		base = ktime_add(tk->tkr.base_mono, *offset);
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	ts->tv_sec += tomono.tv_sec;
-	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsec + tomono.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
+	return ktime_add_ns(base, nsecs);
 
+}
+EXPORT_SYMBOL_GPL(ktime_get_with_offset);
 
 /**
- * timekeeping_clocktai - Returns the TAI time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec.
+ * ktime_mono_to_any() - convert mononotic time to any other time
+ * @tmono:	time to convert.
+ * @offs:	which offset to use
  */
-void timekeeping_clocktai(struct timespec *ts)
+ktime_t ktime_mono_to_any(ktime_t tmono, enum tk_offsets offs)
 {
-	struct timekeeper *tk = &timekeeper;
+	ktime_t *offset = offsets[offs];
 	unsigned long seq;
-	u64 nsecs;
-
-	WARN_ON(timekeeping_suspended);
+	ktime_t tconv;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
+		tconv = ktime_add(tmono, *offset);
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-		ts->tv_sec = tk->xtime_sec + tk->tai_offset;
-		nsecs = timekeeping_get_ns(tk);
+	return tconv;
+}
+EXPORT_SYMBOL_GPL(ktime_mono_to_any);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+/**
+ * ktime_get_raw - Returns the raw monotonic time in ktime_t format
+ */
+ktime_t ktime_get_raw(void)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+	unsigned int seq;
+	ktime_t base;
+	s64 nsecs;
 
-	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsecs);
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		base = tk->base_raw;
+		nsecs = timekeeping_get_ns_raw(tk);
 
-}
-EXPORT_SYMBOL(timekeeping_clocktai);
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
+	return ktime_add_ns(base, nsecs);
+}
+EXPORT_SYMBOL_GPL(ktime_get_raw);
 
 /**
- * ktime_get_clocktai - Returns the TAI time of day in a ktime
+ * ktime_get_ts64 - get the monotonic clock in timespec64 format
+ * @ts:		pointer to timespec variable
  *
- * Returns the time of day in a ktime.
+ * The function calculates the monotonic clock from the realtime
+ * clock and the wall_to_monotonic offset and stores the result
+ * in normalized timespec format in the variable pointed to by @ts.
  */
-ktime_t ktime_get_clocktai(void)
+void ktime_get_ts64(struct timespec64 *ts)
 {
-	struct timespec ts;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct timespec64 tomono;
+	s64 nsec;
+	unsigned int seq;
+
+	WARN_ON(timekeeping_suspended);
 
-	timekeeping_clocktai(&ts);
-	return timespec_to_ktime(ts);
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		ts->tv_sec = tk->xtime_sec;
+		nsec = timekeeping_get_ns(&tk->tkr);
+		tomono = tk->wall_to_monotonic;
+
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	ts->tv_sec += tomono.tv_sec;
+	ts->tv_nsec = 0;
+	timespec64_add_ns(ts, nsec + tomono.tv_nsec);
 }
-EXPORT_SYMBOL(ktime_get_clocktai);
+EXPORT_SYMBOL_GPL(ktime_get_ts64);
 
 #ifdef CONFIG_NTP_PPS
 
@@ -446,23 +659,23 @@ EXPORT_SYMBOL(ktime_get_clocktai);
  */
 void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	s64 nsecs_raw, nsecs_real;
 
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
-		*ts_raw = tk->raw_time;
+		*ts_raw = timespec64_to_timespec(tk->raw_time);
 		ts_real->tv_sec = tk->xtime_sec;
 		ts_real->tv_nsec = 0;
 
 		nsecs_raw = timekeeping_get_ns_raw(tk);
-		nsecs_real = timekeeping_get_ns(tk);
+		nsecs_real = timekeeping_get_ns(&tk->tkr);
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -479,9 +692,9 @@ EXPORT_SYMBOL(getnstime_raw_and_real);
  */
 void do_gettimeofday(struct timeval *tv)
 {
-	struct timespec now;
+	struct timespec64 now;
 
-	getnstimeofday(&now);
+	getnstimeofday64(&now);
 	tv->tv_sec = now.tv_sec;
 	tv->tv_usec = now.tv_nsec/1000;
 }
@@ -495,15 +708,15 @@ EXPORT_SYMBOL(do_gettimeofday);
  */
 int do_settimeofday(const struct timespec *tv)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct timespec ts_delta, xt;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct timespec64 ts_delta, xt, tmp;
 	unsigned long flags;
 
 	if (!timespec_valid_strict(tv))
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 
@@ -511,13 +724,14 @@ int do_settimeofday(const struct timespec *tv)
 	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
 
-	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, ts_delta));
+	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
 
-	tk_set_xtime(tk, tv);
+	tmp = timespec_to_timespec64(*tv);
+	tk_set_xtime(tk, &tmp);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -535,33 +749,35 @@ EXPORT_SYMBOL(do_settimeofday);
  */
 int timekeeping_inject_offset(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
-	struct timespec tmp;
+	struct timespec64 ts64, tmp;
 	int ret = 0;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
+	ts64 = timespec_to_timespec64(*ts);
+
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 
 	/* Make sure the proposed value is valid */
-	tmp = timespec_add(tk_xtime(tk),  *ts);
-	if (!timespec_valid_strict(&tmp)) {
+	tmp = timespec64_add(tk_xtime(tk),  ts64);
+	if (!timespec64_valid_strict(&tmp)) {
 		ret = -EINVAL;
 		goto error;
 	}
 
-	tk_xtime_add(tk, ts);
-	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
+	tk_xtime_add(tk, &ts64);
+	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts64));
 
 error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -578,14 +794,14 @@ EXPORT_SYMBOL(timekeeping_inject_offset);
  */
 s32 timekeeping_get_tai_offset(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
 	s32 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		ret = tk->tai_offset;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return ret;
 }
@@ -606,14 +822,14 @@ static void __timekeeping_set_tai_offset(struct timekeeper *tk, s32 tai_offset)
  */
 void timekeeping_set_tai_offset(s32 tai_offset)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 	__timekeeping_set_tai_offset(tk, tai_offset);
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	clock_was_set();
 }
@@ -625,14 +841,14 @@ void timekeeping_set_tai_offset(s32 tai_offset)
  */
 static int change_clocksource(void *data)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct clocksource *new, *old;
 	unsigned long flags;
 
 	new = (struct clocksource *) data;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 	/*
@@ -641,7 +857,7 @@ static int change_clocksource(void *data)
 	 */
 	if (try_module_get(new->owner)) {
 		if (!new->enable || new->enable(new) == 0) {
-			old = tk->clock;
+			old = tk->tkr.clock;
 			tk_setup_internals(tk, new);
 			if (old->disable)
 				old->disable(old);
@@ -652,7 +868,7 @@ static int change_clocksource(void *data)
 	}
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return 0;
@@ -667,29 +883,14 @@ static int change_clocksource(void *data)
  */
 int timekeeping_notify(struct clocksource *clock)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 
-	if (tk->clock == clock)
+	if (tk->tkr.clock == clock)
 		return 0;
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
-	return tk->clock == clock ? 0 : -1;
-}
-
-/**
- * ktime_get_real - get the real (wall-) time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get_real(void)
-{
-	struct timespec now;
-
-	getnstimeofday(&now);
-
-	return timespec_to_ktime(now);
+	return tk->tkr.clock == clock ? 0 : -1;
 }
-EXPORT_SYMBOL_GPL(ktime_get_real);
 
 /**
  * getrawmonotonic - Returns the raw monotonic time in a timespec
@@ -699,18 +900,20 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
  */
 void getrawmonotonic(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct timespec64 ts64;
 	unsigned long seq;
 	s64 nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 		nsecs = timekeeping_get_ns_raw(tk);
-		*ts = tk->raw_time;
+		ts64 = tk->raw_time;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	timespec_add_ns(ts, nsecs);
+	timespec64_add_ns(&ts64, nsecs);
+	*ts = timespec64_to_timespec(ts64);
 }
 EXPORT_SYMBOL(getrawmonotonic);
 
@@ -719,16 +922,16 @@ EXPORT_SYMBOL(getrawmonotonic);
  */
 int timekeeping_valid_for_hres(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	int ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
-		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
+		ret = tk->tkr.clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return ret;
 }
@@ -738,16 +941,16 @@ int timekeeping_valid_for_hres(void)
  */
 u64 timekeeping_max_deferment(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long seq;
 	u64 ret;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
-		ret = tk->clock->max_idle_ns;
+		ret = tk->tkr.clock->max_idle_ns;
 
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
 	return ret;
 }
@@ -787,14 +990,15 @@ void __weak read_boot_clock(struct timespec *ts)
  */
 void __init timekeeping_init(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now, boot, tmp;
-
-	read_persistent_clock(&now);
+	struct timespec64 now, boot, tmp;
+	struct timespec ts;
 
-	if (!timespec_valid_strict(&now)) {
+	read_persistent_clock(&ts);
+	now = timespec_to_timespec64(ts);
+	if (!timespec64_valid_strict(&now)) {
 		pr_warn("WARNING: Persistent clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		now.tv_sec = 0;
@@ -802,8 +1006,9 @@ void __init timekeeping_init(void)
 	} else if (now.tv_sec || now.tv_nsec)
 		persistent_clock_exist = true;
 
-	read_boot_clock(&boot);
-	if (!timespec_valid_strict(&boot)) {
+	read_boot_clock(&ts);
+	boot = timespec_to_timespec64(ts);
+	if (!timespec64_valid_strict(&boot)) {
 		pr_warn("WARNING: Boot clock returned invalid value!\n"
 			"         Check your CMOS/BIOS settings.\n");
 		boot.tv_sec = 0;
@@ -811,7 +1016,7 @@ void __init timekeeping_init(void)
 	}
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 	ntp_init();
 
 	clock = clocksource_default_clock();
@@ -822,24 +1027,21 @@ void __init timekeeping_init(void)
 	tk_set_xtime(tk, &now);
 	tk->raw_time.tv_sec = 0;
 	tk->raw_time.tv_nsec = 0;
+	tk->base_raw.tv64 = 0;
 	if (boot.tv_sec == 0 && boot.tv_nsec == 0)
 		boot = tk_xtime(tk);
 
-	set_normalized_timespec(&tmp, -boot.tv_sec, -boot.tv_nsec);
+	set_normalized_timespec64(&tmp, -boot.tv_sec, -boot.tv_nsec);
 	tk_set_wall_to_mono(tk, tmp);
 
-	tmp.tv_sec = 0;
-	tmp.tv_nsec = 0;
-	tk_set_sleep_time(tk, tmp);
-
-	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
+	timekeeping_update(tk, TK_MIRROR);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
 /* time in seconds when suspend began */
-static struct timespec timekeeping_suspend_time;
+static struct timespec64 timekeeping_suspend_time;
 
 /**
  * __timekeeping_inject_sleeptime - Internal function to add sleep interval
@@ -849,17 +1051,17 @@ static struct timespec timekeeping_suspend_time;
  * adds the sleep offset to the timekeeping variables.
  */
 static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
-							struct timespec *delta)
+					   struct timespec64 *delta)
 {
-	if (!timespec_valid_strict(delta)) {
+	if (!timespec64_valid_strict(delta)) {
 		printk_deferred(KERN_WARNING
 				"__timekeeping_inject_sleeptime: Invalid "
 				"sleep delta value!\n");
 		return;
 	}
 	tk_xtime_add(tk, delta);
-	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *delta));
-	tk_set_sleep_time(tk, timespec_add(tk->total_sleep_time, *delta));
+	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, *delta));
+	tk_update_sleep_time(tk, timespec64_to_ktime(*delta));
 	tk_debug_account_sleep_time(delta);
 }
 
@@ -875,7 +1077,8 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
  */
 void timekeeping_inject_sleeptime(struct timespec *delta)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct timespec64 tmp;
 	unsigned long flags;
 
 	/*
@@ -886,15 +1089,16 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 		return;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	timekeeping_forward_now(tk);
 
-	__timekeeping_inject_sleeptime(tk, delta);
+	tmp = timespec_to_timespec64(*delta);
+	__timekeeping_inject_sleeptime(tk, &tmp);
 
 	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
@@ -910,20 +1114,22 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
  */
 static void timekeeping_resume(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct clocksource *clock = tk->clock;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct clocksource *clock = tk->tkr.clock;
 	unsigned long flags;
-	struct timespec ts_new, ts_delta;
+	struct timespec64 ts_new, ts_delta;
+	struct timespec tmp;
 	cycle_t cycle_now, cycle_delta;
 	bool suspendtime_found = false;
 
-	read_persistent_clock(&ts_new);
+	read_persistent_clock(&tmp);
+	ts_new = timespec_to_timespec64(tmp);
 
 	clockevents_resume();
 	clocksource_resume();
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	/*
 	 * After system resumes, we need to calculate the suspended time and
@@ -937,15 +1143,16 @@ static void timekeeping_resume(void)
 	 * The less preferred source will only be tried if there is no better
 	 * usable source. The rtc part is handled separately in rtc core code.
 	 */
-	cycle_now = clock->read(clock);
+	cycle_now = tk->tkr.read(clock);
 	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
-		cycle_now > clock->cycle_last) {
+		cycle_now > tk->tkr.cycle_last) {
 		u64 num, max = ULLONG_MAX;
 		u32 mult = clock->mult;
 		u32 shift = clock->shift;
 		s64 nsec = 0;
 
-		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+		cycle_delta = clocksource_delta(cycle_now, tk->tkr.cycle_last,
+						tk->tkr.mask);
 
 		/*
 		 * "cycle_delta * mutl" may cause 64 bits overflow, if the
@@ -960,10 +1167,10 @@ static void timekeeping_resume(void)
 		}
 		nsec += ((u64) cycle_delta * mult) >> shift;
 
-		ts_delta = ns_to_timespec(nsec);
+		ts_delta = ns_to_timespec64(nsec);
 		suspendtime_found = true;
-	} else if (timespec_compare(&ts_new, &timekeeping_suspend_time) > 0) {
-		ts_delta = timespec_sub(ts_new, timekeeping_suspend_time);
+	} else if (timespec64_compare(&ts_new, &timekeeping_suspend_time) > 0) {
+		ts_delta = timespec64_sub(ts_new, timekeeping_suspend_time);
 		suspendtime_found = true;
 	}
 
@@ -971,11 +1178,11 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
 	/* Re-base the last cycle value */
-	tk->cycle_last = clock->cycle_last = cycle_now;
+	tk->tkr.cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
@@ -988,12 +1195,14 @@ static void timekeeping_resume(void)
 
 static int timekeeping_suspend(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
-	struct timespec		delta, delta_delta;
-	static struct timespec	old_delta;
+	struct timespec64		delta, delta_delta;
+	static struct timespec64	old_delta;
+	struct timespec tmp;
 
-	read_persistent_clock(&timekeeping_suspend_time);
+	read_persistent_clock(&tmp);
+	timekeeping_suspend_time = timespec_to_timespec64(tmp);
 
 	/*
 	 * On some systems the persistent_clock can not be detected at
@@ -1004,7 +1213,7 @@ static int timekeeping_suspend(void)
 		persistent_clock_exist = true;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;
 
@@ -1014,8 +1223,8 @@ static int timekeeping_suspend(void)
 	 * try to compensate so the difference in system time
 	 * and persistent_clock time stays close to constant.
 	 */
-	delta = timespec_sub(tk_xtime(tk), timekeeping_suspend_time);
-	delta_delta = timespec_sub(delta, old_delta);
+	delta = timespec64_sub(tk_xtime(tk), timekeeping_suspend_time);
+	delta_delta = timespec64_sub(delta, old_delta);
 	if (abs(delta_delta.tv_sec)  >= 2) {
 		/*
 		 * if delta_delta is too large, assume time correction
@@ -1025,11 +1234,11 @@ static int timekeeping_suspend(void)
 	} else {
 		/* Otherwise try to adjust old_system to compensate */
 		timekeeping_suspend_time =
-			timespec_add(timekeeping_suspend_time, delta_delta);
+			timespec64_add(timekeeping_suspend_time, delta_delta);
 	}
 
 	timekeeping_update(tk, TK_MIRROR);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
@@ -1050,125 +1259,34 @@ static int __init timekeeping_init_ops(void)
 	register_syscore_ops(&timekeeping_syscore_ops);
 	return 0;
 }
-
 device_initcall(timekeeping_init_ops);
 
 /*
- * If the error is already larger, we look ahead even further
- * to compensate for late or lost adjustments.
+ * Apply a multiplier adjustment to the timekeeper
  */
-static __always_inline int timekeeping_bigadjust(struct timekeeper *tk,
-						 s64 error, s64 *interval,
-						 s64 *offset)
+static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
+							 s64 offset,
+							 bool negative,
+							 int adj_scale)
 {
-	s64 tick_error, i;
-	u32 look_ahead, adj;
-	s32 error2, mult;
-
-	/*
-	 * Use the current error value to determine how much to look ahead.
-	 * The larger the error the slower we adjust for it to avoid problems
-	 * with losing too many ticks, otherwise we would overadjust and
-	 * produce an even larger error.  The smaller the adjustment the
-	 * faster we try to adjust for it, as lost ticks can do less harm
-	 * here.  This is tuned so that an error of about 1 msec is adjusted
-	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
-	 */
-	error2 = tk->ntp_error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
-	error2 = abs(error2);
-	for (look_ahead = 0; error2 > 0; look_ahead++)
-		error2 >>= 2;
+	s64 interval = tk->cycle_interval;
+	s32 mult_adj = 1;
 
-	/*
-	 * Now calculate the error in (1 << look_ahead) ticks, but first
-	 * remove the single look ahead already included in the error.
-	 */
-	tick_error = ntp_tick_length() >> (tk->ntp_error_shift + 1);
-	tick_error -= tk->xtime_interval >> 1;
-	error = ((error - tick_error) >> look_ahead) + tick_error;
-
-	/* Finally calculate the adjustment shift value.  */
-	i = *interval;
-	mult = 1;
-	if (error < 0) {
-		error = -error;
-		*interval = -*interval;
-		*offset = -*offset;
-		mult = -1;
+	if (negative) {
+		mult_adj = -mult_adj;
+		interval = -interval;
+		offset  = -offset;
 	}
-	for (adj = 0; error > i; adj++)
-		error >>= 1;
-
-	*interval <<= adj;
-	*offset <<= adj;
-	return mult << adj;
-}
-
-/*
- * Adjust the multiplier to reduce the error value,
- * this is optimized for the most common adjustments of -1,0,1,
- * for other values we can do a bit more work.
- */
-static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
-{
-	s64 error, interval = tk->cycle_interval;
-	int adj;
+	mult_adj <<= adj_scale;
+	interval <<= adj_scale;
+	offset <<= adj_scale;
 
 	/*
-	 * The point of this is to check if the error is greater than half
-	 * an interval.
-	 *
-	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
-	 *
-	 * Note we subtract one in the shift, so that error is really error*2.
-	 * This "saves" dividing(shifting) interval twice, but keeps the
-	 * (error > interval) comparison as still measuring if error is
-	 * larger than half an interval.
-	 *
-	 * Note: It does not "save" on aggravation when reading the code.
-	 */
-	error = tk->ntp_error >> (tk->ntp_error_shift - 1);
-	if (error > interval) {
-		/*
-		 * We now divide error by 4(via shift), which checks if
-		 * the error is greater than twice the interval.
-		 * If it is greater, we need a bigadjust, if its smaller,
-		 * we can adjust by 1.
-		 */
-		error >>= 2;
-		if (likely(error <= interval))
-			adj = 1;
-		else
-			adj = timekeeping_bigadjust(tk, error, &interval, &offset);
-	} else {
-		if (error < -interval) {
-			/* See comment above, this is just switched for the negative */
-			error >>= 2;
-			if (likely(error >= -interval)) {
-				adj = -1;
-				interval = -interval;
-				offset = -offset;
-			} else {
-				adj = timekeeping_bigadjust(tk, error, &interval, &offset);
-			}
-		} else {
-			goto out_adjust;
-		}
-	}
-
-	if (unlikely(tk->clock->maxadj &&
-		(tk->mult + adj > tk->clock->mult + tk->clock->maxadj))) {
-		printk_deferred_once(KERN_WARNING
-			"Adjusting %s more than 11%% (%ld vs %ld)\n",
-			tk->clock->name, (long)tk->mult + adj,
-			(long)tk->clock->mult + tk->clock->maxadj);
-	}
-	/*
 	 * So the following can be confusing.
 	 *
-	 * To keep things simple, lets assume adj == 1 for now.
+	 * To keep things simple, lets assume mult_adj == 1 for now.
 	 *
-	 * When adj != 1, remember that the interval and offset values
+	 * When mult_adj != 1, remember that the interval and offset values
 	 * have been appropriately scaled so the math is the same.
 	 *
 	 * The basic idea here is that we're increasing the multiplier
@@ -1212,12 +1330,78 @@ static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
 	 *
 	 * XXX - TODO: Doc ntp_error calculation.
 	 */
-	tk->mult += adj;
+	tk->tkr.mult += mult_adj;
 	tk->xtime_interval += interval;
-	tk->xtime_nsec -= offset;
+	tk->tkr.xtime_nsec -= offset;
 	tk->ntp_error -= (interval - offset) << tk->ntp_error_shift;
+}
+
+/*
+ * Calculate the multiplier adjustment needed to match the frequency
+ * specified by NTP
+ */
+static __always_inline void timekeeping_freqadjust(struct timekeeper *tk,
+							s64 offset)
+{
+	s64 interval = tk->cycle_interval;
+	s64 xinterval = tk->xtime_interval;
+	s64 tick_error;
+	bool negative;
+	u32 adj;
+
+	/* Remove any current error adj from freq calculation */
+	if (tk->ntp_err_mult)
+		xinterval -= tk->cycle_interval;
+
+	tk->ntp_tick = ntp_tick_length();
+
+	/* Calculate current error per tick */
+	tick_error = ntp_tick_length() >> tk->ntp_error_shift;
+	tick_error -= (xinterval + tk->xtime_remainder);
+
+	/* Don't worry about correcting it if its small */
+	if (likely((tick_error >= 0) && (tick_error <= interval)))
+		return;
+
+	/* preserve the direction of correction */
+	negative = (tick_error < 0);
+
+	/* Sort out the magnitude of the correction */
+	tick_error = abs(tick_error);
+	for (adj = 0; tick_error > interval; adj++)
+		tick_error >>= 1;
+
+	/* scale the corrections */
+	timekeeping_apply_adjustment(tk, offset, negative, adj);
+}
+
+/*
+ * Adjust the timekeeper's multiplier to the correct frequency
+ * and also to reduce the accumulated error value.
+ */
+static void timekeeping_adjust(struct timekeeper *tk, s64 offset)
+{
+	/* Correct for the current frequency error */
+	timekeeping_freqadjust(tk, offset);
+
+	/* Next make a small adjustment to fix any cumulative error */
+	if (!tk->ntp_err_mult && (tk->ntp_error > 0)) {
+		tk->ntp_err_mult = 1;
+		timekeeping_apply_adjustment(tk, offset, 0, 0);
+	} else if (tk->ntp_err_mult && (tk->ntp_error <= 0)) {
+		/* Undo any existing error adjustment */
+		timekeeping_apply_adjustment(tk, offset, 1, 0);
+		tk->ntp_err_mult = 0;
+	}
+
+	if (unlikely(tk->tkr.clock->maxadj &&
+		(tk->tkr.mult > tk->tkr.clock->mult + tk->tkr.clock->maxadj))) {
+		printk_once(KERN_WARNING
+			"Adjusting %s more than 11%% (%ld vs %ld)\n",
+			tk->tkr.clock->name, (long)tk->tkr.mult,
+			(long)tk->tkr.clock->mult + tk->tkr.clock->maxadj);
+	}
 
-out_adjust:
 	/*
 	 * It may be possible that when we entered this function, xtime_nsec
 	 * was very small.  Further, if we're slightly speeding the clocksource
@@ -1232,12 +1416,11 @@ out_adjust:
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)tk->xtime_nsec < 0)) {
-		s64 neg = -(s64)tk->xtime_nsec;
-		tk->xtime_nsec = 0;
+	if (unlikely((s64)tk->tkr.xtime_nsec < 0)) {
+		s64 neg = -(s64)tk->tkr.xtime_nsec;
+		tk->tkr.xtime_nsec = 0;
 		tk->ntp_error += neg << tk->ntp_error_shift;
 	}
-
 }
 
 /**
@@ -1250,26 +1433,26 @@ out_adjust:
  */
 static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
-	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
+	u64 nsecps = (u64)NSEC_PER_SEC << tk->tkr.shift;
 	unsigned int clock_set = 0;
 
-	while (tk->xtime_nsec >= nsecps) {
+	while (tk->tkr.xtime_nsec >= nsecps) {
 		int leap;
 
-		tk->xtime_nsec -= nsecps;
+		tk->tkr.xtime_nsec -= nsecps;
 		tk->xtime_sec++;
 
 		/* Figure out if its a leap sec and apply if needed */
 		leap = second_overflow(tk->xtime_sec);
 		if (unlikely(leap)) {
-			struct timespec ts;
+			struct timespec64 ts;
 
 			tk->xtime_sec += leap;
 
 			ts.tv_sec = leap;
 			ts.tv_nsec = 0;
 			tk_set_wall_to_mono(tk,
-				timespec_sub(tk->wall_to_monotonic, ts));
+				timespec64_sub(tk->wall_to_monotonic, ts));
 
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
@@ -1301,9 +1484,9 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 
 	/* Accumulate one shifted interval */
 	offset -= interval;
-	tk->cycle_last += interval;
+	tk->tkr.cycle_last += interval;
 
-	tk->xtime_nsec += tk->xtime_interval << shift;
+	tk->tkr.xtime_nsec += tk->xtime_interval << shift;
 	*clock_set |= accumulate_nsecs_to_secs(tk);
 
 	/* Accumulate raw time */
@@ -1317,48 +1500,20 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 	tk->raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	tk->ntp_error += ntp_tick_length() << shift;
+	tk->ntp_error += tk->ntp_tick << shift;
 	tk->ntp_error -= (tk->xtime_interval + tk->xtime_remainder) <<
 						(tk->ntp_error_shift + shift);
 
 	return offset;
 }
 
-#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
-static inline void old_vsyscall_fixup(struct timekeeper *tk)
-{
-	s64 remainder;
-
-	/*
-	* Store only full nanoseconds into xtime_nsec after rounding
-	* it up and add the remainder to the error difference.
-	* XXX - This is necessary to avoid small 1ns inconsistnecies caused
-	* by truncating the remainder in vsyscalls. However, it causes
-	* additional work to be done in timekeeping_adjust(). Once
-	* the vsyscall implementations are converted to use xtime_nsec
-	* (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
-	* users are removed, this can be killed.
-	*/
-	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
-	tk->xtime_nsec -= remainder;
-	tk->xtime_nsec += 1ULL << tk->shift;
-	tk->ntp_error += remainder << tk->ntp_error_shift;
-	tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
-}
-#else
-#define old_vsyscall_fixup(tk)
-#endif
-
-
-
 /**
  * update_wall_time - Uses the current clocksource to increment the wall time
  *
  */
 void update_wall_time(void)
 {
-	struct clocksource *clock;
-	struct timekeeper *real_tk = &timekeeper;
+	struct timekeeper *real_tk = &tk_core.timekeeper;
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
@@ -1371,12 +1526,11 @@ void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = real_tk->clock;
-
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = real_tk->cycle_interval;
 #else
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
+	offset = clocksource_delta(tk->tkr.read(tk->tkr.clock),
+				   tk->tkr.cycle_last, tk->tkr.mask);
 #endif
 
 	/* Check if there's really nothing to do */
@@ -1418,9 +1572,7 @@ void update_wall_time(void)
 	 */
 	clock_set |= accumulate_nsecs_to_secs(tk);
 
-	write_seqcount_begin(&timekeeper_seq);
-	/* Update clock->cycle_last with the new value */
-	clock->cycle_last = tk->cycle_last;
+	write_seqcount_begin(&tk_core.seq);
 	/*
 	 * Update the real timekeeper.
 	 *
@@ -1428,12 +1580,12 @@ void update_wall_time(void)
 	 * requires changes to all other timekeeper usage sites as
 	 * well, i.e. move the timekeeper pointer getter into the
 	 * spinlocked/seqcount protected sections. And we trade this
-	 * memcpy under the timekeeper_seq against one before we start
+	 * memcpy under the tk_core.seq against one before we start
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
 	timekeeping_update(real_tk, clock_set);
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 	if (clock_set)
@@ -1454,83 +1606,16 @@ out:
  */
 void getboottime(struct timespec *ts)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct timespec boottime = {
-		.tv_sec = tk->wall_to_monotonic.tv_sec +
-				tk->total_sleep_time.tv_sec,
-		.tv_nsec = tk->wall_to_monotonic.tv_nsec +
-				tk->total_sleep_time.tv_nsec
-	};
-
-	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(getboottime);
-
-/**
- * get_monotonic_boottime - Returns monotonic time since boot
- * @ts:		pointer to the timespec to be set
- *
- * Returns the monotonic time since boot in a timespec.
- *
- * This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
- * includes the time spent in suspend.
- */
-void get_monotonic_boottime(struct timespec *ts)
-{
-	struct timekeeper *tk = &timekeeper;
-	struct timespec tomono, sleep;
-	s64 nsec;
-	unsigned int seq;
-
-	WARN_ON(timekeeping_suspended);
-
-	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-		ts->tv_sec = tk->xtime_sec;
-		nsec = timekeeping_get_ns(tk);
-		tomono = tk->wall_to_monotonic;
-		sleep = tk->total_sleep_time;
-
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
-
-	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
-	ts->tv_nsec = 0;
-	timespec_add_ns(ts, nsec + tomono.tv_nsec + sleep.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(get_monotonic_boottime);
-
-/**
- * ktime_get_boottime - Returns monotonic time since boot in a ktime
- *
- * Returns the monotonic time since boot in a ktime
- *
- * This is similar to CLOCK_MONTONIC/ktime_get, but also
- * includes the time spent in suspend.
- */
-ktime_t ktime_get_boottime(void)
-{
-	struct timespec ts;
-
-	get_monotonic_boottime(&ts);
-	return timespec_to_ktime(ts);
-}
-EXPORT_SYMBOL_GPL(ktime_get_boottime);
-
-/**
- * monotonic_to_bootbased - Convert the monotonic time to boot based.
- * @ts:		pointer to the timespec to be converted
- */
-void monotonic_to_bootbased(struct timespec *ts)
-{
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	ktime_t t = ktime_sub(tk->offs_real, tk->offs_boot);
 
-	*ts = timespec_add(*ts, tk->total_sleep_time);
+	*ts = ktime_to_timespec(t);
 }
-EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
+EXPORT_SYMBOL_GPL(getboottime);
 
 unsigned long get_seconds(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 
 	return tk->xtime_sec;
 }
@@ -1538,43 +1623,44 @@ EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 
-	return tk_xtime(tk);
+	return timespec64_to_timespec(tk_xtime(tk));
 }
 
 struct timespec current_kernel_time(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct timespec now;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct timespec64 now;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		now = tk_xtime(tk);
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	return now;
+	return timespec64_to_timespec(now);
 }
 EXPORT_SYMBOL(current_kernel_time);
 
 struct timespec get_monotonic_coarse(void)
 {
-	struct timekeeper *tk = &timekeeper;
-	struct timespec now, mono;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct timespec64 now, mono;
 	unsigned long seq;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
 		now = tk_xtime(tk);
 		mono = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
+	set_normalized_timespec64(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
-	return now;
+
+	return timespec64_to_timespec(now);
 }
 
 /*
@@ -1587,29 +1673,38 @@ void do_timer(unsigned long ticks)
 }
 
 /**
- * get_xtime_and_monotonic_and_sleep_offset() - get xtime, wall_to_monotonic,
- *    and sleep offsets.
- * @xtim:	pointer to timespec to be set with xtime
- * @wtom:	pointer to timespec to be set with wall_to_monotonic
- * @sleep:	pointer to timespec to be set with time in suspend
+ * ktime_get_update_offsets_tick - hrtimer helper
+ * @offs_real:	pointer to storage for monotonic -> realtime offset
+ * @offs_boot:	pointer to storage for monotonic -> boottime offset
+ * @offs_tai:	pointer to storage for monotonic -> clock tai offset
+ *
+ * Returns monotonic time at last tick and various offsets
  */
-void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
-				struct timespec *wtom, struct timespec *sleep)
+ktime_t ktime_get_update_offsets_tick(ktime_t *offs_real, ktime_t *offs_boot,
+							ktime_t *offs_tai)
 {
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	unsigned int seq;
+	ktime_t base;
+	u64 nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-		*xtim = tk_xtime(tk);
-		*wtom = tk->wall_to_monotonic;
-		*sleep = tk->total_sleep_time;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+		seq = read_seqcount_begin(&tk_core.seq);
+
+		base = tk->tkr.base_mono;
+		nsecs = tk->tkr.xtime_nsec >> tk->tkr.shift;
+
+		*offs_real = tk->offs_real;
+		*offs_boot = tk->offs_boot;
+		*offs_tai = tk->offs_tai;
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return ktime_add_ns(base, nsecs);
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 /**
- * ktime_get_update_offsets - hrtimer helper
+ * ktime_get_update_offsets_now - hrtimer helper
  * @offs_real:	pointer to storage for monotonic -> realtime offset
  * @offs_boot:	pointer to storage for monotonic -> boottime offset
  * @offs_tai:	pointer to storage for monotonic -> clock tai offset
@@ -1617,57 +1712,37 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
  * Returns current monotonic time and updates the offsets
  * Called from hrtimer_interrupt() or retrigger_next_event()
  */
-ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot,
+ktime_t ktime_get_update_offsets_now(ktime_t *offs_real, ktime_t *offs_boot,
 							ktime_t *offs_tai)
 {
-	struct timekeeper *tk = &timekeeper;
-	ktime_t now;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned int seq;
-	u64 secs, nsecs;
+	ktime_t base;
+	u64 nsecs;
 
 	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
+		seq = read_seqcount_begin(&tk_core.seq);
 
-		secs = tk->xtime_sec;
-		nsecs = timekeeping_get_ns(tk);
+		base = tk->tkr.base_mono;
+		nsecs = timekeeping_get_ns(&tk->tkr);
 
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
 		*offs_tai = tk->offs_tai;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
+	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
-	now = ktime_sub(now, *offs_real);
-	return now;
+	return ktime_add_ns(base, nsecs);
 }
 #endif
 
 /**
- * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
- */
-ktime_t ktime_get_monotonic_offset(void)
-{
-	struct timekeeper *tk = &timekeeper;
-	unsigned long seq;
-	struct timespec wtom;
-
-	do {
-		seq = read_seqcount_begin(&timekeeper_seq);
-		wtom = tk->wall_to_monotonic;
-	} while (read_seqcount_retry(&timekeeper_seq, seq));
-
-	return timespec_to_ktime(wtom);
-}
-EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
-
-/**
  * do_adjtimex() - Accessor function to NTP __do_adjtimex function
  */
 int do_adjtimex(struct timex *txc)
 {
-	struct timekeeper *tk = &timekeeper;
+	struct timekeeper *tk = &tk_core.timekeeper;
 	unsigned long flags;
-	struct timespec ts;
+	struct timespec64 ts;
 	s32 orig_tai, tai;
 	int ret;
 
@@ -1687,10 +1762,10 @@ int do_adjtimex(struct timex *txc)
 			return ret;
 	}
 
-	getnstimeofday(&ts);
+	getnstimeofday64(&ts);
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	orig_tai = tai = tk->tai_offset;
 	ret = __do_adjtimex(txc, &ts, &tai);
@@ -1699,7 +1774,7 @@ int do_adjtimex(struct timex *txc)
 		__timekeeping_set_tai_offset(tk, tai);
 		timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	}
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	if (tai != orig_tai)
@@ -1719,11 +1794,11 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
-	write_seqcount_begin(&timekeeper_seq);
+	write_seqcount_begin(&tk_core.seq);
 
 	__hardpps(phase_ts, raw_ts);
 
-	write_seqcount_end(&timekeeper_seq);
+	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
diff --git a/kernel/time/timekeeping.h b/kernel/time/timekeeping.h
new file mode 100644
index 0000000..adc1fc9
--- /dev/null
+++ b/kernel/time/timekeeping.h
@@ -0,0 +1,20 @@
+#ifndef _KERNEL_TIME_TIMEKEEPING_H
+#define _KERNEL_TIME_TIMEKEEPING_H
+/*
+ * Internal interfaces for kernel/time/
+ */
+extern ktime_t ktime_get_update_offsets_tick(ktime_t *offs_real,
+						ktime_t *offs_boot,
+						ktime_t *offs_tai);
+extern ktime_t ktime_get_update_offsets_now(ktime_t *offs_real,
+						ktime_t *offs_boot,
+						ktime_t *offs_tai);
+
+extern int timekeeping_valid_for_hres(void);
+extern u64 timekeeping_max_deferment(void);
+extern int timekeeping_inject_offset(struct timespec *ts);
+extern s32 timekeeping_get_tai_offset(void);
+extern void timekeeping_set_tai_offset(s32 tai_offset);
+extern void timekeeping_clocktai(struct timespec *ts);
+
+#endif
diff --git a/kernel/time/timekeeping_debug.c b/kernel/time/timekeeping_debug.c
index 4d54f97..f6bd652 100644
--- a/kernel/time/timekeeping_debug.c
+++ b/kernel/time/timekeeping_debug.c
@@ -67,7 +67,7 @@ static int __init tk_debug_sleep_time_init(void)
 }
 late_initcall(tk_debug_sleep_time_init);
 
-void tk_debug_account_sleep_time(struct timespec *t)
+void tk_debug_account_sleep_time(struct timespec64 *t)
 {
 	sleep_time_bin[fls(t->tv_sec)]++;
 }
diff --git a/kernel/time/timekeeping_internal.h b/kernel/time/timekeeping_internal.h
index 13323ea..4ea005a 100644
--- a/kernel/time/timekeeping_internal.h
+++ b/kernel/time/timekeeping_internal.h
@@ -3,12 +3,27 @@
 /*
  * timekeeping debug functions
  */
+#include <linux/clocksource.h>
 #include <linux/time.h>
 
 #ifdef CONFIG_DEBUG_FS
-extern void tk_debug_account_sleep_time(struct timespec *t);
+extern void tk_debug_account_sleep_time(struct timespec64 *t);
 #else
 #define tk_debug_account_sleep_time(x)
 #endif
 
+#ifdef CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE
+static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
+{
+	cycle_t ret = (now - last) & mask;
+
+	return (s64) ret > 0 ? ret : 0;
+}
+#else
+static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
+{
+	return (now - last) & mask;
+}
+#endif
+
 #endif /* _TIMEKEEPING_INTERNAL_H */
diff --git a/kernel/timer.c b/kernel/time/timer.c
similarity index 99%
rename from kernel/timer.c
rename to kernel/time/timer.c
index 3bb01a3..aca5dfe 100644
--- a/kernel/timer.c
+++ b/kernel/time/timer.c
@@ -82,6 +82,7 @@ struct tvec_base {
 	unsigned long next_timer;
 	unsigned long active_timers;
 	unsigned long all_timers;
+	int cpu;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -409,6 +410,22 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 			base->next_timer = timer->expires;
 	}
 	base->all_timers++;
+
+	/*
+	 * Check whether the other CPU is in dynticks mode and needs
+	 * to be triggered to reevaluate the timer wheel.
+	 * We are protected against the other CPU fiddling
+	 * with the timer by holding the timer base lock. This also
+	 * makes sure that a CPU on the way to stop its tick can not
+	 * evaluate the timer wheel.
+	 *
+	 * Spare the IPI for deferrable timers on idle targets though.
+	 * The next busy ticks will take care of it. Except full dynticks
+	 * require special care against races with idle_cpu(), lets deal
+	 * with that later.
+	 */
+	if (!tbase_get_deferrable(base) || tick_nohz_full_cpu(base->cpu))
+		wake_up_nohz_cpu(base->cpu);
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -948,22 +965,6 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	timer_set_base(timer, base);
 	debug_activate(timer, timer->expires);
 	internal_add_timer(base, timer);
-	/*
-	 * Check whether the other CPU is in dynticks mode and needs
-	 * to be triggered to reevaluate the timer wheel.
-	 * We are protected against the other CPU fiddling
-	 * with the timer by holding the timer base lock. This also
-	 * makes sure that a CPU on the way to stop its tick can not
-	 * evaluate the timer wheel.
-	 *
-	 * Spare the IPI for deferrable timers on idle targets though.
-	 * The next busy ticks will take care of it. Except full dynticks
-	 * require special care against races with idle_cpu(), lets deal
-	 * with that later.
-	 */
-	if (!tbase_get_deferrable(timer->base) || tick_nohz_full_cpu(cpu))
-		wake_up_nohz_cpu(cpu);
-
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
@@ -1568,6 +1569,7 @@ static int init_timers_cpu(int cpu)
 		}
 		spin_lock_init(&base->lock);
 		tvec_base_done[cpu] = 1;
+		base->cpu = cpu;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
 	}
diff --git a/kernel/time/udelay_test.c b/kernel/time/udelay_test.c
new file mode 100644
index 0000000..e622ba3
--- /dev/null
+++ b/kernel/time/udelay_test.c
@@ -0,0 +1,168 @@
+/*
+ * udelay() test kernel module
+ *
+ * Test is executed by writing and reading to /sys/kernel/debug/udelay_test
+ * Tests are configured by writing: USECS ITERATIONS
+ * Tests are executed by reading from the same file.
+ * Specifying usecs of 0 or negative values will run multiples tests.
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+#define DEFAULT_ITERATIONS 100
+
+#define DEBUGFS_FILENAME "udelay_test"
+
+static DEFINE_MUTEX(udelay_test_lock);
+static struct dentry *udelay_test_debugfs_file;
+static int udelay_test_usecs;
+static int udelay_test_iterations = DEFAULT_ITERATIONS;
+
+static int udelay_test_single(struct seq_file *s, int usecs, uint32_t iters)
+{
+	int min = 0, max = 0, fail_count = 0;
+	uint64_t sum = 0;
+	uint64_t avg;
+	int i;
+	/* Allow udelay to be up to 0.5% fast */
+	int allowed_error_ns = usecs * 5;
+
+	for (i = 0; i < iters; ++i) {
+		struct timespec ts1, ts2;
+		int time_passed;
+
+		ktime_get_ts(&ts1);
+		udelay(usecs);
+		ktime_get_ts(&ts2);
+		time_passed = timespec_to_ns(&ts2) - timespec_to_ns(&ts1);
+
+		if (i == 0 || time_passed < min)
+			min = time_passed;
+		if (i == 0 || time_passed > max)
+			max = time_passed;
+		if ((time_passed + allowed_error_ns) / 1000 < usecs)
+			++fail_count;
+		WARN_ON(time_passed < 0);
+		sum += time_passed;
+	}
+
+	avg = sum;
+	do_div(avg, iters);
+	seq_printf(s, "%d usecs x %d: exp=%d allowed=%d min=%d avg=%lld max=%d",
+			usecs, iters, usecs * 1000,
+			(usecs * 1000) - allowed_error_ns, min, avg, max);
+	if (fail_count)
+		seq_printf(s, " FAIL=%d", fail_count);
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
+static int udelay_test_show(struct seq_file *s, void *v)
+{
+	int usecs;
+	int iters;
+	int ret = 0;
+
+	mutex_lock(&udelay_test_lock);
+	usecs = udelay_test_usecs;
+	iters = udelay_test_iterations;
+	mutex_unlock(&udelay_test_lock);
+
+	if (usecs > 0 && iters > 0) {
+		return udelay_test_single(s, usecs, iters);
+	} else if (usecs == 0) {
+		struct timespec ts;
+
+		ktime_get_ts(&ts);
+		seq_printf(s, "udelay() test (lpj=%ld kt=%ld.%09ld)\n",
+				loops_per_jiffy, ts.tv_sec, ts.tv_nsec);
+		seq_puts(s, "usage:\n");
+		seq_puts(s, "echo USECS [ITERS] > " DEBUGFS_FILENAME "\n");
+		seq_puts(s, "cat " DEBUGFS_FILENAME "\n");
+	}
+
+	return ret;
+}
+
+static int udelay_test_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, udelay_test_show, inode->i_private);
+}
+
+static ssize_t udelay_test_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *pos)
+{
+	char lbuf[32];
+	int ret;
+	int usecs;
+	int iters;
+
+	if (count >= sizeof(lbuf))
+		return -EINVAL;
+
+	if (copy_from_user(lbuf, buf, count))
+		return -EFAULT;
+	lbuf[count] = '\0';
+
+	ret = sscanf(lbuf, "%d %d", &usecs, &iters);
+	if (ret < 1)
+		return -EINVAL;
+	else if (ret < 2)
+		iters = DEFAULT_ITERATIONS;
+
+	mutex_lock(&udelay_test_lock);
+	udelay_test_usecs = usecs;
+	udelay_test_iterations = iters;
+	mutex_unlock(&udelay_test_lock);
+
+	return count;
+}
+
+static const struct file_operations udelay_test_debugfs_ops = {
+	.owner = THIS_MODULE,
+	.open = udelay_test_open,
+	.read = seq_read,
+	.write = udelay_test_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init udelay_test_init(void)
+{
+	mutex_lock(&udelay_test_lock);
+	udelay_test_debugfs_file = debugfs_create_file(DEBUGFS_FILENAME,
+			S_IRUSR, NULL, NULL, &udelay_test_debugfs_ops);
+	mutex_unlock(&udelay_test_lock);
+
+	return 0;
+}
+
+module_init(udelay_test_init);
+
+static void __exit udelay_test_exit(void)
+{
+	mutex_lock(&udelay_test_lock);
+	debugfs_remove(udelay_test_debugfs_file);
+	mutex_unlock(&udelay_test_lock);
+}
+
+module_exit(udelay_test_exit);
+
+MODULE_AUTHOR("David Riley <davidriley@chromium.org>");
+MODULE_LICENSE("GPL");
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f243444..84e2b45 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -806,11 +806,12 @@ static struct {
 	const char *name;
 	int in_ns;		/* is this clock in nanoseconds? */
 } trace_clocks[] = {
-	{ trace_clock_local,	"local",	1 },
-	{ trace_clock_global,	"global",	1 },
-	{ trace_clock_counter,	"counter",	0 },
-	{ trace_clock_jiffies,	"uptime",	1 },
-	{ trace_clock,		"perf",		1 },
+	{ trace_clock_local,		"local",	1 },
+	{ trace_clock_global,		"global",	1 },
+	{ trace_clock_counter,		"counter",	0 },
+	{ trace_clock_jiffies,		"uptime",	1 },
+	{ trace_clock,			"perf",		1 },
+	{ ktime_get_mono_fast_ns,	"mono",		1 },
 	ARCH_TRACE_CLOCKS
 };
 
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index a1dd9a1..975cb49 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -31,20 +31,19 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 		   struct taskstats *stats, struct task_struct *tsk)
 {
 	const struct cred *tcred;
-	struct timespec uptime, ts;
 	cputime_t utime, stime, utimescaled, stimescaled;
-	u64 ac_etime;
+	u64 delta;
 
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
-	/* calculate task elapsed time in timespec */
-	do_posix_clock_monotonic_gettime(&uptime);
-	ts = timespec_sub(uptime, tsk->start_time);
-	/* rebase elapsed time to usec (should never be negative) */
-	ac_etime = timespec_to_ns(&ts);
-	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
+	/* calculate task elapsed time in nsec */
+	delta = ktime_get_ns() - tsk->start_time;
+	/* Convert to micro seconds */
+	do_div(delta, NSEC_PER_USEC);
+	stats->ac_etime = delta;
+	/* Convert to seconds for btime */
+	do_div(delta, USEC_PER_SEC);
+	stats->ac_btime = get_seconds() - delta;
 	if (thread_group_leader(tsk)) {
 		stats->ac_exitcode = tsk->exit_code;
 		if (tsk->flags & PF_FORKNOEXEC)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa..24a26ad 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1649,6 +1649,15 @@ config TEST_BPF
 
 	  If unsure, say N.
 
+config TEST_UDELAY
+	tristate "udelay test driver"
+	default n
+	help
+	  This builds the "udelay_test" module that helps to make sure
+	  that udelay() is working properly.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/devres.c b/lib/devres.c
index f562bf6..bb63248 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -86,8 +86,6 @@ void devm_iounmap(struct device *dev, void __iomem *addr)
 }
 EXPORT_SYMBOL(devm_iounmap);
 
-#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
-
 /**
  * devm_ioremap_resource() - check, request region, and ioremap resource
  * @dev: generic device to handle the resource for
diff --git a/security/tomoyo/audit.c b/security/tomoyo/audit.c
index c1b0037..3ffa4f5 100644
--- a/security/tomoyo/audit.c
+++ b/security/tomoyo/audit.c
@@ -155,11 +155,9 @@ static char *tomoyo_print_header(struct tomoyo_request_info *r)
 	u8 i;
 	if (!buffer)
 		return NULL;
-	{
-		struct timeval tv;
-		do_gettimeofday(&tv);
-		tomoyo_convert_time(tv.tv_sec, &stamp);
-	}
+
+	tomoyo_convert_time(get_seconds(), &stamp);
+
 	pos = snprintf(buffer, tomoyo_buffer_len - 1,
 		       "#%04u/%02u/%02u %02u:%02u:%02u# profile=%u mode=%s "
 		       "granted=%s (global-pid=%u) task={ pid=%u ppid=%u "
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 283862a..e0fb750 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2267,13 +2267,11 @@ static unsigned int tomoyo_stat_modified[TOMOYO_MAX_POLICY_STAT];
  */
 void tomoyo_update_stat(const u8 index)
 {
-	struct timeval tv;
-	do_gettimeofday(&tv);
 	/*
 	 * I don't use atomic operations because race condition is not fatal.
 	 */
 	tomoyo_stat_updated[index]++;
-	tomoyo_stat_modified[index] = tv.tv_sec;
+	tomoyo_stat_modified[index] = get_seconds();
 }
 
 /**
diff --git a/tools/time/udelay_test.sh b/tools/time/udelay_test.sh
new file mode 100755
index 0000000..12d46b9
--- /dev/null
+++ b/tools/time/udelay_test.sh
@@ -0,0 +1,66 @@
+#!/bin/bash
+
+# udelay() test script
+#
+# Test is executed by writing and reading to /sys/kernel/debug/udelay_test
+# and exercises a variety of delays to ensure that udelay() is delaying
+# at least as long as requested (as compared to ktime).
+#
+# Copyright (C) 2014 Google, Inc.
+#
+# This software is licensed under the terms of the GNU General Public
+# License version 2, as published by the Free Software Foundation, and
+# may be copied, distributed, and modified under those terms.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+
+MODULE_NAME=udelay_test
+UDELAY_PATH=/sys/kernel/debug/udelay_test
+
+setup()
+{
+	/sbin/modprobe -q $MODULE_NAME
+	tmp_file=`mktemp`
+}
+
+test_one()
+{
+	delay=$1
+	echo $delay > $UDELAY_PATH
+	tee -a $tmp_file < $UDELAY_PATH
+}
+
+cleanup()
+{
+	if [ -f $tmp_file ]; then
+		rm $tmp_file
+	fi
+	/sbin/modprobe -q -r $MODULE_NAME
+}
+
+trap cleanup EXIT
+setup
+
+# Delay for a variety of times.
+# 1..200, 200..500 (by 10), 500..2000 (by 100)
+for (( delay = 1; delay < 200; delay += 1 )); do
+	test_one $delay
+done
+for (( delay = 200; delay < 500; delay += 10 )); do
+	test_one $delay
+done
+for (( delay = 500; delay <= 2000; delay += 100 )); do
+	test_one $delay
+done
+
+# Search for failures
+count=`grep -c FAIL $tmp_file`
+if [ $? -eq "0" ]; then
+	echo "ERROR: $count delays failed to delay long enough"
+	retcode=1
+fi
+
+exit $retcode

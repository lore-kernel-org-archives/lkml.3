Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3GFUcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 16:32:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:48852 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3GFUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 16:32:16 -0400
Date: Sat, 6 Jul 2013 22:32:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] timer changes for 3.11
Message-ID: <alpine.DEB.2.02.1307062200580.32106@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

The timer changes contain:

  * posix timer code consolidation and fixes for odd corner cases

  * sched_clock implementation moved from ARM to core code to avoid
    duplication by other architectures

  * alarm timer updates

  * clocksource and clockevents unregistration facilities

  * clocksource/events support for new hardware

  * precise nanoseconds RTC readout (Xen feature)

  * generic support for Xen suspend/resume oddities

  * the usual lot of fixes and cleanups all over the place

The parts which touch other areas (ARM/XEN) have been coordinated with
the relevant maintainers. Though this results in an handful of trivial
to solve merge conflicts, which we preferred over nasty cross tree
merge dependencies.

The patches which have been committed in the last few days are bug
fixes plus the posix timer lot. The latter was in akpms queue and next
for quite some time; they just got forgotten and Frederic collected
them last minute.

Thanks,

	tglx

------------------>
Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()

Baruch Siach (2):
      clocksource: dw_apb: Remove unused header
      clocksource: dw_apb: Fix error check

Colin Cross (1):
      power: Add option to log time spent in suspend

Daniel Borkmann (1):
      ktime: Add __must_check prefix to ktime_to_timespec_cond

Daniel Tang (1):
      clocksource: Add TI-Nspire timer support

David Vrabel (7):
      x86: Increase precision of x86_platform.get/set_wallclock()
      hrtimers: Support resuming with two or more CPUs online (but stopped)
      xen: Remove clock_was_set() call in the resume path
      timekeeping: Pass flags instead of multiple bools to timekeeping_update()
      timekeeping: Indicate that clock was set in the pvclock gtod notifier
      x86: xen: Sync the wallclock when the system time is set
      x86: xen: Sync the CMOS RTC as well as the Xen wallclock

Fabio Estevam (1):
      clocksource: vf_pit_timer: Use linux/sched_clock.h

Frederic Weisbecker (6):
      posix_cpu_timer: consolidate expiry time type
      posix_cpu_timers: consolidate timer list cleanups
      posix_cpu_timers: consolidate expired timers check
      selftests: add basic posix timers selftests
      posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
      posix_timers: fix racy timer delta caching on task exit

Jingchang Lu (1):
      clocksource: Add Freescale Vybrid pit timer support

John Stultz (2):
      x86: Fix vrtc_get_time/set_mmss to use new timespec interface
      Revert "dw_apb_timer_of.c: Remove parts that were picoxcell-specific"

KOSAKI Motohiro (1):
      posix-cpu-timers: don't account cpu timer after stopped thread runtime accounting

Liu Ying (1):
      ktime: Use macro NSEC_PER_USEC where appropriate

Marcus Gelderie (1):
      alarmtimer: Export symbols of functions declared in linux/alarmtimer.h

Mark Rutland (1):
      clocksource: Add generic dummy timer driver

Pavel Machek (1):
      dw_apb_timer_of.c: Remove parts that were picoxcell-specific

Stephen Boyd (6):
      ARM: sched_clock: Remove unused needs_suspend member
      ARM: sched_clock: Return suspended count earlier
      sched_clock: Make ARM's sched_clock generic for all architectures
      ARM: sched_clock: Load cycle count after epoch stabilizes
      sched_clock: Add temporary asm/sched_clock.h
      clockevents: Prefer CPU local devices over global devices

Thomas Gleixner (23):
      clocksource: apb_timer: Remove unsused function
      clocksource: Always verify highres capability
      clocksource: Let timekeeping_notify return success/error
      clocksource: Add module refcount
      clocksource: Allow clocksource select to skip current clocksource
      clocksource: Split out user string input
      clocksource: Provide unbind interface in sysfs
      clocksource: Let clocksource_unregister() return success/error
      clockevents: Get rid of the notifier chain
      clockevents: Simplify locking
      clockevents: Move the tick_notify() switch case to clockevents_notify()
      clockevents: Add module refcount
      clockevents: Provide sysfs interface
      clockevents: Split out selection logic
      clockevents: Implement unbind functionality
      clockevents: Define CS_NAME_LEN unconditionally
      clocksource: Implement clocksource_select_fallback() for CONFIG_ARCH_USES_GETTIMEOFFSET=y
      tick: Make oneshot broadcast robust vs. CPU offlining
      tick: Prevent uncontrolled switch to oneshot mode
      tick: Sanitize broadcast control logic
      clocksource: Reselect clocksource when watchdog validated high-res capability
      hrtimers: Move SMP function call to thread context
      hrtimer: Remove unused variable

Todd Poynor (2):
      alarmtimer: Add functions for timerfd support
      timerfd: Add alarm timers


 .../devicetree/bindings/timer/lsi,zevio-timer.txt  |   33 ++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/common/timer-sp.c                         |    2 +-
 arch/arm/include/asm/sched_clock.h                 |   18 +-
 arch/arm/kernel/Makefile                           |    2 +-
 arch/arm/kernel/arch_timer.c                       |    2 +-
 arch/arm/kernel/time.c                             |    4 +-
 arch/arm/mach-davinci/time.c                       |    2 +-
 arch/arm/mach-imx/time.c                           |    2 +-
 arch/arm/mach-integrator/integrator_ap.c           |    2 +-
 arch/arm/mach-ixp4xx/common.c                      |    2 +-
 arch/arm/mach-mmp/time.c                           |    2 +-
 arch/arm/mach-msm/timer.c                          |    2 +-
 arch/arm/mach-omap1/time.c                         |    2 +-
 arch/arm/mach-omap2/timer.c                        |    2 +-
 arch/arm/mach-pxa/time.c                           |    2 +-
 arch/arm/mach-sa1100/time.c                        |    2 +-
 arch/arm/mach-u300/timer.c                         |    2 +-
 arch/arm/plat-iop/time.c                           |    2 +-
 arch/arm/plat-omap/counter_32k.c                   |    2 +-
 arch/arm/plat-orion/time.c                         |    2 +-
 arch/arm/plat-samsung/samsung-time.c               |    2 +-
 arch/arm/plat-versatile/sched-clock.c              |    2 +-
 arch/x86/include/asm/mc146818rtc.h                 |    4 +-
 arch/x86/include/asm/mrst-vrtc.h                   |    4 +-
 arch/x86/include/asm/x86_init.h                    |    6 +-
 arch/x86/kernel/kvmclock.c                         |    9 +-
 arch/x86/kernel/rtc.c                              |   17 +-
 arch/x86/lguest/boot.c                             |    4 +-
 arch/x86/platform/efi/efi.c                        |   10 +-
 arch/x86/platform/mrst/vrtc.c                      |   11 +-
 arch/x86/xen/time.c                                |   58 ++-
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    3 +
 drivers/clocksource/bcm2835_timer.c                |    2 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c          |    3 +-
 drivers/clocksource/dummy_timer.c                  |   69 ++++
 drivers/clocksource/dw_apb_timer.c                 |   12 -
 drivers/clocksource/dw_apb_timer_of.c              |    6 +-
 drivers/clocksource/mxs_timer.c                    |    2 +-
 drivers/clocksource/nomadik-mtu.c                  |    2 +-
 drivers/clocksource/samsung_pwm_timer.c            |    2 +-
 drivers/clocksource/tegra20_timer.c                |    2 +-
 drivers/clocksource/time-armada-370-xp.c           |    2 +-
 drivers/clocksource/timer-marco.c                  |    2 +-
 drivers/clocksource/timer-prima2.c                 |    2 +-
 drivers/clocksource/vf_pit_timer.c                 |  194 ++++++++++
 drivers/clocksource/zevio-timer.c                  |  215 +++++++++++
 drivers/xen/manage.c                               |    3 -
 fs/timerfd.c                                       |  131 +++++--
 include/linux/alarmtimer.h                         |    4 +
 include/linux/clockchips.h                         |    5 +-
 include/linux/clocksource.h                        |    8 +-
 include/linux/dw_apb_timer.h                       |    1 -
 include/linux/efi.h                                |    4 +-
 include/linux/ktime.h                              |   10 +-
 include/linux/posix-timers.h                       |   16 +-
 include/linux/pvclock_gtod.h                       |    7 +
 include/linux/sched_clock.h                        |   21 ++
 init/Kconfig                                       |    3 +
 init/main.c                                        |    2 +
 kernel/hrtimer.c                                   |   32 +-
 kernel/posix-cpu-timers.c                          |  395 +++++++-------------
 kernel/sched/stats.h                               |   39 +-
 kernel/time/Makefile                               |    2 +
 kernel/time/alarmtimer.c                           |   47 ++-
 kernel/time/clockevents.c                          |  271 ++++++++++++--
 kernel/time/clocksource.c                          |  266 +++++++++----
 {arch/arm/kernel => kernel/time}/sched_clock.c     |   17 +-
 kernel/time/tick-broadcast.c                       |  126 +++++--
 kernel/time/tick-common.c                          |  197 ++++------
 kernel/time/tick-internal.h                        |   17 +-
 kernel/time/timekeeping.c                          |   65 ++--
 kernel/time/timekeeping_debug.c                    |   72 ++++
 kernel/time/timekeeping_internal.h                 |   14 +
 kernel/timer.c                                     |    8 +-
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/timers/Makefile            |    8 +
 tools/testing/selftests/timers/posix_timers.c      |  221 +++++++++++
 79 files changed, 2050 insertions(+), 703 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
 create mode 100644 drivers/clocksource/dummy_timer.c
 create mode 100644 drivers/clocksource/vf_pit_timer.c
 create mode 100644 drivers/clocksource/zevio-timer.c
 create mode 100644 include/linux/sched_clock.h
 rename {arch/arm/kernel => kernel/time}/sched_clock.c (94%)
 create mode 100644 kernel/time/timekeeping_debug.c
 create mode 100644 kernel/time/timekeeping_internal.h
 create mode 100644 tools/testing/selftests/timers/Makefile
 create mode 100644 tools/testing/selftests/timers/posix_timers.c

diff --git a/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt b/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
new file mode 100644
index 0000000..b2d07ad
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/lsi,zevio-timer.txt
@@ -0,0 +1,33 @@
+TI-NSPIRE timer
+
+Required properties:
+
+- compatible : should be "lsi,zevio-timer".
+- reg : The physical base address and size of the timer (always first).
+- clocks: phandle to the source clock.
+
+Optional properties:
+
+- interrupts : The interrupt number of the first timer.
+- reg : The interrupt acknowledgement registers
+	(always after timer base address)
+
+If any of the optional properties are not given, the timer is added as a
+clock-source only.
+
+Example:
+
+timer {
+	compatible = "lsi,zevio-timer";
+	reg = <0x900D0000 0x1000>, <0x900A0020 0x8>;
+	interrupts = <19>;
+	clocks = <&timer_clk>;
+};
+
+Example (no clock-events):
+
+timer {
+	compatible = "lsi,zevio-timer";
+	reg = <0x900D0000 0x1000>;
+	clocks = <&timer_clk>;
+};
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 136f263..b02e6bb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
+	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_STRNCPY_FROM_USER
diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index ddc7407..023ee63 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -28,8 +28,8 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/timer-sp.h>
 
diff --git a/arch/arm/include/asm/sched_clock.h b/arch/arm/include/asm/sched_clock.h
index 3d520dd..2389b71 100644
--- a/arch/arm/include/asm/sched_clock.h
+++ b/arch/arm/include/asm/sched_clock.h
@@ -1,16 +1,4 @@
-/*
- * sched_clock.h: support for extending counters to full 64-bit ns counter
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+/* You shouldn't include this file. Use linux/sched_clock.h instead.
+ * Temporary file until all asm/sched_clock.h users are gone
  */
-#ifndef ASM_SCHED_CLOCK
-#define ASM_SCHED_CLOCK
-
-extern void sched_clock_postinit(void);
-extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
-
-extern unsigned long long (*sched_clock_func)(void);
-
-#endif
+#include <linux/sched_clock.h>
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5f3338e..97cb057 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -16,7 +16,7 @@ CFLAGS_REMOVE_return_address.o = -pg
 # Object file lists.
 
 obj-y		:= elf.o entry-armv.o entry-common.o irq.o opcodes.o \
-		   process.o ptrace.o return_address.o sched_clock.o \
+		   process.o ptrace.o return_address.o \
 		   setup.o signal.o stacktrace.o sys_arm.o time.o traps.o
 
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index 59dcdce..221f07b 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -11,9 +11,9 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/sched_clock.h>
 
 #include <asm/delay.h>
-#include <asm/sched_clock.h>
 
 #include <clocksource/arm_arch_timer.h>
 
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index abff4e9..98aee32 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -24,9 +24,9 @@
 #include <linux/timer.h>
 #include <linux/clocksource.h>
 #include <linux/irq.h>
+#include <linux/sched_clock.h>
 
 #include <asm/thread_info.h>
-#include <asm/sched_clock.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
@@ -120,6 +120,4 @@ void __init time_init(void)
 		machine_desc->init_time();
 	else
 		clocksource_of_init();
-
-	sched_clock_postinit();
 }
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index bad361e..7a55b5c 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -18,8 +18,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
 
diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
index fea9131..cd46529 100644
--- a/arch/arm/mach-imx/time.c
+++ b/arch/arm/mach-imx/time.c
@@ -26,8 +26,8 @@
 #include <linux/clockchips.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/mach/time.h>
 
 #include "common.h"
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index b23c8e4..aa43462 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -41,6 +41,7 @@
 #include <linux/stat.h>
 #include <linux/sys_soc.h>
 #include <linux/termios.h>
+#include <linux/sched_clock.h>
 #include <video/vga.h>
 
 #include <mach/hardware.h>
@@ -49,7 +50,6 @@
 #include <asm/setup.h>
 #include <asm/param.h>		/* HZ */
 #include <asm/mach-types.h>
-#include <asm/sched_clock.h>
 
 #include <mach/lm.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 6600cff..58307cf 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -30,6 +30,7 @@
 #include <linux/export.h>
 #include <linux/gpio.h>
 #include <linux/cpu.h>
+#include <linux/sched_clock.h>
 
 #include <mach/udc.h>
 #include <mach/hardware.h>
@@ -38,7 +39,6 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/irq.h>
-#include <asm/sched_clock.h>
 #include <asm/system_misc.h>
 
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 86a18b3..7ac41e8 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -28,8 +28,8 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <mach/addr-map.h>
 #include <mach/regs-timers.h>
 #include <mach/regs-apbc.h>
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 284313f..b6418fd 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -23,10 +23,10 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
 #include <asm/localtimer.h>
-#include <asm/sched_clock.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 726ec23..80603d2 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -43,9 +43,9 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/io.h>
+#include <linux/sched_clock.h>
 
 #include <asm/irq.h>
-#include <asm/sched_clock.h>
 
 #include <mach/hardware.h>
 #include <asm/mach/irq.h>
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index f8b23b8..4c069b0 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -41,10 +41,10 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/dmtimer-omap.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
-#include <asm/sched_clock.h>
 
 #include "omap_hwmod.h"
 #include "omap_device.h"
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 8f1ee92..9aa852a 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -16,11 +16,11 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
+#include <linux/sched_clock.h>
 
 #include <asm/div64.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 #include <mach/regs-ost.h>
 #include <mach/irqs.h>
 
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index a59a13a..713c86c 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -14,9 +14,9 @@
 #include <linux/irq.h>
 #include <linux/timex.h>
 #include <linux/clockchips.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 
diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index d9e7320..af771b7 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -18,12 +18,12 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/irq.h>
+#include <linux/sched_clock.h>
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 
 /* Generic stuff */
-#include <asm/sched_clock.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
 
diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 837a2d5..29606bd7 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -22,9 +22,9 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/export.h>
+#include <linux/sched_clock.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/sched_clock.h>
 #include <asm/uaccess.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
index 5b0b86b..d9bc98e 100644
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -18,9 +18,9 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/clocksource.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 
 #include <plat/counter-32k.h>
 
diff --git a/arch/arm/plat-orion/time.c b/arch/arm/plat-orion/time.c
index 5d5ac0f..9d2b2ac 100644
--- a/arch/arm/plat-orion/time.c
+++ b/arch/arm/plat-orion/time.c
@@ -16,7 +16,7 @@
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 /*
  * MBus bridge block registers.
diff --git a/arch/arm/plat-samsung/samsung-time.c b/arch/arm/plat-samsung/samsung-time.c
index f899cbc..2957075 100644
--- a/arch/arm/plat-samsung/samsung-time.c
+++ b/arch/arm/plat-samsung/samsung-time.c
@@ -15,12 +15,12 @@
 #include <linux/clk.h>
 #include <linux/clockchips.h>
 #include <linux/platform_device.h>
+#include <linux/sched_clock.h>
 
 #include <asm/smp_twd.h>
 #include <asm/mach/time.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <asm/sched_clock.h>
 
 #include <mach/map.h>
 #include <plat/devs.h>
diff --git a/arch/arm/plat-versatile/sched-clock.c b/arch/arm/plat-versatile/sched-clock.c
index b33b74c..51b109e 100644
--- a/arch/arm/plat-versatile/sched-clock.c
+++ b/arch/arm/plat-versatile/sched-clock.c
@@ -20,8 +20,8 @@
  */
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <plat/sched_clock.h>
 
 static void __iomem *ctr;
diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index d354fb7..a55c7ef 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -95,8 +95,8 @@ static inline unsigned char current_lock_cmos_reg(void)
 unsigned char rtc_cmos_read(unsigned char addr);
 void rtc_cmos_write(unsigned char val, unsigned char addr);
 
-extern int mach_set_rtc_mmss(unsigned long nowtime);
-extern unsigned long mach_get_cmos_time(void);
+extern int mach_set_rtc_mmss(const struct timespec *now);
+extern void mach_get_cmos_time(struct timespec *now);
 
 #define RTC_IRQ 8
 
diff --git a/arch/x86/include/asm/mrst-vrtc.h b/arch/x86/include/asm/mrst-vrtc.h
index 73668ab..1e69a75 100644
--- a/arch/x86/include/asm/mrst-vrtc.h
+++ b/arch/x86/include/asm/mrst-vrtc.h
@@ -3,7 +3,7 @@
 
 extern unsigned char vrtc_cmos_read(unsigned char reg);
 extern void vrtc_cmos_write(unsigned char val, unsigned char reg);
-extern unsigned long vrtc_get_time(void);
-extern int vrtc_set_mmss(unsigned long nowtime);
+extern void vrtc_get_time(struct timespec *now);
+extern int vrtc_set_mmss(const struct timespec *now);
 
 #endif
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index d8d9922..828a156 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -142,6 +142,8 @@ struct x86_cpuinit_ops {
 	void (*fixup_cpu_id)(struct cpuinfo_x86 *c, int node);
 };
 
+struct timespec;
+
 /**
  * struct x86_platform_ops - platform specific runtime functions
  * @calibrate_tsc:		calibrate TSC
@@ -156,8 +158,8 @@ struct x86_cpuinit_ops {
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
-	unsigned long (*get_wallclock)(void);
-	int (*set_wallclock)(unsigned long nowtime);
+	void (*get_wallclock)(struct timespec *ts);
+	int (*set_wallclock)(const struct timespec *ts);
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 3dd37eb..1f354f4 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -48,10 +48,9 @@ static struct pvclock_wall_clock wall_clock;
  * have elapsed since the hypervisor wrote the data. So we try to account for
  * that with system time
  */
-static unsigned long kvm_get_wallclock(void)
+static void kvm_get_wallclock(struct timespec *now)
 {
 	struct pvclock_vcpu_time_info *vcpu_time;
-	struct timespec ts;
 	int low, high;
 	int cpu;
 
@@ -64,14 +63,12 @@ static unsigned long kvm_get_wallclock(void)
 	cpu = smp_processor_id();
 
 	vcpu_time = &hv_clock[cpu].pvti;
-	pvclock_read_wallclock(&wall_clock, vcpu_time, &ts);
+	pvclock_read_wallclock(&wall_clock, vcpu_time, now);
 
 	preempt_enable();
-
-	return ts.tv_sec;
 }
 
-static int kvm_set_wallclock(unsigned long now)
+static int kvm_set_wallclock(const struct timespec *now)
 {
 	return -1;
 }
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 198eb20..0aa2939 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -38,8 +38,9 @@ EXPORT_SYMBOL(rtc_lock);
  * jump to the next second precisely 500 ms later. Check the Motorola
  * MC146818A or Dallas DS12887 data sheet for details.
  */
-int mach_set_rtc_mmss(unsigned long nowtime)
+int mach_set_rtc_mmss(const struct timespec *now)
 {
+	unsigned long nowtime = now->tv_sec;
 	struct rtc_time tm;
 	int retval = 0;
 
@@ -58,7 +59,7 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 	return retval;
 }
 
-unsigned long mach_get_cmos_time(void)
+void mach_get_cmos_time(struct timespec *now)
 {
 	unsigned int status, year, mon, day, hour, min, sec, century = 0;
 	unsigned long flags;
@@ -107,7 +108,8 @@ unsigned long mach_get_cmos_time(void)
 	} else
 		year += CMOS_YEARS_OFFS;
 
-	return mktime(year, mon, day, hour, min, sec);
+	now->tv_sec = mktime(year, mon, day, hour, min, sec);
+	now->tv_nsec = 0;
 }
 
 /* Routines for accessing the CMOS RAM/RTC. */
@@ -135,18 +137,13 @@ EXPORT_SYMBOL(rtc_cmos_write);
 
 int update_persistent_clock(struct timespec now)
 {
-	return x86_platform.set_wallclock(now.tv_sec);
+	return x86_platform.set_wallclock(&now);
 }
 
 /* not static: needed by APM */
 void read_persistent_clock(struct timespec *ts)
 {
-	unsigned long retval;
-
-	retval = x86_platform.get_wallclock();
-
-	ts->tv_sec = retval;
-	ts->tv_nsec = 0;
+	x86_platform.get_wallclock(ts);
 }
 
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 7114c63..8424d5a 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -882,9 +882,9 @@ int lguest_setup_irq(unsigned int irq)
  * It would be far better for everyone if the Guest had its own clock, but
  * until then the Host gives us the time on every interrupt.
  */
-static unsigned long lguest_get_wallclock(void)
+static void lguest_get_wallclock(struct timespec *now)
 {
-	return lguest_data.time.tv_sec;
+	*now = lguest_data.time;
 }
 
 /*
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index d2fbced..90f6ed1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -274,8 +274,9 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 	return status;
 }
 
-int efi_set_rtc_mmss(unsigned long nowtime)
+int efi_set_rtc_mmss(const struct timespec *now)
 {
+	unsigned long nowtime = now->tv_sec;
 	efi_status_t 	status;
 	efi_time_t 	eft;
 	efi_time_cap_t 	cap;
@@ -310,7 +311,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
 	return 0;
 }
 
-unsigned long efi_get_time(void)
+void efi_get_time(struct timespec *now)
 {
 	efi_status_t status;
 	efi_time_t eft;
@@ -320,8 +321,9 @@ unsigned long efi_get_time(void)
 	if (status != EFI_SUCCESS)
 		pr_err("Oops: efitime: can't read time!\n");
 
-	return mktime(eft.year, eft.month, eft.day, eft.hour,
-		      eft.minute, eft.second);
+	now->tv_sec = mktime(eft.year, eft.month, eft.day, eft.hour,
+			     eft.minute, eft.second);
+	now->tv_nsec = 0;
 }
 
 /*
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index d62b0a3..5e355b1 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -56,7 +56,7 @@ void vrtc_cmos_write(unsigned char val, unsigned char reg)
 }
 EXPORT_SYMBOL_GPL(vrtc_cmos_write);
 
-unsigned long vrtc_get_time(void)
+void vrtc_get_time(struct timespec *now)
 {
 	u8 sec, min, hour, mday, mon;
 	unsigned long flags;
@@ -82,17 +82,18 @@ unsigned long vrtc_get_time(void)
 	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
 		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
 
-	return mktime(year, mon, mday, hour, min, sec);
+	now->tv_sec = mktime(year, mon, mday, hour, min, sec);
+	now->tv_nsec = 0;
 }
 
-int vrtc_set_mmss(unsigned long nowtime)
+int vrtc_set_mmss(const struct timespec *now)
 {
 	unsigned long flags;
 	struct rtc_time tm;
 	int year;
 	int retval = 0;
 
-	rtc_time_to_tm(nowtime, &tm);
+	rtc_time_to_tm(now->tv_sec, &tm);
 	if (!rtc_valid_tm(&tm) && tm.tm_year >= 72) {
 		/*
 		 * tm.year is the number of years since 1900, and the
@@ -110,7 +111,7 @@ int vrtc_set_mmss(unsigned long nowtime)
 	} else {
 		printk(KERN_ERR
 		       "%s: Invalid vRTC value: write of %lx to vRTC failed\n",
-			__FUNCTION__, nowtime);
+			__FUNCTION__, now->tv_sec);
 		retval = -EINVAL;
 	}
 	return retval;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 3d88bfd..7a5671b 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -14,6 +14,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/math64.h>
 #include <linux/gfp.h>
+#include <linux/pvclock_gtod.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
@@ -191,34 +192,56 @@ static void xen_read_wallclock(struct timespec *ts)
 	put_cpu_var(xen_vcpu);
 }
 
-static unsigned long xen_get_wallclock(void)
+static void xen_get_wallclock(struct timespec *now)
 {
-	struct timespec ts;
+	xen_read_wallclock(now);
+}
 
-	xen_read_wallclock(&ts);
-	return ts.tv_sec;
+static int xen_set_wallclock(const struct timespec *now)
+{
+	return -1;
 }
 
-static int xen_set_wallclock(unsigned long now)
+static int xen_pvclock_gtod_notify(struct notifier_block *nb,
+				   unsigned long was_set, void *priv)
 {
+	/* Protected by the calling core code serialization */
+	static struct timespec next_sync;
+
 	struct xen_platform_op op;
-	int rc;
+	struct timespec now;
 
-	/* do nothing for domU */
-	if (!xen_initial_domain())
-		return -1;
+	now = __current_kernel_time();
+
+	/*
+	 * We only take the expensive HV call when the clock was set
+	 * or when the 11 minutes RTC synchronization time elapsed.
+	 */
+	if (!was_set && timespec_compare(&now, &next_sync) < 0)
+		return NOTIFY_OK;
 
 	op.cmd = XENPF_settime;
-	op.u.settime.secs = now;
-	op.u.settime.nsecs = 0;
+	op.u.settime.secs = now.tv_sec;
+	op.u.settime.nsecs = now.tv_nsec;
 	op.u.settime.system_time = xen_clocksource_read();
 
-	rc = HYPERVISOR_dom0_op(&op);
-	WARN(rc != 0, "XENPF_settime failed: now=%ld\n", now);
+	(void)HYPERVISOR_dom0_op(&op);
 
-	return rc;
+	/*
+	 * Move the next drift compensation time 11 minutes
+	 * ahead. That's emulating the sync_cmos_clock() update for
+	 * the hardware RTC.
+	 */
+	next_sync = now;
+	next_sync.tv_sec += 11 * 60;
+
+	return NOTIFY_OK;
 }
 
+static struct notifier_block xen_pvclock_gtod_notifier = {
+	.notifier_call = xen_pvclock_gtod_notify,
+};
+
 static struct clocksource xen_clocksource __read_mostly = {
 	.name = "xen",
 	.rating = 400,
@@ -480,6 +503,9 @@ static void __init xen_time_init(void)
 	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
+
+	if (xen_initial_domain())
+		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
 }
 
 void __init xen_init_time_ops(void)
@@ -492,7 +518,9 @@ void __init xen_init_time_ops(void)
 
 	x86_platform.calibrate_tsc = xen_tsc_khz;
 	x86_platform.get_wallclock = xen_get_wallclock;
-	x86_platform.set_wallclock = xen_set_wallclock;
+	/* Dom0 uses the native method to set the hardware RTC. */
+	if (!xen_initial_domain())
+		x86_platform.set_wallclock = xen_set_wallclock;
 }
 
 #ifdef CONFIG_XEN_PVHVM
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index f151c6c..0a04257 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -85,3 +85,8 @@ config CLKSRC_SAMSUNG_PWM
 	  Samsung S3C, S5P and Exynos SoCs, replacing an earlier driver
 	  for all devicetree enabled platforms. This driver will be
 	  needed only on systems that do not have the Exynos MCT available.
+
+config VF_PIT_TIMER
+	bool
+	help
+	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 8d979c7..9ba8b4d 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -22,10 +22,13 @@ obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
+obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
 obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
 obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
+obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
+obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index 766611d..07ea7ce 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -28,8 +28,8 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/irq.h>
 
 #define REG_CONTROL	0x00
diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index 54f3d11..0a7fb24 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -14,8 +14,7 @@
  */
 #include <linux/clockchips.h>
 #include <linux/clksrc-dbx500-prcmu.h>
-
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 #define RATE_32K		32768
 
diff --git a/drivers/clocksource/dummy_timer.c b/drivers/clocksource/dummy_timer.c
new file mode 100644
index 0000000..1f55f96
--- /dev/null
+++ b/drivers/clocksource/dummy_timer.c
@@ -0,0 +1,69 @@
+/*
+ *  linux/drivers/clocksource/dummy_timer.c
+ *
+ *  Copyright (C) 2013 ARM Ltd.
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/clockchips.h>
+#include <linux/cpu.h>
+#include <linux/init.h>
+#include <linux/percpu.h>
+#include <linux/cpumask.h>
+
+static DEFINE_PER_CPU(struct clock_event_device, dummy_timer_evt);
+
+static void dummy_timer_set_mode(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	/*
+	 * Core clockevents code will call this when exchanging timer devices.
+	 * We don't need to do anything here.
+	 */
+}
+
+static void __cpuinit dummy_timer_setup(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = __this_cpu_ptr(&dummy_timer_evt);
+
+	evt->name	= "dummy_timer";
+	evt->features	= CLOCK_EVT_FEAT_PERIODIC |
+			  CLOCK_EVT_FEAT_ONESHOT |
+			  CLOCK_EVT_FEAT_DUMMY;
+	evt->rating	= 100;
+	evt->set_mode	= dummy_timer_set_mode;
+	evt->cpumask	= cpumask_of(cpu);
+
+	clockevents_register_device(evt);
+}
+
+static int __cpuinit dummy_timer_cpu_notify(struct notifier_block *self,
+				      unsigned long action, void *hcpu)
+{
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
+		dummy_timer_setup();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block dummy_timer_cpu_nb __cpuinitdata = {
+	.notifier_call = dummy_timer_cpu_notify,
+};
+
+static int __init dummy_timer_register(void)
+{
+	int err = register_cpu_notifier(&dummy_timer_cpu_nb);
+	if (err)
+		return err;
+
+	/* We won't get a call on the boot CPU, so register immediately */
+	if (num_possible_cpus() > 1)
+		dummy_timer_setup();
+
+	return 0;
+}
+early_initcall(dummy_timer_register);
diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 8c2a35f..e54ca10 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -387,15 +387,3 @@ cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs)
 {
 	return (cycle_t)~apbt_readl(&dw_cs->timer, APBTMR_N_CURRENT_VALUE);
 }
-
-/**
- * dw_apb_clocksource_unregister() - unregister and free a clocksource.
- *
- * @dw_cs:	The clocksource to unregister/free.
- */
-void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs)
-{
-	clocksource_unregister(&dw_cs->cs);
-
-	kfree(dw_cs);
-}
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index ab09ed3..d9a1e8d 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -20,9 +20,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
-
-#include <asm/mach/time.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 static void timer_get_base_and_rate(struct device_node *np,
 				    void __iomem **base, u32 *rate)
@@ -44,7 +42,7 @@ static void add_clockevent(struct device_node *event_timer)
 	u32 irq, rate;
 
 	irq = irq_of_parse_and_map(event_timer, 0);
-	if (irq == NO_IRQ)
+	if (irq == 0)
 		panic("No IRQ for clock event timer");
 
 	timer_get_base_and_rate(event_timer, &iobase, &rate);
diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
index 02af420..0f5e65f 100644
--- a/drivers/clocksource/mxs_timer.c
+++ b/drivers/clocksource/mxs_timer.c
@@ -29,9 +29,9 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/stmp_device.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 
 /*
  * There are 2 versions of the timrot on Freescale MXS-based SoCs.
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index e405531..8864c17 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -18,8 +18,8 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/platform_data/clocksource-nomadik-mtu.h>
+#include <linux/sched_clock.h>
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 
 /*
  * The MTU device hosts four different counters, with 4 set of
diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index 0234c8d..584b547 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -21,10 +21,10 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sched_clock.h>
 
 #include <clocksource/samsung_pwm.h>
 
-#include <asm/sched_clock.h>
 
 /*
  * Clocksource driver
diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index ae877b0..9396170 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -26,10 +26,10 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
-#include <asm/sched_clock.h>
 
 #define RTC_SECONDS            0x08
 #define RTC_SHADOW_SECONDS     0x0c
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 47a6730..efdca32 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -27,8 +27,8 @@
 #include <linux/of_address.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/localtimer.h>
 #include <linux/percpu.h>
 /*
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 97738db..e5dc912 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -17,7 +17,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 #include <asm/localtimer.h>
 #include <asm/mach/time.h>
 
diff --git a/drivers/clocksource/timer-prima2.c b/drivers/clocksource/timer-prima2.c
index 7608826..ef3cfb2 100644
--- a/drivers/clocksource/timer-prima2.c
+++ b/drivers/clocksource/timer-prima2.c
@@ -18,7 +18,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 #include <asm/mach/time.h>
 
 #define SIRFSOC_TIMER_COUNTER_LO	0x0000
diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
new file mode 100644
index 0000000..587e020
--- /dev/null
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -0,0 +1,194 @@
+/*
+ * Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+#include <linux/clk.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/sched_clock.h>
+
+/*
+ * Each pit takes 0x10 Bytes register space
+ */
+#define PITMCR		0x00
+#define PIT0_OFFSET	0x100
+#define PITn_OFFSET(n)	(PIT0_OFFSET + 0x10 * (n))
+#define PITLDVAL	0x00
+#define PITCVAL		0x04
+#define PITTCTRL	0x08
+#define PITTFLG		0x0c
+
+#define PITMCR_MDIS	(0x1 << 1)
+
+#define PITTCTRL_TEN	(0x1 << 0)
+#define PITTCTRL_TIE	(0x1 << 1)
+#define PITCTRL_CHN	(0x1 << 2)
+
+#define PITTFLG_TIF	0x1
+
+static void __iomem *clksrc_base;
+static void __iomem *clkevt_base;
+static unsigned long cycle_per_jiffy;
+
+static inline void pit_timer_enable(void)
+{
+	__raw_writel(PITTCTRL_TEN | PITTCTRL_TIE, clkevt_base + PITTCTRL);
+}
+
+static inline void pit_timer_disable(void)
+{
+	__raw_writel(0, clkevt_base + PITTCTRL);
+}
+
+static inline void pit_irq_acknowledge(void)
+{
+	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
+}
+
+static unsigned int pit_read_sched_clock(void)
+{
+	return __raw_readl(clksrc_base + PITCVAL);
+}
+
+static int __init pit_clocksource_init(unsigned long rate)
+{
+	/* set the max load value and start the clock source counter */
+	__raw_writel(0, clksrc_base + PITTCTRL);
+	__raw_writel(~0UL, clksrc_base + PITLDVAL);
+	__raw_writel(PITTCTRL_TEN, clksrc_base + PITTCTRL);
+
+	setup_sched_clock(pit_read_sched_clock, 32, rate);
+	return clocksource_mmio_init(clksrc_base + PITCVAL, "vf-pit", rate,
+			300, 32, clocksource_mmio_readl_down);
+}
+
+static int pit_set_next_event(unsigned long delta,
+				struct clock_event_device *unused)
+{
+	/*
+	 * set a new value to PITLDVAL register will not restart the timer,
+	 * to abort the current cycle and start a timer period with the new
+	 * value, the timer must be disabled and enabled again.
+	 * and the PITLAVAL should be set to delta minus one according to pit
+	 * hardware requirement.
+	 */
+	pit_timer_disable();
+	__raw_writel(delta - 1, clkevt_base + PITLDVAL);
+	pit_timer_enable();
+
+	return 0;
+}
+
+static void pit_set_mode(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		pit_set_next_event(cycle_per_jiffy, evt);
+		break;
+	default:
+		break;
+	}
+}
+
+static irqreturn_t pit_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = dev_id;
+
+	pit_irq_acknowledge();
+
+	/*
+	 * pit hardware doesn't support oneshot, it will generate an interrupt
+	 * and reload the counter value from PITLDVAL when PITCVAL reach zero,
+	 * and start the counter again. So software need to disable the timer
+	 * to stop the counter loop in ONESHOT mode.
+	 */
+	if (likely(evt->mode == CLOCK_EVT_MODE_ONESHOT))
+		pit_timer_disable();
+
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static struct clock_event_device clockevent_pit = {
+	.name		= "VF pit timer",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.set_mode	= pit_set_mode,
+	.set_next_event	= pit_set_next_event,
+	.rating		= 300,
+};
+
+static struct irqaction pit_timer_irq = {
+	.name		= "VF pit timer",
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
+	.handler	= pit_timer_interrupt,
+	.dev_id		= &clockevent_pit,
+};
+
+static int __init pit_clockevent_init(unsigned long rate, int irq)
+{
+	__raw_writel(0, clkevt_base + PITTCTRL);
+	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
+
+	BUG_ON(setup_irq(irq, &pit_timer_irq));
+
+	clockevent_pit.cpumask = cpumask_of(0);
+	clockevent_pit.irq = irq;
+	/*
+	 * The value for the LDVAL register trigger is calculated as:
+	 * LDVAL trigger = (period / clock period) - 1
+	 * The pit is a 32-bit down count timer, when the conter value
+	 * reaches 0, it will generate an interrupt, thus the minimal
+	 * LDVAL trigger value is 1. And then the min_delta is
+	 * minimal LDVAL trigger value + 1, and the max_delta is full 32-bit.
+	 */
+	clockevents_config_and_register(&clockevent_pit, rate, 2, 0xffffffff);
+
+	return 0;
+}
+
+static void __init pit_timer_init(struct device_node *np)
+{
+	struct clk *pit_clk;
+	void __iomem *timer_base;
+	unsigned long clk_rate;
+	int irq;
+
+	timer_base = of_iomap(np, 0);
+	BUG_ON(!timer_base);
+
+	/*
+	 * PIT0 and PIT1 can be chained to build a 64-bit timer,
+	 * so choose PIT2 as clocksource, PIT3 as clockevent device,
+	 * and leave PIT0 and PIT1 unused for anyone else who needs them.
+	 */
+	clksrc_base = timer_base + PITn_OFFSET(2);
+	clkevt_base = timer_base + PITn_OFFSET(3);
+
+	irq = irq_of_parse_and_map(np, 0);
+	BUG_ON(irq <= 0);
+
+	pit_clk = of_clk_get(np, 0);
+	BUG_ON(IS_ERR(pit_clk));
+
+	BUG_ON(clk_prepare_enable(pit_clk));
+
+	clk_rate = clk_get_rate(pit_clk);
+	cycle_per_jiffy = clk_rate / (HZ);
+
+	/* enable the pit module */
+	__raw_writel(~PITMCR_MDIS, timer_base + PITMCR);
+
+	BUG_ON(pit_clocksource_init(clk_rate));
+
+	pit_clockevent_init(clk_rate, irq);
+}
+CLOCKSOURCE_OF_DECLARE(vf610, "fsl,vf610-pit", pit_timer_init);
diff --git a/drivers/clocksource/zevio-timer.c b/drivers/clocksource/zevio-timer.c
new file mode 100644
index 0000000..ca81809
--- /dev/null
+++ b/drivers/clocksource/zevio-timer.c
@@ -0,0 +1,215 @@
+/*
+ *  linux/drivers/clocksource/zevio-timer.c
+ *
+ *  Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/cpumask.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+
+#define IO_CURRENT_VAL	0x00
+#define IO_DIVIDER	0x04
+#define IO_CONTROL	0x08
+
+#define IO_TIMER1	0x00
+#define IO_TIMER2	0x0C
+
+#define IO_MATCH_BEGIN	0x18
+#define IO_MATCH(x)	(IO_MATCH_BEGIN + ((x) << 2))
+
+#define IO_INTR_STS	0x00
+#define IO_INTR_ACK	0x00
+#define IO_INTR_MSK	0x04
+
+#define CNTL_STOP_TIMER	(1 << 4)
+#define CNTL_RUN_TIMER	(0 << 4)
+
+#define CNTL_INC	(1 << 3)
+#define CNTL_DEC	(0 << 3)
+
+#define CNTL_TOZERO	0
+#define CNTL_MATCH(x)	((x) + 1)
+#define CNTL_FOREVER	7
+
+/* There are 6 match registers but we only use one. */
+#define TIMER_MATCH	0
+
+#define TIMER_INTR_MSK	(1 << (TIMER_MATCH))
+#define TIMER_INTR_ALL	0x3F
+
+struct zevio_timer {
+	void __iomem *base;
+	void __iomem *timer1, *timer2;
+	void __iomem *interrupt_regs;
+
+	struct clk *clk;
+	struct clock_event_device clkevt;
+	struct irqaction clkevt_irq;
+
+	char clocksource_name[64];
+	char clockevent_name[64];
+};
+
+static int zevio_timer_set_event(unsigned long delta,
+				 struct clock_event_device *dev)
+{
+	struct zevio_timer *timer = container_of(dev, struct zevio_timer,
+						 clkevt);
+
+	writel(delta, timer->timer1 + IO_CURRENT_VAL);
+	writel(CNTL_RUN_TIMER | CNTL_DEC | CNTL_MATCH(TIMER_MATCH),
+			timer->timer1 + IO_CONTROL);
+
+	return 0;
+}
+
+static void zevio_timer_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *dev)
+{
+	struct zevio_timer *timer = container_of(dev, struct zevio_timer,
+						 clkevt);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_RESUME:
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* Enable timer interrupts */
+		writel(TIMER_INTR_MSK, timer->interrupt_regs + IO_INTR_MSK);
+		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
+		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		/* Disable timer interrupts */
+		writel(0, timer->interrupt_regs + IO_INTR_MSK);
+		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
+		/* Stop timer */
+		writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+	default:
+		/* Unsupported */
+		break;
+	}
+}
+
+static irqreturn_t zevio_timer_interrupt(int irq, void *dev_id)
+{
+	struct zevio_timer *timer = dev_id;
+	u32 intr;
+
+	intr = readl(timer->interrupt_regs + IO_INTR_ACK);
+	if (!(intr & TIMER_INTR_MSK))
+		return IRQ_NONE;
+
+	writel(TIMER_INTR_MSK, timer->interrupt_regs + IO_INTR_ACK);
+	writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+
+	if (timer->clkevt.event_handler)
+		timer->clkevt.event_handler(&timer->clkevt);
+
+	return IRQ_HANDLED;
+}
+
+static int __init zevio_timer_add(struct device_node *node)
+{
+	struct zevio_timer *timer;
+	struct resource res;
+	int irqnr, ret;
+
+	timer = kzalloc(sizeof(*timer), GFP_KERNEL);
+	if (!timer)
+		return -ENOMEM;
+
+	timer->base = of_iomap(node, 0);
+	if (!timer->base) {
+		ret = -EINVAL;
+		goto error_free;
+	}
+	timer->timer1 = timer->base + IO_TIMER1;
+	timer->timer2 = timer->base + IO_TIMER2;
+
+	timer->clk = of_clk_get(node, 0);
+	if (IS_ERR(timer->clk)) {
+		ret = PTR_ERR(timer->clk);
+		pr_err("Timer clock not found! (error %d)\n", ret);
+		goto error_unmap;
+	}
+
+	timer->interrupt_regs = of_iomap(node, 1);
+	irqnr = irq_of_parse_and_map(node, 0);
+
+	of_address_to_resource(node, 0, &res);
+	scnprintf(timer->clocksource_name, sizeof(timer->clocksource_name),
+			"%llx.%s_clocksource",
+			(unsigned long long)res.start, node->name);
+
+	scnprintf(timer->clockevent_name, sizeof(timer->clockevent_name),
+			"%llx.%s_clockevent",
+			(unsigned long long)res.start, node->name);
+
+	if (timer->interrupt_regs && irqnr) {
+		timer->clkevt.name		= timer->clockevent_name;
+		timer->clkevt.set_next_event	= zevio_timer_set_event;
+		timer->clkevt.set_mode		= zevio_timer_set_mode;
+		timer->clkevt.rating		= 200;
+		timer->clkevt.cpumask		= cpu_all_mask;
+		timer->clkevt.features		= CLOCK_EVT_FEAT_ONESHOT;
+		timer->clkevt.irq		= irqnr;
+
+		writel(CNTL_STOP_TIMER, timer->timer1 + IO_CONTROL);
+		writel(0, timer->timer1 + IO_DIVIDER);
+
+		/* Start with timer interrupts disabled */
+		writel(0, timer->interrupt_regs + IO_INTR_MSK);
+		writel(TIMER_INTR_ALL, timer->interrupt_regs + IO_INTR_ACK);
+
+		/* Interrupt to occur when timer value matches 0 */
+		writel(0, timer->base + IO_MATCH(TIMER_MATCH));
+
+		timer->clkevt_irq.name		= timer->clockevent_name;
+		timer->clkevt_irq.handler	= zevio_timer_interrupt;
+		timer->clkevt_irq.dev_id	= timer;
+		timer->clkevt_irq.flags		= IRQF_TIMER | IRQF_IRQPOLL;
+
+		setup_irq(irqnr, &timer->clkevt_irq);
+
+		clockevents_config_and_register(&timer->clkevt,
+				clk_get_rate(timer->clk), 0x0001, 0xffff);
+		pr_info("Added %s as clockevent\n", timer->clockevent_name);
+	}
+
+	writel(CNTL_STOP_TIMER, timer->timer2 + IO_CONTROL);
+	writel(0, timer->timer2 + IO_CURRENT_VAL);
+	writel(0, timer->timer2 + IO_DIVIDER);
+	writel(CNTL_RUN_TIMER | CNTL_FOREVER | CNTL_INC,
+			timer->timer2 + IO_CONTROL);
+
+	clocksource_mmio_init(timer->timer2 + IO_CURRENT_VAL,
+			timer->clocksource_name,
+			clk_get_rate(timer->clk),
+			200, 16,
+			clocksource_mmio_readw_up);
+
+	pr_info("Added %s as clocksource\n", timer->clocksource_name);
+
+	return 0;
+error_unmap:
+	iounmap(timer->base);
+error_free:
+	kfree(timer);
+	return ret;
+}
+
+CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_add);
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..421da85 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -166,9 +166,6 @@ out_resume:
 
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
-	/* Make sure timer events get retriggered on all CPUs */
-	clock_was_set();
-
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 32b644f..9293121 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include <linux/alarmtimer.h>
 #include <linux/file.h>
 #include <linux/poll.h>
 #include <linux/init.h>
@@ -26,7 +27,10 @@
 #include <linux/rcupdate.h>
 
 struct timerfd_ctx {
-	struct hrtimer tmr;
+	union {
+		struct hrtimer tmr;
+		struct alarm alarm;
+	} t;
 	ktime_t tintv;
 	ktime_t moffs;
 	wait_queue_head_t wqh;
@@ -41,14 +45,19 @@ struct timerfd_ctx {
 static LIST_HEAD(cancel_list);
 static DEFINE_SPINLOCK(cancel_lock);
 
+static inline bool isalarm(struct timerfd_ctx *ctx)
+{
+	return ctx->clockid == CLOCK_REALTIME_ALARM ||
+		ctx->clockid == CLOCK_BOOTTIME_ALARM;
+}
+
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
  * tintv.tv64 != 0) until the timer is accessed.
  */
-static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
+static void timerfd_triggered(struct timerfd_ctx *ctx)
 {
-	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
@@ -56,10 +65,25 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 	ctx->ticks++;
 	wake_up_locked(&ctx->wqh);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+}
 
+static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
+{
+	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx,
+					       t.tmr);
+	timerfd_triggered(ctx);
 	return HRTIMER_NORESTART;
 }
 
+static enum alarmtimer_restart timerfd_alarmproc(struct alarm *alarm,
+	ktime_t now)
+{
+	struct timerfd_ctx *ctx = container_of(alarm, struct timerfd_ctx,
+					       t.alarm);
+	timerfd_triggered(ctx);
+	return ALARMTIMER_NORESTART;
+}
+
 /*
  * Called when the clock was set to cancel the timers in the cancel
  * list. This will wake up processes waiting on these timers. The
@@ -107,8 +131,9 @@ static bool timerfd_canceled(struct timerfd_ctx *ctx)
 
 static void timerfd_setup_cancel(struct timerfd_ctx *ctx, int flags)
 {
-	if (ctx->clockid == CLOCK_REALTIME && (flags & TFD_TIMER_ABSTIME) &&
-	    (flags & TFD_TIMER_CANCEL_ON_SET)) {
+	if ((ctx->clockid == CLOCK_REALTIME ||
+	     ctx->clockid == CLOCK_REALTIME_ALARM) &&
+	    (flags & TFD_TIMER_ABSTIME) && (flags & TFD_TIMER_CANCEL_ON_SET)) {
 		if (!ctx->might_cancel) {
 			ctx->might_cancel = true;
 			spin_lock(&cancel_lock);
@@ -124,7 +149,11 @@ static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
 {
 	ktime_t remaining;
 
-	remaining = hrtimer_expires_remaining(&ctx->tmr);
+	if (isalarm(ctx))
+		remaining = alarm_expires_remaining(&ctx->t.alarm);
+	else
+		remaining = hrtimer_expires_remaining(&ctx->t.tmr);
+
 	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
 }
 
@@ -142,11 +171,28 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 	ctx->expired = 0;
 	ctx->ticks = 0;
 	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
-	hrtimer_init(&ctx->tmr, clockid, htmode);
-	hrtimer_set_expires(&ctx->tmr, texp);
-	ctx->tmr.function = timerfd_tmrproc;
+
+	if (isalarm(ctx)) {
+		alarm_init(&ctx->t.alarm,
+			   ctx->clockid == CLOCK_REALTIME_ALARM ?
+			   ALARM_REALTIME : ALARM_BOOTTIME,
+			   timerfd_alarmproc);
+	} else {
+		hrtimer_init(&ctx->t.tmr, clockid, htmode);
+		hrtimer_set_expires(&ctx->t.tmr, texp);
+		ctx->t.tmr.function = timerfd_tmrproc;
+	}
+
 	if (texp.tv64 != 0) {
-		hrtimer_start(&ctx->tmr, texp, htmode);
+		if (isalarm(ctx)) {
+			if (flags & TFD_TIMER_ABSTIME)
+				alarm_start(&ctx->t.alarm, texp);
+			else
+				alarm_start_relative(&ctx->t.alarm, texp);
+		} else {
+			hrtimer_start(&ctx->t.tmr, texp, htmode);
+		}
+
 		if (timerfd_canceled(ctx))
 			return -ECANCELED;
 	}
@@ -158,7 +204,11 @@ static int timerfd_release(struct inode *inode, struct file *file)
 	struct timerfd_ctx *ctx = file->private_data;
 
 	timerfd_remove_cancel(ctx);
-	hrtimer_cancel(&ctx->tmr);
+
+	if (isalarm(ctx))
+		alarm_cancel(&ctx->t.alarm);
+	else
+		hrtimer_cancel(&ctx->t.tmr);
 	kfree_rcu(ctx, rcu);
 	return 0;
 }
@@ -215,9 +265,15 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks += hrtimer_forward_now(&ctx->tmr,
-						     ctx->tintv) - 1;
-			hrtimer_restart(&ctx->tmr);
+			if (isalarm(ctx)) {
+				ticks += alarm_forward_now(
+					&ctx->t.alarm, ctx->tintv) - 1;
+				alarm_restart(&ctx->t.alarm);
+			} else {
+				ticks += hrtimer_forward_now(&ctx->t.tmr,
+							     ctx->tintv) - 1;
+				hrtimer_restart(&ctx->t.tmr);
+			}
 		}
 		ctx->expired = 0;
 		ctx->ticks = 0;
@@ -259,7 +315,9 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 
 	if ((flags & ~TFD_CREATE_FLAGS) ||
 	    (clockid != CLOCK_MONOTONIC &&
-	     clockid != CLOCK_REALTIME))
+	     clockid != CLOCK_REALTIME &&
+	     clockid != CLOCK_REALTIME_ALARM &&
+	     clockid != CLOCK_BOOTTIME_ALARM))
 		return -EINVAL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -268,7 +326,15 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 
 	init_waitqueue_head(&ctx->wqh);
 	ctx->clockid = clockid;
-	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
+
+	if (isalarm(ctx))
+		alarm_init(&ctx->t.alarm,
+			   ctx->clockid == CLOCK_REALTIME_ALARM ?
+			   ALARM_REALTIME : ALARM_BOOTTIME,
+			   timerfd_alarmproc);
+	else
+		hrtimer_init(&ctx->t.tmr, clockid, HRTIMER_MODE_ABS);
+
 	ctx->moffs = ktime_get_monotonic_offset();
 
 	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
@@ -305,8 +371,14 @@ static int do_timerfd_settime(int ufd, int flags,
 	 */
 	for (;;) {
 		spin_lock_irq(&ctx->wqh.lock);
-		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
-			break;
+
+		if (isalarm(ctx)) {
+			if (alarm_try_to_cancel(&ctx->t.alarm) >= 0)
+				break;
+		} else {
+			if (hrtimer_try_to_cancel(&ctx->t.tmr) >= 0)
+				break;
+		}
 		spin_unlock_irq(&ctx->wqh.lock);
 		cpu_relax();
 	}
@@ -317,8 +389,12 @@ static int do_timerfd_settime(int ufd, int flags,
 	 * We do not update "ticks" and "expired" since the timer will be
 	 * re-programmed again in the following timerfd_setup() call.
 	 */
-	if (ctx->expired && ctx->tintv.tv64)
-		hrtimer_forward_now(&ctx->tmr, ctx->tintv);
+	if (ctx->expired && ctx->tintv.tv64) {
+		if (isalarm(ctx))
+			alarm_forward_now(&ctx->t.alarm, ctx->tintv);
+		else
+			hrtimer_forward_now(&ctx->t.tmr, ctx->tintv);
+	}
 
 	old->it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	old->it_interval = ktime_to_timespec(ctx->tintv);
@@ -345,9 +421,18 @@ static int do_timerfd_gettime(int ufd, struct itimerspec *t)
 	spin_lock_irq(&ctx->wqh.lock);
 	if (ctx->expired && ctx->tintv.tv64) {
 		ctx->expired = 0;
-		ctx->ticks +=
-			hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
-		hrtimer_restart(&ctx->tmr);
+
+		if (isalarm(ctx)) {
+			ctx->ticks +=
+				alarm_forward_now(
+					&ctx->t.alarm, ctx->tintv) - 1;
+			alarm_restart(&ctx->t.alarm);
+		} else {
+			ctx->ticks +=
+				hrtimer_forward_now(&ctx->t.tmr, ctx->tintv)
+				- 1;
+			hrtimer_restart(&ctx->t.tmr);
+		}
 	}
 	t->it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	t->it_interval = ktime_to_timespec(ctx->tintv);
diff --git a/include/linux/alarmtimer.h b/include/linux/alarmtimer.h
index 9069694..a899402 100644
--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -44,10 +44,14 @@ struct alarm {
 void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 		enum alarmtimer_restart (*function)(struct alarm *, ktime_t));
 int alarm_start(struct alarm *alarm, ktime_t start);
+int alarm_start_relative(struct alarm *alarm, ktime_t start);
+void alarm_restart(struct alarm *alarm);
 int alarm_try_to_cancel(struct alarm *alarm);
 int alarm_cancel(struct alarm *alarm);
 
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval);
+ktime_t alarm_expires_remaining(const struct alarm *alarm);
 
 /* Provide way to access the rtc device being used by alarmtimers */
 struct rtc_device *alarmtimer_get_rtcdev(void);
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 963d714..0857922 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -30,6 +30,7 @@ enum clock_event_nofitiers {
 #include <linux/notifier.h>
 
 struct clock_event_device;
+struct module;
 
 /* Clock event mode commands */
 enum clock_event_mode {
@@ -83,6 +84,7 @@ enum clock_event_mode {
  * @irq:		IRQ number (only for non CPU local devices)
  * @cpumask:		cpumask to indicate for which CPUs this device works
  * @list:		list head for the management code
+ * @owner:		module reference
  */
 struct clock_event_device {
 	void			(*event_handler)(struct clock_event_device *);
@@ -112,6 +114,7 @@ struct clock_event_device {
 	int			irq;
 	const struct cpumask	*cpumask;
 	struct list_head	list;
+	struct module		*owner;
 } ____cacheline_aligned;
 
 /*
@@ -138,6 +141,7 @@ static inline unsigned long div_sc(unsigned long ticks, unsigned long nsec,
 extern u64 clockevent_delta2ns(unsigned long latch,
 			       struct clock_event_device *evt);
 extern void clockevents_register_device(struct clock_event_device *dev);
+extern int clockevents_unbind_device(struct clock_event_device *ced, int cpu);
 
 extern void clockevents_config(struct clock_event_device *dev, u32 freq);
 extern void clockevents_config_and_register(struct clock_event_device *dev,
@@ -150,7 +154,6 @@ extern void clockevents_exchange_device(struct clock_event_device *old,
 					struct clock_event_device *new);
 extern void clockevents_set_mode(struct clock_event_device *dev,
 				 enum clock_event_mode mode);
-extern int clockevents_register_notifier(struct notifier_block *nb);
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, bool force);
 
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 7279b94..dbbf8aa 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -21,6 +21,7 @@
 /* clocksource cycle base type */
 typedef u64 cycle_t;
 struct clocksource;
+struct module;
 
 #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
 #include <asm/clocksource.h>
@@ -162,6 +163,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  * @cycle_last:		most recent cycle counter value seen by ::read()
+ * @owner:		module reference, must be set by clocksource in modules
  */
 struct clocksource {
 	/*
@@ -195,6 +197,7 @@ struct clocksource {
 	cycle_t cs_last;
 	cycle_t wd_last;
 #endif
+	struct module *owner;
 } ____cacheline_aligned;
 
 /*
@@ -207,6 +210,7 @@ struct clocksource {
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 #define CLOCK_SOURCE_UNSTABLE			0x40
 #define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
+#define CLOCK_SOURCE_RESELECT			0x100
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
@@ -279,7 +283,7 @@ static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 
 
 extern int clocksource_register(struct clocksource*);
-extern void clocksource_unregister(struct clocksource*);
+extern int clocksource_unregister(struct clocksource*);
 extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
@@ -321,7 +325,7 @@ static inline void __clocksource_updatefreq_khz(struct clocksource *cs, u32 khz)
 }
 
 
-extern void timekeeping_notify(struct clocksource *clock);
+extern int timekeeping_notify(struct clocksource *clock);
 
 extern cycle_t clocksource_mmio_readl_up(struct clocksource *);
 extern cycle_t clocksource_mmio_readl_down(struct clocksource *);
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index dd755ce..b1cd959 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -51,7 +51,6 @@ dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
-void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
 
 extern void dw_apb_timer_init(void);
 #endif /* __DW_APB_TIMER_H__ */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2bc0ad7..0068bba 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -594,8 +594,8 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern unsigned long efi_get_time(void);
-extern int efi_set_rtc_mmss(unsigned long nowtime);
+extern void efi_get_time(struct timespec *now);
+extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index bbca128..fc66b30 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -229,7 +229,8 @@ static inline ktime_t timespec_to_ktime(const struct timespec ts)
 static inline ktime_t timeval_to_ktime(const struct timeval tv)
 {
 	return (ktime_t) { .tv = { .sec = (s32)tv.tv_sec,
-				   .nsec = (s32)tv.tv_usec * 1000 } };
+				   .nsec = (s32)(tv.tv_usec *
+						 NSEC_PER_USEC) } };
 }
 
 /**
@@ -320,12 +321,12 @@ static inline s64 ktime_us_delta(const ktime_t later, const ktime_t earlier)
 
 static inline ktime_t ktime_add_us(const ktime_t kt, const u64 usec)
 {
-	return ktime_add_ns(kt, usec * 1000);
+	return ktime_add_ns(kt, usec * NSEC_PER_USEC);
 }
 
 static inline ktime_t ktime_sub_us(const ktime_t kt, const u64 usec)
 {
-	return ktime_sub_ns(kt, usec * 1000);
+	return ktime_sub_ns(kt, usec * NSEC_PER_USEC);
 }
 
 extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
@@ -338,7 +339,8 @@ extern ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs);
  *
  * Returns true if there was a successful conversion, false if kt was 0.
  */
-static inline bool ktime_to_timespec_cond(const ktime_t kt, struct timespec *ts)
+static inline __must_check bool ktime_to_timespec_cond(const ktime_t kt,
+						       struct timespec *ts)
 {
 	if (kt.tv64) {
 		*ts = ktime_to_timespec(kt);
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 7794d75..907f3fd 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -7,14 +7,20 @@
 #include <linux/timex.h>
 #include <linux/alarmtimer.h>
 
-union cpu_time_count {
-	cputime_t cpu;
-	unsigned long long sched;
-};
+
+static inline unsigned long long cputime_to_expires(cputime_t expires)
+{
+	return (__force unsigned long long)expires;
+}
+
+static inline cputime_t expires_to_cputime(unsigned long long expires)
+{
+	return (__force cputime_t)expires;
+}
 
 struct cpu_timer_list {
 	struct list_head entry;
-	union cpu_time_count expires, incr;
+	unsigned long long expires, incr;
 	struct task_struct *task;
 	int firing;
 };
diff --git a/include/linux/pvclock_gtod.h b/include/linux/pvclock_gtod.h
index 0ca7582..a71d2db 100644
--- a/include/linux/pvclock_gtod.h
+++ b/include/linux/pvclock_gtod.h
@@ -3,6 +3,13 @@
 
 #include <linux/notifier.h>
 
+/*
+ * The pvclock gtod notifier is called when the system time is updated
+ * and is used to keep guest time synchronized with host time.
+ *
+ * The 'action' parameter in the notifier function is false (0), or
+ * true (non-zero) if system time was stepped.
+ */
 extern int pvclock_gtod_register_notifier(struct notifier_block *nb);
 extern int pvclock_gtod_unregister_notifier(struct notifier_block *nb);
 
diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
new file mode 100644
index 0000000..fa7922c
--- /dev/null
+++ b/include/linux/sched_clock.h
@@ -0,0 +1,21 @@
+/*
+ * sched_clock.h: support for extending counters to full 64-bit ns counter
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef LINUX_SCHED_CLOCK
+#define LINUX_SCHED_CLOCK
+
+#ifdef CONFIG_GENERIC_SCHED_CLOCK
+extern void sched_clock_postinit(void);
+#else
+static inline void sched_clock_postinit(void) { }
+#endif
+
+extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
+
+extern unsigned long long (*sched_clock_func)(void);
+
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index 2d9b831..68174a5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -758,6 +758,9 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+config GENERIC_SCHED_CLOCK
+	bool
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
diff --git a/init/main.c b/init/main.c
index 9484f4b..bef4a6a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -74,6 +74,7 @@
 #include <linux/ptrace.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
+#include <linux/sched_clock.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -555,6 +556,7 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	sched_clock_postinit();
 	profile_init();
 	call_function_init();
 	WARN(!irqs_disabled(), "Interrupts were enabled early\n");
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fd4b13b..3a951d8 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -721,17 +721,20 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+static void clock_was_set_work(struct work_struct *work)
+{
+	clock_was_set();
+}
+
+static DECLARE_WORK(hrtimer_work, clock_was_set_work);
+
 /*
- * Called from timekeeping code to reprogramm the hrtimer interrupt
- * device. If called from the timer interrupt context we defer it to
- * softirq context.
+ * Called from timekeeping and resume code to reprogramm the hrtimer
+ * interrupt device on all cpus.
  */
 void clock_was_set_delayed(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	cpu_base->clock_was_set = 1;
-	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+	schedule_work(&hrtimer_work);
 }
 
 #else
@@ -773,15 +776,19 @@ void clock_was_set(void)
 
 /*
  * During resume we might have to reprogram the high resolution timer
- * interrupt (on the local CPU):
+ * interrupt on all online CPUs.  However, all other CPUs will be
+ * stopped with IRQs interrupts disabled so the clock_was_set() call
+ * must be deferred.
  */
 void hrtimers_resume(void)
 {
 	WARN_ONCE(!irqs_disabled(),
 		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
 
+	/* Retrigger on the local CPU */
 	retrigger_next_event(NULL);
-	timerfd_clock_was_set();
+	/* And schedule a retrigger for all others */
+	clock_was_set_delayed();
 }
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
@@ -1432,13 +1439,6 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	if (cpu_base->clock_was_set) {
-		cpu_base->clock_was_set = 0;
-		clock_was_set();
-	}
-
 	hrtimer_peek_ahead_timers();
 }
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 42670e9..c7f31aa 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -51,59 +51,28 @@ static int check_clock(const clockid_t which_clock)
 	return error;
 }
 
-static inline union cpu_time_count
+static inline unsigned long long
 timespec_to_sample(const clockid_t which_clock, const struct timespec *tp)
 {
-	union cpu_time_count ret;
-	ret.sched = 0;		/* high half always zero when .cpu used */
+	unsigned long long ret;
+
+	ret = 0;		/* high half always zero when .cpu used */
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		ret.sched = (unsigned long long)tp->tv_sec * NSEC_PER_SEC + tp->tv_nsec;
+		ret = (unsigned long long)tp->tv_sec * NSEC_PER_SEC + tp->tv_nsec;
 	} else {
-		ret.cpu = timespec_to_cputime(tp);
+		ret = cputime_to_expires(timespec_to_cputime(tp));
 	}
 	return ret;
 }
 
 static void sample_to_timespec(const clockid_t which_clock,
-			       union cpu_time_count cpu,
+			       unsigned long long expires,
 			       struct timespec *tp)
 {
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED)
-		*tp = ns_to_timespec(cpu.sched);
+		*tp = ns_to_timespec(expires);
 	else
-		cputime_to_timespec(cpu.cpu, tp);
-}
-
-static inline int cpu_time_before(const clockid_t which_clock,
-				  union cpu_time_count now,
-				  union cpu_time_count then)
-{
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		return now.sched < then.sched;
-	}  else {
-		return now.cpu < then.cpu;
-	}
-}
-static inline void cpu_time_add(const clockid_t which_clock,
-				union cpu_time_count *acc,
-			        union cpu_time_count val)
-{
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		acc->sched += val.sched;
-	}  else {
-		acc->cpu += val.cpu;
-	}
-}
-static inline union cpu_time_count cpu_time_sub(const clockid_t which_clock,
-						union cpu_time_count a,
-						union cpu_time_count b)
-{
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		a.sched -= b.sched;
-	}  else {
-		a.cpu -= b.cpu;
-	}
-	return a;
+		cputime_to_timespec((__force cputime_t)expires, tp);
 }
 
 /*
@@ -111,47 +80,31 @@ static inline union cpu_time_count cpu_time_sub(const clockid_t which_clock,
  * given the current clock sample.
  */
 static void bump_cpu_timer(struct k_itimer *timer,
-				  union cpu_time_count now)
+			   unsigned long long now)
 {
 	int i;
+	unsigned long long delta, incr;
 
-	if (timer->it.cpu.incr.sched == 0)
+	if (timer->it.cpu.incr == 0)
 		return;
 
-	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
-		unsigned long long delta, incr;
+	if (now < timer->it.cpu.expires)
+		return;
 
-		if (now.sched < timer->it.cpu.expires.sched)
-			return;
-		incr = timer->it.cpu.incr.sched;
-		delta = now.sched + incr - timer->it.cpu.expires.sched;
-		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; incr < delta - incr; i++)
-			incr = incr << 1;
-		for (; i >= 0; incr >>= 1, i--) {
-			if (delta < incr)
-				continue;
-			timer->it.cpu.expires.sched += incr;
-			timer->it_overrun += 1 << i;
-			delta -= incr;
-		}
-	} else {
-		cputime_t delta, incr;
+	incr = timer->it.cpu.incr;
+	delta = now + incr - timer->it.cpu.expires;
 
-		if (now.cpu < timer->it.cpu.expires.cpu)
-			return;
-		incr = timer->it.cpu.incr.cpu;
-		delta = now.cpu + incr - timer->it.cpu.expires.cpu;
-		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; incr < delta - incr; i++)
-			     incr += incr;
-		for (; i >= 0; incr = incr >> 1, i--) {
-			if (delta < incr)
-				continue;
-			timer->it.cpu.expires.cpu += incr;
-			timer->it_overrun += 1 << i;
-			delta -= incr;
-		}
+	/* Don't use (incr*2 < delta), incr*2 might overflow. */
+	for (i = 0; incr < delta - incr; i++)
+		incr = incr << 1;
+
+	for (; i >= 0; incr >>= 1, i--) {
+		if (delta < incr)
+			continue;
+
+		timer->it.cpu.expires += incr;
+		timer->it_overrun += 1 << i;
+		delta -= incr;
 	}
 }
 
@@ -170,21 +123,21 @@ static inline int task_cputime_zero(const struct task_cputime *cputime)
 	return 0;
 }
 
-static inline cputime_t prof_ticks(struct task_struct *p)
+static inline unsigned long long prof_ticks(struct task_struct *p)
 {
 	cputime_t utime, stime;
 
 	task_cputime(p, &utime, &stime);
 
-	return utime + stime;
+	return cputime_to_expires(utime + stime);
 }
-static inline cputime_t virt_ticks(struct task_struct *p)
+static inline unsigned long long virt_ticks(struct task_struct *p)
 {
 	cputime_t utime;
 
 	task_cputime(p, &utime, NULL);
 
-	return utime;
+	return cputime_to_expires(utime);
 }
 
 static int
@@ -225,19 +178,19 @@ posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
  * Sample a per-thread clock for the given task.
  */
 static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
-			    union cpu_time_count *cpu)
+			    unsigned long long *sample)
 {
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = prof_ticks(p);
+		*sample = prof_ticks(p);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = virt_ticks(p);
+		*sample = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p);
+		*sample = task_sched_runtime(p);
 		break;
 	}
 	return 0;
@@ -284,7 +237,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
  */
 static int cpu_clock_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
-				  union cpu_time_count *cpu)
+				  unsigned long long *sample)
 {
 	struct task_cputime cputime;
 
@@ -293,15 +246,15 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 		return -EINVAL;
 	case CPUCLOCK_PROF:
 		thread_group_cputime(p, &cputime);
-		cpu->cpu = cputime.utime + cputime.stime;
+		*sample = cputime_to_expires(cputime.utime + cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
 		thread_group_cputime(p, &cputime);
-		cpu->cpu = cputime.utime;
+		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
 		thread_group_cputime(p, &cputime);
-		cpu->sched = cputime.sum_exec_runtime;
+		*sample = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
@@ -312,7 +265,7 @@ static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
 	int error = -EINVAL;
-	union cpu_time_count rtn;
+	unsigned long long rtn;
 
 	if (pid == 0) {
 		/*
@@ -446,6 +399,15 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 	return ret;
 }
 
+static void cleanup_timers_list(struct list_head *head,
+				unsigned long long curr)
+{
+	struct cpu_timer_list *timer, *next;
+
+	list_for_each_entry_safe(timer, next, head, entry)
+		list_del_init(&timer->entry);
+}
+
 /*
  * Clean out CPU timers still ticking when a thread exited.  The task
  * pointer is cleared, and the expiry time is replaced with the residual
@@ -456,37 +418,12 @@ static void cleanup_timers(struct list_head *head,
 			   cputime_t utime, cputime_t stime,
 			   unsigned long long sum_exec_runtime)
 {
-	struct cpu_timer_list *timer, *next;
-	cputime_t ptime = utime + stime;
-
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires.cpu < ptime) {
-			timer->expires.cpu = 0;
-		} else {
-			timer->expires.cpu -= ptime;
-		}
-	}
 
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires.cpu < utime) {
-			timer->expires.cpu = 0;
-		} else {
-			timer->expires.cpu -= utime;
-		}
-	}
+	cputime_t ptime = utime + stime;
 
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires.sched < sum_exec_runtime) {
-			timer->expires.sched = 0;
-		} else {
-			timer->expires.sched -= sum_exec_runtime;
-		}
-	}
+	cleanup_timers_list(head, cputime_to_expires(ptime));
+	cleanup_timers_list(++head, cputime_to_expires(utime));
+	cleanup_timers_list(++head, sum_exec_runtime);
 }
 
 /*
@@ -516,17 +453,21 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
-static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
+static void clear_dead_task(struct k_itimer *itimer, unsigned long long now)
 {
+	struct cpu_timer_list *timer = &itimer->it.cpu;
+
 	/*
 	 * That's all for this thread or process.
 	 * We leave our residual in expires to be reported.
 	 */
-	put_task_struct(timer->it.cpu.task);
-	timer->it.cpu.task = NULL;
-	timer->it.cpu.expires = cpu_time_sub(timer->it_clock,
-					     timer->it.cpu.expires,
-					     now);
+	put_task_struct(timer->task);
+	timer->task = NULL;
+	if (timer->expires < now) {
+		timer->expires = 0;
+	} else {
+		timer->expires -= now;
+	}
 }
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
@@ -558,14 +499,14 @@ static void arm_timer(struct k_itimer *timer)
 
 	listpos = head;
 	list_for_each_entry(next, head, entry) {
-		if (cpu_time_before(timer->it_clock, nt->expires, next->expires))
+		if (nt->expires < next->expires)
 			break;
 		listpos = &next->entry;
 	}
 	list_add(&nt->entry, listpos);
 
 	if (listpos == head) {
-		union cpu_time_count *exp = &nt->expires;
+		unsigned long long exp = nt->expires;
 
 		/*
 		 * We are the new earliest-expiring POSIX 1.b timer, hence
@@ -576,17 +517,17 @@ static void arm_timer(struct k_itimer *timer)
 
 		switch (CPUCLOCK_WHICH(timer->it_clock)) {
 		case CPUCLOCK_PROF:
-			if (expires_gt(cputime_expires->prof_exp, exp->cpu))
-				cputime_expires->prof_exp = exp->cpu;
+			if (expires_gt(cputime_expires->prof_exp, expires_to_cputime(exp)))
+				cputime_expires->prof_exp = expires_to_cputime(exp);
 			break;
 		case CPUCLOCK_VIRT:
-			if (expires_gt(cputime_expires->virt_exp, exp->cpu))
-				cputime_expires->virt_exp = exp->cpu;
+			if (expires_gt(cputime_expires->virt_exp, expires_to_cputime(exp)))
+				cputime_expires->virt_exp = expires_to_cputime(exp);
 			break;
 		case CPUCLOCK_SCHED:
 			if (cputime_expires->sched_exp == 0 ||
-			    cputime_expires->sched_exp > exp->sched)
-				cputime_expires->sched_exp = exp->sched;
+			    cputime_expires->sched_exp > exp)
+				cputime_expires->sched_exp = exp;
 			break;
 		}
 	}
@@ -601,20 +542,20 @@ static void cpu_timer_fire(struct k_itimer *timer)
 		/*
 		 * User don't want any signal.
 		 */
-		timer->it.cpu.expires.sched = 0;
+		timer->it.cpu.expires = 0;
 	} else if (unlikely(timer->sigq == NULL)) {
 		/*
 		 * This a special case for clock_nanosleep,
 		 * not a normal timer from sys_timer_create.
 		 */
 		wake_up_process(timer->it_process);
-		timer->it.cpu.expires.sched = 0;
-	} else if (timer->it.cpu.incr.sched == 0) {
+		timer->it.cpu.expires = 0;
+	} else if (timer->it.cpu.incr == 0) {
 		/*
 		 * One-shot timer.  Clear it as soon as it's fired.
 		 */
 		posix_timer_event(timer, 0);
-		timer->it.cpu.expires.sched = 0;
+		timer->it.cpu.expires = 0;
 	} else if (posix_timer_event(timer, ++timer->it_requeue_pending)) {
 		/*
 		 * The signal did not get queued because the signal
@@ -632,7 +573,7 @@ static void cpu_timer_fire(struct k_itimer *timer)
  */
 static int cpu_timer_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
-				  union cpu_time_count *cpu)
+				  unsigned long long *sample)
 {
 	struct task_cputime cputime;
 
@@ -641,13 +582,13 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime.utime + cputime.stime;
+		*sample = cputime_to_expires(cputime.utime + cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = cputime.utime;
+		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		*sample = cputime.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
 	return 0;
@@ -694,7 +635,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			       struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count old_expires, new_expires, old_incr, val;
+	unsigned long long old_expires, new_expires, old_incr, val;
 	int ret;
 
 	if (unlikely(p == NULL)) {
@@ -749,7 +690,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	}
 
 	if (old) {
-		if (old_expires.sched == 0) {
+		if (old_expires == 0) {
 			old->it_value.tv_sec = 0;
 			old->it_value.tv_nsec = 0;
 		} else {
@@ -764,11 +705,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			 * new setting.
 			 */
 			bump_cpu_timer(timer, val);
-			if (cpu_time_before(timer->it_clock, val,
-					    timer->it.cpu.expires)) {
-				old_expires = cpu_time_sub(
-					timer->it_clock,
-					timer->it.cpu.expires, val);
+			if (val < timer->it.cpu.expires) {
+				old_expires = timer->it.cpu.expires - val;
 				sample_to_timespec(timer->it_clock,
 						   old_expires,
 						   &old->it_value);
@@ -791,8 +729,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		goto out;
 	}
 
-	if (new_expires.sched != 0 && !(flags & TIMER_ABSTIME)) {
-		cpu_time_add(timer->it_clock, &new_expires, val);
+	if (new_expires != 0 && !(flags & TIMER_ABSTIME)) {
+		new_expires += val;
 	}
 
 	/*
@@ -801,8 +739,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 * arm the timer (we'll just fake it for timer_gettime).
 	 */
 	timer->it.cpu.expires = new_expires;
-	if (new_expires.sched != 0 &&
-	    cpu_time_before(timer->it_clock, val, new_expires)) {
+	if (new_expires != 0 && val < new_expires) {
 		arm_timer(timer);
 	}
 
@@ -826,8 +763,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	timer->it_overrun_last = 0;
 	timer->it_overrun = -1;
 
-	if (new_expires.sched != 0 &&
-	    !cpu_time_before(timer->it_clock, val, new_expires)) {
+	if (new_expires != 0 && !(val < new_expires)) {
 		/*
 		 * The designated time already passed, so we notify
 		 * immediately, even if the thread never runs to
@@ -849,7 +785,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 
 static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
-	union cpu_time_count now;
+	unsigned long long now;
 	struct task_struct *p = timer->it.cpu.task;
 	int clear_dead;
 
@@ -859,7 +795,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	sample_to_timespec(timer->it_clock,
 			   timer->it.cpu.incr, &itp->it_interval);
 
-	if (timer->it.cpu.expires.sched == 0) {	/* Timer not armed at all.  */
+	if (timer->it.cpu.expires == 0) {	/* Timer not armed at all.  */
 		itp->it_value.tv_sec = itp->it_value.tv_nsec = 0;
 		return;
 	}
@@ -891,7 +827,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			 */
 			put_task_struct(p);
 			timer->it.cpu.task = NULL;
-			timer->it.cpu.expires.sched = 0;
+			timer->it.cpu.expires = 0;
 			read_unlock(&tasklist_lock);
 			goto dead;
 		} else {
@@ -912,10 +848,9 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		goto dead;
 	}
 
-	if (cpu_time_before(timer->it_clock, now, timer->it.cpu.expires)) {
+	if (now < timer->it.cpu.expires) {
 		sample_to_timespec(timer->it_clock,
-				   cpu_time_sub(timer->it_clock,
-						timer->it.cpu.expires, now),
+				   timer->it.cpu.expires - now,
 				   &itp->it_value);
 	} else {
 		/*
@@ -927,6 +862,28 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 	}
 }
 
+static unsigned long long
+check_timers_list(struct list_head *timers,
+		  struct list_head *firing,
+		  unsigned long long curr)
+{
+	int maxfire = 20;
+
+	while (!list_empty(timers)) {
+		struct cpu_timer_list *t;
+
+		t = list_first_entry(timers, struct cpu_timer_list, entry);
+
+		if (!--maxfire || curr < t->expires)
+			return t->expires;
+
+		t->firing = 1;
+		list_move_tail(&t->entry, firing);
+	}
+
+	return 0;
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them off
  * the tsk->cpu_timers[N] list onto the firing list.  Here we update the
@@ -935,54 +892,20 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 static void check_thread_timers(struct task_struct *tsk,
 				struct list_head *firing)
 {
-	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
 	struct signal_struct *const sig = tsk->signal;
+	struct task_cputime *tsk_expires = &tsk->cputime_expires;
+	unsigned long long expires;
 	unsigned long soft;
 
-	maxfire = 20;
-	tsk->cputime_expires.prof_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || prof_ticks(tsk) < t->expires.cpu) {
-			tsk->cputime_expires.prof_exp = t->expires.cpu;
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	expires = check_timers_list(timers, firing, prof_ticks(tsk));
+	tsk_expires->prof_exp = expires_to_cputime(expires);
 
-	++timers;
-	maxfire = 20;
-	tsk->cputime_expires.virt_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || virt_ticks(tsk) < t->expires.cpu) {
-			tsk->cputime_expires.virt_exp = t->expires.cpu;
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	expires = check_timers_list(++timers, firing, virt_ticks(tsk));
+	tsk_expires->virt_exp = expires_to_cputime(expires);
 
-	++timers;
-	maxfire = 20;
-	tsk->cputime_expires.sched_exp = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
-			tsk->cputime_expires.sched_exp = t->expires.sched;
-			break;
-		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
-	}
+	tsk_expires->sched_exp = check_timers_list(++timers, firing,
+						   tsk->se.sum_exec_runtime);
 
 	/*
 	 * Check for the special case thread timers.
@@ -1030,7 +953,8 @@ static void stop_process_timers(struct signal_struct *sig)
 static u32 onecputick;
 
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
-			     cputime_t *expires, cputime_t cur_time, int signo)
+			     unsigned long long *expires,
+			     unsigned long long cur_time, int signo)
 {
 	if (!it->expires)
 		return;
@@ -1066,9 +990,8 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 static void check_process_timers(struct task_struct *tsk,
 				 struct list_head *firing)
 {
-	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, ptime, virt_expires, prof_expires;
+	unsigned long long utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
@@ -1078,52 +1001,13 @@ static void check_process_timers(struct task_struct *tsk,
 	 * Collect the current process totals.
 	 */
 	thread_group_cputimer(tsk, &cputime);
-	utime = cputime.utime;
-	ptime = utime + cputime.stime;
+	utime = cputime_to_expires(cputime.utime);
+	ptime = utime + cputime_to_expires(cputime.stime);
 	sum_sched_runtime = cputime.sum_exec_runtime;
-	maxfire = 20;
-	prof_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || ptime < tl->expires.cpu) {
-			prof_expires = tl->expires.cpu;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
 
-	++timers;
-	maxfire = 20;
-	virt_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || utime < tl->expires.cpu) {
-			virt_expires = tl->expires.cpu;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
-
-	++timers;
-	maxfire = 20;
-	sched_expires = 0;
-	while (!list_empty(timers)) {
-		struct cpu_timer_list *tl = list_first_entry(timers,
-						      struct cpu_timer_list,
-						      entry);
-		if (!--maxfire || sum_sched_runtime < tl->expires.sched) {
-			sched_expires = tl->expires.sched;
-			break;
-		}
-		tl->firing = 1;
-		list_move_tail(&tl->entry, firing);
-	}
+	prof_expires = check_timers_list(timers, firing, ptime);
+	virt_expires = check_timers_list(++timers, firing, utime);
+	sched_expires = check_timers_list(++timers, firing, sum_sched_runtime);
 
 	/*
 	 * Check for the special case process timers.
@@ -1162,8 +1046,8 @@ static void check_process_timers(struct task_struct *tsk,
 		}
 	}
 
-	sig->cputime_expires.prof_exp = prof_expires;
-	sig->cputime_expires.virt_exp = virt_expires;
+	sig->cputime_expires.prof_exp = expires_to_cputime(prof_expires);
+	sig->cputime_expires.virt_exp = expires_to_cputime(virt_expires);
 	sig->cputime_expires.sched_exp = sched_expires;
 	if (task_cputime_zero(&sig->cputime_expires))
 		stop_process_timers(sig);
@@ -1176,7 +1060,7 @@ static void check_process_timers(struct task_struct *tsk,
 void posix_cpu_timer_schedule(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count now;
+	unsigned long long now;
 
 	if (unlikely(p == NULL))
 		/*
@@ -1205,7 +1089,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			 */
 			put_task_struct(p);
 			timer->it.cpu.task = p = NULL;
-			timer->it.cpu.expires.sched = 0;
+			timer->it.cpu.expires = 0;
 			goto out_unlock;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
 			/*
@@ -1213,6 +1097,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			 * not yet reaped.  Take this opportunity to
 			 * drop our task ref.
 			 */
+			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
@@ -1387,7 +1272,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval)
 {
-	union cpu_time_count now;
+	unsigned long long now;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
@@ -1399,17 +1284,17 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		 * it to be absolute.
 		 */
 		if (*oldval) {
-			if (*oldval <= now.cpu) {
+			if (*oldval <= now) {
 				/* Just about to fire. */
 				*oldval = cputime_one_jiffy;
 			} else {
-				*oldval -= now.cpu;
+				*oldval -= now;
 			}
 		}
 
 		if (!*newval)
 			goto out;
-		*newval += now.cpu;
+		*newval += now;
 	}
 
 	/*
@@ -1459,7 +1344,7 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 		}
 
 		while (!signal_pending(current)) {
-			if (timer.it.cpu.expires.sched == 0) {
+			if (timer.it.cpu.expires == 0) {
 				/*
 				 * Our timer fired and was reset, below
 				 * deletion can not fail.
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2ef90a5..71bac97 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -162,6 +162,39 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
  */
 
 /**
+ * cputimer_running - return true if cputimer is running
+ *
+ * @tsk:	Pointer to target task.
+ */
+static inline bool cputimer_running(struct task_struct *tsk)
+
+{
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+
+	if (!cputimer->running)
+		return false;
+
+	/*
+	 * After we flush the task's sum_exec_runtime to sig->sum_sched_runtime
+	 * in __exit_signal(), we won't account to the signal struct further
+	 * cputime consumed by that task, even though the task can still be
+	 * ticking after __exit_signal().
+	 *
+	 * In order to keep a consistent behaviour between thread group cputime
+	 * and thread group cputimer accounting, lets also ignore the cputime
+	 * elapsing after __exit_signal() in any thread group timer running.
+	 *
+	 * This makes sure that POSIX CPU clocks and timers are synchronized, so
+	 * that a POSIX CPU timer won't expire while the corresponding POSIX CPU
+	 * clock delta is behind the expiring timer value.
+	 */
+	if (unlikely(!tsk->sighand))
+		return false;
+
+	return true;
+}
+
+/**
  * account_group_user_time - Maintain utime for a thread group.
  *
  * @tsk:	Pointer to task structure.
@@ -176,7 +209,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
@@ -199,7 +232,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
@@ -222,7 +255,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!cputimer_running(tsk))
 		return;
 
 	raw_spin_lock(&cputimer->lock);
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index ff7d9d2..9250130 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -4,6 +4,8 @@ obj-y += timeconv.o posix-clock.o alarmtimer.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
+obj-$(CONFIG_GENERIC_SCHED_CLOCK)		+= sched_clock.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
+obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..eec50fc 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -199,6 +199,13 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 
 }
 
+ktime_t alarm_expires_remaining(const struct alarm *alarm)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+	return ktime_sub(alarm->node.expires, base->gettime());
+}
+EXPORT_SYMBOL_GPL(alarm_expires_remaining);
+
 #ifdef CONFIG_RTC_CLASS
 /**
  * alarmtimer_suspend - Suspend time callback
@@ -303,9 +310,10 @@ void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 	alarm->type = type;
 	alarm->state = ALARMTIMER_STATE_INACTIVE;
 }
+EXPORT_SYMBOL_GPL(alarm_init);
 
 /**
- * alarm_start - Sets an alarm to fire
+ * alarm_start - Sets an absolute alarm to fire
  * @alarm: ptr to alarm to set
  * @start: time to run the alarm
  */
@@ -323,6 +331,34 @@ int alarm_start(struct alarm *alarm, ktime_t start)
 	spin_unlock_irqrestore(&base->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(alarm_start);
+
+/**
+ * alarm_start_relative - Sets a relative alarm to fire
+ * @alarm: ptr to alarm to set
+ * @start: time relative to now to run the alarm
+ */
+int alarm_start_relative(struct alarm *alarm, ktime_t start)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+
+	start = ktime_add(start, base->gettime());
+	return alarm_start(alarm, start);
+}
+EXPORT_SYMBOL_GPL(alarm_start_relative);
+
+void alarm_restart(struct alarm *alarm)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+	unsigned long flags;
+
+	spin_lock_irqsave(&base->lock, flags);
+	hrtimer_set_expires(&alarm->timer, alarm->node.expires);
+	hrtimer_restart(&alarm->timer);
+	alarmtimer_enqueue(base, alarm);
+	spin_unlock_irqrestore(&base->lock, flags);
+}
+EXPORT_SYMBOL_GPL(alarm_restart);
 
 /**
  * alarm_try_to_cancel - Tries to cancel an alarm timer
@@ -344,6 +380,7 @@ int alarm_try_to_cancel(struct alarm *alarm)
 	spin_unlock_irqrestore(&base->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(alarm_try_to_cancel);
 
 
 /**
@@ -361,6 +398,7 @@ int alarm_cancel(struct alarm *alarm)
 		cpu_relax();
 	}
 }
+EXPORT_SYMBOL_GPL(alarm_cancel);
 
 
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
@@ -393,8 +431,15 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 	alarm->node.expires = ktime_add(alarm->node.expires, interval);
 	return overrun;
 }
+EXPORT_SYMBOL_GPL(alarm_forward);
 
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
 
+	return alarm_forward(alarm, base->gettime(), interval);
+}
+EXPORT_SYMBOL_GPL(alarm_forward_now);
 
 
 /**
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index c6d6400..38959c8 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -15,20 +15,23 @@
 #include <linux/hrtimer.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/notifier.h>
 #include <linux/smp.h>
+#include <linux/device.h>
 
 #include "tick-internal.h"
 
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
-
-/* Notification for clock events */
-static RAW_NOTIFIER_HEAD(clockevents_chain);
-
 /* Protection for the above */
 static DEFINE_RAW_SPINLOCK(clockevents_lock);
+/* Protection for unbind operations */
+static DEFINE_MUTEX(clockevents_mutex);
+
+struct ce_unbind {
+	struct clock_event_device *ce;
+	int res;
+};
 
 /**
  * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
@@ -232,47 +235,107 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
 	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
 }
 
-/**
- * clockevents_register_notifier - register a clock events change listener
+/*
+ * Called after a notify add to make devices available which were
+ * released from the notifier call.
  */
-int clockevents_register_notifier(struct notifier_block *nb)
+static void clockevents_notify_released(void)
 {
-	unsigned long flags;
-	int ret;
+	struct clock_event_device *dev;
 
-	raw_spin_lock_irqsave(&clockevents_lock, flags);
-	ret = raw_notifier_chain_register(&clockevents_chain, nb);
-	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
+	while (!list_empty(&clockevents_released)) {
+		dev = list_entry(clockevents_released.next,
+				 struct clock_event_device, list);
+		list_del(&dev->list);
+		list_add(&dev->list, &clockevent_devices);
+		tick_check_new_device(dev);
+	}
+}
 
-	return ret;
+/*
+ * Try to install a replacement clock event device
+ */
+static int clockevents_replace(struct clock_event_device *ced)
+{
+	struct clock_event_device *dev, *newdev = NULL;
+
+	list_for_each_entry(dev, &clockevent_devices, list) {
+		if (dev == ced || dev->mode != CLOCK_EVT_MODE_UNUSED)
+			continue;
+
+		if (!tick_check_replacement(newdev, dev))
+			continue;
+
+		if (!try_module_get(dev->owner))
+			continue;
+
+		if (newdev)
+			module_put(newdev->owner);
+		newdev = dev;
+	}
+	if (newdev) {
+		tick_install_replacement(newdev);
+		list_del_init(&ced->list);
+	}
+	return newdev ? 0 : -EBUSY;
 }
 
 /*
- * Notify about a clock event change. Called with clockevents_lock
- * held.
+ * Called with clockevents_mutex and clockevents_lock held
  */
-static void clockevents_do_notify(unsigned long reason, void *dev)
+static int __clockevents_try_unbind(struct clock_event_device *ced, int cpu)
 {
-	raw_notifier_call_chain(&clockevents_chain, reason, dev);
+	/* Fast track. Device is unused */
+	if (ced->mode == CLOCK_EVT_MODE_UNUSED) {
+		list_del_init(&ced->list);
+		return 0;
+	}
+
+	return ced == per_cpu(tick_cpu_device, cpu).evtdev ? -EAGAIN : -EBUSY;
 }
 
 /*
- * Called after a notify add to make devices available which were
- * released from the notifier call.
+ * SMP function call to unbind a device
  */
-static void clockevents_notify_released(void)
+static void __clockevents_unbind(void *arg)
 {
-	struct clock_event_device *dev;
+	struct ce_unbind *cu = arg;
+	int res;
+
+	raw_spin_lock(&clockevents_lock);
+	res = __clockevents_try_unbind(cu->ce, smp_processor_id());
+	if (res == -EAGAIN)
+		res = clockevents_replace(cu->ce);
+	cu->res = res;
+	raw_spin_unlock(&clockevents_lock);
+}
 
-	while (!list_empty(&clockevents_released)) {
-		dev = list_entry(clockevents_released.next,
-				 struct clock_event_device, list);
-		list_del(&dev->list);
-		list_add(&dev->list, &clockevent_devices);
-		clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
-	}
+/*
+ * Issues smp function call to unbind a per cpu device. Called with
+ * clockevents_mutex held.
+ */
+static int clockevents_unbind(struct clock_event_device *ced, int cpu)
+{
+	struct ce_unbind cu = { .ce = ced, .res = -ENODEV };
+
+	smp_call_function_single(cpu, __clockevents_unbind, &cu, 1);
+	return cu.res;
 }
 
+/*
+ * Unbind a clockevents device.
+ */
+int clockevents_unbind_device(struct clock_event_device *ced, int cpu)
+{
+	int ret;
+
+	mutex_lock(&clockevents_mutex);
+	ret = clockevents_unbind(ced, cpu);
+	mutex_unlock(&clockevents_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clockevents_unbind);
+
 /**
  * clockevents_register_device - register a clock event device
  * @dev:	device to register
@@ -290,7 +353,7 @@ void clockevents_register_device(struct clock_event_device *dev)
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 
 	list_add(&dev->list, &clockevent_devices);
-	clockevents_do_notify(CLOCK_EVT_NOTIFY_ADD, dev);
+	tick_check_new_device(dev);
 	clockevents_notify_released();
 
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
@@ -386,6 +449,7 @@ void clockevents_exchange_device(struct clock_event_device *old,
 	 * released list and do a notify add later.
 	 */
 	if (old) {
+		module_put(old->owner);
 		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
 		list_del(&old->list);
 		list_add(&old->list, &clockevents_released);
@@ -433,10 +497,36 @@ void clockevents_notify(unsigned long reason, void *arg)
 	int cpu;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
-	clockevents_do_notify(reason, arg);
 
 	switch (reason) {
+	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
+	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
+	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
+		tick_broadcast_on_off(reason, arg);
+		break;
+
+	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
+	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
+		tick_broadcast_oneshot_control(reason);
+		break;
+
+	case CLOCK_EVT_NOTIFY_CPU_DYING:
+		tick_handover_do_timer(arg);
+		break;
+
+	case CLOCK_EVT_NOTIFY_SUSPEND:
+		tick_suspend();
+		tick_suspend_broadcast();
+		break;
+
+	case CLOCK_EVT_NOTIFY_RESUME:
+		tick_resume();
+		break;
+
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
+		tick_shutdown_broadcast_oneshot(arg);
+		tick_shutdown_broadcast(arg);
+		tick_shutdown(arg);
 		/*
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
@@ -462,4 +552,123 @@ void clockevents_notify(unsigned long reason, void *arg)
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
+
+#ifdef CONFIG_SYSFS
+struct bus_type clockevents_subsys = {
+	.name		= "clockevents",
+	.dev_name       = "clockevent",
+};
+
+static DEFINE_PER_CPU(struct device, tick_percpu_dev);
+static struct tick_device *tick_get_tick_dev(struct device *dev);
+
+static ssize_t sysfs_show_current_tick_dev(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct tick_device *td;
+	ssize_t count = 0;
+
+	raw_spin_lock_irq(&clockevents_lock);
+	td = tick_get_tick_dev(dev);
+	if (td && td->evtdev)
+		count = snprintf(buf, PAGE_SIZE, "%s\n", td->evtdev->name);
+	raw_spin_unlock_irq(&clockevents_lock);
+	return count;
+}
+static DEVICE_ATTR(current_device, 0444, sysfs_show_current_tick_dev, NULL);
+
+/* We don't support the abomination of removable broadcast devices */
+static ssize_t sysfs_unbind_tick_dev(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	char name[CS_NAME_LEN];
+	size_t ret = sysfs_get_uname(buf, name, count);
+	struct clock_event_device *ce;
+
+	if (ret < 0)
+		return ret;
+
+	ret = -ENODEV;
+	mutex_lock(&clockevents_mutex);
+	raw_spin_lock_irq(&clockevents_lock);
+	list_for_each_entry(ce, &clockevent_devices, list) {
+		if (!strcmp(ce->name, name)) {
+			ret = __clockevents_try_unbind(ce, dev->id);
+			break;
+		}
+	}
+	raw_spin_unlock_irq(&clockevents_lock);
+	/*
+	 * We hold clockevents_mutex, so ce can't go away
+	 */
+	if (ret == -EAGAIN)
+		ret = clockevents_unbind(ce, dev->id);
+	mutex_unlock(&clockevents_mutex);
+	return ret ? ret : count;
+}
+static DEVICE_ATTR(unbind_device, 0200, NULL, sysfs_unbind_tick_dev);
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+static struct device tick_bc_dev = {
+	.init_name	= "broadcast",
+	.id		= 0,
+	.bus		= &clockevents_subsys,
+};
+
+static struct tick_device *tick_get_tick_dev(struct device *dev)
+{
+	return dev == &tick_bc_dev ? tick_get_broadcast_device() :
+		&per_cpu(tick_cpu_device, dev->id);
+}
+
+static __init int tick_broadcast_init_sysfs(void)
+{
+	int err = device_register(&tick_bc_dev);
+
+	if (!err)
+		err = device_create_file(&tick_bc_dev, &dev_attr_current_device);
+	return err;
+}
+#else
+static struct tick_device *tick_get_tick_dev(struct device *dev)
+{
+	return &per_cpu(tick_cpu_device, dev->id);
+}
+static inline int tick_broadcast_init_sysfs(void) { return 0; }
 #endif
+
+static int __init tick_init_sysfs(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct device *dev = &per_cpu(tick_percpu_dev, cpu);
+		int err;
+
+		dev->id = cpu;
+		dev->bus = &clockevents_subsys;
+		err = device_register(dev);
+		if (!err)
+			err = device_create_file(dev, &dev_attr_current_device);
+		if (!err)
+			err = device_create_file(dev, &dev_attr_unbind_device);
+		if (err)
+			return err;
+	}
+	return tick_broadcast_init_sysfs();
+}
+
+static int __init clockevents_init_sysfs(void)
+{
+	int err = subsys_system_register(&clockevents_subsys, NULL);
+
+	if (!err)
+		err = tick_init_sysfs();
+	return err;
+}
+device_initcall(clockevents_init_sysfs);
+#endif /* SYSFS */
+
+#endif /* GENERIC_CLOCK_EVENTS */
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..50a8736 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -31,6 +31,8 @@
 #include <linux/tick.h>
 #include <linux/kthread.h>
 
+#include "tick-internal.h"
+
 void timecounter_init(struct timecounter *tc,
 		      const struct cyclecounter *cc,
 		      u64 start_tstamp)
@@ -174,11 +176,12 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
 static struct clocksource *curr_clocksource;
 static LIST_HEAD(clocksource_list);
 static DEFINE_MUTEX(clocksource_mutex);
-static char override_name[32];
+static char override_name[CS_NAME_LEN];
 static int finished_booting;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 static void clocksource_watchdog_work(struct work_struct *work);
+static void clocksource_select(void);
 
 static LIST_HEAD(watchdog_list);
 static struct clocksource *watchdog;
@@ -299,13 +302,30 @@ static void clocksource_watchdog(unsigned long data)
 		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
 		    (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
 		    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
+			/* Mark it valid for high-res. */
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+
+			/*
+			 * clocksource_done_booting() will sort it if
+			 * finished_booting is not set yet.
+			 */
+			if (!finished_booting)
+				continue;
+
 			/*
-			 * We just marked the clocksource as highres-capable,
-			 * notify the rest of the system as well so that we
-			 * transition into high-res mode:
+			 * If this is not the current clocksource let
+			 * the watchdog thread reselect it. Due to the
+			 * change to high res this clocksource might
+			 * be preferred now. If it is the current
+			 * clocksource let the tick code know about
+			 * that change.
 			 */
-			tick_clock_notify();
+			if (cs != curr_clocksource) {
+				cs->flags |= CLOCK_SOURCE_RESELECT;
+				schedule_work(&watchdog_work);
+			} else {
+				tick_clock_notify();
+			}
 		}
 	}
 
@@ -388,44 +408,39 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 
 static void clocksource_dequeue_watchdog(struct clocksource *cs)
 {
-	struct clocksource *tmp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&watchdog_lock, flags);
-	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
-		/* cs is a watched clocksource. */
-		list_del_init(&cs->wd_list);
-	} else if (cs == watchdog) {
-		/* Reset watchdog cycles */
-		clocksource_reset_watchdog();
-		/* Current watchdog is removed. Find an alternative. */
-		watchdog = NULL;
-		list_for_each_entry(tmp, &clocksource_list, list) {
-			if (tmp == cs || tmp->flags & CLOCK_SOURCE_MUST_VERIFY)
-				continue;
-			if (!watchdog || tmp->rating > watchdog->rating)
-				watchdog = tmp;
+	if (cs != watchdog) {
+		if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+			/* cs is a watched clocksource. */
+			list_del_init(&cs->wd_list);
+			/* Check if the watchdog timer needs to be stopped. */
+			clocksource_stop_watchdog();
 		}
 	}
-	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
-	/* Check if the watchdog timer needs to be stopped. */
-	clocksource_stop_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-static int clocksource_watchdog_kthread(void *data)
+static int __clocksource_watchdog_kthread(void)
 {
 	struct clocksource *cs, *tmp;
 	unsigned long flags;
 	LIST_HEAD(unstable);
+	int select = 0;
 
-	mutex_lock(&clocksource_mutex);
 	spin_lock_irqsave(&watchdog_lock, flags);
-	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
+	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
 			list_del_init(&cs->wd_list);
 			list_add(&cs->wd_list, &unstable);
+			select = 1;
 		}
+		if (cs->flags & CLOCK_SOURCE_RESELECT) {
+			cs->flags &= ~CLOCK_SOURCE_RESELECT;
+			select = 1;
+		}
+	}
 	/* Check if the watchdog timer needs to be stopped. */
 	clocksource_stop_watchdog();
 	spin_unlock_irqrestore(&watchdog_lock, flags);
@@ -435,10 +450,23 @@ static int clocksource_watchdog_kthread(void *data)
 		list_del_init(&cs->wd_list);
 		__clocksource_change_rating(cs, 0);
 	}
+	return select;
+}
+
+static int clocksource_watchdog_kthread(void *data)
+{
+	mutex_lock(&clocksource_mutex);
+	if (__clocksource_watchdog_kthread())
+		clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
 
+static bool clocksource_is_watchdog(struct clocksource *cs)
+{
+	return cs == watchdog;
+}
+
 #else /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
 static void clocksource_enqueue_watchdog(struct clocksource *cs)
@@ -449,7 +477,8 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
-static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+static inline int __clocksource_watchdog_kthread(void) { return 0; }
+static bool clocksource_is_watchdog(struct clocksource *cs) { return false; }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
@@ -553,24 +582,42 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
-/**
- * clocksource_select - Select the best clocksource available
- *
- * Private function. Must hold clocksource_mutex when called.
- *
- * Select the clocksource with the best rating, or the clocksource,
- * which is selected by userspace override.
- */
-static void clocksource_select(void)
+static struct clocksource *clocksource_find_best(bool oneshot, bool skipcur)
 {
-	struct clocksource *best, *cs;
+	struct clocksource *cs;
 
 	if (!finished_booting || list_empty(&clocksource_list))
+		return NULL;
+
+	/*
+	 * We pick the clocksource with the highest rating. If oneshot
+	 * mode is active, we pick the highres valid clocksource with
+	 * the best rating.
+	 */
+	list_for_each_entry(cs, &clocksource_list, list) {
+		if (skipcur && cs == curr_clocksource)
+			continue;
+		if (oneshot && !(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES))
+			continue;
+		return cs;
+	}
+	return NULL;
+}
+
+static void __clocksource_select(bool skipcur)
+{
+	bool oneshot = tick_oneshot_mode_active();
+	struct clocksource *best, *cs;
+
+	/* Find the best suitable clocksource */
+	best = clocksource_find_best(oneshot, skipcur);
+	if (!best)
 		return;
-	/* First clocksource on the list has the best rating. */
-	best = list_first_entry(&clocksource_list, struct clocksource, list);
+
 	/* Check for the override clocksource. */
 	list_for_each_entry(cs, &clocksource_list, list) {
+		if (skipcur && cs == curr_clocksource)
+			continue;
 		if (strcmp(cs->name, override_name) != 0)
 			continue;
 		/*
@@ -578,8 +625,7 @@ static void clocksource_select(void)
 		 * capable clocksource if the tick code is in oneshot
 		 * mode (highres or nohz)
 		 */
-		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) &&
-		    tick_oneshot_mode_active()) {
+		if (!(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES) && oneshot) {
 			/* Override clocksource cannot be used. */
 			printk(KERN_WARNING "Override clocksource %s is not "
 			       "HRT compatible. Cannot switch while in "
@@ -590,16 +636,35 @@ static void clocksource_select(void)
 			best = cs;
 		break;
 	}
-	if (curr_clocksource != best) {
-		printk(KERN_INFO "Switching to clocksource %s\n", best->name);
+
+	if (curr_clocksource != best && !timekeeping_notify(best)) {
+		pr_info("Switched to clocksource %s\n", best->name);
 		curr_clocksource = best;
-		timekeeping_notify(curr_clocksource);
 	}
 }
 
+/**
+ * clocksource_select - Select the best clocksource available
+ *
+ * Private function. Must hold clocksource_mutex when called.
+ *
+ * Select the clocksource with the best rating, or the clocksource,
+ * which is selected by userspace override.
+ */
+static void clocksource_select(void)
+{
+	return __clocksource_select(false);
+}
+
+static void clocksource_select_fallback(void)
+{
+	return __clocksource_select(true);
+}
+
 #else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 static inline void clocksource_select(void) { }
+static inline void clocksource_select_fallback(void) { }
 
 #endif
 
@@ -614,16 +679,11 @@ static int __init clocksource_done_booting(void)
 {
 	mutex_lock(&clocksource_mutex);
 	curr_clocksource = clocksource_default_clock();
-	mutex_unlock(&clocksource_mutex);
-
 	finished_booting = 1;
-
 	/*
 	 * Run the watchdog first to eliminate unstable clock sources
 	 */
-	clocksource_watchdog_kthread(NULL);
-
-	mutex_lock(&clocksource_mutex);
+	__clocksource_watchdog_kthread();
 	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
@@ -756,7 +816,6 @@ static void __clocksource_change_rating(struct clocksource *cs, int rating)
 	list_del(&cs->list);
 	cs->rating = rating;
 	clocksource_enqueue(cs);
-	clocksource_select();
 }
 
 /**
@@ -768,21 +827,47 @@ void clocksource_change_rating(struct clocksource *cs, int rating)
 {
 	mutex_lock(&clocksource_mutex);
 	__clocksource_change_rating(cs, rating);
+	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 }
 EXPORT_SYMBOL(clocksource_change_rating);
 
+/*
+ * Unbind clocksource @cs. Called with clocksource_mutex held
+ */
+static int clocksource_unbind(struct clocksource *cs)
+{
+	/*
+	 * I really can't convince myself to support this on hardware
+	 * designed by lobotomized monkeys.
+	 */
+	if (clocksource_is_watchdog(cs))
+		return -EBUSY;
+
+	if (cs == curr_clocksource) {
+		/* Select and try to install a replacement clock source */
+		clocksource_select_fallback();
+		if (curr_clocksource == cs)
+			return -EBUSY;
+	}
+	clocksource_dequeue_watchdog(cs);
+	list_del_init(&cs->list);
+	return 0;
+}
+
 /**
  * clocksource_unregister - remove a registered clocksource
  * @cs:	clocksource to be unregistered
  */
-void clocksource_unregister(struct clocksource *cs)
+int clocksource_unregister(struct clocksource *cs)
 {
+	int ret = 0;
+
 	mutex_lock(&clocksource_mutex);
-	clocksource_dequeue_watchdog(cs);
-	list_del(&cs->list);
-	clocksource_select();
+	if (!list_empty(&cs->list))
+		ret = clocksource_unbind(cs);
 	mutex_unlock(&clocksource_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(clocksource_unregister);
 
@@ -808,6 +893,23 @@ sysfs_show_current_clocksources(struct device *dev,
 	return count;
 }
 
+size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt)
+{
+	size_t ret = cnt;
+
+	/* strings from sysfs write are not 0 terminated! */
+	if (!cnt || cnt >= CS_NAME_LEN)
+		return -EINVAL;
+
+	/* strip of \n: */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+	if (cnt > 0)
+		memcpy(dst, buf, cnt);
+	dst[cnt] = 0;
+	return ret;
+}
+
 /**
  * sysfs_override_clocksource - interface for manually overriding clocksource
  * @dev:	unused
@@ -822,22 +924,13 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	size_t ret = count;
-
-	/* strings from sysfs write are not 0 terminated! */
-	if (count >= sizeof(override_name))
-		return -EINVAL;
-
-	/* strip of \n: */
-	if (buf[count-1] == '\n')
-		count--;
+	size_t ret;
 
 	mutex_lock(&clocksource_mutex);
 
-	if (count > 0)
-		memcpy(override_name, buf, count);
-	override_name[count] = 0;
-	clocksource_select();
+	ret = sysfs_get_uname(buf, override_name, count);
+	if (ret >= 0)
+		clocksource_select();
 
 	mutex_unlock(&clocksource_mutex);
 
@@ -845,6 +938,40 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 }
 
 /**
+ * sysfs_unbind_current_clocksource - interface for manually unbinding clocksource
+ * @dev:	unused
+ * @attr:	unused
+ * @buf:	unused
+ * @count:	length of buffer
+ *
+ * Takes input from sysfs interface for manually unbinding a clocksource.
+ */
+static ssize_t sysfs_unbind_clocksource(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct clocksource *cs;
+	char name[CS_NAME_LEN];
+	size_t ret;
+
+	ret = sysfs_get_uname(buf, name, count);
+	if (ret < 0)
+		return ret;
+
+	ret = -ENODEV;
+	mutex_lock(&clocksource_mutex);
+	list_for_each_entry(cs, &clocksource_list, list) {
+		if (strcmp(cs->name, name))
+			continue;
+		ret = clocksource_unbind(cs);
+		break;
+	}
+	mutex_unlock(&clocksource_mutex);
+
+	return ret ? ret : count;
+}
+
+/**
  * sysfs_show_available_clocksources - sysfs interface for listing clocksource
  * @dev:	unused
  * @attr:	unused
@@ -886,6 +1013,8 @@ sysfs_show_available_clocksources(struct device *dev,
 static DEVICE_ATTR(current_clocksource, 0644, sysfs_show_current_clocksources,
 		   sysfs_override_clocksource);
 
+static DEVICE_ATTR(unbind_clocksource, 0200, NULL, sysfs_unbind_clocksource);
+
 static DEVICE_ATTR(available_clocksource, 0444,
 		   sysfs_show_available_clocksources, NULL);
 
@@ -910,6 +1039,9 @@ static int __init init_clocksource_sysfs(void)
 				&device_clocksource,
 				&dev_attr_current_clocksource);
 	if (!error)
+		error = device_create_file(&device_clocksource,
+					   &dev_attr_unbind_clocksource);
+	if (!error)
 		error = device_create_file(
 				&device_clocksource,
 				&dev_attr_available_clocksource);
diff --git a/arch/arm/kernel/sched_clock.c b/kernel/time/sched_clock.c
similarity index 94%
rename from arch/arm/kernel/sched_clock.c
rename to kernel/time/sched_clock.c
index e8edcaa..a326f27 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -13,8 +13,7 @@
 #include <linux/sched.h>
 #include <linux/syscore_ops.h>
 #include <linux/timer.h>
-
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 struct clock_data {
 	u64 epoch_ns;
@@ -24,7 +23,6 @@ struct clock_data {
 	u32 mult;
 	u32 shift;
 	bool suspended;
-	bool needs_suspend;
 };
 
 static void sched_clock_poll(unsigned long wrap_ticks);
@@ -51,10 +49,11 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace sched_clock_32(void)
 {
 	u64 epoch_ns;
 	u32 epoch_cyc;
+	u32 cyc;
 
 	if (cd.suspended)
 		return cd.epoch_ns;
@@ -73,7 +72,9 @@ static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 		smp_rmb();
 	} while (epoch_cyc != cd.epoch_cyc_copy);
 
-	return epoch_ns + cyc_to_ns((cyc - epoch_cyc) & mask, cd.mult, cd.shift);
+	cyc = read_sched_clock();
+	cyc = (cyc - epoch_cyc) & sched_clock_mask;
+	return epoch_ns + cyc_to_ns(cyc, cd.mult, cd.shift);
 }
 
 /*
@@ -165,12 +166,6 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
-static unsigned long long notrace sched_clock_32(void)
-{
-	u32 cyc = read_sched_clock();
-	return cyc_to_sched_clock(cyc, sched_clock_mask);
-}
-
 unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
 
 unsigned long long notrace sched_clock(void)
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 20d6fba..6d3f916 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -19,6 +19,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/module.h>
 
 #include "tick-internal.h"
 
@@ -29,6 +30,7 @@
 
 static struct tick_device tick_broadcast_device;
 static cpumask_var_t tick_broadcast_mask;
+static cpumask_var_t tick_broadcast_on;
 static cpumask_var_t tmpmask;
 static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
@@ -64,17 +66,34 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
 /*
  * Check, if the device can be utilized as broadcast device:
  */
-int tick_check_broadcast_device(struct clock_event_device *dev)
+static bool tick_check_broadcast_device(struct clock_event_device *curdev,
+					struct clock_event_device *newdev)
+{
+	if ((newdev->features & CLOCK_EVT_FEAT_DUMMY) ||
+	    (newdev->features & CLOCK_EVT_FEAT_C3STOP))
+		return false;
+
+	if (tick_broadcast_device.mode == TICKDEV_MODE_ONESHOT &&
+	    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
+		return false;
+
+	return !curdev || newdev->rating > curdev->rating;
+}
+
+/*
+ * Conditionally install/replace broadcast device
+ */
+void tick_install_broadcast_device(struct clock_event_device *dev)
 {
 	struct clock_event_device *cur = tick_broadcast_device.evtdev;
 
-	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
-	    (tick_broadcast_device.evtdev &&
-	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
-	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
-		return 0;
+	if (!tick_check_broadcast_device(cur, dev))
+		return;
 
-	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
+	if (!try_module_get(dev->owner))
+		return;
+
+	clockevents_exchange_device(cur, dev);
 	if (cur)
 		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
@@ -90,7 +109,6 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 	 */
 	if (dev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_clock_notify();
-	return 1;
 }
 
 /*
@@ -123,8 +141,9 @@ static void tick_device_setup_broadcast_func(struct clock_event_device *dev)
  */
 int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 {
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -138,20 +157,59 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		dev->event_handler = tick_handle_periodic;
 		tick_device_setup_broadcast_func(dev);
 		cpumask_set_cpu(cpu, tick_broadcast_mask);
-		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
+		tick_broadcast_start_periodic(bc);
 		ret = 1;
 	} else {
 		/*
-		 * When the new device is not affected by the stop
-		 * feature and the cpu is marked in the broadcast mask
-		 * then clear the broadcast bit.
+		 * Clear the broadcast bit for this cpu if the
+		 * device is not power state affected.
 		 */
-		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
-			int cpu = smp_processor_id();
+		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
 			cpumask_clear_cpu(cpu, tick_broadcast_mask);
-			tick_broadcast_clear_oneshot(cpu);
-		} else {
+		else
 			tick_device_setup_broadcast_func(dev);
+
+		/*
+		 * Clear the broadcast bit if the CPU is not in
+		 * periodic broadcast on state.
+		 */
+		if (!cpumask_test_cpu(cpu, tick_broadcast_on))
+			cpumask_clear_cpu(cpu, tick_broadcast_mask);
+
+		switch (tick_broadcast_device.mode) {
+		case TICKDEV_MODE_ONESHOT:
+			/*
+			 * If the system is in oneshot mode we can
+			 * unconditionally clear the oneshot mask bit,
+			 * because the CPU is running and therefore
+			 * not in an idle state which causes the power
+			 * state affected device to stop. Let the
+			 * caller initialize the device.
+			 */
+			tick_broadcast_clear_oneshot(cpu);
+			ret = 0;
+			break;
+
+		case TICKDEV_MODE_PERIODIC:
+			/*
+			 * If the system is in periodic mode, check
+			 * whether the broadcast device can be
+			 * switched off now.
+			 */
+			if (cpumask_empty(tick_broadcast_mask) && bc)
+				clockevents_shutdown(bc);
+			/*
+			 * If we kept the cpu in the broadcast mask,
+			 * tell the caller to leave the per cpu device
+			 * in shutdown state. The periodic interrupt
+			 * is delivered by the broadcast device.
+			 */
+			ret = cpumask_test_cpu(cpu, tick_broadcast_mask);
+			break;
+		default:
+			/* Nothing to do */
+			ret = 0;
+			break;
 		}
 	}
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -281,6 +339,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
+		cpumask_set_cpu(cpu, tick_broadcast_on);
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
@@ -290,8 +349,12 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 			tick_broadcast_force = 1;
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
-		if (!tick_broadcast_force &&
-		    cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
+		if (tick_broadcast_force)
+			break;
+		cpumask_clear_cpu(cpu, tick_broadcast_on);
+		if (!tick_device_is_functional(dev))
+			break;
+		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
@@ -349,6 +412,7 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 
 	bc = tick_broadcast_device.evtdev;
 	cpumask_clear_cpu(cpu, tick_broadcast_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_on);
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
 		if (bc && cpumask_empty(tick_broadcast_mask))
@@ -475,7 +539,15 @@ void tick_check_oneshot_broadcast(int cpu)
 	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
-		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
+		/*
+		 * We might be in the middle of switching over from
+		 * periodic to oneshot. If the CPU has not yet
+		 * switched over, leave the device alone.
+		 */
+		if (td->mode == TICKDEV_MODE_ONESHOT) {
+			clockevents_set_mode(td->evtdev,
+					     CLOCK_EVT_MODE_ONESHOT);
+		}
 	}
 }
 
@@ -522,6 +594,13 @@ again:
 	cpumask_clear(tick_broadcast_force_mask);
 
 	/*
+	 * Sanity check. Catch the case where we try to broadcast to
+	 * offline cpus.
+	 */
+	if (WARN_ON_ONCE(!cpumask_subset(tmpmask, cpu_online_mask)))
+		cpumask_and(tmpmask, tmpmask, cpu_online_mask);
+
+	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
 	tick_do_broadcast(tmpmask);
@@ -761,10 +840,12 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	/*
-	 * Clear the broadcast mask flag for the dead cpu, but do not
-	 * stop the broadcast device!
+	 * Clear the broadcast masks for the dead cpu, but do not stop
+	 * the broadcast device!
 	 */
 	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
 
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
@@ -792,6 +873,7 @@ bool tick_broadcast_oneshot_available(void)
 void __init tick_broadcast_init(void)
 {
 	zalloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_on, GFP_NOWAIT);
 	zalloc_cpumask_var(&tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_TICK_ONESHOT
 	zalloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 5d3fb10..64522ec 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 #include <asm/irq_regs.h>
 
@@ -33,7 +34,6 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
 ktime_t tick_next_period;
 ktime_t tick_period;
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
-static DEFINE_RAW_SPINLOCK(tick_device_lock);
 
 /*
  * Debugging: see timer_list.c
@@ -194,7 +194,8 @@ static void tick_setup_device(struct tick_device *td,
 	 * When global broadcasting is active, check if the current
 	 * device is registered as a placeholder for broadcast mode.
 	 * This allows us to handle this x86 misfeature in a generic
-	 * way.
+	 * way. This function also returns !=0 when we keep the
+	 * current active broadcast state for this CPU.
 	 */
 	if (tick_device_uses_broadcast(newdev, cpu))
 		return;
@@ -205,17 +206,75 @@ static void tick_setup_device(struct tick_device *td,
 		tick_setup_oneshot(newdev, handler, next_event);
 }
 
+void tick_install_replacement(struct clock_event_device *newdev)
+{
+	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
+	int cpu = smp_processor_id();
+
+	clockevents_exchange_device(td->evtdev, newdev);
+	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
+	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
+		tick_oneshot_notify();
+}
+
+static bool tick_check_percpu(struct clock_event_device *curdev,
+			      struct clock_event_device *newdev, int cpu)
+{
+	if (!cpumask_test_cpu(cpu, newdev->cpumask))
+		return false;
+	if (cpumask_equal(newdev->cpumask, cpumask_of(cpu)))
+		return true;
+	/* Check if irq affinity can be set */
+	if (newdev->irq >= 0 && !irq_can_set_affinity(newdev->irq))
+		return false;
+	/* Prefer an existing cpu local device */
+	if (curdev && cpumask_equal(curdev->cpumask, cpumask_of(cpu)))
+		return false;
+	return true;
+}
+
+static bool tick_check_preferred(struct clock_event_device *curdev,
+				 struct clock_event_device *newdev)
+{
+	/* Prefer oneshot capable device */
+	if (!(newdev->features & CLOCK_EVT_FEAT_ONESHOT)) {
+		if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
+			return false;
+		if (tick_oneshot_mode_active())
+			return false;
+	}
+
+	/*
+	 * Use the higher rated one, but prefer a CPU local device with a lower
+	 * rating than a non-CPU local device
+	 */
+	return !curdev ||
+		newdev->rating > curdev->rating ||
+	       !cpumask_equal(curdev->cpumask, newdev->cpumask);
+}
+
+/*
+ * Check whether the new device is a better fit than curdev. curdev
+ * can be NULL !
+ */
+bool tick_check_replacement(struct clock_event_device *curdev,
+			    struct clock_event_device *newdev)
+{
+	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
+		return false;
+
+	return tick_check_preferred(curdev, newdev);
+}
+
 /*
- * Check, if the new registered device should be used.
+ * Check, if the new registered device should be used. Called with
+ * clockevents_lock held and interrupts disabled.
  */
-static int tick_check_new_device(struct clock_event_device *newdev)
+void tick_check_new_device(struct clock_event_device *newdev)
 {
 	struct clock_event_device *curdev;
 	struct tick_device *td;
-	int cpu, ret = NOTIFY_OK;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
+	int cpu;
 
 	cpu = smp_processor_id();
 	if (!cpumask_test_cpu(cpu, newdev->cpumask))
@@ -225,40 +284,15 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	curdev = td->evtdev;
 
 	/* cpu local device ? */
-	if (!cpumask_equal(newdev->cpumask, cpumask_of(cpu))) {
-
-		/*
-		 * If the cpu affinity of the device interrupt can not
-		 * be set, ignore it.
-		 */
-		if (!irq_can_set_affinity(newdev->irq))
-			goto out_bc;
+	if (!tick_check_percpu(curdev, newdev, cpu))
+		goto out_bc;
 
-		/*
-		 * If we have a cpu local device already, do not replace it
-		 * by a non cpu local device
-		 */
-		if (curdev && cpumask_equal(curdev->cpumask, cpumask_of(cpu)))
-			goto out_bc;
-	}
+	/* Preference decision */
+	if (!tick_check_preferred(curdev, newdev))
+		goto out_bc;
 
-	/*
-	 * If we have an active device, then check the rating and the oneshot
-	 * feature.
-	 */
-	if (curdev) {
-		/*
-		 * Prefer one shot capable devices !
-		 */
-		if ((curdev->features & CLOCK_EVT_FEAT_ONESHOT) &&
-		    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
-			goto out_bc;
-		/*
-		 * Check the rating
-		 */
-		if (curdev->rating >= newdev->rating)
-			goto out_bc;
-	}
+	if (!try_module_get(newdev->owner))
+		return;
 
 	/*
 	 * Replace the eventually existing device by the new
@@ -273,20 +307,13 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
-
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
-	return NOTIFY_STOP;
+	return;
 
 out_bc:
 	/*
 	 * Can the new device be used as a broadcast device ?
 	 */
-	if (tick_check_broadcast_device(newdev))
-		ret = NOTIFY_STOP;
-
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
-
-	return ret;
+	tick_install_broadcast_device(newdev);
 }
 
 /*
@@ -294,7 +321,7 @@ out_bc:
  *
  * Called with interrupts disabled.
  */
-static void tick_handover_do_timer(int *cpup)
+void tick_handover_do_timer(int *cpup)
 {
 	if (*cpup == tick_do_timer_cpu) {
 		int cpu = cpumask_first(cpu_online_mask);
@@ -311,13 +338,11 @@ static void tick_handover_do_timer(int *cpup)
  * access the hardware device itself.
  * We just set the mode and remove it from the lists.
  */
-static void tick_shutdown(unsigned int *cpup)
+void tick_shutdown(unsigned int *cpup)
 {
 	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
 	struct clock_event_device *dev = td->evtdev;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	td->mode = TICKDEV_MODE_PERIODIC;
 	if (dev) {
 		/*
@@ -329,26 +354,20 @@ static void tick_shutdown(unsigned int *cpup)
 		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
-static void tick_suspend(void)
+void tick_suspend(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_shutdown(td->evtdev);
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
-static void tick_resume(void)
+void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
-	unsigned long flags;
 	int broadcast = tick_resume_broadcast();
 
-	raw_spin_lock_irqsave(&tick_device_lock, flags);
 	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
 
 	if (!broadcast) {
@@ -357,68 +376,12 @@ static void tick_resume(void)
 		else
 			tick_resume_oneshot();
 	}
-	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
-/*
- * Notification about clock event devices
- */
-static int tick_notify(struct notifier_block *nb, unsigned long reason,
-			       void *dev)
-{
-	switch (reason) {
-
-	case CLOCK_EVT_NOTIFY_ADD:
-		return tick_check_new_device(dev);
-
-	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
-	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
-	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		tick_broadcast_on_off(reason, dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
-	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
-		tick_broadcast_oneshot_control(reason);
-		break;
-
-	case CLOCK_EVT_NOTIFY_CPU_DYING:
-		tick_handover_do_timer(dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_CPU_DEAD:
-		tick_shutdown_broadcast_oneshot(dev);
-		tick_shutdown_broadcast(dev);
-		tick_shutdown(dev);
-		break;
-
-	case CLOCK_EVT_NOTIFY_SUSPEND:
-		tick_suspend();
-		tick_suspend_broadcast();
-		break;
-
-	case CLOCK_EVT_NOTIFY_RESUME:
-		tick_resume();
-		break;
-
-	default:
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block tick_notifier = {
-	.notifier_call = tick_notify,
-};
-
 /**
  * tick_init - initialize the tick control
- *
- * Register the notifier with the clockevents framework
  */
 void __init tick_init(void)
 {
-	clockevents_register_notifier(&tick_notifier);
 	tick_broadcast_init();
 }
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index f0299ea..bc906ca 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -6,6 +6,8 @@
 
 extern seqlock_t jiffies_lock;
 
+#define CS_NAME_LEN	32
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
 
 #define TICK_DO_TIMER_NONE	-1
@@ -18,9 +20,19 @@ extern int tick_do_timer_cpu __read_mostly;
 
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
+extern void tick_check_new_device(struct clock_event_device *dev);
+extern void tick_handover_do_timer(int *cpup);
+extern void tick_shutdown(unsigned int *cpup);
+extern void tick_suspend(void);
+extern void tick_resume(void);
+extern bool tick_check_replacement(struct clock_event_device *curdev,
+				   struct clock_event_device *newdev);
+extern void tick_install_replacement(struct clock_event_device *dev);
 
 extern void clockevents_shutdown(struct clock_event_device *dev);
 
+extern size_t sysfs_get_uname(const char *buf, char *dst, size_t cnt);
+
 /*
  * NO_HZ / high resolution timer shared code
  */
@@ -90,7 +102,7 @@ static inline bool tick_broadcast_oneshot_available(void) { return false; }
  */
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu);
-extern int tick_check_broadcast_device(struct clock_event_device *dev);
+extern void tick_install_broadcast_device(struct clock_event_device *dev);
 extern int tick_is_broadcast_device(struct clock_event_device *dev);
 extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
 extern void tick_shutdown_broadcast(unsigned int *cpup);
@@ -102,9 +114,8 @@ tick_set_periodic_handler(struct clock_event_device *dev, int broadcast);
 
 #else /* !BROADCAST */
 
-static inline int tick_check_broadcast_device(struct clock_event_device *dev)
+static inline void tick_install_broadcast_device(struct clock_event_device *dev)
 {
-	return 0;
 }
 
 static inline int tick_is_broadcast_device(struct clock_event_device *dev)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index baeeb5c..48b9fff 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -25,6 +25,11 @@
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
+#include "timekeeping_internal.h"
+
+#define TK_CLEAR_NTP		(1 << 0)
+#define TK_MIRROR		(1 << 1)
+#define TK_CLOCK_WAS_SET	(1 << 2)
 
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
@@ -200,9 +205,9 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
-static void update_pvclock_gtod(struct timekeeper *tk)
+static void update_pvclock_gtod(struct timekeeper *tk, bool was_set)
 {
-	raw_notifier_call_chain(&pvclock_gtod_chain, 0, tk);
+	raw_notifier_call_chain(&pvclock_gtod_chain, was_set, tk);
 }
 
 /**
@@ -216,7 +221,7 @@ int pvclock_gtod_register_notifier(struct notifier_block *nb)
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, true);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
@@ -241,16 +246,16 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
 
 /* must hold timekeeper_lock */
-static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
+static void timekeeping_update(struct timekeeper *tk, unsigned int action)
 {
-	if (clearntp) {
+	if (action & TK_CLEAR_NTP) {
 		tk->ntp_error = 0;
 		ntp_clear();
 	}
 	update_vsyscall(tk);
-	update_pvclock_gtod(tk);
+	update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET);
 
-	if (mirror)
+	if (action & TK_MIRROR)
 		memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 }
 
@@ -508,7 +513,7 @@ int do_settimeofday(const struct timespec *tv)
 
 	tk_set_xtime(tk, tv);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -552,7 +557,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
 error: /* even if we error out, we forwarded the time, so call update */
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -627,13 +632,22 @@ static int change_clocksource(void *data)
 	write_seqcount_begin(&timekeeper_seq);
 
 	timekeeping_forward_now(tk);
-	if (!new->enable || new->enable(new) == 0) {
-		old = tk->clock;
-		tk_setup_internals(tk, new);
-		if (old->disable)
-			old->disable(old);
+	/*
+	 * If the cs is in module, get a module reference. Succeeds
+	 * for built-in code (owner == NULL) as well.
+	 */
+	if (try_module_get(new->owner)) {
+		if (!new->enable || new->enable(new) == 0) {
+			old = tk->clock;
+			tk_setup_internals(tk, new);
+			if (old->disable)
+				old->disable(old);
+			module_put(old->owner);
+		} else {
+			module_put(new->owner);
+		}
 	}
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -648,14 +662,15 @@ static int change_clocksource(void *data)
  * This function is called from clocksource.c after a new, better clock
  * source has been registered. The caller holds the clocksource_mutex.
  */
-void timekeeping_notify(struct clocksource *clock)
+int timekeeping_notify(struct clocksource *clock)
 {
 	struct timekeeper *tk = &timekeeper;
 
 	if (tk->clock == clock)
-		return;
+		return 0;
 	stop_machine(change_clocksource, clock, NULL);
 	tick_clock_notify();
+	return tk->clock == clock ? 0 : -1;
 }
 
 /**
@@ -841,6 +856,7 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 	tk_xtime_add(tk, delta);
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *delta));
 	tk_set_sleep_time(tk, timespec_add(tk->total_sleep_time, *delta));
+	tk_debug_account_sleep_time(delta);
 }
 
 /**
@@ -872,7 +888,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(tk, delta);
 
-	timekeeping_update(tk, true, true);
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -954,7 +970,7 @@ static void timekeeping_resume(void)
 	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
-	timekeeping_update(tk, false, true);
+	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
@@ -1236,9 +1252,10 @@ out_adjust:
  * It also calls into the NTP code to handle leapsecond processing.
  *
  */
-static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
+static inline unsigned int accumulate_nsecs_to_secs(struct timekeeper *tk)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << tk->shift;
+	unsigned int action = 0;
 
 	while (tk->xtime_nsec >= nsecps) {
 		int leap;
@@ -1261,8 +1278,10 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
 			clock_was_set_delayed();
+			action = TK_CLOCK_WAS_SET;
 		}
 	}
+	return action;
 }
 
 /**
@@ -1347,6 +1366,7 @@ static void update_wall_time(void)
 	struct timekeeper *tk = &shadow_timekeeper;
 	cycle_t offset;
 	int shift = 0, maxshift;
+	unsigned int action;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
@@ -1399,7 +1419,7 @@ static void update_wall_time(void)
 	 * Finally, make sure that after the rounding
 	 * xtime_nsec isn't larger than NSEC_PER_SEC
 	 */
-	accumulate_nsecs_to_secs(tk);
+	action = accumulate_nsecs_to_secs(tk);
 
 	write_seqcount_begin(&timekeeper_seq);
 	/* Update clock->cycle_last with the new value */
@@ -1415,7 +1435,7 @@ static void update_wall_time(void)
 	 * updating.
 	 */
 	memcpy(real_tk, tk, sizeof(*tk));
-	timekeeping_update(real_tk, false, false);
+	timekeeping_update(real_tk, action);
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
@@ -1677,6 +1697,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
+		update_pvclock_gtod(tk, true);
 		clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);
diff --git a/kernel/time/timekeeping_debug.c b/kernel/time/timekeeping_debug.c
new file mode 100644
index 0000000..802433a
--- /dev/null
+++ b/kernel/time/timekeeping_debug.c
@@ -0,0 +1,72 @@
+/*
+ * debugfs file to track time spent in suspend
+ *
+ * Copyright (c) 2011, Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+#include <linux/time.h>
+
+static unsigned int sleep_time_bin[32] = {0};
+
+static int tk_debug_show_sleep_time(struct seq_file *s, void *data)
+{
+	unsigned int bin;
+	seq_puts(s, "      time (secs)        count\n");
+	seq_puts(s, "------------------------------\n");
+	for (bin = 0; bin < 32; bin++) {
+		if (sleep_time_bin[bin] == 0)
+			continue;
+		seq_printf(s, "%10u - %-10u %4u\n",
+			bin ? 1 << (bin - 1) : 0, 1 << bin,
+				sleep_time_bin[bin]);
+	}
+	return 0;
+}
+
+static int tk_debug_sleep_time_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tk_debug_show_sleep_time, NULL);
+}
+
+static const struct file_operations tk_debug_sleep_time_fops = {
+	.open		= tk_debug_sleep_time_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init tk_debug_sleep_time_init(void)
+{
+	struct dentry *d;
+
+	d = debugfs_create_file("sleep_time", 0444, NULL, NULL,
+		&tk_debug_sleep_time_fops);
+	if (!d) {
+		pr_err("Failed to create sleep_time debug file\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+late_initcall(tk_debug_sleep_time_init);
+
+void tk_debug_account_sleep_time(struct timespec *t)
+{
+	sleep_time_bin[fls(t->tv_sec)]++;
+}
+
diff --git a/kernel/time/timekeeping_internal.h b/kernel/time/timekeeping_internal.h
new file mode 100644
index 0000000..13323ea
--- /dev/null
+++ b/kernel/time/timekeeping_internal.h
@@ -0,0 +1,14 @@
+#ifndef _TIMEKEEPING_INTERNAL_H
+#define _TIMEKEEPING_INTERNAL_H
+/*
+ * timekeeping debug functions
+ */
+#include <linux/time.h>
+
+#ifdef CONFIG_DEBUG_FS
+extern void tk_debug_account_sleep_time(struct timespec *t);
+#else
+#define tk_debug_account_sleep_time(x)
+#endif
+
+#endif /* _TIMEKEEPING_INTERNAL_H */
diff --git a/kernel/timer.c b/kernel/timer.c
index 15ffdb3..15bc1b4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -149,9 +149,11 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
 
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
-		return original;
-	return j;
+	/*
+	 * Make sure j is still in the future. Otherwise return the
+	 * unmodified value.
+	 */
+	return time_is_after_jiffies(j) ? j : original;
 }
 
 /**
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 0a63658..4cb14ca 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -6,6 +6,7 @@ TARGETS += memory-hotplug
 TARGETS += mqueue
 TARGETS += net
 TARGETS += ptrace
+TARGETS += timers
 TARGETS += vm
 
 all:
diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
new file mode 100644
index 0000000..eb2859f
--- /dev/null
+++ b/tools/testing/selftests/timers/Makefile
@@ -0,0 +1,8 @@
+all:
+	gcc posix_timers.c -o posix_timers -lrt
+
+run_tests: all
+	./posix_timers
+
+clean:
+	rm -f ./posix_timers
diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
new file mode 100644
index 0000000..4fa655d
--- /dev/null
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -0,0 +1,221 @@
+/*
+ * Copyright (C) 2013 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Licensed under the terms of the GNU GPL License version 2
+ *
+ * Selftests for a few posix timers interface.
+ *
+ * Kernel loop code stolen from Steven Rostedt <srostedt@redhat.com>
+ */
+
+#include <sys/time.h>
+#include <stdio.h>
+#include <signal.h>
+#include <unistd.h>
+#include <time.h>
+#include <pthread.h>
+
+#define DELAY 2
+#define USECS_PER_SEC 1000000
+
+static volatile int done;
+
+/* Busy loop in userspace to elapse ITIMER_VIRTUAL */
+static void user_loop(void)
+{
+	while (!done);
+}
+
+/*
+ * Try to spend as much time as possible in kernelspace
+ * to elapse ITIMER_PROF.
+ */
+static void kernel_loop(void)
+{
+	void *addr = sbrk(0);
+
+	while (!done) {
+		brk(addr + 4096);
+		brk(addr);
+	}
+}
+
+/*
+ * Sleep until ITIMER_REAL expiration.
+ */
+static void idle_loop(void)
+{
+	pause();
+}
+
+static void sig_handler(int nr)
+{
+	done = 1;
+}
+
+/*
+ * Check the expected timer expiration matches the GTOD elapsed delta since
+ * we armed the timer. Keep a 0.5 sec error margin due to various jitter.
+ */
+static int check_diff(struct timeval start, struct timeval end)
+{
+	long long diff;
+
+	diff = end.tv_usec - start.tv_usec;
+	diff += (end.tv_sec - start.tv_sec) * USECS_PER_SEC;
+
+	if (abs(diff - DELAY * USECS_PER_SEC) > USECS_PER_SEC / 2) {
+		printf("Diff too high: %lld..", diff);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int check_itimer(int which)
+{
+	int err;
+	struct timeval start, end;
+	struct itimerval val = {
+		.it_value.tv_sec = DELAY,
+	};
+
+	printf("Check itimer ");
+
+	if (which == ITIMER_VIRTUAL)
+		printf("virtual... ");
+	else if (which == ITIMER_PROF)
+		printf("prof... ");
+	else if (which == ITIMER_REAL)
+		printf("real... ");
+
+	fflush(stdout);
+
+	done = 0;
+
+	if (which == ITIMER_VIRTUAL)
+		signal(SIGVTALRM, sig_handler);
+	else if (which == ITIMER_PROF)
+		signal(SIGPROF, sig_handler);
+	else if (which == ITIMER_REAL)
+		signal(SIGALRM, sig_handler);
+
+	err = gettimeofday(&start, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	err = setitimer(which, &val, NULL);
+	if (err < 0) {
+		perror("Can't set timer\n");
+		return -1;
+	}
+
+	if (which == ITIMER_VIRTUAL)
+		user_loop();
+	else if (which == ITIMER_PROF)
+		kernel_loop();
+	else if (which == ITIMER_REAL)
+		idle_loop();
+
+	gettimeofday(&end, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	if (!check_diff(start, end))
+		printf("[OK]\n");
+	else
+		printf("[FAIL]\n");
+
+	return 0;
+}
+
+static int check_timer_create(int which)
+{
+	int err;
+	timer_t id;
+	struct timeval start, end;
+	struct itimerspec val = {
+		.it_value.tv_sec = DELAY,
+	};
+
+	printf("Check timer_create() ");
+	if (which == CLOCK_THREAD_CPUTIME_ID) {
+		printf("per thread... ");
+	} else if (which == CLOCK_PROCESS_CPUTIME_ID) {
+		printf("per process... ");
+	}
+	fflush(stdout);
+
+	done = 0;
+	timer_create(which, NULL, &id);
+	if (err < 0) {
+		perror("Can't create timer\n");
+		return -1;
+	}
+	signal(SIGALRM, sig_handler);
+
+	err = gettimeofday(&start, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	err = timer_settime(id, 0, &val, NULL);
+	if (err < 0) {
+		perror("Can't set timer\n");
+		return -1;
+	}
+
+	user_loop();
+
+	gettimeofday(&end, NULL);
+	if (err < 0) {
+		perror("Can't call gettimeofday()\n");
+		return -1;
+	}
+
+	if (!check_diff(start, end))
+		printf("[OK]\n");
+	else
+		printf("[FAIL]\n");
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int err;
+
+	printf("Testing posix timers. False negative may happen on CPU execution \n");
+	printf("based timers if other threads run on the CPU...\n");
+
+	if (check_itimer(ITIMER_VIRTUAL) < 0)
+		return -1;
+
+	if (check_itimer(ITIMER_PROF) < 0)
+		return -1;
+
+	if (check_itimer(ITIMER_REAL) < 0)
+		return -1;
+
+	if (check_timer_create(CLOCK_THREAD_CPUTIME_ID) < 0)
+		return -1;
+
+	/*
+	 * It's unfortunately hard to reliably test a timer expiration
+	 * on parallel multithread cputime. We could arm it to expire
+	 * on DELAY * nr_threads, with nr_threads busy looping, then wait
+	 * the normal DELAY since the time is elapsing nr_threads faster.
+	 * But for that we need to ensure we have real physical free CPUs
+	 * to ensure true parallelism. So test only one thread until we
+	 * find a better solution.
+	 */
+	if (check_timer_create(CLOCK_PROCESS_CPUTIME_ID) < 0)
+		return -1;
+
+	return 0;
+}

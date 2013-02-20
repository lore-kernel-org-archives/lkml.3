Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab3BTPTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:19:46 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:60960 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935325Ab3BTPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:19:43 -0500
From: Clark Williams <clark.williams@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <clark.williams@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] sched: move clock definitions from sched.h to new file
Date: Wed, 20 Feb 2013 09:19:10 -0600
Message-Id: <1361373550-4011-3-git-send-email-clark.williams@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
References: <1361373550-4011-1-git-send-email-clark.williams@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the various scheduler clock definitions out of include/linux/sched.h
into a new file include/linux/sched/clock.h.

Signed-off-by: Clark Williams <clark.williams@gmail.com>
---
 arch/arm/kernel/sched_clock.c |  2 +-
 arch/x86/kernel/cpu/amd.c     |  2 +-
 arch/x86/kernel/cpu/intel.c   |  2 +-
 arch/x86/kernel/tsc.c         |  2 +-
 drivers/acpi/apei/ghes.c      |  1 +
 drivers/acpi/processor_idle.c |  2 +-
 fs/bio-integrity.c            |  1 +
 include/linux/blkdev.h        |  2 +-
 include/linux/ftrace.h        |  2 +-
 include/linux/sched.h         | 61 -------------------------------------------
 init/do_mounts.c              |  2 +-
 init/do_mounts_initrd.c       |  2 +-
 init/main.c                   |  2 +-
 kernel/events/core.c          |  1 +
 kernel/lockdep.c              |  2 +-
 kernel/printk.c               |  1 +
 kernel/rcutorture.c           |  2 +-
 kernel/sched/sched.h          |  1 +
 kernel/time/tick-sched.c      |  2 +-
 kernel/trace/ring_buffer.c    |  1 +
 kernel/trace/trace_clock.c    |  2 +-
 kernel/watchdog.c             |  1 +
 lib/plist.c                   |  2 +-
 23 files changed, 22 insertions(+), 76 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index fc6692e..8e6f986 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -10,7 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/syscore_ops.h>
 #include <linux/timer.h>
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e3b01e5..f4838e9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -5,7 +5,7 @@
 #include <linux/mm.h>
 
 #include <linux/io.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1905ce9..e7fc935 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -4,7 +4,7 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/smp.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/thread_info.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 4b9ea10..9a72176 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1,7 +1,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 7ae2750..eec858d 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -48,6 +48,7 @@
 #include <linux/genalloc.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/sched/clock.h>
 #include <acpi/apei.h>
 #include <acpi/hed.h>
 #include <asm/mce.h>
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index ed9a1cc..f68208a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -36,7 +36,7 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/moduleparam.h>
-#include <linux/sched.h>	/* need_resched() */
+#include <linux/sched/clock.h>
 #include <linux/pm_qos.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index a3f28f3..090b64d 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -26,6 +26,7 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/sched/clock.h>
 
 struct integrity_slab {
 	struct kmem_cache *slab;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94bc83..89f9b7d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_BLKDEV_H
 #define _LINUX_BLKDEV_H
 
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 
 #ifdef CONFIG_BLOCK
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e5ca8ef..625c2c2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -12,7 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/ptrace.h>
 #include <linux/ktime.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/fs.h>
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33cc421..54624e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1926,64 +1926,6 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 }
 #endif
 
-/*
- * Do not use outside of architecture code which knows its limitations.
- *
- * sched_clock() has no promise of monotonicity or bounded drift between
- * CPUs, use (which you should not) requires disabling IRQs.
- *
- * Please use one of the three interfaces below.
- */
-extern unsigned long long notrace sched_clock(void);
-/*
- * See the comment in kernel/sched/clock.c
- */
-extern u64 cpu_clock(int cpu);
-extern u64 local_clock(void);
-extern u64 sched_clock_cpu(int cpu);
-
-
-extern void sched_clock_init(void);
-
-#ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-static inline void sched_clock_tick(void)
-{
-}
-
-static inline void sched_clock_idle_sleep_event(void)
-{
-}
-
-static inline void sched_clock_idle_wakeup_event(u64 delta_ns)
-{
-}
-#else
-/*
- * Architectures can set this to 1 if they have specified
- * CONFIG_HAVE_UNSTABLE_SCHED_CLOCK in their arch Kconfig,
- * but then during bootup it turns out that sched_clock()
- * is reliable after all:
- */
-extern int sched_clock_stable;
-
-extern void sched_clock_tick(void);
-extern void sched_clock_idle_sleep_event(void);
-extern void sched_clock_idle_wakeup_event(u64 delta_ns);
-#endif
-
-#ifdef CONFIG_IRQ_TIME_ACCOUNTING
-/*
- * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
- * The reason for this explicit opt-in is not to have perf penalty with
- * slow sched_clocks.
- */
-extern void enable_sched_clock_irqtime(void);
-extern void disable_sched_clock_irqtime(void);
-#else
-static inline void enable_sched_clock_irqtime(void) {}
-static inline void disable_sched_clock_irqtime(void) {}
-#endif
-
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 
@@ -1994,9 +1936,6 @@ extern void sched_exec(void);
 #define sched_exec()   {}
 #endif
 
-extern void sched_clock_idle_sleep_event(void);
-extern void sched_clock_idle_wakeup_event(u64 delta_ns);
-
 #ifdef CONFIG_HOTPLUG_CPU
 extern void idle_task_exit(void);
 #else
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 1d1b634..e50ec77 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -9,7 +9,7 @@
 #endif
 
 #include <linux/module.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/ctype.h>
 #include <linux/fd.h>
 #include <linux/tty.h>
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index f9acf71..5e081f2 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -14,7 +14,7 @@
 #include <linux/minix_fs.h>
 #include <linux/romfs_fs.h>
 #include <linux/initrd.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/freezer.h>
 #include <linux/kmod.h>
 
diff --git a/init/main.c b/init/main.c
index cee4b5c..a3129b1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -57,7 +57,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
 #include <linux/kgdb.h>
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5c75791..0b2ef1c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -37,6 +37,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
+#include <linux/sched/clock.h>
 
 #include "internal.h"
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8a0efac..9e939ba 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -27,7 +27,7 @@
  */
 #define DISABLE_BRANCH_PROFILING
 #include <linux/mutex.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
diff --git a/kernel/printk.c b/kernel/printk.c
index 2c1ccb5..2929bfc 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -43,6 +43,7 @@
 #include <linux/rculist.h>
 #include <linux/poll.h>
 #include <linux/irq_work.h>
+#include <linux/sched/clock.h>
 
 #include <asm/uaccess.h>
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index e1f3a8c..424796d 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -32,7 +32,7 @@
 #include <linux/smp.h>
 #include <linux/rcupdate.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/completion.h>
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..855ea5d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/clock.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 314b9ee..fc52f04 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -18,7 +18,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7244acd..03f006c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/cpu.h>
 #include <linux/fs.h>
+#include <linux/sched/clock.h>
 
 #include <asm/local.h>
 
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index aa8f5f4..ac7b6a6 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -17,7 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/ktime.h>
 #include <linux/trace_clock.h>
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4a94467..997cc573 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -24,6 +24,7 @@
 #include <linux/sysctl.h>
 #include <linux/smpboot.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/clock.h>
 
 #include <asm/irq_regs.h>
 #include <linux/kvm_para.h>
diff --git a/lib/plist.c b/lib/plist.c
index 1ebc95f..619910c 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -135,7 +135,7 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 }
 
 #ifdef CONFIG_DEBUG_PI_LIST
-#include <linux/sched.h>
+#include <linux/sched/clock.h>
 #include <linux/module.h>
 #include <linux/init.h>
 
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaBIHYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:24:40 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45948 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaBIHYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:24:38 -0500
From: Gideon Israel Dsouza <gidisrael@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: [PATCH 1/1] kernel: Used macros from compiler.h instead of __attribute__((...))
Date: Sun,  9 Feb 2014 12:54:21 +0530
Message-Id: <1391930661-19611-1-git-send-email-gidisrael@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs. Eg: __weak
for __attribute__((weak)). I've replaced all instances of gcc
attributes with the right macro in the kernel subsystem.

Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
---
 kernel/fork.c             |  3 ++-
 kernel/kallsyms.c         | 11 ++++++-----
 kernel/kexec.c            |  5 +++--
 kernel/ksysfs.c           |  5 +++--
 kernel/power/power.h      |  3 ++-
 kernel/power/snapshot.c   |  3 ++-
 kernel/power/suspend.c    |  5 +++--
 kernel/power/swap.c       |  2 +-
 kernel/sched/clock.c      |  3 ++-
 kernel/sched/core.c       |  3 ++-
 kernel/signal.c           |  4 +++-
 kernel/time/timekeeping.c |  5 +++--
 kernel/trace/trace.h      |  3 ++-
 13 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..ef29ed7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -71,6 +71,7 @@
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
 #include <linux/aio.h>
+#include <linux/compiler.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -283,7 +284,7 @@ void __init fork_init(unsigned long mempages)
 		init_task.signal->rlim[RLIMIT_NPROC];
 }
 
-int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
+int __weak arch_dup_task_struct(struct task_struct *dst,
 					       struct task_struct *src)
 {
 	*dst = *src;
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3127ad5..cb0cf37 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/compiler.h>
 
 #include <asm/sections.h>
 
@@ -36,8 +37,8 @@
  * These will be re-linked against their real values
  * during the second link stage.
  */
-extern const unsigned long kallsyms_addresses[] __attribute__((weak));
-extern const u8 kallsyms_names[] __attribute__((weak));
+extern const unsigned long kallsyms_addresses[] __weak;
+extern const u8 kallsyms_names[] __weak;
 
 /*
  * Tell the compiler that the count isn't in the small data section if the arch
@@ -46,10 +47,10 @@ extern const u8 kallsyms_names[] __attribute__((weak));
 extern const unsigned long kallsyms_num_syms
 __attribute__((weak, section(".rodata")));
 
-extern const u8 kallsyms_token_table[] __attribute__((weak));
-extern const u16 kallsyms_token_index[] __attribute__((weak));
+extern const u8 kallsyms_token_table[] __weak;
+extern const u16 kallsyms_token_index[] __weak;
 
-extern const unsigned long kallsyms_markers[] __attribute__((weak));
+extern const unsigned long kallsyms_markers[] __weak;
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 60bafbe..57c3725 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,6 +32,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <linux/compiler.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1551,10 +1552,10 @@ void vmcoreinfo_append_str(const char *fmt, ...)
  * provide an empty default implementation here -- architecture
  * code may override this
  */
-void __attribute__ ((weak)) arch_crash_save_vmcoreinfo(void)
+void __weak arch_crash_save_vmcoreinfo(void)
 {}
 
-unsigned long __attribute__ ((weak)) paddr_vmcoreinfo_note(void)
+unsigned long __weak paddr_vmcoreinfo_note(void)
 {
 	return __pa((unsigned long)(char *)&vmcoreinfo_note);
 }
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index d945a94..01f3486 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -18,6 +18,7 @@
 #include <linux/stat.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
+#include <linux/compiler.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
@@ -160,8 +161,8 @@ KERNEL_ATTR_RW(rcu_expedited);
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
-extern const void __start_notes __attribute__((weak));
-extern const void __stop_notes __attribute__((weak));
+extern const void __start_notes __weak;
+extern const void __stop_notes __weak;
 #define	notes_size (&__stop_notes - &__start_notes)
 
 static ssize_t notes_read(struct file *filp, struct kobject *kobj,
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 7d4b7ff..5e158da 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -2,6 +2,7 @@
 #include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
 #include <linux/freezer.h>
+#include <linux/compiler.h>
 
 struct swsusp_info {
 	struct new_utsname	uts;
@@ -11,7 +12,7 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
-} __attribute__((aligned(PAGE_SIZE)));
+} __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d9f61a1..b91b66a 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -27,6 +27,7 @@
 #include <linux/highmem.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/compiler.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -155,7 +156,7 @@ static inline void free_image_page(void *addr, int clear_nosave_free)
 struct linked_page {
 	struct linked_page *next;
 	char data[LINKED_PAGE_DATA_SIZE];
-} __attribute__((packed));
+} __packed;
 
 static inline void
 free_list_of_pages(struct linked_page *list, int clear_page_nosave)
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 62ee437..d961190 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -26,6 +26,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/ftrace.h>
 #include <trace/events/power.h>
+#include <linux/compiler.h>
 
 #include "power.h"
 
@@ -156,13 +157,13 @@ static int suspend_prepare(suspend_state_t state)
 }
 
 /* default implementation */
-void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
+void __weak arch_suspend_disable_irqs(void)
 {
 	local_irq_disable();
 }
 
 /* default implementation */
-void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
+void __weak arch_suspend_enable_irqs(void)
 {
 	local_irq_enable();
 }
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 7c33ed2..8c9a481 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -101,7 +101,7 @@ struct swsusp_header {
 	unsigned int flags;	/* Flags to pass to the "boot" kernel */
 	char	orig_sig[10];
 	char	sig[10];
-} __attribute__((packed));
+} __packed;
 
 static struct swsusp_header *swsusp_header;
 
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 43c2bcc..d75cbd22 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -60,13 +60,14 @@
 #include <linux/sched.h>
 #include <linux/static_key.h>
 #include <linux/workqueue.h>
+#include <linux/compiler.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
  * This is default implementation.
  * Architectures and sub-architectures can override this.
  */
-unsigned long long __attribute__((weak)) sched_clock(void)
+unsigned long long __weak sched_clock(void)
 {
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..1af0218 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -73,6 +73,7 @@
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
 #include <linux/context_tracking.h>
+#include <linux/compiler.h>
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
@@ -6451,7 +6452,7 @@ static cpumask_var_t fallback_doms;
  * cpu core maps. It is supposed to return 1 if the topology changed
  * or 0 if it stayed the same.
  */
-int __attribute__((weak)) arch_update_cpu_topology(void)
+int __weak arch_update_cpu_topology(void)
 {
 	return 0;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index 52f881d..ed3e35b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -33,6 +33,8 @@
 #include <linux/uprobes.h>
 #include <linux/compat.h>
 #include <linux/cn_proc.h>
+#include <linux/compiler.h>
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
 
@@ -3618,7 +3620,7 @@ SYSCALL_DEFINE3(sigsuspend, int, unused1, int, unused2, old_sigset_t, mask)
 }
 #endif
 
-__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma)
+__weak const char *arch_vma_name(struct vm_area_struct *vma)
 {
 	return NULL;
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 0aa4ce8..8c367e1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -22,6 +22,7 @@
 #include <linux/tick.h>
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
+#include <linux/compiler.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
@@ -760,7 +761,7 @@ u64 timekeeping_max_deferment(void)
  *
  *  XXX - Do be sure to remove it once all arches implement it.
  */
-void __attribute__((weak)) read_persistent_clock(struct timespec *ts)
+void __weak read_persistent_clock(struct timespec *ts)
 {
 	ts->tv_sec = 0;
 	ts->tv_nsec = 0;
@@ -775,7 +776,7 @@ void __attribute__((weak)) read_persistent_clock(struct timespec *ts)
  *
  *  XXX - Do be sure to remove it once all arches implement it.
  */
-void __attribute__((weak)) read_boot_clock(struct timespec *ts)
+void __weak read_boot_clock(struct timespec *ts)
 {
 	ts->tv_sec = 0;
 	ts->tv_nsec = 0;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 02b592f..326501f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -13,6 +13,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
+#include <linux/compiler.h>
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
@@ -1249,7 +1250,7 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled);
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
 	extern struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_##call;
+	__aligned(4) event_##call;
 #undef FTRACE_ENTRY_DUP
 #define FTRACE_ENTRY_DUP(call, struct_name, id, tstruct, print, filter)	\
 	FTRACE_ENTRY(call, struct_name, id, PARAMS(tstruct), PARAMS(print), \
-- 
1.8.4.2


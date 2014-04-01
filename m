Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaDAVlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:41:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:63065 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaDAVlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:41:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,775,1389772800"; 
   d="scan'208";a="512182605"
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] asmlinkage: Add explicit __visible to drivers/*, lib/*, kernel/*
Date: Tue,  1 Apr 2014 23:40:12 +0200
Message-Id: <1396388412-22573-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1396388412-22573-1-git-send-email-andi@firstfloor.org>
References: <1396388412-22573-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

As requested by Linus add explicit __visible to the asmlinkage users.
This marks functions visible to assembler.

Tree sweep for rest of tree.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/pnp/pnpbios/bioscalls.c |  2 +-
 init/main.c                     |  2 +-
 kernel/context_tracking.c       |  2 +-
 kernel/locking/lockdep.c        |  2 +-
 kernel/power/snapshot.c         |  2 +-
 kernel/printk/printk.c          |  4 ++--
 kernel/sched/core.c             | 10 +++++-----
 kernel/softirq.c                |  4 ++--
 lib/dump_stack.c                |  4 ++--
 9 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index deb7f4b..438d4c7 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -37,7 +37,7 @@ __visible struct {
  * kernel begins at offset 3GB...
  */
 
-asmlinkage void pnp_bios_callfunc(void);
+asmlinkage __visible void pnp_bios_callfunc(void);
 
 __asm__(".text			\n"
 	__ALIGN_STR "\n"
diff --git a/init/main.c b/init/main.c
index 9c7fd4c..48655ce 100644
--- a/init/main.c
+++ b/init/main.c
@@ -476,7 +476,7 @@ static void __init mm_init(void)
 	vmalloc_init();
 }
 
-asmlinkage void __init start_kernel(void)
+asmlinkage __visible void __init start_kernel(void)
 {
 	char * command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 6cb20d2..019d450 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -120,7 +120,7 @@ void context_tracking_user_enter(void)
  * instead of preempt_schedule() to exit user context if needed before
  * calling the scheduler.
  */
-asmlinkage void __sched notrace preempt_schedule_context(void)
+asmlinkage __visible void __sched notrace preempt_schedule_context(void)
 {
 	enum ctx_state prev_ctx;
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index b0e9467..d24e433 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -4188,7 +4188,7 @@ void debug_show_held_locks(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
-asmlinkage void lockdep_sys_exit(void)
+asmlinkage __visible void lockdep_sys_exit(void)
 {
 	struct task_struct *curr = current;
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d9f61a1..7567b0d 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1585,7 +1585,7 @@ swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 	return -ENOMEM;
 }
 
-asmlinkage int swsusp_save(void)
+asmlinkage __visible int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 4dae9cb..17a73b4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1671,7 +1671,7 @@ EXPORT_SYMBOL(printk_emit);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-asmlinkage int printk(const char *fmt, ...)
+asmlinkage __visible int printk(const char *fmt, ...)
 {
 	va_list args;
 	int r;
@@ -1734,7 +1734,7 @@ void early_vprintk(const char *fmt, va_list ap)
 	}
 }
 
-asmlinkage void early_printk(const char *fmt, ...)
+asmlinkage __visible void early_printk(const char *fmt, ...)
 {
 	va_list ap;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a47902c..82eee7f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2194,7 +2194,7 @@ static inline void post_schedule(struct rq *rq)
  * schedule_tail - first thing a freshly forked thread must call.
  * @prev: the thread we just switched away from.
  */
-asmlinkage void schedule_tail(struct task_struct *prev)
+asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct rq *rq = this_rq();
@@ -2743,7 +2743,7 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
-asmlinkage void __sched schedule(void)
+asmlinkage __visible void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 
@@ -2753,7 +2753,7 @@ asmlinkage void __sched schedule(void)
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_CONTEXT_TRACKING
-asmlinkage void __sched schedule_user(void)
+asmlinkage __visible void __sched schedule_user(void)
 {
 	/*
 	 * If we come here after a random call to set_need_resched(),
@@ -2785,7 +2785,7 @@ void __sched schedule_preempt_disabled(void)
  * off of preempt_enable. Kernel preemptions off return from interrupt
  * occur there and call schedule directly.
  */
-asmlinkage void __sched notrace preempt_schedule(void)
+asmlinkage __visible void __sched notrace preempt_schedule(void)
 {
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
@@ -2815,7 +2815,7 @@ EXPORT_SYMBOL(preempt_schedule);
  * Note, that this is called and return with irqs disabled. This will
  * protect us against recursive calling from irq.
  */
-asmlinkage void __sched preempt_schedule_irq(void)
+asmlinkage __visible void __sched preempt_schedule_irq(void)
 {
 	enum ctx_state prev_state;
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 490fcbb..6761973 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -222,7 +222,7 @@ static inline bool lockdep_softirq_start(void) { return false; }
 static inline void lockdep_softirq_end(bool in_hardirq) { }
 #endif
 
-asmlinkage void __do_softirq(void)
+asmlinkage __visible void __do_softirq(void)
 {
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	unsigned long old_flags = current->flags;
@@ -298,7 +298,7 @@ restart:
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-asmlinkage void do_softirq(void)
+asmlinkage __visible void do_softirq(void)
 {
 	__u32 pending;
 	unsigned long flags;
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index f23b63f..6745c62 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -23,7 +23,7 @@ static void __dump_stack(void)
 #ifdef CONFIG_SMP
 static atomic_t dump_lock = ATOMIC_INIT(-1);
 
-asmlinkage void dump_stack(void)
+asmlinkage __visible void dump_stack(void)
 {
 	int was_locked;
 	int old;
@@ -55,7 +55,7 @@ retry:
 	preempt_enable();
 }
 #else
-asmlinkage void dump_stack(void)
+asmlinkage __visible void dump_stack(void)
 {
 	__dump_stack();
 }
-- 
1.8.5.2


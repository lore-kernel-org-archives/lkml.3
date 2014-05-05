Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbaEEXNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:13:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbaEEXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:13:05 -0400
Date: Mon, 5 May 2014 16:12:54 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-722a9f9299ca720a3f14660e7c0dce7b76a9cb42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1398984278-29319-4-git-send-email-andi@firstfloor.org>
References: <1398984278-29319-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] asmlinkage: Add explicit __visible to drivers/*,
  lib/*, kernel/*
Git-Commit-ID: 722a9f9299ca720a3f14660e7c0dce7b76a9cb42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  722a9f9299ca720a3f14660e7c0dce7b76a9cb42
Gitweb:     http://git.kernel.org/tip/722a9f9299ca720a3f14660e7c0dce7b76a9cb42
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 2 May 2014 00:44:38 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 May 2014 16:07:46 -0700

asmlinkage: Add explicit __visible to drivers/*, lib/*, kernel/*

As requested by Linus add explicit __visible to the asmlinkage users.
This marks functions visible to assembler.

Tree sweep for rest of tree.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1398984278-29319-4-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 18fb7a2..1ea328a 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1586,7 +1586,7 @@ swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 	return -ENOMEM;
 }
 
-asmlinkage int swsusp_save(void)
+asmlinkage __visible int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a45b509..7228258 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1674,7 +1674,7 @@ EXPORT_SYMBOL(printk_emit);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-asmlinkage int printk(const char *fmt, ...)
+asmlinkage __visible int printk(const char *fmt, ...)
 {
 	va_list args;
 	int r;
@@ -1737,7 +1737,7 @@ void early_vprintk(const char *fmt, va_list ap)
 	}
 }
 
-asmlinkage void early_printk(const char *fmt, ...)
+asmlinkage __visible void early_printk(const char *fmt, ...)
 {
 	va_list ap;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..d9d8ece 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2192,7 +2192,7 @@ static inline void post_schedule(struct rq *rq)
  * schedule_tail - first thing a freshly forked thread must call.
  * @prev: the thread we just switched away from.
  */
-asmlinkage void schedule_tail(struct task_struct *prev)
+asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct rq *rq = this_rq();
@@ -2741,7 +2741,7 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
-asmlinkage void __sched schedule(void)
+asmlinkage __visible void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 
@@ -2751,7 +2751,7 @@ asmlinkage void __sched schedule(void)
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_CONTEXT_TRACKING
-asmlinkage void __sched schedule_user(void)
+asmlinkage __visible void __sched schedule_user(void)
 {
 	/*
 	 * If we come here after a random call to set_need_resched(),
@@ -2783,7 +2783,7 @@ void __sched schedule_preempt_disabled(void)
  * off of preempt_enable. Kernel preemptions off return from interrupt
  * occur there and call schedule directly.
  */
-asmlinkage void __sched notrace preempt_schedule(void)
+asmlinkage __visible void __sched notrace preempt_schedule(void)
 {
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
@@ -2813,7 +2813,7 @@ EXPORT_SYMBOL(preempt_schedule);
  * Note, that this is called and return with irqs disabled. This will
  * protect us against recursive calling from irq.
  */
-asmlinkage void __sched preempt_schedule_irq(void)
+asmlinkage __visible void __sched preempt_schedule_irq(void)
 {
 	enum ctx_state prev_state;
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 33e4648..92f24f5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -223,7 +223,7 @@ static inline bool lockdep_softirq_start(void) { return false; }
 static inline void lockdep_softirq_end(bool in_hardirq) { }
 #endif
 
-asmlinkage void __do_softirq(void)
+asmlinkage __visible void __do_softirq(void)
 {
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	unsigned long old_flags = current->flags;
@@ -299,7 +299,7 @@ restart:
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

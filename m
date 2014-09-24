Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaIXO6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:58:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaIXO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:58:03 -0400
Date: Wed, 24 Sep 2014 07:56:36 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c55f5158f5606f8a62e694b7e009f59b92ac6258@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tony.luck@intel.com, ralf@linux-mips.org, akpm@linux-foundation.org,
        tglx@linutronix.de, davidlohr@hp.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, james.hogan@imgtec.com,
        qais.yousef@imgtec.com, keescook@chromium.org, paul.burton@imgtec.com,
        fenghua.yu@intel.com, tkhai@yandex.ru
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tony.luck@intel.com, ralf@linux-mips.org,
        akpm@linux-foundation.org, tglx@linutronix.de, davidlohr@hp.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, james.hogan@imgtec.com,
        qais.yousef@imgtec.com, keescook@chromium.org, paul.burton@imgtec.com,
        fenghua.yu@intel.com, tkhai@yandex.ru
In-Reply-To: <20140923150641.GH3312@worktop.programming.kicks-ass.net>
References: <20140923150641.GH3312@worktop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, mips, ia64:
  Remove __ARCH_WANT_UNLOCKED_CTXSW
Git-Commit-ID: c55f5158f5606f8a62e694b7e009f59b92ac6258
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

Commit-ID:  c55f5158f5606f8a62e694b7e009f59b92ac6258
Gitweb:     http://git.kernel.org/tip/c55f5158f5606f8a62e694b7e009f59b92ac6258
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 23 Sep 2014 17:06:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:47:05 +0200

sched, mips, ia64: Remove __ARCH_WANT_UNLOCKED_CTXSW

Kirill found that there's a subtle race in the
__ARCH_WANT_UNLOCKED_CTXSW code, and instead of fixing it, remove the
entire exception because neither arch that uses it seems to actually
still require it.

Boot tested on mips64el (qemu) only.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kirill Tkhai <tkhai@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Qais Yousef <qais.yousef@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: oleg@redhat.com
Cc: linux@roeck-us.net
Cc: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20140923150641.GH3312@worktop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/ia64/include/asm/processor.h |  1 -
 arch/mips/include/asm/processor.h |  6 ------
 kernel/sched/core.c               |  6 ------
 kernel/sched/sched.h              | 30 ------------------------------
 4 files changed, 43 deletions(-)

diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index c736713..ce53c50 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -19,7 +19,6 @@
 #include <asm/ptrace.h>
 #include <asm/ustack.h>
 
-#define __ARCH_WANT_UNLOCKED_CTXSW
 #define ARCH_HAS_PREFETCH_SWITCH_STACK
 
 #define IA64_NUM_PHYS_STACK_REG	96
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 05f0843..f1df4cb 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -397,12 +397,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define ARCH_HAS_PREFETCHW
 #define prefetchw(x) __builtin_prefetch((x), 1, 1)
 
-/*
- * See Documentation/scheduler/sched-arch.txt; prevents deadlock on SMP
- * systems.
- */
-#define __ARCH_WANT_UNLOCKED_CTXSW
-
 #endif
 
 #endif /* _ASM_PROCESSOR_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d65566d..5b0eac9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2331,10 +2331,6 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	 */
 	post_schedule(rq);
 
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
-	/* In this case, finish_task_switch does not reenable preemption */
-	preempt_enable();
-#endif
 	if (current->set_child_tid)
 		put_user(task_pid_vnr(current), current->set_child_tid);
 }
@@ -2377,9 +2373,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * of the scheduler it's an obvious special-case), so we
 	 * do an early lockdep release here:
 	 */
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
-#endif
 
 	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 16e1ca9..6130251 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -975,7 +975,6 @@ static inline int task_on_rq_migrating(struct task_struct *p)
 # define finish_arch_post_lock_switch()	do { } while (0)
 #endif
 
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
 #ifdef CONFIG_SMP
@@ -1013,35 +1012,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	raw_spin_unlock_irq(&rq->lock);
 }
 
-#else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * We can optimise this out completely for !SMP, because the
-	 * SMP rebalancing from interrupt is the only thing that cares
-	 * here.
-	 */
-	next->on_cpu = 1;
-#endif
-	raw_spin_unlock(&rq->lock);
-}
-
-static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
-{
-#ifdef CONFIG_SMP
-	/*
-	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
-	 * We must ensure this doesn't happen until the switch is completely
-	 * finished.
-	 */
-	smp_wmb();
-	prev->on_cpu = 0;
-#endif
-	local_irq_enable();
-}
-#endif /* __ARCH_WANT_UNLOCKED_CTXSW */
-
 /*
  * wake flags
  */

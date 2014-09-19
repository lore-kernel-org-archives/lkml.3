Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaISLx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:53:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaISLxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:53:23 -0400
Date: Fri, 19 Sep 2014 04:46:27 -0700
From: tip-bot for Aaron Tomlin <tipbot@zytor.com>
Message-ID: <tip-d4311ff1a8da48d609db9500f121c15580dfeeb7@git.kernel.org>
Cc: mingo@kernel.org, rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        seiji.aguchi@hds.com, mpe@ellerman.id.au, fabf@skynet.be,
        atomlin@redhat.com, jolsa@redhat.com, riel@redhat.com,
        rostedt@goodmis.org, michael.opdenacker@free-electrons.com,
        akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        tglx@linutronix.de, oleg@redhat.com, vdavydov@parallels.com,
        rientjes@google.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, daeseok.youn@gmail.com, masami.hiramatsu.pt@hitachi.com,
        athorlton@sgi.com, benh@kernel.crashing.org, geert@linux-m68k.org,
        keescook@chromium.org, prarit@redhat.com
Reply-To: mingo@kernel.org, kirill.shutemov@linux.intel.com,
        torvalds@linux-foundation.org, rusty@rustcorp.com.au,
        peterz@infradead.org, mpe@ellerman.id.au, seiji.aguchi@hds.com,
        atomlin@redhat.com, fabf@skynet.be, jolsa@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org, michael.opdenacker@free-electrons.com,
        rostedt@goodmis.org, isimatu.yasuaki@jp.fujitsu.com, oleg@redhat.com,
        tglx@linutronix.de, rientjes@google.com, vdavydov@parallels.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        daeseok.youn@gmail.com, keescook@chromium.org, geert@linux-m68k.org,
        benh@kernel.crashing.org, athorlton@sgi.com,
        masami.hiramatsu.pt@hitachi.com, prarit@redhat.com
In-Reply-To: <1410527779-8133-2-git-send-email-atomlin@redhat.com>
References: <1410527779-8133-2-git-send-email-atomlin@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] init/main.c: Give init_task a canary
Git-Commit-ID: d4311ff1a8da48d609db9500f121c15580dfeeb7
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

Commit-ID:  d4311ff1a8da48d609db9500f121c15580dfeeb7
Gitweb:     http://git.kernel.org/tip/d4311ff1a8da48d609db9500f121c15580dfeeb7
Author:     Aaron Tomlin <atomlin@redhat.com>
AuthorDate: Fri, 12 Sep 2014 14:16:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:22 +0200

init/main.c: Give init_task a canary

Tasks get their end of stack set to STACK_END_MAGIC with the
aim to catch stack overruns. Currently this feature does not
apply to init_task. This patch removes this restriction.

Note that a similar patch was posted by Prarit Bhargava
some time ago but was never merged:

  http://marc.info/?l=linux-kernel&m=127144305403241&w=2

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: aneesh.kumar@linux.vnet.ibm.com
Cc: dzickus@redhat.com
Cc: bmr@redhat.com
Cc: jcastillo@redhat.com
Cc: jgh@redhat.com
Cc: minchan@kernel.org
Cc: tglx@linutronix.de
Cc: hannes@cmpxchg.org
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1410527779-8133-2-git-send-email-atomlin@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/mm/fault.c    |  3 +--
 arch/x86/mm/fault.c        |  3 +--
 include/linux/sched.h      |  2 ++
 init/main.c                |  1 +
 kernel/fork.c              | 12 +++++++++---
 kernel/trace/trace_stack.c |  4 +---
 6 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 51ab9e7..35d0760c 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -30,7 +30,6 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/perf_event.h>
-#include <linux/magic.h>
 #include <linux/ratelimit.h>
 #include <linux/context_tracking.h>
 
@@ -538,7 +537,7 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 		regs->nip);
 
 	stackend = end_of_stack(current);
-	if (current != &init_task && *stackend != STACK_END_MAGIC)
+	if (*stackend != STACK_END_MAGIC)
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	die("Kernel access of bad area", regs, sig);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a241946..bc23a70 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -3,7 +3,6 @@
  *  Copyright (C) 2001, 2002 Andi Kleen, SuSE Labs.
  *  Copyright (C) 2008-2009, Red Hat Inc., Ingo Molnar
  */
-#include <linux/magic.h>		/* STACK_END_MAGIC		*/
 #include <linux/sched.h>		/* test_thread_flag(), ...	*/
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/module.h>		/* search_exception_table	*/
@@ -710,7 +709,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	show_fault_oops(regs, error_code, address);
 
 	stackend = end_of_stack(tsk);
-	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
+	if (*stackend != STACK_END_MAGIC)
 		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 82ff3d6..118dca7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -57,6 +57,7 @@ struct sched_param {
 #include <linux/llist.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/magic.h>
 
 #include <asm/processor.h>
 
@@ -2638,6 +2639,7 @@ static inline unsigned long stack_not_used(struct task_struct *p)
 	return (unsigned long)n - (unsigned long)end_of_stack(p);
 }
 #endif
+extern void set_task_stack_end_magic(struct task_struct *tsk);
 
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available
diff --git a/init/main.c b/init/main.c
index bb1aed9..5fc3fc7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -508,6 +508,7 @@ asmlinkage __visible void __init start_kernel(void)
 	 * lockdep hash:
 	 */
 	lockdep_init();
+	set_task_stack_end_magic(&init_task);
 	smp_setup_processor_id();
 	debug_objects_early_init();
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 9387ae8..ad64248 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -294,11 +294,18 @@ int __weak arch_dup_task_struct(struct task_struct *dst,
 	return 0;
 }
 
+void set_task_stack_end_magic(struct task_struct *tsk)
+{
+	unsigned long *stackend;
+
+	stackend = end_of_stack(tsk);
+	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+}
+
 static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
-	unsigned long *stackend;
 	int node = tsk_fork_get_node(orig);
 	int err;
 
@@ -328,8 +335,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
-	stackend = end_of_stack(tsk);
-	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 8a4e5cb..1636e41 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -13,7 +13,6 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/magic.h>
 
 #include <asm/setup.h>
 
@@ -171,8 +170,7 @@ check_stack(unsigned long ip, unsigned long *stack)
 			i++;
 	}
 
-	if ((current != &init_task &&
-		*(end_of_stack(current)) != STACK_END_MAGIC)) {
+	if (*end_of_stack(current) != STACK_END_MAGIC) {
 		print_max_stack();
 		BUG();
 	}

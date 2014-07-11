Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaGKVug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:50:36 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54279 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaGKVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:50:34 -0400
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: [PATCH] kernel:exit :fix coding style warnings and errors.
Date: Sat, 12 Jul 2014 00:51:49 +0300
Message-Id: <1405115509-13908-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style warnings and errors.

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
---
 kernel/exit.c |   49 ++++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index e5c4668..20a9c10 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -59,7 +59,7 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-static void exit_mm(struct task_struct * tsk);
+static void exit_mm(struct task_struct *tsk);
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
@@ -151,7 +151,7 @@ static void __exit_signal(struct task_struct *tsk)
 	spin_unlock(&sighand->siglock);
 
 	__cleanup_sighand(sighand);
-	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
+	clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	if (group_dead) {
 		flush_sigqueue(&sig->shared_pending);
 		tty_kref_put(tty);
@@ -168,7 +168,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 }
 
 
-void release_task(struct task_struct * p)
+void release_task(struct task_struct *p)
 {
 	struct task_struct *leader;
 	int zap_leader;
@@ -192,7 +192,8 @@ repeat:
 	 */
 	zap_leader = 0;
 	leader = p->group_leader;
-	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
+	if (leader != p && thread_group_empty(leader)
+			&& leader->exit_state == EXIT_ZOMBIE) {
 		/*
 		 * If we were the last child thread and the leader has
 		 * exited already, and the leader's parent ignores SIGCHLD,
@@ -241,7 +242,8 @@ struct pid *session_of_pgrp(struct pid *pgrp)
  *
  * "I ask you, have you ever known what it is to be an orphan?"
  */
-static int will_become_orphaned_pgrp(struct pid *pgrp, struct task_struct *ignored_task)
+static int will_become_orphaned_pgrp(struct pid *pgrp,
+					struct task_struct *ignored_task)
 {
 	struct task_struct *p;
 
@@ -294,9 +296,9 @@ kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
 	struct task_struct *ignored_task = tsk;
 
 	if (!parent)
-		 /* exit: our father is in a different pgrp than
-		  * we are and we were the only connection outside.
-		  */
+		/* exit: our father is in a different pgrp than
+		 * we are and we were the only connection outside.
+		 */
 		parent = tsk->real_parent;
 	else
 		/* reparent: our child is in a different pgrp than
@@ -405,7 +407,7 @@ assign_new_owner:
  * Turn us into a lazy TLB process if we
  * aren't already..
  */
-static void exit_mm(struct task_struct * tsk)
+static void exit_mm(struct task_struct *tsk)
 {
 	struct mm_struct *mm = tsk->mm;
 	struct core_state *core_state;
@@ -425,6 +427,7 @@ static void exit_mm(struct task_struct * tsk)
 	core_state = mm->core_state;
 	if (core_state) {
 		struct core_thread self;
+
 		up_read(&mm->mmap_sem);
 
 		self.task = tsk;
@@ -565,6 +568,7 @@ static void forget_original_parent(struct task_struct *father)
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		struct task_struct *t = p;
+
 		do {
 			t->real_parent = reaper;
 			if (t->parent == father) {
@@ -598,7 +602,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	/*
 	 * This does two things:
 	 *
-  	 * A.  Make init inherit all the child processes
+	 * A.  Make init inherit all the child processes
 	 * B.  Check to see if any process groups have become orphaned
 	 *	as a result of our exiting, and if they have any stopped
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
@@ -648,9 +652,8 @@ static void check_stack_usage(void)
 
 	spin_lock(&low_water_lock);
 	if (free < lowest_to_date) {
-		printk(KERN_WARNING "%s (%d) used greatest stack depth: "
-				"%lu bytes left\n",
-				current->comm, task_pid_nr(current), free);
+		pr_warn("%s (%d) used greatest stack depth: %lu bytes left\n",
+			current->comm, task_pid_nr(current), free);
 		lowest_to_date = free;
 	}
 	spin_unlock(&low_water_lock);
@@ -691,8 +694,7 @@ void do_exit(long code)
 	 * leave this task alone and wait for reboot.
 	 */
 	if (unlikely(tsk->flags & PF_EXITING)) {
-		printk(KERN_ALERT
-			"Fixing recursive fault but reboot is needed!\n");
+		pr_alert("Fixing recursive fault but reboot is needed!\n");
 		/*
 		 * We can do this unlocked here. The futex code uses
 		 * this flag just to verify whether the pi state
@@ -716,9 +718,9 @@ void do_exit(long code)
 	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
-		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
-				current->comm, task_pid_nr(current),
-				preempt_count());
+		pr_info("note: %s[%d] exited with preempt_count %d\n",
+			current->comm, task_pid_nr(current),
+			preempt_count());
 
 	acct_update_integrals(tsk);
 	/* sync mm's RSS info before statistics gathering */
@@ -836,7 +838,6 @@ void do_exit(long code)
 	for (;;)
 		cpu_relax();	/* For when BUG is null */
 }
-
 EXPORT_SYMBOL_GPL(do_exit);
 
 void complete_and_exit(struct completion *comp, long code)
@@ -846,7 +847,6 @@ void complete_and_exit(struct completion *comp, long code)
 
 	do_exit(code);
 }
-
 EXPORT_SYMBOL(complete_and_exit);
 
 SYSCALL_DEFINE1(exit, int, error_code)
@@ -869,6 +869,7 @@ do_group_exit(int exit_code)
 		exit_code = sig->group_exit_code;
 	else if (!thread_group_empty(current)) {
 		struct sighand_struct *const sighand = current->sighand;
+
 		spin_lock_irq(&sighand->siglock);
 		if (signal_group_exit(sig))
 			/* Another thread got here before we took the lock.  */
@@ -1033,9 +1034,9 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
-		 * We use thread_group_cputime_adjusted() to get times for the thread
-		 * group, which consolidates times for all threads in the
-		 * group including the group leader.
+		 * We use thread_group_cputime_adjusted() to get times for
+		 * the thread group, which consolidates times for all threads
+		 * in the group including the group leader.
 		 */
 		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
@@ -1417,6 +1418,7 @@ static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 
 	list_for_each_entry(p, &tsk->children, sibling) {
 		int ret = wait_consider_task(wo, 0, p);
+
 		if (ret)
 			return ret;
 	}
@@ -1430,6 +1432,7 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
 		int ret = wait_consider_task(wo, 1, p);
+
 		if (ret)
 			return ret;
 	}
-- 
1.7.10.4


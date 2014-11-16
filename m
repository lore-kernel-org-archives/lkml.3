Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaKPULT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:11:19 -0500
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:44719 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751423AbaKPUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1544:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3867:3874:4605:5007:6261:7875:10004:10848:11026:11233:11473:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12683:13138:13231:13868:14096:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wheel12_56527ad15e320
X-Filterd-Recvd-Size: 5219
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 12/16] signal: 80 column wrapping
Date: Sun, 16 Nov 2014 12:09:19 -0800
Message-Id: <e5adf4fab1246749bdd5aaec5f1000a2d8754795.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just neaten some lines that extend beyond 80 columns.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 1946fa1..15ce05d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -983,7 +983,8 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			signal->group_stop_count = 0;
 			t = p;
 			do {
-				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
+				task_clear_jobctl_pending(t,
+							  JOBCTL_PENDING_MASK);
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
@@ -1079,7 +1080,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_tgid_nr_ns(current,
 							 task_active_pid_ns(t));
-			q->info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
+			q->info.si_uid = from_kuid_munged(current_user_ns(),
+							  current_uid());
 			break;
 		case (unsigned long)SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1375,8 +1377,10 @@ static int kill_as_cred_perm(const struct cred *cred,
 {
 	const struct cred *pcred = __task_cred(target);
 
-	if (!uid_eq(cred->euid, pcred->suid) && !uid_eq(cred->euid, pcred->uid) &&
-	    !uid_eq(cred->uid,  pcred->suid) && !uid_eq(cred->uid,  pcred->uid))
+	if (!uid_eq(cred->euid, pcred->suid) &&
+	    !uid_eq(cred->euid, pcred->uid) &&
+	    !uid_eq(cred->uid,  pcred->suid) &&
+	    !uid_eq(cred->uid,  pcred->uid))
 		return 0;
 	return 1;
 }
@@ -1752,7 +1756,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, task_active_pid_ns(parent));
-	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns), task_uid(tsk));
+	info.si_uid = from_kuid_munged(task_cred_xxx(parent, user_ns),
+				       task_uid(tsk));
 	rcu_read_unlock();
 
 	task_cputime(tsk, &utime, &stime);
@@ -1816,8 +1821,8 @@ static inline int may_ptrace_stop(void)
  */
 static int sigkill_pending(struct task_struct *tsk)
 {
-	return	sigismember(&tsk->pending.signal, SIGKILL) ||
-		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
+	return sigismember(&tsk->pending.signal, SIGKILL) ||
+	       sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
 }
 
 /*
@@ -2764,7 +2769,8 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 		 * Other callers might not initialize the si_lsb field,
 		 * so check explicitly for the right codes here.
 		 */
-		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
+		if (from->si_code == BUS_MCEERR_AR ||
+		    from->si_code == BUS_MCEERR_AO)
 			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
 #endif
 		break;
@@ -3201,7 +3207,9 @@ static int do_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 		 *	  way that worked) - this fix preserves that older
 		 *	  mechanism.
 		 */
-		if (ss_flags != SS_DISABLE && ss_flags != SS_ONSTACK && ss_flags != 0)
+		if (ss_flags != SS_DISABLE &&
+		    ss_flags != SS_ONSTACK &&
+		    ss_flags != 0)
 			goto out;
 
 		if (ss_flags == SS_DISABLE) {
@@ -3280,7 +3288,8 @@ COMPAT_SYSCALL_DEFINE2(sigaltstack,
 			     compat_user_stack_pointer());
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
-		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(compat_stack_t)) ||
+		if (!access_ok(VERIFY_WRITE, uoss_ptr,
+			       sizeof(compat_stack_t)) ||
 		    __put_user(ptr_to_compat(uoss.ss_sp), &uoss_ptr->ss_sp) ||
 		    __put_user(uoss.ss_flags, &uoss_ptr->ss_flags) ||
 		    __put_user(uoss.ss_size, &uoss_ptr->ss_size))
@@ -3300,9 +3309,10 @@ int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
 {
 	struct task_struct *t = current;
 
-	return  __put_user(ptr_to_compat((void __user *)t->sas_ss_sp), &uss->ss_sp) |
-		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
-		__put_user(t->sas_ss_size, &uss->ss_size);
+	return __put_user(ptr_to_compat((void __user *)t->sas_ss_sp),
+			  &uss->ss_sp) |
+	       __put_user(sas_ss_flags(sp), &uss->ss_flags) |
+	       __put_user(t->sas_ss_size, &uss->ss_size);
 }
 #endif
 
-- 
2.1.2


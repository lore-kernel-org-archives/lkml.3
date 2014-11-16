Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaKPUJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:37 -0500
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:46978 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750865AbaKPUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:4:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2896:2898:3138:3139:3140:3141:3142:3865:3866:3867:3870:3871:3872:3874:4385:4605:5007:6119:6261:7875:7903:8531:9010:10004:10848:10954:11026:11232:11473:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12679:12683:13868:14096:14110:14394:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate12_52bd1e296e354
X-Filterd-Recvd-Size: 18997
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 01/16] signal: whitespace neatening
Date: Sun, 16 Nov 2014 12:09:08 -0800
Message-Id: <6b0ef8a09d7141c6413092bf04167581c214cd02.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No change in object produced.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 174 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 19e3513..24aaaee 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -72,7 +72,7 @@ static int sig_task_ignored(struct task_struct *t, int sig, bool force)
 	handler = sig_handler(t, sig);
 
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
-			handler == SIG_DFL && !force)
+	    handler == SIG_DFL && !force)
 		return 1;
 
 	return sig_handler_ignored(handler, sig);
@@ -109,25 +109,25 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = _NSIG_WORDS, ready = 0; --i >= 0 ;)
-			ready |= signal->sig[i] &~ blocked->sig[i];
+			ready |= signal->sig[i] & ~blocked->sig[i];
 		break;
 
-	case 4: ready  = signal->sig[3] &~ blocked->sig[3];
-		ready |= signal->sig[2] &~ blocked->sig[2];
-		ready |= signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 4: ready  = signal->sig[3] & ~blocked->sig[3];
+		ready |= signal->sig[2] & ~blocked->sig[2];
+		ready |= signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 2: ready  = signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 2: ready  = signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 1: ready  = signal->sig[0] &~ blocked->sig[0];
+	case 1: ready  = signal->sig[0] & ~blocked->sig[0];
 	}
 	return ready !=	0;
 }
 
-#define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
+#define PENDING(p, b) has_pending_signals(&(p)->signal, (b))
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
@@ -164,7 +164,7 @@ void recalc_sigpending(void)
 
 /* Given the mask, find the first available signal that should be serviced. */
 
-#define SYNCHRONOUS_MASK \
+#define SYNCHRONOUS_MASK					\
 	(sigmask(SIGSEGV) | sigmask(SIGBUS) | sigmask(SIGILL) | \
 	 sigmask(SIGTRAP) | sigmask(SIGFPE) | sigmask(SIGSYS))
 
@@ -180,7 +180,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	 * Handle the first word specially: it contains the
 	 * synchronous signals that need to be dequeued first.
 	 */
-	x = *s &~ *m;
+	x = *s & ~*m;
 	if (x) {
 		if (x & SYNCHRONOUS_MASK)
 			x &= SYNCHRONOUS_MASK;
@@ -191,7 +191,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = 1; i < _NSIG_WORDS; ++i) {
-			x = *++s &~ *++m;
+			x = *++s & ~*++m;
 			if (!x)
 				continue;
 			sig = ffz(~x) + i*_NSIG_BPW + 1;
@@ -200,7 +200,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 		break;
 
 	case 2:
-		x = s[1] &~ m[1];
+		x = s[1] & ~m[1];
 		if (!x)
 			break;
 		sig = ffz(~x) + _NSIG_BPW + 1;
@@ -225,7 +225,7 @@ static inline void print_dropped_signal(int sig)
 		return;
 
 	printk(KERN_INFO "%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
-				current->comm, current->pid, sig);
+	       current->comm, current->pid, sig);
 }
 
 /**
@@ -374,7 +374,7 @@ __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimi
 
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
-			task_rlimit(t, RLIMIT_SIGPENDING)) {
+	    task_rlimit(t, RLIMIT_SIGPENDING)) {
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
 	} else {
 		print_dropped_signal(sig);
@@ -407,7 +407,7 @@ void flush_sigqueue(struct sigpending *queue)
 
 	sigemptyset(&queue->signal);
 	while (!list_empty(&queue->list)) {
-		q = list_entry(queue->list.next, struct sigqueue , list);
+		q = list_entry(queue->list.next, struct sigqueue, list);
 		list_del_init(&q->list);
 		__sigqueue_free(q);
 	}
@@ -550,7 +550,7 @@ static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
 	 * there is another siginfo for the same signal.
-	*/
+	 */
 	list_for_each_entry(q, &list->list, list) {
 		if (q->info.si_signo == sig) {
 			if (first)
@@ -562,7 +562,7 @@ static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 	sigdelset(&list->signal, sig);
 
 	if (first) {
-still_pending:
+	still_pending:
 		list_del_init(&first->list);
 		copy_siginfo(info, &first->info);
 		__sigqueue_free(first);
@@ -581,7 +581,7 @@ still_pending:
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
-			siginfo_t *info)
+			    siginfo_t *info)
 {
 	int sig = next_signal(pending, mask);
 
@@ -1021,7 +1021,7 @@ static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_str
 #endif
 
 static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			int group, int from_ancestor_ns)
+			 int group, int from_ancestor_ns)
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
@@ -1032,7 +1032,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 
 	result = TRACE_SIGNAL_IGNORED;
 	if (!prepare_signal(sig, t,
-			from_ancestor_ns || (info == SEND_SIG_FORCED)))
+			    from_ancestor_ns || (info == SEND_SIG_FORCED)))
 		goto ret;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
@@ -1068,19 +1068,19 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 		override_rlimit = 0;
 
 	q = __sigqueue_alloc(sig, t, GFP_ATOMIC | __GFP_NOTRACK_FALSE_POSITIVE,
-		override_rlimit);
+			     override_rlimit);
 	if (q) {
 		list_add_tail(&q->list, &pending->list);
-		switch ((unsigned long) info) {
-		case (unsigned long) SEND_SIG_NOINFO:
+		switch ((unsigned long)info) {
+		case (unsigned long)SEND_SIG_NOINFO:
 			q->info.si_signo = sig;
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_tgid_nr_ns(current,
-							task_active_pid_ns(t));
+							 task_active_pid_ns(t));
 			q->info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
 			break;
-		case (unsigned long) SEND_SIG_PRIV:
+		case (unsigned long)SEND_SIG_PRIV:
 			q->info.si_signo = sig;
 			q->info.si_errno = 0;
 			q->info.si_code = SI_KERNEL;
@@ -1125,13 +1125,13 @@ ret:
 }
 
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
-			int group)
+		       int group)
 {
 	int from_ancestor_ns = 0;
 
 #ifdef CONFIG_PID_NS
 	from_ancestor_ns = si_fromuser(info) &&
-			   !task_pid_nr_ns(current, task_active_pid_ns(t));
+		!task_pid_nr_ns(current, task_active_pid_ns(t));
 #endif
 
 	return __send_signal(sig, info, t, group, from_ancestor_ns);
@@ -1163,7 +1163,7 @@ static void print_fatal_signal(int signr)
 
 static int __init setup_print_fatal_signals(char *str)
 {
-	get_option (&str, &print_fatal_signals);
+	get_option(&str, &print_fatal_signals);
 
 	return 1;
 }
@@ -1183,7 +1183,7 @@ specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 }
 
 int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
-			bool group)
+		     bool group)
 {
 	unsigned long flags;
 	int ret = -ESRCH;
@@ -1379,7 +1379,7 @@ static int kill_as_cred_perm(const struct cred *cred,
 
 /* like kill_pid_info(), but doesn't use uid/euid of "current" */
 int kill_pid_info_as_cred(int sig, struct siginfo *info, struct pid *pid,
-			 const struct cred *cred, u32 secid)
+			  const struct cred *cred, u32 secid)
 {
 	int ret = -EINVAL;
 	struct task_struct *p;
@@ -1436,14 +1436,14 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 	read_lock(&tasklist_lock);
 	if (pid != -1) {
 		ret = __kill_pgrp_info(sig, info,
-				pid ? find_vpid(-pid) : task_pgrp(current));
+				       pid ? find_vpid(-pid) : task_pgrp(current));
 	} else {
 		int retval = 0, count = 0;
-		struct task_struct * p;
+		struct task_struct *p;
 
 		for_each_process(p) {
 			if (task_pid_vnr(p) > 1 &&
-					!same_thread_group(p, current)) {
+			    !same_thread_group(p, current)) {
 				int err = group_send_sig_info(sig, info, p);
 				++count;
 				if (err != -EPERM)
@@ -1473,7 +1473,7 @@ int send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 	return do_send_sig_info(sig, info, p, false);
 }
 
-#define __si_special(priv) \
+#define __si_special(priv)				\
 	((priv) ? SEND_SIG_PRIV : SEND_SIG_NOINFO)
 
 int
@@ -1630,8 +1630,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 
 	BUG_ON(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	BUG_ON(task_is_stopped_or_traced(tsk));
 
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
@@ -1753,20 +1753,20 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	info.si_utime = cputime_to_clock_t(utime);
 	info.si_stime = cputime_to_clock_t(stime);
 
- 	info.si_code = why;
- 	switch (why) {
- 	case CLD_CONTINUED:
- 		info.si_status = SIGCONT;
- 		break;
- 	case CLD_STOPPED:
- 		info.si_status = tsk->signal->group_exit_code & 0x7f;
- 		break;
- 	case CLD_TRAPPED:
- 		info.si_status = tsk->exit_code & 0x7f;
- 		break;
- 	default:
- 		BUG();
- 	}
+	info.si_code = why;
+	switch (why) {
+	case CLD_CONTINUED:
+		info.si_status = SIGCONT;
+		break;
+	case CLD_STOPPED:
+		info.si_status = tsk->signal->group_exit_code & 0x7f;
+		break;
+	case CLD_TRAPPED:
+		info.si_status = tsk->exit_code & 0x7f;
+		break;
+	default:
+		BUG();
+	}
 
 	sighand = parent->sighand;
 	spin_lock_irqsave(&sighand->siglock, flags);
@@ -2229,7 +2229,7 @@ relock:
 
 		if (ptrace_reparented(current->group_leader))
 			do_notify_parent_cldstop(current->group_leader,
-						true, why);
+						 true, why);
 		read_unlock(&tasklist_lock);
 
 		goto relock;
@@ -2293,7 +2293,7 @@ relock:
 		 * case, the signal cannot be dropped.
 		 */
 		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
-				!sig_kernel_only(signr))
+		    !sig_kernel_only(signr))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
@@ -2365,7 +2365,7 @@ relock:
 }
 
 /**
- * signal_delivered - 
+ * signal_delivered -
  * @ksig:		kernel signal struct
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
@@ -2618,7 +2618,7 @@ SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, nset,
-		compat_sigset_t __user *, oset, compat_size_t, sigsetsize)
+		       compat_sigset_t __user *, oset, compat_size_t, sigsetsize)
 {
 #ifdef __BIG_ENDIAN
 	sigset_t old_set = current->blocked;
@@ -2687,7 +2687,7 @@ SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, uset, size_t, sigsetsize)
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, uset,
-		compat_size_t, sigsetsize)
+		       compat_size_t, sigsetsize)
 {
 #ifdef __BIG_ENDIAN
 	sigset_t set;
@@ -2712,7 +2712,7 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 {
 	int err;
 
-	if (!access_ok (VERIFY_WRITE, to, sizeof(siginfo_t)))
+	if (!access_ok(VERIFY_WRITE, to, sizeof(siginfo_t)))
 		return -EFAULT;
 	if (from->si_code < 0)
 		return __copy_to_user(to, from, sizeof(siginfo_t))
@@ -2735,9 +2735,9 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 		err |= __put_user(from->si_uid, &to->si_uid);
 		break;
 	case __SI_TIMER:
-		 err |= __put_user(from->si_tid, &to->si_tid);
-		 err |= __put_user(from->si_overrun, &to->si_overrun);
-		 err |= __put_user(from->si_ptr, &to->si_ptr);
+		err |= __put_user(from->si_tid, &to->si_tid);
+		err |= __put_user(from->si_overrun, &to->si_overrun);
+		err |= __put_user(from->si_ptr, &to->si_ptr);
 		break;
 	case __SI_POLL:
 		err |= __put_user(from->si_band, &to->si_band);
@@ -2794,7 +2794,7 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
  *  @ts: upper bound on process time suspension
  */
 int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
-			const struct timespec *ts)
+		    const struct timespec *ts)
 {
 	struct task_struct *tsk = current;
 	long timeout = MAX_SCHEDULE_TIMEOUT;
@@ -3016,9 +3016,9 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
-			compat_pid_t, pid,
-			int, sig,
-			struct compat_siginfo __user *, uinfo)
+		       compat_pid_t, pid,
+		       int, sig,
+		       struct compat_siginfo __user *, uinfo)
 {
 	siginfo_t info;
 	int ret = copy_siginfo_from_user32(&info, uinfo);
@@ -3061,10 +3061,10 @@ SYSCALL_DEFINE4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo,
-			compat_pid_t, tgid,
-			compat_pid_t, pid,
-			int, sig,
-			struct compat_siginfo __user *, uinfo)
+		       compat_pid_t, tgid,
+		       compat_pid_t, pid,
+		       int, sig,
+		       struct compat_siginfo __user *, uinfo)
 {
 	siginfo_t info;
 
@@ -3139,12 +3139,12 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 }
 
 static int
-do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
+do_sigaltstack(const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
 {
 	stack_t oss;
 	int error;
 
-	oss.ss_sp = (void __user *) current->sas_ss_sp;
+	oss.ss_sp = (void __user *)current->sas_ss_sp;
 	oss.ss_size = current->sas_ss_size;
 	oss.ss_flags = sas_ss_flags(sp);
 
@@ -3169,7 +3169,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 		error = -EINVAL;
 		/*
 		 * Note - this code used to test ss_flags incorrectly:
-		 *  	  old code may have been written using ss_flags==0
+		 *	  old code may have been written using ss_flags==0
 		 *	  to mean ss_flags==SS_ONSTACK (as this was the only
 		 *	  way that worked) - this fix preserves that older
 		 *	  mechanism.
@@ -3186,7 +3186,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 				goto out;
 		}
 
-		current->sas_ss_sp = (unsigned long) ss_sp;
+		current->sas_ss_sp = (unsigned long)ss_sp;
 		current->sas_ss_size = ss_size;
 	}
 
@@ -3203,7 +3203,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 out:
 	return error;
 }
-SYSCALL_DEFINE2(sigaltstack,const stack_t __user *,uss, stack_t __user *,uoss)
+SYSCALL_DEFINE2(sigaltstack, const stack_t __user *, uss, stack_t __user *, uoss)
 {
 	return do_sigaltstack(uss, uoss, current_user_stack_pointer());
 }
@@ -3225,8 +3225,8 @@ int __save_altstack(stack_t __user *uss, unsigned long sp)
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(sigaltstack,
-			const compat_stack_t __user *, uss_ptr,
-			compat_stack_t __user *, uoss_ptr)
+		       const compat_stack_t __user *, uss_ptr,
+		       compat_stack_t __user *, uoss_ptr)
 {
 	stack_t uss, uoss;
 	int ret;
@@ -3244,8 +3244,8 @@ COMPAT_SYSCALL_DEFINE2(sigaltstack,
 	}
 	seg = get_fs();
 	set_fs(KERNEL_DS);
-	ret = do_sigaltstack((stack_t __force __user *) (uss_ptr ? &uss : NULL),
-			     (stack_t __force __user *) &uoss,
+	ret = do_sigaltstack((stack_t __force __user *)(uss_ptr ? &uss : NULL),
+			     (stack_t __force __user *)&uoss,
 			     compat_user_stack_pointer());
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
@@ -3282,7 +3282,7 @@ int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
  */
 SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
-	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t)); 
+	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t));
 }
 
 #endif
@@ -3374,9 +3374,9 @@ out:
 }
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
-		const struct compat_sigaction __user *, act,
-		struct compat_sigaction __user *, oact,
-		compat_size_t, sigsetsize)
+		       const struct compat_sigaction __user *, act,
+		       struct compat_sigaction __user *, oact,
+		       compat_size_t, sigsetsize)
 {
 	struct k_sigaction new_ka, old_ka;
 	compat_sigset_t mask;
@@ -3407,7 +3407,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
 	if (!ret && oact) {
 		sigset_to_compat(&mask, &old_ka.sa.sa_mask);
-		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), 
+		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler),
 			       &oact->sa_handler);
 		ret |= copy_to_user(&oact->sa_mask, &mask, sizeof(mask));
 		ret |= put_user(old_ka.sa.sa_flags, &oact->sa_flags);
@@ -3424,7 +3424,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 #ifdef CONFIG_OLD_SIGACTION
 SYSCALL_DEFINE3(sigaction, int, sig,
 		const struct old_sigaction __user *, act,
-	        struct old_sigaction __user *, oact)
+		struct old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -3459,8 +3459,8 @@ SYSCALL_DEFINE3(sigaction, int, sig,
 #endif
 #ifdef CONFIG_COMPAT_OLD_SIGACTION
 COMPAT_SYSCALL_DEFINE3(sigaction, int, sig,
-		const struct compat_old_sigaction __user *, act,
-	        struct compat_old_sigaction __user *, oact)
+		       const struct compat_old_sigaction __user *, act,
+		       struct compat_old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -3583,7 +3583,7 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 		return -EFAULT;
 	return sigsuspend(&newset);
 }
- 
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_size_t, sigsetsize)
 {
-- 
2.1.2


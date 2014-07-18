Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934539AbaGRJvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:51:17 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62515 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934416AbaGRJvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:51:14 -0400
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org,
        Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: [PATCH] kernel: signal : fix coding style errors and reduce warnings.
Date: Fri, 18 Jul 2014 12:52:05 +0300
Message-Id: <1405677125-26075-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style errors and reduced codign style warnings.

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
---
 kernel/signal.c |  150 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 88 insertions(+), 62 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index a4077e9..e69daec 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -109,25 +109,28 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
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
+	case 4:
+		ready  = signal->sig[3] & ~blocked->sig[3];
+		ready |= signal->sig[2] & ~blocked->sig[2];
+		ready |= signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 2: ready  = signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 2:
+		ready  = signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 1: ready  = signal->sig[0] &~ blocked->sig[0];
+	case 1:
+		ready  = signal->sig[0] & ~blocked->sig[0];
 	}
 	return ready !=	0;
 }
 
-#define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
+#define PENDING(p, b) has_pending_signals(&(p)->signal, (b))
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
@@ -161,6 +164,7 @@ void recalc_sigpending(void)
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
+EXPORT_SYMBOL(recalc_sigpending);
 
 /* Given the mask, find the first available signal that should be serviced. */
 
@@ -180,7 +184,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	 * Handle the first word specially: it contains the
 	 * synchronous signals that need to be dequeued first.
 	 */
-	x = *s &~ *m;
+	x = (*s) & ~(*m);
 	if (x) {
 		if (x & SYNCHRONOUS_MASK)
 			x &= SYNCHRONOUS_MASK;
@@ -191,7 +195,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = 1; i < _NSIG_WORDS; ++i) {
-			x = *++s &~ *++m;
+			x = (*++s) & ~(*++m);
 			if (!x)
 				continue;
 			sig = ffz(~x) + i*_NSIG_BPW + 1;
@@ -200,7 +204,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 		break;
 
 	case 2:
-		x = s[1] &~ m[1];
+		x = s[1] & ~m[1];
 		if (!x)
 			break;
 		sig = ffz(~x) + _NSIG_BPW + 1;
@@ -224,8 +228,8 @@ static inline void print_dropped_signal(int sig)
 	if (!__ratelimit(&ratelimit_state))
 		return;
 
-	printk(KERN_INFO "%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
-				current->comm, current->pid, sig);
+	pr_info("%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
+			current->comm, current->pid, sig);
 }
 
 /**
@@ -358,7 +362,8 @@ static bool task_participate_group_stop(struct task_struct *task)
  *   appropriate lock must be held to stop the target task from exiting
  */
 static struct sigqueue *
-__sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimit)
+__sigqueue_alloc(int sig, struct task_struct *t,
+			gfp_t flags, int override_rlimit)
 {
 	struct sigqueue *q = NULL;
 	struct user_struct *user;
@@ -431,6 +436,7 @@ void flush_signals(struct task_struct *t)
 	__flush_signals(t);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 }
+EXPORT_SYMBOL(flush_signals);
 
 static void __flush_itimer_signals(struct sigpending *pending)
 {
@@ -485,6 +491,7 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 {
 	int i;
 	struct k_sigaction *ka = &t->sighand->action[0];
+
 	for (i = _NSIG ; i != 0 ; i--) {
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
@@ -500,6 +507,7 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 int unhandled_signal(struct task_struct *tsk, int sig)
 {
 	void __user *handler = tsk->sighand->action[sig-1].sa.sa_handler;
+
 	if (is_global_init(tsk))
 		return 1;
 	if (handler != SIG_IGN && handler != SIG_DFL)
@@ -528,6 +536,7 @@ block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
 	current->notifier = notifier;
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
+EXPORT_SYMBOL(block_all_signals);
 
 /* Notify the system that blocking has ended. */
 
@@ -542,6 +551,7 @@ unblock_all_signals(void)
 	recalc_sigpending();
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
+EXPORT_SYMBOL(unblock_all_signals);
 
 static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
@@ -675,6 +685,7 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	}
 	return signr;
 }
+EXPORT_SYMBOL_GPL(dequeue_signal);
 
 /*
  * Tell a process that it has a new active signal..
@@ -991,7 +1002,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * Tell the chosen thread to wake up and dequeue it.
 	 */
 	signal_wake_up(t, sig == SIGKILL);
-	return;
+	/* return; */
 }
 
 static inline int legacy_queue(struct sigpending *signals, int sig)
@@ -1016,7 +1027,7 @@ static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_str
 #else
 static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
 {
-	return;
+	/* return; */
 }
 #endif
 
@@ -1140,21 +1151,23 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);
+
+	pr_info("potentially unexpected fatal signal %d.\n", signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
-	printk(KERN_INFO "code at %08lx: ", regs->ip);
+	pr_info("code at %08lx: ", regs->ip);
 	{
 		int i;
+
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
 			if (get_user(insn, (unsigned char *)(regs->ip + i)))
 				break;
-			printk(KERN_CONT "%02x ", insn);
+			pr_cont("%02x ", insn);
 		}
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 #endif
 	preempt_disable();
 	show_regs(regs);
@@ -1163,7 +1176,7 @@ static void print_fatal_signal(int signr)
 
 static int __init setup_print_fatal_signals(char *str)
 {
-	get_option (&str, &print_fatal_signals);
+	get_option(&str, &print_fatal_signals);
 
 	return 1;
 }
@@ -1316,6 +1329,7 @@ int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
 	retval = -ESRCH;
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 		int err = group_send_sig_info(sig, info, p);
+
 		success |= !err;
 		retval = err;
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
@@ -1349,6 +1363,7 @@ retry:
 int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
 {
 	int error;
+
 	rcu_read_lock();
 	error = kill_pid_info(sig, info, find_vpid(pid));
 	rcu_read_unlock();
@@ -1359,6 +1374,7 @@ static int kill_as_cred_perm(const struct cred *cred,
 			     struct task_struct *target)
 {
 	const struct cred *pcred = __task_cred(target);
+
 	if (!uid_eq(cred->euid, pcred->suid) && !uid_eq(cred->euid, pcred->uid) &&
 	    !uid_eq(cred->uid,  pcred->suid) && !uid_eq(cred->uid,  pcred->uid))
 		return 0;
@@ -1427,7 +1443,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 				pid ? find_vpid(-pid) : task_pgrp(current));
 	} else {
 		int retval = 0, count = 0;
-		struct task_struct * p;
+		struct task_struct *p;
 
 		for_each_process(p) {
 			if (task_pid_vnr(p) > 1 &&
@@ -1460,6 +1476,7 @@ int send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 
 	return do_send_sig_info(sig, info, p, false);
 }
+EXPORT_SYMBOL(send_sig_info);
 
 #define __si_special(priv) \
 	((priv) ? SEND_SIG_PRIV : SEND_SIG_NOINFO)
@@ -1469,12 +1486,14 @@ send_sig(int sig, struct task_struct *p, int priv)
 {
 	return send_sig_info(sig, __si_special(priv), p);
 }
+EXPORT_SYMBOL(send_sig);
 
 void
 force_sig(int sig, struct task_struct *p)
 {
 	force_sig_info(sig, SEND_SIG_PRIV, p);
 }
+EXPORT_SYMBOL(force_sig);
 
 /*
  * When things go south during signal handling, we
@@ -1487,6 +1506,7 @@ force_sigsegv(int sig, struct task_struct *p)
 {
 	if (sig == SIGSEGV) {
 		unsigned long flags;
+
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		p->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
@@ -1618,8 +1638,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 
 	BUG_ON(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	BUG_ON(task_is_stopped_or_traced(tsk));
 
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
@@ -1741,20 +1761,20 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
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
@@ -1939,7 +1959,7 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
 {
 	siginfo_t info;
 
-	memset(&info, 0, sizeof info);
+	memset(&info, 0, sizeof(info));
 	info.si_signo = signr;
 	info.si_code = exit_code;
 	info.si_pid = task_pid_vnr(current);
@@ -2352,7 +2372,7 @@ relock:
 }
 
 /**
- * signal_delivered - 
+ * signal_delivered -
  * @sig:		number of signal being delivered
  * @info:		siginfo_t of signal being delivered
  * @ka:			sigaction setting that chose the handler
@@ -2473,17 +2493,6 @@ out:
 	}
 }
 
-EXPORT_SYMBOL(recalc_sigpending);
-EXPORT_SYMBOL_GPL(dequeue_signal);
-EXPORT_SYMBOL(flush_signals);
-EXPORT_SYMBOL(force_sig);
-EXPORT_SYMBOL(send_sig);
-EXPORT_SYMBOL(send_sig_info);
-EXPORT_SYMBOL(sigprocmask);
-EXPORT_SYMBOL(block_all_signals);
-EXPORT_SYMBOL(unblock_all_signals);
-
-
 /*
  * System call entry points.
  */
@@ -2494,6 +2503,7 @@ EXPORT_SYMBOL(unblock_all_signals);
 SYSCALL_DEFINE0(restart_syscall)
 {
 	struct restart_block *restart = &current_thread_info()->restart_block;
+
 	return restart->fn(restart);
 }
 
@@ -2570,6 +2580,7 @@ int sigprocmask(int how, sigset_t *set, sigset_t *oldset)
 	__set_current_blocked(&newset);
 	return 0;
 }
+EXPORT_SYMBOL(sigprocmask);
 
 /**
  *  sys_rt_sigprocmask - change the list of currently blocked signals
@@ -2623,6 +2634,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, nset,
 		compat_sigset_t new32;
 		sigset_t new_set;
 		int error;
+
 		if (copy_from_user(&new32, nset, sizeof(compat_sigset_t)))
 			return -EFAULT;
 
@@ -2635,6 +2647,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, nset,
 	}
 	if (oset) {
 		compat_sigset_t old32;
+
 		sigset_to_compat(&old32, &old_set);
 		if (copy_to_user(oset, &old32, sizeof(compat_sigset_t)))
 			return -EFAULT;
@@ -2672,6 +2685,7 @@ SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, uset, size_t, sigsetsize)
 {
 	sigset_t set;
 	int err = do_sigpending(&set, sigsetsize);
+
 	if (!err && copy_to_user(uset, &set, sigsetsize))
 		err = -EFAULT;
 	return err;
@@ -2684,8 +2698,10 @@ COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, uset,
 #ifdef __BIG_ENDIAN
 	sigset_t set;
 	int err = do_sigpending(&set, sigsetsize);
+
 	if (!err) {
 		compat_sigset_t set32;
+
 		sigset_to_compat(&set32, &set);
 		/* we can get here only if sigsetsize <= sizeof(set) */
 		if (copy_to_user(uset, &set32, sigsetsize))
@@ -2704,7 +2720,7 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 {
 	int err;
 
-	if (!access_ok (VERIFY_WRITE, to, sizeof(siginfo_t)))
+	if (!access_ok(VERIFY_WRITE, to, sizeof(siginfo_t)))
 		return -EFAULT;
 	if (from->si_code < 0)
 		return __copy_to_user(to, from, sizeof(siginfo_t))
@@ -3001,6 +3017,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 		siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
+
 	if (copy_from_user(&info, uinfo, sizeof(siginfo_t)))
 		return -EFAULT;
 	return do_rt_sigqueueinfo(pid, sig, &info);
@@ -3014,6 +3031,7 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
 {
 	siginfo_t info;
 	int ret = copy_siginfo_from_user32(&info, uinfo);
+
 	if (unlikely(ret))
 		return ret;
 	return do_rt_sigqueueinfo(pid, sig, &info);
@@ -3131,7 +3149,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 }
 
 static int
-do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
+do_sigaltstack(const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
 {
 	stack_t oss;
 	int error;
@@ -3161,7 +3179,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 		error = -EINVAL;
 		/*
 		 * Note - this code used to test ss_flags incorrectly:
-		 *  	  old code may have been written using ss_flags==0
+		 *	  old code may have been written using ss_flags==0
 		 *	  to mean ss_flags==SS_ONSTACK (as this was the only
 		 *	  way that worked) - this fix preserves that older
 		 *	  mechanism.
@@ -3195,7 +3213,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 out:
 	return error;
 }
-SYSCALL_DEFINE2(sigaltstack,const stack_t __user *,uss, stack_t __user *,uoss)
+SYSCALL_DEFINE2(sigaltstack, const stack_t __user *, uss, stack_t __user *, uoss)
 {
 	return do_sigaltstack(uss, uoss, current_user_stack_pointer());
 }
@@ -3210,6 +3228,7 @@ int restore_altstack(const stack_t __user *uss)
 int __save_altstack(stack_t __user *uss, unsigned long sp)
 {
 	struct task_struct *t = current;
+
 	return  __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
 		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
@@ -3260,6 +3279,7 @@ int compat_restore_altstack(const compat_stack_t __user *uss)
 int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
 {
 	struct task_struct *t = current;
+
 	return  __put_user(ptr_to_compat((void __user *)t->sas_ss_sp), &uss->ss_sp) |
 		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
@@ -3274,7 +3294,7 @@ int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
  */
 SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
-	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t)); 
+	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t));
 }
 
 #endif
@@ -3383,6 +3403,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 
 	if (act) {
 		compat_uptr_t handler;
+
 		ret = get_user(handler, &act->sa_handler);
 		new_ka.sa.sa_handler = compat_ptr(handler);
 #ifdef __ARCH_HAS_SA_RESTORER
@@ -3399,7 +3420,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
 	if (!ret && oact) {
 		sigset_to_compat(&mask, &old_ka.sa.sa_mask);
-		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), 
+		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler),
 			       &oact->sa_handler);
 		ret |= copy_to_user(&oact->sa_mask, &mask, sizeof(mask));
 		ret |= put_user(old_ka.sa.sa_flags, &oact->sa_flags);
@@ -3416,13 +3437,14 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 #ifdef CONFIG_OLD_SIGACTION
 SYSCALL_DEFINE3(sigaction, int, sig,
 		const struct old_sigaction __user *, act,
-	        struct old_sigaction __user *, oact)
+		struct old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
 
 	if (act) {
 		old_sigset_t mask;
+
 		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
 		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
 		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer) ||
@@ -3452,7 +3474,7 @@ SYSCALL_DEFINE3(sigaction, int, sig,
 #ifdef CONFIG_COMPAT_OLD_SIGACTION
 COMPAT_SYSCALL_DEFINE3(sigaction, int, sig,
 		const struct compat_old_sigaction __user *, act,
-	        struct compat_old_sigaction __user *, oact)
+		struct compat_old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -3575,9 +3597,10 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 		return -EFAULT;
 	return sigsuspend(&newset);
 }
- 
+
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_size_t, sigsetsize)
+COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *,
+			unewset, compat_size_t, sigsetsize)
 {
 #ifdef __BIG_ENDIAN
 	sigset_t newset;
@@ -3602,6 +3625,7 @@ COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_
 SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
 {
 	sigset_t blocked;
+
 	siginitset(&blocked, mask);
 	return sigsuspend(&blocked);
 }
@@ -3610,6 +3634,7 @@ SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
 SYSCALL_DEFINE3(sigsuspend, int, unused1, int, unused2, old_sigset_t, mask)
 {
 	sigset_t blocked;
+
 	siginitset(&blocked, mask);
 	return sigsuspend(&blocked);
 }
@@ -3638,6 +3663,7 @@ kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
 {
 	static struct task_struct *kdb_prev_t;
 	int sig, new_t;
+
 	if (!spin_trylock(&t->sighand->siglock)) {
 		kdb_printf("Can't do kill command now.\n"
 			   "The sigmask lock is held somewhere else in "
-- 
1.7.10.4


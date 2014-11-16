Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbaKPUJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:35 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:41739 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750884AbaKPUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:33 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3870:3871:3874:4050:4119:4385:4605:5007:6261:8660:9592:10004:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:13148:13230:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: line78_53183b05a3e56
X-Filterd-Recvd-Size: 8270
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 02/16] signal: vertical line neatening
Date: Sun, 16 Nov 2014 12:09:09 -0800
Message-Id: <7587bdc86f2310cec8777ab87e46dfe0f6d78e33.1416167046.git.joe@perches.com>
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
 kernel/signal.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 24aaaee..abb2bcd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -159,7 +159,6 @@ void recalc_sigpending(void)
 {
 	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
-
 }
 
 /* Given the mask, find the first available signal that should be serviced. */
@@ -485,6 +484,7 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 {
 	int i;
 	struct k_sigaction *ka = &t->sighand->action[0];
+
 	for (i = _NSIG ; i != 0 ; i--) {
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
@@ -500,6 +500,7 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 int unhandled_signal(struct task_struct *tsk, int sig)
 {
 	void __user *handler = tsk->sighand->action[sig-1].sa.sa_handler;
+
 	if (is_global_init(tsk))
 		return 1;
 	if (handler != SIG_IGN && handler != SIG_DFL)
@@ -1140,12 +1141,14 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
+
 	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
 	printk(KERN_INFO "code at %08lx: ", regs->ip);
 	{
 		int i;
+
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
@@ -1330,6 +1333,7 @@ int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
 	retval = -ESRCH;
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 		int err = group_send_sig_info(sig, info, p);
+
 		success |= !err;
 		retval = err;
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
@@ -1361,6 +1365,7 @@ int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
 {
 	int error;
+
 	rcu_read_lock();
 	error = kill_pid_info(sig, info, find_vpid(pid));
 	rcu_read_unlock();
@@ -1371,6 +1376,7 @@ static int kill_as_cred_perm(const struct cred *cred,
 			     struct task_struct *target)
 {
 	const struct cred *pcred = __task_cred(target);
+
 	if (!uid_eq(cred->euid, pcred->suid) && !uid_eq(cred->euid, pcred->uid) &&
 	    !uid_eq(cred->uid,  pcred->suid) && !uid_eq(cred->uid,  pcred->uid))
 		return 0;
@@ -1499,6 +1505,7 @@ force_sigsegv(int sig, struct task_struct *p)
 {
 	if (sig == SIGSEGV) {
 		unsigned long flags;
+
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		p->sighand->action[sig - 1].sa.sa_handler = SIG_DFL;
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
@@ -2491,7 +2498,6 @@ EXPORT_SYMBOL(sigprocmask);
 EXPORT_SYMBOL(block_all_signals);
 EXPORT_SYMBOL(unblock_all_signals);
 
-
 /*
  * System call entry points.
  */
@@ -2502,6 +2508,7 @@ EXPORT_SYMBOL(unblock_all_signals);
 SYSCALL_DEFINE0(restart_syscall)
 {
 	struct restart_block *restart = &current_thread_info()->restart_block;
+
 	return restart->fn(restart);
 }
 
@@ -2631,6 +2638,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, nset,
 		compat_sigset_t new32;
 		sigset_t new_set;
 		int error;
+
 		if (copy_from_user(&new32, nset, sizeof(compat_sigset_t)))
 			return -EFAULT;
 
@@ -2643,6 +2651,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, nset,
 	}
 	if (oset) {
 		compat_sigset_t old32;
+
 		sigset_to_compat(&old32, &old_set);
 		if (copy_to_user(oset, &old32, sizeof(compat_sigset_t)))
 			return -EFAULT;
@@ -2680,6 +2689,7 @@ SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, uset, size_t, sigsetsize)
 {
 	sigset_t set;
 	int err = do_sigpending(&set, sigsetsize);
+
 	if (!err && copy_to_user(uset, &set, sigsetsize))
 		err = -EFAULT;
 	return err;
@@ -2692,8 +2702,10 @@ COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, uset,
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
@@ -3009,6 +3021,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 		siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
+
 	if (copy_from_user(&info, uinfo, sizeof(siginfo_t)))
 		return -EFAULT;
 	return do_rt_sigqueueinfo(pid, sig, &info);
@@ -3022,6 +3035,7 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
 {
 	siginfo_t info;
 	int ret = copy_siginfo_from_user32(&info, uinfo);
+
 	if (unlikely(ret))
 		return ret;
 	return do_rt_sigqueueinfo(pid, sig, &info);
@@ -3203,6 +3217,7 @@ do_sigaltstack(const stack_t __user *uss, stack_t __user *uoss, unsigned long sp
 out:
 	return error;
 }
+
 SYSCALL_DEFINE2(sigaltstack, const stack_t __user *, uss, stack_t __user *, uoss)
 {
 	return do_sigaltstack(uss, uoss, current_user_stack_pointer());
@@ -3218,6 +3233,7 @@ int restore_altstack(const stack_t __user *uss)
 int __save_altstack(stack_t __user *uss, unsigned long sp)
 {
 	struct task_struct *t = current;
+
 	return  __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
 		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
@@ -3268,6 +3284,7 @@ int compat_restore_altstack(const compat_stack_t __user *uss)
 int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
 {
 	struct task_struct *t = current;
+
 	return  __put_user(ptr_to_compat((void __user *)t->sas_ss_sp), &uss->ss_sp) |
 		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
 		__put_user(t->sas_ss_size, &uss->ss_size);
@@ -3372,6 +3389,7 @@ SYSCALL_DEFINE4(rt_sigaction, int, sig,
 out:
 	return ret;
 }
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 		       const struct compat_sigaction __user *, act,
@@ -3391,6 +3409,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 
 	if (act) {
 		compat_uptr_t handler;
+
 		ret = get_user(handler, &act->sa_handler);
 		new_ka.sa.sa_handler = compat_ptr(handler);
 #ifdef __ARCH_HAS_SA_RESTORER
@@ -3431,6 +3450,7 @@ SYSCALL_DEFINE3(sigaction, int, sig,
 
 	if (act) {
 		old_sigset_t mask;
+
 		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
 		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
 		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer) ||
@@ -3610,6 +3630,7 @@ COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_
 SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
 {
 	sigset_t blocked;
+
 	siginitset(&blocked, mask);
 	return sigsuspend(&blocked);
 }
@@ -3618,6 +3639,7 @@ SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
 SYSCALL_DEFINE3(sigsuspend, int, unused1, int, unused2, old_sigset_t, mask)
 {
 	sigset_t blocked;
+
 	siginitset(&blocked, mask);
 	return sigsuspend(&blocked);
 }
@@ -3646,6 +3668,7 @@ kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
 {
 	static struct task_struct *kdb_prev_t;
 	int sig, new_t;
+
 	if (!spin_trylock(&t->sighand->siglock)) {
 		kdb_printf("Can't do kill command now.\n"
 			   "The sigmask lock is held somewhere else in "
-- 
2.1.2


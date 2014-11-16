Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaKPUMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:12:35 -0500
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:44664 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750865AbaKPUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:4:41:69:355:379:541:800:960:968:973:981:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2640:2737:2896:3138:3139:3140:3141:3142:3865:3866:3867:3868:3871:3872:3874:4250:4321:4419:4605:5007:6119:6261:7875:7903:7904:8603:10004:10848:11026:11473:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12683:13868:14096:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tub61_545d95cf64a07
X-Filterd-Recvd-Size: 15309
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 06/16] signal: Use consistent function definition style
Date: Sun, 16 Nov 2014 12:09:13 -0800
Message-Id: <9dfe65bf5ead467b4408b7c31636ee7b022d29e8.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file has a mixture of function definition styles.
Standardize on having the return value on the same line.

Convert the SYSCALL style to have the declarator on the
first line and the arguments on separate lines.

Remove an unnecessary #else block by moving #ifdef/#endif
inside a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 153 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 92 insertions(+), 61 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 49562b2..eb0a7c5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -359,8 +359,8 @@ static bool task_participate_group_stop(struct task_struct *task)
  * - this may be called without locks if and only if t == current, otherwise an
  *   appropriate lock must be held to stop the target task from exiting
  */
-static struct sigqueue *
-__sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimit)
+static struct sigqueue *__sigqueue_alloc(int sig, struct task_struct *t,
+					 gfp_t flags, int override_rlimit)
 {
 	struct sigqueue *q = NULL;
 	struct user_struct *user;
@@ -483,8 +483,7 @@ void ignore_signals(struct task_struct *t)
  * Flush all handlers for a task.
  */
 
-void
-flush_signal_handlers(struct task_struct *t, int force_default)
+void flush_signal_handlers(struct task_struct *t, int force_default)
 {
 	int i;
 	struct k_sigaction *ka = &t->sighand->action[0];
@@ -522,8 +521,7 @@ int unhandled_signal(struct task_struct *tsk, int sig)
  * allowed.  priv is a pointer to private data that the notifier routine
  * can use to determine if the signal should be blocked or not.
  */
-void
-block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
+void block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
 {
 	unsigned long flags;
 
@@ -537,8 +535,7 @@ EXPORT_SYMBOL(block_all_signals);
 
 /* Notify the system that blocking has ended. */
 
-void
-unblock_all_signals(void)
+void unblock_all_signals(void)
 {
 	unsigned long flags;
 
@@ -1007,9 +1004,10 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
 	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
 }
 
-#ifdef CONFIG_USER_NS
-static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
+static inline void userns_fixup_signal_uid(struct siginfo *info,
+					   struct task_struct *t)
 {
+#ifdef CONFIG_USER_NS
 	if (current_user_ns() == task_cred_xxx(t, user_ns))
 		return;
 
@@ -1018,15 +1016,11 @@ static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_str
 
 	rcu_read_lock();
 	info->si_uid = from_kuid_munged(task_cred_xxx(t, user_ns),
-					make_kuid(current_user_ns(), info->si_uid));
+					make_kuid(current_user_ns(),
+						  info->si_uid));
 	rcu_read_unlock();
-}
-#else
-static inline void userns_fixup_signal_uid(struct siginfo *info, struct task_struct *t)
-{
-	return;
-}
 #endif
+}
 
 static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			 int group, int from_ancestor_ns)
@@ -1180,14 +1174,13 @@ static int __init setup_print_fatal_signals(char *str)
 
 __setup("print-fatal-signals=", setup_print_fatal_signals);
 
-int
-__group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
+int __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
 	return send_signal(sig, info, p, 1);
 }
 
-static int
-specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+static int specific_send_sig_info(int sig, struct siginfo *info,
+				  struct task_struct *t)
 {
 	return send_signal(sig, info, t, 0);
 }
@@ -1217,8 +1210,7 @@ int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
  * We don't want to have recursive SIGSEGV's etc, for example,
  * that is why we also clear SIGNAL_UNKILLABLE.
  */
-int
-force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
+int force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
 	unsigned long int flags;
 	int ret, blocked, ignored;
@@ -1490,15 +1482,13 @@ EXPORT_SYMBOL(send_sig_info);
 #define __si_special(priv)				\
 	((priv) ? SEND_SIG_PRIV : SEND_SIG_NOINFO)
 
-int
-send_sig(int sig, struct task_struct *p, int priv)
+int send_sig(int sig, struct task_struct *p, int priv)
 {
 	return send_sig_info(sig, __si_special(priv), p);
 }
 EXPORT_SYMBOL(send_sig);
 
-void
-force_sig(int sig, struct task_struct *p)
+void force_sig(int sig, struct task_struct *p)
 {
 	force_sig_info(sig, SEND_SIG_PRIV, p);
 }
@@ -1510,8 +1500,7 @@ EXPORT_SYMBOL(force_sig);
  * the problem was already a SIGSEGV, we'll want to
  * make sure we don't even try to deliver the signal..
  */
-int
-force_sigsegv(int sig, struct task_struct *p)
+int force_sigsegv(int sig, struct task_struct *p)
 {
 	if (sig == SIGSEGV) {
 		unsigned long flags;
@@ -2594,8 +2583,11 @@ EXPORT_SYMBOL(sigprocmask);
  *  @oset: previous value of signal mask if non-null
  *  @sigsetsize: size of sigset_t type
  */
-SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
-		sigset_t __user *, oset, size_t, sigsetsize)
+SYSCALL_DEFINE4(rt_sigprocmask,
+		int, how,
+		sigset_t __user *, nset,
+		sigset_t __user *, oset,
+		size_t, sigsetsize)
 {
 	sigset_t old_set, new_set;
 	int error;
@@ -2625,8 +2617,11 @@ SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE4(rt_sigprocmask, int, how, compat_sigset_t __user *, nset,
-		       compat_sigset_t __user *, oset, compat_size_t, sigsetsize)
+COMPAT_SYSCALL_DEFINE4(rt_sigprocmask,
+		       int, how,
+		       compat_sigset_t __user *, nset,
+		       compat_sigset_t __user *, oset,
+		       compat_size_t, sigsetsize)
 {
 #ifdef __BIG_ENDIAN
 	sigset_t old_set = current->blocked;
@@ -2686,7 +2681,9 @@ static int do_sigpending(void *set, unsigned long sigsetsize)
  *  @uset: stores pending signals
  *  @sigsetsize: size of sigset_t type or larger
  */
-SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, uset, size_t, sigsetsize)
+SYSCALL_DEFINE2(rt_sigpending,
+		sigset_t __user *, uset,
+		size_t, sigsetsize)
 {
 	sigset_t set;
 	int err = do_sigpending(&set, sigsetsize);
@@ -2697,7 +2694,8 @@ SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, uset, size_t, sigsetsize)
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(rt_sigpending, compat_sigset_t __user *, uset,
+COMPAT_SYSCALL_DEFINE2(rt_sigpending,
+		       compat_sigset_t __user *, uset,
 		       compat_size_t, sigsetsize)
 {
 #ifdef __BIG_ENDIAN
@@ -2868,8 +2866,10 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
  *  @uts: upper bound on process time suspension
  *  @sigsetsize: size of sigset_t type
  */
-SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
-		siginfo_t __user *, uinfo, const struct timespec __user *, uts,
+SYSCALL_DEFINE4(rt_sigtimedwait,
+		const sigset_t __user *, uthese,
+		siginfo_t __user *, uinfo,
+		const struct timespec __user *, uts,
 		size_t, sigsetsize)
 {
 	sigset_t these;
@@ -2904,7 +2904,9 @@ SYSCALL_DEFINE4(rt_sigtimedwait, const sigset_t __user *, uthese,
  *  @pid: the PID of the process
  *  @sig: signal to be sent
  */
-SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
+SYSCALL_DEFINE2(kill,
+		pid_t, pid,
+		int, sig)
 {
 	struct siginfo info;
 
@@ -2917,8 +2919,8 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 	return kill_something_info(sig, &info, pid);
 }
 
-static int
-do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
+static int do_send_specific(pid_t tgid, pid_t pid, int sig,
+			    struct siginfo *info)
 {
 	struct task_struct *p;
 	int error = -ESRCH;
@@ -2970,7 +2972,10 @@ static int do_tkill(pid_t tgid, pid_t pid, int sig)
  *  exists but it's not belonging to the target process anymore. This
  *  method solves the problem of threads exiting and PIDs getting reused.
  */
-SYSCALL_DEFINE3(tgkill, pid_t, tgid, pid_t, pid, int, sig)
+SYSCALL_DEFINE3(tgkill,
+		pid_t, tgid,
+		pid_t, pid,
+		int, sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0 || tgid <= 0)
@@ -2986,7 +2991,9 @@ SYSCALL_DEFINE3(tgkill, pid_t, tgid, pid_t, pid, int, sig)
  *
  *  Send a signal to only one task, even if it's a CLONE_THREAD task.
  */
-SYSCALL_DEFINE2(tkill, pid_t, pid, int, sig)
+SYSCALL_DEFINE2(tkill,
+		pid_t, pid,
+		int, sig)
 {
 	/* This is only valid for single tasks */
 	if (pid <= 0)
@@ -3018,7 +3025,9 @@ static int do_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t *info)
  *  @sig: signal to be sent
  *  @uinfo: signal info to be sent
  */
-SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
+SYSCALL_DEFINE3(rt_sigqueueinfo,
+		pid_t, pid,
+		int, sig,
 		siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
@@ -3063,7 +3072,10 @@ static int do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 	return do_send_specific(tgid, pid, sig, info);
 }
 
-SYSCALL_DEFINE4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
+SYSCALL_DEFINE4(rt_tgsigqueueinfo,
+		pid_t, tgid,
+		pid_t, pid,
+		int, sig,
 		siginfo_t __user *, uinfo)
 {
 	siginfo_t info;
@@ -3153,8 +3165,8 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 	return 0;
 }
 
-static int
-do_sigaltstack(const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
+static int do_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+			  unsigned long sp)
 {
 	stack_t oss;
 	int error;
@@ -3219,7 +3231,9 @@ out:
 	return error;
 }
 
-SYSCALL_DEFINE2(sigaltstack, const stack_t __user *, uss, stack_t __user *, uoss)
+SYSCALL_DEFINE2(sigaltstack,
+		const stack_t __user *, uss,
+		stack_t __user *, uoss)
 {
 	return do_sigaltstack(uss, uoss, current_user_stack_pointer());
 }
@@ -3298,7 +3312,8 @@ int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
  *  sys_sigpending - examine pending signals
  *  @set: where mask of pending signal is returned
  */
-SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
+SYSCALL_DEFINE1(sigpending,
+		old_sigset_t __user *, set)
 {
 	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t));
 }
@@ -3316,7 +3331,9 @@ SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
  * others support only sys_rt_sigprocmask.
  */
 
-SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, nset,
+SYSCALL_DEFINE3(sigprocmask,
+		int, how,
+		old_sigset_t __user *, nset,
 		old_sigset_t __user *, oset)
 {
 	old_sigset_t old_set, new_set;
@@ -3364,7 +3381,8 @@ SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, nset,
  *  @oact: used to save the previous sigaction
  *  @sigsetsize: size of sigset_t type
  */
-SYSCALL_DEFINE4(rt_sigaction, int, sig,
+SYSCALL_DEFINE4(rt_sigaction,
+		int, sig,
 		const struct sigaction __user *, act,
 		struct sigaction __user *, oact,
 		size_t, sigsetsize)
@@ -3392,7 +3410,8 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
+COMPAT_SYSCALL_DEFINE4(rt_sigaction,
+		       int, sig,
 		       const struct compat_sigaction __user *, act,
 		       struct compat_sigaction __user *, oact,
 		       compat_size_t, sigsetsize)
@@ -3442,7 +3461,8 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 #endif /* !CONFIG_ODD_RT_SIGACTION */
 
 #ifdef CONFIG_OLD_SIGACTION
-SYSCALL_DEFINE3(sigaction, int, sig,
+SYSCALL_DEFINE3(sigaction,
+		int, sig,
 		const struct old_sigaction __user *, act,
 		struct old_sigaction __user *, oact)
 {
@@ -3479,7 +3499,8 @@ SYSCALL_DEFINE3(sigaction, int, sig,
 }
 #endif
 #ifdef CONFIG_COMPAT_OLD_SIGACTION
-COMPAT_SYSCALL_DEFINE3(sigaction, int, sig,
+COMPAT_SYSCALL_DEFINE3(sigaction,
+		       int, sig,
 		       const struct compat_old_sigaction __user *, act,
 		       struct compat_old_sigaction __user *, oact)
 {
@@ -3531,7 +3552,8 @@ SYSCALL_DEFINE0(sgetmask)
 	return current->blocked.sig[0];
 }
 
-SYSCALL_DEFINE1(ssetmask, int, newmask)
+SYSCALL_DEFINE1(ssetmask,
+		int, newmask)
 {
 	int old = current->blocked.sig[0];
 	sigset_t newset;
@@ -3547,7 +3569,9 @@ SYSCALL_DEFINE1(ssetmask, int, newmask)
 /*
  * For backwards compatibility.  Functionality superseded by sigaction.
  */
-SYSCALL_DEFINE2(signal, int, sig, __sighandler_t, handler)
+SYSCALL_DEFINE2(signal,
+		int, sig,
+		__sighandler_t, handler)
 {
 	struct k_sigaction new_sa, old_sa;
 	int ret;
@@ -3592,7 +3616,9 @@ int sigsuspend(sigset_t *set)
  *  @unewset: new signal mask value
  *  @sigsetsize: size of sigset_t type
  */
-SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
+SYSCALL_DEFINE2(rt_sigsuspend,
+		sigset_t __user *, unewset,
+		size_t, sigsetsize)
 {
 	sigset_t newset;
 
@@ -3606,7 +3632,9 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_size_t, sigsetsize)
+COMPAT_SYSCALL_DEFINE2(rt_sigsuspend,
+		       compat_sigset_t __user *, unewset,
+		       compat_size_t, sigsetsize)
 {
 #ifdef __BIG_ENDIAN
 	sigset_t newset;
@@ -3628,7 +3656,8 @@ COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_
 #endif
 
 #ifdef CONFIG_OLD_SIGSUSPEND
-SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
+SYSCALL_DEFINE1(sigsuspend,
+		old_sigset_t, mask)
 {
 	sigset_t blocked;
 
@@ -3637,7 +3666,10 @@ SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
 }
 #endif
 #ifdef CONFIG_OLD_SIGSUSPEND3
-SYSCALL_DEFINE3(sigsuspend, int, unused1, int, unused2, old_sigset_t, mask)
+SYSCALL_DEFINE3(sigsuspend,
+		int, unused1,
+		int, unused2,
+		old_sigset_t, mask)
 {
 	sigset_t blocked;
 
@@ -3664,8 +3696,7 @@ void __init signals_init(void)
  * available before calling the main signal code, to avoid kdb
  * deadlocks.
  */
-void
-kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
+void kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
 {
 	static struct task_struct *kdb_prev_t;
 	int sig, new_t;
-- 
2.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaKPUKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:10:06 -0500
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:44727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbaKPUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:10:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3867:3868:3871:3872:3873:4050:4119:4321:4385:4605:5007:6261:7901:10004:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:14096:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ball21_5740afe6a7b2e
X-Filterd-Recvd-Size: 8096
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 15/16] signal: Isolate returns by adding blank lines
Date: Sun, 16 Nov 2014 12:09:22 -0800
Message-Id: <1addf7c90163c0f912d4500657c86cd5bffafbb1.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the return statements a bit more obvious.

Move initializations to variable definitions where appropriate
and separate them when not.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 52 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 739d261..1b0d3b0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -131,6 +131,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 		ready  = signal->sig[0] & ~blocked->sig[0];
 		break;
 	}
+
 	return ready !=	0;
 }
 
@@ -677,6 +678,7 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 		do_schedule_next_timer(info);
 		spin_lock(&tsk->sighand->siglock);
 	}
+
 	return signr;
 }
 EXPORT_SYMBOL_GPL(dequeue_signal);
@@ -728,6 +730,7 @@ static int flush_sigqueue_mask(sigset_t *mask, struct sigpending *s)
 			__sigqueue_free(q);
 		}
 	}
+
 	return 1;
 }
 
@@ -739,7 +742,7 @@ static inline int is_si_special(const struct siginfo *info)
 static inline bool si_fromuser(const struct siginfo *info)
 {
 	return info == SEND_SIG_NOINFO ||
-		(!is_si_special(info) && SI_FROMUSER(info));
+	       (!is_si_special(info) && SI_FROMUSER(info));
 }
 
 /*
@@ -1327,16 +1330,16 @@ int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
 {
 	struct task_struct *p = NULL;
-	int retval, success;
+	int retval = -ESRCH;
+	int success = 0;
 
-	success = 0;
-	retval = -ESRCH;
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 		int err = group_send_sig_info(sig, info, p);
 
 		success |= !err;
 		retval = err;
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
+
 	return success ? 0 : retval;
 }
 
@@ -1369,6 +1372,7 @@ int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
 	rcu_read_lock();
 	error = kill_pid_info(sig, info, find_vpid(pid));
 	rcu_read_unlock();
+
 	return error;
 }
 
@@ -1514,6 +1518,7 @@ int force_sigsegv(int sig, struct task_struct *p)
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 	force_sig(SIGSEGV, p);
+
 	return 0;
 }
 
@@ -2372,6 +2377,7 @@ relock:
 	spin_unlock_irq(&sighand->siglock);
 
 	ksig->sig = signr;
+
 	return ksig->sig > 0;
 }
 
@@ -2577,6 +2583,7 @@ int sigprocmask(int how, sigset_t *set, sigset_t *oldset)
 	}
 
 	__set_current_blocked(&newset);
+
 	return 0;
 }
 EXPORT_SYMBOL(sigprocmask);
@@ -2657,6 +2664,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigprocmask,
 		if (copy_to_user(oset, &old32, sizeof(compat_sigset_t)))
 			return -EFAULT;
 	}
+
 	return 0;
 #else
 	return sys_rt_sigprocmask(how, (sigset_t __user *)nset,
@@ -2677,6 +2685,7 @@ static int do_sigpending(void *set, unsigned long sigsetsize)
 
 	/* Outside the lock because only this thread touches it.  */
 	sigandsets(set, &current->blocked, set);
+
 	return 0;
 }
 
@@ -2695,6 +2704,7 @@ SYSCALL_DEFINE2(rt_sigpending,
 
 	if (!err && copy_to_user(uset, &set, sigsetsize))
 		err = -EFAULT;
+
 	return err;
 }
 
@@ -2715,6 +2725,7 @@ COMPAT_SYSCALL_DEFINE2(rt_sigpending,
 		if (copy_to_user(uset, &set32, sigsetsize))
 			err = -EFAULT;
 	}
+
 	return err;
 #else
 	return sys_rt_sigpending((sigset_t __user *)uset, sigsetsize);
@@ -2730,9 +2741,12 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(siginfo_t)))
 		return -EFAULT;
-	if (from->si_code < 0)
-		return __copy_to_user(to, from, sizeof(siginfo_t))
-			? -EFAULT : 0;
+	if (from->si_code < 0) {
+		if (__copy_to_user(to, from, sizeof(siginfo_t)))
+			return -EFAULT;
+		return 0;
+	}
+
 	/*
 	 * If you change siginfo_t structure, please be sure
 	 * this code is fixed accordingly.
@@ -2799,6 +2813,7 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 		err |= __put_user(from->si_uid, &to->si_uid);
 		break;
 	}
+
 	return err;
 }
 
@@ -2861,6 +2876,7 @@ int do_sigtimedwait(const sigset_t *which, siginfo_t *info,
 
 	if (sig)
 		return sig;
+
 	return timeout ? -EINTR : -EAGAIN;
 }
 
@@ -3040,6 +3056,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo,
 
 	if (copy_from_user(&info, uinfo, sizeof(siginfo_t)))
 		return -EFAULT;
+
 	return do_rt_sigqueueinfo(pid, sig, &info);
 }
 
@@ -3050,10 +3067,12 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
 		       struct compat_siginfo __user *, uinfo)
 {
 	siginfo_t info;
-	int ret = copy_siginfo_from_user32(&info, uinfo);
+	int ret;
 
+	ret = copy_siginfo_from_user32(&info, uinfo);
 	if (unlikely(ret))
 		return ret;
+
 	return do_rt_sigqueueinfo(pid, sig, &info);
 }
 #endif
@@ -3168,6 +3187,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 	}
 
 	spin_unlock_irq(&p->sighand->siglock);
+
 	return 0;
 }
 
@@ -3257,9 +3277,9 @@ int __save_altstack(stack_t __user *uss, unsigned long sp)
 {
 	struct task_struct *t = current;
 
-	return  __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
-		__put_user(sas_ss_flags(sp), &uss->ss_flags) |
-		__put_user(t->sas_ss_size, &uss->ss_size);
+	return __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
+	       __put_user(sas_ss_flags(sp), &uss->ss_flags) |
+	       __put_user(t->sas_ss_size, &uss->ss_size);
 }
 
 #ifdef CONFIG_COMPAT
@@ -3295,6 +3315,7 @@ COMPAT_SYSCALL_DEFINE2(sigaltstack,
 		    __put_user(uoss.ss_size, &uoss_ptr->ss_size))
 			ret = -EFAULT;
 	}
+
 	return ret;
 }
 
@@ -3415,6 +3436,7 @@ SYSCALL_DEFINE4(rt_sigaction,
 		if (copy_to_user(oact, &old_sa.sa, sizeof(old_sa.sa)))
 			return -EFAULT;
 	}
+
 out:
 	return ret;
 }
@@ -3465,6 +3487,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction,
 				&oact->sa_restorer);
 #endif
 	}
+
 	return ret;
 }
 #endif
@@ -3547,6 +3570,7 @@ COMPAT_SYSCALL_DEFINE3(sigaction,
 		    __put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask))
 			return -EFAULT;
 	}
+
 	return ret;
 }
 #endif
@@ -3604,6 +3628,7 @@ SYSCALL_DEFINE0(pause)
 		current->state = TASK_INTERRUPTIBLE;
 		schedule();
 	}
+
 	return -ERESTARTNOHAND;
 }
 
@@ -3617,6 +3642,7 @@ int sigsuspend(sigset_t *set)
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
 	set_restore_sigmask();
+
 	return -ERESTARTNOHAND;
 }
 
@@ -3638,6 +3664,7 @@ SYSCALL_DEFINE2(rt_sigsuspend,
 
 	if (copy_from_user(&newset, unewset, sizeof(newset)))
 		return -EFAULT;
+
 	return sigsuspend(&newset);
 }
 
@@ -3657,6 +3684,7 @@ COMPAT_SYSCALL_DEFINE2(rt_sigsuspend,
 	if (copy_from_user(&newset32, unewset, sizeof(compat_sigset_t)))
 		return -EFAULT;
 	sigset_from_compat(&newset, &newset32);
+
 	return sigsuspend(&newset);
 #else
 	/* on little-endian bitmaps don't care about granularity */
@@ -3672,6 +3700,7 @@ SYSCALL_DEFINE1(sigsuspend,
 	sigset_t blocked;
 
 	siginitset(&blocked, mask);
+
 	return sigsuspend(&blocked);
 }
 #endif
@@ -3684,6 +3713,7 @@ SYSCALL_DEFINE3(sigsuspend,
 	sigset_t blocked;
 
 	siginitset(&blocked, mask);
+
 	return sigsuspend(&blocked);
 }
 #endif
-- 
2.1.2


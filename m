Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaKPUNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:13:18 -0500
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:33002 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750761AbaKPUJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:35 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3872:3874:4385:5007:6261:7875:8660:9010:9592:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13148:13230:13868:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sleet68_5370d1db5555c
X-Filterd-Recvd-Size: 3752
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 03/16] signal: Move EXPORT_SYMBOL after function definition
Date: Sun, 16 Nov 2014 12:09:10 -0800
Message-Id: <6984848fc7e9091e9945ff7d8f36f7c803eab469.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index abb2bcd..969c6ba 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -160,6 +160,7 @@ void recalc_sigpending(void)
 	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 }
+EXPORT_SYMBOL(recalc_sigpending);
 
 /* Given the mask, find the first available signal that should be serviced. */
 
@@ -430,6 +431,7 @@ void flush_signals(struct task_struct *t)
 	__flush_signals(t);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 }
+EXPORT_SYMBOL(flush_signals);
 
 static void __flush_itimer_signals(struct sigpending *pending)
 {
@@ -529,6 +531,7 @@ block_all_signals(int (*notifier)(void *priv), void *priv, sigset_t *mask)
 	current->notifier = notifier;
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
+EXPORT_SYMBOL(block_all_signals);
 
 /* Notify the system that blocking has ended. */
 
@@ -543,6 +546,7 @@ unblock_all_signals(void)
 	recalc_sigpending();
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
+EXPORT_SYMBOL(unblock_all_signals);
 
 static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
@@ -676,6 +680,7 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 	}
 	return signr;
 }
+EXPORT_SYMBOL_GPL(dequeue_signal);
 
 /*
  * Tell a process that it has a new active signal..
@@ -1478,6 +1483,7 @@ int send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 
 	return do_send_sig_info(sig, info, p, false);
 }
+EXPORT_SYMBOL(send_sig_info);
 
 #define __si_special(priv)				\
 	((priv) ? SEND_SIG_PRIV : SEND_SIG_NOINFO)
@@ -1487,12 +1493,14 @@ send_sig(int sig, struct task_struct *p, int priv)
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
@@ -2488,16 +2496,6 @@ out:
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
 /*
  * System call entry points.
  */
@@ -2585,6 +2583,7 @@ int sigprocmask(int how, sigset_t *set, sigset_t *oldset)
 	__set_current_blocked(&newset);
 	return 0;
 }
+EXPORT_SYMBOL(sigprocmask);
 
 /**
  *  sys_rt_sigprocmask - change the list of currently blocked signals
-- 
2.1.2


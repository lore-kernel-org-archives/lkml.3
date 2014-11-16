Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaKPUKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:10:44 -0500
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:41765 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751510AbaKPUKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:10:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2737:3138:3139:3140:3141:3142:3352:3865:3867:3870:3871:3873:5007:6119:6261:6691:7903:10004:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555:13311:13357:14093:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sink37_579f956d78533
X-Filterd-Recvd-Size: 2579
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 16/16] signal: Coalesce kdb_printf formats
Date: Sun, 16 Nov 2014 12:09:23 -0800
Message-Id: <c34db3ea88a948e3092195fd228ec033a993aa10.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the strings a bit more findable.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 1b0d3b0..7d5075a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3743,27 +3743,22 @@ void kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
 
 	if (!spin_trylock(&t->sighand->siglock)) {
 		kdb_printf("Can't do kill command now.\n"
-			   "The sigmask lock is held somewhere else in "
-			   "kernel, try again later\n");
+			   "The sigmask lock is held somewhere else in kernel, try again later.\n");
 		return;
 	}
 	spin_unlock(&t->sighand->siglock);
 	new_t = kdb_prev_t != t;
 	kdb_prev_t = t;
 	if (t->state != TASK_RUNNING && new_t) {
-		kdb_printf("Process is not RUNNING, sending a signal from "
-			   "kdb risks deadlock\n"
-			   "on the run queue locks. "
-			   "The signal has _not_ been sent.\n"
-			   "Reissue the kill command if you want to risk "
-			   "the deadlock.\n");
+		kdb_printf("Process is not RUNNING, sending a signal from kdb risks deadlock on the run queue locks. The signal has _not_ been sent.\n"
+			   "Reissue the kill command if you want to risk the deadlock.\n");
 		return;
 	}
 	sig = info->si_signo;
 	if (send_sig_info(sig, info, t))
-		kdb_printf("Fail to deliver Signal %d to process %d.\n",
+		kdb_printf("Fail to deliver Signal %d to process %d\n",
 			   sig, t->pid);
 	else
-		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
+		kdb_printf("Signal %d is sent to process %d\n", sig, t->pid);
 }
 #endif	/* CONFIG_KGDB_KDB */
-- 
2.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbaKPUJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:46 -0500
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:33369 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751242AbaKPUJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2693:3138:3139:3140:3141:3142:3353:3865:3867:3868:3871:3872:4321:5007:6119:6261:7903:10004:10848:11026:11658:11914:12296:12438:12517:12519:12555:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: unit98_54cd45e1adf0c
X-Filterd-Recvd-Size: 2624
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 07/16] signal: Add braces
Date: Sun, 16 Nov 2014 12:09:14 -0800
Message-Id: <39dc1487998dd99ab1eef612bad7d3fa90c1f243.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add braces to arms where other arms have them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index eb0a7c5..baddb92 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -934,15 +934,15 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * If the main thread wants the signal, it gets first crack.
 	 * Probably the least surprising to the average bear.
 	 */
-	if (wants_signal(sig, p))
+	if (wants_signal(sig, p)) {
 		t = p;
-	else if (!group || thread_group_empty(p))
+	} else if (!group || thread_group_empty(p)) {
 		/*
 		 * There is just one thread and it does not need to be woken.
 		 * It will dequeue unblocked signals before it runs again.
 		 */
 		return;
-	else {
+	} else {
 		/*
 		 * Otherwise try to find a suitable thread.
 		 */
@@ -1411,8 +1411,9 @@ int kill_pid_info_as_cred(int sig, struct siginfo *info, struct pid *pid,
 		if (lock_task_sighand(p, &flags)) {
 			ret = __send_signal(sig, info, p, 1, 0);
 			unlock_task_sighand(p, &flags);
-		} else
+		} else {
 			ret = -ESRCH;
+		}
 	}
 out_unlock:
 	rcu_read_unlock();
@@ -1675,11 +1676,11 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_stime = cputime_to_clock_t(stime + tsk->signal->stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
-	if (tsk->exit_code & 0x80)
+	if (tsk->exit_code & 0x80) {
 		info.si_code = CLD_DUMPED;
-	else if (tsk->exit_code & 0x7f)
+	} else if (tsk->exit_code & 0x7f) {
 		info.si_code = CLD_KILLED;
-	else {
+	} else {
 		info.si_code = CLD_EXITED;
 		info.si_status = tsk->exit_code >> 8;
 	}
-- 
2.1.2


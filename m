Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3KQJzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:55:45 -0500
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:36274 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751850Ab3KQJzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:55:19 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2904:3138:3139:3140:3141:3142:3352:3867:3870:3872:4605:5007:6119:6238:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: silk40_1139e2ee32d1f
X-Filterd-Recvd-Size: 2088
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] softirq: Convert printks to pr_<level>
Date: Sun, 17 Nov 2013 01:55:11 -0800
Message-Id: <356e6a8379c6d205586679156cd7c1db19d677bd.1384656563.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1384656563.git.joe@perches.com>
References: <cover.1384656563.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/softirq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7be95d7..49a44cb 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -8,6 +8,8 @@
  *	Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/export.h>
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
@@ -258,7 +260,7 @@ restart:
 		h->action(h);
 		trace_softirq_exit(vec_nr);
 		if (unlikely(prev_count != preempt_count())) {
-			printk(KERN_ERR "huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
+			pr_err("huh, entered softirq %u %s %p with preempt_count %08x, exited with %08x?\n",
 			       vec_nr, softirq_to_name[vec_nr], h->action,
 			       prev_count, preempt_count());
 			preempt_count_set(prev_count);
@@ -562,7 +564,7 @@ EXPORT_SYMBOL(tasklet_init);
 void tasklet_kill(struct tasklet_struct *t)
 {
 	if (in_interrupt())
-		printk("Attempt to kill tasklet from interrupt\n");
+		pr_notice("Attempt to kill tasklet from interrupt\n");
 
 	while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
 		do {
-- 
1.8.1.2.459.gbcd45b4.dirty


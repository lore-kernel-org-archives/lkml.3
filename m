Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab3CDNEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:04:21 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65249 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab3CDM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:17 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -v3 07/23] kernel/: rename random32() to prandom_u32()
Date: Mon,  4 Mar 2013 21:58:15 +0900
Message-Id: <1362401911-14074-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---

No change from v2

 kernel/rcutree.c      | 2 +-
 kernel/test_kprobes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b8ad82..2f8530b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1319,7 +1319,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 #ifdef CONFIG_PROVE_RCU_DELAY
-		if ((random32() % (rcu_num_nodes * 8)) == 0)
+		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0)
 			schedule_timeout_uninterruptible(2);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
index f8b11a2..12d6ebb 100644
--- a/kernel/test_kprobes.c
+++ b/kernel/test_kprobes.c
@@ -365,7 +365,7 @@ int init_test_probes(void)
 	target2 = kprobe_target2;
 
 	do {
-		rand1 = random32();
+		rand1 = prandom_u32();
 	} while (rand1 <= div_factor);
 
 	printk(KERN_INFO "Kprobe smoke test started\n");
-- 
1.8.1.2


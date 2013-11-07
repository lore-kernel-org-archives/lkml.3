Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3KGTDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:03:44 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53912 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3KGTDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:03:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH-next] block/blk-mq: remove newly added instances of __cpuinit
Date: Thu, 7 Nov 2013 14:04:18 -0500
Message-ID: <1383851058-11688-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.rc0.44.gf26f72d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 320ae51feed5c2f13664aa05a76bec198967e04d [Nov7 linux-next
via "Merge remote-tracking branch 'block/for-next'"] adds
"blk-mq: new multi-queue block IO queueing mechanism".  This
commit added new instances of __cpuinit usage.

We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what
we want to see at this point in time, as it will break once
the stubs are gone.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Feel free to squish this into the original commit if there happens
 to be a rebase taking place for some other reason anyway... ]

 block/blk-mq-cpu.c | 4 ++--
 block/blk-mq.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq-cpu.c b/block/blk-mq-cpu.c
index 4f0c352..7e48c97 100644
--- a/block/blk-mq-cpu.c
+++ b/block/blk-mq-cpu.c
@@ -13,7 +13,7 @@
 static LIST_HEAD(blk_mq_cpu_notify_list);
 static DEFINE_SPINLOCK(blk_mq_cpu_notify_lock);
 
-static int __cpuinit blk_mq_main_cpu_notify(struct notifier_block *self,
+static int blk_mq_main_cpu_notify(struct notifier_block *self,
 					    unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long) hcpu;
@@ -28,7 +28,7 @@ static int __cpuinit blk_mq_main_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata blk_mq_main_cpu_notifier = {
+static struct notifier_block blk_mq_main_cpu_notifier = {
 	.notifier_call	= blk_mq_main_cpu_notify,
 };
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 757b8d1..b1c1abc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1403,7 +1403,7 @@ void blk_mq_free_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_mq_free_queue);
 
 /* Basically redo blk_mq_init_queue with queue frozen */
-static void __cpuinit blk_mq_queue_reinit(struct request_queue *q)
+static void blk_mq_queue_reinit(struct request_queue *q)
 {
 	blk_mq_freeze_queue(q);
 
@@ -1420,7 +1420,7 @@ static void __cpuinit blk_mq_queue_reinit(struct request_queue *q)
 	blk_mq_unfreeze_queue(q);
 }
 
-static int __cpuinit blk_mq_queue_reinit_notify(struct notifier_block *nb,
+static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
 		unsigned long action, void *hcpu)
 {
 	struct request_queue *q;
-- 
1.8.4.1


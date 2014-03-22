Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaCVUcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:32:22 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54691 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaCVUcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:32:21 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] block: Use RCU_INIT_POINTER(x, NULL) in partition-generic.c
Date: Sun, 23 Mar 2014 02:01:23 +0530
Message-Id: <1395520283-2991-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 block/partition-generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 789cdea..f1ef057 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -249,8 +249,8 @@ void delete_partition(struct gendisk *disk, int partno)
 	if (!part)
 		return;
 
-	rcu_assign_pointer(ptbl->part[partno], NULL);
-	rcu_assign_pointer(ptbl->last_lookup, NULL);
+	RCU_INIT_POINTER(ptbl->part[partno], NULL);
+	RCU_INIT_POINTER(ptbl->last_lookup, NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 	blk_free_devt(part_devt(part));
-- 
1.7.9.5


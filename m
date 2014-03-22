Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaCVUbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:31:21 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35449 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaCVUbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:31:18 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] block: Use RCU_INIT_POINTER(x, NULL) in genhd.c
Date: Sun, 23 Mar 2014 02:00:18 +0530
Message-Id: <1395520218-2902-1-git-send-email-monamagarwal123@gmail.com>
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
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 791f419..3aec057 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1045,7 +1045,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
 	rcu_assign_pointer(disk->part_tbl, new_ptbl);
 
 	if (old_ptbl) {
-		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
+		RCU_INIT_POINTER(old_ptbl->last_lookup, NULL);
 		kfree_rcu(old_ptbl, rcu_head);
 	}
 }
-- 
1.7.9.5


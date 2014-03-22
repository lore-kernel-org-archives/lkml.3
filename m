Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983AbaCVHE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 03:04:59 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42013 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaCVHE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 03:04:56 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] block: Use RCU_INIT_POINTER(x, NULL) in blk-cgroup.c
Date: Sat, 22 Mar 2014 12:33:58 +0530
Message-Id: <1395471838-3099-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

Since rcu_assign_pointer() is to ensure that the initialization of a structure 
is carried out before storing a pointer to that structure. So, rcu_assign_pointer(p, NULL) 
can be safely converted to RCU_INIT_POINTER(p, NULL).

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 block/blk-cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4e491d9..fc62c47 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -337,7 +337,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	 * will.  Hint assignment itself can race safely.
 	 */
 	if (rcu_dereference_raw(blkcg->blkg_hint) == blkg)
-		rcu_assign_pointer(blkcg->blkg_hint, NULL);
+		RCU_INIT_POINTER(blkcg->blkg_hint, NULL);
 
 	/*
 	 * If root blkg is destroyed.  Just clear the pointer since root_rl
-- 
1.7.9.5


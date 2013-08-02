Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3HBB5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:57:08 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48533 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3HBB5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:57:06 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-8d-51fb11efe694
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Joonsoo Kim <js1304@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/2] mm, vmalloc: remove useless variable in vmap_block
Date: Fri,  2 Aug 2013 10:57:00 +0900
Message-Id: <1375408621-16563-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vbq in vmap_block isn't used. So remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 13a5495..d23c432 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -752,7 +752,6 @@ struct vmap_block_queue {
 struct vmap_block {
 	spinlock_t lock;
 	struct vmap_area *va;
-	struct vmap_block_queue *vbq;
 	unsigned long free, dirty;
 	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
 	struct list_head free_list;
@@ -830,7 +829,6 @@ static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
 	radix_tree_preload_end();
 
 	vbq = &get_cpu_var(vmap_block_queue);
-	vb->vbq = vbq;
 	spin_lock(&vbq->lock);
 	list_add_rcu(&vb->free_list, &vbq->free);
 	spin_unlock(&vbq->lock);
-- 
1.7.9.5


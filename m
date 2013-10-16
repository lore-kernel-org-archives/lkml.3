Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321Ab3JPIo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:44:27 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46536 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3JPIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:44:20 -0400
X-AuditID: 9c930179-b7c78ae000003065-83-525e51dd353c
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 07/15] slab: use well-defined macro, virt_to_slab()
Date: Wed, 16 Oct 2013 17:44:04 +0900
Message-Id: <1381913052-23875-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is trivial change, just use well-defined macro.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 84c4ed6..f9e676e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2865,7 +2865,6 @@ static inline void verify_redzone_free(struct kmem_cache *cache, void *obj)
 static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 				   unsigned long caller)
 {
-	struct page *page;
 	unsigned int objnr;
 	struct slab *slabp;
 
@@ -2873,9 +2872,7 @@ static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 
 	objp -= obj_offset(cachep);
 	kfree_debugcheck(objp);
-	page = virt_to_head_page(objp);
-
-	slabp = page->slab_page;
+	slabp = virt_to_slab(objp);
 
 	if (cachep->flags & SLAB_RED_ZONE) {
 		verify_redzone_free(cachep, objp);
@@ -3087,7 +3084,7 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 		struct slab *slabp;
 		unsigned objnr;
 
-		slabp = virt_to_head_page(objp)->slab_page;
+		slabp = virt_to_slab(objp);
 		objnr = (unsigned)(objp - slabp->s_mem) / cachep->size;
 		slab_bufctl(slabp)[objnr] = BUFCTL_ACTIVE;
 	}
-- 
1.7.9.5


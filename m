Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3HVIvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:51:17 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57101 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3HVIoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:23 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-57-5215cf62a7b7
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 08/16] slab: use well-defined macro, virt_to_slab()
Date: Thu, 22 Aug 2013 17:44:17 +0900
Message-Id: <1377161065-30552-9-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is trivial change, just use well-defined macro.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 9e98ee0..ee03eba 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2853,7 +2853,6 @@ static inline void verify_redzone_free(struct kmem_cache *cache, void *obj)
 static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 				   unsigned long caller)
 {
-	struct page *page;
 	unsigned int objnr;
 	struct slab *slabp;
 
@@ -2861,9 +2860,7 @@ static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 
 	objp -= obj_offset(cachep);
 	kfree_debugcheck(objp);
-	page = virt_to_head_page(objp);
-
-	slabp = page->slab_page;
+	slabp = virt_to_slab(objp);
 
 	if (cachep->flags & SLAB_RED_ZONE) {
 		verify_redzone_free(cachep, objp);
@@ -3075,7 +3072,7 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 		struct slab *slabp;
 		unsigned objnr;
 
-		slabp = virt_to_head_page(objp)->slab_page;
+		slabp = virt_to_slab(objp);
 		objnr = (unsigned)(objp - slabp->s_mem) / cachep->size;
 		slab_bufctl(slabp)[objnr] = BUFCTL_ACTIVE;
 	}
-- 
1.7.9.5


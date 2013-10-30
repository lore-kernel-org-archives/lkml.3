Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3J3KD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:03:58 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56869 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3J3KDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:03:52 -0400
X-AuditID: 9c930197-b7b3eae00000122e-0b-5270d9816a03
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 17/15] slab: replace non-existing 'struct freelist *' with 'void *'
Date: Wed, 30 Oct 2013 19:04:01 +0900
Message-Id: <1383127441-30563-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383127441-30563-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1383127441-30563-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no 'strcut freelist', but codes use pointer to 'struct freelist'.
Although compiler doesn't complain anything about this wrong usage and
codes work fine, but fixing it is better.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index a8a9349..a983e30 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1954,7 +1954,7 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep,
  */
 static void slab_destroy(struct kmem_cache *cachep, struct page *page)
 {
-	struct freelist *freelist;
+	void *freelist;
 
 	freelist = page->freelist;
 	slab_destroy_debugcheck(cachep, page);
@@ -2520,11 +2520,11 @@ int __kmem_cache_shutdown(struct kmem_cache *cachep)
  * kmem_find_general_cachep till the initialization is complete.
  * Hence we cannot have freelist_cache same as the original cache.
  */
-static struct freelist *alloc_slabmgmt(struct kmem_cache *cachep,
+static void *alloc_slabmgmt(struct kmem_cache *cachep,
 				   struct page *page, int colour_off,
 				   gfp_t local_flags, int nodeid)
 {
-	struct freelist *freelist;
+	void *freelist;
 	void *addr = page_address(page);
 
 	if (OFF_SLAB(cachep)) {
@@ -2646,7 +2646,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct page *page,
  * virtual address for kfree, ksize, and slab debugging.
  */
 static void slab_map_pages(struct kmem_cache *cache, struct page *page,
-			   struct freelist *freelist)
+			   void *freelist)
 {
 	page->slab_cache = cache;
 	page->freelist = freelist;
@@ -2659,7 +2659,7 @@ static void slab_map_pages(struct kmem_cache *cache, struct page *page,
 static int cache_grow(struct kmem_cache *cachep,
 		gfp_t flags, int nodeid, struct page *page)
 {
-	struct freelist *freelist;
+	void *freelist;
 	size_t offset;
 	gfp_t local_flags;
 	struct kmem_cache_node *n;
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3LND2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:28:05 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46735 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3LND1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:18 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 113/115] ion: Cleanup whitespace issues and other checkpatch problems
Date: Fri, 13 Dec 2013 19:26:33 -0800
Message-Id: <1386991595-6251-21-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some simple cleanups to address whitespace issues and
other issues found w/ checkpatch.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/compat_ion.c      |  4 +-
 drivers/staging/android/ion/ion.c             | 53 ++++++++++++++-------------
 drivers/staging/android/ion/ion.h             |  2 +-
 drivers/staging/android/ion/ion_chunk_heap.c  |  1 -
 drivers/staging/android/ion/ion_heap.c        |  5 +--
 drivers/staging/android/ion/ion_page_pool.c   |  2 +-
 drivers/staging/android/ion/ion_priv.h        |  2 +-
 drivers/staging/android/ion/ion_system_heap.c |  3 +-
 8 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/android/ion/compat_ion.c b/drivers/staging/android/ion/compat_ion.c
index 079a5bb..af6cd37 100644
--- a/drivers/staging/android/ion/compat_ion.c
+++ b/drivers/staging/android/ion/compat_ion.c
@@ -91,8 +91,8 @@ static int compat_get_ion_custom_data(
 			struct compat_ion_custom_data __user *data32,
 			struct ion_custom_data __user *data)
 {
-        compat_uint_t cmd;
-        compat_ulong_t arg;
+	compat_uint_t cmd;
+	compat_ulong_t arg;
 	int err;
 
 	err = get_user(cmd, &data32->cmd);
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 559e4ee..574066f 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -110,8 +110,8 @@ struct ion_handle {
 
 bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer)
 {
-	return ((buffer->flags & ION_FLAG_CACHED) &&
-		!(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC));
+	return (buffer->flags & ION_FLAG_CACHED) &&
+		!(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC);
 }
 
 bool ion_buffer_cached(struct ion_buffer *buffer)
@@ -202,7 +202,8 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	buffer->size = len;
 
 	table = heap->ops->map_dma(heap, buffer);
-	if (WARN_ONCE(table == NULL, "heap->ops->map_dma should return ERR_PTR on error"))
+	if (WARN_ONCE(table == NULL,
+			"heap->ops->map_dma should return ERR_PTR on error"))
 		table = ERR_PTR(-EINVAL);
 	if (IS_ERR(table)) {
 		heap->ops->free(buffer);
@@ -424,7 +425,8 @@ static struct ion_handle *ion_handle_get_by_id(struct ion_client *client,
 	return handle ? handle : ERR_PTR(-EINVAL);
 }
 
-static bool ion_handle_validate(struct ion_client *client, struct ion_handle *handle)
+static bool ion_handle_validate(struct ion_client *client,
+				struct ion_handle *handle)
 {
 	WARN_ON(!mutex_is_locked(&client->lock));
 	return (idr_find(&client->idr, handle->id) == handle);
@@ -578,7 +580,8 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 		return buffer->vaddr;
 	}
 	vaddr = buffer->heap->ops->map_kernel(buffer->heap, buffer);
-	if (WARN_ONCE(vaddr == NULL, "heap->ops->map_kernel should return ERR_PTR on error"))
+	if (WARN_ONCE(vaddr == NULL,
+			"heap->ops->map_kernel should return ERR_PTR on error"))
 		return ERR_PTR(-EINVAL);
 	if (IS_ERR(vaddr))
 		return vaddr;
@@ -1403,39 +1406,39 @@ static const struct file_operations debug_heap_fops = {
 #ifdef DEBUG_HEAP_SHRINKER
 static int debug_shrink_set(void *data, u64 val)
 {
-        struct ion_heap *heap = data;
-        struct shrink_control sc;
-        int objs;
+	struct ion_heap *heap = data;
+	struct shrink_control sc;
+	int objs;
 
-        sc.gfp_mask = -1;
-        sc.nr_to_scan = 0;
+	sc.gfp_mask = -1;
+	sc.nr_to_scan = 0;
 
-        if (!val)
-                return 0;
+	if (!val)
+		return 0;
 
-        objs = heap->shrinker.shrink(&heap->shrinker, &sc);
-        sc.nr_to_scan = objs;
+	objs = heap->shrinker.shrink(&heap->shrinker, &sc);
+	sc.nr_to_scan = objs;
 
-        heap->shrinker.shrink(&heap->shrinker, &sc);
-        return 0;
+	heap->shrinker.shrink(&heap->shrinker, &sc);
+	return 0;
 }
 
 static int debug_shrink_get(void *data, u64 *val)
 {
-        struct ion_heap *heap = data;
-        struct shrink_control sc;
-        int objs;
+	struct ion_heap *heap = data;
+	struct shrink_control sc;
+	int objs;
 
-        sc.gfp_mask = -1;
-        sc.nr_to_scan = 0;
+	sc.gfp_mask = -1;
+	sc.nr_to_scan = 0;
 
-        objs = heap->shrinker.shrink(&heap->shrinker, &sc);
-        *val = objs;
-        return 0;
+	objs = heap->shrinker.shrink(&heap->shrinker, &sc);
+	*val = objs;
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
-                        debug_shrink_set, "%llu\n");
+			debug_shrink_set, "%llu\n");
 #endif
 
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 962e1c5..dcd2a0c 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -38,7 +38,7 @@ struct ion_buffer;
  * struct ion_platform_heap - defines a heap in the given platform
  * @type:	type of the heap from ion_heap_type enum
  * @id:		unique identifier for heap.  When allocating higher numbers
- * 		will be allocated from first.  At allocation these are passed
+ *		will be allocated from first.  At allocation these are passed
  *		as a bit mask and therefore can not exceed ION_NUM_HEAP_IDS.
  * @name:	used for debug purposes
  * @base:	base address of heap in physical memory if applicable
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index a072089..d40f5f8 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -13,7 +13,6 @@
  * GNU General Public License for more details.
  *
  */
-//#include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/genalloc.h>
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 2d1d555..9cf5622 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -49,9 +49,8 @@ void *ion_heap_map_kernel(struct ion_heap *heap,
 		int npages_this_entry = PAGE_ALIGN(sg->length) / PAGE_SIZE;
 		struct page *page = sg_page(sg);
 		BUG_ON(i >= npages);
-		for (j = 0; j < npages_this_entry; j++) {
+		for (j = 0; j < npages_this_entry; j++)
 			*(tmp++) = page++;
-		}
 	}
 	vaddr = vmap(pages, npages, VM_MAP, pgprot);
 	vfree(pages);
@@ -159,7 +158,7 @@ int ion_heap_pages_zero(struct page *page, size_t size, pgprot_t pgprot)
 	return ion_heap_sglist_zero(&sg, 1, pgprot);
 }
 
-void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer * buffer)
+void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer *buffer)
 {
 	rt_mutex_lock(&heap->lock);
 	list_add(&buffer->list, &heap->free_list);
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index a1c51a8..fa693c2 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -108,7 +108,7 @@ void *ion_page_pool_alloc(struct ion_page_pool *pool)
 	return page;
 }
 
-void ion_page_pool_free(struct ion_page_pool *pool, struct page* page)
+void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
 {
 	int ret;
 
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index fa96175..fc8a4c3 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -230,7 +230,7 @@ int ion_heap_init_deferred_free(struct ion_heap *heap);
 /**
  * ion_heap_freelist_add - add a buffer to the deferred free list
  * @heap:		the heap
- * @buffer: 		the buffer
+ * @buffer:		the buffer
  *
  * Adds an item to the deferred freelist.
  */
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 301d019..b5acd6c 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -148,7 +148,8 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
-		info = alloc_largest_available(sys_heap, buffer, size_remaining, max_order);
+		info = alloc_largest_available(sys_heap, buffer, size_remaining,
+						max_order);
 		if (!info)
 			goto err;
 		list_add_tail(&info->list, &pages);
-- 
1.8.3.2


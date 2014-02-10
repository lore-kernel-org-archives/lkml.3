Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaBJF4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:56:31 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56013 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaBJF4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:56:30 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org, swetland@google.com
Cc: john.stultz@linaro.org, rebecca@android.com, ccross@android.com,
        ohaugan@codeaurora.org, romlem@google.com,
        linux-kernel@vger.kernel.org, devel <devel@driverdev.osuosl.org>
Subject: [PATCH] staging : ion : Fix some checkpatch warnings and an error
Date: Mon, 10 Feb 2014 14:56:24 +0900
Message-ID: <81912500.jvGoQpGOq5@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From aa06cc53c7214a044fbc220872aa6210c09608d3 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 10 Feb 2014 14:27:40 +0900
Subject: [PATCH] staging : ion : Fix some checkpatch warnings and an error

Warning:
- Unnecessary space after function pointer name
- Prefer seq_puts to seq_printf
- quoted string split across lines

Error:
- return is not a function, parentheses are not required

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/android/ion/ion.c      |   19 +++++++++----------
 drivers/staging/android/ion/ion_priv.h |   16 ++++++++--------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 574066f..d81f231 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -55,7 +55,7 @@ struct ion_device {
 	struct mutex buffer_lock;
 	struct rw_semaphore lock;
 	struct plist_head heaps;
-	long (*custom_ioctl) (struct ion_client *client, unsigned int cmd,
+	long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
 			      unsigned long arg);
 	struct rb_root clients;
 	struct dentry *debug_root;
@@ -429,7 +429,7 @@ static bool ion_handle_validate(struct ion_client *client,
 				struct ion_handle *handle)
 {
 	WARN_ON(!mutex_is_locked(&client->lock));
-	return (idr_find(&client->idr, handle->id) == handle);
+	return idr_find(&client->idr, handle->id) == handle;
 }
 
 static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
@@ -1338,7 +1338,7 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	size_t total_orphaned_size = 0;
 
 	seq_printf(s, "%16.s %16.s %16.s\n", "client", "pid", "size");
-	seq_printf(s, "----------------------------------------------------\n");
+	seq_puts(s, "----------------------------------------------------\n");
 
 	for (n = rb_first(&dev->clients); n; n = rb_next(n)) {
 		struct ion_client *client = rb_entry(n, struct ion_client,
@@ -1357,9 +1357,9 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 				   client->pid, size);
 		}
 	}
-	seq_printf(s, "----------------------------------------------------\n");
-	seq_printf(s, "orphaned allocations (info is from last known client):"
-		   "\n");
+	seq_puts(s, "----------------------------------------------------\n");
+	seq_puts(s, "orphaned allocations (info is from last known client):\n");
+
 	mutex_lock(&dev->buffer_lock);
 	for (n = rb_first(&dev->buffers); n; n = rb_next(n)) {
 		struct ion_buffer *buffer = rb_entry(n, struct ion_buffer,
@@ -1376,14 +1376,14 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 		}
 	}
 	mutex_unlock(&dev->buffer_lock);
-	seq_printf(s, "----------------------------------------------------\n");
+	seq_puts(s, "----------------------------------------------------\n");
 	seq_printf(s, "%16.s %16zu\n", "total orphaned",
 		   total_orphaned_size);
 	seq_printf(s, "%16.s %16zu\n", "total ", total_size);
 	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
 		seq_printf(s, "%16.s %16zu\n", "deferred free",
 				heap->free_list_size);
-	seq_printf(s, "----------------------------------------------------\n");
+	seq_puts(s, "----------------------------------------------------\n");
 
 	if (heap->debug_show)
 		heap->debug_show(heap, s, unused);
@@ -1527,8 +1527,7 @@ void __init ion_reserve(struct ion_platform_data *data)
 						    data->heaps[i].align,
 						    MEMBLOCK_ALLOC_ANYWHERE);
 			if (!paddr) {
-				pr_err("%s: error allocating memblock for "
-				       "heap %d\n",
+				pr_err("%s: error allocating memblock for heap %d\n",
 					__func__, i);
 				continue;
 			}
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index d986739..10f315a 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -100,18 +100,18 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
  * map_dma and map_kernel return pointer on success, ERR_PTR on error.
  */
 struct ion_heap_ops {
-	int (*allocate) (struct ion_heap *heap,
+	int (*allocate)(struct ion_heap *heap,
 			 struct ion_buffer *buffer, unsigned long len,
 			 unsigned long align, unsigned long flags);
-	void (*free) (struct ion_buffer *buffer);
-	int (*phys) (struct ion_heap *heap, struct ion_buffer *buffer,
+	void (*free)(struct ion_buffer *buffer);
+	int (*phys)(struct ion_heap *heap, struct ion_buffer *buffer,
 		     ion_phys_addr_t *addr, size_t *len);
-	struct sg_table *(*map_dma) (struct ion_heap *heap,
+	struct sg_table * (*map_dma)(struct ion_heap *heap,
 					struct ion_buffer *buffer);
-	void (*unmap_dma) (struct ion_heap *heap, struct ion_buffer *buffer);
-	void * (*map_kernel) (struct ion_heap *heap, struct ion_buffer *buffer);
-	void (*unmap_kernel) (struct ion_heap *heap, struct ion_buffer *buffer);
-	int (*map_user) (struct ion_heap *mapper, struct ion_buffer *buffer,
+	void (*unmap_dma)(struct ion_heap *heap, struct ion_buffer *buffer);
+	void * (*map_kernel)(struct ion_heap *heap, struct ion_buffer *buffer);
+	void (*unmap_kernel)(struct ion_heap *heap, struct ion_buffer *buffer);
+	int (*map_user)(struct ion_heap *mapper, struct ion_buffer *buffer,
 			 struct vm_area_struct *vma);
 };
 
-- 
1.7.9.5
---

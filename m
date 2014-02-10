Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBJB7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:59:22 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57528 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaBJB7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:59:19 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org
Cc: rebecca@android.com, ccross@android.com, ohaugan@codeaurora.org,
        romlem@google.com, konkers@android.com, rdunlap@infradead.org,
        standby24x7@gmail.com, prtvar.b@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging : android : fix checkpatch issues
Date: Mon, 10 Feb 2014 10:59:14 +0900
Message-ID: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1348300b03697d0499eddba6035a851d1278abd1 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 10 Feb 2014 10:45:30 +0900
Subject: [PATCH] staging : android : fix checkpatch issues

drivers/staging/android/
ion/ion.c :
 - WARNNING: Unnecessary space after function pointer name
 - ERROR: return is not a function, parentheses are not required
 - WARNNING: Prefer seq_puts to seq_printf
 - WARNING: quoted string split across lines

ion/ion_priv.h :
 - WARNING: Unnecessary space after function pointer name

sync.h :
 - WARNING: missing space after return type

timed_output.h :
 - WARNING: Multiple spaces after return type

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/android/ion/ion.c      |   19 +++++++++----------
 drivers/staging/android/ion/ion_priv.h |   16 ++++++++--------
 drivers/staging/android/sync.h         |    2 +-
 drivers/staging/android/timed_output.h |    4 ++--
 4 files changed, 20 insertions(+), 21 deletions(-)

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
 
diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
index 62e2255b..6ee8d69 100644
--- a/drivers/staging/android/sync.h
+++ b/drivers/staging/android/sync.h
@@ -53,7 +53,7 @@ struct sync_timeline_ops {
 	const char *driver_name;
 
 	/* required */
-	struct sync_pt *(*dup)(struct sync_pt *pt);
+	struct sync_pt * (*dup)(struct sync_pt *pt);
 
 	/* required */
 	int (*has_signaled)(struct sync_pt *pt);
diff --git a/drivers/staging/android/timed_output.h b/drivers/staging/android/timed_output.h
index 905c7cc..13d2ca5 100644
--- a/drivers/staging/android/timed_output.h
+++ b/drivers/staging/android/timed_output.h
@@ -20,10 +20,10 @@ struct timed_output_dev {
 	const char	*name;
 
 	/* enable the output and set the timer */
-	void	(*enable)(struct timed_output_dev *sdev, int timeout);
+	void (*enable)(struct timed_output_dev *sdev, int timeout);
 
 	/* returns the current number of milliseconds remaining on the timer */
-	int		(*get_time)(struct timed_output_dev *sdev);
+	int (*get_time)(struct timed_output_dev *sdev);
 
 	/* private data */
 	struct device	*dev;
-- 
1.7.9.5



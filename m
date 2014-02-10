Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBJLZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:25:20 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56722 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJLZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:25:15 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org, swetland@google.com
Cc: john.stultz@linaro.org, rebecca@android.com, ccross@android.com,
        ohaugan@codeaurora.org, romlem@google.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        dan.carpenter@oracle.com
Subject: [Resend PATCH] staging : ion : Fix some checkpatch warnings and an error
Date: Mon, 10 Feb 2014 20:25:06 +0900
Message-ID: <1861074.WmPcbRBdNV@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b94a20adb53fba1a6a3d2aebfbbc1b708e04f3b Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 10 Feb 2014 20:16:50 +0900
Subject: [PATCH] staging : ion : Fix some checkpatch warnings and an error

Warning:
 - Unnecessary space after function pointer name
 - quoted string split across lines

Error:
 - return is not a function, parentheses are not required

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/android/ion/ion.c      |    7 +++----
 drivers/staging/android/ion/ion_priv.h |   16 ++++++++--------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 574066f..f6d8b34 100644
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

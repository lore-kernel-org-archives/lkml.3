Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161510AbaDPO14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:27:56 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41901 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161180AbaDPO1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:27:55 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] staging : android : uapi : fix coding style
Date: Wed, 16 Apr 2014 23:27:39 +0900
Message-Id: <1397658459-4357-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix checkpatch.pl warnings and errors.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/android/uapi/binder.h |    2 +-
 drivers/staging/android/uapi/ion.h    |   20 +++++++++-----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
index 904adb7..dba4cef 100644
--- a/drivers/staging/android/uapi/binder.h
+++ b/drivers/staging/android/uapi/binder.h
@@ -169,7 +169,7 @@ struct binder_ptr_cookie {
 struct binder_handle_cookie {
 	__u32 handle;
 	binder_uintptr_t cookie;
-} __attribute__((packed));
+} __packed;
 
 struct binder_pri_desc {
 	__s32 priority;
diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
index f09e7c1..36332dc 100644
--- a/drivers/staging/android/uapi/ion.h
+++ b/drivers/staging/android/uapi/ion.h
@@ -20,19 +20,17 @@
 #include <linux/ioctl.h>
 #include <linux/types.h>
 
-typedef int ion_user_handle_t;
-
 /**
  * enum ion_heap_types - list of all possible types of heaps
  * @ION_HEAP_TYPE_SYSTEM:	 memory allocated via vmalloc
  * @ION_HEAP_TYPE_SYSTEM_CONTIG: memory allocated via kmalloc
  * @ION_HEAP_TYPE_CARVEOUT:	 memory allocated from a prereserved
- * 				 carveout heap, allocations are physically
- * 				 contiguous
+ *				 carveout heap, allocations are physically
+ *				 contiguous
  * @ION_HEAP_TYPE_DMA:		 memory allocated via DMA API
  * @ION_NUM_HEAPS:		 helper for iterating over heaps, a bit mask
- * 				 is used to identify the heaps, so only 32
- * 				 total heap types are supported
+ *				 is used to identify the heaps, so only 32
+ *				 total heap types are supported
  */
 enum ion_heap_type {
 	ION_HEAP_TYPE_SYSTEM,
@@ -50,7 +48,7 @@ enum ion_heap_type {
 #define ION_HEAP_CARVEOUT_MASK		(1 << ION_HEAP_TYPE_CARVEOUT)
 #define ION_HEAP_TYPE_DMA_MASK		(1 << ION_HEAP_TYPE_DMA)
 
-#define ION_NUM_HEAP_IDS		sizeof(unsigned int) * 8
+#define ION_NUM_HEAP_IDS		(sizeof(unsigned int) * 8)
 
 /**
  * allocation flags - the lower 16 bits are used by core ion, the upper 16
@@ -78,7 +76,7 @@ enum ion_heap_type {
  * @align:		required alignment of the allocation
  * @heap_id_mask:	mask of heap ids to allocate from
  * @flags:		flags passed to heap
- * @handle:		pointer that will be populated with a cookie to use to 
+ * @handle:		pointer that will be populated with a cookie to use to
  *			refer to this allocation
  *
  * Provided by userspace as an argument to the ioctl
@@ -88,7 +86,7 @@ struct ion_allocation_data {
 	size_t align;
 	unsigned int heap_id_mask;
 	unsigned int flags;
-	ion_user_handle_t handle;
+	int handle;
 };
 
 /**
@@ -102,7 +100,7 @@ struct ion_allocation_data {
  * provides the file descriptor and the kernel returns the handle.
  */
 struct ion_fd_data {
-	ion_user_handle_t handle;
+	int handle;
 	int fd;
 };
 
@@ -111,7 +109,7 @@ struct ion_fd_data {
  * @handle:	a handle
  */
 struct ion_handle_data {
-	ion_user_handle_t handle;
+	int handle;
 };
 
 /**
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaGWSa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:30:58 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50115 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035AbaGWSaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:30:55 -0400
From: WANG Chao <wangchao19890207@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Laura Abbott <lauraa@codeaurora.org>, Gioh Kim <gioh.kim@lge.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Heesub Shin <heesub.shin@samsung.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [linux-next PATCH] staging: android: ion: fix void function return statements
Date: Thu, 24 Jul 2014 02:30:17 +0800
Message-Id: <1406140230-23799-1-git-send-email-wangchao19890207@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning of void function return statements, found under
drivers/staging/android/ion.

Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
---
 drivers/staging/android/ion/ion.c               | 1 -
 drivers/staging/android/ion/ion_carveout_heap.c | 1 -
 drivers/staging/android/ion/ion_chunk_heap.c    | 1 -
 drivers/staging/android/ion/ion_dummy_driver.c  | 2 --
 drivers/staging/android/ion/ion_system_heap.c   | 1 -
 5 files changed, 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index cad76ae..56604f4 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1057,7 +1057,6 @@ static void *ion_dma_buf_kmap(struct dma_buf *dmabuf, unsigned long offset)
 static void ion_dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long offset,
 			       void *ptr)
 {
-	return;
 }
 
 static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start,
diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index dcb6f21..9156d82 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -133,7 +133,6 @@ static struct sg_table *ion_carveout_heap_map_dma(struct ion_heap *heap,
 static void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
 					struct ion_buffer *buffer)
 {
-	return;
 }
 
 static struct ion_heap_ops carveout_heap_ops = {
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 9c3e49a..3e6ec2e 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -126,7 +126,6 @@ static struct sg_table *ion_chunk_heap_map_dma(struct ion_heap *heap,
 static void ion_chunk_heap_unmap_dma(struct ion_heap *heap,
 				     struct ion_buffer *buffer)
 {
-	return;
 }
 
 static struct ion_heap_ops chunk_heap_ops = {
diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 6d0a38a..f3ea1c3 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -152,7 +152,5 @@ static void __exit ion_dummy_exit(void)
 				dummy_heaps[ION_HEAP_TYPE_CHUNK].size);
 		chunk_ptr = NULL;
 	}
-
-	return;
 }
 __exitcall(ion_dummy_exit);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 6b77c51..da2a63c 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -205,7 +205,6 @@ static struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
 static void ion_system_heap_unmap_dma(struct ion_heap *heap,
 				      struct ion_buffer *buffer)
 {
-	return;
 }
 
 static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
-- 
1.9.3


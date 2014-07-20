Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaGTELS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:11:18 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43033 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaGTELR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:11:17 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, ccross@android.com,
        tranmanphong@gmail.com, fabio.estevam@freescale.com,
        rebecca@android.com, benjamin.gaignard@linaro.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: ion: ion_cma_heap.c: Fix checkpatch warning
Date: Sun, 20 Jul 2014 11:10:55 +0700
Message-Id: <1405829455-5866-1-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix coding style:

- Remove "fail memory allocation" waring
- Remove return of void function

Tested by compilation only

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/staging/android/ion/ion_cma_heap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index ce68ecf..f8cabcb 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -76,10 +76,8 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 		return -EINVAL;
 
 	info = kzalloc(sizeof(struct ion_cma_buffer_info), GFP_KERNEL);
-	if (!info) {
-		dev_err(dev, "Can't allocate buffer info\n");
+	if (!info)
 		return ION_CMA_ALLOCATE_FAILED;
-	}
 
 	info->cpu_addr = dma_alloc_coherent(dev, len, &(info->handle),
 						GFP_HIGHUSER | __GFP_ZERO);
@@ -90,10 +88,8 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 	}
 
 	info->table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
-	if (!info->table) {
-		dev_err(dev, "Fail to allocate sg table\n");
+	if (!info->table)
 		goto free_mem;
-	}
 
 	if (ion_cma_get_sgtable
 	    (dev, info->table, info->cpu_addr, info->handle, len))
@@ -155,7 +151,6 @@ static struct sg_table *ion_cma_heap_map_dma(struct ion_heap *heap,
 static void ion_cma_heap_unmap_dma(struct ion_heap *heap,
 				   struct ion_buffer *buffer)
 {
-	return;
 }
 
 static int ion_cma_mmap(struct ion_heap *mapper, struct ion_buffer *buffer,
-- 
1.9.3


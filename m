Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaDXXoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:44:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:33279 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaDXXns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:43:48 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 19:43:45 EDT
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: "gioh.kim" <gioh.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>, kernel-team@android.com
Cc: linux-kernel@vger.kernel.org, gunho.lee@lge.com,
        "gioh.kim" <gioh.kim@lge.com>
Subject: [PATCH] Staging: android: ion: duplicated clearing of sg_table
Date: Fri, 25 Apr 2014 08:24:24 +0900
Message-Id: <1398381864-6083-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "gioh.kim" <gioh.kim@lge.com>

Because sg_table is cleared in sg_alloc_table via memset we don't need to use
kzalloc to allocate sg_table.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/ion_carveout_heap.c |    2 +-
 drivers/staging/android/ion/ion_chunk_heap.c    |    2 +-
 drivers/staging/android/ion/ion_system_heap.c   |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index 3cb05b9..dcb6f21 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -81,7 +81,7 @@ static int ion_carveout_heap_allocate(struct ion_heap *heap,
 	if (align > PAGE_SIZE)
 		return -EINVAL;
 
-	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 	ret = sg_alloc_table(table, 1, GFP_KERNEL);
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index d40f5f8..3f2c12b 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -55,7 +55,7 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 	if (allocated_size > chunk_heap->size - chunk_heap->allocated)
 		return -ENOMEM;
 
-	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 	ret = sg_alloc_table(table, num_chunks, GFP_KERNEL);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index c923633..0663a7f 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -166,7 +166,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		max_order = info->order;
 		i++;
 	}
-	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table)
 		goto err;
 
@@ -356,7 +356,7 @@ static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 	for (i = len >> PAGE_SHIFT; i < (1 << order); i++)
 		__free_page(page + i);
 
-	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
 	if (!table) {
 		ret = -ENOMEM;
 		goto out;
-- 
1.7.9.5


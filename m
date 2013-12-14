Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3LND1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:46 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61920 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3LND0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:47 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 095/115] gpu: ion: remove unnecessary function from system heap
Date: Fri, 13 Dec 2013 19:26:15 -0800
Message-Id: <1386991595-6251-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

ion_system_contig_heap buffers have an sglist, just call
ion_heap_map_user to map it.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 3b2f420..9250ee5 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -422,17 +422,6 @@ void ion_system_contig_heap_unmap_dma(struct ion_heap *heap,
 	kfree(buffer->sg_table);
 }
 
-int ion_system_contig_heap_map_user(struct ion_heap *heap,
-				    struct ion_buffer *buffer,
-				    struct vm_area_struct *vma)
-{
-	unsigned long pfn = page_to_pfn(virt_to_page(buffer->priv_virt));
-	return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start,
-			       vma->vm_page_prot);
-
-}
-
 static struct ion_heap_ops kmalloc_ops = {
 	.allocate = ion_system_contig_heap_allocate,
 	.free = ion_system_contig_heap_free,
@@ -441,7 +430,7 @@ static struct ion_heap_ops kmalloc_ops = {
 	.unmap_dma = ion_system_contig_heap_unmap_dma,
 	.map_kernel = ion_heap_map_kernel,
 	.unmap_kernel = ion_heap_unmap_kernel,
-	.map_user = ion_system_contig_heap_map_user,
+	.map_user = ion_heap_map_user,
 };
 
 struct ion_heap *ion_system_contig_heap_create(struct ion_platform_heap *unused)
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaLIBUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:20:35 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:61547 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaLIBUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:20:33 -0500
From: Zeng Tao <prime.zeng@huawei.com>
To: <gregkh@linuxfoundation.org>, <john.stultz@linaro.org>,
        <ccross@android.com>, <rebecca@android.com>,
        <fabio.estevam@freescale.com>, <tranmanphong@gmail.com>,
        <benjamin.gaignard@linaro.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: ion: ion_cma_heap: remove ion_cma_get_sgtable
Date: Tue, 9 Dec 2014 09:19:40 +0800
Message-ID: <1418087980-221566-1-git-send-email-prime.zeng@huawei.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.83]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54864E5C.0058,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 461d0641798ac5e7fddcb6a5b560727d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the temporary code ion_cma_get_sgtable,
use dma_common_get_sgtable instead

Signed-off-by: Zeng Tao <prime.zeng@huawei.com>
---
 drivers/staging/android/ion/ion_cma_heap.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index f8cabcb..f4211f1 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -39,24 +39,6 @@ struct ion_cma_buffer_info {
 	struct sg_table *table;
 };
 
-/*
- * Create scatter-list for the already allocated DMA buffer.
- * This function could be replaced by dma_common_get_sgtable
- * as soon as it will avalaible.
- */
-static int ion_cma_get_sgtable(struct device *dev, struct sg_table *sgt,
-			       void *cpu_addr, dma_addr_t handle, size_t size)
-{
-	struct page *page = virt_to_page(cpu_addr);
-	int ret;
-
-	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
-	if (unlikely(ret))
-		return ret;
-
-	sg_set_page(sgt->sgl, page, PAGE_ALIGN(size), 0);
-	return 0;
-}
 
 /* ION CMA heap operations functions */
 static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
@@ -91,7 +73,7 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 	if (!info->table)
 		goto free_mem;
 
-	if (ion_cma_get_sgtable
+	if (dma_common_get_sgtable
 	    (dev, info->table, info->cpu_addr, info->handle, len))
 		goto free_table;
 	/* keep this for memory release */
-- 
1.9.1


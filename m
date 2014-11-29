Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaK2Bcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 20:32:51 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40743 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaK2Bcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 20:32:50 -0500
From: Zeng Tao <prime.zeng@huawei.com>
To: <gregkh@linuxfoundation.org>, <john.stultz@linaro.org>,
        <ccross@android.com>, <benjamin.gaignard@linaro.org>,
        <rebecca@android.com>, <fabio.estevam@freescale.com>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: ion : ion_cma_heap: fix bug for highmem cma
Date: Sat, 29 Nov 2014 09:31:57 +0800
Message-ID: <1417224717-203170-1-git-send-email-prime.zeng@huawei.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.83]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when cma is located in highmem, virt_to_page will not
work the right way, use pfn_to_page instead.

Signed-off-by: Zeng Tao <prime.zeng@huawei.com>
---
 drivers/staging/android/ion/ion_cma_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index f8cabcb..cc45fc0 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -47,7 +47,7 @@ struct ion_cma_buffer_info {
 static int ion_cma_get_sgtable(struct device *dev, struct sg_table *sgt,
 			       void *cpu_addr, dma_addr_t handle, size_t size)
 {
-	struct page *page = virt_to_page(cpu_addr);
+	struct page *page = pfn_to_page(handle >> PAGE_SHIFT);
 	int ret;
 
 	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
-- 
1.9.1


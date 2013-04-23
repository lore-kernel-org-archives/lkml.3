Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3DWCrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:47:48 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33799 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3DWCrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:47:46 -0400
MIME-Version: 1.0
Date: Tue, 23 Apr 2013 10:47:44 +0800
Message-ID: <CAPgLHd9shRmpq__avgWPupFvcY2LNuEtPs9bG=AVpBx7BpLZTw@mail.gmail.com>
Subject: [PATCH -next] iommu/amd: fix error return code in early_amd_iommu_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: joro@8bytes.org
Cc: yongjun_wei@trendmicro.com.cn, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM int the memory alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/iommu/amd_iommu_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 9110c1c..a55ec50 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1860,6 +1860,7 @@ static int __init early_amd_iommu_init(void)
 		 * Interrupt remapping enabled, create kmem_cache for the
 		 * remapping tables.
 		 */
+		ret = -ENOMEM;
 		amd_iommu_irq_cache = kmem_cache_create("irq_remap_cache",
 				MAX_IRQS_PER_TABLE * sizeof(u32),
 				IRQ_TABLE_ALIGNMENT,


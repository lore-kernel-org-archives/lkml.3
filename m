Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaLXVwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 16:52:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42510 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaLXVwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 16:52:19 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <will.deacon@arm.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH] dma-mapping: limit dma_mask in arch_setup_dma_ops()
Date: Wed, 24 Dec 2014 16:51:36 -0500
Message-ID: <1419457896-3977-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_mask should be limited to minimum of the default dma mask
and dma-range size configured in DT for proper operation.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mm/dma-mapping.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7864797..5cea1fc 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2053,6 +2053,7 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 {
 	struct dma_map_ops *dma_ops;
 
+	*dev->dma_mask = min((*dev->dma_mask), (dma_base + size - 1));
 	dev->archdata.dma_coherent = coherent;
 	if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
 		dma_ops = arm_get_iommu_dma_map_ops(coherent);
-- 
1.7.9.5


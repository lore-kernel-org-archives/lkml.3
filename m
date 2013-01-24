Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3AXNRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:17:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4400 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXNRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:17:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 24 Jan 2013 05:17:13 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ARM: dma-mapping: Add macro to_dma_iommu_mapping()
Date: Thu, 24 Jan 2013 15:16:56 +0200
Message-ID: <1359033425-6674-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be built without CONFIG_ARM_DMA_USE_IOMMU.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/include/asm/device.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/include/asm/device.h b/arch/arm/include/asm/device.h
index 5191a83..6fbe514 100644
--- a/arch/arm/include/asm/device.h
+++ b/arch/arm/include/asm/device.h
@@ -33,4 +33,10 @@ struct pdev_archdata {
 #endif
 };
 
+#ifdef CONFIG_ARM_DMA_USE_IOMMU
+#define to_dma_iommu_mapping(dev) ((dev)->archdata.mapping)
+#else
+#define to_dma_iommu_mapping(dev) NULL
+#endif
+
 #endif
-- 
1.7.9.5


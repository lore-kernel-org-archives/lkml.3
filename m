Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaAHI4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:56:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:14728 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaAHI4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:56:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,623,1384329600"; 
   d="scan'208";a="332789710"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu/vt-d: fix compilation error for IA64 platform
Date: Wed,  8 Jan 2014 16:57:07 +0800
Message-Id: <1389171427-26223-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388989107-4795-20-git-send-email-jiang.liu@linux.intel.com>
References: <1388989107-4795-20-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit: ecd1c02e9fea1c684c9698e8ce6a552656ba0871 [21/22] iommu/vt-d, trivial: clean sparse warnings
config: make ARCH=ia64 defconfig

All error/warnings:
   arch/ia64/kernel/built-in.o: In function `pci_iommu_alloc':
>> (.init.text+0xb541): undefined reference to `intel_dma_ops'
   arch/ia64/kernel/built-in.o: In function `pci_iommu_alloc':
>> (.init.text+0xb561): undefined reference to `intel_dma_ops'

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Joerg,
	Could you please help to fold this into "[21/22] iommu/vt-d,
trivial: clean sparse warnings"?

Thanks!
Gerry
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0863e25..70a3257 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3128,7 +3128,7 @@ static int intel_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return !dma_addr;
 }
 
-static struct dma_map_ops intel_dma_ops = {
+struct dma_map_ops intel_dma_ops = {
 	.alloc = intel_alloc_coherent,
 	.free = intel_free_coherent,
 	.map_sg = intel_map_sg,
-- 
1.7.10.4


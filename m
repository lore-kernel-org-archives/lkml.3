Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaFYI76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:59:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:24678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbaFYI7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:59:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="552982054"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part3 V3 02/21] iommu/vt-d: use correct domain id to flush virtual machine domains
Date: Wed, 25 Jun 2014 17:02:28 +0800
Message-Id: <1403686967-10887-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403686967-10887-1-git-send-email-jiang.liu@linux.intel.com>
References: <1403686967-10887-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For virtual machine domains, domain->id is a virtual id, and the real
domain id written into context entry is dynamically allocated.
So use the real domain id instead of domain->id when flushing iotlbs
for virtual machine domains.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e29d963f3967..64a3c37d5cfa 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1825,7 +1825,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 					   (((u16)bus) << 8) | devfn,
 					   DMA_CCMD_MASK_NOBIT,
 					   DMA_CCMD_DEVICE_INVL);
-		iommu->flush.flush_iotlb(iommu, domain->id, 0, 0, DMA_TLB_DSI_FLUSH);
+		iommu->flush.flush_iotlb(iommu, id, 0, 0, DMA_TLB_DSI_FLUSH);
 	} else {
 		iommu_flush_write_buffer(iommu);
 	}
-- 
1.7.10.4


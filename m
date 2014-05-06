Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbaEFHDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:03:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:34948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934095AbaEFHDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:03:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="526661960"
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
Subject: [Patch Part3 V2 01/21] iommu/vt-d: match segment number when searching for dev_iotlb capable devices
Date: Tue,  6 May 2014 15:05:12 +0800
Message-Id: <1399359932-28972-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
References: <1399359932-28972-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For virtual machine and static identity domains, there may be devices
from different PCI segments associated with the same domain.
So function iommu_support_dev_iotlb() should also match PCI segment
number (iommu unit) when searching for dev_iotlb capable devices.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index f256ffc02e29..612fd441b225 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1274,7 +1274,8 @@ iommu_support_dev_iotlb (struct dmar_domain *domain, struct intel_iommu *iommu,
 
 	spin_lock_irqsave(&device_domain_lock, flags);
 	list_for_each_entry(info, &domain->devices, link)
-		if (info->bus == bus && info->devfn == devfn) {
+		if (info->iommu == iommu && info->bus == bus &&
+		    info->devfn == devfn) {
 			found = 1;
 			break;
 		}
-- 
1.7.10.4


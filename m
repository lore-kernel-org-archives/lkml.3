Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaAFGSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:18:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:61926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbaAFGSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:18:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="401364931"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part1 V3 16/20] iommu/vt-d: release invalidation queue when destroying IOMMU unit
Date: Mon,  6 Jan 2014 14:18:23 +0800
Message-Id: <1388989107-4795-17-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
References: <1388989107-4795-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release associated invalidation queue when destroying IOMMU unit
to avoid memory leak.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 302e037..bb635fb 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -737,6 +737,12 @@ static void free_iommu(struct intel_iommu *iommu)
 		destroy_irq(iommu->irq);
 	}
 
+	if (iommu->qi) {
+		free_page((unsigned long)iommu->qi->desc);
+		kfree(iommu->qi->desc_status);
+		kfree(iommu->qi);
+	}
+
 	if (iommu->reg)
 		unmap_iommu(iommu);
 
-- 
1.7.10.4


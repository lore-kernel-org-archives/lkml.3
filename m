Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaAGJAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:45252 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaAGJAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739812"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 04/14] iommu/vt-d: free resources if failed to create domain for PCIe endpoint
Date: Tue,  7 Jan 2014 17:00:24 +0800
Message-Id: <1389085234-22296-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance function get_domain_for_dev() to release allocated resources
if failed to create domain for PCIe endpoint, otherwise the allocated
resources will get lost.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index da65884..2bbb877 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2078,6 +2078,8 @@ found_domain:
 	if (dmar_insert_dev_info(segment, pdev->bus->number, pdev->devfn,
 				 pdev, &domain) == 0)
 		return domain;
+	else if (!bridge)
+		domain_exit(domain);
 error:
 	/* recheck it here, maybe others set it */
 	return find_domain(pdev);
-- 
1.7.10.4


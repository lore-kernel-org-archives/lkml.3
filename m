Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3LFDYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:24:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab3LFDVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:21:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986928"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiri Kosina <trivial@kernel.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 10/20] iommu/vt-d, trivial: use defined macro instead of hardcoding
Date: Fri,  6 Dec 2013 11:21:13 +0800
Message-Id: <1386300083-6882-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use defined macro instead of hardcoding in function set_ioapic_sid()
for readability.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 41e5798..50fd55c 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -324,7 +324,7 @@ static int set_ioapic_sid(struct irte *irte, int apic)
 		return -1;
 	}
 
-	set_irte_sid(irte, 1, 0, sid);
+	set_irte_sid(irte, SVT_VERIFY_SID_SQ, SQ_ALL_16, sid);
 
 	return 0;
 }
-- 
1.7.10.4


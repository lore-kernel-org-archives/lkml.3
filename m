Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaETMkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:40:09 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:2488 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaETMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:40:07 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 2/6] iommu/vt-d: move up no_iommu and dmar_disabled check
Date: Tue, 20 May 2014 20:37:48 +0800
Message-ID: <1400589472-8544-3-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move up the no_iommu and dmar_disabled check, avoid the
useless initialization for dmar.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/intel-iommu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index e020dcf..6b71608 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3948,6 +3948,9 @@ int __init intel_iommu_init(void)
 	/* VT-d is required for a TXT/tboot launch, so enforce that */
 	force_on = tboot_force_iommu();
 
+	if (no_iommu || dmar_disabled)
+		return ret;
+
 	if (iommu_init_mempool()) {
 		if (force_on)
 			panic("tboot: Failed to initialize iommu memory\n");
@@ -3974,9 +3977,6 @@ int __init intel_iommu_init(void)
 		goto out_free_dmar;
 	}
 
-	if (no_iommu || dmar_disabled)
-		goto out_free_dmar;
-
 	if (list_empty(&dmar_rmrr_units))
 		printk(KERN_INFO "DMAR: No RMRR found\n");
 
-- 
1.7.1



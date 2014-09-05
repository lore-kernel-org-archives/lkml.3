Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbaIEKy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:54:26 -0400
Received: from 8bytes.org ([81.169.241.247]:37794 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878AbaIEKxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:12 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 03/12] iommu/amd: Convert to iommu_capable() API function
Date: Fri,  5 Sep 2014 12:52:55 +0200
Message-Id: <1409914384-21191-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index ecb0109..7de9276 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3384,20 +3384,20 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 	return paddr;
 }
 
-static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
-				    unsigned long cap)
+static bool amd_iommu_capable(enum iommu_cap cap)
 {
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
-		return 1;
+		return true;
 	case IOMMU_CAP_INTR_REMAP:
-		return irq_remapping_enabled;
+		return (irq_remapping_enabled == 1);
 	}
 
-	return 0;
+	return false;
 }
 
 static const struct iommu_ops amd_iommu_ops = {
+	.capable = amd_iommu_capable,
 	.domain_init = amd_iommu_domain_init,
 	.domain_destroy = amd_iommu_domain_destroy,
 	.attach_dev = amd_iommu_attach_device,
@@ -3405,7 +3405,6 @@ static const struct iommu_ops amd_iommu_ops = {
 	.map = amd_iommu_map,
 	.unmap = amd_iommu_unmap,
 	.iova_to_phys = amd_iommu_iova_to_phys,
-	.domain_has_cap = amd_iommu_domain_has_cap,
 	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
 };
 
-- 
1.9.1


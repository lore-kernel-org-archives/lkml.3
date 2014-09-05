Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbaIEKyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:54:24 -0400
Received: from 8bytes.org ([81.169.241.247]:37795 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbaIEKxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:12 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: [PATCH 08/12] iommu/tegra: Convert to iommu_capable() API function
Date: Fri,  5 Sep 2014 12:53:00 +0200
Message-Id: <1409914384-21191-9-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Cc: Hiroshi Doyu <hdoyu@nvidia.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/tegra-gart.c | 7 +++----
 drivers/iommu/tegra-smmu.c | 7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index b10a8ec..6f44ebb 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -303,13 +303,13 @@ static phys_addr_t gart_iommu_iova_to_phys(struct iommu_domain *domain,
 	return pa;
 }
 
-static int gart_iommu_domain_has_cap(struct iommu_domain *domain,
-				     unsigned long cap)
+static bool gart_iommu_capable(enum iommu_cap cap)
 {
-	return 0;
+	return false;
 }
 
 static const struct iommu_ops gart_iommu_ops = {
+	.capable	= gart_iommu_capable,
 	.domain_init	= gart_iommu_domain_init,
 	.domain_destroy	= gart_iommu_domain_destroy,
 	.attach_dev	= gart_iommu_attach_dev,
@@ -317,7 +317,6 @@ static const struct iommu_ops gart_iommu_ops = {
 	.map		= gart_iommu_map,
 	.unmap		= gart_iommu_unmap,
 	.iova_to_phys	= gart_iommu_iova_to_phys,
-	.domain_has_cap	= gart_iommu_domain_has_cap,
 	.pgsize_bitmap	= GART_IOMMU_PGSIZES,
 };
 
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 3ded389..05d14e1 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -780,10 +780,9 @@ static phys_addr_t smmu_iommu_iova_to_phys(struct iommu_domain *domain,
 	return PFN_PHYS(pfn);
 }
 
-static int smmu_iommu_domain_has_cap(struct iommu_domain *domain,
-				     unsigned long cap)
+static bool smmu_iommu_capable(enum iommu_cap cap)
 {
-	return 0;
+	return false;
 }
 
 static int smmu_iommu_attach_dev(struct iommu_domain *domain,
@@ -949,6 +948,7 @@ static void smmu_iommu_domain_destroy(struct iommu_domain *domain)
 }
 
 static const struct iommu_ops smmu_iommu_ops = {
+	.capable	= smmu_iommu_capable,
 	.domain_init	= smmu_iommu_domain_init,
 	.domain_destroy	= smmu_iommu_domain_destroy,
 	.attach_dev	= smmu_iommu_attach_dev,
@@ -956,7 +956,6 @@ static const struct iommu_ops smmu_iommu_ops = {
 	.map		= smmu_iommu_map,
 	.unmap		= smmu_iommu_unmap,
 	.iova_to_phys	= smmu_iommu_iova_to_phys,
-	.domain_has_cap	= smmu_iommu_domain_has_cap,
 	.pgsize_bitmap	= SMMU_IOMMU_PGSIZES,
 };
 
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbaIEKxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:53:22 -0400
Received: from 8bytes.org ([81.169.241.247]:37804 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905AbaIEKxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:13 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 12/12] iommu: Remove iommu_domain_has_cap() API function
Date: Fri,  5 Sep 2014 12:53:04 +0200
Message-Id: <1409914384-21191-13-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 13 -------------
 include/linux/iommu.h | 11 -----------
 2 files changed, 24 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 319d40e..41c6a7d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -954,19 +954,6 @@ phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
 }
 EXPORT_SYMBOL_GPL(iommu_iova_to_phys);
 
-int iommu_domain_has_cap(struct iommu_domain *domain,
-			 enum iommu_cap cap)
-{
-	if (domain->ops->domain_has_cap != NULL)
-		return domain->ops->domain_has_cap(domain, cap);
-
-	if (domain->ops->capable != NULL)
-		return domain->ops->capable(cap);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
-
 static size_t iommu_pgsize(struct iommu_domain *domain,
 			   unsigned long addr_merge, size_t size)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d5534d5..379a617 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -97,7 +97,6 @@ enum iommu_attr {
  * @map: map a physically contiguous memory region to an iommu domain
  * @unmap: unmap a physically contiguous memory region from an iommu domain
  * @iova_to_phys: translate iova to physical address
- * @domain_has_cap: domain capabilities query
  * @add_device: add device to iommu grouping
  * @remove_device: remove device from iommu grouping
  * @domain_get_attr: Query domain attributes
@@ -115,8 +114,6 @@ struct iommu_ops {
 	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
 		     size_t size);
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain, dma_addr_t iova);
-	int (*domain_has_cap)(struct iommu_domain *domain,
-			      unsigned long cap);
 	int (*add_device)(struct device *dev);
 	void (*remove_device)(struct device *dev);
 	int (*device_group)(struct device *dev, unsigned int *groupid);
@@ -159,8 +156,6 @@ extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 		       size_t size);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
-extern int iommu_domain_has_cap(struct iommu_domain *domain,
-				enum iommu_cap cap);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
 
@@ -314,12 +309,6 @@ static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_ad
 	return 0;
 }
 
-static inline int iommu_domain_has_cap(struct iommu_domain *domain,
-				       enum iommu_cap cap)
-{
-	return 0;
-}
-
 static inline void iommu_set_fault_handler(struct iommu_domain *domain,
 				iommu_fault_handler_t handler, void *token)
 {
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaIEKzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:55:40 -0400
Received: from 8bytes.org ([81.169.241.247]:37762 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbaIEKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:10 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 05/12] iommu/fsl: Convert to iommu_capable() API function
Date: Fri,  5 Sep 2014 12:52:57 +0200
Message-Id: <1409914384-21191-6-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Cc: Varun Sethi <Varun.Sethi@freescale.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/fsl_pamu_domain.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 61d1daf..f43a80d 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -411,8 +411,7 @@ static phys_addr_t fsl_pamu_iova_to_phys(struct iommu_domain *domain,
 	return get_phys_addr(dma_domain, iova);
 }
 
-static int fsl_pamu_domain_has_cap(struct iommu_domain *domain,
-				      unsigned long cap)
+static bool fsl_pamu_capable(enum iommu_cap cap)
 {
 	return cap == IOMMU_CAP_CACHE_COHERENCY;
 }
@@ -1074,6 +1073,7 @@ static u32 fsl_pamu_get_windows(struct iommu_domain *domain)
 }
 
 static const struct iommu_ops fsl_pamu_ops = {
+	.capable	= fsl_pamu_capable,
 	.domain_init	= fsl_pamu_domain_init,
 	.domain_destroy = fsl_pamu_domain_destroy,
 	.attach_dev	= fsl_pamu_attach_device,
@@ -1083,7 +1083,6 @@ static const struct iommu_ops fsl_pamu_ops = {
 	.domain_get_windows = fsl_pamu_get_windows,
 	.domain_set_windows = fsl_pamu_set_windows,
 	.iova_to_phys	= fsl_pamu_iova_to_phys,
-	.domain_has_cap = fsl_pamu_domain_has_cap,
 	.domain_set_attr = fsl_pamu_set_domain_attr,
 	.domain_get_attr = fsl_pamu_get_domain_attr,
 	.add_device	= fsl_pamu_add_device,
-- 
1.9.1


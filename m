Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaIEKxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:53:25 -0400
Received: from 8bytes.org ([81.169.241.247]:37799 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbaIEKxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:13 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 07/12] iommu/msm: Convert to iommu_capable() API function
Date: Fri,  5 Sep 2014 12:52:59 +0200
Message-Id: <1409914384-21191-8-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/msm_iommu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 49f41d6..6e3dcc28 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -603,10 +603,9 @@ fail:
 	return ret;
 }
 
-static int msm_iommu_domain_has_cap(struct iommu_domain *domain,
-				    unsigned long cap)
+static bool msm_iommu_capable(enum iommu_cap cap)
 {
-	return 0;
+	return false;
 }
 
 static void print_ctx_regs(void __iomem *base, int ctx)
@@ -675,6 +674,7 @@ fail:
 }
 
 static const struct iommu_ops msm_iommu_ops = {
+	.capable = msm_iommu_capable,
 	.domain_init = msm_iommu_domain_init,
 	.domain_destroy = msm_iommu_domain_destroy,
 	.attach_dev = msm_iommu_attach_dev,
@@ -682,7 +682,6 @@ static const struct iommu_ops msm_iommu_ops = {
 	.map = msm_iommu_map,
 	.unmap = msm_iommu_unmap,
 	.iova_to_phys = msm_iommu_iova_to_phys,
-	.domain_has_cap = msm_iommu_domain_has_cap,
 	.pgsize_bitmap = MSM_IOMMU_PGSIZES,
 };
 
-- 
1.9.1


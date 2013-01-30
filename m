Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3A3Vn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:43:58 -0500
Received: from 8bytes.org ([85.214.48.195]:56852 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab3A3Vn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:43:57 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/4] iommu: Implement DOMAIN_ATTR_PAGING attribute
Date: Wed, 30 Jan 2013 22:43:47 +0100
Message-Id: <1359582228-21552-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359582228-21552-1-git-send-email-joro@8bytes.org>
References: <1359582228-21552-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan 30 22:43:56 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5109941c22971634968597
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attribute of a domain can be queried to find out if the
domain supports setting up page-tables using the iommu_map()
and iommu_unmap() functions.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/iommu.c |    5 +++++
 include/linux/iommu.h |    1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 622360f..ab9dafd 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -869,6 +869,7 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
 {
 	struct iommu_domain_geometry *geometry;
+	bool *paging;
 	int ret = 0;
 
 	switch (attr) {
@@ -877,6 +878,10 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 		*geometry = domain->geometry;
 
 		break;
+	case DOMAIN_ATTR_PAGING:
+		paging  = data;
+		*paging = (domain->ops->pgsize_bitmap != 0UL);
+		break;
 	default:
 		if (!domain->ops->domain_get_attr)
 			return -EINVAL;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7e6ce72..26066f5 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -59,6 +59,7 @@ struct iommu_domain {
 
 enum iommu_attr {
 	DOMAIN_ATTR_GEOMETRY,
+	DOMAIN_ATTR_PAGING,
 	DOMAIN_ATTR_MAX,
 };
 
-- 
1.7.9.5



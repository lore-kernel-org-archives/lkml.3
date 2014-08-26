Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbaHZJhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:37:36 -0400
Received: from 8bytes.org ([81.169.241.247]:55283 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbaHZJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:36:23 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/4] iommu/amd: Move struct iommu_dev_data to amd_iommu.c
Date: Tue, 26 Aug 2014 11:36:11 +0200
Message-Id: <1409045774-32000-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409045774-32000-1-git-send-email-joro@8bytes.org>
References: <1409045774-32000-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The struct is only used there, so it doesn't need to be in
the header file.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c       | 21 +++++++++++++++++++++
 drivers/iommu/amd_iommu_types.h | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index ecb0109..fe6d7cc 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -88,6 +88,27 @@ int amd_iommu_max_glx_val = -1;
 static struct dma_map_ops amd_iommu_dma_ops;
 
 /*
+ * This struct contains device specific data for the IOMMU
+ */
+struct iommu_dev_data {
+	struct list_head list;		  /* For domain->dev_list */
+	struct list_head dev_data_list;	  /* For global dev_data_list */
+	struct iommu_dev_data *alias_data;/* The alias dev_data */
+	struct protection_domain *domain; /* Domain the device is bound to */
+	atomic_t bind;			  /* Domain attach reference count */
+	u16 devid;			  /* PCI Device ID */
+	bool iommu_v2;			  /* Device can make use of IOMMUv2 */
+	bool passthrough;		  /* Default for device is pt_domain */
+	struct {
+		bool enabled;
+		int qdep;
+	} ats;				  /* ATS state */
+	bool pri_tlp;			  /* PASID TLB required for
+					     PPR completions */
+	u32 errata;			  /* Bitmap for errata to apply */
+};
+
+/*
  * general struct to manage commands send to an IOMMU
  */
 struct iommu_cmd {
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index 8e43b7c..cec51a8 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -418,27 +418,6 @@ struct protection_domain {
 };
 
 /*
- * This struct contains device specific data for the IOMMU
- */
-struct iommu_dev_data {
-	struct list_head list;		  /* For domain->dev_list */
-	struct list_head dev_data_list;	  /* For global dev_data_list */
-	struct iommu_dev_data *alias_data;/* The alias dev_data */
-	struct protection_domain *domain; /* Domain the device is bound to */
-	atomic_t bind;			  /* Domain attach reference count */
-	u16 devid;			  /* PCI Device ID */
-	bool iommu_v2;			  /* Device can make use of IOMMUv2 */
-	bool passthrough;		  /* Default for device is pt_domain */
-	struct {
-		bool enabled;
-		int qdep;
-	} ats;				  /* ATS state */
-	bool pri_tlp;			  /* PASID TLB required for
-					     PPR completions */
-	u32 errata;			  /* Bitmap for errata to apply */
-};
-
-/*
  * For dynamic growth the aperture size is split into ranges of 128MB of
  * DMA address space each. This struct represents one such range.
  */
-- 
1.9.1


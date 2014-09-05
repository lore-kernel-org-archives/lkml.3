Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbaIEKyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:54:22 -0400
Received: from 8bytes.org ([81.169.241.247]:37797 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbaIEKxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:12 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 10/12] vfio: Convert to use new iommu_capable() API function
Date: Fri,  5 Sep 2014 12:53:02 +0200
Message-Id: <1409914384-21191-11-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/vfio/vfio_iommu_type1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0734fbe..562f686 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -713,14 +713,14 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	list_add(&group->next, &domain->group_list);
 
 	if (!allow_unsafe_interrupts &&
-	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
+	    !iommu_capable(bus, IOMMU_CAP_INTR_REMAP)) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
 		goto out_detach;
 	}
 
-	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
+	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
 		domain->prot |= IOMMU_CACHE;
 
 	/*
-- 
1.9.1


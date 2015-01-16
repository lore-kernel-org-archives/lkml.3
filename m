Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbbAPXrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:47:24 -0500
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:46297 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbbAPXrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:47:23 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu: fix trace_unmap() to report original iova
Date: Fri, 16 Jan 2015 16:47:19 -0700
Message-Id: <1421452039-7646-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_unmap() calls trace_unmap() with changed iova and original
size. trace_unmap() should report original iova instead. Change
iommu_unmap() to call trace_unmap() with original iova.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Reported-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fbf8827..2eb7554 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1094,6 +1094,7 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 {
 	size_t unmapped_page, unmapped = 0;
 	unsigned int min_pagesz;
+	unsigned long orig_iova = iova;
 
 	if (unlikely(domain->ops->unmap == NULL ||
 		     domain->ops->pgsize_bitmap == 0UL))
@@ -1133,7 +1134,7 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 		unmapped += unmapped_page;
 	}
 
-	trace_unmap(iova, 0, size);
+	trace_unmap(orig_iova, 0, size);
 	return unmapped;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
-- 
2.1.0


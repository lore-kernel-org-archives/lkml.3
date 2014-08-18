Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaHRWvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:51:14 -0400
Received: from 8bytes.org ([81.169.241.247]:40688 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaHRWuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:50:40 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/3] iommu/core: Check for the right function pointer in iommu_map()
Date: Tue, 19 Aug 2014 00:49:59 +0200
Message-Id: <1408402199-15178-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408402199-15178-1-git-send-email-joro@8bytes.org>
References: <1408402199-15178-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Check for the ->map and not the ->unmap pointer.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1698360..ac4adb3 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -995,7 +995,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	size_t orig_size = size;
 	int ret = 0;
 
-	if (unlikely(domain->ops->unmap == NULL ||
+	if (unlikely(domain->ops->map == NULL ||
 		     domain->ops->pgsize_bitmap == 0UL))
 		return -ENODEV;
 
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423336Ab3FUPdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:33:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423151Ab3FUPdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:33:54 -0400
Subject: [PATCH] iommu: Fix compiler warning on pr_debug
To: joro@8bytes.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 21 Jun 2013 09:33:50 -0600
Message-ID: <20130621153331.2881.35589.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/iommu/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 4b0b56b..ab1fa19 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -820,7 +820,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		size_t pgsize = iommu_pgsize(domain, iova | paddr, size);
 
 		pr_debug("mapping: iova 0x%lx pa 0x%lx pgsize %lu\n", iova,
-					(unsigned long)paddr, pgsize);
+			 (unsigned long)paddr, (unsigned long)pgsize);
 
 		ret = domain->ops->map(domain, iova, paddr, pgsize, prot);
 		if (ret)


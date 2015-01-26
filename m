Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbbAZXvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:51:05 -0500
Received: from 8bytes.org ([81.169.241.247]:50711 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbbAZXue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:50:34 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Varun Sethi <Varun.Sethi@freescale.com>, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 3/4] iommu/omap: Print phys_addr_t using %pa
Date: Tue, 27 Jan 2015 00:50:29 +0100
Message-Id: <1422316230-18893-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316230-18893-1-git-send-email-joro@8bytes.org>
References: <1422316230-18893-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Fixes this compile warning:

drivers/iommu/omap-iommu.c: In function 'omap_iommu_map':
drivers/iommu/omap-iommu.c:1139:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'phys_addr_t' [-Wformat=]
  dev_dbg(dev, "mapping da 0x%lx to pa 0x%x size 0x%x\n", da, pa, bytes);

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/omap-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bbb7dce..f59f857 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1126,7 +1126,7 @@ static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
 		return -EINVAL;
 	}
 
-	dev_dbg(dev, "mapping da 0x%lx to pa 0x%x size 0x%x\n", da, pa, bytes);
+	dev_dbg(dev, "mapping da 0x%lx to pa %pa size 0x%x\n", da, &pa, bytes);
 
 	iotlb_init_entry(&e, da, pa, omap_pgsz);
 
-- 
1.9.1


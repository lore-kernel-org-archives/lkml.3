Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3HVNZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:25:53 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:6512
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab3HVNZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:25:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <joro@8bytes.org>
CC: <joe@perches.com>, <festevam@gmail.com>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] iommu: No need to pass '0x' when '%pa' is used
Date: Thu, 22 Aug 2013 10:25:42 -0300
Message-ID: <1377177942-24965-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6197ca82 (iommu: Use %pa and %zx instead of casting) introduced the 
usage of '%pa', but still kept the '0x', which leads to printing '0x0x'.

Remove the '0x' when '%pa' is used.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/iommu/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fbe9ca7..06d36a0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -807,17 +807,17 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	 * size of the smallest page supported by the hardware
 	 */
 	if (!IS_ALIGNED(iova | paddr | size, min_pagesz)) {
-		pr_err("unaligned: iova 0x%lx pa 0x%pa size 0x%zx min_pagesz 0x%x\n",
+		pr_err("unaligned: iova 0x%lx pa %pa size 0x%zx min_pagesz 0x%x\n",
 		       iova, &paddr, size, min_pagesz);
 		return -EINVAL;
 	}
 
-	pr_debug("map: iova 0x%lx pa 0x%pa size 0x%zx\n", iova, &paddr, size);
+	pr_debug("map: iova 0x%lx pa %pa size 0x%zx\n", iova, &paddr, size);
 
 	while (size) {
 		size_t pgsize = iommu_pgsize(domain, iova | paddr, size);
 
-		pr_debug("mapping: iova 0x%lx pa 0x%pa pgsize 0x%zx\n",
+		pr_debug("mapping: iova 0x%lx pa %pa pgsize 0x%zx\n",
 			 iova, &paddr, pgsize);
 
 		ret = domain->ops->map(domain, iova, paddr, pgsize, prot);
-- 
1.8.1.2



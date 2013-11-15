Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab3KOL5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:57:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:23743 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758690Ab3KOL5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:57:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,707,1378857600"; 
   d="scan'208";a="74838972"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <konrad.wilk@oracle.com>
CC: <stefano.stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] swiotlb-xen: add missing xen_dma_map_page call
Date: Fri, 15 Nov 2013 11:57:33 +0000
Message-ID: <1384516653-28165-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb-xen is missing a xen_dma_map_page call in
xen_swiotlb_map_sg_attrs, in the bounce buffer path.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Changes in v2:
- reworked commit message.
---
 drivers/xen/swiotlb-xen.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index a224bc7..1eac073 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -555,6 +555,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				sg_dma_len(sgl) = 0;
 				return 0;
 			}
+			xen_dma_map_page(hwdev, pfn_to_page(map >> PAGE_SHIFT),
+						map & ~PAGE_MASK,
+						sg->length,
+						dir,
+						attrs);
 			sg->dma_address = xen_phys_to_bus(map);
 		} else {
 			/* we are not interested in the dma_addr returned by
-- 
1.7.2.5


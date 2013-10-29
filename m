Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab3J2AjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:39:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45961 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3J2AjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:39:10 -0400
X-IronPort-AV: E=Sophos;i="4.93,589,1378857600"; 
   d="scan'208";a="68231538"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] swiotlb-xen: fix error code returned by xen_swiotlb_map_sg_attrs
Date: Tue, 29 Oct 2013 00:37:54 +0000
Message-ID: <1383007074-6491-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

map_sg returns the number of elements mapped, not a dma_addr_t.
In case of error return 0, not DMA_ERROR_CODE.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 100962d..8af6862 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -548,7 +548,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
 							   attrs);
 				sg_dma_len(sgl) = 0;
-				return DMA_ERROR_CODE;
+				return 0;
 			}
 			sg->dma_address = xen_phys_to_bus(map);
 		} else {
-- 
1.7.2.5


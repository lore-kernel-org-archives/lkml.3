Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaKURB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:01:27 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45604 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568AbaKURBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:01:25 -0500
X-IronPort-AV: E=Sophos;i="5.07,432,1413244800"; 
   d="scan'208";a="193778969"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
Date: Fri, 21 Nov 2014 17:00:19 +0000
Message-ID: <1416589220-7720-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xen_swiotlb_sync_single we always call xen_dma_sync_single_for_cpu,
even when we should call xen_dma_sync_single_for_device. Fix that.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: konrad.wilk@oracle.com
CC: stable@vger.kernel.org
---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 153cf14..810ad41 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -502,7 +502,7 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 
 	if (target == SYNC_FOR_DEVICE)
-		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
+		xen_dma_sync_single_for_device(hwdev, dev_addr, size, dir);
 
 	if (dir != DMA_FROM_DEVICE)
 		return;
-- 
1.7.10.4


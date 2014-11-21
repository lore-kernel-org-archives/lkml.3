Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbaKURAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:00:49 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48230 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbaKURAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:00:47 -0500
X-IronPort-AV: E=Sophos;i="5.07,432,1413244800"; 
   d="scan'208";a="193778965"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single
Date: Fri, 21 Nov 2014 17:00:20 +0000
Message-ID: <1416589220-7720-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to pass the pointer within the swiotlb internal buffer to the
swiotlb library, that in the case of xen_unmap_single is dev_addr, not
paddr.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: konrad.wilk@oracle.com
CC: stable@vger.kernel.org
---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 810ad41..5ea1e3c 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -451,7 +451,7 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr)) {
-		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
+		swiotlb_tbl_unmap_single(hwdev, dev_addr, size, dir);
 		return;
 	}
 
-- 
1.7.10.4


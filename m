Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaKFRIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:08:07 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:38820 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKFRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:08:04 -0500
From: Frediano Ziglio <frediano.ziglio@huawei.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <frediano.ziglio@huawei.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/arm: Return correct code error for xen_swiotlb_map_page
Date: Thu, 6 Nov 2014 17:07:31 +0000
Message-ID: <1415293651-13917-1-git-send-email-frediano.ziglio@huawei.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.66.28]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM error code is not 0 so avoid to return it as error.

Signed-off-by: Frediano Ziglio <frediano.ziglio@huawei.com>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index ebd8f21..3b8d628 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -425,7 +425,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
 		swiotlb_tbl_unmap_single(dev, map, size, dir);
-		dev_addr = 0;
+		dev_addr = DMA_ERROR_CODE;
 	}
 	return dev_addr;
 }
-- 
1.9.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbbALSQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:16:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbbALSG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 082/216] swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
Date: Mon, 12 Jan 2015 18:03:19 +0000
Message-Id: <1421085933-32536-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 9490c6c67e2f41760de8ece4e4f56f75f84ceb9e upstream.

In xen_swiotlb_sync_single we always call xen_dma_sync_single_for_cpu,
even when we should call xen_dma_sync_single_for_device. Fix that.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index f21282da9876..f3a9d831d0f9 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -500,7 +500,7 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 
 	if (target == SYNC_FOR_DEVICE)
-		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
+		xen_dma_sync_single_for_device(hwdev, dev_addr, size, dir);
 
 	if (dir != DMA_FROM_DEVICE)
 		return;
-- 
2.1.4


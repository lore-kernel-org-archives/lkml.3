Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbbA2Cup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:50:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47041 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729AbbA2CiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 083/139] swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
Date: Wed, 28 Jan 2015 14:20:26 -0800
Message-Id: <1422483682-15393-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 9490c6c67e2f41760de8ece4e4f56f75f84ceb9e upstream.

In xen_swiotlb_sync_single we always call xen_dma_sync_single_for_cpu,
even when we should call xen_dma_sync_single_for_device. Fix that.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index c65f6d0..d277278 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -484,7 +484,7 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 
 	if (target == SYNC_FOR_DEVICE)
-		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
+		xen_dma_sync_single_for_device(hwdev, dev_addr, size, dir);
 
 	if (dir != DMA_FROM_DEVICE)
 		return;
-- 
1.9.1


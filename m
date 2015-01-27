Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbbA0MUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:20:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbbA0MUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 124/126] Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"
Date: Tue, 27 Jan 2015 12:17:09 +0000
Message-Id: <1422361031-19364-125-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit dbdd74763f1faf799fbb9ed30423182e92919378 upstream.

This reverts commit 2c3fc8d26dd09b9d7069687eead849ee81c78e46.

This commit broke on x86 PV because entries in the generic SWIOTLB are
indexed using (pseudo-)physical address not DMA address and these are
not the same in a x86 PV guest.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index de37cc22b9a5..c9d0d5a0e662 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -451,7 +451,7 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr)) {
-		swiotlb_tbl_unmap_single(hwdev, dev_addr, size, dir);
+		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
 		return;
 	}
 
-- 
2.1.4


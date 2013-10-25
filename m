Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3JYLF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:05:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21448 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3JYLF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:05:27 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="64688007"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 15/18] swiotlb: print a warning when the swiotlb is full
Date: Fri, 25 Oct 2013 11:51:50 +0100
Message-ID: <1382698313-13161-15-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Changes in v7:
- use dev_warn instead of pr_warn.
---
 drivers/xen/swiotlb-xen.c |    1 +
 lib/swiotlb.c             |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 4221cb5..4d50058 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -542,6 +542,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 								 sg->length,
 								 dir);
 			if (map == SWIOTLB_MAP_ERROR) {
+				dev_warn(hwdev, "swiotlb buffer is full\n");
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
 				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 4e8686c..cdc051e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -502,6 +502,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 not_found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	dev_warn(hwdev, "swiotlb buffer is full\n");
 	return SWIOTLB_MAP_ERROR;
 found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-- 
1.7.2.5


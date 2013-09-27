Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3I0Qfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:35:37 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36206 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3I0Qfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:35:33 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="55590886"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 14/19] swiotlb: print a warning when the swiotlb is full
Date: Fri, 27 Sep 2013 17:10:02 +0100
Message-ID: <1380298207-29151-14-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |    1 +
 lib/swiotlb.c             |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 96ad316..790c2eb 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -674,6 +674,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 								 sg->length,
 								 dir);
 			if (map == SWIOTLB_MAP_ERROR) {
+				pr_warn("swiotlb buffer is full\n");
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
 				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index eb45d17..f06da0d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -502,6 +502,7 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 
 not_found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
+	pr_warn("swiotlb buffer is full\n");
 	return SWIOTLB_MAP_ERROR;
 found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-- 
1.7.2.5


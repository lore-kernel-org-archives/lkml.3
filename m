Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaFWNqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:46:34 -0400
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:54261 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753987AbaFWNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:4321:4419:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12114:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nose89_8d2f681db1d40
X-Filterd-Recvd-Size: 1678
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org
Subject: [PATCH 14/22] irda: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:42 -0700
Message-Id: <fe9eb5f7868e6f7967b0ccd22d9d8550a990a46a.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/irda/vlsi_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/irda/vlsi_ir.c b/drivers/net/irda/vlsi_ir.c
index 4850066..58ef594 100644
--- a/drivers/net/irda/vlsi_ir.c
+++ b/drivers/net/irda/vlsi_ir.c
@@ -485,13 +485,13 @@ static int vlsi_create_hwif(vlsi_irda_dev_t *idev)
 	idev->virtaddr = NULL;
 	idev->busaddr = 0;
 
-	ringarea = pci_alloc_consistent(idev->pdev, HW_RING_AREA_SIZE, &idev->busaddr);
+	ringarea = pci_zalloc_consistent(idev->pdev, HW_RING_AREA_SIZE,
+					 &idev->busaddr);
 	if (!ringarea) {
 		IRDA_ERROR("%s: insufficient memory for descriptor rings\n",
 			   __func__);
 		goto out;
 	}
-	memset(ringarea, 0, HW_RING_AREA_SIZE);
 
 	hwmap = (struct ring_descr_hw *)ringarea;
 	idev->rx_ring = vlsi_alloc_ring(idev->pdev, hwmap, ringsize[1],
-- 
1.8.1.2.459.gbcd45b4.dirty


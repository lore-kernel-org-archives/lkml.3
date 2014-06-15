Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaFOUmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:42:23 -0400
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:58399 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752673AbaFOUi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:4250:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12517:12519:12555:13311:13357:13523:13524,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plant04_6b05a1e112f0c
X-Filterd-Recvd-Size: 2669
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH -next 17/26] bnx2i: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:46 -0700
Message-Id: <0a345660032e6312bb4cd1bd4abefd0b9836e9e4.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index d6d491c..12d38e8 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1080,16 +1080,15 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 	}
 
 	/* Allocate memory area for actual SQ element */
-	ep->qp.sq_virt =
-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.sq_mem_size,
-				   &ep->qp.sq_phys, GFP_KERNEL);
+	ep->qp.sq_virt = dma_zalloc_coherent(&hba->pcidev->dev,
+					     ep->qp.sq_mem_size,
+					     &ep->qp.sq_phys, GFP_KERNEL);
 	if (!ep->qp.sq_virt) {
 		printk(KERN_ALERT "bnx2i: unable to alloc SQ BD memory %d\n",
 				  ep->qp.sq_mem_size);
 		goto mem_alloc_err;
 	}
 
-	memset(ep->qp.sq_virt, 0x00, ep->qp.sq_mem_size);
 	ep->qp.sq_first_qe = ep->qp.sq_virt;
 	ep->qp.sq_prod_qe = ep->qp.sq_first_qe;
 	ep->qp.sq_cons_qe = ep->qp.sq_first_qe;
@@ -1117,15 +1116,14 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 	}
 
 	/* Allocate memory area for actual CQ element */
-	ep->qp.cq_virt =
-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.cq_mem_size,
-				   &ep->qp.cq_phys, GFP_KERNEL);
+	ep->qp.cq_virt = dma_zalloc_coherent(&hba->pcidev->dev,
+					     ep->qp.cq_mem_size,
+					     &ep->qp.cq_phys, GFP_KERNEL);
 	if (!ep->qp.cq_virt) {
 		printk(KERN_ALERT "bnx2i: unable to alloc CQ BD memory %d\n",
 				  ep->qp.cq_mem_size);
 		goto mem_alloc_err;
 	}
-	memset(ep->qp.cq_virt, 0x00, ep->qp.cq_mem_size);
 
 	ep->qp.cq_first_qe = ep->qp.cq_virt;
 	ep->qp.cq_prod_qe = ep->qp.cq_first_qe;
-- 
1.8.1.2.459.gbcd45b4.dirty


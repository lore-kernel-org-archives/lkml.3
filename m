Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaFOUm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:42:56 -0400
Received: from smtprelay0028.hostedemail.com ([216.40.44.28]:47791 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752465AbaFOUix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3867:4321:4385:5007:6119:6261:7903:8603:10004:10026:10848:11026:11233:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sense95_6a48fb3fbc003
X-Filterd-Recvd-Size: 1888
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH -next 15/26] bfa: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:44 -0700
Message-Id: <bd5384bd59bf7eb9bf616832f5c51fdb96be9764.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/bfad_bsg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 8994fb8..65f3e74 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3270,13 +3270,13 @@ bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 	/* Allocate dma coherent memory */
 	buf_info = buf_base;
 	buf_info->size = payload_len;
-	buf_info->virt = dma_alloc_coherent(&bfad->pcidev->dev, buf_info->size,
-					&buf_info->phys, GFP_KERNEL);
+	buf_info->virt = dma_zalloc_coherent(&bfad->pcidev->dev,
+					     buf_info->size, &buf_info->phys,
+					     GFP_KERNEL);
 	if (!buf_info->virt)
 		goto out_free_mem;
 
 	/* copy the linear bsg buffer to buf_info */
-	memset(buf_info->virt, 0, buf_info->size);
 	memcpy(buf_info->virt, payload_kbuf, buf_info->size);
 
 	/*
-- 
1.8.1.2.459.gbcd45b4.dirty


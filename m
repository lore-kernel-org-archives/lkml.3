Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaFOUiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:21 -0400
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:35987 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752202AbaFOUiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3866:4321:4385:5007:6261:10004:10026:10848:11026:11473:11658:11914:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: books29_655ff332c5232
X-Filterd-Recvd-Size: 1557
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH -next 03/26] ata: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:32 -0700
Message-Id: <2be5da39b914e5f9d845c0f789267e80c188d5b5.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/sata_fsl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 616a6d2..07bc7e4 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -734,13 +734,12 @@ static int sata_fsl_port_start(struct ata_port *ap)
 	if (!pp)
 		return -ENOMEM;
 
-	mem = dma_alloc_coherent(dev, SATA_FSL_PORT_PRIV_DMA_SZ, &mem_dma,
-				 GFP_KERNEL);
+	mem = dma_zalloc_coherent(dev, SATA_FSL_PORT_PRIV_DMA_SZ, &mem_dma,
+				  GFP_KERNEL);
 	if (!mem) {
 		kfree(pp);
 		return -ENOMEM;
 	}
-	memset(mem, 0, SATA_FSL_PORT_PRIV_DMA_SZ);
 
 	pp->cmdslot = mem;
 	pp->cmdslot_paddr = mem_dma;
-- 
1.8.1.2.459.gbcd45b4.dirty


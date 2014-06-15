Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaFOUp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:45:27 -0400
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:54010 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751762AbaFOUiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3866:4385:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rings03_65a88ae2a7c37
X-Filterd-Recvd-Size: 1681
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH -next 04/26] block: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:33 -0700
Message-Id: <ff8b612a77e9c4d5826df68b3e6fe27b800610e9.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/nvme-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index a842c71..27b5d3b 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1242,11 +1242,10 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
 	if (!nvmeq)
 		return NULL;
 
-	nvmeq->cqes = dma_alloc_coherent(dmadev, CQ_SIZE(depth),
-					&nvmeq->cq_dma_addr, GFP_KERNEL);
+	nvmeq->cqes = dma_zalloc_coherent(dmadev, CQ_SIZE(depth),
+					  &nvmeq->cq_dma_addr, GFP_KERNEL);
 	if (!nvmeq->cqes)
 		goto free_nvmeq;
-	memset((void *)nvmeq->cqes, 0, CQ_SIZE(depth));
 
 	nvmeq->sq_cmds = dma_alloc_coherent(dmadev, SQ_SIZE(depth),
 					&nvmeq->sq_dma_addr, GFP_KERNEL);
-- 
1.8.1.2.459.gbcd45b4.dirty


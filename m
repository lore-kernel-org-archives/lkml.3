Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaFOUir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:47 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:49851 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752523AbaFOUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3866:4385:4605:5007:6261:8603:10004:10026:10848:11026:11233:11657:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: club83_68a0c61a4e156
X-Filterd-Recvd-Size: 1749
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH -next 11/26] hisilicon: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:40 -0700
Message-Id: <b147291dd4c9fbf6833fb217bd6bd666cfd66446.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 0ffdcd3..175b25c 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -867,12 +867,11 @@ static int hix5hd2_init_hw_desc_queue(struct hix5hd2_priv *priv)
 
 	for (i = 0; i < QUEUE_NUMS; i++) {
 		size = priv->pool[i].count * sizeof(struct hix5hd2_desc);
-		virt_addr = dma_alloc_coherent(dev, size, &phys_addr,
-					       GFP_KERNEL);
+		virt_addr = dma_zalloc_coherent(dev, size, &phys_addr,
+						GFP_KERNEL);
 		if (virt_addr == NULL)
 			goto error_free_pool;
 
-		memset(virt_addr, 0, size);
 		priv->pool[i].size = size;
 		priv->pool[i].desc = virt_addr;
 		priv->pool[i].phys_addr = phys_addr;
-- 
1.8.1.2.459.gbcd45b4.dirty


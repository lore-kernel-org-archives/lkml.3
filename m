Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaFOUi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:57 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:49854 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632AbaFOUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3867:3868:4250:5007:6261:9592:10004:10026:10848:11026:11657:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shape89_69e7a621c0b62
X-Filterd-Recvd-Size: 1923
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org
Subject: [PATCH -next 14/26] rt2x00: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:43 -0700
Message-Id: <cbc917d6b5c2682ad90ca712eae7da9c041ab1af.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rt2x00/rt2x00mmio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.c b/drivers/net/wireless/rt2x00/rt2x00mmio.c
index 6f236ea..f0178fd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mmio.c
@@ -119,14 +119,12 @@ static int rt2x00mmio_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Allocate DMA memory for descriptor and buffer.
 	 */
-	addr = dma_alloc_coherent(rt2x00dev->dev,
-				  queue->limit * queue->desc_size,
-				  &dma, GFP_KERNEL);
+	addr = dma_zalloc_coherent(rt2x00dev->dev,
+				   queue->limit * queue->desc_size, &dma,
+				   GFP_KERNEL);
 	if (!addr)
 		return -ENOMEM;
 
-	memset(addr, 0, queue->limit * queue->desc_size);
-
 	/*
 	 * Initialize all queue entries to contain valid addresses.
 	 */
-- 
1.8.1.2.459.gbcd45b4.dirty


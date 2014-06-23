Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaFWNsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:48:23 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:38924 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756008AbaFWNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:4321:4419:5007:6261:8603:10004:10026:10848:11026:11657:11658:11914:12043:12114:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jelly34_89ffc39af1611
X-Filterd-Recvd-Size: 2549
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Don Fry <pcnet32@frontier.com>, netdev@vger.kernel.org
Subject: [PATCH 08/22] amd: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:36 -0700
Message-Id: <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index e7cc917..e5e2725 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -484,15 +484,13 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 
 	pcnet32_purge_tx_ring(dev);
 
-	new_tx_ring = pci_alloc_consistent(lp->pci_dev,
-					   sizeof(struct pcnet32_tx_head) *
-					   (1 << size),
-					   &new_ring_dma_addr);
+	new_tx_ring = pci_zalloc_consistent(lp->pci_dev,
+					    sizeof(struct pcnet32_tx_head) * (1 << size),
+					    &new_ring_dma_addr);
 	if (new_tx_ring == NULL) {
 		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
 		return;
 	}
-	memset(new_tx_ring, 0, sizeof(struct pcnet32_tx_head) * (1 << size));
 
 	new_dma_addr_list = kcalloc(1 << size, sizeof(dma_addr_t),
 				    GFP_ATOMIC);
@@ -551,15 +549,13 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 	int new, overlap;
 	unsigned int entries = 1 << size;
 
-	new_rx_ring = pci_alloc_consistent(lp->pci_dev,
-					   sizeof(struct pcnet32_rx_head) *
-					   entries,
-					   &new_ring_dma_addr);
+	new_rx_ring = pci_zalloc_consistent(lp->pci_dev,
+					    sizeof(struct pcnet32_rx_head) * entries,
+					    &new_ring_dma_addr);
 	if (new_rx_ring == NULL) {
 		netif_err(lp, drv, dev, "Consistent memory allocation failed\n");
 		return;
 	}
-	memset(new_rx_ring, 0, sizeof(struct pcnet32_rx_head) * entries);
 
 	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
 	if (!new_dma_addr_list)
-- 
1.8.1.2.459.gbcd45b4.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaFWNrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:47:36 -0400
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:50799 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756025AbaFWNme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:4250:4321:4419:4605:5007:6119:6261:8603:9592:10004:10026:10848:11026:11657:11658:11914:12043:12114:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trip95_8a80e1a44ad19
X-Filterd-Recvd-Size: 1905
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 09/22] atl1e: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:37 -0700
Message-Id: <f5d819ba5c42a3379c94bef8a95410bdd2a88360.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 4345332..316e0c3 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -831,17 +831,14 @@ static int atl1e_setup_ring_resources(struct atl1e_adapter *adapter)
 	/* real ring DMA buffer */
 
 	size = adapter->ring_size;
-	adapter->ring_vir_addr = pci_alloc_consistent(pdev,
-			adapter->ring_size, &adapter->ring_dma);
-
+	adapter->ring_vir_addr = pci_zalloc_consistent(pdev, adapter->ring_size,
+						       &adapter->ring_dma);
 	if (adapter->ring_vir_addr == NULL) {
 		netdev_err(adapter->netdev,
 			   "pci_alloc_consistent failed, size = D%d\n", size);
 		return -ENOMEM;
 	}
 
-	memset(adapter->ring_vir_addr, 0, adapter->ring_size);
-
 	rx_page_desc = rx_ring->rx_page_desc;
 
 	/* Init TPD Ring */
-- 
1.8.1.2.459.gbcd45b4.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaFWNrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:47:07 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:59138 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756042AbaFWNmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1540:1568:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:4321:4419:5007:6261:10004:10026:10848:11026:11473:11657:11658:11914:12043:12114:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hen32_8b5680b1b4c28
X-Filterd-Recvd-Size: 1673
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org
Subject: [PATCH 11/22] sky2: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:39 -0700
Message-Id: <7d711e89ab42c3b92f59479c6eac2f3a8e49afc7.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/marvell/sky2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 6969338..5991514 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1622,11 +1622,10 @@ static int sky2_alloc_buffers(struct sky2_port *sky2)
 	if (!sky2->tx_ring)
 		goto nomem;
 
-	sky2->rx_le = pci_alloc_consistent(hw->pdev, RX_LE_BYTES,
-					   &sky2->rx_le_map);
+	sky2->rx_le = pci_zalloc_consistent(hw->pdev, RX_LE_BYTES,
+					    &sky2->rx_le_map);
 	if (!sky2->rx_le)
 		goto nomem;
-	memset(sky2->rx_le, 0, RX_LE_BYTES);
 
 	sky2->rx_ring = kcalloc(sky2->rx_pending, sizeof(struct rx_ring_info),
 				GFP_KERNEL);
-- 
1.8.1.2.459.gbcd45b4.dirty


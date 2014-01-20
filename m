Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaATRzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:55:09 -0500
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:36046 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753413AbaATRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::,RULES_HIT:41:355:379:541:800:960:973:981:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3866:3867:3868:5007:6261:10004:10026:10848:11026:11658:11914:12043:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bed98_33dd281a7be01
X-Filterd-Recvd-Size: 1788
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] caif_usb: Use ether_addr_copy
Date: Mon, 20 Jan 2014 09:52:17 -0800
Message-Id: <73ad3aea35df9926aa882b2b863d54c2c01e401d.1390239869.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1390239869.git.joe@perches.com>
References: <cover.1390239869.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ether_addr_copy instead of memcpy(a, b, ETH_ALEN) to
save some cycles on arm and powerpc.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/caif/caif_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index 75ed04b..dda589c 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -105,8 +105,8 @@ static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
 	 *	5-11	source address
 	 *	12-13	protocol type
 	 */
-	memcpy(&this->tx_eth_hdr[ETH_ALEN], braddr, ETH_ALEN);
-	memcpy(&this->tx_eth_hdr[ETH_ALEN], ethaddr, ETH_ALEN);
+	ether_addr_copy(&this->tx_eth_hdr[ETH_ALEN], braddr);
+	ether_addr_copy(&this->tx_eth_hdr[ETH_ALEN], ethaddr);
 	this->tx_eth_hdr[12] = cpu_to_be16(ETH_P_802_EX1) & 0xff;
 	this->tx_eth_hdr[13] = (cpu_to_be16(ETH_P_802_EX1) >> 8) & 0xff;
 	pr_debug("caif ethernet TX-header dst:%pM src:%pM type:%02x%02x\n",
-- 
1.8.1.2.459.gbcd45b4.dirty


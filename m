Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaATRyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:54:18 -0500
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:36060 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752156AbaATRwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::,RULES_HIT:41:355:379:541:800:960:973:981:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:5007:6119:6261:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: day69_34bd2561c9e0e
X-Filterd-Recvd-Size: 2400
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] pktgen: Use ether_addr_copy
Date: Mon, 20 Jan 2014 09:52:19 -0800
Message-Id: <66814111bdb4c9db5455b2201a8b9993fb179aea.1390239869.git.joe@perches.com>
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
 net/core/pktgen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index fa3e128..fdac61c 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1440,7 +1440,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (!mac_pton(valstr, pkt_dev->dst_mac))
 			return -EINVAL;
 		/* Set up Dest MAC */
-		memcpy(&pkt_dev->hh[0], pkt_dev->dst_mac, ETH_ALEN);
+		ether_addr_copy(&pkt_dev->hh[0], pkt_dev->dst_mac);
 
 		sprintf(pg_result, "OK: dstmac %pM", pkt_dev->dst_mac);
 		return count;
@@ -1457,7 +1457,7 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (!mac_pton(valstr, pkt_dev->src_mac))
 			return -EINVAL;
 		/* Set up Src MAC */
-		memcpy(&pkt_dev->hh[6], pkt_dev->src_mac, ETH_ALEN);
+		ether_addr_copy(&pkt_dev->hh[6], pkt_dev->src_mac);
 
 		sprintf(pg_result, "OK: srcmac %pM", pkt_dev->src_mac);
 		return count;
@@ -2060,10 +2060,10 @@ static void pktgen_setup_inject(struct pktgen_dev *pkt_dev)
 	/* Default to the interface's mac if not explicitly set. */
 
 	if (is_zero_ether_addr(pkt_dev->src_mac))
-		memcpy(&(pkt_dev->hh[6]), pkt_dev->odev->dev_addr, ETH_ALEN);
+		ether_addr_copy(&(pkt_dev->hh[6]), pkt_dev->odev->dev_addr);
 
 	/* Set up Dest MAC */
-	memcpy(&(pkt_dev->hh[0]), pkt_dev->dst_mac, ETH_ALEN);
+	ether_addr_copy(&(pkt_dev->hh[0]), pkt_dev->dst_mac);
 
 	if (pkt_dev->flags & F_IPV6) {
 		int i, set = 0, err = 1;
-- 
1.8.1.2.459.gbcd45b4.dirty


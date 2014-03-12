Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaCLRYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:24:17 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:56653 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756311AbaCLRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:23:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2729:3138:3139:3140:3141:3142:3352:3865:3866:3872:4225:4321:4605:5007:6261:7903:10004:10026:10848:11026:11473:11657:11658:11914:12043:12220:12296:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: steel13_90b22f4316513
X-Filterd-Recvd-Size: 2576
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/9] xilinx: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:36 -0700
Message-Id: <2722ce785ea17ccd8bdbb20f0accd89232aa2b2a.1394644825.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 4 ++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index a434750..fa193c4 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -771,8 +771,8 @@ static void ll_temac_recv(struct net_device *ndev)
 
 		/* if we're doing rx csum offload, set it up */
 		if (((lp->temac_features & TEMAC_FEATURE_RX_CSUM) != 0) &&
-			(skb->protocol == __constant_htons(ETH_P_IP)) &&
-			(skb->len > 64)) {
+		    (skb->protocol == htons(ETH_P_IP)) &&
+		    (skb->len > 64)) {
 
 			skb->csum = cur_p->app3 & 0xFFFF;
 			skb->ip_summed = CHECKSUM_COMPLETE;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4bfdf8c..7b0a735 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -756,7 +756,7 @@ static void axienet_recv(struct net_device *ndev)
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 			}
 		} else if ((lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) != 0 &&
-			   skb->protocol == __constant_htons(ETH_P_IP) &&
+			   skb->protocol == htons(ETH_P_IP) &&
 			   skb->len > 64) {
 			skb->csum = be32_to_cpu(cur_p->app3 & 0xFFFF);
 			skb->ip_summed = CHECKSUM_COMPLETE;
-- 
1.8.1.2.459.gbcd45b4.dirty


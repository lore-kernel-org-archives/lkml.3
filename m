Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaCLRWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:22:54 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:36334 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752668AbaCLRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:22:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:4250:4321:4605:5007:6119:6261:10004:10026:10848:11026:11233:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dirt63_8cd3e11281d3f
X-Filterd-Recvd-Size: 3198
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Rasesh Mody <rmody@brocade.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/9] brocade: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:30 -0700
Message-Id: <784c96cedcbfc68e05a8814fc8acfb3f142639d9.1394644825.git.joe@perches.com>
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
 drivers/net/ethernet/brocade/bna/bnad.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index aeec9cc..cb76253 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2845,13 +2845,11 @@ bnad_txq_wi_prepare(struct bnad *bnad, struct bna_tcb *tcb,
 		}
 		if (unlikely((gso_size + skb_transport_offset(skb) +
 			      tcp_hdrlen(skb)) >= skb->len)) {
-			txqent->hdr.wi.opcode =
-				__constant_htons(BNA_TXQ_WI_SEND);
+			txqent->hdr.wi.opcode = htons(BNA_TXQ_WI_SEND);
 			txqent->hdr.wi.lso_mss = 0;
 			BNAD_UPDATE_CTR(bnad, tx_skb_tso_too_short);
 		} else {
-			txqent->hdr.wi.opcode =
-				__constant_htons(BNA_TXQ_WI_SEND_LSO);
+			txqent->hdr.wi.opcode = htons(BNA_TXQ_WI_SEND_LSO);
 			txqent->hdr.wi.lso_mss = htons(gso_size);
 		}
 
@@ -2865,7 +2863,7 @@ bnad_txq_wi_prepare(struct bnad *bnad, struct bna_tcb *tcb,
 			htons(BNA_TXQ_WI_L4_HDR_N_OFFSET(
 			tcp_hdrlen(skb) >> 2, skb_transport_offset(skb)));
 	} else  {
-		txqent->hdr.wi.opcode =	__constant_htons(BNA_TXQ_WI_SEND);
+		txqent->hdr.wi.opcode =	htons(BNA_TXQ_WI_SEND);
 		txqent->hdr.wi.lso_mss = 0;
 
 		if (unlikely(skb->len > (bnad->netdev->mtu + ETH_HLEN))) {
@@ -2876,11 +2874,10 @@ bnad_txq_wi_prepare(struct bnad *bnad, struct bna_tcb *tcb,
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
 			u8 proto = 0;
 
-			if (skb->protocol == __constant_htons(ETH_P_IP))
+			if (skb->protocol == htons(ETH_P_IP))
 				proto = ip_hdr(skb)->protocol;
 #ifdef NETIF_F_IPV6_CSUM
-			else if (skb->protocol ==
-				 __constant_htons(ETH_P_IPV6)) {
+			else if (skb->protocol == htons(ETH_P_IPV6)) {
 				/* nexthdr may not be TCP immediately. */
 				proto = ipv6_hdr(skb)->nexthdr;
 			}
@@ -3062,8 +3059,7 @@ bnad_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 			vect_id = 0;
 			BNA_QE_INDX_INC(prod, q_depth);
 			txqent = &((struct bna_txq_entry *)tcb->sw_q)[prod];
-			txqent->hdr.wi_ext.opcode =
-				__constant_htons(BNA_TXQ_WI_EXTENSION);
+			txqent->hdr.wi_ext.opcode = htons(BNA_TXQ_WI_EXTENSION);
 			unmap = &unmap_q[prod];
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty


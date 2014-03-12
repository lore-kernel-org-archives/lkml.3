Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbaCLRGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:06:35 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:35218 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754748AbaCLREp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:04:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: list29_80887c957270d
X-Filterd-Recvd-Size: 3158
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:04:17 -0700
Message-Id: <5bc6ebcb56edc59ea478416474fbbe52200a8cb2.1394643455.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394643455.git.joe@perches.com>
References: <cover.1394643455.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/dev.c            | 10 +++++-----
 net/core/flow_dissector.c | 14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b1b0c8d..587f9fb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3495,11 +3495,11 @@ EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
 static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
 {
 	switch (skb->protocol) {
-	case __constant_htons(ETH_P_ARP):
-	case __constant_htons(ETH_P_IP):
-	case __constant_htons(ETH_P_IPV6):
-	case __constant_htons(ETH_P_8021Q):
-	case __constant_htons(ETH_P_8021AD):
+	case htons(ETH_P_ARP):
+	case htons(ETH_P_IP):
+	case htons(ETH_P_IPV6):
+	case htons(ETH_P_8021Q):
+	case htons(ETH_P_8021AD):
 		return true;
 	default:
 		return false;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index e29e810..80201bf 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -61,7 +61,7 @@ bool skb_flow_dissect(const struct sk_buff *skb, struct flow_keys *flow)
 
 again:
 	switch (proto) {
-	case __constant_htons(ETH_P_IP): {
+	case htons(ETH_P_IP): {
 		const struct iphdr *iph;
 		struct iphdr _iph;
 ip:
@@ -77,7 +77,7 @@ ip:
 		iph_to_flow_copy_addrs(flow, iph);
 		break;
 	}
-	case __constant_htons(ETH_P_IPV6): {
+	case htons(ETH_P_IPV6): {
 		const struct ipv6hdr *iph;
 		struct ipv6hdr _iph;
 ipv6:
@@ -91,8 +91,8 @@ ipv6:
 		nhoff += sizeof(struct ipv6hdr);
 		break;
 	}
-	case __constant_htons(ETH_P_8021AD):
-	case __constant_htons(ETH_P_8021Q): {
+	case htons(ETH_P_8021AD):
+	case htons(ETH_P_8021Q): {
 		const struct vlan_hdr *vlan;
 		struct vlan_hdr _vlan;
 
@@ -104,7 +104,7 @@ ipv6:
 		nhoff += sizeof(*vlan);
 		goto again;
 	}
-	case __constant_htons(ETH_P_PPP_SES): {
+	case htons(ETH_P_PPP_SES): {
 		struct {
 			struct pppoe_hdr hdr;
 			__be16 proto;
@@ -115,9 +115,9 @@ ipv6:
 		proto = hdr->proto;
 		nhoff += PPPOE_SES_HLEN;
 		switch (proto) {
-		case __constant_htons(PPP_IP):
+		case htons(PPP_IP):
 			goto ip;
-		case __constant_htons(PPP_IPV6):
+		case htons(PPP_IPV6):
 			goto ipv6;
 		default:
 			return false;
-- 
1.8.1.2.459.gbcd45b4.dirty


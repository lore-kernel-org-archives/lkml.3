Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaCLRXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:23:03 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:57137 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755506AbaCLRW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:22:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3871:4321:5007:6117:6261:7809:7875:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Net
X-HE-Tag: stew92_8dcf2054a8450
X-Filterd-Recvd-Size: 3603
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/9] igb: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:32 -0700
Message-Id: <0eb4523c7e13dc35a6467332e22a24719f7d7041.1394644825.git.joe@perches.com>
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
 drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 3384156..5476e25 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4546,7 +4546,7 @@ static int igb_tso(struct igb_ring *tx_ring,
 	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
 	type_tucmd = E1000_ADVTXD_TUCMD_L4T_TCP;
 
-	if (first->protocol == __constant_htons(ETH_P_IP)) {
+	if (first->protocol == htons(ETH_P_IP)) {
 		struct iphdr *iph = ip_hdr(skb);
 		iph->tot_len = 0;
 		iph->check = 0;
@@ -4602,12 +4602,12 @@ static void igb_tx_csum(struct igb_ring *tx_ring, struct igb_tx_buffer *first)
 	} else {
 		u8 l4_hdr = 0;
 		switch (first->protocol) {
-		case __constant_htons(ETH_P_IP):
+		case htons(ETH_P_IP):
 			vlan_macip_lens |= skb_network_header_len(skb);
 			type_tucmd |= E1000_ADVTXD_TUCMD_IPV4;
 			l4_hdr = ip_hdr(skb)->protocol;
 			break;
-		case __constant_htons(ETH_P_IPV6):
+		case htons(ETH_P_IPV6):
 			vlan_macip_lens |= skb_network_header_len(skb);
 			l4_hdr = ipv6_hdr(skb)->nexthdr;
 			break;
@@ -6690,7 +6690,7 @@ static unsigned int igb_get_headlen(unsigned char *data,
 	hdr.network += ETH_HLEN;
 
 	/* handle any vlan tag if present */
-	if (protocol == __constant_htons(ETH_P_8021Q)) {
+	if (protocol == htons(ETH_P_8021Q)) {
 		if ((hdr.network - data) > (max_len - VLAN_HLEN))
 			return max_len;
 
@@ -6699,7 +6699,7 @@ static unsigned int igb_get_headlen(unsigned char *data,
 	}
 
 	/* handle L3 protocols */
-	if (protocol == __constant_htons(ETH_P_IP)) {
+	if (protocol == htons(ETH_P_IP)) {
 		if ((hdr.network - data) > (max_len - sizeof(struct iphdr)))
 			return max_len;
 
@@ -6713,7 +6713,7 @@ static unsigned int igb_get_headlen(unsigned char *data,
 		/* record next protocol if header is present */
 		if (!(hdr.ipv4->frag_off & htons(IP_OFFSET)))
 			nexthdr = hdr.ipv4->protocol;
-	} else if (protocol == __constant_htons(ETH_P_IPV6)) {
+	} else if (protocol == htons(ETH_P_IPV6)) {
 		if ((hdr.network - data) > (max_len - sizeof(struct ipv6hdr)))
 			return max_len;
 
-- 
1.8.1.2.459.gbcd45b4.dirty


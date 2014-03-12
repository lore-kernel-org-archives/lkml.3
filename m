Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaCLRXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:23:11 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:36358 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756206AbaCLRXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:23:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2895:3138:3139:3140:3141:3142:3865:3866:3867:3868:3871:3872:4049:4119:4250:4321:5007:6117:6119:6261:7809:7875:7903:9010:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:
X-HE-Tag: quill08_8f3fceee91c01
X-Filterd-Recvd-Size: 8072
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
Subject: [PATCH net-next 5/9] ixgbe: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:34 -0700
Message-Id: <a8b7fce92d51c6c97e1450bc291b0815325935d0.1394644825.git.joe@perches.com>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |  8 +++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 30 +++++++++++++--------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index f58db45..5564331 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -407,13 +407,13 @@ int ixgbe_fcoe_ddp(struct ixgbe_adapter *adapter,
 
 	switch (ixgbe_test_staterr(rx_desc, IXGBE_RXDADV_STAT_FCSTAT)) {
 	/* return 0 to bypass going to ULD for DDPed data */
-	case __constant_cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_DDP):
+	case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_DDP):
 		/* update length of DDPed data */
 		ddp->len = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
 		rc = 0;
 		break;
 	/* unmap the sg list when FCPRSP is received */
-	case __constant_cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_FCPRSP):
+	case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_FCPRSP):
 		dma_unmap_sg(&adapter->pdev->dev, ddp->sgl,
 			     ddp->sgc, DMA_FROM_DEVICE);
 		ddp->err = ddp_err;
@@ -421,14 +421,14 @@ int ixgbe_fcoe_ddp(struct ixgbe_adapter *adapter,
 		ddp->sgc = 0;
 		/* fall through */
 	/* if DDP length is present pass it through to ULD */
-	case __constant_cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_NODDP):
+	case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_NODDP):
 		/* update length of DDPed data */
 		ddp->len = le32_to_cpu(rx_desc->wb.lower.hi_dword.rss);
 		if (ddp->len)
 			rc = ddp->len;
 		break;
 	/* no match will return as an error */
-	case __constant_cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_NOMTCH):
+	case cpu_to_le32(IXGBE_RXDADV_STAT_FCSTAT_NOMTCH):
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 10b35d8..20d2519 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1527,7 +1527,7 @@ static unsigned int ixgbe_get_headlen(unsigned char *data,
 	hdr.network += ETH_HLEN;
 
 	/* handle any vlan tag if present */
-	if (protocol == __constant_htons(ETH_P_8021Q)) {
+	if (protocol == htons(ETH_P_8021Q)) {
 		if ((hdr.network - data) > (max_len - VLAN_HLEN))
 			return max_len;
 
@@ -1536,7 +1536,7 @@ static unsigned int ixgbe_get_headlen(unsigned char *data,
 	}
 
 	/* handle L3 protocols */
-	if (protocol == __constant_htons(ETH_P_IP)) {
+	if (protocol == htons(ETH_P_IP)) {
 		if ((hdr.network - data) > (max_len - sizeof(struct iphdr)))
 			return max_len;
 
@@ -1550,7 +1550,7 @@ static unsigned int ixgbe_get_headlen(unsigned char *data,
 		/* record next protocol if header is present */
 		if (!(hdr.ipv4->frag_off & htons(IP_OFFSET)))
 			nexthdr = hdr.ipv4->protocol;
-	} else if (protocol == __constant_htons(ETH_P_IPV6)) {
+	} else if (protocol == htons(ETH_P_IPV6)) {
 		if ((hdr.network - data) > (max_len - sizeof(struct ipv6hdr)))
 			return max_len;
 
@@ -1558,7 +1558,7 @@ static unsigned int ixgbe_get_headlen(unsigned char *data,
 		nexthdr = hdr.ipv6->nexthdr;
 		hlen = sizeof(struct ipv6hdr);
 #ifdef IXGBE_FCOE
-	} else if (protocol == __constant_htons(ETH_P_FCOE)) {
+	} else if (protocol == htons(ETH_P_FCOE)) {
 		if ((hdr.network - data) > (max_len - FCOE_HEADER_LEN))
 			return max_len;
 		hlen = FCOE_HEADER_LEN;
@@ -6508,7 +6508,7 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
 	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
 	type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_TCP;
 
-	if (first->protocol == __constant_htons(ETH_P_IP)) {
+	if (first->protocol == htons(ETH_P_IP)) {
 		struct iphdr *iph = ip_hdr(skb);
 		iph->tot_len = 0;
 		iph->check = 0;
@@ -6568,12 +6568,12 @@ static void ixgbe_tx_csum(struct ixgbe_ring *tx_ring,
 	} else {
 		u8 l4_hdr = 0;
 		switch (first->protocol) {
-		case __constant_htons(ETH_P_IP):
+		case htons(ETH_P_IP):
 			vlan_macip_lens |= skb_network_header_len(skb);
 			type_tucmd |= IXGBE_ADVTXD_TUCMD_IPV4;
 			l4_hdr = ip_hdr(skb)->protocol;
 			break;
-		case __constant_htons(ETH_P_IPV6):
+		case htons(ETH_P_IPV6):
 			vlan_macip_lens |= skb_network_header_len(skb);
 			l4_hdr = ipv6_hdr(skb)->nexthdr;
 			break;
@@ -6848,9 +6848,9 @@ static void ixgbe_atr(struct ixgbe_ring *ring,
 	hdr.network = skb_network_header(first->skb);
 
 	/* Currently only IPv4/IPv6 with TCP is supported */
-	if ((first->protocol != __constant_htons(ETH_P_IPV6) ||
+	if ((first->protocol != htons(ETH_P_IPV6) ||
 	     hdr.ipv6->nexthdr != IPPROTO_TCP) &&
-	    (first->protocol != __constant_htons(ETH_P_IP) ||
+	    (first->protocol != htons(ETH_P_IP) ||
 	     hdr.ipv4->protocol != IPPROTO_TCP))
 		return;
 
@@ -6883,12 +6883,12 @@ static void ixgbe_atr(struct ixgbe_ring *ring,
 	 * and write the value to source port portion of compressed dword
 	 */
 	if (first->tx_flags & (IXGBE_TX_FLAGS_SW_VLAN | IXGBE_TX_FLAGS_HW_VLAN))
-		common.port.src ^= th->dest ^ __constant_htons(ETH_P_8021Q);
+		common.port.src ^= th->dest ^ htons(ETH_P_8021Q);
 	else
 		common.port.src ^= th->dest ^ first->protocol;
 	common.port.dst ^= th->source;
 
-	if (first->protocol == __constant_htons(ETH_P_IP)) {
+	if (first->protocol == htons(ETH_P_IP)) {
 		input.formatted.flow_type = IXGBE_ATR_FLOW_TYPE_TCPV4;
 		common.ip ^= hdr.ipv4->saddr ^ hdr.ipv4->daddr;
 	} else {
@@ -6954,8 +6954,8 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
 	 * or FIP and we have FCoE enabled on the adapter
 	 */
 	switch (vlan_get_protocol(skb)) {
-	case __constant_htons(ETH_P_FCOE):
-	case __constant_htons(ETH_P_FIP):
+	case htons(ETH_P_FCOE):
+	case htons(ETH_P_FIP):
 		adapter = netdev_priv(dev);
 
 		if (adapter->flags & IXGBE_FLAG_FCOE_ENABLED)
@@ -7016,7 +7016,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 		tx_flags |= vlan_tx_tag_get(skb) << IXGBE_TX_FLAGS_VLAN_SHIFT;
 		tx_flags |= IXGBE_TX_FLAGS_HW_VLAN;
 	/* else if it is a SW VLAN check the next protocol and store the tag */
-	} else if (protocol == __constant_htons(ETH_P_8021Q)) {
+	} else if (protocol == htons(ETH_P_8021Q)) {
 		struct vlan_hdr *vhdr, _vhdr;
 		vhdr = skb_header_pointer(skb, ETH_HLEN, sizeof(_vhdr), &_vhdr);
 		if (!vhdr)
@@ -7075,7 +7075,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 
 #ifdef IXGBE_FCOE
 	/* setup tx offload for FCoE */
-	if ((protocol == __constant_htons(ETH_P_FCOE)) &&
+	if ((protocol == htons(ETH_P_FCOE)) &&
 	    (tx_ring->netdev->features & (NETIF_F_FSO | NETIF_F_FCOE_CRC))) {
 		tso = ixgbe_fso(tx_ring, first, &hdr_len);
 		if (tso < 0)
-- 
1.8.1.2.459.gbcd45b4.dirty


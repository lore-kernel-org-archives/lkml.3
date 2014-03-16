Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaCPTUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:20:34 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47201 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaCPTUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:20:32 -0400
Date: Mon, 17 Mar 2014 08:20:25 +1300
From: Daniel Ngu <daniel.dy.ngu@gmail.com>
To: Jonathan Kim <jonathankim@gctsemi.com>
Cc: Dean ahn <deanahn@gctsemi.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_lte.c: fixed coding style
Message-ID: <20140316192025.GE3478@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line over 80 characters
Unchecked sscanf return value

Signed-off-by: Daniel Ngu <daniel.dy.ngu@gmail.com>
---
 drivers/staging/gdm724x/gdm_lte.c |  182 +++++++++++++++++++++++++------------
 1 file changed, 125 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 74a0360..baaf09f 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -131,7 +131,8 @@ static int gdm_lte_emulate_arp(struct sk_buff *skb_in, u32 nic_type)
 
 	/* Get the pointer of the original request */
 	arp_in = (struct arphdr *)(skb_in->data + mac_header_len);
-	arp_data_in = (struct arpdata *)(skb_in->data + mac_header_len + sizeof(struct arphdr));
+	arp_data_in = (struct arpdata *)(skb_in->data + mac_header_len +
+					 sizeof(struct arphdr));
 
 	/* Get the pointer of the outgoing response */
 	arp_out = (struct arphdr *)arp_temp;
@@ -160,9 +161,12 @@ static int gdm_lte_emulate_arp(struct sk_buff *skb_in, u32 nic_type)
 		return -ENOMEM;
 	skb_reserve(skb_out, NET_IP_ALIGN);
 
-	memcpy(skb_put(skb_out, mac_header_len), mac_header_data, mac_header_len);
-	memcpy(skb_put(skb_out, sizeof(struct arphdr)), arp_out, sizeof(struct arphdr));
-	memcpy(skb_put(skb_out, sizeof(struct arpdata)), arp_data_out, sizeof(struct arpdata));
+	memcpy(skb_put(skb_out, mac_header_len), mac_header_data,
+			mac_header_len);
+	memcpy(skb_put(skb_out, sizeof(struct arphdr)), arp_out,
+			sizeof(struct arphdr));
+	memcpy(skb_put(skb_out, sizeof(struct arpdata)), arp_data_out,
+			sizeof(struct arpdata));
 
 	skb_out->protocol = ((struct ethhdr *)mac_header_data)->h_proto;
 	skb_out->dev = skb_in->dev;
@@ -198,7 +202,8 @@ static int icmp6_checksum(struct ipv6hdr *ipv6, u16 *ptr, int len)
 	pseudo_header.ph.ph_nxt = ipv6->nexthdr;
 
 	w = (u16 *)&pseudo_header;
-	for (i = 0; i < sizeof(pseudo_header.pa) / sizeof(pseudo_header.pa[0]); i++)
+	for (i = 0; i < sizeof(pseudo_header.pa) /
+			sizeof(pseudo_header.pa[0]); i++)
 		sum += pseudo_header.pa[i];
 
 	w = ptr;
@@ -260,11 +265,14 @@ static int gdm_lte_emulate_ndp(struct sk_buff *skb_in, u32 nic_type)
 		return -1;
 
 	/* Check if this is NDP packet */
-	icmp6_in = (struct icmp6hdr *)(skb_in->data + mac_header_len + sizeof(struct ipv6hdr));
+	icmp6_in = (struct icmp6hdr *)(skb_in->data + mac_header_len +
+				       sizeof(struct ipv6hdr));
 	if (icmp6_in->icmp6_type == NDISC_ROUTER_SOLICITATION) { /* Check RS */
 		return -1;
-	} else if (icmp6_in->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) { /* Check NS */
-		u8 icmp_na[sizeof(struct icmp6hdr) + sizeof(struct neighbour_advertisement)];
+	} else if (icmp6_in->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
+		/* Check NS */
+		u8 icmp_na[sizeof(struct icmp6hdr) +
+			   sizeof(struct neighbour_advertisement)];
 		u8 zero_addr8[16] = {0,};
 
 		if (memcmp(ipv6_in->saddr.in6_u.u6_addr8, zero_addr8, 16) == 0)
@@ -274,9 +282,13 @@ static int gdm_lte_emulate_ndp(struct sk_buff *skb_in, u32 nic_type)
 		icmp6_out.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT;
 		icmp6_out.icmp6_code = 0;
 		icmp6_out.icmp6_cksum = 0;
-		icmp6_out.icmp6_dataun.un_data32[0] = htonl(0x60000000); /* R=0, S=1, O=1 */
 
-		ns = (struct neighbour_solicitation *)(skb_in->data + mac_header_len + sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr));
+		/* R=0, S=1, O=1 */
+		icmp6_out.icmp6_dataun.un_data32[0] = htonl(0x60000000);
+
+		ns = (struct neighbour_solicitation *)(skb_in->data +
+				mac_header_len + sizeof(struct ipv6hdr) +
+				sizeof(struct icmp6hdr));
 		memcpy(&na.target_address, ns->target_address, 16);
 		na.type = 0x02;
 		na.length = 1;
@@ -289,13 +301,18 @@ static int gdm_lte_emulate_ndp(struct sk_buff *skb_in, u32 nic_type)
 
 		memcpy(&ipv6_out, ipv6_in, sizeof(struct ipv6hdr));
 		memcpy(ipv6_out.saddr.in6_u.u6_addr8, &na.target_address, 16);
-		memcpy(ipv6_out.daddr.in6_u.u6_addr8, ipv6_in->saddr.in6_u.u6_addr8, 16);
-		ipv6_out.payload_len = htons(sizeof(struct icmp6hdr) + sizeof(struct neighbour_advertisement));
+		memcpy(ipv6_out.daddr.in6_u.u6_addr8,
+				ipv6_in->saddr.in6_u.u6_addr8, 16);
+		ipv6_out.payload_len = htons(sizeof(struct icmp6hdr) +
+				sizeof(struct neighbour_advertisement));
 
 		memcpy(icmp_na, &icmp6_out, sizeof(struct icmp6hdr));
-		memcpy(icmp_na + sizeof(struct icmp6hdr), &na, sizeof(struct neighbour_advertisement));
+		memcpy(icmp_na + sizeof(struct icmp6hdr), &na,
+				sizeof(struct neighbour_advertisement));
 
-		icmp6_out.icmp6_cksum = icmp6_checksum(&ipv6_out, (u16 *)icmp_na, sizeof(icmp_na));
+		icmp6_out.icmp6_cksum = icmp6_checksum(&ipv6_out,
+						       (u16 *)icmp_na,
+						       sizeof(icmp_na));
 	} else {
 		return -1;
 	}
@@ -311,10 +328,14 @@ static int gdm_lte_emulate_ndp(struct sk_buff *skb_in, u32 nic_type)
 		return -ENOMEM;
 	skb_reserve(skb_out, NET_IP_ALIGN);
 
-	memcpy(skb_put(skb_out, mac_header_len), mac_header_data, mac_header_len);
-	memcpy(skb_put(skb_out, sizeof(struct ipv6hdr)), &ipv6_out, sizeof(struct ipv6hdr));
-	memcpy(skb_put(skb_out, sizeof(struct icmp6hdr)), &icmp6_out, sizeof(struct icmp6hdr));
-	memcpy(skb_put(skb_out, sizeof(struct neighbour_advertisement)), &na, sizeof(struct neighbour_advertisement));
+	memcpy(skb_put(skb_out, mac_header_len), mac_header_data,
+			mac_header_len);
+	memcpy(skb_put(skb_out, sizeof(struct ipv6hdr)), &ipv6_out,
+			sizeof(struct ipv6hdr));
+	memcpy(skb_put(skb_out, sizeof(struct icmp6hdr)), &icmp6_out,
+			sizeof(struct icmp6hdr));
+	memcpy(skb_put(skb_out, sizeof(struct neighbour_advertisement)), &na,
+			sizeof(struct neighbour_advertisement));
 
 	skb_out->protocol = ((struct ethhdr *)mac_header_data)->h_proto;
 	skb_out->dev = skb_in->dev;
@@ -363,7 +384,8 @@ static s32 gdm_lte_tx_nic_type(struct net_device *dev, struct sk_buff *skb)
 
 		/* Check DHCPv4 */
 		if (ip->protocol == IPPROTO_UDP) {
-			struct udphdr *udp = (struct udphdr *)(network_data + sizeof(struct iphdr));
+			struct udphdr *udp = (struct udphdr *)(network_data +
+					      sizeof(struct iphdr));
 			if (ntohs(udp->dest) == 67 || ntohs(udp->dest) == 68)
 				nic_type |= NIC_TYPE_F_DHCP;
 		}
@@ -373,12 +395,15 @@ static s32 gdm_lte_tx_nic_type(struct net_device *dev, struct sk_buff *skb)
 		ipv6 = (struct ipv6hdr *)network_data;
 
 		if (ipv6->nexthdr == IPPROTO_ICMPV6) /* Check NDP request */ {
-			struct icmp6hdr *icmp6 = (struct icmp6hdr *)(network_data + sizeof(struct ipv6hdr));
-			if (/*icmp6->icmp6_type == NDISC_ROUTER_SOLICITATION || */
-				icmp6->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION)
+			struct icmp6hdr *icmp6 = (struct icmp6hdr *)(
+					network_data + sizeof(struct ipv6hdr));
+			if (/*icmp6->icmp6_type == NDISC_ROUTER_SOLICITATION ||
+			     */
+			    icmp6->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION)
 				nic_type |= NIC_TYPE_ICMPV6;
 		} else if (ipv6->nexthdr == IPPROTO_UDP) /* Check DHCPv6 */ {
-			struct udphdr *udp = (struct udphdr *)(network_data + sizeof(struct ipv6hdr));
+			struct udphdr *udp = (struct udphdr *)(network_data +
+					      sizeof(struct ipv6hdr));
 			if (ntohs(udp->dest) == 546 || ntohs(udp->dest) == 547)
 				nic_type |= NIC_TYPE_F_DHCP;
 		}
@@ -421,9 +446,10 @@ static int gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
 
 	/*
 	Need byte shift (that is, remove VLAN tag) if there is one
-	For the case of ARP, this breaks the offset as vlan_ethhdr+4 is treated as ethhdr
-	However, it shouldn't be a problem as the response starts from arp_hdr and ethhdr
-	is created by this driver based on the NIC mac
+	For the case of ARP, this breaks the offset as vlan_ethhdr+4 is treated
+	as ethhdr
+	However, it shouldn't be a problem as the response starts from arp_hdr
+	and ethhdr is created by this driver based on the NIC mac
 	*/
 	if (nic_type & NIC_TYPE_F_VLAN) {
 		struct vlan_ethhdr *vlan_eth = (struct vlan_ethhdr *)skb->data;
@@ -436,15 +462,18 @@ static int gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
 		data_len = skb->len;
 	}
 
-	/* If it is a ICMPV6 packet, clear all the other bits : for backward compatibility with the firmware */
+	/* If it is a ICMPV6 packet, clear all the other bits : for backward
+	 * compatibility with the firmware */
 	if (nic_type & NIC_TYPE_ICMPV6)
 		nic_type = NIC_TYPE_ICMPV6;
 
-	/* If it is not a dhcp packet, clear all the flag bits : original NIC, otherwise the special flag (IPVX | DHCP) */
+	/* If it is not a dhcp packet, clear all the flag bits : original NIC,
+	 * otherwise the special flag (IPVX | DHCP) */
 	if (!(nic_type & NIC_TYPE_F_DHCP))
 		nic_type &= NIC_TYPE_MASK;
 
-	sscanf(dev->name, "lte%d", &idx);
+	if (sscanf(dev->name, "lte%d", &idx) != 1)
+		return -EINVAL;
 
 	ret = nic->phy_dev->send_sdu_func(nic->phy_dev->priv_dev,
 					  data_buf, data_len,
@@ -486,7 +515,8 @@ static int gdm_lte_event_send(struct net_device *dev, char *buf, int len)
 	struct hci_packet *hci = (struct hci_packet *)buf;
 	int idx;
 
-	sscanf(dev->name, "lte%d", &idx);
+	if (sscanf(dev->name, "lte%d", &idx) != 1)
+		return -EINVAL;
 
 	return netlink_send(lte_event.sock, idx, 0, buf,
 			    gdm_dev16_to_cpu(
@@ -495,7 +525,8 @@ static int gdm_lte_event_send(struct net_device *dev, char *buf, int len)
 			    + HCI_HEADER_SIZE);
 }
 
-static void gdm_lte_event_rcv(struct net_device *dev, u16 type, void *msg, int len)
+static void gdm_lte_event_rcv(struct net_device *dev, u16 type, void *msg,
+			      int len)
 {
 	struct nic *nic = netdev_priv(dev);
 
@@ -536,7 +567,8 @@ static u8 find_dev_index(u32 nic_type)
 	return index;
 }
 
-static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len, int flagged_nic_type)
+static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len,
+			     int flagged_nic_type)
 {
 	u32 nic_type;
 	struct nic *nic;
@@ -551,28 +583,41 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len, int fla
 	nic = netdev_priv(dev);
 
 	if (flagged_nic_type & NIC_TYPE_F_DHCP) {
-		/* Change the destination mac address with the one requested the IP */
+		/* Change the destination mac address with the one requested
+		 * the IP */
 		if (flagged_nic_type & NIC_TYPE_F_IPV4) {
 			struct dhcp_packet {
 				u8 op;      /* BOOTREQUEST or BOOTREPLY */
-				u8 htype;   /* hardware address type. 1 = 10mb ethernet */
+				u8 htype;   /* hardware address type.
+					       1 = 10mb ethernet */
 				u8 hlen;    /* hardware address length */
 				u8 hops;    /* used by relay agents only */
 				u32 xid;    /* unique id */
-				u16 secs;   /* elapsed since client began acquisition/renewal */
+				u16 secs;   /* elapsed since client began
+					       acquisition/renewal */
 				u16 flags;  /* only one flag so far: */
-				#define BROADCAST_FLAG 0x8000 /* "I need broadcast replies" */
-				u32 ciaddr; /* client IP (if client is in BOUND, RENEW or REBINDING state) */
+				#define BROADCAST_FLAG 0x8000 /* "I need
+								 broadcast
+								 replies" */
+				u32 ciaddr; /* client IP (if client is in
+					       BOUND, RENEW or REBINDING
+					       state) */
 				u32 yiaddr; /* 'your' (client) IP address */
-				/* IP address of next server to use in bootstrap, returned in DHCPOFFER, DHCPACK by server */
+				/* IP address of next server to use in
+				 * bootstrap, returned in DHCPOFFER, DHCPACK by
+				 * server */
 				u32 siaddr_nip;
 				u32 gateway_nip; /* relay agent IP address */
-				u8 chaddr[16];   /* link-layer client hardware address (MAC) */
+				u8 chaddr[16];   /* link-layer client hardware
+						    address (MAC) */
 				u8 sname[64];    /* server host name (ASCIZ) */
 				u8 file[128];    /* boot file name (ASCIZ) */
-				u32 cookie;      /* fixed first four option bytes (99,130,83,99 dec) */
+				u32 cookie;      /* fixed first four option
+						    bytes (99,130,83,99 dec) */
 			} __packed;
-			void *addr = buf + sizeof(struct iphdr) + sizeof(struct udphdr) + offsetof(struct dhcp_packet, chaddr);
+			void *addr = buf + sizeof(struct iphdr) +
+				     sizeof(struct udphdr) +
+				     offsetof(struct dhcp_packet, chaddr);
 			memcpy(nic->dest_mac_addr, addr, ETH_ALEN);
 		}
 	}
@@ -593,7 +638,8 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len, int fla
 	vlan_eth.h_vlan_proto = htons(ETH_P_8021Q);
 
 	if (nic_type == NIC_TYPE_ARP) {
-		/* Should be response: Only happens because there was a request from the host */
+		/* Should be response: Only happens because there was a request
+		 * from the host */
 		eth.h_proto = htons(ETH_P_ARP);
 		vlan_eth.h_vlan_encapsulated_proto = htons(ETH_P_ARP);
 	} else {
@@ -640,15 +686,25 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 	u32 nic_type;
 	u8 index;
 
-	hci_len = gdm_dev16_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), multi_sdu->len);
-	num_packet = gdm_dev16_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), multi_sdu->num_packet);
+	hci_len = gdm_dev16_to_cpu(
+			phy_dev->get_endian(phy_dev->priv_dev),
+			multi_sdu->len);
+	num_packet = gdm_dev16_to_cpu(
+			phy_dev->get_endian(phy_dev->priv_dev),
+			multi_sdu->num_packet);
 
 	for (i = 0; i < num_packet; i++) {
 		sdu = (struct sdu *)data;
 
-		cmd_evt = gdm_dev16_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), sdu->cmd_evt);
-		hci_len = gdm_dev16_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), sdu->len);
-		nic_type = gdm_dev32_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), sdu->nic_type);
+		cmd_evt = gdm_dev16_to_cpu(
+				phy_dev->get_endian(phy_dev->priv_dev),
+				sdu->cmd_evt);
+		hci_len = gdm_dev16_to_cpu(
+				phy_dev->get_endian(phy_dev->priv_dev),
+				sdu->len);
+		nic_type = gdm_dev32_to_cpu(
+				phy_dev->get_endian(phy_dev->priv_dev),
+				sdu->nic_type);
 
 		if (cmd_evt != LTE_RX_SDU) {
 			pr_err("rx sdu wrong hci %04x\n", cmd_evt);
@@ -662,7 +718,8 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 		index = find_dev_index(nic_type);
 		if (index < MAX_NIC_TYPE) {
 			dev = phy_dev->dev[index];
-			gdm_lte_netif_rx(dev, (char *)sdu->data, (int)(hci_len-12), nic_type);
+			gdm_lte_netif_rx(dev, (char *)sdu->data,
+					 (int)(hci_len-12), nic_type);
 		} else {
 			pr_err("rx sdu invalid nic_type :%x\n", nic_type);
 		}
@@ -709,7 +766,8 @@ static int gdm_lte_receive_pkt(struct phy_dev *phy_dev, char *buf, int len)
 	if (!len)
 		return ret;
 
-	cmd_evt = gdm_dev16_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), hci->cmd_evt);
+	cmd_evt = gdm_dev16_to_cpu(phy_dev->get_endian(phy_dev->priv_dev),
+				   hci->cmd_evt);
 
 	dev = phy_dev->dev[0];
 	if (dev == NULL)
@@ -718,7 +776,9 @@ static int gdm_lte_receive_pkt(struct phy_dev *phy_dev, char *buf, int len)
 	switch (cmd_evt) {
 	case LTE_RX_SDU:
 		sdu = (struct sdu *)hci->data;
-		nic_type = gdm_dev32_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), sdu->nic_type);
+		nic_type = gdm_dev32_to_cpu(
+				phy_dev->get_endian(phy_dev->priv_dev),
+				sdu->nic_type);
 		index = find_dev_index(nic_type);
 		dev = phy_dev->dev[index];
 		gdm_lte_netif_rx(dev, hci->data, len, nic_type);
@@ -733,7 +793,9 @@ static int gdm_lte_receive_pkt(struct phy_dev *phy_dev, char *buf, int len)
 		break;
 	case LTE_PDN_TABLE_IND:
 		pdn_table = (struct hci_pdn_table_ind *)buf;
-		nic_type = gdm_dev32_to_cpu(phy_dev->get_endian(phy_dev->priv_dev), pdn_table->nic_type);
+		nic_type = gdm_dev32_to_cpu(
+				phy_dev->get_endian(phy_dev->priv_dev),
+				pdn_table->nic_type);
 		index = find_dev_index(nic_type);
 		dev = phy_dev->dev[index];
 		gdm_lte_pdn_table(dev, buf, len);
@@ -758,7 +820,8 @@ void start_rx_proc(struct phy_dev *phy_dev)
 	int i;
 
 	for (i = 0; i < MAX_RX_SUBMIT_COUNT; i++)
-		phy_dev->rcv_func(phy_dev->priv_dev, rx_complete, phy_dev, USB_COMPLETE);
+		phy_dev->rcv_func(phy_dev->priv_dev, rx_complete, phy_dev,
+				  USB_COMPLETE);
 }
 
 static struct net_device_ops gdm_netdev_ops = {
@@ -771,7 +834,8 @@ static struct net_device_ops gdm_netdev_ops = {
 
 static u8 gdm_lte_macaddr[ETH_ALEN] = {0x00, 0x0a, 0x3b, 0x00, 0x00, 0x00};
 
-static void form_mac_address(u8 *dev_addr, u8 *nic_src, u8 *nic_dest, u8 *mac_address, u8 index)
+static void form_mac_address(u8 *dev_addr, u8 *nic_src, u8 *nic_dest,
+			     u8 *mac_address, u8 index)
 {
 	/* Form the dev_addr */
 	if (!mac_address)
@@ -779,10 +843,12 @@ static void form_mac_address(u8 *dev_addr, u8 *nic_src, u8 *nic_dest, u8 *mac_ad
 	else
 		memcpy(dev_addr, mac_address, ETH_ALEN);
 
-	/* The last byte of the mac address should be less than or equal to 0xFC */
+	/* The last byte of the mac address should be less than or equal to
+	 * 0xFC */
 	dev_addr[ETH_ALEN-1] += index;
 
-	/* Create random nic src and copy the first 3 bytes to be the same as dev_addr */
+	/* Create random nic src and copy the first 3 bytes to be the same as
+	 * dev_addr */
 	random_ether_addr(nic_src);
 	memcpy(nic_src, dev_addr, 3);
 
@@ -799,7 +865,8 @@ static void validate_mac_address(u8 *mac_address)
 	}
 }
 
-int register_lte_device(struct phy_dev *phy_dev, struct device *dev, u8 *mac_address)
+int register_lte_device(struct phy_dev *phy_dev, struct device *dev,
+			u8 *mac_address)
 {
 	struct nic *nic;
 	struct net_device *net;
@@ -814,7 +881,8 @@ int register_lte_device(struct phy_dev *phy_dev, struct device *dev, u8 *mac_add
 		sprintf(pdn_dev_name, "lte%%dpdn%d", index);
 
 		/* Allocate netdev */
-		net = alloc_netdev(sizeof(struct nic), pdn_dev_name, ether_setup);
+		net = alloc_netdev(sizeof(struct nic), pdn_dev_name,
+				   ether_setup);
 		if (net == NULL) {
 			pr_err("alloc_netdev failed\n");
 			ret = -ENOMEM;
-- 
1.7.9.5


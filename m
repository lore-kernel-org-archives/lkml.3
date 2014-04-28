Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbaD1VTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:19:00 -0400
Received: from mail-ig0-f194.google.com ([209.85.213.194]:55663 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaD1VS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:18:58 -0400
X-Greylist: delayed 5894 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2014 17:18:58 EDT
From: Junsu Shin <jsshin.dev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Junsu Shin <jsshin.dev@gmail.com>
Subject: [PATCH] Staging: gdm72xx: gdm_wimax: Fixed coding style issues.
Date: Mon, 28 Apr 2014 13:50:11 -0500
Message-Id: <1398711011-3834-1-git-send-email-jsshin.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed following coding style issues.
 - No space is necessary after a cast
 - Alignment should match open parenthesis
 - Braces {} should be used on all arms of this statement

Signed-off-by: Junsu Shin <jsshin.dev@gmail.com>x
---
 drivers/staging/gdm72xx/gdm_wimax.c |   71 ++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 05ce2a2..a3ba931 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -135,24 +135,24 @@ static void dump_eth_packet(struct net_device *dev, const char *title,
 	u16 port = 0;
 
 	protocol = (data[12]<<8) | data[13];
-	ih = (struct iphdr *) (data+ETH_HLEN);
+	ih = (struct iphdr *)(data+ETH_HLEN);
 
 	if (protocol == ETH_P_IP) {
-		uh = (struct udphdr *) ((char *)ih + sizeof(struct iphdr));
+		uh = (struct udphdr *)((char *)ih + sizeof(struct iphdr));
 		ip_protocol = ih->protocol;
 		port = ntohs(uh->dest);
 	} else if (protocol == ETH_P_IPV6) {
-		struct ipv6hdr *i6h = (struct ipv6hdr *) data;
-		uh = (struct udphdr *) ((char *)i6h + sizeof(struct ipv6hdr));
+		struct ipv6hdr *i6h = (struct ipv6hdr *)data;
+		uh = (struct udphdr *)((char *)i6h + sizeof(struct ipv6hdr));
 		ip_protocol = i6h->nexthdr;
 		port = ntohs(uh->dest);
 	}
 
 	netdev_dbg(dev, "[%s] len=%d, %s, %s, %s\n",
-		title, len,
-		get_protocol_name(protocol),
-		get_ip_protocol_name(ip_protocol),
-		get_port_name(port));
+		   title, len,
+		   get_protocol_name(protocol),
+		   get_ip_protocol_name(ip_protocol),
+		   get_port_name(port));
 
 	if (!(data[0] == 0xff && data[1] == 0xff)) {
 		if (protocol == ETH_P_IP)
@@ -196,7 +196,7 @@ static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
 {
 	struct nic *nic = netdev_priv(dev);
 
-	u8 *buf = (u8 *) msg;
+	u8 *buf = (u8 *)msg;
 	u16 hci_cmd =  (buf[0]<<8) | buf[1];
 	u16 hci_len = (buf[2]<<8) | buf[3];
 	netdev_dbg(dev, "H=>D: 0x%04x(%d)\n", hci_cmd, hci_len);
@@ -263,9 +263,9 @@ static struct evt_entry *get_event_entry(void)
 {
 	struct evt_entry *e;
 
-	if (list_empty(&wm_event.freeq))
+	if (list_empty(&wm_event.freeq)) {
 		e = alloc_event_entry();
-	else {
+	} else {
 		e = list_entry(wm_event.freeq.next, struct evt_entry, list);
 		list_del(&e->list);
 	}
@@ -347,7 +347,7 @@ int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev)
 	struct nic *nic = netdev_priv(dev);
 
 	ret = gdm_wimax_send_with_cb(nic, skb->data, skb->len, tx_complete,
-					nic);
+				     nic);
 	if (ret == -ENOSPC) {
 		netif_stop_queue(dev);
 		ret = 0;
@@ -368,7 +368,7 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int ret = 0;
 	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	dump_eth_packet(dev, "TX", skb->data, skb->len);
 
@@ -379,9 +379,9 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	#if !defined(LOOPBACK_TEST)
-	if (!fsm)
+	if (!fsm) {
 		netdev_err(dev, "ASSERTION ERROR: fsm is NULL!!\n");
-	else if (fsm->m_status != M_CONNECTED) {
+	} else if (fsm->m_status != M_CONNECTED) {
 		netdev_emerg(dev, "ASSERTION ERROR: Device is NOT ready. status=%d\n",
 			     fsm->m_status);
 		kfree_skb(skb);
@@ -408,7 +408,7 @@ static int gdm_wimax_set_config(struct net_device *dev, struct ifmap *map)
 static void __gdm_wimax_set_mac_addr(struct net_device *dev, char *mac_addr)
 {
 	u16 hci_pkt_buf[32 / sizeof(u16)];
-	u8 *pkt = (u8 *) &hci_pkt_buf[0];
+	u8 *pkt = (u8 *)&hci_pkt_buf[0];
 	struct nic *nic = netdev_priv(dev);
 
 	/* Since dev is registered as a ethernet device,
@@ -454,7 +454,7 @@ static struct net_device_stats *gdm_wimax_stats(struct net_device *dev)
 static int gdm_wimax_open(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	netif_start_queue(dev);
 
@@ -466,7 +466,7 @@ static int gdm_wimax_open(struct net_device *dev)
 static int gdm_wimax_close(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	netif_stop_queue(dev);
 
@@ -537,16 +537,16 @@ static void gdm_update_fsm(struct net_device *dev, struct fsm_s *new_fsm)
 {
 	struct nic *nic = netdev_priv(dev);
 	struct fsm_s *cur_fsm =
-		(struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+		(struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	if (!cur_fsm)
 		return;
 
 	if (cur_fsm->m_status != new_fsm->m_status ||
-		cur_fsm->c_status != new_fsm->c_status) {
-		if (new_fsm->m_status == M_CONNECTED)
+	    cur_fsm->c_status != new_fsm->c_status) {
+		if (new_fsm->m_status == M_CONNECTED) {
 			netif_carrier_on(dev);
-		else if (cur_fsm->m_status == M_CONNECTED) {
+		} else if (cur_fsm->m_status == M_CONNECTED) {
 			netif_carrier_off(dev);
 			#if defined(CONFIG_WIMAX_GDM72XX_QOS)
 			gdm_qos_release_list(nic);
@@ -558,7 +558,7 @@ static void gdm_update_fsm(struct net_device *dev, struct fsm_s *new_fsm)
 
 static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	struct wm_req_s *req = (struct wm_req_s *) ifr;
+	struct wm_req_s *req = (struct wm_req_s *)ifr;
 	struct nic *nic = netdev_priv(dev);
 	int ret;
 
@@ -574,8 +574,9 @@ static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			return -EOPNOTSUPP;
 		}
 		if (req->cmd == SIOCG_DATA) {
-			ret = gdm_wimax_ioctl_get_data(&req->data,
-						&nic->sdk_data[req->data_id]);
+			ret = gdm_wimax_ioctl_get_data(
+				&req->data,
+				&nic->sdk_data[req->data_id]);
 			if (ret < 0)
 				return ret;
 		} else if (req->cmd == SIOCS_DATA) {
@@ -583,7 +584,7 @@ static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				/*NOTE: gdm_update_fsm should be called
 				before gdm_wimax_ioctl_set_data is called*/
 				gdm_update_fsm(dev,
-						(struct fsm_s *) req->data.buf);
+					       (struct fsm_s *)req->data.buf);
 			}
 			ret = gdm_wimax_ioctl_set_data(
 				&nic->sdk_data[req->data_id], &req->data);
@@ -603,7 +604,7 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
 	u16 buf[32 / sizeof(u16)];
-	struct hci_s *hci = (struct hci_s *) buf;
+	struct hci_s *hci = (struct hci_s *)buf;
 	u16 len = 0;
 	u32 val = 0;
 
@@ -661,7 +662,7 @@ static int gdm_wimax_hci_get_tlv(u8 *buf, u8 *T, u16 *L, u8 **V)
 }
 
 static int gdm_wimax_get_prepared_info(struct net_device *dev, char *buf,
-					int len)
+				       int len)
 {
 	u8 T, *V;
 	u16 L;
@@ -740,7 +741,7 @@ static void gdm_wimax_transmit_aggr_pkt(struct net_device *dev, char *buf,
 	int length;
 
 	while (len > 0) {
-		hci = (struct hci_s *) buf;
+		hci = (struct hci_s *)buf;
 
 		if (B2H(hci->cmd_evt) != WIMAX_RX_SDU) {
 			netdev_err(dev, "Wrong cmd_evt(0x%04X)\n",
@@ -786,7 +787,7 @@ static void gdm_wimax_transmit_pkt(struct net_device *dev, char *buf, int len)
 	switch (cmd_evt) {
 	case WIMAX_RX_SDU_AGGR:
 		gdm_wimax_transmit_aggr_pkt(dev, &buf[HCI_HEADER_SIZE],
-						cmd_len);
+					    cmd_len);
 		break;
 	case WIMAX_RX_SDU:
 		gdm_wimax_netif_rx(dev, &buf[HCI_HEADER_SIZE], cmd_len);
@@ -822,13 +823,13 @@ static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm)
 	memcpy(&hci_pkt_buf[HCI_HEADER_SIZE], fsm, sizeof(struct fsm_s));
 
 	gdm_wimax_event_send(dev, hci_pkt_buf,
-				HCI_HEADER_SIZE + sizeof(struct fsm_s));
+			     HCI_HEADER_SIZE + sizeof(struct fsm_s));
 }
 
 static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up)
 {
 	u16 buf[32 / sizeof(u16)];
-	struct hci_s *hci = (struct hci_s *) buf;
+	struct hci_s *hci = (struct hci_s *)buf;
 	unsigned char up_down;
 
 	up_down = if_up ? WIMAX_IF_UP : WIMAX_IF_DOWN;
@@ -855,9 +856,9 @@ static void prepare_rx_complete(void *arg, void *data, int len)
 	int ret;
 
 	ret = gdm_wimax_get_prepared_info(nic->netdev, data, len);
-	if (ret == 1)
+	if (ret == 1) {
 		gdm_wimax_rcv_with_cb(nic, rx_complete, nic);
-	else {
+	} else {
 		if (ret < 0)
 			netdev_err(nic->netdev,
 				   "get_prepared_info failed(%d)\n", ret);
@@ -948,7 +949,7 @@ cleanup:
 void unregister_wimax_device(struct phy_dev *phy_dev)
 {
 	struct nic *nic = netdev_priv(phy_dev->netdev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	if (fsm)
 		fsm->m_status = M_INIT;
-- 
1.7.9.5


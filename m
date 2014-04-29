Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaD2CVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:21:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39488 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbaD2CVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:21:15 -0400
X-Sasl-enc: HnoOWeR0swW8y+dVS71F8HVydH7JoZg8bzsieKaiojZp 1398738073
Message-ID: <535F0C66.5000001@fastmail.fm>
Date: Tue, 29 Apr 2014 10:20:22 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/10] staging: gdm72xx: Whitespace fixes to conform to
 coding standards
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Whitespace fixes to conform to coding standards

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_qos.c   | 72 ++++++++++++++++++-------------------
 drivers/staging/gdm72xx/gdm_sdio.c  | 15 ++++----
 drivers/staging/gdm72xx/gdm_usb.c   | 43 ++++++++--------------
 drivers/staging/gdm72xx/gdm_wimax.c | 61 +++++++++++++++----------------
 drivers/staging/gdm72xx/gdm_wimax.h |  6 ++--
 drivers/staging/gdm72xx/netlink_k.c |  5 ++-
 drivers/staging/gdm72xx/netlink_k.h |  4 +--
 drivers/staging/gdm72xx/usb_boot.c  | 18 +++++-----
 8 files changed, 101 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 465f695..33df46a 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -47,8 +47,7 @@ static void *alloc_qos_entry(void)
 
 	spin_lock_irqsave(&qos_free_list.lock, flags);
 	if (qos_free_list.cnt) {
-		entry = list_entry(qos_free_list.head.prev, struct qos_entry_s,
-					list);
+		entry = list_entry(qos_free_list.head.prev, struct qos_entry_s, list);
 		list_del(&entry->list);
 		qos_free_list.cnt--;
 		spin_unlock_irqrestore(&qos_free_list.lock, flags);
@@ -62,7 +61,7 @@ static void *alloc_qos_entry(void)
 
 static void free_qos_entry(void *entry)
 {
-	struct qos_entry_s *qentry = (struct qos_entry_s *) entry;
+	struct qos_entry_s *qentry = (struct qos_entry_s *)entry;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qos_free_list.lock, flags);
@@ -148,7 +147,7 @@ static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *stream, u8 *port)
 
 	if (csr->classifier_rule_en&IPTYPEOFSERVICE) {
 		if (((stream[1] & csr->ip2s_mask) < csr->ip2s_lo) ||
-		((stream[1] & csr->ip2s_mask) > csr->ip2s_hi))
+		    ((stream[1] & csr->ip2s_mask) > csr->ip2s_hi))
 			return 1;
 	}
 
@@ -190,7 +189,7 @@ static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *stream, u8 *port)
 
 static u32 get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
 {
-	u32	IP_ver, i;
+	u32 IP_ver, i;
 	struct qos_cb_s *qcb = &nic->qos;
 
 	if (iph == NULL || tcpudph == NULL)
@@ -198,16 +197,16 @@ static u32 get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
 
 	IP_ver = (iph[0]>>4)&0xf;
 
-	if (IP_ver == 4) {
-		for (i = 0; i < QOS_MAX; i++) {
-			if (qcb->csr[i].enabled) {
-				if (qcb->csr[i].classifier_rule_en) {
-					if (chk_ipv4_rule(&qcb->csr[i], iph,
-					tcpudph) == 0)
-						return i;
-				}
-			}
-		}
+	if (IP_ver != 4)
+		return -1;
+
+	for (i = 0; i < QOS_MAX; i++) {
+		if (!qcb->csr[i].enabled)
+			continue;
+		if (!qcb->csr[i].classifier_rule_en)
+			continue;
+		if (chk_ipv4_rule(&qcb->csr[i], iph, tcpudph) == 0)
+			return i;
 	}
 
 	return -1;
@@ -222,22 +221,20 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
 	INIT_LIST_HEAD(head);
 
 	for (i = 0; i < QOS_MAX; i++) {
-		if (qcb->csr[i].enabled) {
-			if (qcb->csr[i].qos_buf_count < qcb->qos_limit_size) {
-				if (!list_empty(&qcb->qos_list[i])) {
-					entry = list_entry(
-					qcb->qos_list[i].prev,
-					struct qos_entry_s, list);
-					list_move_tail(&entry->list, head);
-					qcb->csr[i].qos_buf_count++;
-
-					if (!list_empty(&qcb->qos_list[i]))
-						netdev_warn(nic->netdev,
-							    "Index(%d) is piled!!\n",
-							    i);
-				}
-			}
-		}
+		if (!qcb->csr[i].enabled)
+			continue;
+		if (qcb->csr[i].qos_buf_count >= qcb->qos_limit_size)
+			continue;
+		if (list_empty(&qcb->qos_list[i]))
+			continue;
+
+		entry = list_entry(qcb->qos_list[i].prev, struct qos_entry_s, list);
+
+		list_move_tail(&entry->list, head);
+		qcb->csr[i].qos_buf_count++;
+
+		if (!list_empty(&qcb->qos_list[i]))
+			netdev_warn(nic->netdev, "Index(%d) is piled!!\n", i);
 	}
 
 	return 0;
@@ -260,14 +257,14 @@ int gdm_qos_send_hci_pkt(struct sk_buff *skb, struct net_device *dev)
 	int index;
 	struct qos_cb_s *qcb = &nic->qos;
 	unsigned long flags;
-	struct ethhdr *ethh = (struct ethhdr *) (skb->data + HCI_HEADER_SIZE);
-	struct iphdr *iph = (struct iphdr *) ((char *) ethh + ETH_HLEN);
+	struct ethhdr *ethh = (struct ethhdr *)(skb->data + HCI_HEADER_SIZE);
+	struct iphdr *iph = (struct iphdr *)((char *)ethh + ETH_HLEN);
 	struct tcphdr *tcph;
 	struct qos_entry_s *entry = NULL;
 	struct list_head send_list;
 	int ret = 0;
 
-	tcph = (struct tcphdr *) iph + iph->ihl*4;
+	tcph = (struct tcphdr *)iph + iph->ihl*4;
 
 	if (B2H(ethh->h_proto) == ETH_P_IP) {
 		if (qcb->qos_list_cnt && !qos_free_list.cnt) {
@@ -280,7 +277,7 @@ int gdm_qos_send_hci_pkt(struct sk_buff *skb, struct net_device *dev)
 
 		spin_lock_irqsave(&qcb->qos_lock, flags);
 		if (qcb->qos_list_cnt) {
-			index = get_qos_index(nic, (u8 *)iph, (u8 *) tcph);
+			index = get_qos_index(nic, (u8 *)iph, (u8 *)tcph);
 			if (index == -1)
 				index = qcb->qos_null_idx;
 
@@ -376,7 +373,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 	index = get_csr(qcb, SFID, 1);
 	if (index == -1) {
 		netdev_err(nic->netdev,
-			   "QoS ERROR: csr Update Error / Wrong index (%d) \n",
+			   "QoS ERROR: csr Update Error / Wrong index (%d)\n",
 			   index);
 		return;
 	}
@@ -433,8 +430,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 		qcb->qos_list_cnt--;
 		qcb->qos_limit_size = 254/qcb->qos_list_cnt;
 
-		list_for_each_entry_safe(entry, n, &qcb->qos_list[index],
-					list) {
+		list_for_each_entry_safe(entry, n, &qcb->qos_list[index], list) {
 			list_move_tail(&entry->list, &free_list);
 		}
 		spin_unlock_irqrestore(&qcb->qos_lock, flags);
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index c246537..07be325 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -312,8 +312,7 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
-static void send_hci(struct sdio_func *func, struct tx_cxt *tx,
-			struct sdio_tx *t)
+static void send_hci(struct sdio_func *func, struct tx_cxt *tx, struct sdio_tx *t)
 {
 	unsigned long flags;
 
@@ -380,7 +379,7 @@ static void do_tx(struct work_struct *work)
 }
 
 static int gdm_sdio_send(void *priv_dev, void *data, int len,
-			void (*cb)(void *data), void *cb_data)
+			 void (*cb)(void *data), void *cb_data)
 {
 	struct sdiowm_dev *sdev = priv_dev;
 	struct tx_cxt *tx = &sdev->tx;
@@ -510,6 +509,7 @@ static void gdm_sdio_irq(struct sdio_func *func)
 
 	if (hdr[3] == 1) {	/* Ack */
 		u32 *ack_seq = (u32 *)&hdr[4];
+
 		spin_lock_irqsave(&tx->lock, flags);
 		tx->can_send = 1;
 
@@ -521,7 +521,7 @@ static void gdm_sdio_irq(struct sdio_func *func)
 	}
 
 	memcpy(rx->rx_buf, hdr + TYPE_A_HEADER_SIZE,
-			TYPE_A_LOOKAHEAD_SIZE - TYPE_A_HEADER_SIZE);
+	       TYPE_A_LOOKAHEAD_SIZE - TYPE_A_HEADER_SIZE);
 
 	buf = rx->rx_buf + TYPE_A_LOOKAHEAD_SIZE - TYPE_A_HEADER_SIZE;
 	remain = len - TYPE_A_LOOKAHEAD_SIZE + TYPE_A_HEADER_SIZE;
@@ -577,8 +577,8 @@ done:
 }
 
 static int gdm_sdio_receive(void *priv_dev,
-				void (*cb)(void *cb_data, void *data, int len),
-				void *cb_data)
+			    void (*cb)(void *cb_data, void *data, int len),
+			    void *cb_data)
 {
 	struct sdiowm_dev *sdev = priv_dev;
 	struct rx_cxt *rx = &sdev->rx;
@@ -601,8 +601,7 @@ static int gdm_sdio_receive(void *priv_dev,
 	return 0;
 }
 
-static int sdio_wimax_probe(struct sdio_func *func,
-				const struct sdio_device_id *id)
+static int sdio_wimax_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
 	int ret;
 	struct phy_dev *phy_dev = NULL;
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index b9d7643..c7298d0 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -344,16 +344,11 @@ static int gdm_usb_send(void *priv_dev, void *data, int len,
 	if ((len % 512) == 0)
 		len++;
 
-	usb_fill_bulk_urb(t->urb,
-			usbdev,
-			usb_sndbulkpipe(usbdev, 1),
-			t->buf,
-			len + padding,
-			gdm_usb_send_complete,
-			t);
-
-	print_hex_dump_debug("usb_send: ", DUMP_PREFIX_NONE, 16, 1,
-			     t->buf, len + padding, false);
+	usb_fill_bulk_urb(t->urb, usbdev, usb_sndbulkpipe(usbdev, 1), t->buf,
+			  len + padding, gdm_usb_send_complete, t);
+
+	print_hex_dump_debug("usb_send: ", DUMP_PREFIX_NONE, 16, 1, t->buf,
+			     len + padding, false);
 #ifdef CONFIG_WIMAX_GDM72XX_USB_PM
 	if (usbdev->state & USB_STATE_SUSPENDED) {
 		list_add_tail(&t->p_list, &tx->pending_list);
@@ -470,8 +465,8 @@ static void gdm_usb_rcv_complete(struct urb *urb)
 }
 
 static int gdm_usb_receive(void *priv_dev,
-			void (*cb)(void *cb_data, void *data, int len),
-			void *cb_data)
+			   void (*cb)(void *cb_data, void *data, int len),
+			   void *cb_data)
 {
 	struct usbwm_dev *udev = priv_dev;
 	struct usb_device *usbdev = udev->usbdev;
@@ -494,13 +489,8 @@ static int gdm_usb_receive(void *priv_dev,
 	r->callback = cb;
 	r->cb_data = cb_data;
 
-	usb_fill_bulk_urb(r->urb,
-			usbdev,
-			usb_rcvbulkpipe(usbdev, 0x82),
-			r->buf,
-			RX_BUF_SIZE,
-			gdm_usb_rcv_complete,
-			r);
+	usb_fill_bulk_urb(r->urb, usbdev, usb_rcvbulkpipe(usbdev, 0x82), r->buf,
+			  RX_BUF_SIZE, gdm_usb_rcv_complete, r);
 
 	return usb_submit_urb(r->urb, GFP_ATOMIC);
 }
@@ -519,7 +509,7 @@ static void do_pm_control(struct work_struct *work)
 
 	spin_lock_irqsave(&tx->lock, flags);
 	if (!(udev->usbdev->state & USB_STATE_SUSPENDED) &&
-	     (!list_empty(&tx->hci_list) || !list_empty(&tx->sdu_list))) {
+	    (!list_empty(&tx->hci_list) || !list_empty(&tx->sdu_list))) {
 		struct usb_tx *t, *temp;
 
 		list_for_each_entry_safe(t, temp, &tx->pending_list, p_list) {
@@ -536,8 +526,7 @@ static void do_pm_control(struct work_struct *work)
 }
 #endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
 
-static int gdm_usb_probe(struct usb_interface *intf,
-				const struct usb_device_id *id)
+static int gdm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	int ret = 0;
 	u8 bConfigurationValue;
@@ -566,8 +555,7 @@ static int gdm_usb_probe(struct usb_interface *intf,
 	}
 
 	/* Support for EEPROM bootloader */
-	if (bConfigurationValue == DOWNLOAD_CONF_VALUE ||
-		idProduct & B_DOWNLOAD) {
+	if (bConfigurationValue == DOWNLOAD_CONF_VALUE || idProduct & B_DOWNLOAD) {
 		ret = usb_boot(usbdev, bcdDevice);
 		goto out;
 	}
@@ -639,8 +627,8 @@ static void gdm_usb_disconnect(struct usb_interface *intf)
 	idProduct = L2H(usbdev->descriptor.idProduct);
 
 	if (idProduct != EMERGENCY_PID &&
-			bConfigurationValue != DOWNLOAD_CONF_VALUE &&
-			(idProduct & B_DOWNLOAD) == 0) {
+	    bConfigurationValue != DOWNLOAD_CONF_VALUE && (idProduct & B_DOWNLOAD) == 0) {
+
 		udev = phy_dev->priv_dev;
 		udev->usbdev = NULL;
 
@@ -742,8 +730,7 @@ static int k_mode_thread(void *arg)
 
 			spin_lock_irqsave(&tx->lock, flags);
 
-			list_for_each_entry_safe(t, temp, &tx->pending_list,
-						p_list) {
+			list_for_each_entry_safe(t, temp, &tx->pending_list, p_list) {
 				list_del(&t->p_list);
 				ret = usb_submit_urb(t->urb, GFP_ATOMIC);
 
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 3ccb083..094e9c9 100644
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
+
+		uh = (struct udphdr *)((char *)i6h + sizeof(struct ipv6hdr));
 		ip_protocol = i6h->nexthdr;
 		port = ntohs(uh->dest);
 	}
 
-	netdev_dbg(dev, "[%s] len=%d, %s, %s, %s\n",
-		title, len,
-		get_protocol_name(protocol),
-		get_ip_protocol_name(ip_protocol),
-		get_port_name(port));
+	netdev_dbg(dev, "[%s] len=%d, %s, %s, %s\n", title, len,
+		   get_protocol_name(protocol),
+		   get_ip_protocol_name(ip_protocol),
+		   get_port_name(port));
 
 	if (!(data[0] == 0xff && data[1] == 0xff)) {
 		if (protocol == ETH_P_IP)
@@ -196,9 +196,10 @@ static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
 {
 	struct nic *nic = netdev_priv(dev);
 
-	u8 *buf = (u8 *) msg;
+	u8 *buf = (u8 *)msg;
 	u16 hci_cmd =  (buf[0]<<8) | buf[1];
 	u16 hci_len = (buf[2]<<8) | buf[3];
+
 	netdev_dbg(dev, "H=>D: 0x%04x(%d)\n", hci_cmd, hci_len);
 
 	gdm_wimax_send(nic, msg, len);
@@ -310,6 +311,7 @@ static int gdm_wimax_event_send(struct net_device *dev, char *buf, int size)
 
 	u16 hci_cmd =  ((u8)buf[0]<<8) | (u8)buf[1];
 	u16 hci_len = ((u8)buf[2]<<8) | (u8)buf[3];
+
 	netdev_dbg(dev, "D=>H: 0x%04x(%d)\n", hci_cmd, hci_len);
 
 	spin_lock_irqsave(&wm_event.evt_lock, flags);
@@ -346,8 +348,7 @@ int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev)
 	int ret = 0;
 	struct nic *nic = netdev_priv(dev);
 
-	ret = gdm_wimax_send_with_cb(nic, skb->data, skb->len, tx_complete,
-					nic);
+	ret = gdm_wimax_send_with_cb(nic, skb->data, skb->len, tx_complete, nic);
 	if (ret == -ENOSPC) {
 		netif_stop_queue(dev);
 		ret = 0;
@@ -368,7 +369,7 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int ret = 0;
 	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	dump_eth_packet(dev, "TX", skb->data, skb->len);
 
@@ -408,7 +409,7 @@ static int gdm_wimax_set_config(struct net_device *dev, struct ifmap *map)
 static void __gdm_wimax_set_mac_addr(struct net_device *dev, char *mac_addr)
 {
 	u16 hci_pkt_buf[32 / sizeof(u16)];
-	u8 *pkt = (u8 *) &hci_pkt_buf[0];
+	u8 *pkt = (u8 *)&hci_pkt_buf[0];
 	struct nic *nic = netdev_priv(dev);
 
 	/* Since dev is registered as a ethernet device,
@@ -454,7 +455,7 @@ static struct net_device_stats *gdm_wimax_stats(struct net_device *dev)
 static int gdm_wimax_open(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	netif_start_queue(dev);
 
@@ -466,7 +467,7 @@ static int gdm_wimax_open(struct net_device *dev)
 static int gdm_wimax_close(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	netif_stop_queue(dev);
 
@@ -536,14 +537,13 @@ static void gdm_wimax_cleanup_ioctl(struct net_device *dev)
 static void gdm_update_fsm(struct net_device *dev, struct fsm_s *new_fsm)
 {
 	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *cur_fsm =
-		(struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *cur_fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	if (!cur_fsm)
 		return;
 
 	if (cur_fsm->m_status != new_fsm->m_status ||
-		cur_fsm->c_status != new_fsm->c_status) {
+	    cur_fsm->c_status != new_fsm->c_status) {
 		if (new_fsm->m_status == M_CONNECTED) {
 			netif_carrier_on(dev);
 		} else if (cur_fsm->m_status == M_CONNECTED) {
@@ -558,7 +558,7 @@ static void gdm_update_fsm(struct net_device *dev, struct fsm_s *new_fsm)
 
 static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	struct wm_req_s *req = (struct wm_req_s *) ifr;
+	struct wm_req_s *req = (struct wm_req_s *)ifr;
 	struct nic *nic = netdev_priv(dev);
 	int ret;
 
@@ -575,15 +575,14 @@ static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		}
 		if (req->cmd == SIOCG_DATA) {
 			ret = gdm_wimax_ioctl_get_data(&req->data,
-						&nic->sdk_data[req->data_id]);
+						       &nic->sdk_data[req->data_id]);
 			if (ret < 0)
 				return ret;
 		} else if (req->cmd == SIOCS_DATA) {
 			if (req->data_id == SIOC_DATA_FSM) {
 				/*NOTE: gdm_update_fsm should be called
 				before gdm_wimax_ioctl_set_data is called*/
-				gdm_update_fsm(dev,
-						(struct fsm_s *) req->data.buf);
+				gdm_update_fsm(dev, (struct fsm_s *)req->data.buf);
 			}
 			ret = gdm_wimax_ioctl_set_data(
 				&nic->sdk_data[req->data_id], &req->data);
@@ -603,7 +602,7 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
 	u16 buf[32 / sizeof(u16)];
-	struct hci_s *hci = (struct hci_s *) buf;
+	struct hci_s *hci = (struct hci_s *)buf;
 	u16 len = 0;
 	u32 val = 0;
 
@@ -660,8 +659,7 @@ static int gdm_wimax_hci_get_tlv(u8 *buf, u8 *T, u16 *L, u8 **V)
 	return next_pos;
 }
 
-static int gdm_wimax_get_prepared_info(struct net_device *dev, char *buf,
-					int len)
+static int gdm_wimax_get_prepared_info(struct net_device *dev, char *buf, int len)
 {
 	u8 T, *V;
 	u16 L;
@@ -740,7 +738,7 @@ static void gdm_wimax_transmit_aggr_pkt(struct net_device *dev, char *buf,
 	int length;
 
 	while (len > 0) {
-		hci = (struct hci_s *) buf;
+		hci = (struct hci_s *)buf;
 
 		if (B2H(hci->cmd_evt) != WIMAX_RX_SDU) {
 			netdev_err(dev, "Wrong cmd_evt(0x%04X)\n",
@@ -785,8 +783,7 @@ static void gdm_wimax_transmit_pkt(struct net_device *dev, char *buf, int len)
 
 	switch (cmd_evt) {
 	case WIMAX_RX_SDU_AGGR:
-		gdm_wimax_transmit_aggr_pkt(dev, &buf[HCI_HEADER_SIZE],
-						cmd_len);
+		gdm_wimax_transmit_aggr_pkt(dev, &buf[HCI_HEADER_SIZE], cmd_len);
 		break;
 	case WIMAX_RX_SDU:
 		gdm_wimax_netif_rx(dev, &buf[HCI_HEADER_SIZE], cmd_len);
@@ -822,13 +819,13 @@ static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm)
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
@@ -944,7 +941,7 @@ cleanup:
 void unregister_wimax_device(struct phy_dev *phy_dev)
 {
 	struct nic *nic = netdev_priv(phy_dev->netdev);
-	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	if (fsm)
 		fsm->m_status = M_INIT;
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index 55212f5..21087c03 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -38,10 +38,10 @@ struct phy_dev {
 	struct net_device	*netdev;
 
 	int	(*send_func)(void *priv_dev, void *data, int len,
-			void (*cb)(void *cb_data), void *cb_data);
+			     void (*cb)(void *cb_data), void *cb_data);
 	int	(*rcv_func)(void *priv_dev,
-			void (*cb)(void *cb_data, void *data, int len),
-			void *cb_data);
+			    void (*cb)(void *cb_data, void *data, int len),
+			    void *cb_data);
 };
 
 struct nic {
diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 52317c7..06f7b13 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -55,8 +55,7 @@ static void netlink_rcv_cb(struct sk_buff *skb)
 	if (skb->len >= NLMSG_HDRLEN) {
 		nlh = (struct nlmsghdr *)skb->data;
 
-		if (skb->len < nlh->nlmsg_len ||
-		nlh->nlmsg_len > ND_MAX_MSG_LEN) {
+		if (skb->len < nlh->nlmsg_len || nlh->nlmsg_len > ND_MAX_MSG_LEN) {
 			netdev_err(skb->dev, "Invalid length (%d,%d)\n",
 				   skb->len, nlh->nlmsg_len);
 			return;
@@ -89,7 +88,7 @@ static void netlink_rcv(struct sk_buff *skb)
 }
 
 struct sock *netlink_init(int unit, void (*cb)(struct net_device *dev, u16 type,
-						void *msg, int len))
+					       void *msg, int len))
 {
 	struct sock *sock;
 	struct netlink_kernel_cfg cfg = {
diff --git a/drivers/staging/gdm72xx/netlink_k.h b/drivers/staging/gdm72xx/netlink_k.h
index 1dffaa6..b6caac1 100644
--- a/drivers/staging/gdm72xx/netlink_k.h
+++ b/drivers/staging/gdm72xx/netlink_k.h
@@ -16,8 +16,8 @@
 #include <linux/netdevice.h>
 #include <net/sock.h>
 
-struct sock *netlink_init(int unit,
-	void (*cb)(struct net_device *dev, u16 type, void *msg, int len));
+struct sock *netlink_init(int unit, void (*cb)(struct net_device *dev, u16 type,
+					       void *msg, int len));
 void netlink_exit(struct sock *sock);
 int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len);
 
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index 8518a5a..75149d7 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -67,6 +67,7 @@ struct fw_info {
 static void array_le32_to_cpu(u32 *arr, int num)
 {
 	int i;
+
 	for (i = 0; i < num; i++, arr++)
 		*arr = __le32_to_cpu(*arr);
 }
@@ -79,7 +80,7 @@ static int gdm_wibro_send(struct usb_device *usbdev, void *data, int len)
 	int actual;
 
 	ret = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 1), data, len,
-			&actual, 1000);
+			   &actual, 1000);
 
 	if (ret < 0) {
 		dev_err(&usbdev->dev, "Error : usb_bulk_msg ( result = %d )\n",
@@ -95,7 +96,7 @@ static int gdm_wibro_recv(struct usb_device *usbdev, void *data, int len)
 	int actual;
 
 	ret = usb_bulk_msg(usbdev, usb_rcvbulkpipe(usbdev, 2), data, len,
-			&actual, 5000);
+			   &actual, 5000);
 
 	if (ret < 0) {
 		dev_err(&usbdev->dev,
@@ -105,9 +106,8 @@ static int gdm_wibro_recv(struct usb_device *usbdev, void *data, int len)
 	return 0;
 }
 
-static int download_image(struct usb_device *usbdev,
-				const struct firmware *firm,
-				loff_t pos, u32 img_len, u32 magic_num)
+static int download_image(struct usb_device *usbdev, const struct firmware *firm,
+			  loff_t pos, u32 img_len, u32 magic_num)
 {
 	struct dn_header h;
 	int ret = 0;
@@ -204,8 +204,8 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 			goto out;
 		}
 
-		ret = download_image(usbdev, firm, pos,
-				fw_info.kernel_len, DN_KERNEL_MAGIC_NUMBER);
+		ret = download_image(usbdev, firm, pos, fw_info.kernel_len,
+				     DN_KERNEL_MAGIC_NUMBER);
 		if (ret < 0)
 			goto out;
 		dev_info(&usbdev->dev, "GCT: Kernel download success.\n");
@@ -216,7 +216,7 @@ int usb_boot(struct usb_device *usbdev, u16 pid)
 			goto out;
 		}
 		ret = download_image(usbdev, firm, pos, fw_info.rootfs_len,
-				DN_ROOTFS_MAGIC_NUMBER);
+				     DN_ROOTFS_MAGIC_NUMBER);
 		if (ret < 0)
 			goto out;
 		dev_info(&usbdev->dev, "GCT: Filesystem download success.\n");
@@ -261,7 +261,7 @@ out:
 }
 
 static int em_download_image(struct usb_device *usbdev, const char *img_name,
-				char *type_string)
+			     char *type_string)
 {
 	char *buf = NULL;
 	loff_t pos = 0;
-- 
1.8.4


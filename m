Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaEHGYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:24:07 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:56380 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaEHGYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:24:05 -0400
X-Google-Original-From: Adithya K
From: Adithya K <linux.challenge1@gmail.com>
To: standby24x7@gmail.com, dan.carpenter@oracle.com, khoroshilov@ispras.ru,
        arnd@arndb.de, burzalodowa@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: Adithya K <linux.challenge1@gmail.com>
Subject: [PATCH] Staging: gdm72xx Fix minor coding style problems 
Date: Thu,  8 May 2014 11:53:57 +0530
Message-Id: <1399530237-1788-1-git-send-email-user@akrishna-Latitude-E6430>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch for fixing of minor coding style problems.

Signed-off-by: Adithya K <linux.challenge1@gmail.com>
---
 drivers/staging/gdm72xx/gdm_qos.c   |    3 ++-
 drivers/staging/gdm72xx/gdm_sdio.c  |    1 +
 drivers/staging/gdm72xx/gdm_usb.c   |    2 +-
 drivers/staging/gdm72xx/gdm_wimax.c |    3 +++
 drivers/staging/gdm72xx/usb_boot.c  |    1 +
 5 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 50d43ad..5ed32b9 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -229,6 +229,7 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
 					entry = list_entry(
 					qcb->qos_list[i].prev,
 					struct qos_entry_s, list);
+
 					list_move_tail(&entry->list, head);
 					qcb->csr[i].qos_buf_count++;
 
@@ -377,7 +378,7 @@ void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 	index = get_csr(qcb, SFID, 1);
 	if (index == -1) {
 		netdev_err(nic->netdev,
-			   "QoS ERROR: csr Update Error / Wrong index (%d) \n",
+			   "QoS ERROR: csr Update Error / Wrong index (%d)\n",
 			   index);
 		return;
 	}
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index c246537..4d5ccf8 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -510,6 +510,7 @@ static void gdm_sdio_irq(struct sdio_func *func)
 
 	if (hdr[3] == 1) {	/* Ack */
 		u32 *ack_seq = (u32 *)&hdr[4];
+
 		spin_lock_irqsave(&tx->lock, flags);
 		tx->can_send = 1;
 
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 20539d8..8fd1b1f 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -759,7 +759,7 @@ static int k_mode_thread(void *arg)
 			spin_lock_irqsave(&k_lock, flags2);
 		}
 		wait_event_interruptible_lock_irq(k_wait,
-						  !list_empty(&k_list) || k_mode_stop,
+		!list_empty(&k_list) || k_mode_stop,
 						  k_lock);
 		spin_unlock_irqrestore(&k_lock, flags2);
 	}
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 05ce2a2..c44e7aa 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -143,6 +143,7 @@ static void dump_eth_packet(struct net_device *dev, const char *title,
 		port = ntohs(uh->dest);
 	} else if (protocol == ETH_P_IPV6) {
 		struct ipv6hdr *i6h = (struct ipv6hdr *) data;
+
 		uh = (struct udphdr *) ((char *)i6h + sizeof(struct ipv6hdr));
 		ip_protocol = i6h->nexthdr;
 		port = ntohs(uh->dest);
@@ -199,6 +200,7 @@ static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
 	u8 *buf = (u8 *) msg;
 	u16 hci_cmd =  (buf[0]<<8) | buf[1];
 	u16 hci_len = (buf[2]<<8) | buf[3];
+
 	netdev_dbg(dev, "H=>D: 0x%04x(%d)\n", hci_cmd, hci_len);
 
 	gdm_wimax_send(nic, msg, len);
@@ -310,6 +312,7 @@ static int gdm_wimax_event_send(struct net_device *dev, char *buf, int size)
 
 	u16 hci_cmd =  ((u8)buf[0]<<8) | (u8)buf[1];
 	u16 hci_len = ((u8)buf[2]<<8) | (u8)buf[3];
+
 	netdev_dbg(dev, "D=>H: 0x%04x(%d)\n", hci_cmd, hci_len);
 
 	spin_lock_irqsave(&wm_event.evt_lock, flags);
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index 0d45eb6..4d7c61c 100644
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
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaCPTRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:17:36 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42719 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaCPTRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:17:34 -0400
Date: Mon, 17 Mar 2014 08:17:28 +1300
From: Daniel Ngu <daniel.dy.ngu@gmail.com>
To: Jonathan Kim <jonathankim@gctsemi.com>
Cc: Dean ahn <deanahn@gctsemi.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_mux.c: fixed coding style
Message-ID: <20140316191728.GC3478@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line over 80 characters

Signed-off-by: Daniel Ngu <daniel.dy.ngu@gmail.com>
---
 drivers/staging/gdm724x/gdm_mux.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
index 2fa3a5a..10ce2c1 100644
--- a/drivers/staging/gdm724x/gdm_mux.c
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -165,7 +165,8 @@ static int up_to_host(struct mux_rx *r)
 	int len = r->len;
 
 	while (1) {
-		mux_header = (struct mux_pkt_header *)(r->buf + packet_size_sum);
+		mux_header = (struct mux_pkt_header *)(r->buf +
+						       packet_size_sum);
 		start_flag = __le32_to_cpu(mux_header->start_flag);
 		payload_size = __le32_to_cpu(mux_header->payload_size);
 		packet_type = __le16_to_cpu(mux_header->packet_type);
@@ -231,7 +232,8 @@ static void do_rx(struct work_struct *work)
 			spin_unlock_irqrestore(&rx->to_host_lock, flags);
 			break;
 		}
-		r = list_entry(rx->to_host_list.next, struct mux_rx, to_host_list);
+		r = list_entry(rx->to_host_list.next, struct mux_rx,
+			       to_host_list);
 		list_del(&r->to_host_list);
 		spin_unlock_irqrestore(&rx->to_host_lock, flags);
 
@@ -249,7 +251,8 @@ static void remove_rx_submit_list(struct mux_rx *r, struct rx_cxt *rx)
 	struct mux_rx	*r_remove, *r_remove_next;
 
 	spin_lock_irqsave(&rx->submit_list_lock, flags);
-	list_for_each_entry_safe(r_remove, r_remove_next, &rx->rx_submit_list, rx_submit_list) {
+	list_for_each_entry_safe(r_remove, r_remove_next, &rx->rx_submit_list,
+				 rx_submit_list) {
 		if (r == r_remove)
 			list_del(&r->rx_submit_list);
 	}
@@ -279,9 +282,8 @@ static void gdm_mux_rcv_complete(struct urb *urb)
 	}
 }
 
-static int gdm_mux_recv(void *priv_dev,
-			int (*cb)(void *data, int len, int tty_index, struct tty_dev *tty_dev, int complete)
-			)
+static int gdm_mux_recv(void *priv_dev, int (*cb)(void *data, int len,
+			int tty_index, struct tty_dev *tty_dev, int complete))
 {
 	struct mux_dev *mux_dev = priv_dev;
 	struct usb_device *usbdev = mux_dev->usbdev;
@@ -416,7 +418,8 @@ static int gdm_mux_send(void *priv_dev, void *data, int len, int tty_index,
 	return ret;
 }
 
-static int gdm_mux_send_control(void *priv_dev, int request, int value, void *buf, int len)
+static int gdm_mux_send_control(void *priv_dev, int request, int value,
+				void *buf, int len)
 {
 	struct mux_dev *mux_dev = priv_dev;
 	struct usb_device *usbdev = mux_dev->usbdev;
@@ -448,7 +451,8 @@ static void release_usb(struct mux_dev *mux_dev)
 	cancel_delayed_work(&mux_dev->work_rx);
 
 	spin_lock_irqsave(&rx->submit_list_lock, flags);
-	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list) {
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list,
+				 rx_submit_list) {
 		spin_unlock_irqrestore(&rx->submit_list_lock, flags);
 		usb_kill_urb(r->urb);
 		spin_lock_irqsave(&rx->submit_list_lock, flags);
@@ -503,7 +507,8 @@ static int init_usb(struct mux_dev *mux_dev)
 	return ret;
 }
 
-static int gdm_mux_probe(struct usb_interface *intf, const struct usb_device_id *id)
+static int gdm_mux_probe(struct usb_interface *intf,
+			 const struct usb_device_id *id)
 {
 	struct mux_dev *mux_dev;
 	struct tty_dev *tty_dev;
@@ -610,7 +615,8 @@ static int gdm_mux_suspend(struct usb_interface *intf, pm_message_t pm_msg)
 
 
 	spin_lock_irqsave(&rx->submit_list_lock, flags);
-	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list) {
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list,
+				 rx_submit_list) {
 		spin_unlock_irqrestore(&rx->submit_list_lock, flags);
 		usb_kill_urb(r->urb);
 		spin_lock_irqsave(&rx->submit_list_lock, flags);
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaCPTPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:15:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39039 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbaCPTPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:15:42 -0400
Date: Mon, 17 Mar 2014 08:15:36 +1300
From: Daniel Ngu <daniel.dy.ngu@gmail.com>
To: Jonathan Kim <jonathankim@gctsemi.com>
Cc: Dean ahn <deanahn@gctsemi.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: gdm_usb.c: fixed coding style
Message-ID: <20140316191536.GB3478@quad>
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
 drivers/staging/gdm724x/gdm_usb.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index 03b4305..3d6774b 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -30,14 +30,17 @@
 #include "gdm_endian.h"
 
 #define USB_DEVICE_CDC_DATA(vid, pid) \
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_CLASS | USB_DEVICE_ID_MATCH_INT_SUBCLASS,\
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
+		       USB_DEVICE_ID_MATCH_INT_CLASS | \
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,\
 	.idVendor = vid,\
 	.idProduct = pid,\
 	.bInterfaceClass = USB_CLASS_COMM,\
 	.bInterfaceSubClass = USB_CDC_SUBCLASS_ETHERNET
 
 #define USB_DEVICE_MASS_DATA(vid, pid) \
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,\
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
+		       USB_DEVICE_ID_MATCH_INT_INFO,\
 	.idVendor = vid,\
 	.idProduct = pid,\
 	.bInterfaceSubClass = USB_SC_SCSI, \
@@ -59,7 +62,8 @@ static void do_tx(struct work_struct *work);
 static void do_rx(struct work_struct *work);
 
 static int gdm_usb_recv(void *priv_dev,
-			int (*cb)(void *cb_data, void *data, int len, int context),
+			int (*cb)(void *cb_data, void *data, int len,
+				  int context),
 			void *cb_data,
 			int context);
 
@@ -375,7 +379,8 @@ static int set_mac_address(u8 *data, void *arg)
 	if (tlv->type == MAC_ADDRESS && udev->request_mac_addr) {
 		memcpy(mac_address, tlv->data, tlv->len);
 
-		if (register_lte_device(phy_dev, &udev->intf->dev, mac_address) < 0)
+		if (register_lte_device(phy_dev, &udev->intf->dev,
+					mac_address) < 0)
 			pr_err("register lte device failed\n");
 
 		udev->request_mac_addr = 0;
@@ -388,7 +393,8 @@ static int set_mac_address(u8 *data, void *arg)
 
 static void do_rx(struct work_struct *work)
 {
-	struct lte_udev *udev = container_of(work, struct lte_udev, work_rx.work);
+	struct lte_udev *udev = container_of(work, struct lte_udev,
+					     work_rx.work);
 	struct rx_cxt *rx = &udev->rx;
 	struct usb_rx *r;
 	struct hci_packet *hci;
@@ -403,7 +409,8 @@ static void do_rx(struct work_struct *work)
 			spin_unlock_irqrestore(&rx->to_host_lock, flags);
 			break;
 		}
-		r = list_entry(rx->to_host_list.next, struct usb_rx, to_host_list);
+		r = list_entry(rx->to_host_list.next, struct usb_rx,
+				to_host_list);
 		list_del(&r->to_host_list);
 		spin_unlock_irqrestore(&rx->to_host_lock, flags);
 
@@ -450,7 +457,8 @@ static void remove_rx_submit_list(struct usb_rx *r, struct rx_cxt *rx)
 	struct usb_rx	*r_remove, *r_remove_next;
 
 	spin_lock_irqsave(&rx->submit_lock, flags);
-	list_for_each_entry_safe(r_remove, r_remove_next, &rx->rx_submit_list, rx_submit_list)
+	list_for_each_entry_safe(r_remove, r_remove_next, &rx->rx_submit_list,
+				 rx_submit_list)
 	{
 		if (r == r_remove) {
 			list_del(&r->rx_submit_list);
@@ -487,7 +495,8 @@ static void gdm_usb_rcv_complete(struct urb *urb)
 }
 
 static int gdm_usb_recv(void *priv_dev,
-			int (*cb)(void *cb_data, void *data, int len, int context),
+			int (*cb)(void *cb_data, void *data, int len,
+				  int context),
 			void *cb_data,
 			int context)
 {
@@ -641,7 +650,8 @@ static u32 packet_aggregation(struct lte_udev *udev, u8 *send_buf)
 
 static void do_tx(struct work_struct *work)
 {
-	struct lte_udev *udev = container_of(work, struct lte_udev, work_tx.work);
+	struct lte_udev *udev = container_of(work, struct lte_udev,
+					     work_tx.work);
 	struct usb_device *usbdev = udev->usbdev;
 	struct tx_cxt *tx = &udev->tx;
 	struct usb_tx *t = NULL;
@@ -800,7 +810,8 @@ static struct gdm_endian *gdm_usb_get_endian(void *priv_dev)
 	return &udev->gdm_ed;
 }
 
-static int gdm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
+static int gdm_usb_probe(struct usb_interface *intf,
+			 const struct usb_device_id *id)
 {
 	int ret = 0;
 	struct phy_dev *phy_dev = NULL;
@@ -848,7 +859,8 @@ static int gdm_usb_probe(struct usb_interface *intf, const struct usb_device_id
 	usb_enable_autosuspend(usbdev);
 	pm_runtime_set_autosuspend_delay(&usbdev->dev, AUTO_SUSPEND_TIMER);
 
-	/* List up hosts with big endians, otherwise, defaults to little endian */
+	/* List up hosts with big endians, otherwise, defaults to little
+	 * endian */
 	if (idProduct == PID_GDM7243)
 		gdm_set_endian(&udev->gdm_ed, ENDIANNESS_BIG);
 	else
-- 
1.7.9.5


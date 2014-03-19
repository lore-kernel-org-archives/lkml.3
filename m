Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbaCSWOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:14:52 -0400
Received: from ced.ryick.net ([82.229.97.62]:40201 "EHLO ced.ryick.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbaCSWOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:14:50 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 18:14:50 EDT
From: =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
Subject: [PATCH 2/2] coding style: fix line over 80 characters
Date: Wed, 19 Mar 2014 23:04:57 +0100
Message-Id: <1395266697-8699-3-git-send-email-ced@ryick.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395266697-8699-1-git-send-email-ced@ryick.net>
References: <1395266697-8699-1-git-send-email-ced@ryick.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cédric Cabessa <ced@ryick.net>
---
 drivers/staging/usbip/vhci_hcd.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index f690668..1e84577 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -271,12 +271,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			}
 			break;
 		case USB_PORT_FEAT_POWER:
-			usbip_dbg_vhci_rh(" ClearPortFeature: USB_PORT_FEAT_POWER\n");
+			usbip_dbg_vhci_rh(
+				" ClearPortFeature: USB_PORT_FEAT_POWER\n");
 			dum->port_status[rhport] = 0;
 			dum->resuming = 0;
 			break;
 		case USB_PORT_FEAT_C_RESET:
-			usbip_dbg_vhci_rh(" ClearPortFeature: USB_PORT_FEAT_C_RESET\n");
+			usbip_dbg_vhci_rh(
+				" ClearPortFeature: USB_PORT_FEAT_C_RESET\n");
 			switch (dum->vdev[rhport].speed) {
 			case USB_SPEED_HIGH:
 				dum->port_status[rhport] |=
@@ -335,15 +337,17 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 			if (dum->vdev[rhport].ud.status ==
 			    VDEV_ST_NOTASSIGNED) {
-				usbip_dbg_vhci_rh(" enable rhport %d (status %u)\n",
-						  rhport,
-						  dum->vdev[rhport].ud.status);
+				usbip_dbg_vhci_rh(
+					" enable rhport %d (status %u)\n",
+					rhport,
+					dum->vdev[rhport].ud.status);
 				dum->port_status[rhport] |=
 					USB_PORT_STAT_ENABLE;
 			}
 		}
 		((__le16 *) buf)[0] = cpu_to_le16(dum->port_status[rhport]);
-		((__le16 *) buf)[1] = cpu_to_le16(dum->port_status[rhport] >> 16);
+		((__le16 *) buf)[1] =
+			cpu_to_le16(dum->port_status[rhport] >> 16);
 
 		usbip_dbg_vhci_rh(" GetPortStatus bye %x %x\n", ((u16 *)buf)[0],
 				  ((u16 *)buf)[1]);
@@ -355,10 +359,12 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	case SetPortFeature:
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
-			usbip_dbg_vhci_rh(" SetPortFeature: USB_PORT_FEAT_SUSPEND\n");
+			usbip_dbg_vhci_rh(
+				" SetPortFeature: USB_PORT_FEAT_SUSPEND\n");
 			break;
 		case USB_PORT_FEAT_RESET:
-			usbip_dbg_vhci_rh(" SetPortFeature: USB_PORT_FEAT_RESET\n");
+			usbip_dbg_vhci_rh(
+				" SetPortFeature: USB_PORT_FEAT_RESET\n");
 			/* if it's already running, disconnect first */
 			if (dum->port_status[rhport] & USB_PORT_STAT_ENABLE) {
 				dum->port_status[rhport] &=
@@ -530,7 +536,8 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 
 		case USB_REQ_GET_DESCRIPTOR:
 			if (ctrlreq->wValue == cpu_to_le16(USB_DT_DEVICE << 8))
-				usbip_dbg_vhci_hc("Not yet?:Get_Descriptor to device 0 (get max pipe size)\n");
+				usbip_dbg_vhci_hc(
+					"Not yet?:Get_Descriptor to device 0 (get max pipe size)\n");
 
 			if (vdev->udev)
 				usb_put_dev(vdev->udev);
@@ -539,7 +546,9 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 
 		default:
 			/* NOT REACHED */
-			dev_err(dev, "invalid request to devnum 0 bRequest %u, wValue %u\n", ctrlreq->bRequest,
+			dev_err(dev,
+				"invalid request to devnum 0 bRequest %u, wValue %u\n",
+				ctrlreq->bRequest,
 				ctrlreq->wValue);
 			ret =  -EINVAL;
 			goto no_need_xmit;
@@ -1060,7 +1069,9 @@ static int vhci_hcd_suspend(struct platform_device *pdev, pm_message_t state)
 	spin_unlock(&the_controller->lock);
 
 	if (connected > 0) {
-		dev_info(&pdev->dev, "We have %d active connection%s. Do not suspend.\n", connected, (connected == 1 ? "" : "s"));
+		dev_info(&pdev->dev,
+			 "We have %d active connection%s. Do not suspend.\n",
+			 connected, (connected == 1 ? "" : "s"));
 		ret =  -EBUSY;
 	} else {
 		dev_info(&pdev->dev, "suspend vhci_hcd");
-- 
1.8.3.1


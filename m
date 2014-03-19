Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbaCSWOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:14:55 -0400
Received: from ced.ryick.net ([82.229.97.62]:40202 "EHLO ced.ryick.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757418AbaCSWOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:14:51 -0400
From: =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Cabessa?= <ced@ryick.net>
Subject: [PATCH 1/2] coding style: fix quoted string split across lines
Date: Wed, 19 Mar 2014 23:04:56 +0100
Message-Id: <1395266697-8699-2-git-send-email-ced@ryick.net>
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
 drivers/staging/usbip/stub_tx.c      | 16 ++++++++--------
 drivers/staging/usbip/usbip_common.c | 10 ++++------
 drivers/staging/usbip/vhci_sysfs.c   |  4 ++--
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index cd5326a..1622563 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -74,12 +74,12 @@ void stub_complete(struct urb *urb)
 		/* OK */
 		break;
 	case -ENOENT:
-		dev_info(&urb->dev->dev, "stopped by a call to usb_kill_urb() "
-			 "because of cleaning up a virtual connection\n");
+		dev_info(&urb->dev->dev,
+			 "stopped by a call to usb_kill_urb() because of cleaning up a virtual connection\n");
 		return;
 	case -ECONNRESET:
-		dev_info(&urb->dev->dev, "unlinked by a call to "
-			 "usb_unlink_urb()\n");
+		dev_info(&urb->dev->dev,
+			 "unlinked by a call to usb_unlink_urb()\n");
 		break;
 	case -EPIPE:
 		dev_info(&urb->dev->dev, "endpoint %d is stalled\n",
@@ -89,8 +89,9 @@ void stub_complete(struct urb *urb)
 		dev_info(&urb->dev->dev, "device removed?\n");
 		break;
 	default:
-		dev_info(&urb->dev->dev, "urb completion with non-zero status "
-			 "%d\n", urb->status);
+		dev_info(&urb->dev->dev,
+			 "urb completion with non-zero status %d\n",
+			 urb->status);
 		break;
 	}
 
@@ -228,8 +229,7 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 
 			if (txsize != sizeof(pdu_header) + urb->actual_length) {
 				dev_err(&sdev->interface->dev,
-					"actual length of urb %d does not "
-					"match iso packet sizes %zu\n",
+					"actual length of urb %d does not match iso packet sizes %zu\n",
 					urb->actual_length,
 					txsize-sizeof(pdu_header));
 				kfree(iov);
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 2a11233..184fa70 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -178,8 +178,8 @@ static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
 	}
 
 	pr_debug("       ");
-	pr_debug("bRequestType(%02X) bRequest(%02X) wValue(%04X) wIndex(%04X) "
-		 "wLength(%04X) ", cmd->bRequestType, cmd->bRequest,
+	pr_debug("bRequestType(%02X) bRequest(%02X) wValue(%04X) wIndex(%04X) wLength(%04X) ",
+		 cmd->bRequestType, cmd->bRequest,
 		 cmd->wValue, cmd->wIndex, cmd->wLength);
 	pr_debug("\n       ");
 
@@ -290,8 +290,7 @@ void usbip_dump_header(struct usbip_header *pdu)
 
 	switch (pdu->base.command) {
 	case USBIP_CMD_SUBMIT:
-		pr_debug("USBIP_CMD_SUBMIT: "
-			 "x_flags %u x_len %u sf %u #p %d iv %d\n",
+		pr_debug("USBIP_CMD_SUBMIT: x_flags %u x_len %u sf %u #p %d iv %d\n",
 			 pdu->u.cmd_submit.transfer_flags,
 			 pdu->u.cmd_submit.transfer_buffer_length,
 			 pdu->u.cmd_submit.start_frame,
@@ -688,8 +687,7 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 
 	if (total_length != urb->actual_length) {
 		dev_err(&urb->dev->dev,
-			"total length of iso packets %d not equal to actual "
-			"length of buffer %d\n",
+			"total length of iso packets %d not equal to actual length of buffer %d\n",
 			total_length, urb->actual_length);
 
 		if (ud->side == USBIP_STUB)
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 82dd49f..e098032 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -47,8 +47,8 @@ static ssize_t status_show(struct device *dev, struct device_attribute *attr,
 	 * up /proc/net/{tcp,tcp6}. Also, a userland program may remember a
 	 * port number and its peer IP address.
 	 */
-	out += sprintf(out, "prt sta spd bus dev socket           "
-		       "local_busid\n");
+	out += sprintf(out,
+		       "prt sta spd bus dev socket           local_busid\n");
 
 	for (i = 0; i < VHCI_NPORTS; i++) {
 		struct vhci_device *vdev = port_to_vdev(i);
-- 
1.8.3.1


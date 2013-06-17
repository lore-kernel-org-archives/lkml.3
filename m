Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3FQRgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:36:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50726 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3FQRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 23/84] USB: zte_ev: fix control-message timeouts
Date: Mon, 17 Jun 2013 10:30:27 -0700
Message-Id: <1371490288-23167-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5cbfa3acdcbf19e1d29cf3479ad8200d2e644e44 upstream.

The control-message timeout is specified in milliseconds and should not
depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/zte_ev.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/serial/zte_ev.c b/drivers/usb/serial/zte_ev.c
index 39ee737..b9a88f2 100644
--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -53,7 +53,7 @@ static int zte_ev_usb_serial_open(struct tty_struct *tty,
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x22, 0x21,
 				 0x0001, 0x0000, NULL, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	dev_dbg(dev, "result = %d\n", result);
 
 	/* send  2st cmd and recieve data */
@@ -65,7 +65,7 @@ static int zte_ev_usb_serial_open(struct tty_struct *tty,
 	result = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 0x21, 0xa1,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 
 	/* send 3 cmd */
@@ -84,7 +84,7 @@ static int zte_ev_usb_serial_open(struct tty_struct *tty,
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x20, 0x21,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 
 	/* send 4 cmd */
@@ -95,7 +95,7 @@ static int zte_ev_usb_serial_open(struct tty_struct *tty,
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x22, 0x21,
 				 0x0003, 0x0000, NULL, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	dev_dbg(dev, "result = %d\n", result);
 
 	/* send 5 cmd */
@@ -107,7 +107,7 @@ static int zte_ev_usb_serial_open(struct tty_struct *tty,
 	result = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 0x21, 0xa1,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 
 	/* send 6 cmd */
@@ -126,7 +126,7 @@ static int zte_ev_usb_serial_open(struct tty_struct *tty,
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x20, 0x21,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 	kfree(buf);
 
@@ -178,7 +178,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x22, 0x21,
 				 0x0002, 0x0000, NULL, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	dev_dbg(dev, "result = %d\n", result);
 
 	/* send 2st ctl cmd(CTL    21 22 03 00  00 00 00 00 ) */
@@ -186,7 +186,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x22, 0x21,
 				 0x0003, 0x0000, NULL, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	dev_dbg(dev, "result = %d\n", result);
 
 	/* send  3st cmd and recieve data */
@@ -198,7 +198,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 0x21, 0xa1,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 
 	/* send 4 cmd */
@@ -217,7 +217,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x20, 0x21,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 
 	/* send 5 cmd */
@@ -228,7 +228,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x22, 0x21,
 				 0x0003, 0x0000, NULL, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	dev_dbg(dev, "result = %d\n", result);
 
 	/* send 6 cmd */
@@ -240,7 +240,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 0x21, 0xa1,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 
 	/* send 7 cmd */
@@ -259,7 +259,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x20, 0x21,
 				 0x0000, 0x0000, buf, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	debug_data(dev, __func__, len, buf, result);
 
 	/* send 8 cmd */
@@ -270,7 +270,7 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 0x22, 0x21,
 				 0x0003, 0x0000, NULL, len,
-				 HZ * USB_CTRL_GET_TIMEOUT);
+				 USB_CTRL_GET_TIMEOUT);
 	dev_dbg(dev, "result = %d\n", result);
 
 	kfree(buf);
-- 
1.8.1.2


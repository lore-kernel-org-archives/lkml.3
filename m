Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3JNTrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:47:53 -0400
Received: from libra.uberspace.de ([95.143.172.171]:59387 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757302Ab3JNTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:47:00 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH v2 4/5] drivers: usb: core: devio.c: Reindented switch-block
Date: Mon, 14 Oct 2013 21:46:39 +0200
Message-Id: <1381780000-23327-5-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
References: <20131014181214.GB6023@kroah.com>
 <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reindented the switch-block.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 56 ++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index dd8701b..9761a27 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1843,39 +1843,39 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 	} else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
 		retval = -EINVAL;
 	} else {
-	switch (ctl->ioctl_code) {
-
-	/* disconnect kernel driver from interface */
-	case USBDEVFS_DISCONNECT:
-		if (intf->dev.driver) {
-			driver = to_usb_driver(intf->dev.driver);
-			dev_dbg(&intf->dev, "disconnect by usbfs\n");
-			usb_driver_release_interface(driver, intf);
-		} else
-			retval = -ENODATA;
-		break;
+		switch (ctl->ioctl_code) {
+
+		/* disconnect kernel driver from interface */
+		case USBDEVFS_DISCONNECT:
+			if (intf->dev.driver) {
+				driver = to_usb_driver(intf->dev.driver);
+				dev_dbg(&intf->dev, "disconnect by usbfs\n");
+				usb_driver_release_interface(driver, intf);
+			} else
+				retval = -ENODATA;
+			break;
 
-	/* let kernel drivers try to (re)bind to the interface */
-	case USBDEVFS_CONNECT:
-		if (!intf->dev.driver)
-			retval = device_attach(&intf->dev);
-		else
-			retval = -EBUSY;
-		break;
+		/* let kernel drivers try to (re)bind to the interface */
+		case USBDEVFS_CONNECT:
+			if (!intf->dev.driver)
+				retval = device_attach(&intf->dev);
+			else
+				retval = -EBUSY;
+			break;
 
-	/* talk directly to the interface's driver */
-	default:
-		if (intf->dev.driver)
-			driver = to_usb_driver(intf->dev.driver);
-		if (driver == NULL || driver->unlocked_ioctl == NULL) {
-			retval = -ENOTTY;
-		} else {
-			retval = driver->unlocked_ioctl(intf, ctl->ioctl_code, buf);
-			if (retval == -ENOIOCTLCMD)
+		/* talk directly to the interface's driver */
+		default:
+			if (intf->dev.driver)
+				driver = to_usb_driver(intf->dev.driver);
+			if (driver == NULL || driver->unlocked_ioctl == NULL) {
 				retval = -ENOTTY;
+			} else {
+				retval = driver->unlocked_ioctl(intf, ctl->ioctl_code, buf);
+				if (retval == -ENOIOCTLCMD)
+					retval = -ENOTTY;
+			}
 		}
 	}
-	}
 
 	/* cleanup and return */
 	if (retval >= 0
-- 
1.8.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3JJVlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:41:52 -0400
Received: from libra.uberspace.de ([95.143.172.171]:60109 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757457Ab3JJVlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:41:50 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 5/6] drivers: usb: core: devio.c: Braces around switch
Date: Thu, 10 Oct 2013 23:41:31 +0200
Message-Id: <1381441292-6145-6-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added braces around switch statement as the styleguide tells us.
Indented the switch-block for it and split a function call
(driver->unlocked_ioctl() on line 1876) arguments to several lines to
fit the 80-column convention.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 60 ++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 8aca6b93..215d882 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1843,36 +1843,42 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 	}
 	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
 		retval = -EINVAL;
-	else switch (ctl->ioctl_code) {
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
+	}
+	else {
+		switch (ctl->ioctl_code) {
+
+		/* disconnect kernel driver from interface */
+		case USBDEVFS_DISCONNECT:
+			if (intf->dev.driver) {
+				driver = to_usb_driver(intf->dev.driver);
+				dev_dbg(&intf->dev, "disconnect by usbfs\n");
+				usb_driver_release_interface(driver, intf);
+			} else {
+				retval = -ENODATA;
+			}
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
+				retval = driver->unlocked_ioctl(intf,
+								ctl->ioctl_code,
+								buf);
+				if (retval == -ENOIOCTLCMD)
+					retval = -ENOTTY;
+			}
 		}
 	}
 
-- 
1.8.4


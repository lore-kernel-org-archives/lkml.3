Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaAXQZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:25:13 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:39070
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbaAXQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:25:10 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ke42caxa@cip.cs.fau.de, josh@joshtriplett.org,
        himangi774@gmail.com, viro@zeniv.linux.org.uk
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] staging/usbip: simplify usbip_dump_usb_device() udev->speed handling
Date: Fri, 24 Jan 2014 09:25:05 -0700
Message-Id: <1390580705-2012-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change usbip_dump_usb_device() to use usb_speed_string() and remove the
code that does switch on udev->speed and builds custom speed strings.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/usbip_common.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 4470cd3..ad5f0c8 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -99,26 +99,8 @@ static void usbip_dump_usb_device(struct usb_device *udev)
 	struct device *dev = &udev->dev;
 	int i;
 
-	dev_dbg(dev, "       devnum(%d) devpath(%s) ",
-		udev->devnum, udev->devpath);
-
-	switch (udev->speed) {
-	case USB_SPEED_HIGH:
-		pr_debug("SPD_HIGH ");
-		break;
-	case USB_SPEED_FULL:
-		pr_debug("SPD_FULL ");
-		break;
-	case USB_SPEED_LOW:
-		pr_debug("SPD_LOW ");
-		break;
-	case USB_SPEED_UNKNOWN:
-		pr_debug("SPD_UNKNOWN ");
-		break;
-	default:
-		pr_debug("SPD_ERROR ");
-		break;
-	}
+	dev_dbg(dev, "       devnum(%d) devpath(%s) usb speed(%s)",
+		udev->devnum, udev->devpath, usb_speed_string(udev->speed));
 
 	pr_debug("tt %p, ttport %d\n", udev->tt, udev->ttport);
 
-- 
1.8.3.2


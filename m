Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaHGFLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:11:02 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44343 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaHGFK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:10:57 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 3/3] usbip: remove struct usb_device_id table
Date: Thu,  7 Aug 2014 08:10:29 +0300
Message-Id: <1407388229-31807-5-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
References: <1407388229-31807-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was used back when usbip-host was an interface device driver;
after the conversion to device driver, the table remained unused.
Remove it in order to stop receiving a warning about it.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/usb/usbip/stub_dev.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 51d0c71..fac20e0 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -26,33 +26,6 @@
 #include "stub.h"
 
 /*
- * Define device IDs here if you want to explicitly limit exportable devices.
- * In most cases, wildcard matching will be okay because driver binding can be
- * changed dynamically by a userland program.
- */
-static struct usb_device_id stub_table[] = {
-#if 0
-	/* just an example */
-	{ USB_DEVICE(0x05ac, 0x0301) },   /* Mac 1 button mouse */
-	{ USB_DEVICE(0x0430, 0x0009) },   /* Plat Home Keyboard */
-	{ USB_DEVICE(0x059b, 0x0001) },   /* Iomega USB Zip 100 */
-	{ USB_DEVICE(0x04b3, 0x4427) },   /* IBM USB CD-ROM */
-	{ USB_DEVICE(0x05a9, 0xa511) },   /* LifeView USB cam */
-	{ USB_DEVICE(0x55aa, 0x0201) },   /* Imation card reader */
-	{ USB_DEVICE(0x046d, 0x0870) },   /* Qcam Express(QV-30) */
-	{ USB_DEVICE(0x04bb, 0x0101) },   /* IO-DATA HD 120GB */
-	{ USB_DEVICE(0x04bb, 0x0904) },   /* IO-DATA USB-ET/TX */
-	{ USB_DEVICE(0x04bb, 0x0201) },   /* IO-DATA USB-ET/TX */
-	{ USB_DEVICE(0x08bb, 0x2702) },   /* ONKYO USB Speaker */
-	{ USB_DEVICE(0x046d, 0x08b2) },   /* Logicool Qcam 4000 Pro */
-#endif
-	/* magic for wild card */
-	{ .driver_info = 1 },
-	{ 0, }                                     /* Terminating entry */
-};
-MODULE_DEVICE_TABLE(usb, stub_table);
-
-/*
  * usbip_status shows the status of usbip-host as long as this driver is bound
  * to the target device.
  */
-- 
1.8.1.2


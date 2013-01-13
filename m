Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3AMVdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 16:33:00 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35048 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3AMVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 16:32:58 -0500
Message-ID: <50F33615.2080502@qdot.me>
Date: Sun, 13 Jan 2013 23:32:53 +0100
From: Tomasz Mloduchowski <q@qdot.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121113 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: Crucible Technologies COMET Caller ID - pid added -
 v2
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Mloduchowski <q@qdot.me>

Simple fix to add support for Crucible Technologies COMET Caller ID
USB decoder - a device containing FTDI USB/Serial converter chip,
handling 1200bps CallerID messages decoded from the phone line -
adding correct USB PID is sufficient.

Tested to apply cleanly and work flawlessly against 3.6.9, 3.7.0-rc8
and 3.8.0-rc3 on both amd64 and x86 arches.

Signed-off-by: Tomasz Mloduchowski <q@qdot.me>
---
diff -ur linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c
--- linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c	2013-01-13 19:41:28.000000000 +0100
+++ linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c	2013-01-13 19:49:27.239874311 +0100
@@ -875,6 +875,8 @@
 	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
+	/* Crucible Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff -ur linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio_ids.h linux-3.8-rc3/drivers/usb/serial/ftdi_sio_ids.h
--- linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio_ids.h	2013-01-13 19:41:28.000000000 +0100
+++ linux-3.8-rc3/drivers/usb/serial/ftdi_sio_ids.h	2013-01-13 23:28:44.964087761 +0100
@@ -1259,3 +1259,9 @@
  * ATI command output: Cinterion MC55i
  */
 #define FTDI_CINTERION_MC55I_PID	0xA951
+
+/*
+ * Product: Comet Caller ID decoder
+ * Manufacturer: Crucible Technologies
+ */
+#define FTDI_CT_COMET_PID	0x8e08

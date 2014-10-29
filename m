Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaJ2VWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:22:25 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:50649 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbaJ2VWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:22:23 -0400
From: Anton Staaf <robotboy@chromium.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Staaf <robotboy@chromium.org>
Subject: [PATCH] USB: simple: add Google simple serial SubClass support
Date: Wed, 29 Oct 2014 14:21:56 -0700
Message-Id: <1414617716-39377-1-git-send-email-robotboy@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Google devices that export simple serial
interfaces using the vendor specific SubClass/Protocol pair
0x50/0x01.

Signed-off-by: Anton Staaf <robotboy@chromium.org>

---
 drivers/usb/serial/usb-serial-simple.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
index fb79775..85bb973 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -8,6 +8,7 @@
  * Copyright (C) 2010 Zilogic Systems <code@zilogic.com>
  * Copyright (C) 2013 Wei Shuai <cpuwolf@gmail.com>
  * Copyright (C) 2013 Linux Foundation
+ * Copyright (C) 2014 Google, Inc.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License version
@@ -80,6 +81,14 @@ DEVICE(suunto, SUUNTO_IDS);
 	{ USB_DEVICE(0x908, 0x0004) }
 DEVICE(siemens_mpi, SIEMENS_IDS);
 
+/* Google Serial USB SubClass */
+#define GOOGLE_IDS()					       \
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x18d1,		       \
+					USB_CLASS_VENDOR_SPEC, \
+					0x50,		       \
+					0x01) }
+DEVICE(google, GOOGLE_IDS);
+
 /* All of the above structures mushed into two lists */
 static struct usb_serial_driver * const serial_drivers[] = {
 	&zio_device,
@@ -90,6 +99,7 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&hp4x_device,
 	&suunto_device,
 	&siemens_mpi_device,
+	&google_device,
 	NULL
 };
 
@@ -102,6 +112,7 @@ static const struct usb_device_id id_table[] = {
 	HP4X_IDS(),
 	SUUNTO_IDS(),
 	SIEMENS_IDS(),
+	GOOGLE_IDS(),
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
-- 
2.1.0.rc2.206.gedb03e5


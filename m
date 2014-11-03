Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaKCQng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:43:36 -0500
Received: from mail-ie0-f202.google.com ([209.85.223.202]:64185 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaKCQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:43:34 -0500
From: Anton Staaf <robotboy@chromium.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Staaf <robotboy@chromium.org>
Subject: [PATCH] USB: simple: add Google simple serial SubClass support
Date: Mon,  3 Nov 2014 08:43:20 -0800
Message-Id: <1415033000-28530-1-git-send-email-robotboy@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414616030-37346-1-git-send-email-robotboy@chromium.org>
References: <1414616030-37346-1-git-send-email-robotboy@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Google devices that export simple serial
interfaces using the vendor specific SubClass/Protocol pair
0x50/0x01.

Signed-off-by: Anton Staaf <robotboy@chromium.org>
---
 drivers/usb/serial/usb-serial-simple.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
index 8bfc47c..a3572b7 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -91,6 +91,14 @@ DEVICE(suunto, SUUNTO_IDS);
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
 	&carelink_device,
@@ -103,6 +111,7 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&hp4x_device,
 	&suunto_device,
 	&siemens_mpi_device,
+	&google_device,
 	NULL
 };
 
@@ -117,6 +126,7 @@ static const struct usb_device_id id_table[] = {
 	HP4X_IDS(),
 	SUUNTO_IDS(),
 	SIEMENS_IDS(),
+	GOOGLE_IDS(),
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
-- 
2.1.0.rc2.206.gedb03e5


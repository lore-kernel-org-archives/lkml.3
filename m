Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaBBNnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 08:43:07 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:45238 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBBNnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 08:43:06 -0500
Date: Sun, 02 Feb 2014 14:42:52 +0100
From: Ulrich Hahn <uhahn@eanco.de>
Subject: [PATCH v4] USB: ftdi_sio: add Tagsys RFID Reader IDs
To: Johan Hovold <johan@hovold.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.4.11
Message-Id: <1391348572.32311.0@biblenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding two more IDs to the ftdi_sio usb serial driver.
It now connects Tagsys RFID readers.
There might be more IDs out there for other Tagsys models.

Signed-off-by: Ulrich Hahn <uhahn@eanco.de>

diff -urpN linux-3.13.1/drivers/usb/serial/ftdi_sio.c linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio.c
--- linux-3.13.1/drivers/usb/serial/ftdi_sio.c	2014-01-29 14:06:37.000000000 +0100
+++ linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio.c	2014-02-02 11:57:08.625914749 +0100
@@ -192,6 +192,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
diff -urpN linux-3.13.1/drivers/usb/serial/ftdi_sio_ids.h linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio_ids.h
--- linux-3.13.1/drivers/usb/serial/ftdi_sio_ids.h	2014-01-29 14:06:37.000000000 +0100
+++ linux-3.13.1+tagsys/drivers/usb/serial/ftdi_sio_ids.h	2014-02-02 14:32:41.153358910 +0100
@@ -363,6 +363,12 @@
 /* Sprog II (Andrew Crosland's SprogII DCC interface) */
 #define FTDI_SPROG_II		0xF0C8
 
+/*
+ * Two of the Tagsys RFID Readers
+ */
+#define FTDI_TAGSYS_LP101_PID	0xF0E9	/* Tagsys L-P101 RFID*/
+#define FTDI_TAGSYS_P200X_PID	0xF0EE	/* Tagsys Medio P200x RFID*/
+
 /* an infrared receiver for user access control with IR tags */
 #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
 

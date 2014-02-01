Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbaBAQnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 11:43:17 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33143 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaBAQnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 11:43:15 -0500
MIME-Version: 1.0
From: Ulrich Hahn <uhahn@eanco.de>
Date: Sat, 1 Feb 2014 17:42:55 +0100
X-Google-Sender-Auth: MZqqWzmqHYpIwTxF4Jefd8g2DzY
Message-ID: <CALj7hYWGkYyfpZ-0KGSkArnJepaptVkW70xnKktBuO29PajmpQ@mail.gmail.com>
Subject: ..another device for the ftdi_sio driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there -

finally I prepared a patch for the famous ftdi_sio usb serial driver.
Adding two Tagsys RFID readers I am using.
After having asked Bill Ryder he suggested adressing the
linux-usb-devel mailing list. (what?)

Sorry for the mess below - I am not doing this frequently - being
rather a leecher over the last 20 years:-)


diff -uprN linux-source-3.2.0/drivers/usb/serial/ftdi_sio.c
linux-source-3.2.0+tagsysRFID/drivers/usb/serial/ftdi_sio.c
--- linux-source-3.2.0/drivers/usb/serial/ftdi_sio.c    2013-12-03
18:40:26.000000000 +0100
+++ linux-source-3.2.0+tagsysRFID/drivers/usb/serial/ftdi_sio.c
2014-02-01 16:32:40.146698791 +0100
@@ -202,6 +202,8 @@ static struct usb_device_id id_table_com
        { USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
        { USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+       { USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
diff -uprN linux-source-3.2.0/drivers/usb/serial/ftdi_sio_ids.h
linux-source-3.2.0+tagsysRFID/drivers/usb/serial/ftdi_sio_ids.h
--- linux-source-3.2.0/drivers/usb/serial/ftdi_sio_ids.h
2013-12-03 18:40:26.000000000 +0100
+++ linux-source-3.2.0+tagsysRFID/drivers/usb/serial/ftdi_sio_ids.h
 2014-02-01 16:33:50.239338227 +0100
@@ -363,6 +363,13 @@
 /* Sprog II (Andrew Crosland's SprogII DCC interface) */
 #define FTDI_SPROG_II          0xF0C8

+/*
+ * Tagsys RFID Readers
+ * survey (two of them) by Ulrich Hahn
+ */
+#define FTDI_TAGSYS_LP101_PID       0xF0E9  /* Tagsys L-P101 RFID*/
+#define FTDI_TAGSYS_P200X_PID       0xF0EE  /* Tagsys Medio P200x RFID*/
+
 /* an infrared receiver for user access control with IR tags */
 #define FTDI_PIEGROUP_PID      0xF208  /* Product Id */

Signed-off-by: Ulrich Hahn <uhahn@eanco.de>


best regards
Ulrich Hahn

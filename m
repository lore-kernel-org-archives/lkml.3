Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3C1PGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:06:24 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44623 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3C1PGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:06:20 -0400
From: Konstantin Holoborodko <klh.kernel@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Konstantin Holoborodko <klh.kernel@gmail.com>
Subject: [PATCH] usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD
Date: Fri, 29 Mar 2013 00:06:13 +0900
Message-Id: <1364483173-11500-1-git-send-email-klh.kernel@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It enhances the driver for FTDI-based USB serial adapters
to recognize Mitsubishi Electric Corp. USB/RS422 Converters
as FT232BM chips and support them.
https://search.meau.com/?q=FX-USB-AW

Signed-off-by: Konstantin Holoborodko <klh.kernel@gmail.com>
Tested-by: Konstantin Holoborodko <klh.kernel@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d4809d5..9886180 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -640,6 +640,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
 	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
+	{ USB_DEVICE(MITSUBISHI_VID, MITSUBISHI_FXUSB_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 9d359e1..e79861e 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -584,6 +584,13 @@
 #define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
 
 /*
+ * Mitsubishi Electric Corp. (http://www.meau.com)
+ * Submitted by Konstantin Holoborodko
+ */
+#define MITSUBISHI_VID		0x06D3
+#define MITSUBISHI_FXUSB_PID	0x0284 /* USB/RS422 converters: FX-USB-AW/-BD */
+
+/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */
-- 
1.7.9.5


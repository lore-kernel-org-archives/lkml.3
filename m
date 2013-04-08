Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936459Ab3DHKR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:17:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42739 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935583Ab3DHJvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Holoborodko <klh.kernel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/102] usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD
Date: Mon,  8 Apr 2013 10:49:48 +0100
Message-Id: <1365414657-29191-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Holoborodko <klh.kernel@gmail.com>

commit 482b0b5d82bd916cc0c55a2abf65bdc69023b843 upstream.

It enhances the driver for FTDI-based USB serial adapters
to recognize Mitsubishi Electric Corp. USB/RS422 Converters
as FT232BM chips and support them.
https://search.meau.com/?q=FX-USB-AW

Signed-off-by: Konstantin Holoborodko <klh.kernel@gmail.com>
Tested-by: Konstantin Holoborodko <klh.kernel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1f939cb..cddca7f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -648,6 +648,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
 	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
+	{ USB_DEVICE(MITSUBISHI_VID, MITSUBISHI_FXUSB_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 9d359e18..e79861e 100644
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
1.8.1.2


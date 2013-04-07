Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874Ab3DGXb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:31:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46780 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934583Ab3DGXbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:31:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Konstantin Holoborodko" <klh.kernel@gmail.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.172861017@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [38/74] usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -648,6 +648,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
 	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
+	{ USB_DEVICE(MITSUBISHI_VID, MITSUBISHI_FXUSB_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
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


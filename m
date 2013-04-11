Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936388Ab3DKVDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:03:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935752Ab3DKUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:17 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=b2a7M-lswegA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qESsptcO_bQA:10 a=pGLkceISAAAA:8 a=sOvEHXT4AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202602.011525626@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Konstantin Holoborodko <klh.kernel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 097/171 ] usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0097-usb-ftdi_sio-Add-support-for-Mitsubishi-FX-USB-AW-BD.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Konstantin Holoborodko <klh.kernel@gmail.com>

[ Upstream commit 482b0b5d82bd916cc0c55a2abf65bdc69023b843 ]

It enhances the driver for FTDI-based USB serial adapters
to recognize Mitsubishi Electric Corp. USB/RS422 Converters
as FT232BM chips and support them.
https://search.meau.com/?q=FX-USB-AW

Signed-off-by: Konstantin Holoborodko <klh.kernel@gmail.com>
Tested-by: Konstantin Holoborodko <klh.kernel@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 360bdeb..edf6bb4 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -647,6 +647,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
 	{ USB_DEVICE(ACTON_VID, ACTON_SPECTRAPRO_PID) },
 	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
+	{ USB_DEVICE(MITSUBISHI_VID, MITSUBISHI_FXUSB_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 049b6e7..4801983 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -577,6 +577,13 @@
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
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab3GCS6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:58:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183Ab3GCSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:51 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=kXCziQ0v94QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=moTEe2FfZVUA:10 a=VZE4gLrUAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=XuoIeGlZvS0XHmn7ZBsA:9 a=3rEIPAstt5gA:10 a=FprxmC2WWiEA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184045.786021344@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Gomella <andrew.gomella@nih.gov>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [007/141] USB: ftdi_sio: Add support for Newport CONEX motor drivers
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0007-USB-ftdi_sio-Add-support-for-Newport-CONEX-motor-dri.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Gomella, Andrew (NIH/NHLBI) [F]" <andrew.gomella@nih.gov>

[ Upstream commit 7138143972b7c293267c783fc99a194f0ceff7f2 ]

Here are two more devices that use FTDI USB-to-serial chips with new product ID's.

The devices are the Newport Conex-AGP and Conex-CC motor controllers.
(http://www.newport.com/CONEX-AGP-Integrated-Piezo-Motor-Rotation-Stages-/987623/1033/info.aspx)
(http://www.newport.com/CONEX-CC-DC-Servo-Controller-Actuators/934114/1033/info.aspx)

usb-devices command yields:

P:  Vendor=104d ProdID=3002 Rev=06.00
S:  Manufacturer=Newport
S:  Product=CONEX-CC

as well as

P:  Vendor=104d ProdID=3006 Rev=06.00
S:  Manufacturer=Newport
S:  Product=CONEX-AGP

Signed-off-by: Andrew Gomella <andrew.gomella@nih.gov>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5843cc8..5c3e249 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -197,6 +197,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_CC_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_AGP_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5c84306..1e4bff5 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -765,6 +765,8 @@
  */
 #define NEWPORT_VID			0x104D
 #define NEWPORT_AGILIS_PID		0x3000
+#define NEWPORT_CONEX_CC_PID		0x3002
+#define NEWPORT_CONEX_AGP_PID		0x3006
 
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */
-- 
1.7.10.4



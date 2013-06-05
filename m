Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab3FEVZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:25:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab3FEVMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:12:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Gomella <andrew.gomella@nih.gov>
Subject: [ 06/44] USB: ftdi_sio: Add support for Newport CONEX motor drivers
Date: Wed,  5 Jun 2013 14:12:04 -0700
Message-Id: <20130605211222.540890192@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Gomella, Andrew (NIH/NHLBI) [F]" <andrew.gomella@nih.gov>

commit 7138143972b7c293267c783fc99a194f0ceff7f2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -199,6 +199,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_CC_PID) },
+	{ USB_DEVICE(NEWPORT_VID, NEWPORT_CONEX_AGP_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -772,6 +772,8 @@
  */
 #define NEWPORT_VID			0x104D
 #define NEWPORT_AGILIS_PID		0x3000
+#define NEWPORT_CONEX_CC_PID		0x3002
+#define NEWPORT_CONEX_AGP_PID		0x3006
 
 /* Interbiometrics USB I/O Board */
 /* Developed for Interbiometrics by Rudolf Gugler */



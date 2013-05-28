Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab3E1Dy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:54:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52556 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758858Ab3E1DyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Gomella, Andrew (NIH/NHLBI)=?UTF-8?Q?=20?=[F]" 
	<andrew.gomella@nih.gov>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.752324303@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [48/94] USB: ftdi_sio: Add support for Newport CONEX motor drivers
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -197,6 +197,8 @@ static struct usb_device_id id_table_com
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


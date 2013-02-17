Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3BQWzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741Ab3BQWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:01 -0500
Message-Id: <20130217225003.759368754@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sven Killig <sven@killig.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 18/66] USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Killig <sven@killig.de>

commit c249f911406efcc7456cb4af79396726bf7b8c57 upstream.

Add PID/VID entries for ELV WS 300 PC II weather station

Signed-off-by: Sven Killig <sven@killig.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ba68835..3ae3ff3 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -584,6 +584,7 @@ static struct usb_device_id id_table_combined [] = {
 	/*
 	 * ELV devices:
 	 */
+	{ USB_DEVICE(FTDI_ELV_VID, FTDI_ELV_WS300_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_USR_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_MSM1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_KL100_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index fa5d560..7c89cfc 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -204,7 +204,7 @@
 
 /*
  * ELV USB devices submitted by Christian Abt of ELV (www.elv.de).
- * All of these devices use FTDI's vendor ID (0x0403).
+ * Almost all of these devices use FTDI's vendor ID (0x0403).
  * Further IDs taken from ELV Windows .inf file.
  *
  * The previously included PID for the UO 100 module was incorrect.
@@ -212,6 +212,8 @@
  *
  * Armin Laeuger originally sent the PID for the UM 100 module.
  */
+#define FTDI_ELV_VID	0x1B1F	/* ELV AG */
+#define FTDI_ELV_WS300_PID	0xC006	/* eQ3 WS 300 PC II */
 #define FTDI_ELV_USR_PID	0xE000	/* ELV Universal-Sound-Recorder */
 #define FTDI_ELV_MSM1_PID	0xE001	/* ELV Mini-Sound-Modul */
 #define FTDI_ELV_KL100_PID	0xE002	/* ELV Kfz-Leistungsmesser KL 100 */



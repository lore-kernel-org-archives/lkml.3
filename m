Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaCaALd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:11:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbaC3Xmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Joerg Dorchain" <joerg@dorchain.net>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.300213677@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 144/200] USB: ftdi_sio: add Cressi Leonardo PID
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Dorchain <joerg@dorchain.net>

commit 6dbd46c849e071e6afc1e0cad489b0175bca9318 upstream.

Hello,

the following patch adds an entry for the PID of a Cressi Leonardo
diving computer interface to kernel 3.13.0.
It is detected as FT232RL.
Works with subsurface.

Signed-off-by: Joerg Dorchain <joerg@dorchain.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -918,6 +918,8 @@ static struct usb_device_id id_table_com
 	/* Crucible Devices */
 	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_Z3X_PID) },
+	/* Cressi Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CRESSI_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1320,3 +1320,9 @@
  * Manufacturer: Smart GSM Team
  */
 #define FTDI_Z3X_PID		0x0011
+
+/*
+ * Product: Cressi PC Interface
+ * Manufacturer: Cressi
+ */
+#define FTDI_CRESSI_PID		0x87d0


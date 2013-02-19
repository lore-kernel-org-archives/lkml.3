Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135Ab3BSSvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54276 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934123Ab3BSSvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sven Killig <sven@killig.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 29/81] USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II
Date: Tue, 19 Feb 2013 15:48:52 -0300
Message-Id: <1361299784-8830-30-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Killig <sven@killig.de>

commit c249f911406efcc7456cb4af79396726bf7b8c57 upstream.

Add PID/VID entries for ELV WS 300 PC II weather station

Signed-off-by: Sven Killig <sven@killig.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 653139b..031b23c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -590,6 +590,7 @@ static struct usb_device_id id_table_combined [] = {
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
-- 
1.7.9.5


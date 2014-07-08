Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaGHNHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:07:12 -0400
Received: from kiutl.biot.com ([31.172.244.210]:37275 "EHLO kiutl.biot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbaGHNHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:07:10 -0400
X-Greylist: delayed 1456 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2014 09:07:10 EDT
From: Bert Vermeulen <bert@biot.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bert Vermeulen <bert@biot.com>
Subject: [PATCH] USB: ftdi_sio: Add extra PID.
Date: Tue,  8 Jul 2014 14:42:23 +0200
Message-Id: <1404823343-7236-1-git-send-email-bert@biot.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PID 0x0003 to the VID 0x128d (Testo). At least the
Testo 435-4 uses this, likely other gear as well.

Signed-off-by: Bert Vermeulen <bert@biot.com>
---
 drivers/usb/serial/ftdi_sio.c     | 3 ++-
 drivers/usb/serial/ftdi_sio_ids.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 115662c1..bf2e30a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -720,7 +720,8 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_ACG_HFDUAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_YEI_SERVOCENTER31_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_THORLABS_PID) },
-	{ USB_DEVICE(TESTO_VID, TESTO_USB_INTERFACE_PID) },
+	{ USB_DEVICE(TESTO_VID, TESTO_1_PID) },
+	{ USB_DEVICE(TESTO_VID, TESTO_3_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_GAMMA_SCOUT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TACTRIX_OPENPORT_13M_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TACTRIX_OPENPORT_13S_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 500474c..106cc16 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -798,7 +798,8 @@
  * Submitted by Colin Leroy
  */
 #define TESTO_VID			0x128D
-#define TESTO_USB_INTERFACE_PID		0x0001
+#define TESTO_1_PID			0x0001
+#define TESTO_3_PID			0x0003
 
 /*
  * Mobility Electronics products.
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbaGRNh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:37:29 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17682 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761921AbaGRNNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:13:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bert Vermeulen <bert@biot.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 129/170] USB: ftdi_sio: Add extra PID.
Date: Fri, 18 Jul 2014 14:12:14 +0200
Message-Id: <b9240255c51f6c16ed4f3eda10be351ba58f2967.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bert Vermeulen <bert@biot.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5a7fbe7e9ea0b1b9d7ffdba64db1faa3a259164c upstream.

This patch adds PID 0x0003 to the VID 0x128d (Testo). At least the
Testo 435-4 uses this, likely other gear as well.

Signed-off-by: Bert Vermeulen <bert@biot.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio.c     | 3 ++-
 drivers/usb/serial/ftdi_sio_ids.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ebf04c7d49cb..399fe9fa4db0 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -721,7 +721,8 @@ static struct usb_device_id id_table_combined [] = {
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
index 500474c48f4b..106cc16cc6ed 100644
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
2.0.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaFWJGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:06:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55458 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/111] USB: ftdi_sio: add NovaTech OrionLXm product ID
Date: Mon, 23 Jun 2014 10:31:23 +0200
Message-Id: <05fabc1b425e984177f602fc7e3c9b453373567a.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d0839d757e6294921c31b1c4ca4f1dcc5df63bcd upstream.

The NovaTech OrionLXm uses an onboard FTDI serial converter for JTAG and
console access.

Here is the lsusb output:
Bus 004 Device 123: ID 0403:7c90 Future Technology Devices
International, Ltd

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c94be8c051c0..503c89e18187 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -581,6 +581,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TIAO_UMPA_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLXM_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	/*
 	 * ELV devices:
 	 */
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 993c93df6874..500474c48f4b 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -538,6 +538,11 @@
  */
 #define FTDI_TIAO_UMPA_PID	0x8a98	/* TIAO/DIYGADGET USB Multi-Protocol Adapter */
 
+/*
+ * NovaTech product ids (FTDI_VID)
+ */
+#define FTDI_NT_ORIONLXM_PID	0x7c90	/* OrionLXm Substation Automation Platform */
+
 
 /********************************/
 /** third-party VID/PID combos **/
-- 
2.0.0


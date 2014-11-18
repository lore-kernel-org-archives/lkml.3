Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaKROcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:32:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaKROKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Frans Klaver <frans.klaver@xsens.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 145/206] usb: serial: ftdi_sio: add Awinda Station and Dongle products
Date: Tue, 18 Nov 2014 15:08:20 +0100
Message-Id: <ff8aff4db6d20ca4da80bec75e3b9987646b553f.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Klaver <frans.klaver@xsens.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit edd74ffab1f6909eee400c7de8ce621870aacac9 upstream.

Add new IDs for the Xsens Awinda Station and Awinda Dongle.

While at it, order the definitions by PID and add a logical separation
between devices using Xsens' VID and those using FTDI's VID.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 87d816bbf9e0..ee5b4b81928d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -675,6 +675,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 5937b2d242f2..b68084c11432 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -143,8 +143,12 @@
  * Xsens Technologies BV products (http://www.xsens.com).
  */
 #define XSENS_VID		0x2639
-#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+#define XSENS_AWINDA_STATION_PID 0x0101
+#define XSENS_AWINDA_DONGLE_PID 0x0102
 #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
+#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+
+/* Xsens devices using FTDI VID */
 #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
 #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
 #define XSENS_CONVERTER_2_PID	0xD38A
-- 
2.1.3


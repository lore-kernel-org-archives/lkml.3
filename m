Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934382AbbA1EWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:22:53 -0500
Received: from mail.kernel.org ([198.145.29.136]:40053 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934298AbbA1EWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:43 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Frans Klaver <frans.klaver@xsens.com>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 096/177] usb: serial: ftdi_sio: add Awinda Station and Dongle products
Date: Wed, 28 Jan 2015 12:09:14 +0800
Message-Id: <1422418236-12852-187-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Klaver <frans.klaver@xsens.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit edd74ffab1f6909eee400c7de8ce621870aacac9 upstream.

Add new IDs for the Xsens Awinda Station and Awinda Dongle.

While at it, order the definitions by PID and add a logical separation
between devices using Xsens' VID and those using FTDI's VID.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c7c980b..7736459 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -685,6 +685,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 02abda9..bd2a2c9 100644
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
1.9.1


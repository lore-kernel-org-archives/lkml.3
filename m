Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaKKLf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:35:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaKKLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frans Klaver <frans.klaver@xsens.com>, Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 107/170] usb: serial: ftdi_sio: add Awinda Station and Dongle products
Date: Tue, 11 Nov 2014 11:07:46 +0000
Message-Id: <1415704129-12709-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frans Klaver <frans.klaver@xsens.com>

commit edd74ffab1f6909eee400c7de8ce621870aacac9 upstream.

Add new IDs for the Xsens Awinda Station and Awinda Dongle.

While at it, order the definitions by PID and add a logical separation
between devices using Xsens' VID and those using FTDI's VID.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3614620e09e1..dafc40d010b2 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -674,6 +674,8 @@ static const struct usb_device_id id_table_combined[] = {
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
2.1.0


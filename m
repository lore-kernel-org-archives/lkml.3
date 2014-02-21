Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbaBUNis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:38:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaBUMum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ulrich Hahn <uhahn@eanco.de>, Johan Hovold <johan@hovold.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/121] USB: ftdi_sio: add Tagsys RFID Reader IDs
Date: Fri, 21 Feb 2014 12:48:12 +0000
Message-Id: <1392986945-9693-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Hahn <uhahn@eanco.de>

commit 76f24e3f39a1a94bab0d54e98899d64abcd9f69c upstream.

Adding two more IDs to the ftdi_sio usb serial driver.
It now connects Tagsys RFID readers.
There might be more IDs out there for other Tagsys models.

Signed-off-by: Ulrich Hahn <uhahn@eanco.de>
Cc: Johan Hovold <johan@hovold.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 06eca51..b7446a6 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -195,6 +195,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index eb03021..1e2d369 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -364,6 +364,12 @@
 /* Sprog II (Andrew Crosland's SprogII DCC interface) */
 #define FTDI_SPROG_II		0xF0C8
 
+/*
+ * Two of the Tagsys RFID Readers
+ */
+#define FTDI_TAGSYS_LP101_PID	0xF0E9	/* Tagsys L-P101 RFID*/
+#define FTDI_TAGSYS_P200X_PID	0xF0EE	/* Tagsys Medio P200x RFID*/
+
 /* an infrared receiver for user access control with IR tags */
 #define FTDI_PIEGROUP_PID	0xF208	/* Product Id */
 
-- 
1.9.0


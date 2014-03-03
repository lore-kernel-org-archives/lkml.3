Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaCCS7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:59:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56144 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaCCS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:59:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ulrich Hahn <uhahn@eanco.de>, Johan Hovold <johan@hovold.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 38/67] USB: ftdi_sio: add Tagsys RFID Reader IDs
Date: Mon,  3 Mar 2014 10:55:26 -0800
Message-Id: <1393872955-28810-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Hahn <uhahn@eanco.de>

commit 76f24e3f39a1a94bab0d54e98899d64abcd9f69c upstream.

Adding two more IDs to the ftdi_sio usb serial driver.
It now connects Tagsys RFID readers.
There might be more IDs out there for other Tagsys models.

Signed-off-by: Ulrich Hahn <uhahn@eanco.de>
Cc: Johan Hovold <johan@hovold.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 579a2c3..df8a23d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -197,6 +197,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_LP101_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_TAGSYS_P200X_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_LENZ_LIUSB_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 83ca064..9cf48543 100644
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
1.8.3.2


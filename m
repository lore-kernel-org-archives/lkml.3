Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaKKLdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:33:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaKKLKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Perry Hung <iperry@gmail.com>, Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 117/170] usb: serial: ftdi_sio: add "bricked" FTDI device PID
Date: Tue, 11 Nov 2014 11:07:56 +0000
Message-Id: <1415704129-12709-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Hung <iperry@gmail.com>

commit 7f2719f0003da1ad13124ef00f48d7514c79e30d upstream.

An official recent Windows driver from FTDI detects counterfeit devices
and reprograms the internal EEPROM containing the USB PID to 0, effectively
bricking the device.

Add support for this VID/PID pair to correctly bind the driver on these
devices.

See:
http://hackaday.com/2014/10/22/watch-that-windows-update-ftdi-drivers-are-killing-fake-chips/

Signed-off-by: Perry Hung <iperry@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index dafc40d010b2..a523adad6380 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -145,6 +145,7 @@ static struct ftdi_sio_quirk ftdi_8u2232c_quirk = {
  * /sys/bus/usb-serial/drivers/ftdi_sio/new_id and send a patch or report.
  */
 static const struct usb_device_id id_table_combined[] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_BRICK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index b68084c11432..6786b705ccf6 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -30,6 +30,12 @@
 
 /*** third-party PIDs (using FTDI_VID) ***/
 
+/*
+ * Certain versions of the official Windows FTDI driver reprogrammed
+ * counterfeit FTDI devices to PID 0. Support these devices anyway.
+ */
+#define FTDI_BRICK_PID		0x0000
+
 #define FTDI_LUMEL_PD12_PID	0x6002
 
 /*
-- 
2.1.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581AbbA1Ern (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:47:43 -0500
Received: from mail.kernel.org ([198.145.29.136]:40170 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934390AbbA1EW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:58 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Perry Hung <iperry@gmail.com>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 101/177] usb: serial: ftdi_sio: add "bricked" FTDI device PID
Date: Wed, 28 Jan 2015 12:09:19 +0800
Message-Id: <1422418236-12852-192-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Perry Hung <iperry@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7736459..a89433b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -156,6 +156,7 @@ static struct ftdi_sio_quirk ftdi_8u2232c_quirk = {
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_BRICK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index bd2a2c9..64ee791 100644
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
1.9.1


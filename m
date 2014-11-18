Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaKROlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:41:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbaKROKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Perry Hung <iperry@gmail.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 146/206] usb: serial: ftdi_sio: add "bricked" FTDI device PID
Date: Tue, 18 Nov 2014 15:08:21 +0100
Message-Id: <0de57c08042f960997e77635d7cf4ea7acd86c31.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Perry Hung <iperry@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ee5b4b81928d..74c20472c25b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -146,6 +146,7 @@ static struct ftdi_sio_quirk ftdi_8u2232c_quirk = {
  * /sys/bus/usb-serial/drivers/ftdi_sio/new_id and send a patch or report.
  */
 static struct usb_device_id id_table_combined [] = {
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
2.1.3


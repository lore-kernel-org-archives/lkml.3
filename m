Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbaKLB36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:29:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaKLB3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:29:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Perry Hung <iperry@gmail.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.17 200/319] usb: serial: ftdi_sio: add "bricked" FTDI device PID
Date: Wed, 12 Nov 2014 10:15:38 +0900
Message-Id: <20141112011025.930580639@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -140,6 +140,7 @@ static struct ftdi_sio_quirk ftdi_8u2232
  * /sys/bus/usb-serial/drivers/ftdi_sio/new_id and send a patch or report.
  */
 static const struct usb_device_id id_table_combined[] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_BRICK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
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



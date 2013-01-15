Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514Ab3AOW7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:59:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:48749 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934006Ab3AOW6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:58:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tomasz Mloduchowski <q@qdot.me>
Subject: [ 60/71] usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added
Date: Tue, 15 Jan 2013 14:54:57 -0800
Message-Id: <20130115225344.714649158@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Mloduchowski <q@qdot.me>

commit 8cf65dc386f3634a43312f436cc7a935476a40c4 upstream.

Simple fix to add support for Crucible Technologies COMET Caller ID
USB decoder - a device containing FTDI USB/Serial converter chip,
handling 1200bps CallerID messages decoded from the phone line -
adding correct USB PID is sufficient.

Tested to apply cleanly and work flawlessly against 3.6.9, 3.7.0-rc8
and 3.8.0-rc3 on both amd64 and x86 arches.

Signed-off-by: Tomasz Mloduchowski <q@qdot.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -879,6 +879,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
+	/* Crucible Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1259,3 +1259,9 @@
  * ATI command output: Cinterion MC55i
  */
 #define FTDI_CINTERION_MC55I_PID	0xA951
+
+/*
+ * Product: Comet Caller ID decoder
+ * Manufacturer: Crucible Technologies
+ */
+#define FTDI_CT_COMET_PID	0x8e08



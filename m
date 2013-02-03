Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3BCO42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34305 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272Ab3BCO4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:17 -0500
Message-Id: <20130203144648.340748414@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tomasz Mloduchowski <q@qdot.me>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 048/128] usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0a373b3..ba68835 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -875,6 +875,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
+	/* Crucible Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 049b6e7..fa5d560 100644
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



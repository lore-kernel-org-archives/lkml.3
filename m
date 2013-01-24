Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3AXDgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:36:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3AXDbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomasz Mloduchowski <q@qdot.me>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 60/74] usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added
Date: Thu, 24 Jan 2013 01:27:12 -0200
Message-Id: <1358998046-613-61-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 360bdeb..653139b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -881,6 +881,8 @@ static struct usb_device_id id_table_combined [] = {
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
-- 
1.7.9.5


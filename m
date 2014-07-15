Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaGORML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:11 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60562 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbaGORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:19 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 70/94] USB: serial: ftdi_sio: Add Infineon Triboard
Date: Tue, 15 Jul 2014 20:01:25 +0300
Message-Id: <1405443709-15288-70-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Sojka <sojkam1@fel.cvut.cz>

This adds support for Infineon TriBoard TC1798 [1]. Only interface 1
is used as serial line (see [2], Figure 8-6).

[1] http://www.infineon.com/cms/de/product/microcontroller/development-tools-software-and-kits/tricore-tm-development-tools-software-and-kits/starterkits-and-evaluation-boards/starter-kit-tc1798/channel.html?channel=db3a304333b8a7ca0133cfa3d73e4268
[2] http://www.infineon.com/dgdl/TriBoardManual-TC1798-V10.pdf?folderId=db3a304412b407950112b409ae7c0343&fileId=db3a304333b8a7ca0133cfae99fe426a

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: Johan Hovold <johan@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bf2e30a..8a3813b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -945,6 +945,8 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
+	/* Infineon Devices */
+	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 106cc16..c4777bc 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -584,6 +584,12 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020
 
 /*
+ * Infineon Technologies
+ */
+#define INFINEON_VID		0x058b
+#define INFINEON_TRIBOARD_PID	0x0028 /* DAS JTAG TriBoard TC1798 V1.0 */
+
+/*
  * Acton Research Corp.
  */
 #define ACTON_VID		0x0647	/* Vendor ID */
-- 
1.7.10.4


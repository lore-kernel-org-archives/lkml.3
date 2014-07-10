Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaGJMIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:08:38 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:34436 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaGJMIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:08:35 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2014 08:08:34 EDT
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH] USB: serial: ftdi_sio: Add Infineon Triboard
Date: Thu, 10 Jul 2014 14:00:34 +0200
Message-Id: <1404993634-5251-1-git-send-email-sojkam1@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for Infineon TriBoard TC1798 [1]. Only interface 1
is used as serial line (see [2], Figure 8-6).

[1] http://www.infineon.com/cms/de/product/microcontroller/development-tools-software-and-kits/tricore-tm-development-tools-software-and-kits/starterkits-and-evaluation-boards/starter-kit-tc1798/channel.html?channel=db3a304333b8a7ca0133cfa3d73e4268
[2] http://www.infineon.com/dgdl/TriBoardManual-TC1798-V10.pdf?folderId=db3a304412b407950112b409ae7c0343&fileId=db3a304333b8a7ca0133cfae99fe426a

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 115662c1..0c2b6e0 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -944,6 +944,8 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
+	/* Infineon Devices */
+	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 500474c..8d959a7 100644
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
2.0.0


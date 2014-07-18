Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346AbaGRNDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:03:03 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17196 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965133AbaGRNC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:02:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 130/170] USB: serial: ftdi_sio: Add Infineon Triboard
Date: Fri, 18 Jul 2014 14:12:15 +0200
Message-Id: <5179e365aa9aad2b038f35a0fe597ee1f921463f.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Sojka <sojkam1@fel.cvut.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d8279a40e50ad55539780aa617a32a53d7f0953e upstream.

This adds support for Infineon TriBoard TC1798 [1]. Only interface 1
is used as serial line (see [2], Figure 8-6).

[1] http://www.infineon.com/cms/de/product/microcontroller/development-tools-software-and-kits/tricore-tm-development-tools-software-and-kits/starterkits-and-evaluation-boards/starter-kit-tc1798/channel.html?channel=db3a304333b8a7ca0133cfa3d73e4268
[2] http://www.infineon.com/dgdl/TriBoardManual-TC1798-V10.pdf?folderId=db3a304412b407950112b409ae7c0343&fileId=db3a304333b8a7ca0133cfae99fe426a

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 399fe9fa4db0..e0bf8ee1f976 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -946,6 +946,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
+	/* Infineon Devices */
+	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 106cc16cc6ed..c4777bc6aee0 100644
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


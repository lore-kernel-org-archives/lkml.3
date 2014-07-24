Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934981AbaGXJvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:51:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934853AbaGXJtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 122/128] USB: serial: ftdi_sio: Add Infineon Triboard
Date: Thu, 24 Jul 2014 10:46:11 +0100
Message-Id: <1406195177-8656-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Sojka <sojkam1@fel.cvut.cz>

commit d8279a40e50ad55539780aa617a32a53d7f0953e upstream.

This adds support for Infineon TriBoard TC1798 [1]. Only interface 1
is used as serial line (see [2], Figure 8-6).

[1] http://www.infineon.com/cms/de/product/microcontroller/development-tools-software-and-kits/tricore-tm-development-tools-software-and-kits/starterkits-and-evaluation-boards/starter-kit-tc1798/channel.html?channel=db3a304333b8a7ca0133cfa3d73e4268
[2] http://www.infineon.com/dgdl/TriBoardManual-TC1798-V10.pdf?folderId=db3a304412b407950112b409ae7c0343&fileId=db3a304333b8a7ca0133cfae99fe426a

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3ff453947e41..9e75e3eaea4f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -948,6 +948,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
+	/* Infineon Devices */
+	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
 	{ },					/* Optional parameter entry */
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
1.9.1


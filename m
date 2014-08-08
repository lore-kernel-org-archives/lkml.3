Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbaHHUyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:54:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbaHHUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 100/259] USB: serial: ftdi_sio: Add Infineon Triboard
Date: Fri,  8 Aug 2014 13:38:43 -0700
Message-Id: <1407530482-4483-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 2a077ea..44771a0 100644
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
1.9.1


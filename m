Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaI3Vio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaI3Vil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ja=C5=A1a=20Bartelj?= <jasa.bartelj@gmail.com>,
        Johan Hovold <johan@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 052/103] USB: ftdi_sio: Added PID for new ekey device
Date: Tue, 30 Sep 2014 14:30:57 -0700
Message-Id: <1412112708-27356-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ja=C5=A1a=20Bartelj?= <jasa.bartelj@gmail.com>

commit 646907f5bfb0782c731ae9ff6fb63471a3566132 upstream.

Added support to the ftdi_sio driver for ekey Converter USB which
uses an FT232BM chip.

Signed-off-by: Jaša Bartelj <jasa.bartelj@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 6f4e126..d429761 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -949,6 +949,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
+	/* ekey Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
 	/* Infineon Devices */
 	{ USB_DEVICE_INTERFACE_NUMBER(INFINEON_VID, INFINEON_TRIBOARD_PID, 1) },
 	{ }					/* Terminating entry */
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 3168a01..70b0b1d 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1380,3 +1380,8 @@
 #define BRAINBOXES_US_160_6_PID		0x9006 /* US-160 16xRS232 1Mbaud Port 11 and 12 */
 #define BRAINBOXES_US_160_7_PID		0x9007 /* US-160 16xRS232 1Mbaud Port 13 and 14 */
 #define BRAINBOXES_US_160_8_PID		0x9008 /* US-160 16xRS232 1Mbaud Port 15 and 16 */
+
+/*
+ * ekey biometric systems GmbH (http://ekey.net/)
+ */
+#define FTDI_EKEY_CONV_USB_PID		0xCB08	/* Converter USB */
-- 
1.9.1


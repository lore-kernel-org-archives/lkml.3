Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaIWCjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:39:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:38207 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbaIWCj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:39:28 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ja=C5=A1a=20Bartelj?= <jasa.bartelj@gmail.com>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 22/45] USB: ftdi_sio: Added PID for new ekey device
Date: Tue, 23 Sep 2014 10:31:24 +0800
Message-Id: <1411439507-30391-22-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaša Bartelj <jasa.bartelj@gmail.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 646907f5bfb0782c731ae9ff6fb63471a3566132 upstream.

Added support to the ftdi_sio driver for ekey Converter USB which
uses an FT232BM chip.

Signed-off-by: Jaša Bartelj <jasa.bartelj@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index eab9340..121a052 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -957,6 +957,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_842_4_PID) },
+	/* ekey Devices */
+	{ USB_DEVICE(FTDI_VID, FTDI_EKEY_CONV_USB_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 7e926cd..0eb2e97 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1371,3 +1371,8 @@
 #define BRAINBOXES_US_160_6_PID		0x9006 /* US-160 16xRS232 1Mbaud Port 11 and 12 */
 #define BRAINBOXES_US_160_7_PID		0x9007 /* US-160 16xRS232 1Mbaud Port 13 and 14 */
 #define BRAINBOXES_US_160_8_PID		0x9008 /* US-160 16xRS232 1Mbaud Port 15 and 16 */
+
+/*
+ * ekey biometric systems GmbH (http://ekey.net/)
+ */
+#define FTDI_EKEY_CONV_USB_PID		0xCB08	/* Converter USB */
-- 
1.7.9.5


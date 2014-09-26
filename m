Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbaIZKee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:34:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbaIZJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:59 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ja=C5=A1a=20Bartelj?= <jasa.bartelj@gmail.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/142] USB: ftdi_sio: Added PID for new ekey device
Date: Fri, 26 Sep 2014 11:43:54 +0200
Message-Id: <4f3a9801a2d14233e8b3c64ce3db37e13ddeb721.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaša Bartelj <jasa.bartelj@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 646907f5bfb0782c731ae9ff6fb63471a3566132 upstream.

Added support to the ftdi_sio driver for ekey Converter USB which
uses an FT232BM chip.

Signed-off-by: Jaša Bartelj <jasa.bartelj@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b370cc8f0b96..bb68ed5cd3bc 100644
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
index 3168a0191973..70b0b1d88ae9 100644
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
2.1.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab3EGNxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:53:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298Ab3EGNmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adrian Thomasset <adrian.thomasset@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 097/118] USB: ftdi_sio: correct ST Micro Connect Lite PIDs
Date: Tue,  7 May 2013 14:39:03 +0100
Message-Id: <1367933964-1564-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Thomasset <adrian.thomasset@st.com>

commit 9f06d15f8db6946e41f73196a122b84a37938878 upstream.

The current ST Micro Connect Lite uses the FT4232H hi-speed quad USB
UART FTDI chip. It is also possible to drive STM reference targets
populated with an on-board JTAG debugger based on the FT2232H chip with
the same STMicroelectronics tools.

For this reason, the ST Micro Connect Lite PIDs should be
ST_STMCLT_2232_PID: 0x3746
ST_STMCLT_4232_PID: 0x3747

Signed-off-by: Adrian Thomasset <adrian.thomasset@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/ftdi_sio.c     | 4 +++-
 drivers/usb/serial/ftdi_sio_ids.h | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 527fb35..ecfd525 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -877,7 +877,9 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
 	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
+	{ USB_DEVICE(ST_VID, ST_STMCLT_2232_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ST_VID, ST_STMCLT_4232_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_RF_R106) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 3c00351..9852827 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1151,7 +1151,8 @@
  * STMicroelectonics
  */
 #define ST_VID			0x0483
-#define ST_STMCLT1030_PID	0x3747 /* ST Micro Connect Lite STMCLT1030 */
+#define ST_STMCLT_2232_PID	0x3746
+#define ST_STMCLT_4232_PID	0x3747
 
 /*
  * Papouch products (http://www.papouch.com/)
-- 
1.8.1.2


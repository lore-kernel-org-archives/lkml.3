Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3EFXhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:37:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760401Ab3EFXNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adrian Thomasset <adrian.thomasset@st.com>
Subject: [ 022/104] USB: ftdi_sio: correct ST Micro Connect Lite PIDs
Date: Mon,  6 May 2013 16:11:41 -0700
Message-Id: <20130506230045.869969218@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/ftdi_sio.c     |    4 +++-
 drivers/usb/serial/ftdi_sio_ids.h |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -871,7 +871,9 @@ static struct usb_device_id id_table_com
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



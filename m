Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3ERCQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:16:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3ERCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:48 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xG7FASiUxxYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GzrDZu2snX4A:10 a=8b9GpE9nAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=W5mFZgEbAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=RUNXi7WdHkcA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021644.011355441@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Adrian Thomasset <adrian.thomasset@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 014/136 ] USB: ftdi_sio: correct ST Micro Connect Lite PIDs
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0014-USB-ftdi_sio-correct-ST-Micro-Connect-Lite-PIDs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Adrian Thomasset <adrian.thomasset@st.com>

[ Upstream commit 9f06d15f8db6946e41f73196a122b84a37938878 ]

The current ST Micro Connect Lite uses the FT4232H hi-speed quad USB
UART FTDI chip. It is also possible to drive STM reference targets
populated with an on-board JTAG debugger based on the FT2232H chip with
the same STMicroelectronics tools.

For this reason, the ST Micro Connect Lite PIDs should be
ST_STMCLT_2232_PID: 0x3746
ST_STMCLT_4232_PID: 0x3747

Signed-off-by: Adrian Thomasset <adrian.thomasset@st.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/serial/ftdi_sio.c     |    4 +++-
 drivers/usb/serial/ftdi_sio_ids.h |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f656145..8e9a6cd 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -875,7 +875,9 @@ static struct usb_device_id id_table_combined [] = {
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
index 1463afc..5c84306 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1144,7 +1144,8 @@
  * STMicroelectonics
  */
 #define ST_VID			0x0483
-#define ST_STMCLT1030_PID	0x3747 /* ST Micro Connect Lite STMCLT1030 */
+#define ST_STMCLT_2232_PID	0x3746
+#define ST_STMCLT_4232_PID	0x3747
 
 /*
  * Papouch products (http://www.papouch.com/)
-- 
1.7.10.4



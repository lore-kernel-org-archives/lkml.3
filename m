Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbaFIWye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:54:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934284AbaFIWqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 28/40] USB: ftdi_sio: add NovaTech OrionLXm product ID
Date: Mon,  9 Jun 2014 15:48:59 -0700
Message-Id: <20140609224840.105310967@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George McCollister <george.mccollister@gmail.com>

commit d0839d757e6294921c31b1c4ca4f1dcc5df63bcd upstream.

The NovaTech OrionLXm uses an onboard FTDI serial converter for JTAG and
console access.

Here is the lsusb output:
Bus 004 Device 123: ID 0403:7c90 Future Technology Devices
International, Ltd

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -583,6 +583,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_TAVIR_STK500_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TIAO_UMPA_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_NT_ORIONLXM_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	/*
 	 * ELV devices:
 	 */
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -538,6 +538,11 @@
  */
 #define FTDI_TIAO_UMPA_PID	0x8a98	/* TIAO/DIYGADGET USB Multi-Protocol Adapter */
 
+/*
+ * NovaTech product ids (FTDI_VID)
+ */
+#define FTDI_NT_ORIONLXM_PID	0x7c90	/* OrionLXm Substation Automation Platform */
+
 
 /********************************/
 /** third-party VID/PID combos **/



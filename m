Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaGHTRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:17:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54338 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "George McCollister" <george.mccollister@gmail.com>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.971342823@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 040/125] USB: ftdi_sio: add NovaTech OrionLXm product ID
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 5 +++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -591,6 +591,8 @@ static struct usb_device_id id_table_com
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


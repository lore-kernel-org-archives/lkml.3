Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966379AbaLLGxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:53:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965978AbaLLGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:15 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Frans Klaver" <frans.klaver@xsens.com>,
        "Johan Hovold" <johan@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.919250263@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 070/164] usb: serial: ftdi_sio: add Awinda Station and
 Dongle products
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Frans Klaver <frans.klaver@xsens.com>

commit edd74ffab1f6909eee400c7de8ce621870aacac9 upstream.

Add new IDs for the Xsens Awinda Station and Awinda Dongle.

While at it, order the definitions by PID and add a logical separation
between devices using Xsens' VID and those using FTDI's VID.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -685,6 +685,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -143,8 +143,12 @@
  * Xsens Technologies BV products (http://www.xsens.com).
  */
 #define XSENS_VID		0x2639
-#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+#define XSENS_AWINDA_STATION_PID 0x0101
+#define XSENS_AWINDA_DONGLE_PID 0x0102
 #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
+#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+
+/* Xsens devices using FTDI VID */
 #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
 #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
 #define XSENS_CONVERTER_2_PID	0xD38A


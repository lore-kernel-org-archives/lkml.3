Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaIKMlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:41:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51666 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Patrick Riphagen" <patrick.riphagen@xsens.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Frans Klaver" <frans.klaver@xsens.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.163751165@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 046/131] USB: serial: ftdi_sio: Add support for new
 Xsens devices
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Riphagen <patrick.riphagen@xsens.com>

commit 4bdcde358b4bda74e356841d351945ca3f2245dd upstream.

This adds support for new Xsens devices, using Xsens' own Vendor ID.

Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 3 +++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -684,6 +684,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
 	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACTIVE_ROBOTS_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -140,6 +140,9 @@
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */
+#define XSENS_VID		0x2639
+#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+#define XSENS_MTW_PID		0x0200	/* Xsens MTw */
 #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
 #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
 #define XSENS_CONVERTER_2_PID	0xD38A


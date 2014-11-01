Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaKAXEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:04:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60019 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "=?UTF-8?q?Bj=C3=B8rn=20Mork?=" <bjorn@mork.no>,
        "Johan Hovold" <johan@kernel.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.85373458@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 016/102] USB: sierra: avoid CDC class functions on
 "68A3" devices
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 049255f51644c1105775af228396d187402a5934 upstream.

Sierra Wireless Direct IP devices using the 68A3 product ID
can be configured for modes including a CDC ECM class function.
The known example uses interface numbers 12 and 13 for the ECM
control and data interfaces respectively, consistent with CDC
MBIM function interface numbering on other Sierra devices.

It seems cleaner to restrict this driver to the ff/ff/ff
vendor specific interfaces rather than increasing the already
long interface number blacklist.  This should be more future
proof if Sierra adds more class functions using interface
numbers not yet in the blacklist.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -296,14 +296,16 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1199, 0x68A2),   /* Sierra Wireless MC77xx in QMI mode */
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-	{ USB_DEVICE(0x1199, 0x68A3), 	/* Sierra Wireless Direct IP modems */
+	/* Sierra Wireless Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68A3, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	/* AT&T Direct IP LTE modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
-	{ USB_DEVICE(0x0f3d, 0x68A3), 	/* Airprime/Sierra Wireless Direct IP modems */
+	/* Airprime/Sierra Wireless Direct IP modems */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68A3, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 


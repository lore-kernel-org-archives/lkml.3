Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaK0Iqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:41293 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbaK0Iqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:38 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 17/91] USB: sierra: avoid CDC class functions on "68A3" devices
Date: Thu, 27 Nov 2014 16:42:00 +0800
Message-Id: <1417077794-9299-17-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/sierra.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index bd79d68..64df565 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -296,14 +296,16 @@ static const struct usb_device_id id_table[] = {
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
 
-- 
1.9.1


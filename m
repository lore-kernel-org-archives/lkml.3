Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbaGRNa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:30:29 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17836 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161131AbaGRNPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/170] USB: option: add device ID for SpeedUp SU9800 usb 3g modem
Date: Fri, 18 Jul 2014 14:11:11 +0200
Message-Id: <245fbe911b4a92eb631ed77519cf8935665c7544.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1cab4c68e339086cdaff7535848e878e8f261fca upstream.

Reported by Alif Mubarak Ahmad:

This device vendor and product id is 1c9e:9800
It is working as serial interface with generic usbserial driver.
I thought it is more suitable to use usbserial option driver, which has
better capability distinguishing between modem serial interface and
micro sd storage interface.

[ johan: style changes ]

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Tested-by: Alif Mubarak Ahmad <alive4ever@live.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 70ede84f4f6b..909bb77544b5 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -352,6 +352,9 @@ static void option_instat_callback(struct urb *urb);
 /* Zoom */
 #define ZOOM_PRODUCT_4597			0x9607
 
+/* SpeedUp SU9800 usb 3g modem */
+#define SPEEDUP_PRODUCT_SU9800			0x9800
+
 /* Haier products */
 #define HAIER_VENDOR_ID				0x201e
 #define HAIER_PRODUCT_CE100			0x2009
@@ -1577,6 +1580,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
   	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
   	},
+	{ USB_DEVICE_INTERFACE_CLASS(LONGCHEER_VENDOR_ID, SPEEDUP_PRODUCT_SU9800, 0xff) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
-- 
2.0.0


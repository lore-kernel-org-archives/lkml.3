Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbaHHVdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:33:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaHHUrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>, Johan Hovold <johan@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 025/259] USB: option: add device ID for SpeedUp SU9800 usb 3g modem
Date: Fri,  8 Aug 2014 13:37:28 -0700
Message-Id: <1407530482-4483-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 948a19f..407396d 100644
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
1.9.1


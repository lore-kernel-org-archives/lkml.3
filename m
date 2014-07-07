Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaGGXzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:55:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaGGXzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>,
        Alif Mubarak Ahmad <alive4ever@live.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 07/53] USB: option: add device ID for SpeedUp SU9800 usb 3g modem
Date: Mon,  7 Jul 2014 16:57:52 -0700
Message-Id: <20140707235829.499661890@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -352,6 +352,9 @@ static void option_instat_callback(struc
 /* Zoom */
 #define ZOOM_PRODUCT_4597			0x9607
 
+/* SpeedUp SU9800 usb 3g modem */
+#define SPEEDUP_PRODUCT_SU9800			0x9800
+
 /* Haier products */
 #define HAIER_VENDOR_ID				0x201e
 #define HAIER_PRODUCT_CE100			0x2009
@@ -1577,6 +1580,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
   	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
   	},
+	{ USB_DEVICE_INTERFACE_CLASS(LONGCHEER_VENDOR_ID, SPEEDUP_PRODUCT_SU9800, 0xff) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },



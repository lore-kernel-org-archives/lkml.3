Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbaE2OJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:09:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59411 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933301AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Ulbricht <michael.ulbricht@systec-electronic.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Oliver Neukum <oliver@neukum.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 036/103] USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver
Date: Thu, 29 May 2014 15:48:21 +0200
Message-Id: <d9fede04483fa9e0f383403db0bb318f12bda3ea.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ulbricht <michael.ulbricht@systec-electronic.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 895d240d1db0b2736d779200788e4c4aea28a0c6 upstream.

By specifying NO_UNION_NORMAL the ACM driver does only use the first two
USB interfaces (modem data & control). The AT Port, Diagnostic and NMEA
interfaces are left to the USB serial driver.

Signed-off-by: Michael Ulbricht <michael.ulbricht@systec-electronic.com>
Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e8404319ca68..0b5e381bcbe6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1560,13 +1560,27 @@ static const struct usb_device_id acm_ids[] = {
 	},
 	/* Motorola H24 HSPA module: */
 	{ USB_DEVICE(0x22b8, 0x2d91) }, /* modem                                */
-	{ USB_DEVICE(0x22b8, 0x2d92) }, /* modem           + diagnostics        */
-	{ USB_DEVICE(0x22b8, 0x2d93) }, /* modem + AT port                      */
-	{ USB_DEVICE(0x22b8, 0x2d95) }, /* modem + AT port + diagnostics        */
-	{ USB_DEVICE(0x22b8, 0x2d96) }, /* modem                         + NMEA */
-	{ USB_DEVICE(0x22b8, 0x2d97) }, /* modem           + diagnostics + NMEA */
-	{ USB_DEVICE(0x22b8, 0x2d99) }, /* modem + AT port               + NMEA */
-	{ USB_DEVICE(0x22b8, 0x2d9a) }, /* modem + AT port + diagnostics + NMEA */
+	{ USB_DEVICE(0x22b8, 0x2d92),   /* modem           + diagnostics        */
+	.driver_info = NO_UNION_NORMAL, /* handle only modem interface          */
+	},
+	{ USB_DEVICE(0x22b8, 0x2d93),   /* modem + AT port                      */
+	.driver_info = NO_UNION_NORMAL, /* handle only modem interface          */
+	},
+	{ USB_DEVICE(0x22b8, 0x2d95),   /* modem + AT port + diagnostics        */
+	.driver_info = NO_UNION_NORMAL, /* handle only modem interface          */
+	},
+	{ USB_DEVICE(0x22b8, 0x2d96),   /* modem                         + NMEA */
+	.driver_info = NO_UNION_NORMAL, /* handle only modem interface          */
+	},
+	{ USB_DEVICE(0x22b8, 0x2d97),   /* modem           + diagnostics + NMEA */
+	.driver_info = NO_UNION_NORMAL, /* handle only modem interface          */
+	},
+	{ USB_DEVICE(0x22b8, 0x2d99),   /* modem + AT port               + NMEA */
+	.driver_info = NO_UNION_NORMAL, /* handle only modem interface          */
+	},
+	{ USB_DEVICE(0x22b8, 0x2d9a),   /* modem + AT port + diagnostics + NMEA */
+	.driver_info = NO_UNION_NORMAL, /* handle only modem interface          */
+	},
 
 	{ USB_DEVICE(0x0572, 0x1329), /* Hummingbird huc56s (Conexant) */
 	.driver_info = NO_UNION_NORMAL, /* union descriptor misplaced on
-- 
1.9.3


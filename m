Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbaFQQPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:15:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50379 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629AbaFQQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Ulbricht <michael.ulbricht@systec-electronic.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 018/121] USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver
Date: Tue, 17 Jun 2014 09:13:31 -0700
Message-Id: <1403021714-16320-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ulbricht <michael.ulbricht@systec-electronic.com>

commit 895d240d1db0b2736d779200788e4c4aea28a0c6 upstream.

By specifying NO_UNION_NORMAL the ACM driver does only use the first two
USB interfaces (modem data & control). The AT Port, Diagnostic and NMEA
interfaces are left to the USB serial driver.

Signed-off-by: Michael Ulbricht <michael.ulbricht@systec-electronic.com>
Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index c4564e3..f12fed0 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1587,13 +1587,27 @@ static const struct usb_device_id acm_ids[] = {
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
1.9.1


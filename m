Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaFEETr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:19:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaFEETl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ulbricht <michael.ulbricht@systec-electronic.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 3.4 003/214] USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver
Date: Wed,  4 Jun 2014 21:16:06 -0700
Message-Id: <20140605041640.160516665@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/class/cdc-acm.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1587,13 +1587,27 @@ static const struct usb_device_id acm_id
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



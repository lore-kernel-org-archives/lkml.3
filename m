Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaFJT56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:57:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbaFJTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Ulbricht <michael.ulbricht@systec-electronic.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 031/160] USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver
Date: Tue, 10 Jun 2014 12:44:31 -0700
Message-Id: <1402429600-20477-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
index e840431..0b5e381 100644
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
1.9.1


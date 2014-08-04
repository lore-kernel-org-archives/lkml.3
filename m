Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaHDBuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 21:50:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43062 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaHDBuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 21:50:07 -0400
From: Vincent Elger Zwanenburg <vincentezw@gmail.com>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com
Cc: ath9k-devel@qca.qualcomm.com, marcel@holtmann.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] drivers/bluetooth/: Toshiba Qualcomm AR9565 (ath3k) bluetooth fix
Date: Mon, 04 Aug 2014 02:49:57 +0100
Message-ID: <2264904.tEpMTWnAtp@venture>
User-Agent: KMail/4.13.2 (Linux/3.16.0-031600rc7-generic; KDE/4.13.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Vincent Elger Zwanenburg <vincentz@topmail.ie>
Date:   Mon Aug 4 01:34:27 2014 +0100

Fixes bluetooth support on Toshiba C55-B-138 notebooks by 1) adding an ignore 
line into btusb.c for its PID/VID combination and 2) assigning the VID/PID 
combination in ath3k.c to load the BTUSB_ATH3012 driver.

Signed-off-by: Vincent Elger Zwanenburg <vincentz@topmail.ie>
---
diff -uprN -X linux-3.16-rc7-vanilla/Documentation/dontdiff linux-3.16-rc7-
vanilla/drivers/bluetooth/ath3k.c /usr/src/linux-
mine/drivers/bluetooth/ath3k.c
--- linux-3.16-rc7-vanilla/drivers/bluetooth/ath3k.c	2014-07-27 
20:41:55.000000000 +0100
+++ /usr/src/linux-mine/drivers/bluetooth/ath3k.c	2014-08-03 
04:24:37.449746557 +0100
@@ -75,6 +75,7 @@ static const struct usb_device_id ath3k_
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0489, 0xe04d) },
 	{ USB_DEVICE(0x0489, 0xe04e) },
+	{ USB_DEVICE(0x0930, 0x0227) },
 	{ USB_DEVICE(0x0489, 0xe057) },
 	{ USB_DEVICE(0x0489, 0xe056) },
 	{ USB_DEVICE(0x0489, 0xe05f) },
@@ -123,6 +124,7 @@ static const struct usb_device_id ath3k_
 
 	/* Atheros AR3012 with sflash firmware*/
 	{ USB_DEVICE(0x0489, 0xe04e), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0227), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe04d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe056), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0489, 0xe057), .driver_info = BTUSB_ATH3012 },
diff -uprN -X linux-3.16-rc7-vanilla/Documentation/dontdiff linux-3.16-rc7-
vanilla/drivers/bluetooth/btusb.c /usr/src/linux-
mine/drivers/bluetooth/btusb.c
--- linux-3.16-rc7-vanilla/drivers/bluetooth/btusb.c	2014-07-27 
20:41:55.000000000 +0100
+++ /usr/src/linux-mine/drivers/bluetooth/btusb.c	2014-08-03 
04:12:09.386738905 +0100
@@ -158,6 +158,7 @@ static const struct usb_device_id blackl
 	{ USB_DEVICE(0x04ca, 0x3008), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x300b), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x0930, 0x0227), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0220), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0b05, 0x17d0), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0x0036), .driver_info = BTUSB_ATH3012 },


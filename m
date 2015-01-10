Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbbAJFgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:54 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:47986 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbbAJFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:51 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 15/25] staging: line6: Filter on Pocket POD interface
Date: Fri,  9 Jan 2015 23:36:01 -0600
Message-Id: <1420868171-2031-16-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver only supports interface 1 of the Pocket POD.  Use the device
table to filter on this.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index e97e2cb..8b03bc0 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -39,7 +39,7 @@ static const struct usb_device_id line6_id_table[] = {
 	{ LINE6_DEVICE(0x4642),    .driver_info = LINE6_BASSPODXTLIVE },
 	{ LINE6_DEVICE(0x4252),    .driver_info = LINE6_BASSPODXTPRO },
 	{ LINE6_DEVICE(0x4750),    .driver_info = LINE6_GUITARPORT },
-	{ LINE6_DEVICE(0x5051),    .driver_info = LINE6_POCKETPOD },
+	{ LINE6_IF_NUM(0x5051, 1), .driver_info = LINE6_POCKETPOD },
 	{ LINE6_DEVICE(0x5057),    .driver_info = LINE6_PODHD300 },
 	{ LINE6_DEVICE(0x5058),    .driver_info = LINE6_PODHD400 },
 	{ LINE6_IF_NUM(0x414D, 0), .driver_info = LINE6_PODHD500_0 },
@@ -738,15 +738,7 @@ static int line6_probe(struct usb_interface *interface,
 		break;
 
 	case LINE6_POCKETPOD:
-		switch (interface_number) {
-		case 0:
-			return -ENODEV;	/* this interface has no endpoints */
-		case 1:
-			alternate = 0;
-			break;
-		default:
-			MISSING_CASE;
-		}
+		alternate = 0;
 		break;
 
 	case LINE6_PODHD500_0:
-- 
2.1.0


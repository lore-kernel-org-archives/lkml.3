Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbbAJFja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:39:30 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64989 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbbAJFgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:53 -0500
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
Subject: [PATCH 16/25] staging: line6: Filter on UX2 interfaces
Date: Fri,  9 Jan 2015 23:36:02 -0600
Message-Id: <1420868171-2031-17-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver only supports interface 0 of the TonePort UX2 and POD Studio
UX2 devices.  Use the device table to filter on this.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 8b03bc0..f04ff80 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -46,14 +46,14 @@ static const struct usb_device_id line6_id_table[] = {
 	{ LINE6_IF_NUM(0x414D, 1), .driver_info = LINE6_PODHD500_1 },
 	{ LINE6_DEVICE(0x4153),    .driver_info = LINE6_PODSTUDIO_GX },
 	{ LINE6_DEVICE(0x4150),    .driver_info = LINE6_PODSTUDIO_UX1 },
-	{ LINE6_DEVICE(0x4151),    .driver_info = LINE6_PODSTUDIO_UX2 },
+	{ LINE6_IF_NUM(0x4151, 0), .driver_info = LINE6_PODSTUDIO_UX2 },
 	{ LINE6_DEVICE(0x5044),    .driver_info = LINE6_PODXT },
 	{ LINE6_IF_NUM(0x4650, 0), .driver_info = LINE6_PODXTLIVE_POD },
 	{ LINE6_IF_NUM(0x4650, 1), .driver_info = LINE6_PODXTLIVE_VARIAX },
 	{ LINE6_DEVICE(0x5050),    .driver_info = LINE6_PODXTPRO },
 	{ LINE6_DEVICE(0x4147),    .driver_info = LINE6_TONEPORT_GX },
 	{ LINE6_DEVICE(0x4141),    .driver_info = LINE6_TONEPORT_UX1 },
-	{ LINE6_DEVICE(0x4142),    .driver_info = LINE6_TONEPORT_UX2 },
+	{ LINE6_IF_NUM(0x4142, 0), .driver_info = LINE6_TONEPORT_UX2 },
 	{ LINE6_DEVICE(0x534d),    .driver_info = LINE6_VARIAX },
 	{}
 };
@@ -768,20 +768,8 @@ static int line6_probe(struct usb_interface *interface,
 
 	case LINE6_TONEPORT_UX2:
 	case LINE6_PODSTUDIO_UX2:
-		switch (interface_number) {
-		case 0:
-			/* defaults to 44.1kHz, 16-bit */
-			alternate = 2;
-			break;
-		case 1:
-			/* don't know yet what this is ...
-			   alternate = 1;
-			   break;
-			 */
-			return -ENODEV;
-		default:
-			MISSING_CASE;
-		}
+		/* defaults to 44.1kHz, 16-bit */
+		alternate = 2;
 		break;
 
 	default:
-- 
2.1.0


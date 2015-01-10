Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbbAJFgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:36:46 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:40462 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbbAJFgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:35 -0500
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
Subject: [PATCH 05/25] staging: line6: Define a device type enum
Date: Fri,  9 Jan 2015 23:35:51 -0600
Message-Id: <1420868171-2031-6-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define an enum containing the supported devices and associate each entry
in the device table to the respective value.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 54 ++++++++++++++++++++++++++++--------------
 drivers/staging/line6/driver.h | 21 ++++++++++++++++
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index a263bce..2797e41 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -34,24 +34,42 @@
 
 /* table of devices that work with this driver */
 static const struct usb_device_id line6_id_table[] = {
-	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXT) },
-	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTLIVE) },
-	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTPRO) },
-	{ LINE6_DEVICE(LINE6_DEVID_GUITARPORT) },
-	{ LINE6_DEVICE(LINE6_DEVID_POCKETPOD) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODHD300) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODHD400) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODHD500) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_GX) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX1) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX2) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODXT) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODXTLIVE) },
-	{ LINE6_DEVICE(LINE6_DEVID_PODXTPRO) },
-	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_GX) },
-	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX1) },
-	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX2) },
-	{ LINE6_DEVICE(LINE6_DEVID_VARIAX) },
+	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXT),
+		.driver_info = LINE6_BASSPODXT },
+	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTLIVE),
+		.driver_info = LINE6_BASSPODXTLIVE },
+	{ LINE6_DEVICE(LINE6_DEVID_BASSPODXTPRO),
+		.driver_info = LINE6_BASSPODXTPRO },
+	{ LINE6_DEVICE(LINE6_DEVID_GUITARPORT),
+		.driver_info = LINE6_GUITARPORT },
+	{ LINE6_DEVICE(LINE6_DEVID_POCKETPOD),
+		.driver_info = LINE6_POCKETPOD },
+	{ LINE6_DEVICE(LINE6_DEVID_PODHD300),
+		.driver_info = LINE6_PODHD300 },
+	{ LINE6_DEVICE(LINE6_DEVID_PODHD400),
+		.driver_info = LINE6_PODHD400 },
+	{ LINE6_DEVICE(LINE6_DEVID_PODHD500),
+		.driver_info = LINE6_PODHD500 },
+	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_GX),
+		.driver_info = LINE6_PODSTUDIO_GX },
+	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX1),
+		.driver_info = LINE6_PODSTUDIO_UX1 },
+	{ LINE6_DEVICE(LINE6_DEVID_PODSTUDIO_UX2),
+		.driver_info = LINE6_PODSTUDIO_UX2 },
+	{ LINE6_DEVICE(LINE6_DEVID_PODXT),
+		.driver_info = LINE6_PODXT },
+	{ LINE6_DEVICE(LINE6_DEVID_PODXTLIVE),
+		.driver_info = LINE6_PODXTLIVE },
+	{ LINE6_DEVICE(LINE6_DEVID_PODXTPRO),
+		.driver_info = LINE6_PODXTPRO },
+	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_GX),
+		.driver_info = LINE6_TONEPORT_GX },
+	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX1),
+		.driver_info = LINE6_TONEPORT_UX1 },
+	{ LINE6_DEVICE(LINE6_DEVID_TONEPORT_UX2),
+		.driver_info = LINE6_TONEPORT_UX2 },
+	{ LINE6_DEVICE(LINE6_DEVID_VARIAX),
+		.driver_info = LINE6_VARIAX },
 	{}
 };
 
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 1cc7532..8fb4a9c 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -20,6 +20,27 @@
 
 #define DRIVER_NAME "line6usb"
 
+enum line6_device_type {
+	LINE6_BASSPODXT,
+	LINE6_BASSPODXTLIVE,
+	LINE6_BASSPODXTPRO,
+	LINE6_GUITARPORT,
+	LINE6_POCKETPOD,
+	LINE6_PODHD300,
+	LINE6_PODHD400,
+	LINE6_PODHD500,
+	LINE6_PODSTUDIO_GX,
+	LINE6_PODSTUDIO_UX1,
+	LINE6_PODSTUDIO_UX2,
+	LINE6_PODXT,
+	LINE6_PODXTLIVE,
+	LINE6_PODXTPRO,
+	LINE6_TONEPORT_GX,
+	LINE6_TONEPORT_UX1,
+	LINE6_TONEPORT_UX2,
+	LINE6_VARIAX
+};
+
 #define LINE6_TIMEOUT 1
 #define LINE6_BUFSIZE_LISTEN 32
 #define LINE6_MESSAGE_MAXLEN 256
-- 
2.1.0


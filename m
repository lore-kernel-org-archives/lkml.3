Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3IANZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 09:25:51 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:46170 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3IANZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 09:25:50 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArVuAEQ/I1JV5qu1PGdsb2JhbABagwYBiGelCoxihhKBDYEeFwMBAQEBODWDARMBDxgRWRgKGhOHcAMTr2gNiWgWjHmCcIQkA5QbgXGIKIV4iFE6
X-IronPort-AV: E=Sophos;i="4.89,1001,1367964000"; 
   d="scan'208";a="607455429"
From: Henrik Rydberg <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] HID: Correct the USB IDs for the new Macbook Air 6
Date: Sun,  1 Sep 2013 15:31:44 +0200
Message-Id: <1378042304-1400-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent patch (9d9a04ee) added support for the new machine, but got
the sequence of USB ids wrong. Reports from both Ian and Linus T show
that the 0x0291 id is for ISO, not ANSI, which should have the missing
number 0x0290. This patchs moves the three numbers accordingly, fixing
the problem.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reported-and-tested-by: Ian Munsie <darkstarsword@gmail.com>
Tested-by: Linus G Thiel <linus@hanssonlarsson.se>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Jiri, Dmitry,

it looks like this change has been sufficiently tested now, in
addition to making perfect sense. Jiri, would you mind taking it, if
Dmitry approves?

The patch should go to stable as well at some point, but the new order
makes me not dare adding a Cc... ;-)

Cheers,
Henrik

 drivers/hid/hid-ids.h         | 6 +++---
 drivers/input/mouse/bcm5974.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ffe4c7a..0b7ac21 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -135,9 +135,9 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI  0x0255
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO   0x0256
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0290
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0291
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0292
 #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
 #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
 #define USB_DEVICE_ID_APPLE_IRCONTROL	0x8240
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 4ef4d5e..a73f961 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -89,9 +89,9 @@
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO	0x025a
 #define USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS	0x025b
 /* MacbookAir6,2 (unibody, June 2013) */
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
-#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0290
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0291
+#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0292
 
 #define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
-- 
1.8.3.4


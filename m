Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbbAQXkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:40:17 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:40814 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbbAQXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:40:16 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2015 18:40:15 EST
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Jonathan Woithe <jwoithe@just42.net>, Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Karcher <karcher@physik.fu-berlin.de>
Subject: [PATCH 1/1] fujitsu-laptop: use FB_BLANK_* constants
Date: Sun, 18 Jan 2015 00:32:59 +0100
Message-Id: <1421537580-28554-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 2.1.3
X-Originating-IP: 85.25.239.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Karcher <karcher@physik.fu-berlin.de>

---
 drivers/platform/x86/fujitsu-laptop.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 7c21c1c..2a9afa2 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -64,6 +64,7 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/backlight.h>
+#include <linux/fb.h>
 #include <linux/input.h>
 #include <linux/kfifo.h>
 #include <linux/platform_device.h>
@@ -398,7 +399,7 @@ static int bl_get_brightness(struct backlight_device *b)
 static int bl_update_status(struct backlight_device *b)
 {
 	int ret;
-	if (b->props.power == 4)
+	if (b->props.power == FB_BLANK_POWERDOWN)
 		ret = call_fext_func(FUNC_BACKLIGHT, 0x1, 0x4, 0x3);
 	else
 		ret = call_fext_func(FUNC_BACKLIGHT, 0x1, 0x4, 0x0);
@@ -1139,9 +1140,9 @@ static int __init fujitsu_init(void)
 
 	if (!acpi_video_backlight_support()) {
 		if (call_fext_func(FUNC_BACKLIGHT, 0x2, 0x4, 0x0) == 3)
-			fujitsu->bl_device->props.power = 4;
+			fujitsu->bl_device->props.power = FB_BLANK_POWERDOWN;
 		else
-			fujitsu->bl_device->props.power = 0;
+			fujitsu->bl_device->props.power = FB_BLANK_UNBLANK;
 	}
 
 	pr_info("driver " FUJITSU_DRIVER_VERSION " successfully loaded\n");
-- 
2.1.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbbART3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 14:29:35 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:33299 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347AbbART3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 14:29:33 -0500
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Jonathan Woithe <jwoithe@just42.net>, Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] fujitsu-laptop: use FB_BLANK_* constants
Date: Sun, 18 Jan 2015 20:28:46 +0100
Message-Id: <1421609326-3610-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <0150118191421.GJ56582@vmdeb7>
References: <0150118191421.GJ56582@vmdeb7>
X-Originating-IP: 92.204.32.193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the magic numbers in fujitsu-laptop.c by the appropriate FB_BLANK
constants, as indicated by the comment for backlight_properties.power in
include/linux/backlight.h.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
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


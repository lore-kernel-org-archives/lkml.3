Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab3C3NB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:01:57 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:62632 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3C3NB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:01:56 -0400
From: Artem Savkov <artem.savkov@gmail.com>
To: dannybaumann@web.de
Cc: aaron.lu@intel.com, rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] acpi/video: lcd_get_level_current doen't return current level
Date: Sat, 30 Mar 2013 17:01:41 +0400
Message-Id: <1364648501-5127-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_video_device_lcd_get_level_current() called acpi_video_bqc_value_to_level()
with "*level" as a second argument, resulting in level being returned based on
initial input, not current brightness, breaking backlight controls.

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/acpi/video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 3cdd047..68a777b 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -505,7 +505,8 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 				return 0;
 			}
 
-			*level = acpi_video_bqc_value_to_level(device, *level);
+			*level = acpi_video_bqc_value_to_level(device,
+					device->brightness->curr);
 
 			for (i = 2; i < device->brightness->count; i++)
 				if (device->brightness->levels[i] == *level) {
-- 
1.8.2


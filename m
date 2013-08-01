Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3HAXrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:47:51 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:65353 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3HAXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:47:46 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 3/3] acpi: video: remove unnecessary casting
Date: Thu,  1 Aug 2013 18:44:01 -0500
Message-Id: <1375400641-1694-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
References: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/video.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index b07573f..11bafbe 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -236,8 +236,7 @@ static int acpi_video_get_brightness(struct backlight_device *bd)
 {
 	unsigned long long cur_level;
 	int i;
-	struct acpi_video_device *vd =
-		(struct acpi_video_device *)bl_get_data(bd);
+	struct acpi_video_device *vd = bl_get_data(bd);
 
 	if (acpi_video_device_lcd_get_level_current(vd, &cur_level, false))
 		return -EINVAL;
@@ -255,8 +254,7 @@ static int acpi_video_get_brightness(struct backlight_device *bd)
 static int acpi_video_set_brightness(struct backlight_device *bd)
 {
 	int request_level = bd->props.brightness + 2;
-	struct acpi_video_device *vd =
-		(struct acpi_video_device *)bl_get_data(bd);
+	struct acpi_video_device *vd = bl_get_data(bd);
 
 	return acpi_video_device_lcd_set_level(vd,
 				vd->brightness->levels[request_level]);
-- 
1.8.3.4


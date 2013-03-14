Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3CNKew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:34:52 -0400
Received: from mout.web.de ([212.227.17.11]:58818 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab3CNKes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:34:48 -0400
From: Danny Baumann <dannybaumann@web.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH 2/3] ACPI video: Make logic a little easier to understand.
Date: Thu, 14 Mar 2013 11:34:23 +0100
Message-Id: <1363257264-15984-3-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363257264-15984-1-git-send-email-dannybaumann@web.de>
References: <1363257264-15984-1-git-send-email-dannybaumann@web.de>
X-Provags-ID: V02:K0:/QVIGxPIgUsq/TojMW3JggHhj4jF3V5AGcpKUVmvtV4
 gwzXPfxAbX4+U676p76MWytPuH6sUObc1LCN0vp9RIkpltp4s/
 Y/ZspMXcAt/Gytu75DCPFGX275M11yL9l5k+T4XHLS9498RS87
 hO5Yh0exgIE6m1Fd4ht84VDURHrsnCbr0Av+DwbplYzPRG+TaZ
 8blQXGKDs9FUoNMOoNMPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make code paths a little easier to follow, and don't needlessly continue
list iteration.
---
 drivers/acpi/video.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index ef85574..d0fade7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -736,16 +736,17 @@ acpi_video_init_brightness(struct acpi_video_device *device)
 		 */
 		if (use_bios_initial_backlight) {
 			for (i = 2; i < br->count; i++)
-				if (level_old == br->levels[i])
+				if (level_old == br->levels[i]) {
 					level = level_old;
+					break;
+				}
 		}
-		goto set_level;
+	} else {
+		if (br->flags._BCL_reversed)
+			level_old = (br->count - 1) - level_old;
+		level = br->levels[level_old];
 	}
 
-	if (br->flags._BCL_reversed)
-		level_old = (br->count - 1) - level_old;
-	level = br->levels[level_old];
-
 set_level:
 	result = acpi_video_device_lcd_set_level(device, level);
 	if (result)
-- 
1.8.1.4


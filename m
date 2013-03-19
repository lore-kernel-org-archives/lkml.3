Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3CSQXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:23:12 -0400
Received: from mout.web.de ([212.227.15.3]:59710 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730Ab3CSQXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:23:09 -0400
From: Danny Baumann <dannybaumann@web.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH v4 2/3] ACPI video: Make logic a little easier to understand.
Date: Tue, 19 Mar 2013 17:22:51 +0100
Message-Id: <1363710172-2906-2-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363710172-2906-1-git-send-email-dannybaumann@web.de>
References: <1363710172-2906-1-git-send-email-dannybaumann@web.de>
X-Provags-ID: V02:K0:/UKS34jO6VYOmNTF8mn6ZUpBZsYlJO2rwOKsMndvhgj
 ic3BZ2hwD0YTNkYEKRbv3HQJST/n7BBb9nmblZDzNneBKwEwIy
 D2NggM3sc1yxRSq9pkdWwo/lAGcBnMdZHrdUx5N9zCP5U80xn2
 FUsMWpRlFzLi4OJoJpnIYEgIi0Pjert0X3SYQr1qBRNOOsBnzu
 SgMZJvlf/1joKp/MEbHkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make code paths a little easier to follow, and don't needlessly continue
list iteration.

Signed-off-by: Danny Baumann <dannybaumann@web.de>
---
 drivers/acpi/video.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 09e4722..89bf61e 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -737,16 +737,17 @@ acpi_video_init_brightness(struct acpi_video_device *device)
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


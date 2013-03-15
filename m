Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3COKLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:11:19 -0400
Received: from mout.web.de ([212.227.15.3]:58467 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab3COKLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:11:17 -0400
From: Danny Baumann <dannybaumann@web.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Danny Baumann <dannybaumann@web.de>
Subject: [PATCH v2 2/3] ACPI video: Make logic a little easier to understand.
Date: Fri, 15 Mar 2013 11:10:47 +0100
Message-Id: <1363342248-6496-2-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363342248-6496-1-git-send-email-dannybaumann@web.de>
References: <1363342248-6496-1-git-send-email-dannybaumann@web.de>
X-Provags-ID: V02:K0:nxRLp09iohu03PGjgnBWHVoSPgaPjxWOwH4m5+yYHCu
 YKOAqwSGD4zGPJFXDG7WhEb7JyiMA9Ho9z7iZVhG63syQhh4wQ
 EpaDjMSCRcJ7RxIMzqXDHh4DEhEvDdbacRlNKygXMC0TBgfRrD
 YudhKHZ1PshJ+bP7aHNhut2M1pqQ02Nx1XiCj67KieGZhIiDck
 qf0y5JzCNYZJx0Ku6aK9w==
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
index 9c33871..5ef329a 100644
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


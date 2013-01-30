Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3A3GTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:19:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15292 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3A3GTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:19:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Jan 2013 22:17:37 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Purdie <rpurdie@rpsys.net>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] pwm-backlight: handle BL_CORE_FBBLANK state
Date: Wed, 30 Jan 2013 15:19:15 +0900
Message-ID: <1359526755-21145-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to include/linux/backlight.h, the fb_blank field is to be
removed and blank status should preferably be set by setting the
BL_CORE_FBBLANK bit of the state field. This patch ensures this
condition is also taken into account when updating the backlight state.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/video/backlight/pwm_bl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 069983c..4af6d13 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -41,10 +41,9 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 	int brightness = bl->props.brightness;
 	int max = bl->props.max_brightness;
 
-	if (bl->props.power != FB_BLANK_UNBLANK)
-		brightness = 0;
-
-	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
+	if (bl->props.power != FB_BLANK_UNBLANK ||
+	    bl->props.fb_blank != FB_BLANK_UNBLANK ||
+	    bl->props.state & BL_CORE_FBBLANK)
 		brightness = 0;
 
 	if (pb->notify)
-- 
1.8.1.2


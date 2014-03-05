Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaCEIUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:20:14 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34565 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaCEIUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:20:11 -0500
From: jon@ringle.org
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH] video: da8xx-fb: Fix casting of info->pseudo_palette
Date: Wed,  5 Mar 2014 03:19:59 -0500
Message-Id: <1394007599-31429-1-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Ringle <jringle@gridpoint.com>

(Resending without corporate disclaimer in email footer)

The casting to (u16 *) on info->pseudo_palette is wrong and causes the
display to show a blue (garbage) vertical line on every other pixel column

Signed-off-by: Jon Ringle <jringle@gridpoint.com>
---
 drivers/video/da8xx-fb.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index d042624..83c43b2 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -678,15 +678,7 @@ static int fb_setcolreg(unsigned regno, unsigned red, unsigned green,
 			(green << info->var.green.offset) |
 			(blue << info->var.blue.offset);
 
-		switch (info->var.bits_per_pixel) {
-		case 16:
-			((u16 *) (info->pseudo_palette))[regno] = v;
-			break;
-		case 24:
-		case 32:
-			((u32 *) (info->pseudo_palette))[regno] = v;
-			break;
-		}
+		((u32 *) (info->pseudo_palette))[regno] = v;
 		if (palette[0] != 0x4000) {
 			update_hw = 1;
 			palette[0] = 0x4000;
-- 
1.8.5.4


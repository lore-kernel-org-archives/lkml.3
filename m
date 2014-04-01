Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaDAMkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:40:12 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42253 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaDAMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:40:08 -0400
From: jon@ringle.org
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH v2 2/2] video: da8xx-fb: Fix casting of info->pseudo_palette
Date: Tue,  1 Apr 2014 08:33:05 -0400
Message-Id: <1396355585-458-2-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1396355585-458-1-git-send-email-jon@ringle.org>
References: <1396355585-458-1-git-send-email-jon@ringle.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Ringle <jringle@gridpoint.com>

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


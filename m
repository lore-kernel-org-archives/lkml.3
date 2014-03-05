Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaCEP5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:57:22 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59381 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaCEP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:57:20 -0500
Date: Wed, 5 Mar 2014 23:56:19 +0800
From: Wang YanQing <udknight@gmail.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, fengguang.wu@intel.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: uvesafb: Remove impossible code path in
 uvesafb_init_info
Message-ID: <20140305155619.GA32166@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, tomi.valkeinen@ti.com,
	plagnioj@jcrosoft.com, fengguang.wu@intel.com,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because uvesafb_vbe_init will fail when get zero avaiable modes,
and we have checked the return value of uvesafb_vbe_init_mode,
so it is impossible to pass NULL as mode into uvesafb_init_info.

[ This patch fix warning report by fengguang.wu@intel.com
  "drivers/video/fbdev/uvesafb.c:1509 uvesafb_init_info()
   error: we previously assumed 'mode' could be null" ]

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/fbdev/uvesafb.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 18352b2..509d452 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1474,12 +1474,7 @@ static void uvesafb_init_info(struct fb_info *info, struct vbe_mode_ib *mode)
 	 *                 used video mode, i.e. the minimum amount of
 	 *                 memory we need.
 	 */
-	if (mode != NULL) {
-		size_vmode = info->var.yres * mode->bytes_per_scan_line;
-	} else {
-		size_vmode = info->var.yres * info->var.xres *
-			     ((info->var.bits_per_pixel + 7) >> 3);
-	}
+	size_vmode = info->var.yres * mode->bytes_per_scan_line;
 
 	/*
 	 *   size_total -- all video memory we have. Used for mtrr
-- 
1.8.3.4.8.g69490f3.dirty

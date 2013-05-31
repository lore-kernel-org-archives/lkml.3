Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3EaO3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:29:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37565 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3EaO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:28:51 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/2] trivial: atmel_lcdfb: add missing error message
Date: Fri, 31 May 2013 16:28:38 +0200
Message-Id: <1370010519-18691-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a too small framebuffer is given, the atmel_lcdfb_check_var
silently fails.
Adding an error message will save some head scratching.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/video/atmel_lcdfb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 540909d..6e6491f 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -461,8 +461,11 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
 	if (info->fix.smem_len) {
 		unsigned int smem_len = (var->xres_virtual * var->yres_virtual
 					 * ((var->bits_per_pixel + 7) / 8));
-		if (smem_len > info->fix.smem_len)
+		if (smem_len > info->fix.smem_len) {
+			dev_err(dev, "Frame buffer is too small (%u) for screen size (need at least %u)\n",
+				info->fix.smem_len, smem_len);
 			return -EINVAL;
+		}
 	}
 
 	/* Saturate vertical and horizontal timings at maximum values */
-- 
1.7.10.4


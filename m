Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3BCVvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:51:25 -0500
Received: from mout.gmx.net ([212.227.17.21]:56248 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3BCVvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:23 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/tGFJSTPTtuLFe3pDu3iJ2TiYCWoJdmHUPp5/tMf
	vLjhZavi63jLdx
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] staging/xgifb: Remove always false comparisons
Date: Sun,  3 Feb 2013 22:54:31 +0100
Message-Id: <1359928479-8484-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some comparisons that always evaluate to false since
xoffset and yoffset are defined as __u32 in fb_var_screeninfo in
include/linux/fb.h and thus can never be negative.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ca9f583..83f8a6a 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1333,12 +1333,6 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	/* Adapt RGB settings */
 	XGIfb_bpp_to_var(xgifb_info, var);
 
-	/* Sanity check for offsets */
-	if (var->xoffset < 0)
-		var->xoffset = 0;
-	if (var->yoffset < 0)
-		var->yoffset = 0;
-
 	if (!XGIfb_ypan) {
 		if (var->xres != var->xres_virtual)
 			var->xres_virtual = var->xres;
@@ -1373,8 +1367,7 @@ static int XGIfb_pan_display(struct fb_var_screeninfo *var,
 		return -EINVAL;
 
 	if (var->vmode & FB_VMODE_YWRAP) {
-		if (var->yoffset < 0 || var->yoffset >= info->var.yres_virtual
-				|| var->xoffset)
+		if (var->yoffset >= info->var.yres_virtual || var->xoffset)
 			return -EINVAL;
 	} else if (var->xoffset + info->var.xres > info->var.xres_virtual
 				|| var->yoffset + info->var.yres
-- 
1.7.8.6


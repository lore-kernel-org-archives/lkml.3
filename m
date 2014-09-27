Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaI0BLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:11:33 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55269 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaI0BLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:11:14 -0400
From: Behan Webster <behanw@converseincode.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: behanw@converseincode.com, archit@ti.com, daniel.vetter@ffwll.ch,
        geert@linux-m68k.org, laurent.pinchart@ideasonboard.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, robdclark@gmail.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] arm, fbdev, omap2, LLVMLinux: Remove nested function from omapfb
Date: Fri, 26 Sep 2014 18:10:53 -0700
Message-Id: <1411780253-4492-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
References: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the use of nested functions where a normal function will suffice.

Nested functions are not liked by upstream kernel developers in general. Their
use breaks the use of clang as a compiler, and doesn't make the code any
better.

This code now works for both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index ec2d132..1587243 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -273,16 +273,16 @@ static struct omapfb_colormode omapfb_colormodes[] = {
 	},
 };
 
+static bool cmp_component(struct fb_bitfield *f1, struct fb_bitfield *f2)
+{
+	return f1->length == f2->length &&
+		f1->offset == f2->offset &&
+		f1->msb_right == f2->msb_right;
+}
+
 static bool cmp_var_to_colormode(struct fb_var_screeninfo *var,
 		struct omapfb_colormode *color)
 {
-	bool cmp_component(struct fb_bitfield *f1, struct fb_bitfield *f2)
-	{
-		return f1->length == f2->length &&
-			f1->offset == f2->offset &&
-			f1->msb_right == f2->msb_right;
-	}
-
 	if (var->bits_per_pixel == 0 ||
 			var->red.length == 0 ||
 			var->blue.length == 0 ||
-- 
1.9.1


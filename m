Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaE0SJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:09:14 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:52087 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbaE0SJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:09:11 -0400
Message-ID: <1401214147.28714.12.camel@x220>
Subject: [PATCH] 68328fb: remove check for CONFIG_FB_68328_INVERT
From: Paul Bolle <pebolle@tiscali.nl>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 20:09:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2014 18:09:08.0227 (UTC) FILETIME=[C0D65D30:01CF79D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v2.6.7 the 68328 frame buffer driver contains a check for
CONFIG_FB_68328_INVERT. But the Kconfig symbol FB_68328_INVERT was never
added to the tree. Remove this check and do some related cleaning up.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/video/fbdev/68328fb.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/68328fb.c b/drivers/video/fbdev/68328fb.c
index 552258c8f99d..17f21cedff9b 100644
--- a/drivers/video/fbdev/68328fb.c
+++ b/drivers/video/fbdev/68328fb.c
@@ -49,12 +49,6 @@
 #error wrong architecture for the MC68x328 frame buffer device
 #endif
 
-#if defined(CONFIG_FB_68328_INVERT)
-#define MC68X328FB_MONO_VISUAL FB_VISUAL_MONO01
-#else
-#define MC68X328FB_MONO_VISUAL FB_VISUAL_MONO10
-#endif
-
 static u_long videomemory;
 static u_long videomemorysize;
 
@@ -462,7 +456,7 @@ int __init mc68x328fb_init(void)
 	fb_info.fix.line_length =
 		get_line_length(mc68x328fb_default.xres_virtual, mc68x328fb_default.bits_per_pixel);
 	fb_info.fix.visual = (mc68x328fb_default.bits_per_pixel) == 1 ?
-		MC68X328FB_MONO_VISUAL : FB_VISUAL_PSEUDOCOLOR;
+		FB_VISUAL_MONO10 : FB_VISUAL_PSEUDOCOLOR;
 	if (fb_info.var.bits_per_pixel == 1) {
 		fb_info.var.red.length = fb_info.var.green.length = fb_info.var.blue.length = 1;
 		fb_info.var.red.offset = fb_info.var.green.offset = fb_info.var.blue.offset = 0;
-- 
1.9.3


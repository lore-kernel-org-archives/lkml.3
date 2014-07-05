Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaGENIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 09:08:17 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58072 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaGENIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 09:08:15 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: vga16fb.c:  Cleaning up useless assignment of function parameter
Date: Sat,  5 Jul 2014 15:09:31 +0200
Message-Id: <1404565771-22515-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Removal of assignment of function parameter, that has no effect outside the function

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/vga16fb.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/vga16fb.c b/drivers/video/fbdev/vga16fb.c
index 283d335..d92e4fd 100644
--- a/drivers/video/fbdev/vga16fb.c
+++ b/drivers/video/fbdev/vga16fb.c
@@ -275,7 +275,6 @@ static void vga16fb_clock_chip(struct vga16fb_par *par,
 	}
 	par->misc |= best->misc;
 	par->clkdiv = best->seq_clock_mode;
-	pixclock = (best->pixclock * div) / mul;		
 }
 			       
 #define FAIL(X) return -EINVAL
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaGFSnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:43:21 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63478 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaGFSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:43:17 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Jingoo Han <jg1.han@samsung.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Marek Vasut <marex@denx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] video: fbdev: mxsfb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:44:32 +0200
Message-Id: <1404672272-19231-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/mxsfb.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/mxsfb.c b/drivers/video/fbdev/mxsfb.c
index accf48a2..d0a55c6 100644
--- a/drivers/video/fbdev/mxsfb.c
+++ b/drivers/video/fbdev/mxsfb.c
@@ -594,7 +594,6 @@ static int mxsfb_restore_mode(struct mxsfb_info *host,
 			struct fb_videomode *vmode)
 {
 	struct fb_info *fb_info = &host->fb_info;
-	unsigned line_count;
 	unsigned period;
 	unsigned long pa, fbsize;
 	int bits_per_pixel, ofs;
@@ -672,7 +671,6 @@ static int mxsfb_restore_mode(struct mxsfb_info *host,
 		writel(fb_info->fix.smem_start, host->base + host->devdata->next_buf);
 	}
 
-	line_count = fb_info->fix.smem_len / fb_info->fix.line_length;
 	fb_info->fix.ypanstep = 1;
 
 	clk_prepare_enable(host->clk);
-- 
1.7.10.4


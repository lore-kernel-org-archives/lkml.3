Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaGFS5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:57:01 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43690 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaGFS47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:56:59 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: savage: savagefb_driver.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:58:14 +0200
Message-Id: <1404673094-20329-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/savage/savagefb_driver.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/savage/savagefb_driver.c b/drivers/video/fbdev/savage/savagefb_driver.c
index 4dbf45f..5c7620e 100644
--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -951,8 +951,6 @@ static int savagefb_check_var(struct fb_var_screeninfo   *var,
 	if (memlen > vramlen) {
 		var->yres_virtual = vramlen * 8 /
 			(var->xres_virtual * var->bits_per_pixel);
-		memlen = var->xres_virtual * var->bits_per_pixel *
-			var->yres_virtual / 8;
 	}
 
 	/* we must round yres/xres down, we already rounded y/xres_virtual up
-- 
1.7.10.4


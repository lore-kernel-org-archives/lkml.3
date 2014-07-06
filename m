Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaGFSjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:39:11 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40446 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaGFSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:39:08 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Anatolij Gustschin <agust@denx.de>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] video: fbdev: mb862xx: mb862xxfbdrv.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:40:24 +0200
Message-Id: <1404672024-18891-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/mb862xx/mb862xxfbdrv.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/video/fbdev/mb862xx/mb862xxfbdrv.c b/drivers/video/fbdev/mb862xx/mb862xxfbdrv.c
index 0cd4c33..24be945 100644
--- a/drivers/video/fbdev/mb862xx/mb862xxfbdrv.c
+++ b/drivers/video/fbdev/mb862xx/mb862xxfbdrv.c
@@ -273,7 +273,6 @@ static int mb862xxfb_set_par(struct fb_info *fbi)
 static int mb862xxfb_pan(struct fb_var_screeninfo *var,
 			 struct fb_info *info)
 {
-	struct mb862xxfb_par *par = info->par;
 	unsigned long reg;
 
 	reg = pack(var->yoffset, var->xoffset);
@@ -286,7 +285,6 @@ static int mb862xxfb_pan(struct fb_var_screeninfo *var,
 
 static int mb862xxfb_blank(int mode, struct fb_info *fbi)
 {
-	struct mb862xxfb_par  *par = fbi->par;
 	unsigned long reg;
 
 	dev_dbg(fbi->dev, "blank mode=%d\n", mode);
@@ -548,7 +546,6 @@ static ssize_t mb862xxfb_show_dispregs(struct device *dev,
 				       struct device_attribute *attr, char *buf)
 {
 	struct fb_info *fbi = dev_get_drvdata(dev);
-	struct mb862xxfb_par *par = fbi->par;
 	char *ptr = buf;
 	unsigned int reg;
 
-- 
1.7.10.4


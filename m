Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaGFSkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:40:13 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39104 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaGFSkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:40:10 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: mbx: mbxfb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:41:26 +0200
Message-Id: <1404672086-18977-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/mbx/mbxfb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/mbx/mbxfb.c b/drivers/video/fbdev/mbx/mbxfb.c
index 2bd52ed..320f263 100644
--- a/drivers/video/fbdev/mbx/mbxfb.c
+++ b/drivers/video/fbdev/mbx/mbxfb.c
@@ -689,7 +689,6 @@ static struct fb_ops mbxfb_ops = {
 */
 static void setup_memc(struct fb_info *fbi)
 {
-	unsigned long tmp;
 	int i;
 
 	/* FIXME: use platform specific parameters */
@@ -714,7 +713,7 @@ static void setup_memc(struct fb_info *fbi)
 	write_reg_dly(LMPWR_MC_PWR_ACT, LMPWR);
 	/* perform dummy reads */
 	for ( i = 0; i < 16; i++ ) {
-		tmp = readl(fbi->screen_base);
+		readl(fbi->screen_base);
 	}
 }
 
-- 
1.7.10.4


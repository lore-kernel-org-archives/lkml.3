Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaGFTBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 15:01:09 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59775 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaGFTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 15:01:07 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: valkyriefb.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 21:02:22 +0200
Message-Id: <1404673342-20672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/valkyriefb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/valkyriefb.c b/drivers/video/fbdev/valkyriefb.c
index 97cb9bd..af708fe 100644
--- a/drivers/video/fbdev/valkyriefb.c
+++ b/drivers/video/fbdev/valkyriefb.c
@@ -416,18 +416,18 @@ static int read_valkyrie_sense(struct fb_info_valkyrie *p)
 
 	out_8(&p->valkyrie_regs->msense.r, 0);   /* release all lines */
 	__delay(20000);
-	sense = ((in = in_8(&p->valkyrie_regs->msense.r)) & 0x70) << 4;
+	sense = ((in_8(&p->valkyrie_regs->msense.r)) & 0x70) << 4;
 	/* drive each sense line low in turn and collect the other 2 */
 	out_8(&p->valkyrie_regs->msense.r, 4);   /* drive A low */
 	__delay(20000);
-	sense |= ((in = in_8(&p->valkyrie_regs->msense.r)) & 0x30);
+	sense |= ((in_8(&p->valkyrie_regs->msense.r)) & 0x30);
 	out_8(&p->valkyrie_regs->msense.r, 2);   /* drive B low */
 	__delay(20000);
 	sense |= ((in = in_8(&p->valkyrie_regs->msense.r)) & 0x40) >> 3;
 	sense |= (in & 0x10) >> 2;
 	out_8(&p->valkyrie_regs->msense.r, 1);   /* drive C low */
 	__delay(20000);
-	sense |= ((in = in_8(&p->valkyrie_regs->msense.r)) & 0x60) >> 5;
+	sense |= ((in_8(&p->valkyrie_regs->msense.r)) & 0x60) >> 5;
 
 	out_8(&p->valkyrie_regs->msense.r, 7);
 
-- 
1.7.10.4


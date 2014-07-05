Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbaGEMvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 08:51:08 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:63971 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaGEMvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 08:51:05 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: valkyriefb.c:  Cleaning up variable that is never used
Date: Sat,  5 Jul 2014 14:52:20 +0200
Message-Id: <1404564740-22066-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaGFSz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:55:58 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49593 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaGFSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:55:57 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: savage: savagefb.h:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:57:12 +0200
Message-Id: <1404673032-20246-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/savage/savagefb.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/savage/savagefb.h b/drivers/video/fbdev/savage/savagefb.h
index dcaab90..8ff4ab1 100644
--- a/drivers/video/fbdev/savage/savagefb.h
+++ b/drivers/video/fbdev/savage/savagefb.h
@@ -351,32 +351,26 @@ static inline void VGAwSEQ(u8 index, u8 val, struct savagefb_par *par)
 
 static inline void VGAenablePalette(struct savagefb_par *par)
 {
-	u8 tmp;
-
-	tmp = vga_in8(0x3da, par);
+	vga_in8(0x3da, par);
 	vga_out8(0x3c0, 0x00, par);
 	par->paletteEnabled = 1;
 }
 
 static inline void VGAdisablePalette(struct savagefb_par *par)
 {
-	u8 tmp;
-
-	tmp = vga_in8(0x3da, par);
+	vga_in8(0x3da, par);
 	vga_out8(0x3c0, 0x20, par);
 	par->paletteEnabled = 0;
 }
 
 static inline void VGAwATTR(u8 index, u8 value, struct savagefb_par *par)
 {
-	u8 tmp;
-
 	if (par->paletteEnabled)
 		index &= ~0x20;
 	else
 		index |= 0x20;
 
-	tmp = vga_in8(0x3da, par);
+	vga_in8(0x3da, par);
 	vga_out8(0x3c0, index, par);
 	vga_out8 (0x3c0, value, par);
 }
-- 
1.7.10.4


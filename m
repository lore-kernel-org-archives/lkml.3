Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaLKJEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:04:50 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46475 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaLKJEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:04:46 -0500
Date: Thu, 11 Dec 2014 11:04:41 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: vgastate: remove trailing whitespaces
Message-ID: <20141211090441.GA9943@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error, trailing whitespace.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/video/vgastate.c |   82 +++++++++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/video/vgastate.c b/drivers/video/vgastate.c
index b91c466..548c751 100644
--- a/drivers/video/vgastate.c
+++ b/drivers/video/vgastate.c
@@ -2,7 +2,7 @@
  * linux/drivers/video/vgastate.c -- VGA state save/restore
  *
  * Copyright 2002 James Simmons
- * 
+ *
  * Copyright history from vga16fb.c:
  *	Copyright 1999 Ben Pfaff and Petr Vandrovec
  *	Based on VGA info at http://www.goodnet.com/~tinara/FreeVGA/home.htm
@@ -10,7 +10,7 @@
  *
  * This file is subject to the terms and conditions of the GNU General
  * Public License.  See the file COPYING in the main directory of this
- * archive for more details.  
+ * archive for more details.
  *
  */
 #include <linux/module.h>
@@ -29,16 +29,16 @@ struct regstate {
 	__u8 *gfx;
 	__u8 *seq;
 	__u8 misc;
-};	
+};
 
-static inline unsigned char vga_rcrtcs(void __iomem *regbase, unsigned short iobase, 
+static inline unsigned char vga_rcrtcs(void __iomem *regbase, unsigned short iobase,
 				       unsigned char reg)
 {
 	vga_w(regbase, iobase + 0x4, reg);
 	return vga_r(regbase, iobase + 0x5);
 }
 
-static inline void vga_wcrtcs(void __iomem *regbase, unsigned short iobase, 
+static inline void vga_wcrtcs(void __iomem *regbase, unsigned short iobase,
 			      unsigned char reg, unsigned char val)
 {
 	vga_w(regbase, iobase + 0x4, reg);
@@ -71,7 +71,7 @@ static void save_vga_text(struct vgastate *state, void __iomem *fbbase)
 	gr6 = vga_rgfx(state->vgabase, VGA_GFX_MISC);
 	seq2 = vga_rseq(state->vgabase, VGA_SEQ_PLANE_WRITE);
 	seq4 = vga_rseq(state->vgabase, VGA_SEQ_MEMORY_MODE);
-	
+
 	/* blank screen */
 	seq1 = vga_rseq(state->vgabase, VGA_SEQ_CLOCK_MODE);
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
@@ -85,7 +85,7 @@ static void save_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x2);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < 4 * 8192; i++) 
+		for (i = 0; i < 4 * 8192; i++)
 			saved->vga_font0[i] = vga_r(fbbase, i);
 	}
 
@@ -96,10 +96,10 @@ static void save_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x3);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < state->memsize; i++) 
+		for (i = 0; i < state->memsize; i++)
 			saved->vga_font1[i] = vga_r(fbbase, i);
 	}
-	
+
 	/* save font at plane 0/1 */
 	if (state->flags & VGA_SAVE_TEXT) {
 		vga_wseq(state->vgabase, VGA_SEQ_PLANE_WRITE, 0x1);
@@ -107,7 +107,7 @@ static void save_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < 8192; i++) 
+		for (i = 0; i < 8192; i++)
 			saved->vga_text[i] = vga_r(fbbase, i);
 
 		vga_wseq(state->vgabase, VGA_SEQ_PLANE_WRITE, 0x2);
@@ -115,8 +115,8 @@ static void save_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x1);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < 8192; i++) 
-			saved->vga_text[8192+i] = vga_r(fbbase + 2 * 8192, i); 
+		for (i = 0; i < 8192; i++)
+			saved->vga_text[8192+i] = vga_r(fbbase + 2 * 8192, i);
 	}
 
 	/* restore regs */
@@ -151,7 +151,7 @@ static void restore_vga_text(struct vgastate *state, void __iomem *fbbase)
 	gr8 = vga_rgfx(state->vgabase, VGA_GFX_BIT_MASK);
 	seq2 = vga_rseq(state->vgabase, VGA_SEQ_PLANE_WRITE);
 	seq4 = vga_rseq(state->vgabase, VGA_SEQ_MEMORY_MODE);
-	
+
 	/* blank screen */
 	seq1 = vga_rseq(state->vgabase, VGA_SEQ_CLOCK_MODE);
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
@@ -163,7 +163,7 @@ static void restore_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_BIT_MASK, 0xff);
 		vga_wgfx(state->vgabase, VGA_GFX_SR_ENABLE, 0x00);
 	}
-	
+
 	/* restore font at plane 2 */
 	if (state->flags & VGA_SAVE_FONT0) {
 		vga_wseq(state->vgabase, VGA_SEQ_PLANE_WRITE, 0x4);
@@ -171,7 +171,7 @@ static void restore_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x2);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < 4 * 8192; i++) 
+		for (i = 0; i < 4 * 8192; i++)
 			vga_w(fbbase, i, saved->vga_font0[i]);
 	}
 
@@ -182,10 +182,10 @@ static void restore_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x3);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < state->memsize; i++) 
+		for (i = 0; i < state->memsize; i++)
 			vga_w(fbbase, i, saved->vga_font1[i]);
 	}
-	
+
 	/* restore font at plane 0/1 */
 	if (state->flags & VGA_SAVE_TEXT) {
 		vga_wseq(state->vgabase, VGA_SEQ_PLANE_WRITE, 0x1);
@@ -193,16 +193,16 @@ static void restore_vga_text(struct vgastate *state, void __iomem *fbbase)
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < 8192; i++) 
+		for (i = 0; i < 8192; i++)
 			vga_w(fbbase, i, saved->vga_text[i]);
-		
+
 		vga_wseq(state->vgabase, VGA_SEQ_PLANE_WRITE, 0x2);
 		vga_wseq(state->vgabase, VGA_SEQ_MEMORY_MODE, 0x6);
 		vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, 0x1);
 		vga_wgfx(state->vgabase, VGA_GFX_MODE, 0x0);
 		vga_wgfx(state->vgabase, VGA_GFX_MISC, 0x5);
-		for (i = 0; i < 8192; i++) 
-			vga_w(fbbase, i, saved->vga_text[8192+i]); 
+		for (i = 0; i < 8192; i++)
+			vga_w(fbbase, i, saved->vga_text[8192+i]);
 	}
 
 	/* unblank screen */
@@ -222,7 +222,7 @@ static void restore_vga_text(struct vgastate *state, void __iomem *fbbase)
 	vga_wseq(state->vgabase, VGA_SEQ_PLANE_WRITE, seq2);
 	vga_wseq(state->vgabase, VGA_SEQ_MEMORY_MODE, seq4);
 }
-			      
+
 static void save_vga_mode(struct vgastate *state)
 {
 	struct regstate *saved = (struct regstate *) state->vidstate;
@@ -235,10 +235,10 @@ static void save_vga_mode(struct vgastate *state)
 	else
 		iobase = 0x3b0;
 
-	for (i = 0; i < state->num_crtc; i++) 
+	for (i = 0; i < state->num_crtc; i++)
 		saved->crtc[i] = vga_rcrtcs(state->vgabase, iobase, i);
-	
-	vga_r(state->vgabase, iobase + 0xa); 
+
+	vga_r(state->vgabase, iobase + 0xa);
 	vga_w(state->vgabase, VGA_ATT_W, 0x00);
 	for (i = 0; i < state->num_attr; i++) {
 		vga_r(state->vgabase, iobase + 0xa);
@@ -247,10 +247,10 @@ static void save_vga_mode(struct vgastate *state)
 	vga_r(state->vgabase, iobase + 0xa);
 	vga_w(state->vgabase, VGA_ATT_W, 0x20);
 
-	for (i = 0; i < state->num_gfx; i++) 
+	for (i = 0; i < state->num_gfx; i++)
 		saved->gfx[i] = vga_rgfx(state->vgabase, i);
 
-	for (i = 0; i < state->num_seq; i++) 
+	for (i = 0; i < state->num_seq; i++)
 		saved->seq[i] = vga_rseq(state->vgabase, i);
 }
 
@@ -268,26 +268,26 @@ static void restore_vga_mode(struct vgastate *state)
 		iobase = 0x3b0;
 
 	/* turn off display */
-	vga_wseq(state->vgabase, VGA_SEQ_CLOCK_MODE, 
+	vga_wseq(state->vgabase, VGA_SEQ_CLOCK_MODE,
 		 saved->seq[VGA_SEQ_CLOCK_MODE] | 0x20);
 
 	/* disable sequencer */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x01);
-	
+
 	/* enable palette addressing */
 	vga_r(state->vgabase, iobase + 0xa);
 	vga_w(state->vgabase, VGA_ATT_W, 0x00);
 
-	for (i = 2; i < state->num_seq; i++) 
+	for (i = 2; i < state->num_seq; i++)
 		vga_wseq(state->vgabase, i, saved->seq[i]);
 
 
 	/* unprotect vga regs */
 	vga_wcrtcs(state->vgabase, iobase, 17, saved->crtc[17] & ~0x80);
-	for (i = 0; i < state->num_crtc; i++) 
+	for (i = 0; i < state->num_crtc; i++)
 		vga_wcrtcs(state->vgabase, iobase, i, saved->crtc[i]);
-	
-	for (i = 0; i < state->num_gfx; i++) 
+
+	for (i = 0; i < state->num_gfx; i++)
 		vga_wgfx(state->vgabase, i, saved->gfx[i]);
 
 	for (i = 0; i < state->num_attr; i++) {
@@ -298,7 +298,7 @@ static void restore_vga_mode(struct vgastate *state)
 	/* reenable sequencer */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x03);
 	/* turn display on */
-	vga_wseq(state->vgabase, VGA_SEQ_CLOCK_MODE, 
+	vga_wseq(state->vgabase, VGA_SEQ_CLOCK_MODE,
 		 saved->seq[VGA_SEQ_CLOCK_MODE] & ~(1 << 5));
 
 	/* disable video/palette source */
@@ -312,7 +312,7 @@ static void save_vga_cmap(struct vgastate *state)
 	int i;
 
 	vga_w(state->vgabase, VGA_PEL_MSK, 0xff);
-	
+
 	/* assumes DAC is readable and writable */
 	vga_w(state->vgabase, VGA_PEL_IR, 0x00);
 	for (i = 0; i < 768; i++)
@@ -346,7 +346,7 @@ static void vga_cleanup(struct vgastate *state)
 		state->vidstate = NULL;
 	}
 }
-		
+
 int save_vga(struct vgastate *state)
 {
 	struct regstate *saved;
@@ -357,7 +357,7 @@ int save_vga(struct vgastate *state)
 		return 1;
 
 	state->vidstate = (void *)saved;
-		
+
 	if (state->flags & VGA_SAVE_CMAP) {
 		saved->vga_cmap = vmalloc(768);
 		if (!saved->vga_cmap) {
@@ -403,7 +403,7 @@ int save_vga(struct vgastate *state)
 		}
 		if (!state->memsize)
 			state->memsize = 8 * 8192;
-		
+
 		if (!state->membase)
 			state->membase = 0xA0000;
 
@@ -414,7 +414,7 @@ int save_vga(struct vgastate *state)
 			return 1;
 		}
 
-		/* 
+		/*
 		 * save only first 32K used by vgacon
 		 */
 		if (state->flags & VGA_SAVE_FONT0) {
@@ -425,7 +425,7 @@ int save_vga(struct vgastate *state)
 				return 1;
 			}
 		}
-		/* 
+		/*
 		 * largely unused, but if required by the caller
 		 * we'll just save everything.
 		 */
@@ -448,7 +448,7 @@ int save_vga(struct vgastate *state)
 				return 1;
 			}
 		}
-		
+
 		save_vga_text(state, fbbase);
 		iounmap(fbbase);
 	}
-- 
1.7.0.4


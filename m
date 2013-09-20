Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3ITBgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 21:36:18 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:58068 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752050Ab3ITBgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 21:36:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:69:355:379:541:857:960:966:973:981:988:989:1260:1345:1359:1437:1461:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2538:2559:2562:2896:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:4250:4321:4384:4385:4395:4605:5007:6261:7903:7974:8603:10004:10026:10848:11026:11914:12043:12296:12438:12517:12519:12555:12679:12683:12731:12737:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: baby56_8b978323ca832
X-Filterd-Recvd-Size: 58993
From: Joe Perches <joe@perches.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] framebuffer: Use fb_<level>
Date: Thu, 19 Sep 2013 18:35:55 -0700
Message-Id: <8e7d2ced3f358961988c2602b8d1dff673f569c0.1379640011.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <0926c7a34ac51c4cbb67debd0d883f41891e75d9.1379640011.git.joe@perches.com>
References: <0926c7a34ac51c4cbb67debd0d883f41891e75d9.1379640011.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neaten and shorten the code using the new fb_<level> macros.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/auxdisplay/cfag12864bfb.c    |  3 +-
 drivers/video/68328fb.c              |  9 +++---
 drivers/video/amifb.c                |  4 +--
 drivers/video/arcfb.c                |  8 ++---
 drivers/video/arkfb.c                | 46 +++++++++++++-------------
 drivers/video/asiliantfb.c           |  4 +--
 drivers/video/atafb.c                |  7 ++--
 drivers/video/aty/aty128fb.c         |  4 +--
 drivers/video/broadsheetfb.c         |  5 ++-
 drivers/video/carminefb.c            |  3 +-
 drivers/video/cobalt_lcdfb.c         |  3 +-
 drivers/video/controlfb.c            |  4 +--
 drivers/video/efifb.c                |  3 +-
 drivers/video/fb-puv3.c              |  5 ++-
 drivers/video/fm2fb.c                |  2 +-
 drivers/video/gbefb.c                |  6 ++--
 drivers/video/geode/gx1fb_core.c     |  2 +-
 drivers/video/geode/gxfb_core.c      |  2 +-
 drivers/video/geode/lxfb_core.c      |  3 +-
 drivers/video/gxt4500.c              |  3 +-
 drivers/video/hecubafb.c             |  5 ++-
 drivers/video/hgafb.c                |  3 +-
 drivers/video/hitfb.c                |  3 +-
 drivers/video/hpfb.c                 |  3 +-
 drivers/video/i740fb.c               |  8 ++---
 drivers/video/igafb.c                |  5 ++-
 drivers/video/imsttfb.c              |  4 +--
 drivers/video/kyro/fbdev.c           |  8 ++---
 drivers/video/macfb.c                |  3 +-
 drivers/video/matrox/matroxfb_base.c |  6 ++--
 drivers/video/mbx/mbxfb.c            |  2 +-
 drivers/video/neofb.c                |  3 +-
 drivers/video/nuc900fb.c             |  3 +-
 drivers/video/offb.c                 |  3 +-
 drivers/video/platinumfb.c           |  2 +-
 drivers/video/pm2fb.c                |  4 +--
 drivers/video/pm3fb.c                |  3 +-
 drivers/video/pmag-ba-fb.c           |  4 +--
 drivers/video/pmagb-b-fb.c           |  9 +++---
 drivers/video/pvr2fb.c               | 25 ++++++++-------
 drivers/video/q40fb.c                |  3 +-
 drivers/video/s1d13xxxfb.c           |  3 +-
 drivers/video/s3fb.c                 | 62 +++++++++++++++++++-----------------
 drivers/video/sgivwfb.c              |  4 +--
 drivers/video/sis/sis_main.c         |  4 +--
 drivers/video/skeletonfb.c           |  3 +-
 drivers/video/sstfb.c                |  8 ++---
 drivers/video/stifb.c                |  4 +--
 drivers/video/svgalib.c              |  4 +--
 drivers/video/tgafb.c                |  4 +--
 drivers/video/tmiofb.c               |  3 +-
 drivers/video/uvesafb.c              |  6 ++--
 drivers/video/valkyriefb.c           |  2 +-
 drivers/video/vesafb.c               |  3 +-
 drivers/video/vfb.c                  |  5 ++-
 drivers/video/vga16fb.c              |  3 +-
 drivers/video/vt8623fb.c             | 40 ++++++++++++-----------
 drivers/video/w100fb.c               |  5 ++-
 drivers/video/wm8505fb.c             | 12 +++----
 59 files changed, 186 insertions(+), 224 deletions(-)

diff --git a/drivers/auxdisplay/cfag12864bfb.c b/drivers/auxdisplay/cfag12864bfb.c
index d585735..a387403 100644
--- a/drivers/auxdisplay/cfag12864bfb.c
+++ b/drivers/auxdisplay/cfag12864bfb.c
@@ -102,8 +102,7 @@ static int cfag12864bfb_probe(struct platform_device *device)
 
 	platform_set_drvdata(device, info);
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
-		info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	return 0;
 
diff --git a/drivers/video/68328fb.c b/drivers/video/68328fb.c
index fa44fbe..552258c 100644
--- a/drivers/video/68328fb.c
+++ b/drivers/video/68328fb.c
@@ -478,11 +478,10 @@ int __init mc68x328fb_init(void)
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO
-		"fb%d: %s frame buffer device\n", fb_info.node,	fb_info.fix.id);
-	printk(KERN_INFO
-		"fb%d: %dx%dx%d at 0x%08lx\n", fb_info.node,
-		mc68x328fb_default.xres_virtual, mc68x328fb_default.yres_virtual,
+	fb_info(&fb_info, "%s frame buffer device\n", fb_info.fix.id);
+	fb_info(&fb_info, "%dx%dx%d at 0x%08lx\n",
+		mc68x328fb_default.xres_virtual,
+		mc68x328fb_default.yres_virtual,
 		1 << mc68x328fb_default.bits_per_pixel, videomemory);
 
 	return 0;
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index a6780ee..aaa1691 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -3742,8 +3742,8 @@ default_chipset:
 	if (err)
 		goto unset_drvdata;
 
-	printk("fb%d: %s frame buffer device, using %dK of video memory\n",
-	       info->node, info->fix.id, info->fix.smem_len>>10);
+	fb_info(info, "%s frame buffer device, using %dK of video memory\n",
+		info->fix.id, info->fix.smem_len>>10);
 
 	return 0;
 
diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index e43401a..1b0b233 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -556,9 +556,8 @@ static int arcfb_probe(struct platform_device *dev)
 			goto err1;
 		}
 	}
-	printk(KERN_INFO
-	       "fb%d: Arc frame buffer device, using %dK of video memory\n",
-	       info->node, videomemorysize >> 10);
+	fb_info(info, "Arc frame buffer device, using %dK of video memory\n",
+		videomemorysize >> 10);
 
 	/* this inits the lcd but doesn't clear dirty pixels */
 	for (i = 0; i < num_cols * num_rows; i++) {
@@ -572,8 +571,7 @@ static int arcfb_probe(struct platform_device *dev)
 	/* if we were told to splash the screen, we just clear it */
 	if (!nosplash) {
 		for (i = 0; i < num_cols * num_rows; i++) {
-			printk(KERN_INFO "fb%d: splashing lcd %d\n",
-				info->node, i);
+			fb_info(info, "splashing lcd %d\n", i);
 			ks108_set_start_line(par, i, 0);
 			ks108_clear_lcd(par, i);
 		}
diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index 94a51f1..ee0f1a1 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -137,8 +137,7 @@ static void arkfb_settile(struct fb_info *info, struct fb_tilemap *map)
 
 	if ((map->width != 8) || (map->height != 16) ||
 	    (map->depth != 1) || (map->length != 256)) {
-	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, "
-		       "height %d, depth %d, length %d\n", info->node,
+		fb_err(info, "unsupported font parameters: width %d, height %d, depth %d, length %d\n",
 		       map->width, map->height, map->depth, map->length);
 		return;
 	}
@@ -517,7 +516,7 @@ static void ark_set_pixclock(struct fb_info *info, u32 pixclock)
 
 	int rv = dac_set_freq(par->dac, 0, 1000000000 / pixclock);
 	if (rv < 0) {
-		printk(KERN_ERR "fb%d: cannot set requested pixclock, keeping old value\n", info->node);
+		fb_err(info, "cannot set requested pixclock, keeping old value\n");
 		return;
 	}
 
@@ -584,7 +583,7 @@ static int arkfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	rv = svga_match_format (arkfb_formats, var, NULL);
 	if (rv < 0)
 	{
-		printk(KERN_ERR "fb%d: unsupported mode requested\n", info->node);
+		fb_err(info, "unsupported mode requested\n");
 		return rv;
 	}
 
@@ -604,14 +603,15 @@ static int arkfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	mem = ((var->bits_per_pixel * var->xres_virtual) >> 3) * var->yres_virtual;
 	if (mem > info->screen_size)
 	{
-		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n", info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));
+		fb_err(info, "not enough framebuffer memory (%d kB requested, %d kB available)\n",
+		       mem >> 10, (unsigned int) (info->screen_size >> 10));
 		return -EINVAL;
 	}
 
 	rv = svga_check_timings (&ark_timing_regs, var, info->node);
 	if (rv < 0)
 	{
-		printk(KERN_ERR "fb%d: invalid timings requested\n", info->node);
+		fb_err(info, "invalid timings requested\n");
 		return rv;
 	}
 
@@ -693,7 +693,7 @@ static int arkfb_set_par(struct fb_info *info)
 	vga_wseq(par->state.vgabase, 0x18, regval);
 
 	/* Set the offset register */
-	pr_debug("fb%d: offset register       : %d\n", info->node, offset_value);
+	fb_dbg(info, "offset register       : %d\n", offset_value);
 	svga_wcrt_multi(par->state.vgabase, ark_offset_regs, offset_value);
 
 	/* fix for hi-res textmode */
@@ -716,7 +716,7 @@ static int arkfb_set_par(struct fb_info *info)
 	/* Set mode-specific register values */
 	switch (mode) {
 	case 0:
-		pr_debug("fb%d: text mode\n", info->node);
+		fb_dbg(info, "text mode\n");
 		svga_set_textmode_vga_regs(par->state.vgabase);
 
 		vga_wseq(par->state.vgabase, 0x11, 0x10); /* basic VGA mode */
@@ -725,7 +725,7 @@ static int arkfb_set_par(struct fb_info *info)
 
 		break;
 	case 1:
-		pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
+		fb_dbg(info, "4 bit pseudocolor\n");
 		vga_wgfx(par->state.vgabase, VGA_GFX_MODE, 0x40);
 
 		vga_wseq(par->state.vgabase, 0x11, 0x10); /* basic VGA mode */
@@ -733,44 +733,44 @@ static int arkfb_set_par(struct fb_info *info)
 		dac_set_mode(par->dac, DAC_PSEUDO8_8);
 		break;
 	case 2:
-		pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
+		fb_dbg(info, "4 bit pseudocolor, planar\n");
 
 		vga_wseq(par->state.vgabase, 0x11, 0x10); /* basic VGA mode */
 		svga_wcrt_mask(par->state.vgabase, 0x46, 0x00, 0x04); /* 8bit pixel path */
 		dac_set_mode(par->dac, DAC_PSEUDO8_8);
 		break;
 	case 3:
-		pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
+		fb_dbg(info, "8 bit pseudocolor\n");
 
 		vga_wseq(par->state.vgabase, 0x11, 0x16); /* 8bpp accel mode */
 
 		if (info->var.pixclock > 20000) {
-			pr_debug("fb%d: not using multiplex\n", info->node);
+			fb_dbg(info, "not using multiplex\n");
 			svga_wcrt_mask(par->state.vgabase, 0x46, 0x00, 0x04); /* 8bit pixel path */
 			dac_set_mode(par->dac, DAC_PSEUDO8_8);
 		} else {
-			pr_debug("fb%d: using multiplex\n", info->node);
+			fb_dbg(info, "using multiplex\n");
 			svga_wcrt_mask(par->state.vgabase, 0x46, 0x04, 0x04); /* 16bit pixel path */
 			dac_set_mode(par->dac, DAC_PSEUDO8_16);
 			hdiv = 2;
 		}
 		break;
 	case 4:
-		pr_debug("fb%d: 5/5/5 truecolor\n", info->node);
+		fb_dbg(info, "5/5/5 truecolor\n");
 
 		vga_wseq(par->state.vgabase, 0x11, 0x1A); /* 16bpp accel mode */
 		svga_wcrt_mask(par->state.vgabase, 0x46, 0x04, 0x04); /* 16bit pixel path */
 		dac_set_mode(par->dac, DAC_RGB1555_16);
 		break;
 	case 5:
-		pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
+		fb_dbg(info, "5/6/5 truecolor\n");
 
 		vga_wseq(par->state.vgabase, 0x11, 0x1A); /* 16bpp accel mode */
 		svga_wcrt_mask(par->state.vgabase, 0x46, 0x04, 0x04); /* 16bit pixel path */
 		dac_set_mode(par->dac, DAC_RGB0565_16);
 		break;
 	case 6:
-		pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
+		fb_dbg(info, "8/8/8 truecolor\n");
 
 		vga_wseq(par->state.vgabase, 0x11, 0x16); /* 8bpp accel mode ??? */
 		svga_wcrt_mask(par->state.vgabase, 0x46, 0x04, 0x04); /* 16bit pixel path */
@@ -779,7 +779,7 @@ static int arkfb_set_par(struct fb_info *info)
 		hdiv = 2;
 		break;
 	case 7:
-		pr_debug("fb%d: 8/8/8/8 truecolor\n", info->node);
+		fb_dbg(info, "8/8/8/8 truecolor\n");
 
 		vga_wseq(par->state.vgabase, 0x11, 0x1E); /* 32bpp accel mode */
 		svga_wcrt_mask(par->state.vgabase, 0x46, 0x04, 0x04); /* 16bit pixel path */
@@ -787,7 +787,7 @@ static int arkfb_set_par(struct fb_info *info)
 		hmul = 2;
 		break;
 	default:
-		printk(KERN_ERR "fb%d: unsupported mode - bug\n", info->node);
+		fb_err(info, "unsupported mode - bug\n");
 		return -EINVAL;
 	}
 
@@ -879,19 +879,19 @@ static int arkfb_blank(int blank_mode, struct fb_info *info)
 
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		pr_debug("fb%d: unblank\n", info->node);
+		fb_dbg(info, "unblank\n");
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x00, 0x20);
 		svga_wcrt_mask(par->state.vgabase, 0x17, 0x80, 0x80);
 		break;
 	case FB_BLANK_NORMAL:
-		pr_debug("fb%d: blank\n", info->node);
+		fb_dbg(info, "blank\n");
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		svga_wcrt_mask(par->state.vgabase, 0x17, 0x80, 0x80);
 		break;
 	case FB_BLANK_POWERDOWN:
 	case FB_BLANK_HSYNC_SUSPEND:
 	case FB_BLANK_VSYNC_SUSPEND:
-		pr_debug("fb%d: sync down\n", info->node);
+		fb_dbg(info, "sync down\n");
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		svga_wcrt_mask(par->state.vgabase, 0x17, 0x00, 0x80);
 		break;
@@ -1052,8 +1052,8 @@ static int ark_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto err_reg_fb;
 	}
 
-	printk(KERN_INFO "fb%d: %s on %s, %d MB RAM\n", info->node, info->fix.id,
-		 pci_name(dev), info->fix.smem_len >> 20);
+	fb_info(info, "%s on %s, %d MB RAM\n",
+		info->fix.id, pci_name(dev), info->fix.smem_len >> 20);
 
 	/* Record a reference to the driver data */
 	pci_set_drvdata(dev, info);
diff --git a/drivers/video/asiliantfb.c b/drivers/video/asiliantfb.c
index d5a37d6..d611f1a 100644
--- a/drivers/video/asiliantfb.c
+++ b/drivers/video/asiliantfb.c
@@ -527,8 +527,8 @@ static int init_asiliant(struct fb_info *p, unsigned long addr)
 		return err;
 	}
 
-	printk(KERN_INFO "fb%d: Asiliant 69000 frame buffer (%dK RAM detected)\n",
-		p->node, p->fix.smem_len / 1024);
+	fb_info(p, "Asiliant 69000 frame buffer (%dK RAM detected)\n",
+		p->fix.smem_len / 1024);
 
 	writeb(0xff, mmio_base + 0x78c);
 	chips_hw_init(p);
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 64e41f5..e21d1f5 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -3246,11 +3246,8 @@ int __init atafb_init(void)
 		return -EINVAL;
 	}
 
-	// FIXME: mode needs setting!
-	//printk("fb%d: %s frame buffer device, using %dK of video memory\n",
-	//       fb_info.node, fb_info.mode->name, screen_len>>10);
-	printk("fb%d: frame buffer device, using %dK of video memory\n",
-	       fb_info.node, screen_len >> 10);
+	fb_info(&fb_info, "frame buffer device, using %dK of video memory\n",
+		screen_len >> 10);
 
 	/* TODO: This driver cannot be unloaded yet */
 	return 0;
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index a4dfe8c..d660f65 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -2029,8 +2029,8 @@ static int aty128_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (register_framebuffer(info) < 0)
 		return 0;
 
-	printk(KERN_INFO "fb%d: %s frame buffer device on %s\n",
-	       info->node, info->fix.id, video_card);
+	fb_info(info, "%s frame buffer device on %s\n",
+		info->fix.id, video_card);
 
 	return 1;	/* success! */
 }
diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
index b09701c..5d11a6a 100644
--- a/drivers/video/broadsheetfb.c
+++ b/drivers/video/broadsheetfb.c
@@ -1167,9 +1167,8 @@ static int broadsheetfb_probe(struct platform_device *dev)
 	if (retval < 0)
 		goto err_unreg_fb;
 
-	printk(KERN_INFO
-	       "fb%d: Broadsheet frame buffer, using %dK of video memory\n",
-	       info->node, videomemorysize >> 10);
+	fb_info(info, "Broadsheet frame buffer, using %dK of video memory\n",
+		videomemorysize >> 10);
 
 
 	return 0;
diff --git a/drivers/video/carminefb.c b/drivers/video/carminefb.c
index 153dd65..4940079 100644
--- a/drivers/video/carminefb.c
+++ b/drivers/video/carminefb.c
@@ -585,8 +585,7 @@ static int alloc_carmine_fb(void __iomem *regs, void __iomem *smem_base,
 	if (ret < 0)
 		goto err_dealloc_cmap;
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
-			info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	*rinfo = info;
 	return 0;
diff --git a/drivers/video/cobalt_lcdfb.c b/drivers/video/cobalt_lcdfb.c
index a903149..1387ad6 100644
--- a/drivers/video/cobalt_lcdfb.c
+++ b/drivers/video/cobalt_lcdfb.c
@@ -368,8 +368,7 @@ static int cobalt_lcdfb_probe(struct platform_device *dev)
 
 	lcd_clear(info);
 
-	printk(KERN_INFO "fb%d: Cobalt server LCD frame buffer device\n",
-		info->node);
+	fb_info(info, "Cobalt server LCD frame buffer device\n");
 
 	return 0;
 }
diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index 67b77b4..fdadef9 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -471,8 +471,8 @@ try_again:
 	/* Register with fbdev layer */
 	if (register_framebuffer(&p->info) < 0)
 		return -ENXIO;
-	
-	printk(KERN_INFO "fb%d: control display adapter\n", p->info.node);	
+
+	fb_info(&p->info, "control display adapter\n");
 
 	return 0;
 }
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 7f9ff75..e58f45c 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -322,8 +322,7 @@ static int efifb_probe(struct platform_device *dev)
 		printk(KERN_ERR "efifb: cannot register framebuffer\n");
 		goto err_fb_dealoc;
 	}
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-		info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	return 0;
 
 err_fb_dealoc:
diff --git a/drivers/video/fb-puv3.c b/drivers/video/fb-puv3.c
index 27fc956..6db9ebd 100644
--- a/drivers/video/fb-puv3.c
+++ b/drivers/video/fb-puv3.c
@@ -713,9 +713,8 @@ static int unifb_probe(struct platform_device *dev)
 	platform_set_drvdata(dev, info);
 	platform_device_add_data(dev, unifb_regs, sizeof(u32) * UNIFB_REGS_NUM);
 
-	printk(KERN_INFO
-	       "fb%d: Virtual frame buffer device, using %dM of video memory\n",
-	       info->node, UNIFB_MEMSIZE >> 20);
+	fb_info(info, "Virtual frame buffer device, using %dM of video memory\n",
+		UNIFB_MEMSIZE >> 20);
 	return 0;
 err2:
 	fb_dealloc_cmap(&info->cmap);
diff --git a/drivers/video/fm2fb.c b/drivers/video/fm2fb.c
index c99c967..e69d47a 100644
--- a/drivers/video/fm2fb.c
+++ b/drivers/video/fm2fb.c
@@ -289,7 +289,7 @@ static int fm2fb_probe(struct zorro_dev *z, const struct zorro_device_id *id)
 		zorro_release_device(z);
 		return -EINVAL;
 	}
-	printk("fb%d: %s frame buffer device\n", info->node, fb_fix.id);
+	fb_info(info, "%s frame buffer device\n", fb_fix.id);
 	return 0;
 }
 
diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index ceab370..4c7cb36 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1236,9 +1236,9 @@ static int gbefb_probe(struct platform_device *p_dev)
 	platform_set_drvdata(p_dev, info);
 	gbefb_create_sysfs(&p_dev->dev);
 
-	printk(KERN_INFO "fb%d: %s rev %d @ 0x%08x using %dkB memory\n",
-	       info->node, info->fix.id, gbe_revision, (unsigned) GBE_BASE,
-	       gbe_mem_size >> 10);
+	fb_info(info, "%s rev %d @ 0x%08x using %dkB memory\n",
+		info->fix.id, gbe_revision, (unsigned)GBE_BASE,
+		gbe_mem_size >> 10);
 
 	return 0;
 
diff --git a/drivers/video/geode/gx1fb_core.c b/drivers/video/geode/gx1fb_core.c
index ebbaada..040bc66 100644
--- a/drivers/video/geode/gx1fb_core.c
+++ b/drivers/video/geode/gx1fb_core.c
@@ -357,7 +357,7 @@ static int gx1fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 	pci_set_drvdata(pdev, info);
-	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	return 0;
 
   err:
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 19f0c1ad..a5ec51f 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -423,7 +423,7 @@ static int gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 	pci_set_drvdata(pdev, info);
-	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	return 0;
 
   err:
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 4dd7b55..5bcde80 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -555,8 +555,7 @@ static int lxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 	pci_set_drvdata(pdev, info);
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-		info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	return 0;
 
diff --git a/drivers/video/gxt4500.c b/drivers/video/gxt4500.c
index c35663f..135d78a 100644
--- a/drivers/video/gxt4500.c
+++ b/drivers/video/gxt4500.c
@@ -698,8 +698,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev, "gxt4500: cannot register framebuffer\n");
 		goto err_free_cmap;
 	}
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-	       info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	return 0;
 
diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index 59d2318..906026f 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -261,9 +261,8 @@ static int hecubafb_probe(struct platform_device *dev)
 		goto err_fbreg;
 	platform_set_drvdata(dev, info);
 
-	printk(KERN_INFO
-	       "fb%d: Hecuba frame buffer device, using %dK of video memory\n",
-	       info->node, videomemorysize >> 10);
+	fb_info(info, "Hecuba frame buffer device, using %dK of video memory\n",
+		videomemorysize >> 10);
 
 	/* this inits the dpy */
 	retval = par->board->init(par);
diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
index 1e9e2d8..5ff9fe2 100644
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -586,8 +586,7 @@ static int hgafb_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-        printk(KERN_INFO "fb%d: %s frame buffer device\n",
-               info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	platform_set_drvdata(pdev, info);
 	return 0;
 }
diff --git a/drivers/video/hitfb.c b/drivers/video/hitfb.c
index c2414d6..a648d51 100644
--- a/drivers/video/hitfb.c
+++ b/drivers/video/hitfb.c
@@ -405,8 +405,7 @@ static int hitfb_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, info);
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-	       info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	return 0;
 
diff --git a/drivers/video/hpfb.c b/drivers/video/hpfb.c
index b802f93..a1b7e5f 100644
--- a/drivers/video/hpfb.c
+++ b/drivers/video/hpfb.c
@@ -298,8 +298,7 @@ static int hpfb_init_one(unsigned long phys_base, unsigned long virt_base)
 	if (ret < 0)
 		goto dealloc_cmap;
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-	       fb_info.node, fb_info.fix.id);
+	fb_info(&fb_info, "%s frame buffer device\n", fb_info.fix.id);
 
 	return 0;
 
diff --git a/drivers/video/i740fb.c b/drivers/video/i740fb.c
index 6c48388..985bae4 100644
--- a/drivers/video/i740fb.c
+++ b/drivers/video/i740fb.c
@@ -203,8 +203,7 @@ static int i740fb_release(struct fb_info *info, int user)
 
 	mutex_lock(&(par->open_lock));
 	if (par->ref_count == 0) {
-		printk(KERN_ERR "fb%d: release called with zero refcount\n",
-			info->node);
+		fb_err(info, "release called with zero refcount\n");
 		mutex_unlock(&(par->open_lock));
 		return -EINVAL;
 	}
@@ -1067,7 +1066,7 @@ static int i740fb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	par->has_sgram = !((tmp & DRAM_RAS_TIMING) ||
 			   (tmp & DRAM_RAS_PRECHARGE));
 
-	printk(KERN_INFO "fb%d: Intel740 on %s, %ld KB %s\n", info->node,
+	fb_info(info, "Intel740 on %s, %ld KB %s\n",
 		pci_name(dev), info->screen_size >> 10,
 		par->has_sgram ? "SGRAM" : "SDRAM");
 
@@ -1143,8 +1142,7 @@ static int i740fb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 		goto err_reg_framebuffer;
 	}
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-		info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	pci_set_drvdata(dev, info);
 #ifdef CONFIG_MTRR
 	if (mtrr) {
diff --git a/drivers/video/igafb.c b/drivers/video/igafb.c
index 79cbfa7..486f188 100644
--- a/drivers/video/igafb.c
+++ b/drivers/video/igafb.c
@@ -360,9 +360,8 @@ static int __init iga_init(struct fb_info *info, struct iga_par *par)
 	if (register_framebuffer(info) < 0)
 		return 0;
 
-	printk("fb%d: %s frame buffer device at 0x%08lx [%dMB VRAM]\n",
-	       info->node, info->fix.id, 
-	       par->frame_buffer_phys, info->fix.smem_len >> 20);
+	fb_info(info, "%s frame buffer device at 0x%08lx [%dMB VRAM]\n",
+		info->fix.id, par->frame_buffer_phys, info->fix.smem_len >> 20);
 
 	iga_blank_border(par); 
 	return 1;
diff --git a/drivers/video/imsttfb.c b/drivers/video/imsttfb.c
index d5220cc..aae10ce 100644
--- a/drivers/video/imsttfb.c
+++ b/drivers/video/imsttfb.c
@@ -1461,8 +1461,8 @@ static void init_imstt(struct fb_info *info)
 	}
 
 	tmp = (read_reg_le32(par->dc_regs, SSTATUS) & 0x0f00) >> 8;
-	printk("fb%u: %s frame buffer; %uMB vram; chip version %u\n",
-		info->node, info->fix.id, info->fix.smem_len >> 20, tmp);
+	fb_info(info, "%s frame buffer; %uMB vram; chip version %u\n",
+		info->fix.id, info->fix.smem_len >> 20, tmp);
 }
 
 static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
index 6157f74..7fb500a 100644
--- a/drivers/video/kyro/fbdev.c
+++ b/drivers/video/kyro/fbdev.c
@@ -736,10 +736,10 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (register_framebuffer(info) < 0)
 		goto out_unmap;
 
-	printk("fb%d: %s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
-	       info->node, info->fix.id, info->var.xres,
-	       info->var.yres, info->var.bits_per_pixel, size >> 10,
-	       (unsigned long)info->fix.smem_len >> 10);
+	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
+		info->fix.id,
+		info->var.xres, info->var.yres, info->var.bits_per_pixel,
+		size >> 10, (unsigned long)info->fix.smem_len >> 10);
 
 	pci_set_drvdata(pdev, info);
 
diff --git a/drivers/video/macfb.c b/drivers/video/macfb.c
index fe01add..5bd2eb8 100644
--- a/drivers/video/macfb.c
+++ b/drivers/video/macfb.c
@@ -913,8 +913,7 @@ static int __init macfb_init(void)
 	if (err)
 		goto fail_dealloc;
 
-	pr_info("fb%d: %s frame buffer device\n",
-	        fb_info.node, fb_info.fix.id);
+	fb_info(&fb_info, "%s frame buffer device\n", fb_info.fix.id);
 
 	return 0;
 
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 2456529..87c64ff 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -1893,14 +1893,12 @@ static int initMatrox2(struct matrox_fb_info *minfo, struct board *b)
 	if (register_framebuffer(&minfo->fbcon) < 0) {
 		goto failVideoIO;
 	}
-	printk("fb%d: %s frame buffer device\n",
-	       minfo->fbcon.node, minfo->fbcon.fix.id);
+	fb_info(&minfo->fbcon, "%s frame buffer device\n", minfo->fbcon.fix.id);
 
 	/* there is no console on this fb... but we have to initialize hardware
 	 * until someone tells me what is proper thing to do */
 	if (!minfo->initialized) {
-		printk(KERN_INFO "fb%d: initializing hardware\n",
-		       minfo->fbcon.node);
+		fb_info(&minfo->fbcon, "initializing hardware\n");
 		/* We have to use FB_ACTIVATE_FORCE, as we had to put vesafb_defined to the fbcon.var
 		 * already before, so register_framebuffer works correctly. */
 		vesafb_defined.activate |= FB_ACTIVATE_FORCE;
diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 0c1a874..e89cac0 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -976,7 +976,7 @@ static int mbxfb_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, fbi);
 
-	printk(KERN_INFO "fb%d: mbx frame buffer device\n", fbi->node);
+	fb_info(fbi, "mbx frame buffer device\n");
 
 	if (mfbi->platform_probe)
 		mfbi->platform_probe(fbi);
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index 7ef079c..26317b1 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -2104,8 +2104,7 @@ static int neofb_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (err < 0)
 		goto err_reg_fb;
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-	       info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	/*
 	 * Our driver data
diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index 796e511..af8b8f3 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -647,8 +647,7 @@ static int nuc900fb_probe(struct platform_device *pdev)
 		goto free_cpufreq;
 	}
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-		fbinfo->node, fbinfo->fix.id);
+	fb_info(fbinfo, "%s frame buffer device\n", fbinfo->fix.id);
 
 	return 0;
 
diff --git a/drivers/video/offb.c b/drivers/video/offb.c
index 0c4f343..9dbea22 100644
--- a/drivers/video/offb.c
+++ b/drivers/video/offb.c
@@ -515,8 +515,7 @@ static void __init offb_init_fb(const char *name, const char *full_name,
 	if (register_framebuffer(info) < 0)
 		goto out_err;
 
-	printk(KERN_INFO "fb%d: Open Firmware frame buffer device on %s\n",
-	       info->node, full_name);
+	fb_info(info, "Open Firmware frame buffer device on %s\n", full_name);
 	return;
 
 out_err:
diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
index 3d86bac..ff126439 100644
--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -403,7 +403,7 @@ try_again:
 	if (rc < 0)
 		return rc;
 
-	printk(KERN_INFO "fb%d: Apple Platinum frame buffer device\n", info->node);
+	fb_info(info, "Apple Platinum frame buffer device\n");
 
 	return 0;
 }
diff --git a/drivers/video/pm2fb.c b/drivers/video/pm2fb.c
index 81354ee..6a1637e 100644
--- a/drivers/video/pm2fb.c
+++ b/drivers/video/pm2fb.c
@@ -1694,8 +1694,8 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (retval < 0)
 		goto err_exit_all;
 
-	printk(KERN_INFO "fb%d: %s frame buffer device, memory = %dK.\n",
-	       info->node, info->fix.id, pm2fb_fix.smem_len / 1024);
+	fb_info(info, "%s frame buffer device, memory = %dK\n",
+		info->fix.id, pm2fb_fix.smem_len / 1024);
 
 	/*
 	 * Our driver data
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 7718faa..e31938d 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -1445,8 +1445,7 @@ static int pm3fb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 		retval = -EINVAL;
 		goto err_exit_all;
 	}
-	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
-	   info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	pci_set_drvdata(dev, info);
 	return 0;
 
diff --git a/drivers/video/pmag-ba-fb.c b/drivers/video/pmag-ba-fb.c
index d1e46ce..914a52b 100644
--- a/drivers/video/pmag-ba-fb.c
+++ b/drivers/video/pmag-ba-fb.c
@@ -212,8 +212,8 @@ static int pmagbafb_probe(struct device *dev)
 
 	get_device(dev);
 
-	pr_info("fb%d: %s frame buffer device at %s\n",
-		info->node, info->fix.id, dev_name(dev));
+	fb_info(info, "%s frame buffer device at %s\n",
+		info->fix.id, dev_name(dev));
 
 	return 0;
 
diff --git a/drivers/video/pmagb-b-fb.c b/drivers/video/pmagb-b-fb.c
index 0e13174..0822b6f 100644
--- a/drivers/video/pmagb-b-fb.c
+++ b/drivers/video/pmagb-b-fb.c
@@ -328,11 +328,10 @@ static int pmagbbfb_probe(struct device *dev)
 	snprintf(freq1, sizeof(freq1), "%u.%03uMHz",
 		 par->osc1 / 1000, par->osc1 % 1000);
 
-	pr_info("fb%d: %s frame buffer device at %s\n",
-		info->node, info->fix.id, dev_name(dev));
-	pr_info("fb%d: Osc0: %s, Osc1: %s, Osc%u selected\n",
-		info->node, freq0, par->osc1 ? freq1 : "disabled",
-		par->osc1 != 0);
+	fb_info(info, "%s frame buffer device at %s\n",
+		info->fix.id, dev_name(dev));
+	fb_info(info, "Osc0: %s, Osc1: %s, Osc%u selected\n",
+		freq0, par->osc1 ? freq1 : "disabled", par->osc1 != 0);
 
 	return 0;
 
diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
index df07860..167cfff 100644
--- a/drivers/video/pvr2fb.c
+++ b/drivers/video/pvr2fb.c
@@ -817,24 +817,25 @@ static int pvr2fb_common_init(void)
 
 	rev = fb_readl(par->mmio_base + 0x04);
 
-	printk("fb%d: %s (rev %ld.%ld) frame buffer device, using %ldk/%ldk of video memory\n",
-	       fb_info->node, fb_info->fix.id, (rev >> 4) & 0x0f, rev & 0x0f,
-	       modememused >> 10, (unsigned long)(fb_info->fix.smem_len >> 10));
-	printk("fb%d: Mode %dx%d-%d pitch = %ld cable: %s video output: %s\n",
-	       fb_info->node, fb_info->var.xres, fb_info->var.yres,
-	       fb_info->var.bits_per_pixel,
-	       get_line_length(fb_info->var.xres, fb_info->var.bits_per_pixel),
-	       (char *)pvr2_get_param(cables, NULL, cable_type, 3),
-	       (char *)pvr2_get_param(outputs, NULL, video_output, 3));
+	fb_info(fb_info, "%s (rev %ld.%ld) frame buffer device, using %ldk/%ldk of video memory\n",
+		fb_info->fix.id, (rev >> 4) & 0x0f, rev & 0x0f,
+		modememused >> 10,
+		(unsigned long)(fb_info->fix.smem_len >> 10));
+	fb_info(fb_info, "Mode %dx%d-%d pitch = %ld cable: %s video output: %s\n",
+		fb_info->var.xres, fb_info->var.yres,
+		fb_info->var.bits_per_pixel,
+		get_line_length(fb_info->var.xres, fb_info->var.bits_per_pixel),
+		(char *)pvr2_get_param(cables, NULL, cable_type, 3),
+		(char *)pvr2_get_param(outputs, NULL, video_output, 3));
 
 #ifdef CONFIG_SH_STORE_QUEUES
-	printk(KERN_NOTICE "fb%d: registering with SQ API\n", fb_info->node);
+	fb_notice(fb_info, "registering with SQ API\n");
 
 	pvr2fb_map = sq_remap(fb_info->fix.smem_start, fb_info->fix.smem_len,
 			      fb_info->fix.id, PAGE_SHARED);
 
-	printk(KERN_NOTICE "fb%d: Mapped video memory to SQ addr 0x%lx\n",
-	       fb_info->node, pvr2fb_map);
+	fb_notice(fb_info, "Mapped video memory to SQ addr 0x%lx\n",
+		  pvr2fb_map);
 #endif
 
 	return 0;
diff --git a/drivers/video/q40fb.c b/drivers/video/q40fb.c
index d44c735..7487f76 100644
--- a/drivers/video/q40fb.c
+++ b/drivers/video/q40fb.c
@@ -119,8 +119,7 @@ static int q40fb_probe(struct platform_device *dev)
 		return -EINVAL;
 	}
 
-        printk(KERN_INFO "fb%d: Q40 frame buffer alive and kicking !\n",
-	       info->node);
+	fb_info(info, "Q40 frame buffer alive and kicking !\n");
 	return 0;
 }
 
diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index 05c2dc3..312305b 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -901,8 +901,7 @@ static int s1d13xxxfb_probe(struct platform_device *pdev)
 		goto bail;
 	}
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-	       info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	return 0;
 
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 47ca86c..2a135f5 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -306,8 +306,8 @@ static void s3fb_settile_fast(struct fb_info *info, struct fb_tilemap *map)
 
 	if ((map->width != 8) || (map->height != 16) ||
 	    (map->depth != 1) || (map->length != 256)) {
-	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
-			info->node, map->width, map->height, map->depth, map->length);
+		fb_err(info, "unsupported font parameters: width %d, height %d, depth %d, length %d\n",
+		       map->width, map->height, map->depth, map->length);
 		return;
 	}
 
@@ -476,7 +476,7 @@ static void s3_set_pixclock(struct fb_info *info, u32 pixclock)
 	rv = svga_compute_pll((par->chip == CHIP_365_TRIO3D) ? &s3_trio3d_pll : &s3_pll,
 			      1000000000 / pixclock, &m, &n, &r, info->node);
 	if (rv < 0) {
-		printk(KERN_ERR "fb%d: cannot set requested pixclock, keeping old value\n", info->node);
+		fb_err(info, "cannot set requested pixclock, keeping old value\n");
 		return;
 	}
 
@@ -569,7 +569,7 @@ static int s3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 		rv = -EINVAL;
 
 	if (rv < 0) {
-		printk(KERN_ERR "fb%d: unsupported mode requested\n", info->node);
+		fb_err(info, "unsupported mode requested\n");
 		return rv;
 	}
 
@@ -587,22 +587,21 @@ static int s3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	/* Check whether have enough memory */
 	mem = ((var->bits_per_pixel * var->xres_virtual) >> 3) * var->yres_virtual;
 	if (mem > info->screen_size) {
-		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n",
-			info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));
+		fb_err(info, "not enough framebuffer memory (%d kB requested , %u kB available)\n",
+		       mem >> 10, (unsigned int) (info->screen_size >> 10));
 		return -EINVAL;
 	}
 
 	rv = svga_check_timings (&s3_timing_regs, var, info->node);
 	if (rv < 0) {
-		printk(KERN_ERR "fb%d: invalid timings requested\n", info->node);
+		fb_err(info, "invalid timings requested\n");
 		return rv;
 	}
 
 	rv = svga_compute_pll(&s3_pll, PICOS2KHZ(var->pixclock), &m, &n, &r,
 				info->node);
 	if (rv < 0) {
-		printk(KERN_ERR "fb%d: invalid pixclock value requested\n",
-			info->node);
+		fb_err(info, "invalid pixclock value requested\n");
 		return rv;
 	}
 
@@ -686,7 +685,7 @@ static int s3fb_set_par(struct fb_info *info)
 
 
 	/* Set the offset register */
-	pr_debug("fb%d: offset register       : %d\n", info->node, offset_value);
+	fb_dbg(info, "offset register       : %d\n", offset_value);
 	svga_wcrt_multi(par->state.vgabase, s3_offset_regs, offset_value);
 
 	if (par->chip != CHIP_357_VIRGE_GX2 &&
@@ -769,7 +768,7 @@ static int s3fb_set_par(struct fb_info *info)
 	/* Set mode-specific register values */
 	switch (mode) {
 	case 0:
-		pr_debug("fb%d: text mode\n", info->node);
+		fb_dbg(info, "text mode\n");
 		svga_set_textmode_vga_regs(par->state.vgabase);
 
 		/* Set additional registers like in 8-bit mode */
@@ -780,12 +779,12 @@ static int s3fb_set_par(struct fb_info *info)
 		svga_wcrt_mask(par->state.vgabase, 0x3A, 0x00, 0x30);
 
 		if (fasttext) {
-			pr_debug("fb%d: high speed text mode set\n", info->node);
+			fb_dbg(info, "high speed text mode set\n");
 			svga_wcrt_mask(par->state.vgabase, 0x31, 0x40, 0x40);
 		}
 		break;
 	case 1:
-		pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
+		fb_dbg(info, "4 bit pseudocolor\n");
 		vga_wgfx(par->state.vgabase, VGA_GFX_MODE, 0x40);
 
 		/* Set additional registers like in 8-bit mode */
@@ -796,7 +795,7 @@ static int s3fb_set_par(struct fb_info *info)
 		svga_wcrt_mask(par->state.vgabase, 0x3A, 0x00, 0x30);
 		break;
 	case 2:
-		pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
+		fb_dbg(info, "4 bit pseudocolor, planar\n");
 
 		/* Set additional registers like in 8-bit mode */
 		svga_wcrt_mask(par->state.vgabase, 0x50, 0x00, 0x30);
@@ -806,7 +805,7 @@ static int s3fb_set_par(struct fb_info *info)
 		svga_wcrt_mask(par->state.vgabase, 0x3A, 0x00, 0x30);
 		break;
 	case 3:
-		pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
+		fb_dbg(info, "8 bit pseudocolor\n");
 		svga_wcrt_mask(par->state.vgabase, 0x50, 0x00, 0x30);
 		if (info->var.pixclock > 20000 ||
 		    par->chip == CHIP_357_VIRGE_GX2 ||
@@ -822,7 +821,7 @@ static int s3fb_set_par(struct fb_info *info)
 		}
 		break;
 	case 4:
-		pr_debug("fb%d: 5/5/5 truecolor\n", info->node);
+		fb_dbg(info, "5/5/5 truecolor\n");
 		if (par->chip == CHIP_988_VIRGE_VX) {
 			if (info->var.pixclock > 20000)
 				svga_wcrt_mask(par->state.vgabase, 0x67, 0x20, 0xF0);
@@ -850,7 +849,7 @@ static int s3fb_set_par(struct fb_info *info)
 		}
 		break;
 	case 5:
-		pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
+		fb_dbg(info, "5/6/5 truecolor\n");
 		if (par->chip == CHIP_988_VIRGE_VX) {
 			if (info->var.pixclock > 20000)
 				svga_wcrt_mask(par->state.vgabase, 0x67, 0x40, 0xF0);
@@ -879,16 +878,16 @@ static int s3fb_set_par(struct fb_info *info)
 		break;
 	case 6:
 		/* VIRGE VX case */
-		pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
+		fb_dbg(info, "8/8/8 truecolor\n");
 		svga_wcrt_mask(par->state.vgabase, 0x67, 0xD0, 0xF0);
 		break;
 	case 7:
-		pr_debug("fb%d: 8/8/8/8 truecolor\n", info->node);
+		fb_dbg(info, "8/8/8/8 truecolor\n");
 		svga_wcrt_mask(par->state.vgabase, 0x50, 0x30, 0x30);
 		svga_wcrt_mask(par->state.vgabase, 0x67, 0xD0, 0xF0);
 		break;
 	default:
-		printk(KERN_ERR "fb%d: unsupported mode - bug\n", info->node);
+		fb_err(info, "unsupported mode - bug\n");
 		return -EINVAL;
 	}
 
@@ -991,27 +990,27 @@ static int s3fb_blank(int blank_mode, struct fb_info *info)
 
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		pr_debug("fb%d: unblank\n", info->node);
+		fb_dbg(info, "unblank\n");
 		svga_wcrt_mask(par->state.vgabase, 0x56, 0x00, 0x06);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x00, 0x20);
 		break;
 	case FB_BLANK_NORMAL:
-		pr_debug("fb%d: blank\n", info->node);
+		fb_dbg(info, "blank\n");
 		svga_wcrt_mask(par->state.vgabase, 0x56, 0x00, 0x06);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		pr_debug("fb%d: hsync\n", info->node);
+		fb_dbg(info, "hsync\n");
 		svga_wcrt_mask(par->state.vgabase, 0x56, 0x02, 0x06);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		pr_debug("fb%d: vsync\n", info->node);
+		fb_dbg(info, "vsync\n");
 		svga_wcrt_mask(par->state.vgabase, 0x56, 0x04, 0x06);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
 	case FB_BLANK_POWERDOWN:
-		pr_debug("fb%d: sync down\n", info->node);
+		fb_dbg(info, "sync down\n");
 		svga_wcrt_mask(par->state.vgabase, 0x56, 0x06, 0x06);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
@@ -1359,13 +1358,16 @@ static int s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto err_reg_fb;
 	}
 
-	printk(KERN_INFO "fb%d: %s on %s, %d MB RAM, %d MHz MCLK\n", info->node, info->fix.id,
-		 pci_name(dev), info->fix.smem_len >> 20, (par->mclk_freq + 500) / 1000);
+	fb_info(info, "%s on %s, %d MB RAM, %d MHz MCLK\n",
+		info->fix.id, pci_name(dev),
+		info->fix.smem_len >> 20, (par->mclk_freq + 500) / 1000);
 
 	if (par->chip == CHIP_UNKNOWN)
-		printk(KERN_INFO "fb%d: unknown chip, CR2D=%x, CR2E=%x, CRT2F=%x, CRT30=%x\n",
-			info->node, vga_rcrt(par->state.vgabase, 0x2d), vga_rcrt(par->state.vgabase, 0x2e),
-			vga_rcrt(par->state.vgabase, 0x2f), vga_rcrt(par->state.vgabase, 0x30));
+		fb_info(info, "unknown chip, CR2D=%x, CR2E=%x, CRT2F=%x, CRT30=%x\n",
+			vga_rcrt(par->state.vgabase, 0x2d),
+			vga_rcrt(par->state.vgabase, 0x2e),
+			vga_rcrt(par->state.vgabase, 0x2f),
+			vga_rcrt(par->state.vgabase, 0x30));
 
 	/* Record a reference to the driver data */
 	pci_set_drvdata(dev, info);
diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index a9ac3ce..bc74d04 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -803,8 +803,8 @@ static int sgivwfb_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, info);
 
-	printk(KERN_INFO "fb%d: SGI DBE frame buffer device, using %ldK of video memory at %#lx\n",      
-		info->node, sgivwfb_mem_size >> 10, sgivwfb_mem_phys);
+	fb_info(info, "SGI DBE frame buffer device, using %ldK of video memory at %#lx\n",
+		sgivwfb_mem_size >> 10, sgivwfb_mem_phys);
 	return 0;
 
 fail_register_framebuffer:
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 977e279..e962879 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -6480,8 +6480,8 @@ error_3:	vfree(ivideo->bios_abase);
 									"disabled");
 
 
-		printk(KERN_INFO "fb%d: %s frame buffer device version %d.%d.%d\n",
-			sis_fb_info->node, ivideo->myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
+		fb_info(sis_fb_info, "%s frame buffer device version %d.%d.%d\n",
+			ivideo->myid, VER_MAJOR, VER_MINOR, VER_LEVEL);
 
 		printk(KERN_INFO "sisfb: Copyright (C) 2001-2005 Thomas Winischhofer\n");
 
diff --git a/drivers/video/skeletonfb.c b/drivers/video/skeletonfb.c
index 2d4694c..fefde7c 100644
--- a/drivers/video/skeletonfb.c
+++ b/drivers/video/skeletonfb.c
@@ -824,8 +824,7 @@ static int xxxfb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	fb_dealloc_cmap(&info->cmap);
 	return -EINVAL;
     }
-    printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
-	   info->fix.id);
+    fb_info(info, "%s frame buffer device\n", info->fix.id);
     pci_set_drvdata(dev, info); /* or platform_set_drvdata(pdev, info) */
     return 0;
 }
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index 9c00026..f0cb279 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -706,10 +706,10 @@ static void sstfb_setvgapass( struct fb_info *info, int enable )
 	fbiinit0 = sst_read (FBIINIT0);
 	if (par->vgapass) {
 		sst_write(FBIINIT0, fbiinit0 & ~DIS_VGA_PASSTHROUGH);
-		printk(KERN_INFO "fb%d: Enabling VGA pass-through\n", info->node );
+		fb_info(info, "Enabling VGA pass-through\n");
 	} else {
 		sst_write(FBIINIT0, fbiinit0 | DIS_VGA_PASSTHROUGH);
-		printk(KERN_INFO "fb%d: Disabling VGA pass-through\n", info->node );
+		fb_info(info, "Disabling VGA pass-through\n");
 	}
 	pci_write_config_dword(sst_dev, PCI_INIT_ENABLE, tmp);
 }
@@ -1437,8 +1437,8 @@ static int sstfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		printk(KERN_WARNING "sstfb: can't create sysfs entry.\n");
 
 
-	printk(KERN_INFO "fb%d: %s frame buffer device at 0x%p\n",
-	       info->node, fix->id, info->screen_base);
+	fb_info(info, "%s frame buffer device at 0x%p\n",
+		fix->id, info->screen_base);
 
 	return 0;
 
diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
index 876648e..a943a7c 100644
--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -1283,9 +1283,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 
 	sti->info = info; /* save for unregister_framebuffer() */
 
-	printk(KERN_INFO 
-	    "fb%d: %s %dx%d-%d frame buffer device, %s, id: %04x, mmio: 0x%04lx\n",
-		fb->info.node, 
+	fb_info(&fb->info, "%s %dx%d-%d frame buffer device, %s, id: %04x, mmio: 0x%04lx\n",
 		fix->id,
 		var->xres, 
 		var->yres,
diff --git a/drivers/video/svgalib.c b/drivers/video/svgalib.c
index 33df9ec..9e01322 100644
--- a/drivers/video/svgalib.c
+++ b/drivers/video/svgalib.c
@@ -198,8 +198,8 @@ void svga_settile(struct fb_info *info, struct fb_tilemap *map)
 
 	if ((map->width != 8) || (map->height != 16) ||
 	    (map->depth != 1) || (map->length != 256)) {
-	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
-			info->node, map->width, map->height, map->depth, map->length);
+		fb_err(info, "unsupported font parameters: width %d, height %d, depth %d, length %d\n",
+		       map->width, map->height, map->depth, map->length);
 		return;
 	}
 
diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index c9c8e5a..f28674f 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -1671,8 +1671,8 @@ static int tgafb_register(struct device *dev)
 	if (tga_bus_tc)
 		pr_info("tgafb: SFB+ detected, rev=0x%02x\n",
 			par->tga_chip_rev);
-	pr_info("fb%d: %s frame buffer device at 0x%lx\n",
-		info->node, info->fix.id, (long)bar0_start);
+	fb_info(info, "%s frame buffer device at 0x%lx\n",
+		info->fix.id, (long)bar0_start);
 
 	return 0;
 
diff --git a/drivers/video/tmiofb.c b/drivers/video/tmiofb.c
index deb8733..1b5063b 100644
--- a/drivers/video/tmiofb.c
+++ b/drivers/video/tmiofb.c
@@ -781,8 +781,7 @@ static int tmiofb_probe(struct platform_device *dev)
 	if (retval < 0)
 		goto err_register_framebuffer;
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-				info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	return 0;
 
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 7aec6f3..46a3c5b 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -1771,13 +1771,11 @@ static int uvesafb_probe(struct platform_device *dev)
 			"using %dk, total %dk\n", info->fix.smem_start,
 			info->screen_base, info->fix.smem_len/1024,
 			par->vbe_ib.total_memory * 64);
-	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
-			info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 
 	err = sysfs_create_group(&dev->dev.kobj, &uvesafb_dev_attgrp);
 	if (err != 0)
-		printk(KERN_WARNING "fb%d: failed to register attributes\n",
-			info->node);
+		fb_warn(info, "failed to register attributes\n");
 
 	return 0;
 
diff --git a/drivers/video/valkyriefb.c b/drivers/video/valkyriefb.c
index 3f5a041..e287ebc 100644
--- a/drivers/video/valkyriefb.c
+++ b/drivers/video/valkyriefb.c
@@ -392,7 +392,7 @@ int __init valkyriefb_init(void)
 	if ((err = register_framebuffer(&p->info)) != 0)
 		goto out_cmap_free;
 
-	printk(KERN_INFO "fb%d: valkyrie frame buffer device\n", p->info.node);
+	fb_info(&p->info, "valkyrie frame buffer device\n");
 	return 0;
 
  out_cmap_free:
diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index bd83233..1c7da3b 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -489,8 +489,7 @@ static int vesafb_probe(struct platform_device *dev)
 		fb_dealloc_cmap(&info->cmap);
 		goto err;
 	}
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-	       info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	return 0;
 err:
 	if (info->screen_base)
diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index ee5985e..c25ff2e 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -527,9 +527,8 @@ static int vfb_probe(struct platform_device *dev)
 		goto err2;
 	platform_set_drvdata(dev, info);
 
-	printk(KERN_INFO
-	       "fb%d: Virtual frame buffer device, using %ldK of video memory\n",
-	       info->node, videomemorysize >> 10);
+	fb_info(info, "Virtual frame buffer device, using %ldK of video memory\n",
+		videomemorysize >> 10);
 	return 0;
 err2:
 	fb_dealloc_cmap(&info->cmap);
diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 2827333..283d335 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1377,8 +1377,7 @@ static int vga16fb_probe(struct platform_device *dev)
 		goto err_check_var;
 	}
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n",
-	       info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	platform_set_drvdata(dev, info);
 
 	return 0;
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index e9557fa..7e97c53 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -266,7 +266,7 @@ static void vt8623_set_pixclock(struct fb_info *info, u32 pixclock)
 
 	rv = svga_compute_pll(&vt8623_pll, 1000000000 / pixclock, &m, &n, &r, info->node);
 	if (rv < 0) {
-		printk(KERN_ERR "fb%d: cannot set requested pixclock, keeping old value\n", info->node);
+		fb_err(info, "cannot set requested pixclock, keeping old value\n");
 		return;
 	}
 
@@ -335,7 +335,7 @@ static int vt8623fb_check_var(struct fb_var_screeninfo *var, struct fb_info *inf
 	rv = svga_match_format (vt8623fb_formats, var, NULL);
 	if (rv < 0)
 	{
-		printk(KERN_ERR "fb%d: unsupported mode requested\n", info->node);
+		fb_err(info, "unsupported mode requested\n");
 		return rv;
 	}
 
@@ -354,21 +354,23 @@ static int vt8623fb_check_var(struct fb_var_screeninfo *var, struct fb_info *inf
 	mem = ((var->bits_per_pixel * var->xres_virtual) >> 3) * var->yres_virtual;
 	if (mem > info->screen_size)
 	{
-		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n", info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));
+		fb_err(info, "not enough framebuffer memory (%d kB requested, %d kB available)\n",
+		       mem >> 10, (unsigned int) (info->screen_size >> 10));
 		return -EINVAL;
 	}
 
 	/* Text mode is limited to 256 kB of memory */
 	if ((var->bits_per_pixel == 0) && (mem > (256*1024)))
 	{
-		printk(KERN_ERR "fb%d: text framebuffer size too large (%d kB requested, 256 kB possible)\n", info->node, mem >> 10);
+		fb_err(info, "text framebuffer size too large (%d kB requested, 256 kB possible)\n",
+		       mem >> 10);
 		return -EINVAL;
 	}
 
 	rv = svga_check_timings (&vt8623_timing_regs, var, info->node);
 	if (rv < 0)
 	{
-		printk(KERN_ERR "fb%d: invalid timings requested\n", info->node);
+		fb_err(info, "invalid timings requested\n");
 		return rv;
 	}
 
@@ -474,32 +476,32 @@ static int vt8623fb_set_par(struct fb_info *info)
 	mode = svga_match_format(vt8623fb_formats, &(info->var), &(info->fix));
 	switch (mode) {
 	case 0:
-		pr_debug("fb%d: text mode\n", info->node);
+		fb_dbg(info, "text mode\n");
 		svga_set_textmode_vga_regs(par->state.vgabase);
 		svga_wseq_mask(par->state.vgabase, 0x15, 0x00, 0xFE);
 		svga_wcrt_mask(par->state.vgabase, 0x11, 0x60, 0x70);
 		break;
 	case 1:
-		pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
+		fb_dbg(info, "4 bit pseudocolor\n");
 		vga_wgfx(par->state.vgabase, VGA_GFX_MODE, 0x40);
 		svga_wseq_mask(par->state.vgabase, 0x15, 0x20, 0xFE);
 		svga_wcrt_mask(par->state.vgabase, 0x11, 0x00, 0x70);
 		break;
 	case 2:
-		pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
+		fb_dbg(info, "4 bit pseudocolor, planar\n");
 		svga_wseq_mask(par->state.vgabase, 0x15, 0x00, 0xFE);
 		svga_wcrt_mask(par->state.vgabase, 0x11, 0x00, 0x70);
 		break;
 	case 3:
-		pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
+		fb_dbg(info, "8 bit pseudocolor\n");
 		svga_wseq_mask(par->state.vgabase, 0x15, 0x22, 0xFE);
 		break;
 	case 4:
-		pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
+		fb_dbg(info, "5/6/5 truecolor\n");
 		svga_wseq_mask(par->state.vgabase, 0x15, 0xB6, 0xFE);
 		break;
 	case 5:
-		pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
+		fb_dbg(info, "8/8/8 truecolor\n");
 		svga_wseq_mask(par->state.vgabase, 0x15, 0xAE, 0xFE);
 		break;
 	default:
@@ -584,27 +586,27 @@ static int vt8623fb_blank(int blank_mode, struct fb_info *info)
 
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		pr_debug("fb%d: unblank\n", info->node);
+		fb_dbg(info, "unblank\n");
 		svga_wcrt_mask(par->state.vgabase, 0x36, 0x00, 0x30);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x00, 0x20);
 		break;
 	case FB_BLANK_NORMAL:
-		pr_debug("fb%d: blank\n", info->node);
+		fb_dbg(info, "blank\n");
 		svga_wcrt_mask(par->state.vgabase, 0x36, 0x00, 0x30);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		pr_debug("fb%d: DPMS standby (hsync off)\n", info->node);
+		fb_dbg(info, "DPMS standby (hsync off)\n");
 		svga_wcrt_mask(par->state.vgabase, 0x36, 0x10, 0x30);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		pr_debug("fb%d: DPMS suspend (vsync off)\n", info->node);
+		fb_dbg(info, "DPMS suspend (vsync off)\n");
 		svga_wcrt_mask(par->state.vgabase, 0x36, 0x20, 0x30);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
 	case FB_BLANK_POWERDOWN:
-		pr_debug("fb%d: DPMS off (no sync)\n", info->node);
+		fb_dbg(info, "DPMS off (no sync)\n");
 		svga_wcrt_mask(par->state.vgabase, 0x36, 0x30, 0x30);
 		svga_wseq_mask(par->state.vgabase, 0x01, 0x20, 0x20);
 		break;
@@ -769,12 +771,12 @@ static int vt8623_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->device, "cannot register framebugger\n");
+		dev_err(info->device, "cannot register framebuffer\n");
 		goto err_reg_fb;
 	}
 
-	printk(KERN_INFO "fb%d: %s on %s, %d MB RAM\n", info->node, info->fix.id,
-		 pci_name(dev), info->fix.smem_len >> 20);
+	fb_info(info, "%s on %s, %d MB RAM\n",
+		info->fix.id, pci_name(dev), info->fix.smem_len >> 20);
 
 	/* Record a reference to the driver data */
 	pci_set_drvdata(dev, info);
diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index 7a299e95..adce4cb 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -761,10 +761,9 @@ int w100fb_probe(struct platform_device *pdev)
 	err |= device_create_file(&pdev->dev, &dev_attr_flip);
 
 	if (err != 0)
-		printk(KERN_WARNING "fb%d: failed to register attributes (%d)\n",
-				info->node, err);
+		fb_warn(info, "failed to register attributes (%d)\n", err);
 
-	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node, info->fix.id);
+	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	return 0;
 out:
 	if (info) {
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 3072f30..fd447b8 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -372,14 +372,12 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	}
 
 	ret = device_create_file(&pdev->dev, &dev_attr_contrast);
-	if (ret < 0) {
-		printk(KERN_WARNING "fb%d: failed to register attributes (%d)\n",
-			fbi->fb.node, ret);
-	}
+	if (ret < 0)
+		fb_warn(&fbi->fb, "failed to register attributes (%d)\n", ret);
 
-	printk(KERN_INFO "fb%d: %s frame buffer at 0x%lx-0x%lx\n",
-	       fbi->fb.node, fbi->fb.fix.id, fbi->fb.fix.smem_start,
-	       fbi->fb.fix.smem_start + fbi->fb.fix.smem_len - 1);
+	fb_info(&fbi->fb, "%s frame buffer at 0x%lx-0x%lx\n",
+		fbi->fb.fix.id, fbi->fb.fix.smem_start,
+		fbi->fb.fix.smem_start + fbi->fb.fix.smem_len - 1);
 
 	return 0;
 }
-- 
1.8.1.2.459.gbcd45b4.dirty


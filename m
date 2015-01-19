Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbbASSAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:00:39 -0500
Received: from mout.web.de ([212.227.15.14]:51510 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbbASSAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:00:36 -0500
Message-ID: <54BD463A.90104@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:00:26 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Antonino Daplas <adaplas@gmail.com>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Hans de Goede <hdegoede@redhat.com>, Helge Deller <deller@gmx.de>,
        "James E. J. Bottomley" <jejb@parisc-linux.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-nvidia@lists.surfsouth.com, linux-parisc@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/9] video: Deletion of checks before the function call "iounmap"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ia6xN8cVszsF10gRjg/2eVQEYtOfM1zyXlYQMoBdVlgdxG4GlRE
 hrwDbFmTxNu0OgMUOQC8UBzqQlnttAmb1bQUD8oKxvxU6GZmyqoiJY3jFjyGtrgGH9cWFww
 pq8o7dtlHb+6lj0KqeUXr7+kuPzQDHlXf8OsmMmeTm5lQ9PK2Emey+/IoUs8F+Y38UwCyeV
 Tt6iAkd8YcoDKDYBdj8yQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 22:45:39 +0100

The iounmap() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/aty/atyfb_base.c   | 15 +++++----------
 drivers/video/fbdev/cirrusfb.c         |  3 +--
 drivers/video/fbdev/controlfb.c        |  6 ++----
 drivers/video/fbdev/efifb.c            |  3 +--
 drivers/video/fbdev/hgafb.c            |  3 +--
 drivers/video/fbdev/hpfb.c             |  3 +--
 drivers/video/fbdev/i810/i810_main.c   |  6 ++----
 drivers/video/fbdev/macfb.c            | 15 +++++----------
 drivers/video/fbdev/offb.c             |  3 +--
 drivers/video/fbdev/pvr2fb.c           |  3 +--
 drivers/video/fbdev/s1d13xxxfb.c       |  3 +--
 drivers/video/fbdev/s3fb.c             |  6 ++----
 drivers/video/fbdev/sh_mobile_hdmi.c   |  6 ++----
 drivers/video/fbdev/sh_mobile_lcdcfb.c |  3 +--
 drivers/video/fbdev/simplefb.c         |  3 +--
 drivers/video/fbdev/stifb.c            |  3 +--
 drivers/video/fbdev/tdfxfb.c           |  6 ++----
 drivers/video/fbdev/tgafb.c            |  3 +--
 drivers/video/fbdev/tridentfb.c        |  6 ++----
 drivers/video/fbdev/valkyriefb.c       |  9 +++------
 drivers/video/fbdev/vesafb.c           |  6 ++----
 drivers/video/fbdev/w100fb.c           |  9 +++------
 22 files changed, 41 insertions(+), 82 deletions(-)

diff --git a/drivers/video/fbdev/aty/atyfb_base.c b/drivers/video/fbdev/aty/atyfb_base.c
index 37ec09b..0f4b147 100644
--- a/drivers/video/fbdev/aty/atyfb_base.c
+++ b/drivers/video/fbdev/aty/atyfb_base.c
@@ -3605,10 +3605,8 @@ err_release_io:
 #ifdef __sparc__
 	kfree(par->mmap_map);
 #else
-	if (par->ati_regbase)
-		iounmap(par->ati_regbase);
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(par->ati_regbase);
+	iounmap(info->screen_base);
 #endif
 err_release_mem:
 	if (par->aux_start)
@@ -3733,13 +3731,10 @@ static void atyfb_remove(struct fb_info *info)
 	}
 #endif
 #ifndef __sparc__
-	if (par->ati_regbase)
-		iounmap(par->ati_regbase);
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(par->ati_regbase);
+	iounmap(info->screen_base);
 #ifdef __BIG_ENDIAN
-	if (info->sprite.addr)
-		iounmap(info->sprite.addr);
+	iounmap(info->sprite.addr);
 #endif
 #endif
 #ifdef __sparc__
diff --git a/drivers/video/fbdev/cirrusfb.c b/drivers/video/fbdev/cirrusfb.c
index d992aa5..d8b3359 100644
--- a/drivers/video/fbdev/cirrusfb.c
+++ b/drivers/video/fbdev/cirrusfb.c
@@ -2164,8 +2164,7 @@ err_release_regions:
 #endif
 	pci_release_regions(pdev);
 err_release_fb:
-	if (cinfo->laguna_mmio != NULL)
-		iounmap(cinfo->laguna_mmio);
+	iounmap(cinfo->laguna_mmio);
 	framebuffer_release(info);
 err_out:
 	return ret;
diff --git a/drivers/video/fbdev/controlfb.c b/drivers/video/fbdev/controlfb.c
index 080fdd2..d386fed 100644
--- a/drivers/video/fbdev/controlfb.c
+++ b/drivers/video/fbdev/controlfb.c
@@ -1068,10 +1068,8 @@ static void control_cleanup(void)
 	if (!p)
 		return;
 
-	if (p->cmap_regs)
-		iounmap(p->cmap_regs);
-	if (p->control_regs)
-		iounmap(p->control_regs);
+	iounmap(p->cmap_regs);
+	iounmap(p->control_regs);
 	if (p->frame_buffer) {
 		if (p->control_use_bank2)
 			p->frame_buffer -= 0x600000;
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 4bfff34..a6d08f0 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -65,8 +65,7 @@ static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
 
 static void efifb_destroy(struct fb_info *info)
 {
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(info->screen_base);
 	if (request_mem_succeeded)
 		release_mem_region(info->apertures->ranges[0].base,
 				   info->apertures->ranges[0].size);
diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index 5ff9fe2..76b231e 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -552,8 +552,7 @@ static int hgafb_probe(struct platform_device *pdev)
 
 	if (! hga_card_detect()) {
 		printk(KERN_INFO "hgafb: HGA card not detected.\n");
-		if (hga_vram)
-			iounmap(hga_vram);
+		iounmap(hga_vram);
 		return -EINVAL;
 	}
 
diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index a1b7e5f..9b47102 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -355,8 +355,7 @@ static void hpfb_remove_one(struct dio_dev *d)
 		iounmap((void *)fb_regs);
 	release_mem_region(d->resource.start, resource_size(&d->resource));
 	fb_dealloc_cmap(&fb_info.cmap);
-	if (fb_info.screen_base)
-		iounmap(fb_info.screen_base);
+	iounmap(fb_info.screen_base);
 }
 
 static struct dio_device_id hpfb_dio_tbl[] = {
diff --git a/drivers/video/fbdev/i810/i810_main.c b/drivers/video/fbdev/i810/i810_main.c
index bb674e4..ce3a585 100644
--- a/drivers/video/fbdev/i810/i810_main.c
+++ b/drivers/video/fbdev/i810/i810_main.c
@@ -2105,10 +2105,8 @@ static void i810fb_release_resource(struct fb_info *info,
 	if (par->i810_gtt.i810_fb_memory)
 		agp_free_memory(gtt->i810_fb_memory);
 
-	if (par->mmio_start_virtual)
-		iounmap(par->mmio_start_virtual);
-	if (par->aperture.virtual)
-		iounmap(par->aperture.virtual);
+	iounmap(par->mmio_start_virtual);
+	iounmap(par->aperture.virtual);
 	kfree(par->edid);
 	if (par->res_flags & FRAMEBUFFER_REQ)
 		release_mem_region(par->aperture.physical,
diff --git a/drivers/video/fbdev/macfb.c b/drivers/video/fbdev/macfb.c
index cda7587..dde0520 100644
--- a/drivers/video/fbdev/macfb.c
+++ b/drivers/video/fbdev/macfb.c
@@ -541,16 +541,11 @@ static void __init macfb_setup(char *options)
 
 static void __init iounmap_macfb(void)
 {
-	if (dafb_cmap_regs)
-		iounmap(dafb_cmap_regs);
-	if (v8_brazil_cmap_regs)
-		iounmap(v8_brazil_cmap_regs);
-	if (rbv_cmap_regs)
-		iounmap(rbv_cmap_regs);
-	if (civic_cmap_regs)
-		iounmap(civic_cmap_regs);
-	if (csc_cmap_regs)
-		iounmap(csc_cmap_regs);
+	iounmap(dafb_cmap_regs);
+	iounmap(v8_brazil_cmap_regs);
+	iounmap(rbv_cmap_regs);
+	iounmap(civic_cmap_regs);
+	iounmap(csc_cmap_regs);
 }
 
 static int __init macfb_init(void)
diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
index 43a0a52..5efce99 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -281,8 +281,7 @@ static int offb_set_par(struct fb_info *info)
 
 static void offb_destroy(struct fb_info *info)
 {
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(info->screen_base);
 	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
 	framebuffer_release(info);
 }
diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 7c74f58..7aa4ef1 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -841,8 +841,7 @@ static int pvr2fb_common_init(void)
 	return 0;
 
 out_err:
-	if (fb_info->screen_base)
-		iounmap(fb_info->screen_base);
+	iounmap(fb_info->screen_base);
 	if (par->mmio_base)
 		iounmap((void *)par->mmio_base);
 
diff --git a/drivers/video/fbdev/s1d13xxxfb.c b/drivers/video/fbdev/s1d13xxxfb.c
index 83433cb..dff38b7 100644
--- a/drivers/video/fbdev/s1d13xxxfb.c
+++ b/drivers/video/fbdev/s1d13xxxfb.c
@@ -750,8 +750,7 @@ s1d13xxxfb_remove(struct platform_device *pdev)
 
 		fb_dealloc_cmap(&info->cmap);
 
-		if (info->screen_base)
-			iounmap(info->screen_base);
+		iounmap(info->screen_base);
 
 		framebuffer_release(info);
 	}
diff --git a/drivers/video/fbdev/s3fb.c b/drivers/video/fbdev/s3fb.c
index f0ae61a..3d9d45f 100644
--- a/drivers/video/fbdev/s3fb.c
+++ b/drivers/video/fbdev/s3fb.c
@@ -1382,8 +1382,7 @@ err_find_mode:
 #ifdef CONFIG_FB_S3_DDC
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
-	if (par->mmio)
-		iounmap(par->mmio);
+	iounmap(par->mmio);
 #endif
 	pci_iounmap(dev, info->screen_base);
 err_iomap:
@@ -1419,8 +1418,7 @@ static void s3_pci_remove(struct pci_dev *dev)
 #ifdef CONFIG_FB_S3_DDC
 		if (par->ddc_registered)
 			i2c_del_adapter(&par->ddc_adapter);
-		if (par->mmio)
-			iounmap(par->mmio);
+		iounmap(par->mmio);
 #endif
 
 		pci_iounmap(dev, info->screen_base);
diff --git a/drivers/video/fbdev/sh_mobile_hdmi.c b/drivers/video/fbdev/sh_mobile_hdmi.c
index 7c72a3f..2a7187d 100644
--- a/drivers/video/fbdev/sh_mobile_hdmi.c
+++ b/drivers/video/fbdev/sh_mobile_hdmi.c
@@ -1397,8 +1397,7 @@ static int __init sh_hdmi_probe(struct platform_device *pdev)
 ecodec:
 	free_irq(irq, hdmi);
 ereqirq:
-	if (hdmi->htop1)
-		iounmap(hdmi->htop1);
+	iounmap(hdmi->htop1);
 emap_htop1:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -1428,8 +1427,7 @@ static int __exit sh_hdmi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(hdmi->hdmi_clk);
 	clk_put(hdmi->hdmi_clk);
-	if (hdmi->htop1)
-		iounmap(hdmi->htop1);
+	iounmap(hdmi->htop1);
 	iounmap(hdmi->base);
 	release_mem_region(res->start, resource_size(res));
 
diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
index d3013cd..4f9a25b 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -2489,8 +2489,7 @@ static int sh_mobile_lcdc_remove(struct platform_device *pdev)
 		clk_put(priv->dot_clk);
 	}
 
-	if (priv->base)
-		iounmap(priv->base);
+	iounmap(priv->base);
 
 	if (priv->irq)
 		free_irq(priv->irq, priv);
diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index 92cac80..40e6b33 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -72,8 +72,7 @@ static int simplefb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 
 static void simplefb_destroy(struct fb_info *info)
 {
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(info->screen_base);
 }
 
 static struct fb_ops simplefb_ops = {
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 86621fa..ea12305 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1374,8 +1374,7 @@ stifb_cleanup(void)
 			unregister_framebuffer(sti->info);
 			release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 		        release_mem_region(info->fix.smem_start, info->fix.smem_len);
-				if (info->screen_base)
-					iounmap(info->screen_base);
+				iounmap(info->screen_base);
 		        fb_dealloc_cmap(&info->cmap);
 		        framebuffer_release(info);
 		}
diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index f761fe3..69d4062 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1572,15 +1572,13 @@ out_err_iobase:
 	release_region(pci_resource_start(pdev, 2),
 		       pci_resource_len(pdev, 2));
 out_err_screenbase:
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(info->screen_base);
 	release_mem_region(info->fix.smem_start, pci_resource_len(pdev, 1));
 out_err_regbase:
 	/*
 	 * Cleanup after anything that was remapped/allocated.
 	 */
-	if (default_par->regbase_virt)
-		iounmap(default_par->regbase_virt);
+	iounmap(default_par->regbase_virt);
 	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 out_err:
 	framebuffer_release(info);
diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index 65ba992..b6fb7e8 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -1520,8 +1520,7 @@ static int tgafb_register(struct device *dev)
  err2:
 	fb_dealloc_cmap(&info->cmap);
  err1:
-	if (mem_base)
-		iounmap(mem_base);
+	iounmap(mem_base);
 	release_mem_region(bar0_start, bar0_len);
  err0:
 	framebuffer_release(info);
diff --git a/drivers/video/fbdev/tridentfb.c b/drivers/video/fbdev/tridentfb.c
index 7ed9a22..71567401 100644
--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -1531,13 +1531,11 @@ static int trident_pci_probe(struct pci_dev *dev,
 
 out_unmap2:
 	kfree(info->pixmap.addr);
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(info->screen_base);
 	release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
 	disable_mmio(info->par);
 out_unmap1:
-	if (default_par->io_virt)
-		iounmap(default_par->io_virt);
+	iounmap(default_par->io_virt);
 	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 	framebuffer_release(info);
 	return err;
diff --git a/drivers/video/fbdev/valkyriefb.c b/drivers/video/fbdev/valkyriefb.c
index 275fb98..2a9213b 100644
--- a/drivers/video/fbdev/valkyriefb.c
+++ b/drivers/video/fbdev/valkyriefb.c
@@ -400,12 +400,9 @@ int __init valkyriefb_init(void)
  out_cmap_free:
 	fb_dealloc_cmap(&p->info.cmap);
  out_free:
-	if (p->frame_buffer)
-		iounmap(p->frame_buffer);
-	if (p->cmap_regs)
-		iounmap(p->cmap_regs);
-	if (p->valkyrie_regs)
-		iounmap(p->valkyrie_regs);
+	iounmap(p->frame_buffer);
+	iounmap(p->cmap_regs);
+	iounmap(p->valkyrie_regs);
 	kfree(p);
 	return err;
 }
diff --git a/drivers/video/fbdev/vesafb.c b/drivers/video/fbdev/vesafb.c
index d79a0ac..693d18e 100644
--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -176,8 +176,7 @@ static int vesafb_setcolreg(unsigned regno, unsigned red, unsigned green,
 static void vesafb_destroy(struct fb_info *info)
 {
 	fb_dealloc_cmap(&info->cmap);
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(info->screen_base);
 	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
 }
 
@@ -492,8 +491,7 @@ static int vesafb_probe(struct platform_device *dev)
 	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	return 0;
 err:
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	iounmap(info->screen_base);
 	framebuffer_release(info);
 	release_mem_region(vesafb_fix.smem_start, size_total);
 	return err;
diff --git a/drivers/video/fbdev/w100fb.c b/drivers/video/fbdev/w100fb.c
index 10951c8..aeb53eb 100644
--- a/drivers/video/fbdev/w100fb.c
+++ b/drivers/video/fbdev/w100fb.c
@@ -770,12 +770,9 @@ out:
 		fb_dealloc_cmap(&info->cmap);
 		kfree(info->pseudo_palette);
 	}
-	if (remapped_fbuf != NULL)
-		iounmap(remapped_fbuf);
-	if (remapped_regs != NULL)
-		iounmap(remapped_regs);
-	if (remapped_base != NULL)
-		iounmap(remapped_base);
+	iounmap(remapped_fbuf);
+	iounmap(remapped_regs);
+	iounmap(remapped_base);
 	if (info)
 		framebuffer_release(info);
 	return err;
-- 
2.2.2


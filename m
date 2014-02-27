Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaB0L4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:56:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37010 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaB0Lzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:55:46 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 1/3] video: move fbdev to drivers/video/fbdev
Date: Thu, 27 Feb 2014 13:54:44 +0200
Message-ID: <1393502086-9433-2-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
References: <1393502086-9433-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers/video directory is a mess. It contains generic video related
files, directories for backlight, console, linux logo, lots of fbdev
device drivers, fbdev framework files.

Make some order into the chaos by creating drivers/video/fbdev
directory, and move all fbdev related files there.

No functionality is changed, although I guess it is possible that some
subtle Makefile build order related issue could be created by this
patch.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Rob Clark <robdclark@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/Makefile                                   |    4 +-
 drivers/video/Kconfig                              | 2483 +-------------------
 drivers/video/Makefile                             |  168 +-
 drivers/video/{ => fbdev}/68328fb.c                |    0
 drivers/video/fbdev/Kconfig                        | 2481 +++++++++++++++++++
 drivers/video/fbdev/Makefile                       |  167 ++
 drivers/video/{ => fbdev}/acornfb.c                |    0
 drivers/video/{ => fbdev}/acornfb.h                |    0
 drivers/video/{ => fbdev}/amba-clcd.c              |    0
 drivers/video/{ => fbdev}/amifb.c                  |    0
 drivers/video/{ => fbdev}/arcfb.c                  |    0
 drivers/video/{ => fbdev}/arkfb.c                  |    0
 drivers/video/{ => fbdev}/asiliantfb.c             |    0
 drivers/video/{ => fbdev}/atafb.c                  |    0
 drivers/video/{ => fbdev}/atafb.h                  |    0
 drivers/video/{ => fbdev}/atafb_iplan2p2.c         |    0
 drivers/video/{ => fbdev}/atafb_iplan2p4.c         |    0
 drivers/video/{ => fbdev}/atafb_iplan2p8.c         |    0
 drivers/video/{ => fbdev}/atafb_mfb.c              |    0
 drivers/video/{ => fbdev}/atafb_utils.h            |    0
 drivers/video/{ => fbdev}/atmel_lcdfb.c            |    0
 drivers/video/{ => fbdev}/aty/Makefile             |    0
 drivers/video/{ => fbdev}/aty/ati_ids.h            |    0
 drivers/video/{ => fbdev}/aty/aty128fb.c           |    0
 drivers/video/{ => fbdev}/aty/atyfb.h              |    0
 drivers/video/{ => fbdev}/aty/atyfb_base.c         |    0
 drivers/video/{ => fbdev}/aty/mach64_accel.c       |    0
 drivers/video/{ => fbdev}/aty/mach64_ct.c          |    0
 drivers/video/{ => fbdev}/aty/mach64_cursor.c      |    0
 drivers/video/{ => fbdev}/aty/mach64_gx.c          |    0
 drivers/video/{ => fbdev}/aty/radeon_accel.c       |    0
 drivers/video/{ => fbdev}/aty/radeon_backlight.c   |    0
 drivers/video/{ => fbdev}/aty/radeon_base.c        |    0
 drivers/video/{ => fbdev}/aty/radeon_i2c.c         |    0
 drivers/video/{ => fbdev}/aty/radeon_monitor.c     |    0
 drivers/video/{ => fbdev}/aty/radeon_pm.c          |    0
 drivers/video/{ => fbdev}/aty/radeonfb.h           |    0
 drivers/video/{ => fbdev}/au1100fb.c               |    0
 drivers/video/{ => fbdev}/au1100fb.h               |    0
 drivers/video/{ => fbdev}/au1200fb.c               |    0
 drivers/video/{ => fbdev}/au1200fb.h               |    0
 drivers/video/{ => fbdev}/auo_k1900fb.c            |    0
 drivers/video/{ => fbdev}/auo_k1901fb.c            |    0
 drivers/video/{ => fbdev}/auo_k190x.c              |    0
 drivers/video/{ => fbdev}/auo_k190x.h              |    0
 drivers/video/{ => fbdev}/bf537-lq035.c            |    0
 drivers/video/{ => fbdev}/bf54x-lq043fb.c          |    0
 drivers/video/{ => fbdev}/bfin-lq035q1-fb.c        |    0
 drivers/video/{ => fbdev}/bfin-t350mcqb-fb.c       |    0
 drivers/video/{ => fbdev}/bfin_adv7393fb.c         |    0
 drivers/video/{ => fbdev}/bfin_adv7393fb.h         |    0
 drivers/video/{ => fbdev}/broadsheetfb.c           |    0
 drivers/video/{ => fbdev}/bt431.h                  |    0
 drivers/video/{ => fbdev}/bt455.h                  |    0
 drivers/video/{ => fbdev}/bw2.c                    |    0
 drivers/video/{ => fbdev}/c2p.h                    |    0
 drivers/video/{ => fbdev}/c2p_core.h               |    0
 drivers/video/{ => fbdev}/c2p_iplan2.c             |    0
 drivers/video/{ => fbdev}/c2p_planar.c             |    0
 drivers/video/{ => fbdev}/carminefb.c              |    0
 drivers/video/{ => fbdev}/carminefb.h              |    0
 drivers/video/{ => fbdev}/carminefb_regs.h         |    0
 drivers/video/{ => fbdev}/cfbcopyarea.c            |    0
 drivers/video/{ => fbdev}/cfbfillrect.c            |    0
 drivers/video/{ => fbdev}/cfbimgblt.c              |    0
 drivers/video/{ => fbdev}/cg14.c                   |    0
 drivers/video/{ => fbdev}/cg3.c                    |    0
 drivers/video/{ => fbdev}/cg6.c                    |    0
 drivers/video/{ => fbdev}/chipsfb.c                |    0
 drivers/video/{ => fbdev}/cirrusfb.c               |    0
 drivers/video/{ => fbdev}/clps711xfb.c             |    0
 drivers/video/{ => fbdev}/cobalt_lcdfb.c           |    0
 drivers/video/{ => fbdev}/controlfb.c              |    0
 drivers/video/{ => fbdev}/controlfb.h              |    0
 drivers/video/{ => fbdev}/cyber2000fb.c            |    0
 drivers/video/{ => fbdev}/cyber2000fb.h            |    0
 drivers/video/{ => fbdev}/da8xx-fb.c               |    0
 drivers/video/{ => fbdev}/dnfb.c                   |    0
 drivers/video/{ => fbdev}/edid.h                   |    0
 drivers/video/{ => fbdev}/efifb.c                  |    0
 drivers/video/{ => fbdev}/ep93xx-fb.c              |    0
 drivers/video/{ => fbdev}/exynos/Kconfig           |    0
 drivers/video/{ => fbdev}/exynos/Makefile          |    0
 drivers/video/{ => fbdev}/exynos/exynos_dp_core.c  |    0
 drivers/video/{ => fbdev}/exynos/exynos_dp_core.h  |    0
 drivers/video/{ => fbdev}/exynos/exynos_dp_reg.c   |    0
 drivers/video/{ => fbdev}/exynos/exynos_dp_reg.h   |    0
 drivers/video/{ => fbdev}/exynos/exynos_mipi_dsi.c |    0
 .../{ => fbdev}/exynos/exynos_mipi_dsi_common.c    |    0
 .../{ => fbdev}/exynos/exynos_mipi_dsi_common.h    |    0
 .../{ => fbdev}/exynos/exynos_mipi_dsi_lowlevel.c  |    0
 .../{ => fbdev}/exynos/exynos_mipi_dsi_lowlevel.h  |    0
 .../{ => fbdev}/exynos/exynos_mipi_dsi_regs.h      |    0
 drivers/video/{ => fbdev}/exynos/s6e8ax0.c         |    0
 drivers/video/{ => fbdev}/fb-puv3.c                |    0
 drivers/video/{ => fbdev}/fb_ddc.c                 |    0
 drivers/video/{ => fbdev}/fb_defio.c               |    0
 drivers/video/{ => fbdev}/fb_draw.h                |    0
 drivers/video/{ => fbdev}/fb_notify.c              |    0
 drivers/video/{ => fbdev}/fb_sys_fops.c            |    0
 drivers/video/{ => fbdev}/fbcmap.c                 |    0
 drivers/video/{ => fbdev}/fbcvt.c                  |    0
 drivers/video/{ => fbdev}/fbmem.c                  |    0
 drivers/video/{ => fbdev}/fbmon.c                  |    0
 drivers/video/{ => fbdev}/fbsysfs.c                |    0
 drivers/video/{ => fbdev}/ffb.c                    |    0
 drivers/video/{ => fbdev}/fm2fb.c                  |    0
 drivers/video/{ => fbdev}/fsl-diu-fb.c             |    0
 drivers/video/{ => fbdev}/g364fb.c                 |    0
 drivers/video/{ => fbdev}/gbefb.c                  |    0
 drivers/video/{ => fbdev}/geode/Kconfig            |    0
 drivers/video/{ => fbdev}/geode/Makefile           |    0
 drivers/video/{ => fbdev}/geode/display_gx.c       |    0
 drivers/video/{ => fbdev}/geode/display_gx1.c      |    0
 drivers/video/{ => fbdev}/geode/display_gx1.h      |    0
 drivers/video/{ => fbdev}/geode/geodefb.h          |    0
 drivers/video/{ => fbdev}/geode/gx1fb_core.c       |    0
 drivers/video/{ => fbdev}/geode/gxfb.h             |    0
 drivers/video/{ => fbdev}/geode/gxfb_core.c        |    0
 drivers/video/{ => fbdev}/geode/lxfb.h             |    0
 drivers/video/{ => fbdev}/geode/lxfb_core.c        |    0
 drivers/video/{ => fbdev}/geode/lxfb_ops.c         |    0
 drivers/video/{ => fbdev}/geode/suspend_gx.c       |    0
 drivers/video/{ => fbdev}/geode/video_cs5530.c     |    0
 drivers/video/{ => fbdev}/geode/video_cs5530.h     |    0
 drivers/video/{ => fbdev}/geode/video_gx.c         |    0
 drivers/video/{ => fbdev}/goldfishfb.c             |    0
 drivers/video/{ => fbdev}/grvga.c                  |    0
 drivers/video/{ => fbdev}/gxt4500.c                |    0
 drivers/video/{ => fbdev}/hecubafb.c               |    0
 drivers/video/{ => fbdev}/hgafb.c                  |    0
 drivers/video/{ => fbdev}/hitfb.c                  |    0
 drivers/video/{ => fbdev}/hpfb.c                   |    0
 drivers/video/{ => fbdev}/hyperv_fb.c              |    0
 drivers/video/{ => fbdev}/i740_reg.h               |    0
 drivers/video/{ => fbdev}/i740fb.c                 |    0
 drivers/video/{ => fbdev}/i810/Makefile            |    0
 drivers/video/{ => fbdev}/i810/i810-i2c.c          |    0
 drivers/video/{ => fbdev}/i810/i810.h              |    0
 drivers/video/{ => fbdev}/i810/i810_accel.c        |    0
 drivers/video/{ => fbdev}/i810/i810_dvt.c          |    0
 drivers/video/{ => fbdev}/i810/i810_gtf.c          |    0
 drivers/video/{ => fbdev}/i810/i810_main.c         |    0
 drivers/video/{ => fbdev}/i810/i810_main.h         |    0
 drivers/video/{ => fbdev}/i810/i810_regs.h         |    0
 drivers/video/{ => fbdev}/igafb.c                  |    0
 drivers/video/{ => fbdev}/imsttfb.c                |    0
 drivers/video/{ => fbdev}/imxfb.c                  |    0
 drivers/video/{ => fbdev}/intelfb/Makefile         |    0
 drivers/video/{ => fbdev}/intelfb/intelfb.h        |    0
 drivers/video/{ => fbdev}/intelfb/intelfb_i2c.c    |    0
 drivers/video/{ => fbdev}/intelfb/intelfbdrv.c     |    0
 drivers/video/{ => fbdev}/intelfb/intelfbhw.c      |    0
 drivers/video/{ => fbdev}/intelfb/intelfbhw.h      |    0
 drivers/video/{ => fbdev}/jz4740_fb.c              |    0
 drivers/video/{ => fbdev}/kyro/Makefile            |    0
 drivers/video/{ => fbdev}/kyro/STG4000InitDevice.c |    0
 drivers/video/{ => fbdev}/kyro/STG4000Interface.h  |    0
 .../video/{ => fbdev}/kyro/STG4000OverlayDevice.c  |    0
 drivers/video/{ => fbdev}/kyro/STG4000Ramdac.c     |    0
 drivers/video/{ => fbdev}/kyro/STG4000Reg.h        |    0
 drivers/video/{ => fbdev}/kyro/STG4000VTG.c        |    0
 drivers/video/{ => fbdev}/kyro/fbdev.c             |    0
 drivers/video/{ => fbdev}/leo.c                    |    0
 drivers/video/{ => fbdev}/macfb.c                  |    0
 drivers/video/{ => fbdev}/macmodes.c               |    0
 drivers/video/{ => fbdev}/macmodes.h               |    0
 drivers/video/{ => fbdev}/matrox/Makefile          |    0
 drivers/video/{ => fbdev}/matrox/g450_pll.c        |    0
 drivers/video/{ => fbdev}/matrox/g450_pll.h        |    0
 drivers/video/{ => fbdev}/matrox/i2c-matroxfb.c    |    0
 .../video/{ => fbdev}/matrox/matroxfb_DAC1064.c    |    0
 .../video/{ => fbdev}/matrox/matroxfb_DAC1064.h    |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_Ti3026.c |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_Ti3026.h |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_accel.c  |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_accel.h  |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_base.c   |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_base.h   |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_crtc2.c  |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_crtc2.h  |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_g450.c   |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_g450.h   |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_maven.c  |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_maven.h  |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_misc.c   |    0
 drivers/video/{ => fbdev}/matrox/matroxfb_misc.h   |    0
 drivers/video/{ => fbdev}/maxinefb.c               |    0
 drivers/video/{ => fbdev}/mb862xx/Makefile         |    0
 drivers/video/{ => fbdev}/mb862xx/mb862xx-i2c.c    |    0
 drivers/video/{ => fbdev}/mb862xx/mb862xx_reg.h    |    0
 drivers/video/{ => fbdev}/mb862xx/mb862xxfb.h      |    0
 .../video/{ => fbdev}/mb862xx/mb862xxfb_accel.c    |    0
 .../video/{ => fbdev}/mb862xx/mb862xxfb_accel.h    |    0
 drivers/video/{ => fbdev}/mb862xx/mb862xxfbdrv.c   |    0
 drivers/video/{ => fbdev}/mbx/Makefile             |    0
 drivers/video/{ => fbdev}/mbx/mbxdebugfs.c         |    0
 drivers/video/{ => fbdev}/mbx/mbxfb.c              |    0
 drivers/video/{ => fbdev}/mbx/reg_bits.h           |    0
 drivers/video/{ => fbdev}/mbx/regs.h               |    0
 drivers/video/{ => fbdev}/metronomefb.c            |    0
 drivers/video/{ => fbdev}/mmp/Kconfig              |    6 +-
 drivers/video/{ => fbdev}/mmp/Makefile             |    0
 drivers/video/{ => fbdev}/mmp/core.c               |    0
 drivers/video/{ => fbdev}/mmp/fb/Kconfig           |    0
 drivers/video/{ => fbdev}/mmp/fb/Makefile          |    0
 drivers/video/{ => fbdev}/mmp/fb/mmpfb.c           |    0
 drivers/video/{ => fbdev}/mmp/fb/mmpfb.h           |    0
 drivers/video/{ => fbdev}/mmp/hw/Kconfig           |    0
 drivers/video/{ => fbdev}/mmp/hw/Makefile          |    0
 drivers/video/{ => fbdev}/mmp/hw/mmp_ctrl.c        |    0
 drivers/video/{ => fbdev}/mmp/hw/mmp_ctrl.h        |    0
 drivers/video/{ => fbdev}/mmp/hw/mmp_spi.c         |    0
 drivers/video/{ => fbdev}/mmp/panel/Kconfig        |    0
 drivers/video/{ => fbdev}/mmp/panel/Makefile       |    0
 .../video/{ => fbdev}/mmp/panel/tpo_tj032md01bw.c  |    0
 drivers/video/{ => fbdev}/modedb.c                 |    0
 drivers/video/{ => fbdev}/msm/Makefile             |    0
 drivers/video/{ => fbdev}/msm/mddi.c               |    0
 drivers/video/{ => fbdev}/msm/mddi_client_dummy.c  |    0
 .../video/{ => fbdev}/msm/mddi_client_nt35399.c    |    0
 .../video/{ => fbdev}/msm/mddi_client_toshiba.c    |    0
 drivers/video/{ => fbdev}/msm/mddi_hw.h            |    0
 drivers/video/{ => fbdev}/msm/mdp.c                |    0
 drivers/video/{ => fbdev}/msm/mdp_csc_table.h      |    0
 drivers/video/{ => fbdev}/msm/mdp_hw.h             |    0
 drivers/video/{ => fbdev}/msm/mdp_ppp.c            |    0
 drivers/video/{ => fbdev}/msm/mdp_scale_tables.c   |    0
 drivers/video/{ => fbdev}/msm/mdp_scale_tables.h   |    0
 drivers/video/{ => fbdev}/msm/msm_fb.c             |    0
 drivers/video/{ => fbdev}/mx3fb.c                  |    0
 drivers/video/{ => fbdev}/mxsfb.c                  |    0
 drivers/video/{ => fbdev}/n411.c                   |    0
 drivers/video/{ => fbdev}/neofb.c                  |    0
 drivers/video/{ => fbdev}/nuc900fb.c               |    0
 drivers/video/{ => fbdev}/nuc900fb.h               |    0
 drivers/video/{ => fbdev}/nvidia/Makefile          |    0
 drivers/video/{ => fbdev}/nvidia/nv_accel.c        |    0
 drivers/video/{ => fbdev}/nvidia/nv_backlight.c    |    0
 drivers/video/{ => fbdev}/nvidia/nv_dma.h          |    0
 drivers/video/{ => fbdev}/nvidia/nv_hw.c           |    0
 drivers/video/{ => fbdev}/nvidia/nv_i2c.c          |    0
 drivers/video/{ => fbdev}/nvidia/nv_local.h        |    0
 drivers/video/{ => fbdev}/nvidia/nv_of.c           |    0
 drivers/video/{ => fbdev}/nvidia/nv_proto.h        |    0
 drivers/video/{ => fbdev}/nvidia/nv_setup.c        |    0
 drivers/video/{ => fbdev}/nvidia/nv_type.h         |    0
 drivers/video/{ => fbdev}/nvidia/nvidia.c          |    0
 drivers/video/{ => fbdev}/ocfb.c                   |    0
 drivers/video/{ => fbdev}/offb.c                   |    0
 drivers/video/{ => fbdev}/omap/Kconfig             |    0
 drivers/video/{ => fbdev}/omap/Makefile            |    0
 drivers/video/{ => fbdev}/omap/hwa742.c            |    0
 drivers/video/{ => fbdev}/omap/lcd_ams_delta.c     |    0
 drivers/video/{ => fbdev}/omap/lcd_h3.c            |    0
 drivers/video/{ => fbdev}/omap/lcd_htcherald.c     |    0
 drivers/video/{ => fbdev}/omap/lcd_inn1510.c       |    0
 drivers/video/{ => fbdev}/omap/lcd_inn1610.c       |    0
 drivers/video/{ => fbdev}/omap/lcd_mipid.c         |    0
 drivers/video/{ => fbdev}/omap/lcd_osk.c           |    0
 drivers/video/{ => fbdev}/omap/lcd_palmte.c        |    0
 drivers/video/{ => fbdev}/omap/lcd_palmtt.c        |    0
 drivers/video/{ => fbdev}/omap/lcd_palmz71.c       |    0
 drivers/video/{ => fbdev}/omap/lcdc.c              |    0
 drivers/video/{ => fbdev}/omap/lcdc.h              |    0
 drivers/video/{ => fbdev}/omap/omapfb.h            |    0
 drivers/video/{ => fbdev}/omap/omapfb_main.c       |    0
 drivers/video/{ => fbdev}/omap/sossi.c             |    0
 drivers/video/fbdev/omap2/Kconfig                  |   10 +
 drivers/video/{ => fbdev}/omap2/Makefile           |    0
 .../video/{ => fbdev}/omap2/displays-new/Kconfig   |    0
 .../video/{ => fbdev}/omap2/displays-new/Makefile  |    0
 .../omap2/displays-new/connector-analog-tv.c       |    0
 .../{ => fbdev}/omap2/displays-new/connector-dvi.c |    0
 .../omap2/displays-new/connector-hdmi.c            |    0
 .../omap2/displays-new/encoder-tfp410.c            |    0
 .../omap2/displays-new/encoder-tpd12s015.c         |    0
 .../{ => fbdev}/omap2/displays-new/panel-dpi.c     |    0
 .../{ => fbdev}/omap2/displays-new/panel-dsi-cm.c  |    0
 .../omap2/displays-new/panel-lgphilips-lb035q02.c  |    0
 .../omap2/displays-new/panel-nec-nl8048hl11.c      |    0
 .../omap2/displays-new/panel-sharp-ls037v7dw01.c   |    0
 .../omap2/displays-new/panel-sony-acx565akm.c      |    0
 .../omap2/displays-new/panel-tpo-td028ttec1.c      |    0
 .../omap2/displays-new/panel-tpo-td043mtea1.c      |    0
 drivers/video/{ => fbdev}/omap2/dss/Kconfig        |    0
 drivers/video/{ => fbdev}/omap2/dss/Makefile       |    0
 drivers/video/{ => fbdev}/omap2/dss/apply.c        |    0
 drivers/video/{ => fbdev}/omap2/dss/core.c         |    0
 drivers/video/{ => fbdev}/omap2/dss/dispc-compat.c |    0
 drivers/video/{ => fbdev}/omap2/dss/dispc-compat.h |    0
 drivers/video/{ => fbdev}/omap2/dss/dispc.c        |    0
 drivers/video/{ => fbdev}/omap2/dss/dispc.h        |    0
 drivers/video/{ => fbdev}/omap2/dss/dispc_coefs.c  |    0
 .../video/{ => fbdev}/omap2/dss/display-sysfs.c    |    0
 drivers/video/{ => fbdev}/omap2/dss/display.c      |    0
 drivers/video/{ => fbdev}/omap2/dss/dpi.c          |    0
 drivers/video/{ => fbdev}/omap2/dss/dsi.c          |    0
 drivers/video/{ => fbdev}/omap2/dss/dss.c          |    0
 drivers/video/{ => fbdev}/omap2/dss/dss.h          |    0
 drivers/video/{ => fbdev}/omap2/dss/dss_features.c |    0
 drivers/video/{ => fbdev}/omap2/dss/dss_features.h |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi.h         |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi4.c        |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi4_core.c   |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi4_core.h   |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi_common.c  |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi_phy.c     |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi_pll.c     |    0
 drivers/video/{ => fbdev}/omap2/dss/hdmi_wp.c      |    0
 .../video/{ => fbdev}/omap2/dss/manager-sysfs.c    |    0
 drivers/video/{ => fbdev}/omap2/dss/manager.c      |    0
 drivers/video/{ => fbdev}/omap2/dss/output.c       |    0
 .../video/{ => fbdev}/omap2/dss/overlay-sysfs.c    |    0
 drivers/video/{ => fbdev}/omap2/dss/overlay.c      |    0
 drivers/video/{ => fbdev}/omap2/dss/rfbi.c         |    0
 drivers/video/{ => fbdev}/omap2/dss/sdi.c          |    0
 drivers/video/{ => fbdev}/omap2/dss/venc.c         |    0
 drivers/video/{ => fbdev}/omap2/dss/venc_panel.c   |    0
 drivers/video/{ => fbdev}/omap2/omapfb/Kconfig     |    0
 drivers/video/{ => fbdev}/omap2/omapfb/Makefile    |    0
 .../video/{ => fbdev}/omap2/omapfb/omapfb-ioctl.c  |    0
 .../video/{ => fbdev}/omap2/omapfb/omapfb-main.c   |    0
 .../video/{ => fbdev}/omap2/omapfb/omapfb-sysfs.c  |    0
 drivers/video/{ => fbdev}/omap2/omapfb/omapfb.h    |    0
 drivers/video/{ => fbdev}/omap2/vrfb.c             |    0
 drivers/video/{ => fbdev}/p9100.c                  |    0
 drivers/video/{ => fbdev}/platinumfb.c             |    0
 drivers/video/{ => fbdev}/platinumfb.h             |    0
 drivers/video/{ => fbdev}/pm2fb.c                  |    0
 drivers/video/{ => fbdev}/pm3fb.c                  |    0
 drivers/video/{ => fbdev}/pmag-aa-fb.c             |    0
 drivers/video/{ => fbdev}/pmag-ba-fb.c             |    0
 drivers/video/{ => fbdev}/pmagb-b-fb.c             |    0
 drivers/video/{ => fbdev}/ps3fb.c                  |    0
 drivers/video/{ => fbdev}/pvr2fb.c                 |    0
 drivers/video/{ => fbdev}/pxa168fb.c               |    0
 drivers/video/{ => fbdev}/pxa168fb.h               |    0
 drivers/video/{ => fbdev}/pxa3xx-gcu.c             |    0
 drivers/video/{ => fbdev}/pxa3xx-gcu.h             |    0
 drivers/video/{ => fbdev}/pxafb.c                  |    0
 drivers/video/{ => fbdev}/pxafb.h                  |    0
 drivers/video/{ => fbdev}/q40fb.c                  |    0
 drivers/video/{ => fbdev}/riva/Makefile            |    0
 drivers/video/{ => fbdev}/riva/fbdev.c             |    0
 drivers/video/{ => fbdev}/riva/nv_driver.c         |    0
 drivers/video/{ => fbdev}/riva/nv_type.h           |    0
 drivers/video/{ => fbdev}/riva/nvreg.h             |    0
 drivers/video/{ => fbdev}/riva/riva_hw.c           |    0
 drivers/video/{ => fbdev}/riva/riva_hw.h           |    0
 drivers/video/{ => fbdev}/riva/riva_tbl.h          |    0
 drivers/video/{ => fbdev}/riva/rivafb-i2c.c        |    0
 drivers/video/{ => fbdev}/riva/rivafb.h            |    0
 drivers/video/{ => fbdev}/s1d13xxxfb.c             |    0
 drivers/video/{ => fbdev}/s3c-fb.c                 |    0
 drivers/video/{ => fbdev}/s3c2410fb.c              |    0
 drivers/video/{ => fbdev}/s3c2410fb.h              |    0
 drivers/video/{ => fbdev}/s3fb.c                   |    0
 drivers/video/{ => fbdev}/sa1100fb.c               |    0
 drivers/video/{ => fbdev}/sa1100fb.h               |    0
 drivers/video/{ => fbdev}/savage/Makefile          |    0
 drivers/video/{ => fbdev}/savage/savagefb-i2c.c    |    0
 drivers/video/{ => fbdev}/savage/savagefb.h        |    0
 drivers/video/{ => fbdev}/savage/savagefb_accel.c  |    0
 drivers/video/{ => fbdev}/savage/savagefb_driver.c |    0
 drivers/video/{ => fbdev}/sbuslib.c                |    0
 drivers/video/{ => fbdev}/sbuslib.h                |    0
 drivers/video/{ => fbdev}/sgivwfb.c                |    0
 drivers/video/{ => fbdev}/sh7760fb.c               |    0
 drivers/video/{ => fbdev}/sh_mipi_dsi.c            |    0
 drivers/video/{ => fbdev}/sh_mobile_hdmi.c         |    0
 drivers/video/{ => fbdev}/sh_mobile_lcdcfb.c       |    0
 drivers/video/{ => fbdev}/sh_mobile_lcdcfb.h       |    0
 drivers/video/{ => fbdev}/sh_mobile_meram.c        |    0
 drivers/video/{ => fbdev}/simplefb.c               |    0
 drivers/video/{ => fbdev}/sis/300vtbl.h            |    0
 drivers/video/{ => fbdev}/sis/310vtbl.h            |    0
 drivers/video/{ => fbdev}/sis/Makefile             |    0
 drivers/video/{ => fbdev}/sis/init.c               |    0
 drivers/video/{ => fbdev}/sis/init.h               |    0
 drivers/video/{ => fbdev}/sis/init301.c            |    0
 drivers/video/{ => fbdev}/sis/init301.h            |    0
 drivers/video/{ => fbdev}/sis/initdef.h            |    0
 drivers/video/{ => fbdev}/sis/initextlfb.c         |    0
 drivers/video/{ => fbdev}/sis/oem300.h             |    0
 drivers/video/{ => fbdev}/sis/oem310.h             |    0
 drivers/video/{ => fbdev}/sis/sis.h                |    0
 drivers/video/{ => fbdev}/sis/sis_accel.c          |    0
 drivers/video/{ => fbdev}/sis/sis_accel.h          |    0
 drivers/video/{ => fbdev}/sis/sis_main.c           |    0
 drivers/video/{ => fbdev}/sis/sis_main.h           |    0
 drivers/video/{ => fbdev}/sis/vgatypes.h           |    0
 drivers/video/{ => fbdev}/sis/vstruct.h            |    0
 drivers/video/{ => fbdev}/skeletonfb.c             |    0
 drivers/video/{ => fbdev}/sm501fb.c                |    0
 drivers/video/{ => fbdev}/smscufx.c                |    0
 drivers/video/{ => fbdev}/ssd1307fb.c              |    0
 drivers/video/{ => fbdev}/sstfb.c                  |    0
 drivers/video/{ => fbdev}/sticore.h                |    0
 drivers/video/{ => fbdev}/stifb.c                  |    0
 drivers/video/{ => fbdev}/sunxvr1000.c             |    0
 drivers/video/{ => fbdev}/sunxvr2500.c             |    0
 drivers/video/{ => fbdev}/sunxvr500.c              |    0
 drivers/video/{ => fbdev}/svgalib.c                |    0
 drivers/video/{ => fbdev}/syscopyarea.c            |    0
 drivers/video/{ => fbdev}/sysfillrect.c            |    0
 drivers/video/{ => fbdev}/sysimgblt.c              |    0
 drivers/video/{ => fbdev}/tcx.c                    |    0
 drivers/video/{ => fbdev}/tdfxfb.c                 |    0
 drivers/video/{ => fbdev}/tgafb.c                  |    0
 drivers/video/{ => fbdev}/tmiofb.c                 |    0
 drivers/video/{ => fbdev}/tridentfb.c              |    0
 drivers/video/{ => fbdev}/udlfb.c                  |    0
 drivers/video/{ => fbdev}/uvesafb.c                |    0
 drivers/video/{ => fbdev}/valkyriefb.c             |    0
 drivers/video/{ => fbdev}/valkyriefb.h             |    0
 drivers/video/{ => fbdev}/vermilion/Makefile       |    0
 drivers/video/{ => fbdev}/vermilion/cr_pll.c       |    0
 drivers/video/{ => fbdev}/vermilion/vermilion.c    |    0
 drivers/video/{ => fbdev}/vermilion/vermilion.h    |    0
 drivers/video/{ => fbdev}/vesafb.c                 |    0
 drivers/video/{ => fbdev}/vfb.c                    |    0
 drivers/video/{ => fbdev}/vga16fb.c                |    0
 drivers/video/{ => fbdev}/via/Makefile             |    0
 drivers/video/{ => fbdev}/via/accel.c              |    0
 drivers/video/{ => fbdev}/via/accel.h              |    0
 drivers/video/{ => fbdev}/via/chip.h               |    0
 drivers/video/{ => fbdev}/via/debug.h              |    0
 drivers/video/{ => fbdev}/via/dvi.c                |    0
 drivers/video/{ => fbdev}/via/dvi.h                |    0
 drivers/video/{ => fbdev}/via/global.c             |    0
 drivers/video/{ => fbdev}/via/global.h             |    0
 drivers/video/{ => fbdev}/via/hw.c                 |    0
 drivers/video/{ => fbdev}/via/hw.h                 |    0
 drivers/video/{ => fbdev}/via/ioctl.c              |    0
 drivers/video/{ => fbdev}/via/ioctl.h              |    0
 drivers/video/{ => fbdev}/via/lcd.c                |    0
 drivers/video/{ => fbdev}/via/lcd.h                |    0
 drivers/video/{ => fbdev}/via/share.h              |    0
 drivers/video/{ => fbdev}/via/tblDPASetting.c      |    0
 drivers/video/{ => fbdev}/via/tblDPASetting.h      |    0
 drivers/video/{ => fbdev}/via/via-core.c           |    0
 drivers/video/{ => fbdev}/via/via-gpio.c           |    0
 drivers/video/{ => fbdev}/via/via_aux.c            |    0
 drivers/video/{ => fbdev}/via/via_aux.h            |    0
 drivers/video/{ => fbdev}/via/via_aux_ch7301.c     |    0
 drivers/video/{ => fbdev}/via/via_aux_edid.c       |    0
 drivers/video/{ => fbdev}/via/via_aux_sii164.c     |    0
 drivers/video/{ => fbdev}/via/via_aux_vt1621.c     |    0
 drivers/video/{ => fbdev}/via/via_aux_vt1622.c     |    0
 drivers/video/{ => fbdev}/via/via_aux_vt1625.c     |    0
 drivers/video/{ => fbdev}/via/via_aux_vt1631.c     |    0
 drivers/video/{ => fbdev}/via/via_aux_vt1632.c     |    0
 drivers/video/{ => fbdev}/via/via_aux_vt1636.c     |    0
 drivers/video/{ => fbdev}/via/via_clock.c          |    0
 drivers/video/{ => fbdev}/via/via_clock.h          |    0
 drivers/video/{ => fbdev}/via/via_i2c.c            |    0
 drivers/video/{ => fbdev}/via/via_modesetting.c    |    0
 drivers/video/{ => fbdev}/via/via_modesetting.h    |    0
 drivers/video/{ => fbdev}/via/via_utility.c        |    0
 drivers/video/{ => fbdev}/via/via_utility.h        |    0
 drivers/video/{ => fbdev}/via/viafbdev.c           |    0
 drivers/video/{ => fbdev}/via/viafbdev.h           |    0
 drivers/video/{ => fbdev}/via/viamode.c            |    0
 drivers/video/{ => fbdev}/via/viamode.h            |    0
 drivers/video/{ => fbdev}/via/vt1636.c             |    0
 drivers/video/{ => fbdev}/via/vt1636.h             |    0
 drivers/video/{ => fbdev}/vt8500lcdfb.c            |    0
 drivers/video/{ => fbdev}/vt8500lcdfb.h            |    0
 drivers/video/{ => fbdev}/vt8623fb.c               |    0
 drivers/video/{ => fbdev}/w100fb.c                 |    0
 drivers/video/{ => fbdev}/w100fb.h                 |    0
 drivers/video/{ => fbdev}/wm8505fb.c               |    0
 drivers/video/{ => fbdev}/wm8505fb_regs.h          |    0
 drivers/video/{ => fbdev}/wmt_ge_rops.c            |    0
 drivers/video/{ => fbdev}/wmt_ge_rops.h            |    0
 drivers/video/{ => fbdev}/xen-fbfront.c            |    0
 drivers/video/{ => fbdev}/xilinxfb.c               |    0
 drivers/video/omap2/Kconfig                        |   10 -
 479 files changed, 2670 insertions(+), 2659 deletions(-)
 rename drivers/video/{ => fbdev}/68328fb.c (100%)
 create mode 100644 drivers/video/fbdev/Kconfig
 create mode 100644 drivers/video/fbdev/Makefile
 rename drivers/video/{ => fbdev}/acornfb.c (100%)
 rename drivers/video/{ => fbdev}/acornfb.h (100%)
 rename drivers/video/{ => fbdev}/amba-clcd.c (100%)
 rename drivers/video/{ => fbdev}/amifb.c (100%)
 rename drivers/video/{ => fbdev}/arcfb.c (100%)
 rename drivers/video/{ => fbdev}/arkfb.c (100%)
 rename drivers/video/{ => fbdev}/asiliantfb.c (100%)
 rename drivers/video/{ => fbdev}/atafb.c (100%)
 rename drivers/video/{ => fbdev}/atafb.h (100%)
 rename drivers/video/{ => fbdev}/atafb_iplan2p2.c (100%)
 rename drivers/video/{ => fbdev}/atafb_iplan2p4.c (100%)
 rename drivers/video/{ => fbdev}/atafb_iplan2p8.c (100%)
 rename drivers/video/{ => fbdev}/atafb_mfb.c (100%)
 rename drivers/video/{ => fbdev}/atafb_utils.h (100%)
 rename drivers/video/{ => fbdev}/atmel_lcdfb.c (100%)
 rename drivers/video/{ => fbdev}/aty/Makefile (100%)
 rename drivers/video/{ => fbdev}/aty/ati_ids.h (100%)
 rename drivers/video/{ => fbdev}/aty/aty128fb.c (100%)
 rename drivers/video/{ => fbdev}/aty/atyfb.h (100%)
 rename drivers/video/{ => fbdev}/aty/atyfb_base.c (100%)
 rename drivers/video/{ => fbdev}/aty/mach64_accel.c (100%)
 rename drivers/video/{ => fbdev}/aty/mach64_ct.c (100%)
 rename drivers/video/{ => fbdev}/aty/mach64_cursor.c (100%)
 rename drivers/video/{ => fbdev}/aty/mach64_gx.c (100%)
 rename drivers/video/{ => fbdev}/aty/radeon_accel.c (100%)
 rename drivers/video/{ => fbdev}/aty/radeon_backlight.c (100%)
 rename drivers/video/{ => fbdev}/aty/radeon_base.c (100%)
 rename drivers/video/{ => fbdev}/aty/radeon_i2c.c (100%)
 rename drivers/video/{ => fbdev}/aty/radeon_monitor.c (100%)
 rename drivers/video/{ => fbdev}/aty/radeon_pm.c (100%)
 rename drivers/video/{ => fbdev}/aty/radeonfb.h (100%)
 rename drivers/video/{ => fbdev}/au1100fb.c (100%)
 rename drivers/video/{ => fbdev}/au1100fb.h (100%)
 rename drivers/video/{ => fbdev}/au1200fb.c (100%)
 rename drivers/video/{ => fbdev}/au1200fb.h (100%)
 rename drivers/video/{ => fbdev}/auo_k1900fb.c (100%)
 rename drivers/video/{ => fbdev}/auo_k1901fb.c (100%)
 rename drivers/video/{ => fbdev}/auo_k190x.c (100%)
 rename drivers/video/{ => fbdev}/auo_k190x.h (100%)
 rename drivers/video/{ => fbdev}/bf537-lq035.c (100%)
 rename drivers/video/{ => fbdev}/bf54x-lq043fb.c (100%)
 rename drivers/video/{ => fbdev}/bfin-lq035q1-fb.c (100%)
 rename drivers/video/{ => fbdev}/bfin-t350mcqb-fb.c (100%)
 rename drivers/video/{ => fbdev}/bfin_adv7393fb.c (100%)
 rename drivers/video/{ => fbdev}/bfin_adv7393fb.h (100%)
 rename drivers/video/{ => fbdev}/broadsheetfb.c (100%)
 rename drivers/video/{ => fbdev}/bt431.h (100%)
 rename drivers/video/{ => fbdev}/bt455.h (100%)
 rename drivers/video/{ => fbdev}/bw2.c (100%)
 rename drivers/video/{ => fbdev}/c2p.h (100%)
 rename drivers/video/{ => fbdev}/c2p_core.h (100%)
 rename drivers/video/{ => fbdev}/c2p_iplan2.c (100%)
 rename drivers/video/{ => fbdev}/c2p_planar.c (100%)
 rename drivers/video/{ => fbdev}/carminefb.c (100%)
 rename drivers/video/{ => fbdev}/carminefb.h (100%)
 rename drivers/video/{ => fbdev}/carminefb_regs.h (100%)
 rename drivers/video/{ => fbdev}/cfbcopyarea.c (100%)
 rename drivers/video/{ => fbdev}/cfbfillrect.c (100%)
 rename drivers/video/{ => fbdev}/cfbimgblt.c (100%)
 rename drivers/video/{ => fbdev}/cg14.c (100%)
 rename drivers/video/{ => fbdev}/cg3.c (100%)
 rename drivers/video/{ => fbdev}/cg6.c (100%)
 rename drivers/video/{ => fbdev}/chipsfb.c (100%)
 rename drivers/video/{ => fbdev}/cirrusfb.c (100%)
 rename drivers/video/{ => fbdev}/clps711xfb.c (100%)
 rename drivers/video/{ => fbdev}/cobalt_lcdfb.c (100%)
 rename drivers/video/{ => fbdev}/controlfb.c (100%)
 rename drivers/video/{ => fbdev}/controlfb.h (100%)
 rename drivers/video/{ => fbdev}/cyber2000fb.c (100%)
 rename drivers/video/{ => fbdev}/cyber2000fb.h (100%)
 rename drivers/video/{ => fbdev}/da8xx-fb.c (100%)
 rename drivers/video/{ => fbdev}/dnfb.c (100%)
 rename drivers/video/{ => fbdev}/edid.h (100%)
 rename drivers/video/{ => fbdev}/efifb.c (100%)
 rename drivers/video/{ => fbdev}/ep93xx-fb.c (100%)
 rename drivers/video/{ => fbdev}/exynos/Kconfig (100%)
 rename drivers/video/{ => fbdev}/exynos/Makefile (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_dp_core.c (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_dp_core.h (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_dp_reg.c (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_dp_reg.h (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_mipi_dsi.c (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_mipi_dsi_common.c (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_mipi_dsi_common.h (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_mipi_dsi_lowlevel.c (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_mipi_dsi_lowlevel.h (100%)
 rename drivers/video/{ => fbdev}/exynos/exynos_mipi_dsi_regs.h (100%)
 rename drivers/video/{ => fbdev}/exynos/s6e8ax0.c (100%)
 rename drivers/video/{ => fbdev}/fb-puv3.c (100%)
 rename drivers/video/{ => fbdev}/fb_ddc.c (100%)
 rename drivers/video/{ => fbdev}/fb_defio.c (100%)
 rename drivers/video/{ => fbdev}/fb_draw.h (100%)
 rename drivers/video/{ => fbdev}/fb_notify.c (100%)
 rename drivers/video/{ => fbdev}/fb_sys_fops.c (100%)
 rename drivers/video/{ => fbdev}/fbcmap.c (100%)
 rename drivers/video/{ => fbdev}/fbcvt.c (100%)
 rename drivers/video/{ => fbdev}/fbmem.c (100%)
 rename drivers/video/{ => fbdev}/fbmon.c (100%)
 rename drivers/video/{ => fbdev}/fbsysfs.c (100%)
 rename drivers/video/{ => fbdev}/ffb.c (100%)
 rename drivers/video/{ => fbdev}/fm2fb.c (100%)
 rename drivers/video/{ => fbdev}/fsl-diu-fb.c (100%)
 rename drivers/video/{ => fbdev}/g364fb.c (100%)
 rename drivers/video/{ => fbdev}/gbefb.c (100%)
 rename drivers/video/{ => fbdev}/geode/Kconfig (100%)
 rename drivers/video/{ => fbdev}/geode/Makefile (100%)
 rename drivers/video/{ => fbdev}/geode/display_gx.c (100%)
 rename drivers/video/{ => fbdev}/geode/display_gx1.c (100%)
 rename drivers/video/{ => fbdev}/geode/display_gx1.h (100%)
 rename drivers/video/{ => fbdev}/geode/geodefb.h (100%)
 rename drivers/video/{ => fbdev}/geode/gx1fb_core.c (100%)
 rename drivers/video/{ => fbdev}/geode/gxfb.h (100%)
 rename drivers/video/{ => fbdev}/geode/gxfb_core.c (100%)
 rename drivers/video/{ => fbdev}/geode/lxfb.h (100%)
 rename drivers/video/{ => fbdev}/geode/lxfb_core.c (100%)
 rename drivers/video/{ => fbdev}/geode/lxfb_ops.c (100%)
 rename drivers/video/{ => fbdev}/geode/suspend_gx.c (100%)
 rename drivers/video/{ => fbdev}/geode/video_cs5530.c (100%)
 rename drivers/video/{ => fbdev}/geode/video_cs5530.h (100%)
 rename drivers/video/{ => fbdev}/geode/video_gx.c (100%)
 rename drivers/video/{ => fbdev}/goldfishfb.c (100%)
 rename drivers/video/{ => fbdev}/grvga.c (100%)
 rename drivers/video/{ => fbdev}/gxt4500.c (100%)
 rename drivers/video/{ => fbdev}/hecubafb.c (100%)
 rename drivers/video/{ => fbdev}/hgafb.c (100%)
 rename drivers/video/{ => fbdev}/hitfb.c (100%)
 rename drivers/video/{ => fbdev}/hpfb.c (100%)
 rename drivers/video/{ => fbdev}/hyperv_fb.c (100%)
 rename drivers/video/{ => fbdev}/i740_reg.h (100%)
 rename drivers/video/{ => fbdev}/i740fb.c (100%)
 rename drivers/video/{ => fbdev}/i810/Makefile (100%)
 rename drivers/video/{ => fbdev}/i810/i810-i2c.c (100%)
 rename drivers/video/{ => fbdev}/i810/i810.h (100%)
 rename drivers/video/{ => fbdev}/i810/i810_accel.c (100%)
 rename drivers/video/{ => fbdev}/i810/i810_dvt.c (100%)
 rename drivers/video/{ => fbdev}/i810/i810_gtf.c (100%)
 rename drivers/video/{ => fbdev}/i810/i810_main.c (100%)
 rename drivers/video/{ => fbdev}/i810/i810_main.h (100%)
 rename drivers/video/{ => fbdev}/i810/i810_regs.h (100%)
 rename drivers/video/{ => fbdev}/igafb.c (100%)
 rename drivers/video/{ => fbdev}/imsttfb.c (100%)
 rename drivers/video/{ => fbdev}/imxfb.c (100%)
 rename drivers/video/{ => fbdev}/intelfb/Makefile (100%)
 rename drivers/video/{ => fbdev}/intelfb/intelfb.h (100%)
 rename drivers/video/{ => fbdev}/intelfb/intelfb_i2c.c (100%)
 rename drivers/video/{ => fbdev}/intelfb/intelfbdrv.c (100%)
 rename drivers/video/{ => fbdev}/intelfb/intelfbhw.c (100%)
 rename drivers/video/{ => fbdev}/intelfb/intelfbhw.h (100%)
 rename drivers/video/{ => fbdev}/jz4740_fb.c (100%)
 rename drivers/video/{ => fbdev}/kyro/Makefile (100%)
 rename drivers/video/{ => fbdev}/kyro/STG4000InitDevice.c (100%)
 rename drivers/video/{ => fbdev}/kyro/STG4000Interface.h (100%)
 rename drivers/video/{ => fbdev}/kyro/STG4000OverlayDevice.c (100%)
 rename drivers/video/{ => fbdev}/kyro/STG4000Ramdac.c (100%)
 rename drivers/video/{ => fbdev}/kyro/STG4000Reg.h (100%)
 rename drivers/video/{ => fbdev}/kyro/STG4000VTG.c (100%)
 rename drivers/video/{ => fbdev}/kyro/fbdev.c (100%)
 rename drivers/video/{ => fbdev}/leo.c (100%)
 rename drivers/video/{ => fbdev}/macfb.c (100%)
 rename drivers/video/{ => fbdev}/macmodes.c (100%)
 rename drivers/video/{ => fbdev}/macmodes.h (100%)
 rename drivers/video/{ => fbdev}/matrox/Makefile (100%)
 rename drivers/video/{ => fbdev}/matrox/g450_pll.c (100%)
 rename drivers/video/{ => fbdev}/matrox/g450_pll.h (100%)
 rename drivers/video/{ => fbdev}/matrox/i2c-matroxfb.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_DAC1064.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_DAC1064.h (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_Ti3026.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_Ti3026.h (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_accel.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_accel.h (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_base.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_base.h (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_crtc2.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_crtc2.h (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_g450.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_g450.h (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_maven.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_maven.h (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_misc.c (100%)
 rename drivers/video/{ => fbdev}/matrox/matroxfb_misc.h (100%)
 rename drivers/video/{ => fbdev}/maxinefb.c (100%)
 rename drivers/video/{ => fbdev}/mb862xx/Makefile (100%)
 rename drivers/video/{ => fbdev}/mb862xx/mb862xx-i2c.c (100%)
 rename drivers/video/{ => fbdev}/mb862xx/mb862xx_reg.h (100%)
 rename drivers/video/{ => fbdev}/mb862xx/mb862xxfb.h (100%)
 rename drivers/video/{ => fbdev}/mb862xx/mb862xxfb_accel.c (100%)
 rename drivers/video/{ => fbdev}/mb862xx/mb862xxfb_accel.h (100%)
 rename drivers/video/{ => fbdev}/mb862xx/mb862xxfbdrv.c (100%)
 rename drivers/video/{ => fbdev}/mbx/Makefile (100%)
 rename drivers/video/{ => fbdev}/mbx/mbxdebugfs.c (100%)
 rename drivers/video/{ => fbdev}/mbx/mbxfb.c (100%)
 rename drivers/video/{ => fbdev}/mbx/reg_bits.h (100%)
 rename drivers/video/{ => fbdev}/mbx/regs.h (100%)
 rename drivers/video/{ => fbdev}/metronomefb.c (100%)
 rename drivers/video/{ => fbdev}/mmp/Kconfig (61%)
 rename drivers/video/{ => fbdev}/mmp/Makefile (100%)
 rename drivers/video/{ => fbdev}/mmp/core.c (100%)
 rename drivers/video/{ => fbdev}/mmp/fb/Kconfig (100%)
 rename drivers/video/{ => fbdev}/mmp/fb/Makefile (100%)
 rename drivers/video/{ => fbdev}/mmp/fb/mmpfb.c (100%)
 rename drivers/video/{ => fbdev}/mmp/fb/mmpfb.h (100%)
 rename drivers/video/{ => fbdev}/mmp/hw/Kconfig (100%)
 rename drivers/video/{ => fbdev}/mmp/hw/Makefile (100%)
 rename drivers/video/{ => fbdev}/mmp/hw/mmp_ctrl.c (100%)
 rename drivers/video/{ => fbdev}/mmp/hw/mmp_ctrl.h (100%)
 rename drivers/video/{ => fbdev}/mmp/hw/mmp_spi.c (100%)
 rename drivers/video/{ => fbdev}/mmp/panel/Kconfig (100%)
 rename drivers/video/{ => fbdev}/mmp/panel/Makefile (100%)
 rename drivers/video/{ => fbdev}/mmp/panel/tpo_tj032md01bw.c (100%)
 rename drivers/video/{ => fbdev}/modedb.c (100%)
 rename drivers/video/{ => fbdev}/msm/Makefile (100%)
 rename drivers/video/{ => fbdev}/msm/mddi.c (100%)
 rename drivers/video/{ => fbdev}/msm/mddi_client_dummy.c (100%)
 rename drivers/video/{ => fbdev}/msm/mddi_client_nt35399.c (100%)
 rename drivers/video/{ => fbdev}/msm/mddi_client_toshiba.c (100%)
 rename drivers/video/{ => fbdev}/msm/mddi_hw.h (100%)
 rename drivers/video/{ => fbdev}/msm/mdp.c (100%)
 rename drivers/video/{ => fbdev}/msm/mdp_csc_table.h (100%)
 rename drivers/video/{ => fbdev}/msm/mdp_hw.h (100%)
 rename drivers/video/{ => fbdev}/msm/mdp_ppp.c (100%)
 rename drivers/video/{ => fbdev}/msm/mdp_scale_tables.c (100%)
 rename drivers/video/{ => fbdev}/msm/mdp_scale_tables.h (100%)
 rename drivers/video/{ => fbdev}/msm/msm_fb.c (100%)
 rename drivers/video/{ => fbdev}/mx3fb.c (100%)
 rename drivers/video/{ => fbdev}/mxsfb.c (100%)
 rename drivers/video/{ => fbdev}/n411.c (100%)
 rename drivers/video/{ => fbdev}/neofb.c (100%)
 rename drivers/video/{ => fbdev}/nuc900fb.c (100%)
 rename drivers/video/{ => fbdev}/nuc900fb.h (100%)
 rename drivers/video/{ => fbdev}/nvidia/Makefile (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_accel.c (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_backlight.c (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_dma.h (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_hw.c (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_i2c.c (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_local.h (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_of.c (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_proto.h (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_setup.c (100%)
 rename drivers/video/{ => fbdev}/nvidia/nv_type.h (100%)
 rename drivers/video/{ => fbdev}/nvidia/nvidia.c (100%)
 rename drivers/video/{ => fbdev}/ocfb.c (100%)
 rename drivers/video/{ => fbdev}/offb.c (100%)
 rename drivers/video/{ => fbdev}/omap/Kconfig (100%)
 rename drivers/video/{ => fbdev}/omap/Makefile (100%)
 rename drivers/video/{ => fbdev}/omap/hwa742.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_ams_delta.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_h3.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_htcherald.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_inn1510.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_inn1610.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_mipid.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_osk.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_palmte.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_palmtt.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcd_palmz71.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcdc.c (100%)
 rename drivers/video/{ => fbdev}/omap/lcdc.h (100%)
 rename drivers/video/{ => fbdev}/omap/omapfb.h (100%)
 rename drivers/video/{ => fbdev}/omap/omapfb_main.c (100%)
 rename drivers/video/{ => fbdev}/omap/sossi.c (100%)
 create mode 100644 drivers/video/fbdev/omap2/Kconfig
 rename drivers/video/{ => fbdev}/omap2/Makefile (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/Kconfig (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/Makefile (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/connector-analog-tv.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/connector-dvi.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/connector-hdmi.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/encoder-tfp410.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/encoder-tpd12s015.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-dpi.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-dsi-cm.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-lgphilips-lb035q02.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-nec-nl8048hl11.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-sharp-ls037v7dw01.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-sony-acx565akm.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-tpo-td028ttec1.c (100%)
 rename drivers/video/{ => fbdev}/omap2/displays-new/panel-tpo-td043mtea1.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/Kconfig (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/Makefile (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/apply.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/core.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dispc-compat.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dispc-compat.h (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dispc.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dispc.h (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dispc_coefs.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/display-sysfs.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/display.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dpi.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dsi.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dss.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dss.h (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dss_features.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/dss_features.h (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi.h (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi4.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi4_core.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi4_core.h (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi_common.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi_phy.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi_pll.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/hdmi_wp.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/manager-sysfs.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/manager.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/output.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/overlay-sysfs.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/overlay.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/rfbi.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/sdi.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/venc.c (100%)
 rename drivers/video/{ => fbdev}/omap2/dss/venc_panel.c (100%)
 rename drivers/video/{ => fbdev}/omap2/omapfb/Kconfig (100%)
 rename drivers/video/{ => fbdev}/omap2/omapfb/Makefile (100%)
 rename drivers/video/{ => fbdev}/omap2/omapfb/omapfb-ioctl.c (100%)
 rename drivers/video/{ => fbdev}/omap2/omapfb/omapfb-main.c (100%)
 rename drivers/video/{ => fbdev}/omap2/omapfb/omapfb-sysfs.c (100%)
 rename drivers/video/{ => fbdev}/omap2/omapfb/omapfb.h (100%)
 rename drivers/video/{ => fbdev}/omap2/vrfb.c (100%)
 rename drivers/video/{ => fbdev}/p9100.c (100%)
 rename drivers/video/{ => fbdev}/platinumfb.c (100%)
 rename drivers/video/{ => fbdev}/platinumfb.h (100%)
 rename drivers/video/{ => fbdev}/pm2fb.c (100%)
 rename drivers/video/{ => fbdev}/pm3fb.c (100%)
 rename drivers/video/{ => fbdev}/pmag-aa-fb.c (100%)
 rename drivers/video/{ => fbdev}/pmag-ba-fb.c (100%)
 rename drivers/video/{ => fbdev}/pmagb-b-fb.c (100%)
 rename drivers/video/{ => fbdev}/ps3fb.c (100%)
 rename drivers/video/{ => fbdev}/pvr2fb.c (100%)
 rename drivers/video/{ => fbdev}/pxa168fb.c (100%)
 rename drivers/video/{ => fbdev}/pxa168fb.h (100%)
 rename drivers/video/{ => fbdev}/pxa3xx-gcu.c (100%)
 rename drivers/video/{ => fbdev}/pxa3xx-gcu.h (100%)
 rename drivers/video/{ => fbdev}/pxafb.c (100%)
 rename drivers/video/{ => fbdev}/pxafb.h (100%)
 rename drivers/video/{ => fbdev}/q40fb.c (100%)
 rename drivers/video/{ => fbdev}/riva/Makefile (100%)
 rename drivers/video/{ => fbdev}/riva/fbdev.c (100%)
 rename drivers/video/{ => fbdev}/riva/nv_driver.c (100%)
 rename drivers/video/{ => fbdev}/riva/nv_type.h (100%)
 rename drivers/video/{ => fbdev}/riva/nvreg.h (100%)
 rename drivers/video/{ => fbdev}/riva/riva_hw.c (100%)
 rename drivers/video/{ => fbdev}/riva/riva_hw.h (100%)
 rename drivers/video/{ => fbdev}/riva/riva_tbl.h (100%)
 rename drivers/video/{ => fbdev}/riva/rivafb-i2c.c (100%)
 rename drivers/video/{ => fbdev}/riva/rivafb.h (100%)
 rename drivers/video/{ => fbdev}/s1d13xxxfb.c (100%)
 rename drivers/video/{ => fbdev}/s3c-fb.c (100%)
 rename drivers/video/{ => fbdev}/s3c2410fb.c (100%)
 rename drivers/video/{ => fbdev}/s3c2410fb.h (100%)
 rename drivers/video/{ => fbdev}/s3fb.c (100%)
 rename drivers/video/{ => fbdev}/sa1100fb.c (100%)
 rename drivers/video/{ => fbdev}/sa1100fb.h (100%)
 rename drivers/video/{ => fbdev}/savage/Makefile (100%)
 rename drivers/video/{ => fbdev}/savage/savagefb-i2c.c (100%)
 rename drivers/video/{ => fbdev}/savage/savagefb.h (100%)
 rename drivers/video/{ => fbdev}/savage/savagefb_accel.c (100%)
 rename drivers/video/{ => fbdev}/savage/savagefb_driver.c (100%)
 rename drivers/video/{ => fbdev}/sbuslib.c (100%)
 rename drivers/video/{ => fbdev}/sbuslib.h (100%)
 rename drivers/video/{ => fbdev}/sgivwfb.c (100%)
 rename drivers/video/{ => fbdev}/sh7760fb.c (100%)
 rename drivers/video/{ => fbdev}/sh_mipi_dsi.c (100%)
 rename drivers/video/{ => fbdev}/sh_mobile_hdmi.c (100%)
 rename drivers/video/{ => fbdev}/sh_mobile_lcdcfb.c (100%)
 rename drivers/video/{ => fbdev}/sh_mobile_lcdcfb.h (100%)
 rename drivers/video/{ => fbdev}/sh_mobile_meram.c (100%)
 rename drivers/video/{ => fbdev}/simplefb.c (100%)
 rename drivers/video/{ => fbdev}/sis/300vtbl.h (100%)
 rename drivers/video/{ => fbdev}/sis/310vtbl.h (100%)
 rename drivers/video/{ => fbdev}/sis/Makefile (100%)
 rename drivers/video/{ => fbdev}/sis/init.c (100%)
 rename drivers/video/{ => fbdev}/sis/init.h (100%)
 rename drivers/video/{ => fbdev}/sis/init301.c (100%)
 rename drivers/video/{ => fbdev}/sis/init301.h (100%)
 rename drivers/video/{ => fbdev}/sis/initdef.h (100%)
 rename drivers/video/{ => fbdev}/sis/initextlfb.c (100%)
 rename drivers/video/{ => fbdev}/sis/oem300.h (100%)
 rename drivers/video/{ => fbdev}/sis/oem310.h (100%)
 rename drivers/video/{ => fbdev}/sis/sis.h (100%)
 rename drivers/video/{ => fbdev}/sis/sis_accel.c (100%)
 rename drivers/video/{ => fbdev}/sis/sis_accel.h (100%)
 rename drivers/video/{ => fbdev}/sis/sis_main.c (100%)
 rename drivers/video/{ => fbdev}/sis/sis_main.h (100%)
 rename drivers/video/{ => fbdev}/sis/vgatypes.h (100%)
 rename drivers/video/{ => fbdev}/sis/vstruct.h (100%)
 rename drivers/video/{ => fbdev}/skeletonfb.c (100%)
 rename drivers/video/{ => fbdev}/sm501fb.c (100%)
 rename drivers/video/{ => fbdev}/smscufx.c (100%)
 rename drivers/video/{ => fbdev}/ssd1307fb.c (100%)
 rename drivers/video/{ => fbdev}/sstfb.c (100%)
 rename drivers/video/{ => fbdev}/sticore.h (100%)
 rename drivers/video/{ => fbdev}/stifb.c (100%)
 rename drivers/video/{ => fbdev}/sunxvr1000.c (100%)
 rename drivers/video/{ => fbdev}/sunxvr2500.c (100%)
 rename drivers/video/{ => fbdev}/sunxvr500.c (100%)
 rename drivers/video/{ => fbdev}/svgalib.c (100%)
 rename drivers/video/{ => fbdev}/syscopyarea.c (100%)
 rename drivers/video/{ => fbdev}/sysfillrect.c (100%)
 rename drivers/video/{ => fbdev}/sysimgblt.c (100%)
 rename drivers/video/{ => fbdev}/tcx.c (100%)
 rename drivers/video/{ => fbdev}/tdfxfb.c (100%)
 rename drivers/video/{ => fbdev}/tgafb.c (100%)
 rename drivers/video/{ => fbdev}/tmiofb.c (100%)
 rename drivers/video/{ => fbdev}/tridentfb.c (100%)
 rename drivers/video/{ => fbdev}/udlfb.c (100%)
 rename drivers/video/{ => fbdev}/uvesafb.c (100%)
 rename drivers/video/{ => fbdev}/valkyriefb.c (100%)
 rename drivers/video/{ => fbdev}/valkyriefb.h (100%)
 rename drivers/video/{ => fbdev}/vermilion/Makefile (100%)
 rename drivers/video/{ => fbdev}/vermilion/cr_pll.c (100%)
 rename drivers/video/{ => fbdev}/vermilion/vermilion.c (100%)
 rename drivers/video/{ => fbdev}/vermilion/vermilion.h (100%)
 rename drivers/video/{ => fbdev}/vesafb.c (100%)
 rename drivers/video/{ => fbdev}/vfb.c (100%)
 rename drivers/video/{ => fbdev}/vga16fb.c (100%)
 rename drivers/video/{ => fbdev}/via/Makefile (100%)
 rename drivers/video/{ => fbdev}/via/accel.c (100%)
 rename drivers/video/{ => fbdev}/via/accel.h (100%)
 rename drivers/video/{ => fbdev}/via/chip.h (100%)
 rename drivers/video/{ => fbdev}/via/debug.h (100%)
 rename drivers/video/{ => fbdev}/via/dvi.c (100%)
 rename drivers/video/{ => fbdev}/via/dvi.h (100%)
 rename drivers/video/{ => fbdev}/via/global.c (100%)
 rename drivers/video/{ => fbdev}/via/global.h (100%)
 rename drivers/video/{ => fbdev}/via/hw.c (100%)
 rename drivers/video/{ => fbdev}/via/hw.h (100%)
 rename drivers/video/{ => fbdev}/via/ioctl.c (100%)
 rename drivers/video/{ => fbdev}/via/ioctl.h (100%)
 rename drivers/video/{ => fbdev}/via/lcd.c (100%)
 rename drivers/video/{ => fbdev}/via/lcd.h (100%)
 rename drivers/video/{ => fbdev}/via/share.h (100%)
 rename drivers/video/{ => fbdev}/via/tblDPASetting.c (100%)
 rename drivers/video/{ => fbdev}/via/tblDPASetting.h (100%)
 rename drivers/video/{ => fbdev}/via/via-core.c (100%)
 rename drivers/video/{ => fbdev}/via/via-gpio.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux.h (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_ch7301.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_edid.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_sii164.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_vt1621.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_vt1622.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_vt1625.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_vt1631.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_vt1632.c (100%)
 rename drivers/video/{ => fbdev}/via/via_aux_vt1636.c (100%)
 rename drivers/video/{ => fbdev}/via/via_clock.c (100%)
 rename drivers/video/{ => fbdev}/via/via_clock.h (100%)
 rename drivers/video/{ => fbdev}/via/via_i2c.c (100%)
 rename drivers/video/{ => fbdev}/via/via_modesetting.c (100%)
 rename drivers/video/{ => fbdev}/via/via_modesetting.h (100%)
 rename drivers/video/{ => fbdev}/via/via_utility.c (100%)
 rename drivers/video/{ => fbdev}/via/via_utility.h (100%)
 rename drivers/video/{ => fbdev}/via/viafbdev.c (100%)
 rename drivers/video/{ => fbdev}/via/viafbdev.h (100%)
 rename drivers/video/{ => fbdev}/via/viamode.c (100%)
 rename drivers/video/{ => fbdev}/via/viamode.h (100%)
 rename drivers/video/{ => fbdev}/via/vt1636.c (100%)
 rename drivers/video/{ => fbdev}/via/vt1636.h (100%)
 rename drivers/video/{ => fbdev}/vt8500lcdfb.c (100%)
 rename drivers/video/{ => fbdev}/vt8500lcdfb.h (100%)
 rename drivers/video/{ => fbdev}/vt8623fb.c (100%)
 rename drivers/video/{ => fbdev}/w100fb.c (100%)
 rename drivers/video/{ => fbdev}/w100fb.h (100%)
 rename drivers/video/{ => fbdev}/wm8505fb.c (100%)
 rename drivers/video/{ => fbdev}/wm8505fb_regs.h (100%)
 rename drivers/video/{ => fbdev}/wmt_ge_rops.c (100%)
 rename drivers/video/{ => fbdev}/wmt_ge_rops.h (100%)
 rename drivers/video/{ => fbdev}/xen-fbfront.c (100%)
 rename drivers/video/{ => fbdev}/xilinxfb.c (100%)
 delete mode 100644 drivers/video/omap2/Kconfig

diff --git a/drivers/Makefile b/drivers/Makefile
index 8e3b8b06c0b2..fd0b0791d270 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -53,8 +53,8 @@ obj-y				+= gpu/
 obj-$(CONFIG_CONNECTOR)		+= connector/
 
 # i810fb and intelfb depend on char/agp/
-obj-$(CONFIG_FB_I810)           += video/i810/
-obj-$(CONFIG_FB_INTEL)          += video/intelfb/
+obj-$(CONFIG_FB_I810)           += video/fbdev/i810/
+obj-$(CONFIG_FB_INTEL)          += video/fbdev/intelfb/
 
 obj-$(CONFIG_PARPORT)		+= parport/
 obj-y				+= base/ block/ misc/ mfd/ nfc/
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 22262a3a0e2d..f0f26a0b746e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -23,6 +23,10 @@ source "drivers/gpu/host1x/Kconfig"
 
 source "drivers/gpu/drm/Kconfig"
 
+source "drivers/video/fbdev/Kconfig"
+
+source "drivers/video/backlight/Kconfig"
+
 config VGASTATE
        tristate
        default n
@@ -39,2491 +43,14 @@ config VIDEOMODE_HELPERS
 config HDMI
 	bool
 
-menuconfig FB
-	tristate "Support for frame buffer devices"
-	---help---
-	  The frame buffer device provides an abstraction for the graphics
-	  hardware. It represents the frame buffer of some video hardware and
-	  allows application software to access the graphics hardware through
-	  a well-defined interface, so the software doesn't need to know
-	  anything about the low-level (hardware register) stuff.
-
-	  Frame buffer devices work identically across the different
-	  architectures supported by Linux and make the implementation of
-	  application programs easier and more portable; at this point, an X
-	  server exists which uses the frame buffer device exclusively.
-	  On several non-X86 architectures, the frame buffer device is the
-	  only way to use the graphics hardware.
-
-	  The device is accessed through special device nodes, usually located
-	  in the /dev directory, i.e. /dev/fb*.
-
-	  You need an utility program called fbset to make full use of frame
-	  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
-	  and the Framebuffer-HOWTO at
-	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.3.html> for more
-	  information.
-
-	  Say Y here and to the driver for your graphics board below if you
-	  are compiling a kernel for a non-x86 architecture.
-
-	  If you are compiling for the x86 architecture, you can say Y if you
-	  want to play with it, but it is not essential. Please note that
-	  running graphical applications that directly touch the hardware
-	  (e.g. an accelerated X server) and that are not frame buffer
-	  device-aware may cause unexpected results. If unsure, say N.
-
-config FIRMWARE_EDID
-       bool "Enable firmware EDID"
-       depends on FB
-       default n
-       ---help---
-         This enables access to the EDID transferred from the firmware.
-	 On the i386, this is from the Video BIOS. Enable this if DDC/I2C
-	 transfers do not work for your driver and if you are using
-	 nvidiafb, i810fb or savagefb.
-
-	 In general, choosing Y for this option is safe.  If you
-	 experience extremely long delays while booting before you get
-	 something on your display, try setting this to N.  Matrox cards in
-	 combination with certain motherboards and monitors are known to
-	 suffer from this problem.
-
-config FB_DDC
-       tristate
-       depends on FB
-       select I2C_ALGOBIT
-       select I2C
-       default n
-
-config FB_BOOT_VESA_SUPPORT
-	bool
-	depends on FB
-	default n
-	---help---
-	  If true, at least one selected framebuffer driver can take advantage
-	  of VESA video modes set at an early boot stage via the vga= parameter.
-
-config FB_CFB_FILLRECT
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include the cfb_fillrect function for generic software rectangle
-	  filling. This is used by drivers that don't provide their own
-	  (accelerated) version.
-
-config FB_CFB_COPYAREA
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include the cfb_copyarea function for generic software area copying.
-	  This is used by drivers that don't provide their own (accelerated)
-	  version.
-
-config FB_CFB_IMAGEBLIT
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include the cfb_imageblit function for generic software image
-	  blitting. This is used by drivers that don't provide their own
-	  (accelerated) version.
-
-config FB_CFB_REV_PIXELS_IN_BYTE
-	bool
-	depends on FB
-	default n
-	---help---
-	  Allow generic frame-buffer functions to work on displays with 1, 2
-	  and 4 bits per pixel depths which has opposite order of pixels in
-	  byte order to bytes in long order.
-
-config FB_SYS_FILLRECT
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include the sys_fillrect function for generic software rectangle
-	  filling. This is used by drivers that don't provide their own
-	  (accelerated) version and the framebuffer is in system RAM.
-
-config FB_SYS_COPYAREA
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include the sys_copyarea function for generic software area copying.
-	  This is used by drivers that don't provide their own (accelerated)
-	  version and the framebuffer is in system RAM.
-
-config FB_SYS_IMAGEBLIT
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Include the sys_imageblit function for generic software image
-	  blitting. This is used by drivers that don't provide their own
-	  (accelerated) version and the framebuffer is in system RAM.
-
-menuconfig FB_FOREIGN_ENDIAN
-	bool "Framebuffer foreign endianness support"
-	depends on FB
-	---help---
-	  This menu will let you enable support for the framebuffers with
-	  non-native endianness (e.g. Little-Endian framebuffer on a
-	  Big-Endian machine). Most probably you don't have such hardware,
-	  so it's safe to say "n" here.
-
-choice
-	prompt "Choice endianness support"
-	depends on FB_FOREIGN_ENDIAN
-
-config FB_BOTH_ENDIAN
-	bool "Support for Big- and Little-Endian framebuffers"
-
-config FB_BIG_ENDIAN
-	bool "Support for Big-Endian framebuffers only"
-
-config FB_LITTLE_ENDIAN
-	bool "Support for Little-Endian framebuffers only"
-
-endchoice
-
-config FB_SYS_FOPS
-       tristate
-       depends on FB
-       default n
-
-config FB_DEFERRED_IO
-	bool
-	depends on FB
-
-config FB_HECUBA
-	tristate
-	depends on FB
-	depends on FB_DEFERRED_IO
-
-config FB_SVGALIB
-	tristate
-	depends on FB
-	default n
-	---help---
-	  Common utility functions useful to fbdev drivers of VGA-based
-	  cards.
-
-config FB_MACMODES
-       tristate
-       depends on FB
-       default n
-
-config FB_BACKLIGHT
-	bool
-	depends on FB
-	select BACKLIGHT_LCD_SUPPORT
-	select BACKLIGHT_CLASS_DEVICE
-	default n
-
-config FB_MODE_HELPERS
-        bool "Enable Video Mode Handling Helpers"
-        depends on FB
-	default n
-	---help---
-	  This enables functions for handling video modes using the
-	  Generalized Timing Formula and the EDID parser. A few drivers rely
-          on this feature such as the radeonfb, rivafb, and the i810fb. If
-	  your driver does not take advantage of this feature, choosing Y will
-	  just increase the kernel size by about 5K.
-
-config FB_TILEBLITTING
-       bool "Enable Tile Blitting Support"
-       depends on FB
-       default n
-       ---help---
-         This enables tile blitting.  Tile blitting is a drawing technique
-	 where the screen is divided into rectangular sections (tiles), whereas
-	 the standard blitting divides the screen into pixels. Because the
-	 default drawing element is a tile, drawing functions will be passed
-	 parameters in terms of number of tiles instead of number of pixels.
-	 For example, to draw a single character, instead of using bitmaps,
-	 an index to an array of bitmaps will be used.  To clear or move a
-	 rectangular section of a screen, the rectangle will be described in
-	 terms of number of tiles in the x- and y-axis.
-
-	 This is particularly important to one driver, matroxfb.  If
-	 unsure, say N.
-
-comment "Frame buffer hardware drivers"
-	depends on FB
-
-config FB_GRVGA
-	tristate "Aeroflex Gaisler framebuffer support"
-	depends on FB && SPARC
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	This enables support for the SVGACTRL framebuffer in the GRLIB IP library from Aeroflex Gaisler.
-
-config FB_CIRRUS
-	tristate "Cirrus Logic support"
-	depends on FB && (ZORRO || PCI)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  This enables support for Cirrus Logic GD542x/543x based boards on
-	  Amiga: SD64, Piccolo, Picasso II/II+, Picasso IV, or EGS Spectrum.
-
-	  If you have a PCI-based system, this enables support for these
-	  chips: GD-543x, GD-544x, GD-5480.
-
-	  Please read the file <file:Documentation/fb/cirrusfb.txt>.
-
-	  Say N unless you have such a graphics board or plan to get one
-	  before you next recompile the kernel.
-
-config FB_PM2
-	tristate "Permedia2 support"
-	depends on FB && ((AMIGA && BROKEN) || PCI)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for cards based on
-	  the 3D Labs Permedia, Permedia 2 and Permedia 2V chips.
-	  The driver was tested on the following cards:
-		Diamond FireGL 1000 PRO AGP
-		ELSA Gloria Synergy PCI
-		Appian Jeronimo PRO (both heads) PCI
-		3DLabs Oxygen ACX aka EONtronics Picasso P2 PCI
-		Techsource Raptor GFX-8P (aka Sun PGX-32) on SPARC
-		ASK Graphic Blaster Exxtreme AGP
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called pm2fb.
-
-config FB_PM2_FIFO_DISCONNECT
-	bool "enable FIFO disconnect feature"
-	depends on FB_PM2 && PCI
-	help
-	  Support the Permedia2 FIFO disconnect feature.
-
-config FB_ARMCLCD
-	tristate "ARM PrimeCell PL110 support"
-	depends on ARM || ARM64 || COMPILE_TEST
-	depends on FB && ARM_AMBA
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This framebuffer device driver is for the ARM PrimeCell PL110
-	  Colour LCD controller.  ARM PrimeCells provide the building
-	  blocks for System on a Chip devices.
-
-	  If you want to compile this as a module (=code which can be
-	  inserted into and removed from the running kernel), say M
-	  here and read <file:Documentation/kbuild/modules.txt>.  The module
-	  will be called amba-clcd.
-
-config FB_ACORN
-	bool "Acorn VIDC support"
-	depends on (FB = y) && ARM && ARCH_ACORN
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Acorn VIDC graphics
-	  hardware found in Acorn RISC PCs and other ARM-based machines.  If
-	  unsure, say N.
-
-config FB_CLPS711X
-	bool "CLPS711X LCD support"
-	depends on (FB = y) && ARM && ARCH_CLPS711X
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  Say Y to enable the Framebuffer driver for the CLPS7111 and
-	  EP7212 processors.
-
-config FB_SA1100
-	bool "SA-1100 LCD support"
-	depends on (FB = y) && ARM && ARCH_SA1100
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is a framebuffer device for the SA-1100 LCD Controller.
-	  See <http://www.linux-fbdev.org/> for information on framebuffer
-	  devices.
-
-	  If you plan to use the LCD display with your SA-1100 system, say
-	  Y here.
-
-config FB_IMX
-	tristate "Freescale i.MX1/21/25/27 LCD support"
-	depends on FB && IMX_HAVE_PLATFORM_IMX_FB
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MODE_HELPERS
-	select VIDEOMODE_HELPERS
-
-config FB_CYBER2000
-	tristate "CyberPro 2000/2010/5000 support"
-	depends on FB && PCI && (BROKEN || !SPARC64)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This enables support for the Integraphics CyberPro 20x0 and 5000
-	  VGA chips used in the Rebel.com Netwinder and other machines.
-	  Say Y if you have a NetWinder or a graphics card containing this
-	  device, otherwise say N.
-
-config FB_CYBER2000_DDC
-	bool "DDC for CyberPro support"
-	depends on FB_CYBER2000
-	select FB_DDC
-	default y
-	help
-	  Say Y here if you want DDC support for your CyberPro graphics
-	  card. This is only I2C bus support, driver does not use EDID.
-
-config FB_CYBER2000_I2C
-	bool "CyberPro 2000/2010/5000 I2C support"
-	depends on FB_CYBER2000 && I2C && ARCH_NETWINDER
-	select I2C_ALGOBIT
-	help
-	  Enable support for the I2C video decoder interface on the
-	  Integraphics CyberPro 20x0 and 5000 VGA chips.  This is used
-	  on the Netwinder machines for the SAA7111 video capture.
-
-config FB_APOLLO
-	bool
-	depends on (FB = y) && APOLLO
-	default y
-	select FB_CFB_FILLRECT
-	select FB_CFB_IMAGEBLIT
-
-config FB_Q40
-	bool
-	depends on (FB = y) && Q40
-	default y
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-
-config FB_AMIGA
-	tristate "Amiga native chipset support"
-	depends on FB && AMIGA
-	help
-	  This is the frame buffer device driver for the builtin graphics
-	  chipset found in Amigas.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called amifb.
-
-config FB_AMIGA_OCS
-	bool "Amiga OCS chipset support"
-	depends on FB_AMIGA
-	help
-	  This enables support for the original Agnus and Denise video chips,
-	  found in the Amiga 1000 and most A500's and A2000's. If you intend
-	  to run Linux on any of these systems, say Y; otherwise say N.
-
-config FB_AMIGA_ECS
-	bool "Amiga ECS chipset support"
-	depends on FB_AMIGA
-	help
-	  This enables support for the Enhanced Chip Set, found in later
-	  A500's, later A2000's, the A600, the A3000, the A3000T and CDTV. If
-	  you intend to run Linux on any of these systems, say Y; otherwise
-	  say N.
-
-config FB_AMIGA_AGA
-	bool "Amiga AGA chipset support"
-	depends on FB_AMIGA
-	help
-	  This enables support for the Advanced Graphics Architecture (also
-	  known as the AGA or AA) Chip Set, found in the A1200, A4000, A4000T
-	  and CD32. If you intend to run Linux on any of these systems, say Y;
-	  otherwise say N.
-
-config FB_FM2
-	bool "Amiga FrameMaster II/Rainbow II support"
-	depends on (FB = y) && ZORRO
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Amiga FrameMaster
-	  card from BSC (exhibited 1992 but not shipped as a CBM product).
-
-config FB_ARC
-	tristate "Arc Monochrome LCD board support"
-	depends on FB && X86
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	help
-	  This enables support for the Arc Monochrome LCD board. The board
-	  is based on the KS-108 lcd controller and is typically a matrix
-	  of 2*n chips. This driver was tested with a 128x64 panel. This
-	  driver supports it for use with x86 SBCs through a 16 bit GPIO
-	  interface (8 bit data, 8 bit control). If you anticipate using
-	  this driver, say Y or M; otherwise say N. You must specify the
-	  GPIO IO address to be used for setting control and data.
-
-config FB_ATARI
-	bool "Atari native chipset support"
-	depends on (FB = y) && ATARI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the builtin graphics
-	  chipset found in Ataris.
-
-config FB_OF
-	bool "Open Firmware frame buffer device support"
-	depends on (FB = y) && (PPC64 || PPC_OF) && (!PPC_PSERIES || PCI)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MACMODES
-	help
-	  Say Y if you want support with Open Firmware for your graphics
-	  board.
-
-config FB_CONTROL
-	bool "Apple \"control\" display support"
-	depends on (FB = y) && PPC_PMAC && PPC32
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MACMODES
-	help
-	  This driver supports a frame buffer for the graphics adapter in the
-	  Power Macintosh 7300 and others.
-
-config FB_PLATINUM
-	bool "Apple \"platinum\" display support"
-	depends on (FB = y) && PPC_PMAC && PPC32
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MACMODES
-	help
-	  This driver supports a frame buffer for the "platinum" graphics
-	  adapter in some Power Macintoshes.
-
-config FB_VALKYRIE
-	bool "Apple \"valkyrie\" display support"
-	depends on (FB = y) && (MAC || (PPC_PMAC && PPC32))
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MACMODES
-	help
-	  This driver supports a frame buffer for the "valkyrie" graphics
-	  adapter in some Power Macintoshes.
-
-config FB_CT65550
-	bool "Chips 65550 display support"
-	depends on (FB = y) && PPC32 && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Chips & Technologies
-	  65550 graphics chip in PowerBooks.
-
-config FB_ASILIANT
-	bool "Asiliant (Chips) 69000 display support"
-	depends on (FB = y) && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Asiliant 69030 chipset
-
-config FB_IMSTT
-	bool "IMS Twin Turbo display support"
-	depends on (FB = y) && PCI
-	select FB_CFB_IMAGEBLIT
-	select FB_MACMODES if PPC
-	help
-	  The IMS Twin Turbo is a PCI-based frame buffer card bundled with
-	  many Macintosh and compatible computers.
-
-config FB_VGA16
-	tristate "VGA 16-color graphics support"
-	depends on FB && (X86 || PPC)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select VGASTATE
-	select FONT_8x16 if FRAMEBUFFER_CONSOLE
-	help
-	  This is the frame buffer device driver for VGA 16 color graphic
-	  cards. Say Y if you have such a card.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called vga16fb.
-
-config FB_BF54X_LQ043
-	tristate "SHARP LQ043 TFT LCD (BF548 EZKIT)"
-	depends on FB && (BF54x) && !BF542
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	 This is the framebuffer device driver for a SHARP LQ043T1DG01 TFT LCD
-
-config FB_BFIN_T350MCQB
-	tristate "Varitronix COG-T350MCQB TFT LCD display (BF527 EZKIT)"
-	depends on FB && BLACKFIN
-	select BFIN_GPTIMERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	 This is the framebuffer device driver for a Varitronix VL-PS-COG-T350MCQB-01 display TFT LCD
-	 This display is a QVGA 320x240 24-bit RGB display interfaced by an 8-bit wide PPI
-	 It uses PPI[0..7] PPI_FS1, PPI_FS2 and PPI_CLK.
-
-config FB_BFIN_LQ035Q1
-	tristate "SHARP LQ035Q1DH02 TFT LCD"
-	depends on FB && BLACKFIN && SPI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select BFIN_GPTIMERS
-	help
-	  This is the framebuffer device driver for a SHARP LQ035Q1DH02 TFT display found on
-	  the Blackfin Landscape LCD EZ-Extender Card.
-	  This display is a QVGA 320x240 18-bit RGB display interfaced by an 16-bit wide PPI
-	  It uses PPI[0..15] PPI_FS1, PPI_FS2 and PPI_CLK.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bfin-lq035q1-fb.
-
-config FB_BF537_LQ035
-	tristate "SHARP LQ035 TFT LCD (BF537 STAMP)"
-	depends on FB && (BF534 || BF536 || BF537) && I2C_BLACKFIN_TWI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select BFIN_GPTIMERS
-	help
-	  This is the framebuffer device for a SHARP LQ035Q7DB03 TFT LCD
-	  attached to a BF537.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bf537-lq035.
-
-config FB_BFIN_7393
-	tristate "Blackfin ADV7393 Video encoder"
-	depends on FB && BLACKFIN
-	select I2C
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for a ADV7393 video encoder
-	  attached to a Blackfin on the PPI port.
-	  If your Blackfin board has a ADV7393 select Y.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bfin_adv7393fb.
-
-choice
-	prompt  "Video mode support"
-	depends on FB_BFIN_7393
-	default NTSC
-
-config NTSC
-	bool 'NTSC 720x480'
-
-config PAL
-	bool 'PAL 720x576'
-
-config NTSC_640x480
-	bool 'NTSC 640x480 (Experimental)'
-
-config PAL_640x480
-	bool 'PAL 640x480 (Experimental)'
-
-config NTSC_YCBCR
-	bool 'NTSC 720x480 YCbCR input'
-
-config PAL_YCBCR
-	bool 'PAL 720x576 YCbCR input'
-
-endchoice
-
-choice
-	prompt  "Size of ADV7393 frame buffer memory Single/Double Size"
-	depends on (FB_BFIN_7393)
-	default ADV7393_1XMEM
-
-config ADV7393_1XMEM
-	bool 'Single'
-
-config ADV7393_2XMEM
-	bool 'Double'
-endchoice
-
-config FB_STI
-	tristate "HP STI frame buffer device support"
-	depends on FB && PARISC
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select STI_CONSOLE
-	select VT
-	default y
-	---help---
-	  STI refers to the HP "Standard Text Interface" which is a set of
-	  BIOS routines contained in a ROM chip in HP PA-RISC based machines.
-	  Enabling this option will implement the linux framebuffer device
-	  using calls to the STI BIOS routines for initialisation.
-	
-	  If you enable this option, you will get a planar framebuffer device
-	  /dev/fb which will work on the most common HP graphic cards of the
-	  NGLE family, including the artist chips (in the 7xx and Bxxx series),
-	  HCRX, HCRX24, CRX, CRX24 and VisEG series.
-
-	  It is safe to enable this option, so you should probably say "Y".
-
-config FB_MAC
-	bool "Generic Macintosh display support"
-	depends on (FB = y) && MAC
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MACMODES
-
-config FB_HP300
-	bool
-	depends on (FB = y) && DIO
-	select FB_CFB_IMAGEBLIT
-	default y
-
-config FB_TGA
-	tristate "TGA/SFB+ framebuffer support"
-	depends on FB && (ALPHA || TC)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select BITREVERSE
-	---help---
-	  This is the frame buffer device driver for generic TGA and SFB+
-	  graphic cards.  These include DEC ZLXp-E1, -E2 and -E3 PCI cards,
-	  also known as PBXGA-A, -B and -C, and DEC ZLX-E1, -E2 and -E3
-	  TURBOchannel cards, also known as PMAGD-A, -B and -C.
-
-	  Due to hardware limitations ZLX-E2 and E3 cards are not supported
-	  for DECstation 5000/200 systems.  Additionally due to firmware
-	  limitations these cards may cause troubles with booting DECstation
-	  5000/240 and /260 systems, but are fully supported under Linux if
-	  you manage to get it going. ;-)
-
-	  Say Y if you have one of those.
-
-config FB_UVESA
-	tristate "Userspace VESA VGA graphics support"
-	depends on FB && CONNECTOR
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MODE_HELPERS
-	help
-	  This is the frame buffer driver for generic VBE 2.0 compliant
-	  graphic cards. It can also take advantage of VBE 3.0 features,
-	  such as refresh rate adjustment.
-
-	  This driver generally provides more features than vesafb but
-	  requires a userspace helper application called 'v86d'. See
-	  <file:Documentation/fb/uvesafb.txt> for more information.
-
-	  If unsure, say N.
-
-config FB_VESA
-	bool "VESA VGA graphics support"
-	depends on (FB = y) && X86
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_BOOT_VESA_SUPPORT
-	help
-	  This is the frame buffer device driver for generic VESA 2.0
-	  compliant graphic cards. The older VESA 1.2 cards are not supported.
-	  You will get a boot time penguin logo at no additional cost. Please
-	  read <file:Documentation/fb/vesafb.txt>. If unsure, say Y.
-
-config FB_EFI
-	bool "EFI-based Framebuffer Support"
-	depends on (FB = y) && X86 && EFI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the EFI frame buffer device driver. If the firmware on
-	  your platform is EFI 1.10 or UEFI 2.0, select Y to add support for
-	  using the EFI framebuffer as your console.
-
-config FB_N411
-       tristate "N411 Apollo/Hecuba devkit support"
-       depends on FB && X86 && MMU
-       select FB_SYS_FILLRECT
-       select FB_SYS_COPYAREA
-       select FB_SYS_IMAGEBLIT
-       select FB_SYS_FOPS
-       select FB_DEFERRED_IO
-       select FB_HECUBA
-       help
-         This enables support for the Apollo display controller in its
-         Hecuba form using the n411 devkit.
-
-config FB_HGA
-	tristate "Hercules mono graphics support"
-	depends on FB && X86
-	help
-	  Say Y here if you have a Hercules mono graphics card.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called hgafb.
-
-	  As this card technology is at least 25 years old,
-	  most people will answer N here.
-
-config FB_SGIVW
-	tristate "SGI Visual Workstation framebuffer support"
-	depends on FB && X86_VISWS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  SGI Visual Workstation support for framebuffer graphics.
-
-config FB_GBE
-	bool "SGI Graphics Backend frame buffer support"
-	depends on (FB = y) && (SGI_IP32 || X86_VISWS)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
- 	help
-	  This is the frame buffer device driver for SGI Graphics Backend.
-	  This chip is used in SGI O2 and Visual Workstation 320/540.
-
-config FB_GBE_MEM
-	int "Video memory size in MB"
-	depends on FB_GBE
-	default 4
-	help
-	  This is the amount of memory reserved for the framebuffer,
-	  which can be any value between 1MB and 8MB.
-
-config FB_SBUS
-	bool "SBUS and UPA framebuffers"
-	depends on (FB = y) && SPARC
-	help
-	  Say Y if you want support for SBUS or UPA based frame buffer device.
-
-config FB_BW2
-	bool "BWtwo support"
-	depends on (FB = y) && (SPARC && FB_SBUS)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the BWtwo frame buffer.
-
-config FB_CG3
-	bool "CGthree support"
-	depends on (FB = y) && (SPARC && FB_SBUS)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the CGthree frame buffer.
-
-config FB_CG6
-	bool "CGsix (GX,TurboGX) support"
-	depends on (FB = y) && (SPARC && FB_SBUS)
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the CGsix (GX, TurboGX)
-	  frame buffer.
-
-config FB_FFB
-	bool "Creator/Creator3D/Elite3D support"
-	depends on FB_SBUS && SPARC64
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Creator, Creator3D,
-	  and Elite3D graphics boards.
-
-config FB_TCX
-	bool "TCX (SS4/SS5 only) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the TCX 24/8bit frame
-	  buffer.
-
-config FB_CG14
-	bool "CGfourteen (SX) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the CGfourteen frame
-	  buffer on Desktop SPARCsystems with the SX graphics option.
-
-config FB_P9100
-	bool "P9100 (Sparcbook 3 only) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the P9100 card
-	  supported on Sparcbook 3 machines.
-
-config FB_LEO
-	bool "Leo (ZX) support"
-	depends on FB_SBUS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the SBUS-based Sun ZX
-	  (leo) frame buffer cards.
-
-config FB_IGA
-	bool "IGA 168x display support"
-	depends on (FB = y) && SPARC32
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for the INTERGRAPHICS 1680 and
-	  successor frame buffer cards.
-
-config FB_XVR500
-	bool "Sun XVR-500 3DLABS Wildcat support"
-	depends on (FB = y) && PCI && SPARC64
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for the Sun XVR-500 and similar
-	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
-	  only works on sparc64 systems where the system firmware has
-	  mostly initialized the card already.  It is treated as a
-	  completely dumb framebuffer device.
-
-config FB_XVR2500
-	bool "Sun XVR-2500 3DLABS Wildcat support"
-	depends on (FB = y) && PCI && SPARC64
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for the Sun XVR-2500 and similar
-	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
-	  only works on sparc64 systems where the system firmware has
-	  mostly initialized the card already.  It is treated as a
-	  completely dumb framebuffer device.
-
-config FB_XVR1000
-	bool "Sun XVR-1000 support"
-	depends on (FB = y) && SPARC64
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer device for the Sun XVR-1000 and similar
-	  graphics cards.  The driver only works on sparc64 systems where
-	  the system firmware has mostly initialized the card already.  It
-	  is treated as a completely dumb framebuffer device.
-
-config FB_PVR2
-	tristate "NEC PowerVR 2 display support"
-	depends on FB && SH_DREAMCAST
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Say Y here if you have a PowerVR 2 card in your box.  If you plan to
-	  run linux on your Dreamcast, you will have to say Y here.
-	  This driver may or may not work on other PowerVR 2 cards, but is
-	  totally untested.  Use at your own risk.  If unsure, say N.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called pvr2fb.
-
-	  You can pass several parameters to the driver at boot time or at
-	  module load time.  The parameters look like "video=pvr2:XXX", where
-	  the meaning of XXX can be found at the end of the main source file
-	  (<file:drivers/video/pvr2fb.c>). Please see the file
-	  <file:Documentation/fb/pvr2fb.txt>.
-
-config FB_OPENCORES
-	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
-	depends on FB
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This enables support for the OpenCores VGA/LCD core.
-
-	  The OpenCores VGA/LCD core is typically used together with
-	  softcore CPUs (e.g. OpenRISC or Microblaze) or hard processor
-	  systems (e.g. Altera socfpga or Xilinx Zynq) on FPGAs.
-
-	  The source code and specification for the core is available at
-	  <http://opencores.org/project,vga_lcd>
-
-config FB_S1D13XXX
-	tristate "Epson S1D13XXX framebuffer support"
-	depends on FB
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  Support for S1D13XXX framebuffer device family (currently only
-	  working with S1D13806). Product specs at
-	  <http://vdc.epson.com/>
-
-config FB_ATMEL
-	tristate "AT91/AT32 LCD Controller support"
-	depends on FB && HAVE_FB_ATMEL
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MODE_HELPERS
-	select VIDEOMODE_HELPERS
-	help
-	  This enables support for the AT91/AT32 LCD Controller.
-
-config FB_INTSRAM
-	bool "Frame Buffer in internal SRAM"
-	depends on FB_ATMEL && ARCH_AT91SAM9261
-	help
-	  Say Y if you want to map Frame Buffer in internal SRAM. Say N if you want
-	  to let frame buffer in external SDRAM.
-
-config FB_ATMEL_STN
-	bool "Use a STN display with AT91/AT32 LCD Controller"
-	depends on FB_ATMEL && (MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK)
-	default n
-	help
-	  Say Y if you want to connect a STN LCD display to the AT91/AT32 LCD
-	  Controller. Say N if you want to connect a TFT.
-
-	  If unsure, say N.
-
-config FB_NVIDIA
-	tristate "nVidia Framebuffer Support"
-	depends on FB && PCI
-	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select BITREVERSE
-	select VGASTATE
-	help
-	  This driver supports graphics boards with the nVidia chips, TNT
-	  and newer. For very old chipsets, such as the RIVA128, then use
-	  the rivafb.
-	  Say Y if you have such a graphics board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called nvidiafb.
-
-config FB_NVIDIA_I2C
-       bool "Enable DDC Support"
-       depends on FB_NVIDIA
-       select FB_DDC
-       help
-	  This enables I2C support for nVidia Chipsets.  This is used
-	  only for getting EDID information from the attached display
-	  allowing for robust video mode handling and switching.
-
-	  Because fbdev-2.6 requires that drivers must be able to
-	  independently validate video mode parameters, you should say Y
-	  here.
-
-config FB_NVIDIA_DEBUG
-	bool "Lots of debug output"
-	depends on FB_NVIDIA
-	default n
-	help
-	  Say Y here if you want the nVidia driver to output all sorts
-	  of debugging information to provide to the maintainer when
-	  something goes wrong.
-
-config FB_NVIDIA_BACKLIGHT
-	bool "Support for backlight control"
-	depends on FB_NVIDIA
-	default y
-	help
-	  Say Y here if you want to control the backlight of your display.
-
-config FB_RIVA
-	tristate "nVidia Riva support"
-	depends on FB && PCI
-	select FB_BACKLIGHT if FB_RIVA_BACKLIGHT
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select BITREVERSE
-	select VGASTATE
-	help
-	  This driver supports graphics boards with the nVidia Riva/Geforce
-	  chips.
-	  Say Y if you have such a graphics board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called rivafb.
-
-config FB_RIVA_I2C
-       bool "Enable DDC Support"
-       depends on FB_RIVA
-       select FB_DDC
-       help
-	  This enables I2C support for nVidia Chipsets.  This is used
-	  only for getting EDID information from the attached display
-	  allowing for robust video mode handling and switching.
-
-	  Because fbdev-2.6 requires that drivers must be able to
-	  independently validate video mode parameters, you should say Y
-	  here.
-
-config FB_RIVA_DEBUG
-	bool "Lots of debug output"
-	depends on FB_RIVA
-	default n
-	help
-	  Say Y here if you want the Riva driver to output all sorts
-	  of debugging information to provide to the maintainer when
-	  something goes wrong.
-
-config FB_RIVA_BACKLIGHT
-	bool "Support for backlight control"
-	depends on FB_RIVA
-	default y
-	help
-	  Say Y here if you want to control the backlight of your display.
-
-config FB_I740
-	tristate "Intel740 support"
-	depends on FB && PCI
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select VGASTATE
-	select FB_DDC
-	help
-	  This driver supports graphics cards based on Intel740 chip.
-
-config FB_I810
-	tristate "Intel 810/815 support"
-	depends on FB && PCI && X86_32 && AGP_INTEL
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select VGASTATE
-	help
-	  This driver supports the on-board graphics built in to the Intel 810 
-          and 815 chipsets.  Say Y if you have and plan to use such a board.
-
-          To compile this driver as a module, choose M here: the
-	  module will be called i810fb.
-
-          For more information, please read 
-	  <file:Documentation/fb/intel810.txt>
-
-config FB_I810_GTF
-	bool "use VESA Generalized Timing Formula"
-	depends on FB_I810
-	help
-	  If you say Y, then the VESA standard, Generalized Timing Formula 
-          or GTF, will be used to calculate the required video timing values
-	  per video mode.  Since the GTF allows nondiscrete timings 
-          (nondiscrete being a range of values as opposed to discrete being a
-          set of values), you'll be able to use any combination of horizontal 
-	  and vertical resolutions, and vertical refresh rates without having
-	  to specify your own timing parameters.  This is especially useful
-	  to maximize the performance of an aging display, or if you just 
-          have a display with nonstandard dimensions. A VESA compliant 
-	  monitor is recommended, but can still work with non-compliant ones.
-	  If you need or want this, then select this option. The timings may 
-	  not be compliant with Intel's recommended values. Use at your own 
-	  risk.
-
-          If you say N, the driver will revert to discrete video timings 
-	  using a set recommended by Intel in their documentation.
-  
-          If unsure, say N.
-
-config FB_I810_I2C
-	bool "Enable DDC Support"
-	depends on FB_I810 && FB_I810_GTF
-	select FB_DDC
-	help
-
-config FB_LE80578
-	tristate "Intel LE80578 (Vermilion) support"
-	depends on FB && PCI && X86
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This driver supports the LE80578 (Vermilion Range) chipset
-
-config FB_CARILLO_RANCH
-	tristate "Intel Carillo Ranch support"
-	depends on FB_LE80578 && FB && PCI && X86
-	help
-	  This driver supports the LE80578 (Carillo Ranch) board
-
-config FB_INTEL
-	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support"
-	depends on FB && PCI && X86 && AGP_INTEL && EXPERT
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
-	depends on !DRM_I915
-	help
-	  This driver supports the on-board graphics built in to the Intel
-          830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
-          Say Y if you have and plan to use such a board.
-
-	  To make FB_INTELFB=Y work you need to say AGP_INTEL=y too.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called intelfb.
-
-	  For more information, please read <file:Documentation/fb/intelfb.txt>
-
-config FB_INTEL_DEBUG
-	bool "Intel driver Debug Messages"
-	depends on FB_INTEL
-	---help---
-	  Say Y here if you want the Intel driver to output all sorts
-	  of debugging information to provide to the maintainer when
-	  something goes wrong.
-
-config FB_INTEL_I2C
-	bool "DDC/I2C for Intel framebuffer support"
-	depends on FB_INTEL
-	select FB_DDC
-	default y
-	help
-	  Say Y here if you want DDC/I2C support for your on-board Intel graphics.
-
-config FB_MATROX
-	tristate "Matrox acceleration"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_TILEBLITTING
-	select FB_MACMODES if PPC_PMAC
-	---help---
-	  Say Y here if you have a Matrox Millennium, Matrox Millennium II,
-	  Matrox Mystique, Matrox Mystique 220, Matrox Productiva G100, Matrox
-	  Mystique G200, Matrox Millennium G200, Matrox Marvel G200 video,
-	  Matrox G400, G450 or G550 card in your box.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called matroxfb.
-
-	  You can pass several parameters to the driver at boot time or at
-	  module load time. The parameters look like "video=matroxfb:XXX", and
-	  are described in <file:Documentation/fb/matroxfb.txt>.
-
-config FB_MATROX_MILLENIUM
-	bool "Millennium I/II support"
-	depends on FB_MATROX
-	help
-	  Say Y here if you have a Matrox Millennium or Matrox Millennium II
-	  video card. If you select "Advanced lowlevel driver options" below,
-	  you should check 4 bpp packed pixel, 8 bpp packed pixel, 16 bpp
-	  packed pixel, 24 bpp packed pixel and 32 bpp packed pixel. You can
-	  also use font widths different from 8.
-
-config FB_MATROX_MYSTIQUE
-	bool "Mystique support"
-	depends on FB_MATROX
-	help
-	  Say Y here if you have a Matrox Mystique or Matrox Mystique 220
-	  video card. If you select "Advanced lowlevel driver options" below,
-	  you should check 8 bpp packed pixel, 16 bpp packed pixel, 24 bpp
-	  packed pixel and 32 bpp packed pixel. You can also use font widths
-	  different from 8.
-
-config FB_MATROX_G
-	bool "G100/G200/G400/G450/G550 support"
-	depends on FB_MATROX
-	---help---
-	  Say Y here if you have a Matrox G100, G200, G400, G450 or G550 based
-	  video card. If you select "Advanced lowlevel driver options", you
-	  should check 8 bpp packed pixel, 16 bpp packed pixel, 24 bpp packed
-	  pixel and 32 bpp packed pixel. You can also use font widths
-	  different from 8.
-
-	  If you need support for G400 secondary head, you must say Y to
-	  "Matrox I2C support" and "G400 second head support" right below.
-	  G450/G550 secondary head and digital output are supported without
-	  additional modules.
-
-	  The driver starts in monitor mode. You must use the matroxset tool 
-	  (available at <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to 
-	  swap primary and secondary head outputs, or to change output mode.  
-	  Secondary head driver always start in 640x480 resolution and you 
-	  must use fbset to change it.
-
-	  Do not forget that second head supports only 16 and 32 bpp
-	  packed pixels, so it is a good idea to compile them into the kernel
-	  too. You can use only some font widths, as the driver uses generic
-	  painting procedures (the secondary head does not use acceleration
-	  engine).
-
-	  G450/G550 hardware can display TV picture only from secondary CRTC,
-	  and it performs no scaling, so picture must have 525 or 625 lines.
-
-config FB_MATROX_I2C
-	tristate "Matrox I2C support"
-	depends on FB_MATROX
-	select FB_DDC
-	---help---
-	  This drivers creates I2C buses which are needed for accessing the
-	  DDC (I2C) bus present on all Matroxes, an I2C bus which
-	  interconnects Matrox optional devices, like MGA-TVO on G200 and
-	  G400, and the secondary head DDC bus, present on G400 only.
-
-	  You can say Y or M here if you want to experiment with monitor
-	  detection code. You must say Y or M here if you want to use either
-	  second head of G400 or MGA-TVO on G200 or G400.
-
-	  If you compile it as module, it will create a module named
-	  i2c-matroxfb.
-
-config FB_MATROX_MAVEN
-	tristate "G400 second head support"
-	depends on FB_MATROX_G && FB_MATROX_I2C
-	---help---
-	  WARNING !!! This support does not work with G450 !!!
-
-	  Say Y or M here if you want to use a secondary head (meaning two
-	  monitors in parallel) on G400 or MGA-TVO add-on on G200. Secondary
-	  head is not compatible with accelerated XFree 3.3.x SVGA servers -
-	  secondary head output is blanked while you are in X. With XFree
-	  3.9.17 preview you can use both heads if you use SVGA over fbdev or
-	  the fbdev driver on first head and the fbdev driver on second head.
-
-	  If you compile it as module, two modules are created,
-	  matroxfb_crtc2 and matroxfb_maven. Matroxfb_maven is needed for
-	  both G200 and G400, matroxfb_crtc2 is needed only by G400. You must
-	  also load i2c-matroxfb to get it to run.
-
-	  The driver starts in monitor mode and you must use the matroxset
-	  tool (available at
-	  <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to switch it to
-	  PAL or NTSC or to swap primary and secondary head outputs.
-	  Secondary head driver also always start in 640x480 resolution, you
-	  must use fbset to change it.
-
-	  Also do not forget that second head supports only 16 and 32 bpp
-	  packed pixels, so it is a good idea to compile them into the kernel
-	  too.  You can use only some font widths, as the driver uses generic
-	  painting procedures (the secondary head does not use acceleration
-	  engine).
-
-config FB_RADEON
-	tristate "ATI Radeon display support"
-	depends on FB && PCI
-	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MACMODES if PPC_OF
-	help
-	  Choose this option if you want to use an ATI Radeon graphics card as
-	  a framebuffer device.  There are both PCI and AGP versions.  You
-	  don't need to choose this to run the Radeon in plain VGA mode.
-
-	  There is a product page at
-	  http://products.amd.com/en-us/GraphicCardResult.aspx
-
-config FB_RADEON_I2C
-	bool "DDC/I2C for ATI Radeon support"
-	depends on FB_RADEON
-	select FB_DDC
-	default y
-	help
-	  Say Y here if you want DDC/I2C support for your Radeon board. 
-
-config FB_RADEON_BACKLIGHT
-	bool "Support for backlight control"
-	depends on FB_RADEON
-	default y
-	help
-	  Say Y here if you want to control the backlight of your display.
-
-config FB_RADEON_DEBUG
-	bool "Lots of debug output from Radeon driver"
-	depends on FB_RADEON
-	default n
-	help
-	  Say Y here if you want the Radeon driver to output all sorts
-	  of debugging information to provide to the maintainer when
-	  something goes wrong.
-
-config FB_ATY128
-	tristate "ATI Rage128 display support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_BACKLIGHT if FB_ATY128_BACKLIGHT
-	select FB_MACMODES if PPC_PMAC
-	help
-	  This driver supports graphics boards with the ATI Rage128 chips.
-	  Say Y if you have such a graphics board and read
-	  <file:Documentation/fb/aty128fb.txt>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called aty128fb.
-
-config FB_ATY128_BACKLIGHT
-	bool "Support for backlight control"
-	depends on FB_ATY128
-	default y
-	help
-	  Say Y here if you want to control the backlight of your display.
-
-config FB_ATY
-	tristate "ATI Mach64 display support" if PCI || ATARI
-	depends on FB && !SPARC32
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_BACKLIGHT if FB_ATY_BACKLIGHT
-	select FB_MACMODES if PPC
-	help
-	  This driver supports graphics boards with the ATI Mach64 chips.
-	  Say Y if you have such a graphics board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called atyfb.
-
-config FB_ATY_CT
-	bool "Mach64 CT/VT/GT/LT (incl. 3D RAGE) support"
-	depends on PCI && FB_ATY
-	default y if SPARC64 && PCI
-	help
-	  Say Y here to support use of ATI's 64-bit Rage boards (or other
-	  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
-	  framebuffer device.  The ATI product support page for these boards
-	  is at <http://support.ati.com/products/pc/mach64/mach64.html>.
-
-config FB_ATY_GENERIC_LCD
-	bool "Mach64 generic LCD support"
-	depends on FB_ATY_CT
-	help
-	  Say Y if you have a laptop with an ATI Rage LT PRO, Rage Mobility,
-	  Rage XC, or Rage XL chipset.
-
-config FB_ATY_GX
-	bool "Mach64 GX support" if PCI
-	depends on FB_ATY
-	default y if ATARI
-	help
-	  Say Y here to support use of the ATI Mach64 Graphics Expression
-	  board (or other boards based on the Mach64 GX chipset) as a
-	  framebuffer device.  The ATI product support page for these boards
-	  is at
-	  <http://support.ati.com/products/pc/mach64/graphics_xpression.html>.
-
-config FB_ATY_BACKLIGHT
-	bool "Support for backlight control"
-	depends on FB_ATY
-	default y
-	help
-	  Say Y here if you want to control the backlight of your display.
-
-config FB_S3
-	tristate "S3 Trio/Virge support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_TILEBLITTING
-	select FB_SVGALIB
-	select VGASTATE
-	select FONT_8x16 if FRAMEBUFFER_CONSOLE
-	---help---
-	  Driver for graphics boards with S3 Trio / S3 Virge chip.
-
-config FB_S3_DDC
-	bool "DDC for S3 support"
-	depends on FB_S3
-	select FB_DDC
-	default y
-	help
-	  Say Y here if you want DDC support for your S3 graphics card.
-
-config FB_SAVAGE
-	tristate "S3 Savage support"
-	depends on FB && PCI
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select VGASTATE
-	help
-	  This driver supports notebooks and computers with S3 Savage PCI/AGP
-	  chips.
-
-	  Say Y if you have such a graphics card.
-
-	  To compile this driver as a module, choose M here; the module
-	  will be called savagefb.
-
-config FB_SAVAGE_I2C
-       bool "Enable DDC2 Support"
-       depends on FB_SAVAGE
-       select FB_DDC
-       help
-	  This enables I2C support for S3 Savage Chipsets.  This is used
-	  only for getting EDID information from the attached display
-	  allowing for robust video mode handling and switching.
-
-	  Because fbdev-2.6 requires that drivers must be able to
-	  independently validate video mode parameters, you should say Y
-	  here.
-
-config FB_SAVAGE_ACCEL
-       bool "Enable Console Acceleration"
-       depends on FB_SAVAGE
-       default n
-       help
-          This option will compile in console acceleration support. If
-          the resulting framebuffer console has bothersome glitches, then
-          choose N here.
-
-config FB_SIS
-	tristate "SiS/XGI display support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_BOOT_VESA_SUPPORT if FB_SIS = y
-	help
-	  This is the frame buffer device driver for the SiS 300, 315, 330
-	  and 340 series as well as XGI V3XT, V5, V8, Z7 graphics chipsets.
-	  Specs available at <http://www.sis.com> and <http://www.xgitech.com>.
-
-	  To compile this driver as a module, choose M here; the module
-	  will be called sisfb.
-
-config FB_SIS_300
-	bool "SiS 300 series support"
-	depends on FB_SIS
-	help
-	  Say Y here to support use of the SiS 300/305, 540, 630 and 730.
-
-config FB_SIS_315
-	bool "SiS 315/330/340 series and XGI support"
-	depends on FB_SIS
-	help
-	  Say Y here to support use of the SiS 315, 330 and 340 series
-	  (315/H/PRO, 55x, 650, 651, 740, 330, 661, 741, 760, 761) as well
-	  as XGI V3XT, V5, V8 and Z7.
-
-config FB_VIA
-       tristate "VIA UniChrome (Pro) and Chrome9 display support"
-       depends on FB && PCI && X86
-       select FB_CFB_FILLRECT
-       select FB_CFB_COPYAREA
-       select FB_CFB_IMAGEBLIT
-       select I2C_ALGOBIT
-       select I2C
-       select GPIOLIB
-       help
-	  This is the frame buffer device driver for Graphics chips of VIA
-	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
-	  CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family (K8M890,CN896
- 	  /P4M900,VX800)
-	  Say Y if you have a VIA UniChrome graphics board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called viafb.
-
-if FB_VIA
-
-config FB_VIA_DIRECT_PROCFS
-	bool "direct hardware access via procfs (DEPRECATED)(DANGEROUS)"
-	depends on FB_VIA
-	default n
-	help
-	  Allow direct hardware access to some output registers via procfs.
-	  This is dangerous but may provide the only chance to get the
-	  correct output device configuration.
-	  Its use is strongly discouraged.
-
-config FB_VIA_X_COMPATIBILITY
-	bool "X server compatibility"
-	depends on FB_VIA
-	default n
-	help
-	  This option reduces the functionality (power saving, ...) of the
-	  framebuffer to avoid negative impact on the OpenChrome X server.
-	  If you use any X server other than fbdev you should enable this
-	  otherwise it should be safe to disable it and allow using all
-	  features.
-
-endif
-
-config FB_NEOMAGIC
-	tristate "NeoMagic display support"
-	depends on FB && PCI
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select VGASTATE
-	help
-	  This driver supports notebooks with NeoMagic PCI chips.
-	  Say Y if you have such a graphics card. 
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called neofb.
-
-config FB_KYRO
-	tristate "IMG Kyro support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  Say Y here if you have a STG4000 / Kyro / PowerVR 3 based
-	  graphics board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called kyrofb.
-
-config FB_3DFX
-	tristate "3Dfx Banshee/Voodoo3/Voodoo5 display support"
-	depends on FB && PCI
-	select FB_CFB_IMAGEBLIT
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_MODE_HELPERS
-	help
-	  This driver supports graphics boards with the 3Dfx Banshee,
-	  Voodoo3 or VSA-100 (aka Voodoo4/5) chips. Say Y if you have
-	  such a graphics board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tdfxfb.
-
-config FB_3DFX_ACCEL
-	bool "3Dfx Acceleration functions"
-	depends on FB_3DFX
-	---help---
-	This will compile the 3Dfx Banshee/Voodoo3/VSA-100 frame buffer
-	device driver with acceleration functions.
-
-config FB_3DFX_I2C
-	bool "Enable DDC/I2C support"
-	depends on FB_3DFX
-	select FB_DDC
-	default y
-	help
-	  Say Y here if you want DDC/I2C support for your 3dfx Voodoo3.
-
-config FB_VOODOO1
-	tristate "3Dfx Voodoo Graphics (sst1) support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Say Y here if you have a 3Dfx Voodoo Graphics (Voodoo1/sst1) or 
-	  Voodoo2 (cvg) based graphics card.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called sstfb.
-
-	  WARNING: Do not use any application that uses the 3D engine
-	  (namely glide) while using this driver.
-	  Please read the <file:Documentation/fb/sstfb.txt> for supported
-	  options and other important info  support.
-
-config FB_VT8623
-	tristate "VIA VT8623 support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_TILEBLITTING
-	select FB_SVGALIB
-	select VGASTATE
-	select FONT_8x16 if FRAMEBUFFER_CONSOLE
-	---help---
-	  Driver for CastleRock integrated graphics core in the
-	  VIA VT8623 [Apollo CLE266] chipset.
-
-config FB_TRIDENT
-	tristate "Trident/CyberXXX/CyberBlade support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  This is the frame buffer device driver for Trident PCI/AGP chipsets.
-	  Supported chipset families are TGUI 9440/96XX, 3DImage, Blade3D
-	  and Blade XP.
-	  There are also integrated versions of these chips called CyberXXXX,
-	  CyberImage or CyberBlade. These chips are mostly found in laptops
-	  but also on some motherboards including early VIA EPIA motherboards.
-	  For more information, read <file:Documentation/fb/tridentfb.txt>
-
-	  Say Y if you have such a graphics board.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called tridentfb.
-
-config FB_ARK
-	tristate "ARK 2000PV support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_TILEBLITTING
-	select FB_SVGALIB
-	select VGASTATE
-	select FONT_8x16 if FRAMEBUFFER_CONSOLE
-	---help---
-	  Driver for PCI graphics boards with ARK 2000PV chip
-	  and ICS 5342 RAMDAC.
-
-config FB_PM3
-	tristate "Permedia3 support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the 3DLabs Permedia3
-	  chipset, used in Formac ProFormance III, 3DLabs Oxygen VX1 &
-	  similar boards, 3DLabs Permedia3 Create!, Appian Jeronimo 2000
-	  and maybe other boards.
-
-config FB_CARMINE
-	tristate "Fujitsu carmine frame buffer support"
-	depends on FB && PCI
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Fujitsu Carmine chip.
-	  The driver provides two independent frame buffer devices.
-
-choice
-	depends on FB_CARMINE
-	prompt "DRAM timing"
-	default FB_CARMINE_DRAM_EVAL
-
-config FB_CARMINE_DRAM_EVAL
-	bool "Eval board timings"
-	help
-	  Use timings which work on the eval card.
-
-config CARMINE_DRAM_CUSTOM
-	bool "Custom board timings"
-	help
-	  Use custom board timings.
-endchoice
-
-config FB_AU1100
-	bool "Au1100 LCD Driver"
-	depends on (FB = y) && MIPS_ALCHEMY
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the framebuffer driver for the AMD Au1100 SOC.  It can drive
-	  various panels and CRTs by passing in kernel cmd line option
-	  au1100fb:panel=<name>.
-
-config FB_AU1200
-	bool "Au1200/Au1300 LCD Driver"
-	depends on (FB = y) && MIPS_ALCHEMY
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	help
-	  This is the framebuffer driver for the Au1200/Au1300 SOCs.
-	  It can drive various panels and CRTs by passing in kernel cmd line
-	  option au1200fb:panel=<name>.
-
-config FB_VT8500
-	bool "VIA VT8500 framebuffer support"
-	depends on (FB = y) && ARM && ARCH_VT8500
-	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
-	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
-	select FB_SYS_IMAGEBLIT
-	select FB_MODE_HELPERS
-	select VIDEOMODE_HELPERS
-	help
-	  This is the framebuffer driver for VIA VT8500 integrated LCD
-	  controller.
-
-config FB_WM8505
-	bool "Wondermedia WM8xxx-series frame buffer support"
-	depends on (FB = y) && ARM && ARCH_VT8500
-	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
-	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
-	select FB_SYS_IMAGEBLIT
-	select FB_MODE_HELPERS
-	select VIDEOMODE_HELPERS
-	help
-	  This is the framebuffer driver for WonderMedia WM8xxx-series
-	  integrated LCD controller. This driver covers the WM8505, WM8650
-	  and WM8850 SoCs.
-
-config FB_WMT_GE_ROPS
-	bool "VT8500/WM8xxx accelerated raster ops support"
-	depends on (FB = y) && (FB_VT8500 || FB_WM8505)
-	default n
-	help
-	  This adds support for accelerated raster operations on the
-	  VIA VT8500 and Wondermedia 85xx series SoCs.
-
-source "drivers/video/geode/Kconfig"
-
-config FB_HIT
-	tristate "HD64461 Frame Buffer support"
-	depends on FB && HD64461
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This is the frame buffer device driver for the Hitachi HD64461 LCD
-	  frame buffer card.
-
-config FB_PMAG_AA
-	bool "PMAG-AA TURBOchannel framebuffer support"
-	depends on (FB = y) && TC
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
-	help
-	  Support for the PMAG-AA TURBOchannel framebuffer card (1280x1024x1)
-	  used mainly in the MIPS-based DECstation series.
-
-config FB_PMAG_BA
-	tristate "PMAG-BA TURBOchannel framebuffer support"
-	depends on FB && TC
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
-	help
-	  Support for the PMAG-BA TURBOchannel framebuffer card (1024x864x8)
-	  used mainly in the MIPS-based DECstation series.
-
-config FB_PMAGB_B
-	tristate "PMAGB-B TURBOchannel framebuffer support"
-	depends on FB && TC
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
-	help
-	  Support for the PMAGB-B TURBOchannel framebuffer card used mainly
-	  in the MIPS-based DECstation series. The card is currently only
-	  supported in 1280x1024x8 mode.
-
-config FB_MAXINE
-	bool "Maxine (Personal DECstation) onboard framebuffer support"
-	depends on (FB = y) && MACH_DECSTATION
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
-	help
-	  Support for the onboard framebuffer (1024x768x8) in the Personal
-	  DECstation series (Personal DECstation 5000/20, /25, /33, /50,
-	  Codename "Maxine").
-
-config FB_G364
-	bool "G364 frame buffer support"
-	depends on (FB = y) && (MIPS_MAGNUM_4000 || OLIVETTI_M700)
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
-	help
-	  The G364 driver is the framebuffer used in MIPS Magnum 4000 and
-	  Olivetti M700-10 systems.
-
-config FB_68328
-	bool "Motorola 68328 native frame buffer support"
-	depends on (FB = y) && (M68328 || M68EZ328 || M68VZ328)
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
-	help
-	  Say Y here if you want to support the built-in frame buffer of
-	  the Motorola 68328 CPU family.
-
-config FB_PXA168
-	tristate "PXA168/910 LCD framebuffer support"
-	depends on FB && (CPU_PXA168 || CPU_PXA910)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for the built-in LCD controller in the Marvell
-	  MMP processor.
-
-config FB_PXA
-	tristate "PXA LCD framebuffer support"
-	depends on FB && ARCH_PXA
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for the built-in LCD controller in the Intel
-	  PXA2x0 processor.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted and removed from the running kernel whenever you want). The
-	  module will be called pxafb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/kbuild/modules.txt>.
-
-	  If unsure, say N.
-
-config FB_PXA_OVERLAY
-	bool "Support PXA27x/PXA3xx Overlay(s) as framebuffer"
-	default n
-	depends on FB_PXA && (PXA27x || PXA3xx)
-
-config FB_PXA_SMARTPANEL
-	bool "PXA Smartpanel LCD support"
-	default n
-	depends on FB_PXA
-
-config FB_PXA_PARAMETERS
-	bool "PXA LCD command line parameters"
-	default n
-	depends on FB_PXA
-	---help---
-	  Enable the use of kernel command line or module parameters
-	  to configure the physical properties of the LCD panel when
-	  using the PXA LCD driver.
-
-	  This option allows you to override the panel parameters
-	  supplied by the platform in order to support multiple
-	  different models of flatpanel. If you will only be using a
-	  single model of flatpanel then you can safely leave this
-	  option disabled.
-
-	  <file:Documentation/fb/pxafb.txt> describes the available parameters.
-
-config PXA3XX_GCU
-	tristate "PXA3xx 2D graphics accelerator driver"
-	depends on FB_PXA
-	help
-	  Kernelspace driver for the 2D graphics controller unit (GCU)
-	  found on PXA3xx processors. There is a counterpart driver in the
-	  DirectFB suite, see http://www.directfb.org/
-
-	  If you compile this as a module, it will be called pxa3xx_gcu.
-
-config FB_MBX
-	tristate "2700G LCD framebuffer support"
-	depends on FB && ARCH_PXA
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Framebuffer driver for the Intel 2700G (Marathon) Graphics
-	  Accelerator
-
-config FB_MBX_DEBUG
-       bool "Enable debugging info via debugfs"
-       depends on FB_MBX && DEBUG_FS
-       default n
-       ---help---
-         Enable this if you want debugging information using the debug
-         filesystem (debugfs)
-
-         If unsure, say N.
-
-config FB_FSL_DIU
-	tristate "Freescale DIU framebuffer support"
-	depends on FB && FSL_SOC
-	select FB_MODE_HELPERS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select PPC_LIB_RHEAP
-	---help---
-	  Framebuffer driver for the Freescale SoC DIU
-
-config FB_W100
-	tristate "W100 frame buffer support"
-	depends on FB && ARCH_PXA
- 	select FB_CFB_FILLRECT
- 	select FB_CFB_COPYAREA
- 	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for the w100 as found on the Sharp SL-Cxx series.
-	  It can also drive the w3220 chip found on iPAQ hx4700.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted and removed from the running kernel whenever you want). The
-	  module will be called w100fb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/kbuild/modules.txt>.
-
-	  If unsure, say N.
-
-config FB_SH_MOBILE_LCDC
-	tristate "SuperH Mobile LCDC framebuffer support"
-	depends on FB && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select FB_DEFERRED_IO
-	select FB_BACKLIGHT
-	select SH_MIPI_DSI if SH_LCD_MIPI_DSI
-	---help---
-	  Frame buffer driver for the on-chip SH-Mobile LCD controller.
-
-config FB_SH_MOBILE_HDMI
-	tristate "SuperH Mobile HDMI controller support"
-	depends on FB_SH_MOBILE_LCDC
-	select FB_MODE_HELPERS
-	select SOUND
-	select SND
-	select SND_SOC
-	---help---
-	  Driver for the on-chip SH-Mobile HDMI controller.
-
-config FB_TMIO
-	tristate "Toshiba Mobile IO FrameBuffer support"
-	depends on FB && MFD_CORE
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for the Toshiba Mobile IO integrated as found
-	  on the Sharp SL-6000 series
-
-	  This driver is also available as a module ( = code which can be
-	  inserted and removed from the running kernel whenever you want). The
-	  module will be called tmiofb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/kbuild/modules.txt>.
-
-	  If unsure, say N.
-
-config FB_TMIO_ACCELL
-	bool "tmiofb acceleration"
-	depends on FB_TMIO
-	default y
-
-config FB_S3C
-	tristate "Samsung S3C framebuffer support"
-	depends on FB && (CPU_S3C2416 || ARCH_S3C64XX || ARCH_S5P64X0 || \
-		ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for the built-in FB controller in the Samsung
-	  SoC line from the S3C2443 onwards, including the S3C2416, S3C2450,
-	  and the S3C64XX series such as the S3C6400 and S3C6410.
-
-	  These chips all have the same basic framebuffer design with the
-	  actual capabilities depending on the chip. For instance the S3C6400
-	  and S3C6410 support 4 hardware windows whereas the S3C24XX series
-	  currently only have two.
-
-	  Currently the support is only for the S3C6400 and S3C6410 SoCs.
-
-config FB_S3C_DEBUG_REGWRITE
-       bool "Debug register writes"
-       depends on FB_S3C
-       ---help---
-         Show all register writes via pr_debug()
-
-config FB_S3C2410
-	tristate "S3C2410 LCD framebuffer support"
-	depends on FB && ARCH_S3C24XX
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for the built-in LCD controller in the Samsung
-	  S3C2410 processor.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted and removed from the running kernel whenever you want). The
-	  module will be called s3c2410fb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/kbuild/modules.txt>.
-
-	  If unsure, say N.
-config FB_S3C2410_DEBUG
-	bool "S3C2410 lcd debug messages"
-	depends on FB_S3C2410
-	help
-	  Turn on debugging messages. Note that you can set/unset at run time
-	  through sysfs
-
-config FB_NUC900
-        bool "NUC900 LCD framebuffer support"
-        depends on FB && ARCH_W90X900
-        select FB_CFB_FILLRECT
-        select FB_CFB_COPYAREA
-        select FB_CFB_IMAGEBLIT
-        ---help---
-          Frame buffer driver for the built-in LCD controller in the Nuvoton
-          NUC900 processor
-
-config GPM1040A0_320X240
-        bool "Giantplus Technology GPM1040A0 320x240 Color TFT LCD"
-        depends on FB_NUC900
-
-config FB_SM501
-	tristate "Silicon Motion SM501 framebuffer support"
-	depends on FB && MFD_SM501
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for the CRT and LCD controllers in the Silicon
-	  Motion SM501.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted and removed from the running kernel whenever you want). The
-	  module will be called sm501fb. If you want to compile it as a module,
-	  say M here and read <file:Documentation/kbuild/modules.txt>.
-
-	  If unsure, say N.
-
-config FB_SMSCUFX
-	tristate "SMSC UFX6000/7000 USB Framebuffer support"
-	depends on FB && USB
-	select FB_MODE_HELPERS
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select FB_DEFERRED_IO
-	---help---
-	  This is a kernel framebuffer driver for SMSC UFX USB devices.
-	  Supports fbdev clients like xf86-video-fbdev, kdrive, fbi, and
-	  mplayer -vo fbdev. Supports both UFX6000 (USB 2.0) and UFX7000
-	  (USB 3.0) devices.
-	  To compile as a module, choose M here: the module name is smscufx.
-
-config FB_UDL
-	tristate "Displaylink USB Framebuffer support"
-	depends on FB && USB
-	select FB_MODE_HELPERS
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select FB_DEFERRED_IO
-	---help---
-	  This is a kernel framebuffer driver for DisplayLink USB devices.
-	  Supports fbdev clients like xf86-video-fbdev, kdrive, fbi, and
-	  mplayer -vo fbdev. Supports all USB 2.0 era DisplayLink devices.
-	  To compile as a module, choose M here: the module name is udlfb.
-
-config FB_IBM_GXT4500
-	tristate "Framebuffer support for IBM GXT4000P/4500P/6000P/6500P adaptors"
-	depends on FB && PPC
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Say Y here to enable support for the IBM GXT4000P/6000P and
-	  GXT4500P/6500P display adaptor based on Raster Engine RC1000,
-	  found on some IBM System P (pSeries) machines. This driver
-	  doesn't use Geometry Engine GT1000.
-
-config FB_PS3
-	tristate "PS3 GPU framebuffer driver"
-	depends on FB && PS3_PS3AV
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
-	---help---
-	  Include support for the virtual frame buffer in the PS3 platform.
-
-config FB_PS3_DEFAULT_SIZE_M
-	int "PS3 default frame buffer size (in MiB)"
-	depends on FB_PS3
-	default 9
-	---help---
-	  This is the default size (in MiB) of the virtual frame buffer in
-	  the PS3.
-	  The default value can be overridden on the kernel command line
-	  using the "ps3fb" option (e.g. "ps3fb=9M");
-
-config FB_XILINX
-	tristate "Xilinx frame buffer support"
-	depends on FB && (XILINX_VIRTEX || MICROBLAZE || ARCH_ZYNQ)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Include support for the Xilinx ML300/ML403 reference design
-	  framebuffer. ML300 carries a 640*480 LCD display on the board,
-	  ML403 uses a standard DB15 VGA connector.
-
-config FB_GOLDFISH
-	tristate "Goldfish Framebuffer"
-	depends on FB && HAS_DMA
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Framebuffer driver for Goldfish Virtual Platform
-
-config FB_COBALT
-	tristate "Cobalt server LCD frame buffer support"
-	depends on FB && (MIPS_COBALT || MIPS_SEAD3)
-
-config FB_SH7760
-	bool "SH7760/SH7763/SH7720/SH7721 LCDC support"
-	depends on FB && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
-		|| CPU_SUBTYPE_SH7720 || CPU_SUBTYPE_SH7721)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Support for the SH7760/SH7763/SH7720/SH7721 integrated
-	  (D)STN/TFT LCD Controller.
-	  Supports display resolutions up to 1024x1024 pixel, grayscale and
-	  color operation, with depths ranging from 1 bpp to 8 bpp monochrome
-	  and 8, 15 or 16 bpp color; 90 degrees clockwise display rotation for
-	  panels <= 320 pixel horizontal resolution.
-
-config FB_DA8XX
-	tristate "DA8xx/OMAP-L1xx/AM335x Framebuffer support"
-	depends on FB && (ARCH_DAVINCI_DA8XX || SOC_AM33XX)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_CFB_REV_PIXELS_IN_BYTE
-	select FB_MODE_HELPERS
-	select VIDEOMODE_HELPERS
-	---help---
-	  This is the frame buffer device driver for the TI LCD controller
-	  found on DA8xx/OMAP-L1xx/AM335x SoCs.
-	  If unsure, say N.
-
-config FB_VIRTUAL
-	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
-	depends on FB
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	---help---
-	  This is a `virtual' frame buffer device. It operates on a chunk of
-	  unswappable kernel memory instead of on the memory of a graphics
-	  board. This means you cannot see any output sent to this frame
-	  buffer device, while it does consume precious memory. The main use
-	  of this frame buffer device is testing and debugging the frame
-	  buffer subsystem. Do NOT enable it for normal systems! To protect
-	  the innocent, it has to be enabled explicitly at boot time using the
-	  kernel option `video=vfb:'.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called vfb. In order to load it, you must use
-	  the vfb_enable=1 option.
-
-	  If unsure, say N.
-
-config XEN_FBDEV_FRONTEND
-	tristate "Xen virtual frame buffer support"
-	depends on FB && XEN
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select FB_DEFERRED_IO
-	select INPUT_XEN_KBDDEV_FRONTEND if INPUT_MISC
-	select XEN_XENBUS_FRONTEND
-	default y
-	help
-	  This driver implements the front-end of the Xen virtual
-	  frame buffer driver.  It communicates with a back-end
-	  in another domain.
-
-config FB_METRONOME
-	tristate "E-Ink Metronome/8track controller support"
-	depends on FB
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select FB_DEFERRED_IO
-	help
-	  This driver implements support for the E-Ink Metronome
-	  controller. The pre-release name for this device was 8track
-	  and could also have been called by some vendors as PVI-nnnn.
-
-config FB_MB862XX
-	tristate "Fujitsu MB862xx GDC support"
-	depends on FB
-	depends on PCI || (OF && PPC)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Frame buffer driver for Fujitsu Carmine/Coral-P(A)/Lime controllers.
-
-choice
-	prompt "GDC variant"
-	depends on FB_MB862XX
-
-config FB_MB862XX_PCI_GDC
-	bool "Carmine/Coral-P(A) GDC"
-	depends on PCI
-	---help---
-	  This enables framebuffer support for Fujitsu Carmine/Coral-P(A)
-	  PCI graphics controller devices.
-
-config FB_MB862XX_LIME
-	bool "Lime GDC"
-	depends on OF && PPC
-	select FB_FOREIGN_ENDIAN
-	select FB_LITTLE_ENDIAN
-	---help---
-	  Framebuffer support for Fujitsu Lime GDC on host CPU bus.
-
-endchoice
-
-config FB_MB862XX_I2C
-	bool "Support I2C bus on MB862XX GDC"
-	depends on FB_MB862XX && I2C
-	default y
-	help
-	  Selecting this option adds Coral-P(A)/Lime GDC I2C bus adapter
-	  driver to support accessing I2C devices on controller's I2C bus.
-	  These are usually some video decoder chips.
-
-config FB_EP93XX
-	tristate "EP93XX frame buffer support"
-	depends on FB && ARCH_EP93XX
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	---help---
-	  Framebuffer driver for the Cirrus Logic EP93XX series of processors.
-	  This driver is also available as a module. The module will be called
-	  ep93xx-fb.
-
-config FB_PRE_INIT_FB
-	bool "Don't reinitialize, use bootloader's GDC/Display configuration"
-	depends on FB && FB_MB862XX_LIME
-	---help---
-	  Select this option if display contents should be inherited as set by
-	  the bootloader.
-
-config FB_MSM
-	tristate "MSM Framebuffer support"
-	depends on FB && ARCH_MSM
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-
-config FB_MX3
-	tristate "MX3 Framebuffer support"
-	depends on FB && MX3_IPU
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	default y
-	help
-	  This is a framebuffer device for the i.MX31 LCD Controller. So
-	  far only synchronous displays are supported. If you plan to use
-	  an LCD display with your i.MX31 system, say Y here.
-
-config FB_BROADSHEET
-	tristate "E-Ink Broadsheet/Epson S1D13521 controller support"
-	depends on FB
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select FB_DEFERRED_IO
-	help
-	  This driver implements support for the E-Ink Broadsheet
-	  controller. The release name for this device was Epson S1D13521
-	  and could also have been called by other names when coupled with
-	  a bridge adapter.
-
-config FB_AUO_K190X
-	tristate "AUO-K190X EPD controller support"
-	depends on FB
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	select FB_DEFERRED_IO
-	help
-	  Provides support for epaper controllers from the K190X series
-	  of AUO. These controllers can be used to drive epaper displays
-	  from Sipix.
-
-	  This option enables the common support, shared by the individual
-	  controller drivers. You will also have to enable the driver
-	  for the controller type used in your device.
-
-config FB_AUO_K1900
-	tristate "AUO-K1900 EPD controller support"
-	depends on FB && FB_AUO_K190X
-	help
-	  This driver implements support for the AUO K1900 epd-controller.
-	  This controller can drive Sipix epaper displays but can only do
-	  serial updates, reducing the number of possible frames per second.
-
-config FB_AUO_K1901
-	tristate "AUO-K1901 EPD controller support"
-	depends on FB && FB_AUO_K190X
-	help
-	  This driver implements support for the AUO K1901 epd-controller.
-	  This controller can drive Sipix epaper displays and supports
-	  concurrent updates, making higher frames per second possible.
-
-config FB_JZ4740
-	tristate "JZ4740 LCD framebuffer support"
-	depends on FB && MACH_JZ4740
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	help
-	  Framebuffer support for the JZ4740 SoC.
-
-config FB_MXS
-	tristate "MXS LCD framebuffer support"
-	depends on FB && ARCH_MXS
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	select FB_MODE_HELPERS
-	select VIDEOMODE_HELPERS
-	help
-	  Framebuffer support for the MXS SoC.
-
-config FB_PUV3_UNIGFX
-	tristate "PKUnity v3 Unigfx framebuffer support"
-	depends on FB && UNICORE32 && ARCH_PUV3
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_SYS_FOPS
-	help
-	  Choose this option if you want to use the Unigfx device as a
-	  framebuffer device. Without the support of PCI & AGP.
-
-config FB_HYPERV
-	tristate "Microsoft Hyper-V Synthetic Video support"
-	depends on FB && HYPERV
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  This framebuffer driver supports Microsoft Hyper-V Synthetic Video.
-
-config FB_SIMPLE
-	bool "Simple framebuffer support"
-	depends on (FB = y)
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
-	help
-	  Say Y if you want support for a simple frame-buffer.
-
-	  This driver assumes that the display hardware has been initialized
-	  before the kernel boots, and the kernel will simply render to the
-	  pre-allocated frame buffer surface.
-
-	  Configuration re: surface address, size, and format must be provided
-	  through device tree, or plain old platform data.
-
-source "drivers/video/omap/Kconfig"
-source "drivers/video/omap2/Kconfig"
-source "drivers/video/exynos/Kconfig"
-source "drivers/video/mmp/Kconfig"
-source "drivers/video/backlight/Kconfig"
-
 if VT
 	source "drivers/video/console/Kconfig"
 endif
 
 if FB || SGI_NEWPORT_CONSOLE
 	source "drivers/video/logo/Kconfig"
-endif
 
-config FB_SH_MOBILE_MERAM
-	tristate "SuperH Mobile MERAM read ahead support"
-	depends on (SUPERH || ARCH_SHMOBILE)
-	select GENERIC_ALLOCATOR
-	---help---
-	  Enable MERAM support for the SuperH controller.
-
-	  This will allow for caching of the framebuffer to provide more
-	  reliable access under heavy main memory bus traffic situations.
-	  Up to 4 memory channels can be configured, allowing 4 RGB or
-	  2 YCbCr framebuffers to be configured.
+endif
 
-config FB_SSD1307
-	tristate "Solomon SSD1307 framebuffer support"
-	depends on FB && I2C
-	depends on OF
-	depends on GPIOLIB
-	select FB_SYS_FOPS
-	select FB_SYS_FILLRECT
-	select FB_SYS_COPYAREA
-	select FB_SYS_IMAGEBLIT
-	select FB_DEFERRED_IO
-	select PWM
-	help
-	  This driver implements support for the Solomon SSD1307
-	  OLED controller over I2C.
 
 endmenu
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index ae17ddf49a00..94fe9c486c60 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -1,179 +1,15 @@
-# Makefile for the Linux video drivers.
-# 5 Aug 1999, James Simmons, <mailto:jsimmons@users.sf.net>
-# Rewritten to use lists instead of if-statements.
-
-# Each configuration option enables a list of files.
-
 obj-$(CONFIG_VGASTATE)            += vgastate.o
 obj-$(CONFIG_HDMI)                += hdmi.o
-obj-y                             += fb_notify.o
-obj-$(CONFIG_FB)                  += fb.o
-fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
-                                     modedb.o fbcvt.o
-fb-objs                           := $(fb-y)
 
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
 obj-y				  += backlight/
 
-obj-$(CONFIG_EXYNOS_VIDEO)     += exynos/
-
-obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
-obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
-obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
-obj-$(CONFIG_FB_SYS_FILLRECT)  += sysfillrect.o
-obj-$(CONFIG_FB_SYS_COPYAREA)  += syscopyarea.o
-obj-$(CONFIG_FB_SYS_IMAGEBLIT) += sysimgblt.o
-obj-$(CONFIG_FB_SYS_FOPS)      += fb_sys_fops.o
-obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
-obj-$(CONFIG_FB_MACMODES)      += macmodes.o
-obj-$(CONFIG_FB_DDC)           += fb_ddc.o
-obj-$(CONFIG_FB_DEFERRED_IO)   += fb_defio.o
-obj-$(CONFIG_FB_WMT_GE_ROPS)   += wmt_ge_rops.o
-
-# Hardware specific drivers go first
-obj-$(CONFIG_FB_AMIGA)            += amifb.o c2p_planar.o
-obj-$(CONFIG_FB_ARC)              += arcfb.o
-obj-$(CONFIG_FB_CLPS711X)         += clps711xfb.o
-obj-$(CONFIG_FB_CYBER2000)        += cyber2000fb.o
-obj-$(CONFIG_FB_GRVGA)            += grvga.o
-obj-$(CONFIG_FB_PM2)              += pm2fb.o
-obj-$(CONFIG_FB_PM3)		  += pm3fb.o
-
-obj-$(CONFIG_FB_I740)		  += i740fb.o
-obj-$(CONFIG_FB_MATROX)		  += matrox/
-obj-$(CONFIG_FB_RIVA)		  += riva/
-obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
-obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
-obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
-obj-$(CONFIG_FB_RADEON)		  += aty/
-obj-$(CONFIG_FB_SIS)		  += sis/
-obj-$(CONFIG_FB_VIA)		  += via/
-obj-$(CONFIG_FB_KYRO)             += kyro/
-obj-$(CONFIG_FB_SAVAGE)		  += savage/
-obj-$(CONFIG_FB_GEODE)		  += geode/
-obj-$(CONFIG_FB_MBX)		  += mbx/
-obj-$(CONFIG_FB_NEOMAGIC)         += neofb.o
-obj-$(CONFIG_FB_3DFX)             += tdfxfb.o
-obj-$(CONFIG_FB_CONTROL)          += controlfb.o
-obj-$(CONFIG_FB_PLATINUM)         += platinumfb.o
-obj-$(CONFIG_FB_VALKYRIE)         += valkyriefb.o
-obj-$(CONFIG_FB_CT65550)          += chipsfb.o
-obj-$(CONFIG_FB_IMSTT)            += imsttfb.o
-obj-$(CONFIG_FB_FM2)              += fm2fb.o
-obj-$(CONFIG_FB_VT8623)           += vt8623fb.o
-obj-$(CONFIG_FB_TRIDENT)          += tridentfb.o
-obj-$(CONFIG_FB_LE80578)          += vermilion/
-obj-$(CONFIG_FB_S3)               += s3fb.o
-obj-$(CONFIG_FB_ARK)              += arkfb.o
-obj-$(CONFIG_FB_STI)              += stifb.o
-obj-$(CONFIG_FB_FFB)              += ffb.o sbuslib.o
-obj-$(CONFIG_FB_CG6)              += cg6.o sbuslib.o
-obj-$(CONFIG_FB_CG3)              += cg3.o sbuslib.o
-obj-$(CONFIG_FB_BW2)              += bw2.o sbuslib.o
-obj-$(CONFIG_FB_CG14)             += cg14.o sbuslib.o
-obj-$(CONFIG_FB_P9100)            += p9100.o sbuslib.o
-obj-$(CONFIG_FB_TCX)              += tcx.o sbuslib.o
-obj-$(CONFIG_FB_LEO)              += leo.o sbuslib.o
-obj-$(CONFIG_FB_SGIVW)            += sgivwfb.o
-obj-$(CONFIG_FB_ACORN)            += acornfb.o
-obj-$(CONFIG_FB_ATARI)            += atafb.o c2p_iplan2.o atafb_mfb.o \
-                                     atafb_iplan2p2.o atafb_iplan2p4.o atafb_iplan2p8.o
-obj-$(CONFIG_FB_MAC)              += macfb.o
-obj-$(CONFIG_FB_HECUBA)           += hecubafb.o
-obj-$(CONFIG_FB_N411)             += n411.o
-obj-$(CONFIG_FB_HGA)              += hgafb.o
-obj-$(CONFIG_FB_XVR500)           += sunxvr500.o
-obj-$(CONFIG_FB_XVR2500)          += sunxvr2500.o
-obj-$(CONFIG_FB_XVR1000)          += sunxvr1000.o
-obj-$(CONFIG_FB_IGA)              += igafb.o
-obj-$(CONFIG_FB_APOLLO)           += dnfb.o
-obj-$(CONFIG_FB_Q40)              += q40fb.o
-obj-$(CONFIG_FB_TGA)              += tgafb.o
-obj-$(CONFIG_FB_HP300)            += hpfb.o
-obj-$(CONFIG_FB_G364)             += g364fb.o
-obj-$(CONFIG_FB_EP93XX)		  += ep93xx-fb.o
-obj-$(CONFIG_FB_SA1100)           += sa1100fb.o
-obj-$(CONFIG_FB_HIT)              += hitfb.o
-obj-$(CONFIG_FB_ATMEL)		  += atmel_lcdfb.o
-obj-$(CONFIG_FB_PVR2)             += pvr2fb.o
-obj-$(CONFIG_FB_VOODOO1)          += sstfb.o
-obj-$(CONFIG_FB_ARMCLCD)	  += amba-clcd.o
-obj-$(CONFIG_FB_GOLDFISH)         += goldfishfb.o
-obj-$(CONFIG_FB_68328)            += 68328fb.o
-obj-$(CONFIG_FB_GBE)              += gbefb.o
-obj-$(CONFIG_FB_CIRRUS)		  += cirrusfb.o
-obj-$(CONFIG_FB_ASILIANT)	  += asiliantfb.o
-obj-$(CONFIG_FB_PXA)		  += pxafb.o
-obj-$(CONFIG_FB_PXA168)		  += pxa168fb.o
-obj-$(CONFIG_PXA3XX_GCU)	  += pxa3xx-gcu.o
-obj-$(CONFIG_MMP_DISP)           += mmp/
-obj-$(CONFIG_FB_W100)		  += w100fb.o
-obj-$(CONFIG_FB_TMIO)		  += tmiofb.o
-obj-$(CONFIG_FB_AU1100)		  += au1100fb.o
-obj-$(CONFIG_FB_AU1200)		  += au1200fb.o
-obj-$(CONFIG_FB_VT8500)		  += vt8500lcdfb.o
-obj-$(CONFIG_FB_WM8505)		  += wm8505fb.o
-obj-$(CONFIG_FB_PMAG_AA)	  += pmag-aa-fb.o
-obj-$(CONFIG_FB_PMAG_BA)	  += pmag-ba-fb.o
-obj-$(CONFIG_FB_PMAGB_B)	  += pmagb-b-fb.o
-obj-$(CONFIG_FB_MAXINE)		  += maxinefb.o
-obj-$(CONFIG_FB_METRONOME)        += metronomefb.o
-obj-$(CONFIG_FB_BROADSHEET)       += broadsheetfb.o
-obj-$(CONFIG_FB_AUO_K190X)	  += auo_k190x.o
-obj-$(CONFIG_FB_AUO_K1900)	  += auo_k1900fb.o
-obj-$(CONFIG_FB_AUO_K1901)	  += auo_k1901fb.o
-obj-$(CONFIG_FB_S1D13XXX)	  += s1d13xxxfb.o
-obj-$(CONFIG_FB_SH7760)		  += sh7760fb.o
-obj-$(CONFIG_FB_IMX)              += imxfb.o
-obj-$(CONFIG_FB_S3C)		  += s3c-fb.o
-obj-$(CONFIG_FB_S3C2410)	  += s3c2410fb.o
-obj-$(CONFIG_FB_FSL_DIU)	  += fsl-diu-fb.o
-obj-$(CONFIG_FB_COBALT)           += cobalt_lcdfb.o
-obj-$(CONFIG_FB_IBM_GXT4500)	  += gxt4500.o
-obj-$(CONFIG_FB_PS3)		  += ps3fb.o
-obj-$(CONFIG_FB_SM501)            += sm501fb.o
-obj-$(CONFIG_FB_UDL)		  += udlfb.o
-obj-$(CONFIG_FB_SMSCUFX)	  += smscufx.o
-obj-$(CONFIG_FB_XILINX)           += xilinxfb.o
-obj-$(CONFIG_SH_MIPI_DSI)	  += sh_mipi_dsi.o
-obj-$(CONFIG_FB_SH_MOBILE_HDMI)	  += sh_mobile_hdmi.o
-obj-$(CONFIG_FB_SH_MOBILE_MERAM)  += sh_mobile_meram.o
-obj-$(CONFIG_FB_SH_MOBILE_LCDC)	  += sh_mobile_lcdcfb.o
-obj-$(CONFIG_FB_OMAP)             += omap/
-obj-y                             += omap2/
-obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
-obj-$(CONFIG_FB_CARMINE)          += carminefb.o
-obj-$(CONFIG_FB_MB862XX)	  += mb862xx/
-obj-$(CONFIG_FB_MSM)              += msm/
-obj-$(CONFIG_FB_NUC900)           += nuc900fb.o
-obj-$(CONFIG_FB_JZ4740)		  += jz4740_fb.o
-obj-$(CONFIG_FB_PUV3_UNIGFX)      += fb-puv3.o
-obj-$(CONFIG_FB_HYPERV)		  += hyperv_fb.o
-obj-$(CONFIG_FB_OPENCORES)	  += ocfb.o
-
-# Platform or fallback drivers go here
-obj-$(CONFIG_FB_UVESA)            += uvesafb.o
-obj-$(CONFIG_FB_VESA)             += vesafb.o
-obj-$(CONFIG_FB_EFI)              += efifb.o
-obj-$(CONFIG_FB_VGA16)            += vga16fb.o
-obj-$(CONFIG_FB_OF)               += offb.o
-obj-$(CONFIG_FB_BF537_LQ035)      += bf537-lq035.o
-obj-$(CONFIG_FB_BF54X_LQ043)	  += bf54x-lq043fb.o
-obj-$(CONFIG_FB_BFIN_LQ035Q1)     += bfin-lq035q1-fb.o
-obj-$(CONFIG_FB_BFIN_T350MCQB)	  += bfin-t350mcqb-fb.o
-obj-$(CONFIG_FB_BFIN_7393)        += bfin_adv7393fb.o
-obj-$(CONFIG_FB_MX3)		  += mx3fb.o
-obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
-obj-$(CONFIG_FB_MXS)		  += mxsfb.o
-obj-$(CONFIG_FB_SSD1307)	  += ssd1307fb.o
-obj-$(CONFIG_FB_SIMPLE)           += simplefb.o
-
-# the test framebuffer is last
-obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
+obj-y				  += fbdev/
 
 #video output switch sysfs driver
 obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
+
 obj-$(CONFIG_VIDEOMODE_HELPERS) += display_timing.o videomode.o
 ifeq ($(CONFIG_OF),y)
 obj-$(CONFIG_VIDEOMODE_HELPERS) += of_display_timing.o of_videomode.o
diff --git a/drivers/video/68328fb.c b/drivers/video/fbdev/68328fb.c
similarity index 100%
rename from drivers/video/68328fb.c
rename to drivers/video/fbdev/68328fb.c
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
new file mode 100644
index 000000000000..582987896f8d
--- /dev/null
+++ b/drivers/video/fbdev/Kconfig
@@ -0,0 +1,2481 @@
+#
+# fbdev configuration
+#
+
+menuconfig FB
+	tristate "Support for frame buffer devices"
+	---help---
+	  The frame buffer device provides an abstraction for the graphics
+	  hardware. It represents the frame buffer of some video hardware and
+	  allows application software to access the graphics hardware through
+	  a well-defined interface, so the software doesn't need to know
+	  anything about the low-level (hardware register) stuff.
+
+	  Frame buffer devices work identically across the different
+	  architectures supported by Linux and make the implementation of
+	  application programs easier and more portable; at this point, an X
+	  server exists which uses the frame buffer device exclusively.
+	  On several non-X86 architectures, the frame buffer device is the
+	  only way to use the graphics hardware.
+
+	  The device is accessed through special device nodes, usually located
+	  in the /dev directory, i.e. /dev/fb*.
+
+	  You need an utility program called fbset to make full use of frame
+	  buffer devices. Please read <file:Documentation/fb/framebuffer.txt>
+	  and the Framebuffer-HOWTO at
+	  <http://www.munted.org.uk/programming/Framebuffer-HOWTO-1.3.html> for more
+	  information.
+
+	  Say Y here and to the driver for your graphics board below if you
+	  are compiling a kernel for a non-x86 architecture.
+
+	  If you are compiling for the x86 architecture, you can say Y if you
+	  want to play with it, but it is not essential. Please note that
+	  running graphical applications that directly touch the hardware
+	  (e.g. an accelerated X server) and that are not frame buffer
+	  device-aware may cause unexpected results. If unsure, say N.
+
+config FIRMWARE_EDID
+       bool "Enable firmware EDID"
+       depends on FB
+       default n
+       ---help---
+         This enables access to the EDID transferred from the firmware.
+	 On the i386, this is from the Video BIOS. Enable this if DDC/I2C
+	 transfers do not work for your driver and if you are using
+	 nvidiafb, i810fb or savagefb.
+
+	 In general, choosing Y for this option is safe.  If you
+	 experience extremely long delays while booting before you get
+	 something on your display, try setting this to N.  Matrox cards in
+	 combination with certain motherboards and monitors are known to
+	 suffer from this problem.
+
+config FB_DDC
+       tristate
+       depends on FB
+       select I2C_ALGOBIT
+       select I2C
+       default n
+
+config FB_BOOT_VESA_SUPPORT
+	bool
+	depends on FB
+	default n
+	---help---
+	  If true, at least one selected framebuffer driver can take advantage
+	  of VESA video modes set at an early boot stage via the vga= parameter.
+
+config FB_CFB_FILLRECT
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the cfb_fillrect function for generic software rectangle
+	  filling. This is used by drivers that don't provide their own
+	  (accelerated) version.
+
+config FB_CFB_COPYAREA
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the cfb_copyarea function for generic software area copying.
+	  This is used by drivers that don't provide their own (accelerated)
+	  version.
+
+config FB_CFB_IMAGEBLIT
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the cfb_imageblit function for generic software image
+	  blitting. This is used by drivers that don't provide their own
+	  (accelerated) version.
+
+config FB_CFB_REV_PIXELS_IN_BYTE
+	bool
+	depends on FB
+	default n
+	---help---
+	  Allow generic frame-buffer functions to work on displays with 1, 2
+	  and 4 bits per pixel depths which has opposite order of pixels in
+	  byte order to bytes in long order.
+
+config FB_SYS_FILLRECT
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the sys_fillrect function for generic software rectangle
+	  filling. This is used by drivers that don't provide their own
+	  (accelerated) version and the framebuffer is in system RAM.
+
+config FB_SYS_COPYAREA
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the sys_copyarea function for generic software area copying.
+	  This is used by drivers that don't provide their own (accelerated)
+	  version and the framebuffer is in system RAM.
+
+config FB_SYS_IMAGEBLIT
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Include the sys_imageblit function for generic software image
+	  blitting. This is used by drivers that don't provide their own
+	  (accelerated) version and the framebuffer is in system RAM.
+
+menuconfig FB_FOREIGN_ENDIAN
+	bool "Framebuffer foreign endianness support"
+	depends on FB
+	---help---
+	  This menu will let you enable support for the framebuffers with
+	  non-native endianness (e.g. Little-Endian framebuffer on a
+	  Big-Endian machine). Most probably you don't have such hardware,
+	  so it's safe to say "n" here.
+
+choice
+	prompt "Choice endianness support"
+	depends on FB_FOREIGN_ENDIAN
+
+config FB_BOTH_ENDIAN
+	bool "Support for Big- and Little-Endian framebuffers"
+
+config FB_BIG_ENDIAN
+	bool "Support for Big-Endian framebuffers only"
+
+config FB_LITTLE_ENDIAN
+	bool "Support for Little-Endian framebuffers only"
+
+endchoice
+
+config FB_SYS_FOPS
+       tristate
+       depends on FB
+       default n
+
+config FB_DEFERRED_IO
+	bool
+	depends on FB
+
+config FB_HECUBA
+	tristate
+	depends on FB
+	depends on FB_DEFERRED_IO
+
+config FB_SVGALIB
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Common utility functions useful to fbdev drivers of VGA-based
+	  cards.
+
+config FB_MACMODES
+       tristate
+       depends on FB
+       default n
+
+config FB_BACKLIGHT
+	bool
+	depends on FB
+	select BACKLIGHT_LCD_SUPPORT
+	select BACKLIGHT_CLASS_DEVICE
+	default n
+
+config FB_MODE_HELPERS
+        bool "Enable Video Mode Handling Helpers"
+        depends on FB
+	default n
+	---help---
+	  This enables functions for handling video modes using the
+	  Generalized Timing Formula and the EDID parser. A few drivers rely
+          on this feature such as the radeonfb, rivafb, and the i810fb. If
+	  your driver does not take advantage of this feature, choosing Y will
+	  just increase the kernel size by about 5K.
+
+config FB_TILEBLITTING
+       bool "Enable Tile Blitting Support"
+       depends on FB
+       default n
+       ---help---
+         This enables tile blitting.  Tile blitting is a drawing technique
+	 where the screen is divided into rectangular sections (tiles), whereas
+	 the standard blitting divides the screen into pixels. Because the
+	 default drawing element is a tile, drawing functions will be passed
+	 parameters in terms of number of tiles instead of number of pixels.
+	 For example, to draw a single character, instead of using bitmaps,
+	 an index to an array of bitmaps will be used.  To clear or move a
+	 rectangular section of a screen, the rectangle will be described in
+	 terms of number of tiles in the x- and y-axis.
+
+	 This is particularly important to one driver, matroxfb.  If
+	 unsure, say N.
+
+comment "Frame buffer hardware drivers"
+	depends on FB
+
+config FB_GRVGA
+	tristate "Aeroflex Gaisler framebuffer support"
+	depends on FB && SPARC
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	This enables support for the SVGACTRL framebuffer in the GRLIB IP library from Aeroflex Gaisler.
+
+config FB_CIRRUS
+	tristate "Cirrus Logic support"
+	depends on FB && (ZORRO || PCI)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  This enables support for Cirrus Logic GD542x/543x based boards on
+	  Amiga: SD64, Piccolo, Picasso II/II+, Picasso IV, or EGS Spectrum.
+
+	  If you have a PCI-based system, this enables support for these
+	  chips: GD-543x, GD-544x, GD-5480.
+
+	  Please read the file <file:Documentation/fb/cirrusfb.txt>.
+
+	  Say N unless you have such a graphics board or plan to get one
+	  before you next recompile the kernel.
+
+config FB_PM2
+	tristate "Permedia2 support"
+	depends on FB && ((AMIGA && BROKEN) || PCI)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for cards based on
+	  the 3D Labs Permedia, Permedia 2 and Permedia 2V chips.
+	  The driver was tested on the following cards:
+		Diamond FireGL 1000 PRO AGP
+		ELSA Gloria Synergy PCI
+		Appian Jeronimo PRO (both heads) PCI
+		3DLabs Oxygen ACX aka EONtronics Picasso P2 PCI
+		Techsource Raptor GFX-8P (aka Sun PGX-32) on SPARC
+		ASK Graphic Blaster Exxtreme AGP
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pm2fb.
+
+config FB_PM2_FIFO_DISCONNECT
+	bool "enable FIFO disconnect feature"
+	depends on FB_PM2 && PCI
+	help
+	  Support the Permedia2 FIFO disconnect feature.
+
+config FB_ARMCLCD
+	tristate "ARM PrimeCell PL110 support"
+	depends on ARM || ARM64 || COMPILE_TEST
+	depends on FB && ARM_AMBA
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This framebuffer device driver is for the ARM PrimeCell PL110
+	  Colour LCD controller.  ARM PrimeCells provide the building
+	  blocks for System on a Chip devices.
+
+	  If you want to compile this as a module (=code which can be
+	  inserted into and removed from the running kernel), say M
+	  here and read <file:Documentation/kbuild/modules.txt>.  The module
+	  will be called amba-clcd.
+
+config FB_ACORN
+	bool "Acorn VIDC support"
+	depends on (FB = y) && ARM && ARCH_ACORN
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Acorn VIDC graphics
+	  hardware found in Acorn RISC PCs and other ARM-based machines.  If
+	  unsure, say N.
+
+config FB_CLPS711X
+	bool "CLPS711X LCD support"
+	depends on (FB = y) && ARM && ARCH_CLPS711X
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  Say Y to enable the Framebuffer driver for the CLPS7111 and
+	  EP7212 processors.
+
+config FB_SA1100
+	bool "SA-1100 LCD support"
+	depends on (FB = y) && ARM && ARCH_SA1100
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is a framebuffer device for the SA-1100 LCD Controller.
+	  See <http://www.linux-fbdev.org/> for information on framebuffer
+	  devices.
+
+	  If you plan to use the LCD display with your SA-1100 system, say
+	  Y here.
+
+config FB_IMX
+	tristate "Freescale i.MX1/21/25/27 LCD support"
+	depends on FB && IMX_HAVE_PLATFORM_IMX_FB
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+
+config FB_CYBER2000
+	tristate "CyberPro 2000/2010/5000 support"
+	depends on FB && PCI && (BROKEN || !SPARC64)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This enables support for the Integraphics CyberPro 20x0 and 5000
+	  VGA chips used in the Rebel.com Netwinder and other machines.
+	  Say Y if you have a NetWinder or a graphics card containing this
+	  device, otherwise say N.
+
+config FB_CYBER2000_DDC
+	bool "DDC for CyberPro support"
+	depends on FB_CYBER2000
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC support for your CyberPro graphics
+	  card. This is only I2C bus support, driver does not use EDID.
+
+config FB_CYBER2000_I2C
+	bool "CyberPro 2000/2010/5000 I2C support"
+	depends on FB_CYBER2000 && I2C && ARCH_NETWINDER
+	select I2C_ALGOBIT
+	help
+	  Enable support for the I2C video decoder interface on the
+	  Integraphics CyberPro 20x0 and 5000 VGA chips.  This is used
+	  on the Netwinder machines for the SAA7111 video capture.
+
+config FB_APOLLO
+	bool
+	depends on (FB = y) && APOLLO
+	default y
+	select FB_CFB_FILLRECT
+	select FB_CFB_IMAGEBLIT
+
+config FB_Q40
+	bool
+	depends on (FB = y) && Q40
+	default y
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+
+config FB_AMIGA
+	tristate "Amiga native chipset support"
+	depends on FB && AMIGA
+	help
+	  This is the frame buffer device driver for the builtin graphics
+	  chipset found in Amigas.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called amifb.
+
+config FB_AMIGA_OCS
+	bool "Amiga OCS chipset support"
+	depends on FB_AMIGA
+	help
+	  This enables support for the original Agnus and Denise video chips,
+	  found in the Amiga 1000 and most A500's and A2000's. If you intend
+	  to run Linux on any of these systems, say Y; otherwise say N.
+
+config FB_AMIGA_ECS
+	bool "Amiga ECS chipset support"
+	depends on FB_AMIGA
+	help
+	  This enables support for the Enhanced Chip Set, found in later
+	  A500's, later A2000's, the A600, the A3000, the A3000T and CDTV. If
+	  you intend to run Linux on any of these systems, say Y; otherwise
+	  say N.
+
+config FB_AMIGA_AGA
+	bool "Amiga AGA chipset support"
+	depends on FB_AMIGA
+	help
+	  This enables support for the Advanced Graphics Architecture (also
+	  known as the AGA or AA) Chip Set, found in the A1200, A4000, A4000T
+	  and CD32. If you intend to run Linux on any of these systems, say Y;
+	  otherwise say N.
+
+config FB_FM2
+	bool "Amiga FrameMaster II/Rainbow II support"
+	depends on (FB = y) && ZORRO
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Amiga FrameMaster
+	  card from BSC (exhibited 1992 but not shipped as a CBM product).
+
+config FB_ARC
+	tristate "Arc Monochrome LCD board support"
+	depends on FB && X86
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	help
+	  This enables support for the Arc Monochrome LCD board. The board
+	  is based on the KS-108 lcd controller and is typically a matrix
+	  of 2*n chips. This driver was tested with a 128x64 panel. This
+	  driver supports it for use with x86 SBCs through a 16 bit GPIO
+	  interface (8 bit data, 8 bit control). If you anticipate using
+	  this driver, say Y or M; otherwise say N. You must specify the
+	  GPIO IO address to be used for setting control and data.
+
+config FB_ATARI
+	bool "Atari native chipset support"
+	depends on (FB = y) && ATARI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the builtin graphics
+	  chipset found in Ataris.
+
+config FB_OF
+	bool "Open Firmware frame buffer device support"
+	depends on (FB = y) && (PPC64 || PPC_OF) && (!PPC_PSERIES || PCI)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MACMODES
+	help
+	  Say Y if you want support with Open Firmware for your graphics
+	  board.
+
+config FB_CONTROL
+	bool "Apple \"control\" display support"
+	depends on (FB = y) && PPC_PMAC && PPC32
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MACMODES
+	help
+	  This driver supports a frame buffer for the graphics adapter in the
+	  Power Macintosh 7300 and others.
+
+config FB_PLATINUM
+	bool "Apple \"platinum\" display support"
+	depends on (FB = y) && PPC_PMAC && PPC32
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MACMODES
+	help
+	  This driver supports a frame buffer for the "platinum" graphics
+	  adapter in some Power Macintoshes.
+
+config FB_VALKYRIE
+	bool "Apple \"valkyrie\" display support"
+	depends on (FB = y) && (MAC || (PPC_PMAC && PPC32))
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MACMODES
+	help
+	  This driver supports a frame buffer for the "valkyrie" graphics
+	  adapter in some Power Macintoshes.
+
+config FB_CT65550
+	bool "Chips 65550 display support"
+	depends on (FB = y) && PPC32 && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Chips & Technologies
+	  65550 graphics chip in PowerBooks.
+
+config FB_ASILIANT
+	bool "Asiliant (Chips) 69000 display support"
+	depends on (FB = y) && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Asiliant 69030 chipset
+
+config FB_IMSTT
+	bool "IMS Twin Turbo display support"
+	depends on (FB = y) && PCI
+	select FB_CFB_IMAGEBLIT
+	select FB_MACMODES if PPC
+	help
+	  The IMS Twin Turbo is a PCI-based frame buffer card bundled with
+	  many Macintosh and compatible computers.
+
+config FB_VGA16
+	tristate "VGA 16-color graphics support"
+	depends on FB && (X86 || PPC)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VGASTATE
+	select FONT_8x16 if FRAMEBUFFER_CONSOLE
+	help
+	  This is the frame buffer device driver for VGA 16 color graphic
+	  cards. Say Y if you have such a card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vga16fb.
+
+config FB_BF54X_LQ043
+	tristate "SHARP LQ043 TFT LCD (BF548 EZKIT)"
+	depends on FB && (BF54x) && !BF542
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	 This is the framebuffer device driver for a SHARP LQ043T1DG01 TFT LCD
+
+config FB_BFIN_T350MCQB
+	tristate "Varitronix COG-T350MCQB TFT LCD display (BF527 EZKIT)"
+	depends on FB && BLACKFIN
+	select BFIN_GPTIMERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	 This is the framebuffer device driver for a Varitronix VL-PS-COG-T350MCQB-01 display TFT LCD
+	 This display is a QVGA 320x240 24-bit RGB display interfaced by an 8-bit wide PPI
+	 It uses PPI[0..7] PPI_FS1, PPI_FS2 and PPI_CLK.
+
+config FB_BFIN_LQ035Q1
+	tristate "SHARP LQ035Q1DH02 TFT LCD"
+	depends on FB && BLACKFIN && SPI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select BFIN_GPTIMERS
+	help
+	  This is the framebuffer device driver for a SHARP LQ035Q1DH02 TFT display found on
+	  the Blackfin Landscape LCD EZ-Extender Card.
+	  This display is a QVGA 320x240 18-bit RGB display interfaced by an 16-bit wide PPI
+	  It uses PPI[0..15] PPI_FS1, PPI_FS2 and PPI_CLK.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin-lq035q1-fb.
+
+config FB_BF537_LQ035
+	tristate "SHARP LQ035 TFT LCD (BF537 STAMP)"
+	depends on FB && (BF534 || BF536 || BF537) && I2C_BLACKFIN_TWI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select BFIN_GPTIMERS
+	help
+	  This is the framebuffer device for a SHARP LQ035Q7DB03 TFT LCD
+	  attached to a BF537.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bf537-lq035.
+
+config FB_BFIN_7393
+	tristate "Blackfin ADV7393 Video encoder"
+	depends on FB && BLACKFIN
+	select I2C
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for a ADV7393 video encoder
+	  attached to a Blackfin on the PPI port.
+	  If your Blackfin board has a ADV7393 select Y.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_adv7393fb.
+
+choice
+	prompt  "Video mode support"
+	depends on FB_BFIN_7393
+	default NTSC
+
+config NTSC
+	bool 'NTSC 720x480'
+
+config PAL
+	bool 'PAL 720x576'
+
+config NTSC_640x480
+	bool 'NTSC 640x480 (Experimental)'
+
+config PAL_640x480
+	bool 'PAL 640x480 (Experimental)'
+
+config NTSC_YCBCR
+	bool 'NTSC 720x480 YCbCR input'
+
+config PAL_YCBCR
+	bool 'PAL 720x576 YCbCR input'
+
+endchoice
+
+choice
+	prompt  "Size of ADV7393 frame buffer memory Single/Double Size"
+	depends on (FB_BFIN_7393)
+	default ADV7393_1XMEM
+
+config ADV7393_1XMEM
+	bool 'Single'
+
+config ADV7393_2XMEM
+	bool 'Double'
+endchoice
+
+config FB_STI
+	tristate "HP STI frame buffer device support"
+	depends on FB && PARISC
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select STI_CONSOLE
+	select VT
+	default y
+	---help---
+	  STI refers to the HP "Standard Text Interface" which is a set of
+	  BIOS routines contained in a ROM chip in HP PA-RISC based machines.
+	  Enabling this option will implement the linux framebuffer device
+	  using calls to the STI BIOS routines for initialisation.
+	
+	  If you enable this option, you will get a planar framebuffer device
+	  /dev/fb which will work on the most common HP graphic cards of the
+	  NGLE family, including the artist chips (in the 7xx and Bxxx series),
+	  HCRX, HCRX24, CRX, CRX24 and VisEG series.
+
+	  It is safe to enable this option, so you should probably say "Y".
+
+config FB_MAC
+	bool "Generic Macintosh display support"
+	depends on (FB = y) && MAC
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MACMODES
+
+config FB_HP300
+	bool
+	depends on (FB = y) && DIO
+	select FB_CFB_IMAGEBLIT
+	default y
+
+config FB_TGA
+	tristate "TGA/SFB+ framebuffer support"
+	depends on FB && (ALPHA || TC)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select BITREVERSE
+	---help---
+	  This is the frame buffer device driver for generic TGA and SFB+
+	  graphic cards.  These include DEC ZLXp-E1, -E2 and -E3 PCI cards,
+	  also known as PBXGA-A, -B and -C, and DEC ZLX-E1, -E2 and -E3
+	  TURBOchannel cards, also known as PMAGD-A, -B and -C.
+
+	  Due to hardware limitations ZLX-E2 and E3 cards are not supported
+	  for DECstation 5000/200 systems.  Additionally due to firmware
+	  limitations these cards may cause troubles with booting DECstation
+	  5000/240 and /260 systems, but are fully supported under Linux if
+	  you manage to get it going. ;-)
+
+	  Say Y if you have one of those.
+
+config FB_UVESA
+	tristate "Userspace VESA VGA graphics support"
+	depends on FB && CONNECTOR
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MODE_HELPERS
+	help
+	  This is the frame buffer driver for generic VBE 2.0 compliant
+	  graphic cards. It can also take advantage of VBE 3.0 features,
+	  such as refresh rate adjustment.
+
+	  This driver generally provides more features than vesafb but
+	  requires a userspace helper application called 'v86d'. See
+	  <file:Documentation/fb/uvesafb.txt> for more information.
+
+	  If unsure, say N.
+
+config FB_VESA
+	bool "VESA VGA graphics support"
+	depends on (FB = y) && X86
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT
+	help
+	  This is the frame buffer device driver for generic VESA 2.0
+	  compliant graphic cards. The older VESA 1.2 cards are not supported.
+	  You will get a boot time penguin logo at no additional cost. Please
+	  read <file:Documentation/fb/vesafb.txt>. If unsure, say Y.
+
+config FB_EFI
+	bool "EFI-based Framebuffer Support"
+	depends on (FB = y) && X86 && EFI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the EFI frame buffer device driver. If the firmware on
+	  your platform is EFI 1.10 or UEFI 2.0, select Y to add support for
+	  using the EFI framebuffer as your console.
+
+config FB_N411
+       tristate "N411 Apollo/Hecuba devkit support"
+       depends on FB && X86 && MMU
+       select FB_SYS_FILLRECT
+       select FB_SYS_COPYAREA
+       select FB_SYS_IMAGEBLIT
+       select FB_SYS_FOPS
+       select FB_DEFERRED_IO
+       select FB_HECUBA
+       help
+         This enables support for the Apollo display controller in its
+         Hecuba form using the n411 devkit.
+
+config FB_HGA
+	tristate "Hercules mono graphics support"
+	depends on FB && X86
+	help
+	  Say Y here if you have a Hercules mono graphics card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hgafb.
+
+	  As this card technology is at least 25 years old,
+	  most people will answer N here.
+
+config FB_SGIVW
+	tristate "SGI Visual Workstation framebuffer support"
+	depends on FB && X86_VISWS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  SGI Visual Workstation support for framebuffer graphics.
+
+config FB_GBE
+	bool "SGI Graphics Backend frame buffer support"
+	depends on (FB = y) && (SGI_IP32 || X86_VISWS)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+ 	help
+	  This is the frame buffer device driver for SGI Graphics Backend.
+	  This chip is used in SGI O2 and Visual Workstation 320/540.
+
+config FB_GBE_MEM
+	int "Video memory size in MB"
+	depends on FB_GBE
+	default 4
+	help
+	  This is the amount of memory reserved for the framebuffer,
+	  which can be any value between 1MB and 8MB.
+
+config FB_SBUS
+	bool "SBUS and UPA framebuffers"
+	depends on (FB = y) && SPARC
+	help
+	  Say Y if you want support for SBUS or UPA based frame buffer device.
+
+config FB_BW2
+	bool "BWtwo support"
+	depends on (FB = y) && (SPARC && FB_SBUS)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the BWtwo frame buffer.
+
+config FB_CG3
+	bool "CGthree support"
+	depends on (FB = y) && (SPARC && FB_SBUS)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the CGthree frame buffer.
+
+config FB_CG6
+	bool "CGsix (GX,TurboGX) support"
+	depends on (FB = y) && (SPARC && FB_SBUS)
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the CGsix (GX, TurboGX)
+	  frame buffer.
+
+config FB_FFB
+	bool "Creator/Creator3D/Elite3D support"
+	depends on FB_SBUS && SPARC64
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Creator, Creator3D,
+	  and Elite3D graphics boards.
+
+config FB_TCX
+	bool "TCX (SS4/SS5 only) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the TCX 24/8bit frame
+	  buffer.
+
+config FB_CG14
+	bool "CGfourteen (SX) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the CGfourteen frame
+	  buffer on Desktop SPARCsystems with the SX graphics option.
+
+config FB_P9100
+	bool "P9100 (Sparcbook 3 only) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the P9100 card
+	  supported on Sparcbook 3 machines.
+
+config FB_LEO
+	bool "Leo (ZX) support"
+	depends on FB_SBUS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the SBUS-based Sun ZX
+	  (leo) frame buffer cards.
+
+config FB_IGA
+	bool "IGA 168x display support"
+	depends on (FB = y) && SPARC32
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for the INTERGRAPHICS 1680 and
+	  successor frame buffer cards.
+
+config FB_XVR500
+	bool "Sun XVR-500 3DLABS Wildcat support"
+	depends on (FB = y) && PCI && SPARC64
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for the Sun XVR-500 and similar
+	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
+	  only works on sparc64 systems where the system firmware has
+	  mostly initialized the card already.  It is treated as a
+	  completely dumb framebuffer device.
+
+config FB_XVR2500
+	bool "Sun XVR-2500 3DLABS Wildcat support"
+	depends on (FB = y) && PCI && SPARC64
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for the Sun XVR-2500 and similar
+	  graphics cards based upon the 3DLABS Wildcat chipset.  The driver
+	  only works on sparc64 systems where the system firmware has
+	  mostly initialized the card already.  It is treated as a
+	  completely dumb framebuffer device.
+
+config FB_XVR1000
+	bool "Sun XVR-1000 support"
+	depends on (FB = y) && SPARC64
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer device for the Sun XVR-1000 and similar
+	  graphics cards.  The driver only works on sparc64 systems where
+	  the system firmware has mostly initialized the card already.  It
+	  is treated as a completely dumb framebuffer device.
+
+config FB_PVR2
+	tristate "NEC PowerVR 2 display support"
+	depends on FB && SH_DREAMCAST
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Say Y here if you have a PowerVR 2 card in your box.  If you plan to
+	  run linux on your Dreamcast, you will have to say Y here.
+	  This driver may or may not work on other PowerVR 2 cards, but is
+	  totally untested.  Use at your own risk.  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pvr2fb.
+
+	  You can pass several parameters to the driver at boot time or at
+	  module load time.  The parameters look like "video=pvr2:XXX", where
+	  the meaning of XXX can be found at the end of the main source file
+	  (<file:drivers/video/pvr2fb.c>). Please see the file
+	  <file:Documentation/fb/pvr2fb.txt>.
+
+config FB_OPENCORES
+	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
+	depends on FB
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This enables support for the OpenCores VGA/LCD core.
+
+	  The OpenCores VGA/LCD core is typically used together with
+	  softcore CPUs (e.g. OpenRISC or Microblaze) or hard processor
+	  systems (e.g. Altera socfpga or Xilinx Zynq) on FPGAs.
+
+	  The source code and specification for the core is available at
+	  <http://opencores.org/project,vga_lcd>
+
+config FB_S1D13XXX
+	tristate "Epson S1D13XXX framebuffer support"
+	depends on FB
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  Support for S1D13XXX framebuffer device family (currently only
+	  working with S1D13806). Product specs at
+	  <http://vdc.epson.com/>
+
+config FB_ATMEL
+	tristate "AT91/AT32 LCD Controller support"
+	depends on FB && HAVE_FB_ATMEL
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	help
+	  This enables support for the AT91/AT32 LCD Controller.
+
+config FB_INTSRAM
+	bool "Frame Buffer in internal SRAM"
+	depends on FB_ATMEL && ARCH_AT91SAM9261
+	help
+	  Say Y if you want to map Frame Buffer in internal SRAM. Say N if you want
+	  to let frame buffer in external SDRAM.
+
+config FB_ATMEL_STN
+	bool "Use a STN display with AT91/AT32 LCD Controller"
+	depends on FB_ATMEL && (MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK)
+	default n
+	help
+	  Say Y if you want to connect a STN LCD display to the AT91/AT32 LCD
+	  Controller. Say N if you want to connect a TFT.
+
+	  If unsure, say N.
+
+config FB_NVIDIA
+	tristate "nVidia Framebuffer Support"
+	depends on FB && PCI
+	select FB_BACKLIGHT if FB_NVIDIA_BACKLIGHT
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select BITREVERSE
+	select VGASTATE
+	help
+	  This driver supports graphics boards with the nVidia chips, TNT
+	  and newer. For very old chipsets, such as the RIVA128, then use
+	  the rivafb.
+	  Say Y if you have such a graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nvidiafb.
+
+config FB_NVIDIA_I2C
+       bool "Enable DDC Support"
+       depends on FB_NVIDIA
+       select FB_DDC
+       help
+	  This enables I2C support for nVidia Chipsets.  This is used
+	  only for getting EDID information from the attached display
+	  allowing for robust video mode handling and switching.
+
+	  Because fbdev-2.6 requires that drivers must be able to
+	  independently validate video mode parameters, you should say Y
+	  here.
+
+config FB_NVIDIA_DEBUG
+	bool "Lots of debug output"
+	depends on FB_NVIDIA
+	default n
+	help
+	  Say Y here if you want the nVidia driver to output all sorts
+	  of debugging information to provide to the maintainer when
+	  something goes wrong.
+
+config FB_NVIDIA_BACKLIGHT
+	bool "Support for backlight control"
+	depends on FB_NVIDIA
+	default y
+	help
+	  Say Y here if you want to control the backlight of your display.
+
+config FB_RIVA
+	tristate "nVidia Riva support"
+	depends on FB && PCI
+	select FB_BACKLIGHT if FB_RIVA_BACKLIGHT
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select BITREVERSE
+	select VGASTATE
+	help
+	  This driver supports graphics boards with the nVidia Riva/Geforce
+	  chips.
+	  Say Y if you have such a graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rivafb.
+
+config FB_RIVA_I2C
+       bool "Enable DDC Support"
+       depends on FB_RIVA
+       select FB_DDC
+       help
+	  This enables I2C support for nVidia Chipsets.  This is used
+	  only for getting EDID information from the attached display
+	  allowing for robust video mode handling and switching.
+
+	  Because fbdev-2.6 requires that drivers must be able to
+	  independently validate video mode parameters, you should say Y
+	  here.
+
+config FB_RIVA_DEBUG
+	bool "Lots of debug output"
+	depends on FB_RIVA
+	default n
+	help
+	  Say Y here if you want the Riva driver to output all sorts
+	  of debugging information to provide to the maintainer when
+	  something goes wrong.
+
+config FB_RIVA_BACKLIGHT
+	bool "Support for backlight control"
+	depends on FB_RIVA
+	default y
+	help
+	  Say Y here if you want to control the backlight of your display.
+
+config FB_I740
+	tristate "Intel740 support"
+	depends on FB && PCI
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VGASTATE
+	select FB_DDC
+	help
+	  This driver supports graphics cards based on Intel740 chip.
+
+config FB_I810
+	tristate "Intel 810/815 support"
+	depends on FB && PCI && X86_32 && AGP_INTEL
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VGASTATE
+	help
+	  This driver supports the on-board graphics built in to the Intel 810 
+          and 815 chipsets.  Say Y if you have and plan to use such a board.
+
+          To compile this driver as a module, choose M here: the
+	  module will be called i810fb.
+
+          For more information, please read 
+	  <file:Documentation/fb/intel810.txt>
+
+config FB_I810_GTF
+	bool "use VESA Generalized Timing Formula"
+	depends on FB_I810
+	help
+	  If you say Y, then the VESA standard, Generalized Timing Formula 
+          or GTF, will be used to calculate the required video timing values
+	  per video mode.  Since the GTF allows nondiscrete timings 
+          (nondiscrete being a range of values as opposed to discrete being a
+          set of values), you'll be able to use any combination of horizontal 
+	  and vertical resolutions, and vertical refresh rates without having
+	  to specify your own timing parameters.  This is especially useful
+	  to maximize the performance of an aging display, or if you just 
+          have a display with nonstandard dimensions. A VESA compliant 
+	  monitor is recommended, but can still work with non-compliant ones.
+	  If you need or want this, then select this option. The timings may 
+	  not be compliant with Intel's recommended values. Use at your own 
+	  risk.
+
+          If you say N, the driver will revert to discrete video timings 
+	  using a set recommended by Intel in their documentation.
+  
+          If unsure, say N.
+
+config FB_I810_I2C
+	bool "Enable DDC Support"
+	depends on FB_I810 && FB_I810_GTF
+	select FB_DDC
+	help
+
+config FB_LE80578
+	tristate "Intel LE80578 (Vermilion) support"
+	depends on FB && PCI && X86
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This driver supports the LE80578 (Vermilion Range) chipset
+
+config FB_CARILLO_RANCH
+	tristate "Intel Carillo Ranch support"
+	depends on FB_LE80578 && FB && PCI && X86
+	help
+	  This driver supports the LE80578 (Carillo Ranch) board
+
+config FB_INTEL
+	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support"
+	depends on FB && PCI && X86 && AGP_INTEL && EXPERT
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
+	depends on !DRM_I915
+	help
+	  This driver supports the on-board graphics built in to the Intel
+          830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.
+          Say Y if you have and plan to use such a board.
+
+	  To make FB_INTELFB=Y work you need to say AGP_INTEL=y too.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called intelfb.
+
+	  For more information, please read <file:Documentation/fb/intelfb.txt>
+
+config FB_INTEL_DEBUG
+	bool "Intel driver Debug Messages"
+	depends on FB_INTEL
+	---help---
+	  Say Y here if you want the Intel driver to output all sorts
+	  of debugging information to provide to the maintainer when
+	  something goes wrong.
+
+config FB_INTEL_I2C
+	bool "DDC/I2C for Intel framebuffer support"
+	depends on FB_INTEL
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC/I2C support for your on-board Intel graphics.
+
+config FB_MATROX
+	tristate "Matrox acceleration"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_TILEBLITTING
+	select FB_MACMODES if PPC_PMAC
+	---help---
+	  Say Y here if you have a Matrox Millennium, Matrox Millennium II,
+	  Matrox Mystique, Matrox Mystique 220, Matrox Productiva G100, Matrox
+	  Mystique G200, Matrox Millennium G200, Matrox Marvel G200 video,
+	  Matrox G400, G450 or G550 card in your box.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called matroxfb.
+
+	  You can pass several parameters to the driver at boot time or at
+	  module load time. The parameters look like "video=matroxfb:XXX", and
+	  are described in <file:Documentation/fb/matroxfb.txt>.
+
+config FB_MATROX_MILLENIUM
+	bool "Millennium I/II support"
+	depends on FB_MATROX
+	help
+	  Say Y here if you have a Matrox Millennium or Matrox Millennium II
+	  video card. If you select "Advanced lowlevel driver options" below,
+	  you should check 4 bpp packed pixel, 8 bpp packed pixel, 16 bpp
+	  packed pixel, 24 bpp packed pixel and 32 bpp packed pixel. You can
+	  also use font widths different from 8.
+
+config FB_MATROX_MYSTIQUE
+	bool "Mystique support"
+	depends on FB_MATROX
+	help
+	  Say Y here if you have a Matrox Mystique or Matrox Mystique 220
+	  video card. If you select "Advanced lowlevel driver options" below,
+	  you should check 8 bpp packed pixel, 16 bpp packed pixel, 24 bpp
+	  packed pixel and 32 bpp packed pixel. You can also use font widths
+	  different from 8.
+
+config FB_MATROX_G
+	bool "G100/G200/G400/G450/G550 support"
+	depends on FB_MATROX
+	---help---
+	  Say Y here if you have a Matrox G100, G200, G400, G450 or G550 based
+	  video card. If you select "Advanced lowlevel driver options", you
+	  should check 8 bpp packed pixel, 16 bpp packed pixel, 24 bpp packed
+	  pixel and 32 bpp packed pixel. You can also use font widths
+	  different from 8.
+
+	  If you need support for G400 secondary head, you must say Y to
+	  "Matrox I2C support" and "G400 second head support" right below.
+	  G450/G550 secondary head and digital output are supported without
+	  additional modules.
+
+	  The driver starts in monitor mode. You must use the matroxset tool 
+	  (available at <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to 
+	  swap primary and secondary head outputs, or to change output mode.  
+	  Secondary head driver always start in 640x480 resolution and you 
+	  must use fbset to change it.
+
+	  Do not forget that second head supports only 16 and 32 bpp
+	  packed pixels, so it is a good idea to compile them into the kernel
+	  too. You can use only some font widths, as the driver uses generic
+	  painting procedures (the secondary head does not use acceleration
+	  engine).
+
+	  G450/G550 hardware can display TV picture only from secondary CRTC,
+	  and it performs no scaling, so picture must have 525 or 625 lines.
+
+config FB_MATROX_I2C
+	tristate "Matrox I2C support"
+	depends on FB_MATROX
+	select FB_DDC
+	---help---
+	  This drivers creates I2C buses which are needed for accessing the
+	  DDC (I2C) bus present on all Matroxes, an I2C bus which
+	  interconnects Matrox optional devices, like MGA-TVO on G200 and
+	  G400, and the secondary head DDC bus, present on G400 only.
+
+	  You can say Y or M here if you want to experiment with monitor
+	  detection code. You must say Y or M here if you want to use either
+	  second head of G400 or MGA-TVO on G200 or G400.
+
+	  If you compile it as module, it will create a module named
+	  i2c-matroxfb.
+
+config FB_MATROX_MAVEN
+	tristate "G400 second head support"
+	depends on FB_MATROX_G && FB_MATROX_I2C
+	---help---
+	  WARNING !!! This support does not work with G450 !!!
+
+	  Say Y or M here if you want to use a secondary head (meaning two
+	  monitors in parallel) on G400 or MGA-TVO add-on on G200. Secondary
+	  head is not compatible with accelerated XFree 3.3.x SVGA servers -
+	  secondary head output is blanked while you are in X. With XFree
+	  3.9.17 preview you can use both heads if you use SVGA over fbdev or
+	  the fbdev driver on first head and the fbdev driver on second head.
+
+	  If you compile it as module, two modules are created,
+	  matroxfb_crtc2 and matroxfb_maven. Matroxfb_maven is needed for
+	  both G200 and G400, matroxfb_crtc2 is needed only by G400. You must
+	  also load i2c-matroxfb to get it to run.
+
+	  The driver starts in monitor mode and you must use the matroxset
+	  tool (available at
+	  <ftp://platan.vc.cvut.cz/pub/linux/matrox-latest/>) to switch it to
+	  PAL or NTSC or to swap primary and secondary head outputs.
+	  Secondary head driver also always start in 640x480 resolution, you
+	  must use fbset to change it.
+
+	  Also do not forget that second head supports only 16 and 32 bpp
+	  packed pixels, so it is a good idea to compile them into the kernel
+	  too.  You can use only some font widths, as the driver uses generic
+	  painting procedures (the secondary head does not use acceleration
+	  engine).
+
+config FB_RADEON
+	tristate "ATI Radeon display support"
+	depends on FB && PCI
+	select FB_BACKLIGHT if FB_RADEON_BACKLIGHT
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MACMODES if PPC_OF
+	help
+	  Choose this option if you want to use an ATI Radeon graphics card as
+	  a framebuffer device.  There are both PCI and AGP versions.  You
+	  don't need to choose this to run the Radeon in plain VGA mode.
+
+	  There is a product page at
+	  http://products.amd.com/en-us/GraphicCardResult.aspx
+
+config FB_RADEON_I2C
+	bool "DDC/I2C for ATI Radeon support"
+	depends on FB_RADEON
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC/I2C support for your Radeon board. 
+
+config FB_RADEON_BACKLIGHT
+	bool "Support for backlight control"
+	depends on FB_RADEON
+	default y
+	help
+	  Say Y here if you want to control the backlight of your display.
+
+config FB_RADEON_DEBUG
+	bool "Lots of debug output from Radeon driver"
+	depends on FB_RADEON
+	default n
+	help
+	  Say Y here if you want the Radeon driver to output all sorts
+	  of debugging information to provide to the maintainer when
+	  something goes wrong.
+
+config FB_ATY128
+	tristate "ATI Rage128 display support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_BACKLIGHT if FB_ATY128_BACKLIGHT
+	select FB_MACMODES if PPC_PMAC
+	help
+	  This driver supports graphics boards with the ATI Rage128 chips.
+	  Say Y if you have such a graphics board and read
+	  <file:Documentation/fb/aty128fb.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called aty128fb.
+
+config FB_ATY128_BACKLIGHT
+	bool "Support for backlight control"
+	depends on FB_ATY128
+	default y
+	help
+	  Say Y here if you want to control the backlight of your display.
+
+config FB_ATY
+	tristate "ATI Mach64 display support" if PCI || ATARI
+	depends on FB && !SPARC32
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_BACKLIGHT if FB_ATY_BACKLIGHT
+	select FB_MACMODES if PPC
+	help
+	  This driver supports graphics boards with the ATI Mach64 chips.
+	  Say Y if you have such a graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called atyfb.
+
+config FB_ATY_CT
+	bool "Mach64 CT/VT/GT/LT (incl. 3D RAGE) support"
+	depends on PCI && FB_ATY
+	default y if SPARC64 && PCI
+	help
+	  Say Y here to support use of ATI's 64-bit Rage boards (or other
+	  boards based on the Mach64 CT, VT, GT, and LT chipsets) as a
+	  framebuffer device.  The ATI product support page for these boards
+	  is at <http://support.ati.com/products/pc/mach64/mach64.html>.
+
+config FB_ATY_GENERIC_LCD
+	bool "Mach64 generic LCD support"
+	depends on FB_ATY_CT
+	help
+	  Say Y if you have a laptop with an ATI Rage LT PRO, Rage Mobility,
+	  Rage XC, or Rage XL chipset.
+
+config FB_ATY_GX
+	bool "Mach64 GX support" if PCI
+	depends on FB_ATY
+	default y if ATARI
+	help
+	  Say Y here to support use of the ATI Mach64 Graphics Expression
+	  board (or other boards based on the Mach64 GX chipset) as a
+	  framebuffer device.  The ATI product support page for these boards
+	  is at
+	  <http://support.ati.com/products/pc/mach64/graphics_xpression.html>.
+
+config FB_ATY_BACKLIGHT
+	bool "Support for backlight control"
+	depends on FB_ATY
+	default y
+	help
+	  Say Y here if you want to control the backlight of your display.
+
+config FB_S3
+	tristate "S3 Trio/Virge support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_TILEBLITTING
+	select FB_SVGALIB
+	select VGASTATE
+	select FONT_8x16 if FRAMEBUFFER_CONSOLE
+	---help---
+	  Driver for graphics boards with S3 Trio / S3 Virge chip.
+
+config FB_S3_DDC
+	bool "DDC for S3 support"
+	depends on FB_S3
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC support for your S3 graphics card.
+
+config FB_SAVAGE
+	tristate "S3 Savage support"
+	depends on FB && PCI
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VGASTATE
+	help
+	  This driver supports notebooks and computers with S3 Savage PCI/AGP
+	  chips.
+
+	  Say Y if you have such a graphics card.
+
+	  To compile this driver as a module, choose M here; the module
+	  will be called savagefb.
+
+config FB_SAVAGE_I2C
+       bool "Enable DDC2 Support"
+       depends on FB_SAVAGE
+       select FB_DDC
+       help
+	  This enables I2C support for S3 Savage Chipsets.  This is used
+	  only for getting EDID information from the attached display
+	  allowing for robust video mode handling and switching.
+
+	  Because fbdev-2.6 requires that drivers must be able to
+	  independently validate video mode parameters, you should say Y
+	  here.
+
+config FB_SAVAGE_ACCEL
+       bool "Enable Console Acceleration"
+       depends on FB_SAVAGE
+       default n
+       help
+          This option will compile in console acceleration support. If
+          the resulting framebuffer console has bothersome glitches, then
+          choose N here.
+
+config FB_SIS
+	tristate "SiS/XGI display support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_BOOT_VESA_SUPPORT if FB_SIS = y
+	help
+	  This is the frame buffer device driver for the SiS 300, 315, 330
+	  and 340 series as well as XGI V3XT, V5, V8, Z7 graphics chipsets.
+	  Specs available at <http://www.sis.com> and <http://www.xgitech.com>.
+
+	  To compile this driver as a module, choose M here; the module
+	  will be called sisfb.
+
+config FB_SIS_300
+	bool "SiS 300 series support"
+	depends on FB_SIS
+	help
+	  Say Y here to support use of the SiS 300/305, 540, 630 and 730.
+
+config FB_SIS_315
+	bool "SiS 315/330/340 series and XGI support"
+	depends on FB_SIS
+	help
+	  Say Y here to support use of the SiS 315, 330 and 340 series
+	  (315/H/PRO, 55x, 650, 651, 740, 330, 661, 741, 760, 761) as well
+	  as XGI V3XT, V5, V8 and Z7.
+
+config FB_VIA
+       tristate "VIA UniChrome (Pro) and Chrome9 display support"
+       depends on FB && PCI && X86
+       select FB_CFB_FILLRECT
+       select FB_CFB_COPYAREA
+       select FB_CFB_IMAGEBLIT
+       select I2C_ALGOBIT
+       select I2C
+       select GPIOLIB
+       help
+	  This is the frame buffer device driver for Graphics chips of VIA
+	  UniChrome (Pro) Family (CLE266,PM800/CN400,P4M800CE/P4M800Pro/
+	  CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family (K8M890,CN896
+ 	  /P4M900,VX800)
+	  Say Y if you have a VIA UniChrome graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called viafb.
+
+if FB_VIA
+
+config FB_VIA_DIRECT_PROCFS
+	bool "direct hardware access via procfs (DEPRECATED)(DANGEROUS)"
+	depends on FB_VIA
+	default n
+	help
+	  Allow direct hardware access to some output registers via procfs.
+	  This is dangerous but may provide the only chance to get the
+	  correct output device configuration.
+	  Its use is strongly discouraged.
+
+config FB_VIA_X_COMPATIBILITY
+	bool "X server compatibility"
+	depends on FB_VIA
+	default n
+	help
+	  This option reduces the functionality (power saving, ...) of the
+	  framebuffer to avoid negative impact on the OpenChrome X server.
+	  If you use any X server other than fbdev you should enable this
+	  otherwise it should be safe to disable it and allow using all
+	  features.
+
+endif
+
+config FB_NEOMAGIC
+	tristate "NeoMagic display support"
+	depends on FB && PCI
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select VGASTATE
+	help
+	  This driver supports notebooks with NeoMagic PCI chips.
+	  Say Y if you have such a graphics card. 
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called neofb.
+
+config FB_KYRO
+	tristate "IMG Kyro support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  Say Y here if you have a STG4000 / Kyro / PowerVR 3 based
+	  graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called kyrofb.
+
+config FB_3DFX
+	tristate "3Dfx Banshee/Voodoo3/Voodoo5 display support"
+	depends on FB && PCI
+	select FB_CFB_IMAGEBLIT
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_MODE_HELPERS
+	help
+	  This driver supports graphics boards with the 3Dfx Banshee,
+	  Voodoo3 or VSA-100 (aka Voodoo4/5) chips. Say Y if you have
+	  such a graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tdfxfb.
+
+config FB_3DFX_ACCEL
+	bool "3Dfx Acceleration functions"
+	depends on FB_3DFX
+	---help---
+	This will compile the 3Dfx Banshee/Voodoo3/VSA-100 frame buffer
+	device driver with acceleration functions.
+
+config FB_3DFX_I2C
+	bool "Enable DDC/I2C support"
+	depends on FB_3DFX
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC/I2C support for your 3dfx Voodoo3.
+
+config FB_VOODOO1
+	tristate "3Dfx Voodoo Graphics (sst1) support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Say Y here if you have a 3Dfx Voodoo Graphics (Voodoo1/sst1) or 
+	  Voodoo2 (cvg) based graphics card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sstfb.
+
+	  WARNING: Do not use any application that uses the 3D engine
+	  (namely glide) while using this driver.
+	  Please read the <file:Documentation/fb/sstfb.txt> for supported
+	  options and other important info  support.
+
+config FB_VT8623
+	tristate "VIA VT8623 support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_TILEBLITTING
+	select FB_SVGALIB
+	select VGASTATE
+	select FONT_8x16 if FRAMEBUFFER_CONSOLE
+	---help---
+	  Driver for CastleRock integrated graphics core in the
+	  VIA VT8623 [Apollo CLE266] chipset.
+
+config FB_TRIDENT
+	tristate "Trident/CyberXXX/CyberBlade support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  This is the frame buffer device driver for Trident PCI/AGP chipsets.
+	  Supported chipset families are TGUI 9440/96XX, 3DImage, Blade3D
+	  and Blade XP.
+	  There are also integrated versions of these chips called CyberXXXX,
+	  CyberImage or CyberBlade. These chips are mostly found in laptops
+	  but also on some motherboards including early VIA EPIA motherboards.
+	  For more information, read <file:Documentation/fb/tridentfb.txt>
+
+	  Say Y if you have such a graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tridentfb.
+
+config FB_ARK
+	tristate "ARK 2000PV support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_TILEBLITTING
+	select FB_SVGALIB
+	select VGASTATE
+	select FONT_8x16 if FRAMEBUFFER_CONSOLE
+	---help---
+	  Driver for PCI graphics boards with ARK 2000PV chip
+	  and ICS 5342 RAMDAC.
+
+config FB_PM3
+	tristate "Permedia3 support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the 3DLabs Permedia3
+	  chipset, used in Formac ProFormance III, 3DLabs Oxygen VX1 &
+	  similar boards, 3DLabs Permedia3 Create!, Appian Jeronimo 2000
+	  and maybe other boards.
+
+config FB_CARMINE
+	tristate "Fujitsu carmine frame buffer support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Fujitsu Carmine chip.
+	  The driver provides two independent frame buffer devices.
+
+choice
+	depends on FB_CARMINE
+	prompt "DRAM timing"
+	default FB_CARMINE_DRAM_EVAL
+
+config FB_CARMINE_DRAM_EVAL
+	bool "Eval board timings"
+	help
+	  Use timings which work on the eval card.
+
+config CARMINE_DRAM_CUSTOM
+	bool "Custom board timings"
+	help
+	  Use custom board timings.
+endchoice
+
+config FB_AU1100
+	bool "Au1100 LCD Driver"
+	depends on (FB = y) && MIPS_ALCHEMY
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer driver for the AMD Au1100 SOC.  It can drive
+	  various panels and CRTs by passing in kernel cmd line option
+	  au1100fb:panel=<name>.
+
+config FB_AU1200
+	bool "Au1200/Au1300 LCD Driver"
+	depends on (FB = y) && MIPS_ALCHEMY
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	help
+	  This is the framebuffer driver for the Au1200/Au1300 SOCs.
+	  It can drive various panels and CRTs by passing in kernel cmd line
+	  option au1200fb:panel=<name>.
+
+config FB_VT8500
+	bool "VIA VT8500 framebuffer support"
+	depends on (FB = y) && ARM && ARCH_VT8500
+	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
+	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
+	select FB_SYS_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	help
+	  This is the framebuffer driver for VIA VT8500 integrated LCD
+	  controller.
+
+config FB_WM8505
+	bool "Wondermedia WM8xxx-series frame buffer support"
+	depends on (FB = y) && ARM && ARCH_VT8500
+	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
+	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
+	select FB_SYS_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	help
+	  This is the framebuffer driver for WonderMedia WM8xxx-series
+	  integrated LCD controller. This driver covers the WM8505, WM8650
+	  and WM8850 SoCs.
+
+config FB_WMT_GE_ROPS
+	bool "VT8500/WM8xxx accelerated raster ops support"
+	depends on (FB = y) && (FB_VT8500 || FB_WM8505)
+	default n
+	help
+	  This adds support for accelerated raster operations on the
+	  VIA VT8500 and Wondermedia 85xx series SoCs.
+
+source "drivers/video/fbdev/geode/Kconfig"
+
+config FB_HIT
+	tristate "HD64461 Frame Buffer support"
+	depends on FB && HD64461
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Hitachi HD64461 LCD
+	  frame buffer card.
+
+config FB_PMAG_AA
+	bool "PMAG-AA TURBOchannel framebuffer support"
+	depends on (FB = y) && TC
+ 	select FB_CFB_FILLRECT
+ 	select FB_CFB_COPYAREA
+ 	select FB_CFB_IMAGEBLIT
+	help
+	  Support for the PMAG-AA TURBOchannel framebuffer card (1280x1024x1)
+	  used mainly in the MIPS-based DECstation series.
+
+config FB_PMAG_BA
+	tristate "PMAG-BA TURBOchannel framebuffer support"
+	depends on FB && TC
+ 	select FB_CFB_FILLRECT
+ 	select FB_CFB_COPYAREA
+ 	select FB_CFB_IMAGEBLIT
+	help
+	  Support for the PMAG-BA TURBOchannel framebuffer card (1024x864x8)
+	  used mainly in the MIPS-based DECstation series.
+
+config FB_PMAGB_B
+	tristate "PMAGB-B TURBOchannel framebuffer support"
+	depends on FB && TC
+ 	select FB_CFB_FILLRECT
+ 	select FB_CFB_COPYAREA
+ 	select FB_CFB_IMAGEBLIT
+	help
+	  Support for the PMAGB-B TURBOchannel framebuffer card used mainly
+	  in the MIPS-based DECstation series. The card is currently only
+	  supported in 1280x1024x8 mode.
+
+config FB_MAXINE
+	bool "Maxine (Personal DECstation) onboard framebuffer support"
+	depends on (FB = y) && MACH_DECSTATION
+ 	select FB_CFB_FILLRECT
+ 	select FB_CFB_COPYAREA
+ 	select FB_CFB_IMAGEBLIT
+	help
+	  Support for the onboard framebuffer (1024x768x8) in the Personal
+	  DECstation series (Personal DECstation 5000/20, /25, /33, /50,
+	  Codename "Maxine").
+
+config FB_G364
+	bool "G364 frame buffer support"
+	depends on (FB = y) && (MIPS_MAGNUM_4000 || OLIVETTI_M700)
+ 	select FB_CFB_FILLRECT
+ 	select FB_CFB_COPYAREA
+ 	select FB_CFB_IMAGEBLIT
+	help
+	  The G364 driver is the framebuffer used in MIPS Magnum 4000 and
+	  Olivetti M700-10 systems.
+
+config FB_68328
+	bool "Motorola 68328 native frame buffer support"
+	depends on (FB = y) && (M68328 || M68EZ328 || M68VZ328)
+ 	select FB_CFB_FILLRECT
+ 	select FB_CFB_COPYAREA
+ 	select FB_CFB_IMAGEBLIT
+	help
+	  Say Y here if you want to support the built-in frame buffer of
+	  the Motorola 68328 CPU family.
+
+config FB_PXA168
+	tristate "PXA168/910 LCD framebuffer support"
+	depends on FB && (CPU_PXA168 || CPU_PXA910)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for the built-in LCD controller in the Marvell
+	  MMP processor.
+
+config FB_PXA
+	tristate "PXA LCD framebuffer support"
+	depends on FB && ARCH_PXA
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for the built-in LCD controller in the Intel
+	  PXA2x0 processor.
+
+	  This driver is also available as a module ( = code which can be
+	  inserted and removed from the running kernel whenever you want). The
+	  module will be called pxafb. If you want to compile it as a module,
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
+
+	  If unsure, say N.
+
+config FB_PXA_OVERLAY
+	bool "Support PXA27x/PXA3xx Overlay(s) as framebuffer"
+	default n
+	depends on FB_PXA && (PXA27x || PXA3xx)
+
+config FB_PXA_SMARTPANEL
+	bool "PXA Smartpanel LCD support"
+	default n
+	depends on FB_PXA
+
+config FB_PXA_PARAMETERS
+	bool "PXA LCD command line parameters"
+	default n
+	depends on FB_PXA
+	---help---
+	  Enable the use of kernel command line or module parameters
+	  to configure the physical properties of the LCD panel when
+	  using the PXA LCD driver.
+
+	  This option allows you to override the panel parameters
+	  supplied by the platform in order to support multiple
+	  different models of flatpanel. If you will only be using a
+	  single model of flatpanel then you can safely leave this
+	  option disabled.
+
+	  <file:Documentation/fb/pxafb.txt> describes the available parameters.
+
+config PXA3XX_GCU
+	tristate "PXA3xx 2D graphics accelerator driver"
+	depends on FB_PXA
+	help
+	  Kernelspace driver for the 2D graphics controller unit (GCU)
+	  found on PXA3xx processors. There is a counterpart driver in the
+	  DirectFB suite, see http://www.directfb.org/
+
+	  If you compile this as a module, it will be called pxa3xx_gcu.
+
+config FB_MBX
+	tristate "2700G LCD framebuffer support"
+	depends on FB && ARCH_PXA
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Framebuffer driver for the Intel 2700G (Marathon) Graphics
+	  Accelerator
+
+config FB_MBX_DEBUG
+       bool "Enable debugging info via debugfs"
+       depends on FB_MBX && DEBUG_FS
+       default n
+       ---help---
+         Enable this if you want debugging information using the debug
+         filesystem (debugfs)
+
+         If unsure, say N.
+
+config FB_FSL_DIU
+	tristate "Freescale DIU framebuffer support"
+	depends on FB && FSL_SOC
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select PPC_LIB_RHEAP
+	---help---
+	  Framebuffer driver for the Freescale SoC DIU
+
+config FB_W100
+	tristate "W100 frame buffer support"
+	depends on FB && ARCH_PXA
+ 	select FB_CFB_FILLRECT
+ 	select FB_CFB_COPYAREA
+ 	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for the w100 as found on the Sharp SL-Cxx series.
+	  It can also drive the w3220 chip found on iPAQ hx4700.
+
+	  This driver is also available as a module ( = code which can be
+	  inserted and removed from the running kernel whenever you want). The
+	  module will be called w100fb. If you want to compile it as a module,
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
+
+	  If unsure, say N.
+
+config FB_SH_MOBILE_LCDC
+	tristate "SuperH Mobile LCDC framebuffer support"
+	depends on FB && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	select FB_BACKLIGHT
+	select SH_MIPI_DSI if SH_LCD_MIPI_DSI
+	---help---
+	  Frame buffer driver for the on-chip SH-Mobile LCD controller.
+
+config FB_SH_MOBILE_HDMI
+	tristate "SuperH Mobile HDMI controller support"
+	depends on FB_SH_MOBILE_LCDC
+	select FB_MODE_HELPERS
+	select SOUND
+	select SND
+	select SND_SOC
+	---help---
+	  Driver for the on-chip SH-Mobile HDMI controller.
+
+config FB_TMIO
+	tristate "Toshiba Mobile IO FrameBuffer support"
+	depends on FB && MFD_CORE
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for the Toshiba Mobile IO integrated as found
+	  on the Sharp SL-6000 series
+
+	  This driver is also available as a module ( = code which can be
+	  inserted and removed from the running kernel whenever you want). The
+	  module will be called tmiofb. If you want to compile it as a module,
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
+
+	  If unsure, say N.
+
+config FB_TMIO_ACCELL
+	bool "tmiofb acceleration"
+	depends on FB_TMIO
+	default y
+
+config FB_S3C
+	tristate "Samsung S3C framebuffer support"
+	depends on FB && (CPU_S3C2416 || ARCH_S3C64XX || ARCH_S5P64X0 || \
+		ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for the built-in FB controller in the Samsung
+	  SoC line from the S3C2443 onwards, including the S3C2416, S3C2450,
+	  and the S3C64XX series such as the S3C6400 and S3C6410.
+
+	  These chips all have the same basic framebuffer design with the
+	  actual capabilities depending on the chip. For instance the S3C6400
+	  and S3C6410 support 4 hardware windows whereas the S3C24XX series
+	  currently only have two.
+
+	  Currently the support is only for the S3C6400 and S3C6410 SoCs.
+
+config FB_S3C_DEBUG_REGWRITE
+       bool "Debug register writes"
+       depends on FB_S3C
+       ---help---
+         Show all register writes via pr_debug()
+
+config FB_S3C2410
+	tristate "S3C2410 LCD framebuffer support"
+	depends on FB && ARCH_S3C24XX
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for the built-in LCD controller in the Samsung
+	  S3C2410 processor.
+
+	  This driver is also available as a module ( = code which can be
+	  inserted and removed from the running kernel whenever you want). The
+	  module will be called s3c2410fb. If you want to compile it as a module,
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
+
+	  If unsure, say N.
+config FB_S3C2410_DEBUG
+	bool "S3C2410 lcd debug messages"
+	depends on FB_S3C2410
+	help
+	  Turn on debugging messages. Note that you can set/unset at run time
+	  through sysfs
+
+config FB_NUC900
+        bool "NUC900 LCD framebuffer support"
+        depends on FB && ARCH_W90X900
+        select FB_CFB_FILLRECT
+        select FB_CFB_COPYAREA
+        select FB_CFB_IMAGEBLIT
+        ---help---
+          Frame buffer driver for the built-in LCD controller in the Nuvoton
+          NUC900 processor
+
+config GPM1040A0_320X240
+        bool "Giantplus Technology GPM1040A0 320x240 Color TFT LCD"
+        depends on FB_NUC900
+
+config FB_SM501
+	tristate "Silicon Motion SM501 framebuffer support"
+	depends on FB && MFD_SM501
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for the CRT and LCD controllers in the Silicon
+	  Motion SM501.
+
+	  This driver is also available as a module ( = code which can be
+	  inserted and removed from the running kernel whenever you want). The
+	  module will be called sm501fb. If you want to compile it as a module,
+	  say M here and read <file:Documentation/kbuild/modules.txt>.
+
+	  If unsure, say N.
+
+config FB_SMSCUFX
+	tristate "SMSC UFX6000/7000 USB Framebuffer support"
+	depends on FB && USB
+	select FB_MODE_HELPERS
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	---help---
+	  This is a kernel framebuffer driver for SMSC UFX USB devices.
+	  Supports fbdev clients like xf86-video-fbdev, kdrive, fbi, and
+	  mplayer -vo fbdev. Supports both UFX6000 (USB 2.0) and UFX7000
+	  (USB 3.0) devices.
+	  To compile as a module, choose M here: the module name is smscufx.
+
+config FB_UDL
+	tristate "Displaylink USB Framebuffer support"
+	depends on FB && USB
+	select FB_MODE_HELPERS
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	---help---
+	  This is a kernel framebuffer driver for DisplayLink USB devices.
+	  Supports fbdev clients like xf86-video-fbdev, kdrive, fbi, and
+	  mplayer -vo fbdev. Supports all USB 2.0 era DisplayLink devices.
+	  To compile as a module, choose M here: the module name is udlfb.
+
+config FB_IBM_GXT4500
+	tristate "Framebuffer support for IBM GXT4000P/4500P/6000P/6500P adaptors"
+	depends on FB && PPC
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Say Y here to enable support for the IBM GXT4000P/6000P and
+	  GXT4500P/6500P display adaptor based on Raster Engine RC1000,
+	  found on some IBM System P (pSeries) machines. This driver
+	  doesn't use Geometry Engine GT1000.
+
+config FB_PS3
+	tristate "PS3 GPU framebuffer driver"
+	depends on FB && PS3_PS3AV
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
+	---help---
+	  Include support for the virtual frame buffer in the PS3 platform.
+
+config FB_PS3_DEFAULT_SIZE_M
+	int "PS3 default frame buffer size (in MiB)"
+	depends on FB_PS3
+	default 9
+	---help---
+	  This is the default size (in MiB) of the virtual frame buffer in
+	  the PS3.
+	  The default value can be overridden on the kernel command line
+	  using the "ps3fb" option (e.g. "ps3fb=9M");
+
+config FB_XILINX
+	tristate "Xilinx frame buffer support"
+	depends on FB && (XILINX_VIRTEX || MICROBLAZE || ARCH_ZYNQ)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Include support for the Xilinx ML300/ML403 reference design
+	  framebuffer. ML300 carries a 640*480 LCD display on the board,
+	  ML403 uses a standard DB15 VGA connector.
+
+config FB_GOLDFISH
+	tristate "Goldfish Framebuffer"
+	depends on FB && HAS_DMA
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Framebuffer driver for Goldfish Virtual Platform
+
+config FB_COBALT
+	tristate "Cobalt server LCD frame buffer support"
+	depends on FB && (MIPS_COBALT || MIPS_SEAD3)
+
+config FB_SH7760
+	bool "SH7760/SH7763/SH7720/SH7721 LCDC support"
+	depends on FB && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763 \
+		|| CPU_SUBTYPE_SH7720 || CPU_SUBTYPE_SH7721)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Support for the SH7760/SH7763/SH7720/SH7721 integrated
+	  (D)STN/TFT LCD Controller.
+	  Supports display resolutions up to 1024x1024 pixel, grayscale and
+	  color operation, with depths ranging from 1 bpp to 8 bpp monochrome
+	  and 8, 15 or 16 bpp color; 90 degrees clockwise display rotation for
+	  panels <= 320 pixel horizontal resolution.
+
+config FB_DA8XX
+	tristate "DA8xx/OMAP-L1xx/AM335x Framebuffer support"
+	depends on FB && (ARCH_DAVINCI_DA8XX || SOC_AM33XX)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_CFB_REV_PIXELS_IN_BYTE
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	---help---
+	  This is the frame buffer device driver for the TI LCD controller
+	  found on DA8xx/OMAP-L1xx/AM335x SoCs.
+	  If unsure, say N.
+
+config FB_VIRTUAL
+	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
+	depends on FB
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	---help---
+	  This is a `virtual' frame buffer device. It operates on a chunk of
+	  unswappable kernel memory instead of on the memory of a graphics
+	  board. This means you cannot see any output sent to this frame
+	  buffer device, while it does consume precious memory. The main use
+	  of this frame buffer device is testing and debugging the frame
+	  buffer subsystem. Do NOT enable it for normal systems! To protect
+	  the innocent, it has to be enabled explicitly at boot time using the
+	  kernel option `video=vfb:'.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vfb. In order to load it, you must use
+	  the vfb_enable=1 option.
+
+	  If unsure, say N.
+
+config XEN_FBDEV_FRONTEND
+	tristate "Xen virtual frame buffer support"
+	depends on FB && XEN
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	select INPUT_XEN_KBDDEV_FRONTEND if INPUT_MISC
+	select XEN_XENBUS_FRONTEND
+	default y
+	help
+	  This driver implements the front-end of the Xen virtual
+	  frame buffer driver.  It communicates with a back-end
+	  in another domain.
+
+config FB_METRONOME
+	tristate "E-Ink Metronome/8track controller support"
+	depends on FB
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	help
+	  This driver implements support for the E-Ink Metronome
+	  controller. The pre-release name for this device was 8track
+	  and could also have been called by some vendors as PVI-nnnn.
+
+config FB_MB862XX
+	tristate "Fujitsu MB862xx GDC support"
+	depends on FB
+	depends on PCI || (OF && PPC)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Frame buffer driver for Fujitsu Carmine/Coral-P(A)/Lime controllers.
+
+choice
+	prompt "GDC variant"
+	depends on FB_MB862XX
+
+config FB_MB862XX_PCI_GDC
+	bool "Carmine/Coral-P(A) GDC"
+	depends on PCI
+	---help---
+	  This enables framebuffer support for Fujitsu Carmine/Coral-P(A)
+	  PCI graphics controller devices.
+
+config FB_MB862XX_LIME
+	bool "Lime GDC"
+	depends on OF && PPC
+	select FB_FOREIGN_ENDIAN
+	select FB_LITTLE_ENDIAN
+	---help---
+	  Framebuffer support for Fujitsu Lime GDC on host CPU bus.
+
+endchoice
+
+config FB_MB862XX_I2C
+	bool "Support I2C bus on MB862XX GDC"
+	depends on FB_MB862XX && I2C
+	default y
+	help
+	  Selecting this option adds Coral-P(A)/Lime GDC I2C bus adapter
+	  driver to support accessing I2C devices on controller's I2C bus.
+	  These are usually some video decoder chips.
+
+config FB_EP93XX
+	tristate "EP93XX frame buffer support"
+	depends on FB && ARCH_EP93XX
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Framebuffer driver for the Cirrus Logic EP93XX series of processors.
+	  This driver is also available as a module. The module will be called
+	  ep93xx-fb.
+
+config FB_PRE_INIT_FB
+	bool "Don't reinitialize, use bootloader's GDC/Display configuration"
+	depends on FB && FB_MB862XX_LIME
+	---help---
+	  Select this option if display contents should be inherited as set by
+	  the bootloader.
+
+config FB_MSM
+	tristate "MSM Framebuffer support"
+	depends on FB && ARCH_MSM
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+
+config FB_MX3
+	tristate "MX3 Framebuffer support"
+	depends on FB && MX3_IPU
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	default y
+	help
+	  This is a framebuffer device for the i.MX31 LCD Controller. So
+	  far only synchronous displays are supported. If you plan to use
+	  an LCD display with your i.MX31 system, say Y here.
+
+config FB_BROADSHEET
+	tristate "E-Ink Broadsheet/Epson S1D13521 controller support"
+	depends on FB
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	help
+	  This driver implements support for the E-Ink Broadsheet
+	  controller. The release name for this device was Epson S1D13521
+	  and could also have been called by other names when coupled with
+	  a bridge adapter.
+
+config FB_AUO_K190X
+	tristate "AUO-K190X EPD controller support"
+	depends on FB
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select FB_DEFERRED_IO
+	help
+	  Provides support for epaper controllers from the K190X series
+	  of AUO. These controllers can be used to drive epaper displays
+	  from Sipix.
+
+	  This option enables the common support, shared by the individual
+	  controller drivers. You will also have to enable the driver
+	  for the controller type used in your device.
+
+config FB_AUO_K1900
+	tristate "AUO-K1900 EPD controller support"
+	depends on FB && FB_AUO_K190X
+	help
+	  This driver implements support for the AUO K1900 epd-controller.
+	  This controller can drive Sipix epaper displays but can only do
+	  serial updates, reducing the number of possible frames per second.
+
+config FB_AUO_K1901
+	tristate "AUO-K1901 EPD controller support"
+	depends on FB && FB_AUO_K190X
+	help
+	  This driver implements support for the AUO K1901 epd-controller.
+	  This controller can drive Sipix epaper displays and supports
+	  concurrent updates, making higher frames per second possible.
+
+config FB_JZ4740
+	tristate "JZ4740 LCD framebuffer support"
+	depends on FB && MACH_JZ4740
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	help
+	  Framebuffer support for the JZ4740 SoC.
+
+config FB_MXS
+	tristate "MXS LCD framebuffer support"
+	depends on FB && ARCH_MXS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_MODE_HELPERS
+	select VIDEOMODE_HELPERS
+	help
+	  Framebuffer support for the MXS SoC.
+
+config FB_PUV3_UNIGFX
+	tristate "PKUnity v3 Unigfx framebuffer support"
+	depends on FB && UNICORE32 && ARCH_PUV3
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	help
+	  Choose this option if you want to use the Unigfx device as a
+	  framebuffer device. Without the support of PCI & AGP.
+
+config FB_HYPERV
+	tristate "Microsoft Hyper-V Synthetic Video support"
+	depends on FB && HYPERV
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This framebuffer driver supports Microsoft Hyper-V Synthetic Video.
+
+config FB_SIMPLE
+	bool "Simple framebuffer support"
+	depends on (FB = y)
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  Say Y if you want support for a simple frame-buffer.
+
+	  This driver assumes that the display hardware has been initialized
+	  before the kernel boots, and the kernel will simply render to the
+	  pre-allocated frame buffer surface.
+
+	  Configuration re: surface address, size, and format must be provided
+	  through device tree, or plain old platform data.
+
+source "drivers/video/fbdev/omap/Kconfig"
+source "drivers/video/fbdev/omap2/Kconfig"
+source "drivers/video/fbdev/exynos/Kconfig"
+source "drivers/video/fbdev/mmp/Kconfig"
+
+config FB_SH_MOBILE_MERAM
+	tristate "SuperH Mobile MERAM read ahead support"
+	depends on (SUPERH || ARCH_SHMOBILE)
+	select GENERIC_ALLOCATOR
+	---help---
+	  Enable MERAM support for the SuperH controller.
+
+	  This will allow for caching of the framebuffer to provide more
+	  reliable access under heavy main memory bus traffic situations.
+	  Up to 4 memory channels can be configured, allowing 4 RGB or
+	  2 YCbCr framebuffers to be configured.
+
+config FB_SSD1307
+	tristate "Solomon SSD1307 framebuffer support"
+	depends on FB && I2C
+	depends on OF
+	depends on GPIOLIB
+	select FB_SYS_FOPS
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_DEFERRED_IO
+	select PWM
+	help
+	  This driver implements support for the Solomon SSD1307
+	  OLED controller over I2C.
diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
new file mode 100644
index 000000000000..616e0975ae6e
--- /dev/null
+++ b/drivers/video/fbdev/Makefile
@@ -0,0 +1,167 @@
+# Makefile for the Linux video drivers.
+# 5 Aug 1999, James Simmons, <mailto:jsimmons@users.sf.net>
+# Rewritten to use lists instead of if-statements.
+
+# Each configuration option enables a list of files.
+
+obj-y                             += fb_notify.o
+obj-$(CONFIG_FB)                  += fb.o
+fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
+                                     modedb.o fbcvt.o
+fb-objs                           := $(fb-y)
+
+obj-$(CONFIG_EXYNOS_VIDEO)     += exynos/
+
+obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
+obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
+obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
+obj-$(CONFIG_FB_SYS_FILLRECT)  += sysfillrect.o
+obj-$(CONFIG_FB_SYS_COPYAREA)  += syscopyarea.o
+obj-$(CONFIG_FB_SYS_IMAGEBLIT) += sysimgblt.o
+obj-$(CONFIG_FB_SYS_FOPS)      += fb_sys_fops.o
+obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
+obj-$(CONFIG_FB_MACMODES)      += macmodes.o
+obj-$(CONFIG_FB_DDC)           += fb_ddc.o
+obj-$(CONFIG_FB_DEFERRED_IO)   += fb_defio.o
+obj-$(CONFIG_FB_WMT_GE_ROPS)   += wmt_ge_rops.o
+
+# Hardware specific drivers go first
+obj-$(CONFIG_FB_AMIGA)            += amifb.o c2p_planar.o
+obj-$(CONFIG_FB_ARC)              += arcfb.o
+obj-$(CONFIG_FB_CLPS711X)         += clps711xfb.o
+obj-$(CONFIG_FB_CYBER2000)        += cyber2000fb.o
+obj-$(CONFIG_FB_GRVGA)            += grvga.o
+obj-$(CONFIG_FB_PM2)              += pm2fb.o
+obj-$(CONFIG_FB_PM3)		  += pm3fb.o
+
+obj-$(CONFIG_FB_I740)		  += i740fb.o
+obj-$(CONFIG_FB_MATROX)		  += matrox/
+obj-$(CONFIG_FB_RIVA)		  += riva/
+obj-$(CONFIG_FB_NVIDIA)		  += nvidia/
+obj-$(CONFIG_FB_ATY)		  += aty/ macmodes.o
+obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
+obj-$(CONFIG_FB_RADEON)		  += aty/
+obj-$(CONFIG_FB_SIS)		  += sis/
+obj-$(CONFIG_FB_VIA)		  += via/
+obj-$(CONFIG_FB_KYRO)             += kyro/
+obj-$(CONFIG_FB_SAVAGE)		  += savage/
+obj-$(CONFIG_FB_GEODE)		  += geode/
+obj-$(CONFIG_FB_MBX)		  += mbx/
+obj-$(CONFIG_FB_NEOMAGIC)         += neofb.o
+obj-$(CONFIG_FB_3DFX)             += tdfxfb.o
+obj-$(CONFIG_FB_CONTROL)          += controlfb.o
+obj-$(CONFIG_FB_PLATINUM)         += platinumfb.o
+obj-$(CONFIG_FB_VALKYRIE)         += valkyriefb.o
+obj-$(CONFIG_FB_CT65550)          += chipsfb.o
+obj-$(CONFIG_FB_IMSTT)            += imsttfb.o
+obj-$(CONFIG_FB_FM2)              += fm2fb.o
+obj-$(CONFIG_FB_VT8623)           += vt8623fb.o
+obj-$(CONFIG_FB_TRIDENT)          += tridentfb.o
+obj-$(CONFIG_FB_LE80578)          += vermilion/
+obj-$(CONFIG_FB_S3)               += s3fb.o
+obj-$(CONFIG_FB_ARK)              += arkfb.o
+obj-$(CONFIG_FB_STI)              += stifb.o
+obj-$(CONFIG_FB_FFB)              += ffb.o sbuslib.o
+obj-$(CONFIG_FB_CG6)              += cg6.o sbuslib.o
+obj-$(CONFIG_FB_CG3)              += cg3.o sbuslib.o
+obj-$(CONFIG_FB_BW2)              += bw2.o sbuslib.o
+obj-$(CONFIG_FB_CG14)             += cg14.o sbuslib.o
+obj-$(CONFIG_FB_P9100)            += p9100.o sbuslib.o
+obj-$(CONFIG_FB_TCX)              += tcx.o sbuslib.o
+obj-$(CONFIG_FB_LEO)              += leo.o sbuslib.o
+obj-$(CONFIG_FB_SGIVW)            += sgivwfb.o
+obj-$(CONFIG_FB_ACORN)            += acornfb.o
+obj-$(CONFIG_FB_ATARI)            += atafb.o c2p_iplan2.o atafb_mfb.o \
+                                     atafb_iplan2p2.o atafb_iplan2p4.o atafb_iplan2p8.o
+obj-$(CONFIG_FB_MAC)              += macfb.o
+obj-$(CONFIG_FB_HECUBA)           += hecubafb.o
+obj-$(CONFIG_FB_N411)             += n411.o
+obj-$(CONFIG_FB_HGA)              += hgafb.o
+obj-$(CONFIG_FB_XVR500)           += sunxvr500.o
+obj-$(CONFIG_FB_XVR2500)          += sunxvr2500.o
+obj-$(CONFIG_FB_XVR1000)          += sunxvr1000.o
+obj-$(CONFIG_FB_IGA)              += igafb.o
+obj-$(CONFIG_FB_APOLLO)           += dnfb.o
+obj-$(CONFIG_FB_Q40)              += q40fb.o
+obj-$(CONFIG_FB_TGA)              += tgafb.o
+obj-$(CONFIG_FB_HP300)            += hpfb.o
+obj-$(CONFIG_FB_G364)             += g364fb.o
+obj-$(CONFIG_FB_EP93XX)		  += ep93xx-fb.o
+obj-$(CONFIG_FB_SA1100)           += sa1100fb.o
+obj-$(CONFIG_FB_HIT)              += hitfb.o
+obj-$(CONFIG_FB_ATMEL)		  += atmel_lcdfb.o
+obj-$(CONFIG_FB_PVR2)             += pvr2fb.o
+obj-$(CONFIG_FB_VOODOO1)          += sstfb.o
+obj-$(CONFIG_FB_ARMCLCD)	  += amba-clcd.o
+obj-$(CONFIG_FB_GOLDFISH)         += goldfishfb.o
+obj-$(CONFIG_FB_68328)            += 68328fb.o
+obj-$(CONFIG_FB_GBE)              += gbefb.o
+obj-$(CONFIG_FB_CIRRUS)		  += cirrusfb.o
+obj-$(CONFIG_FB_ASILIANT)	  += asiliantfb.o
+obj-$(CONFIG_FB_PXA)		  += pxafb.o
+obj-$(CONFIG_FB_PXA168)		  += pxa168fb.o
+obj-$(CONFIG_PXA3XX_GCU)	  += pxa3xx-gcu.o
+obj-$(CONFIG_MMP_DISP)           += mmp/
+obj-$(CONFIG_FB_W100)		  += w100fb.o
+obj-$(CONFIG_FB_TMIO)		  += tmiofb.o
+obj-$(CONFIG_FB_AU1100)		  += au1100fb.o
+obj-$(CONFIG_FB_AU1200)		  += au1200fb.o
+obj-$(CONFIG_FB_VT8500)		  += vt8500lcdfb.o
+obj-$(CONFIG_FB_WM8505)		  += wm8505fb.o
+obj-$(CONFIG_FB_PMAG_AA)	  += pmag-aa-fb.o
+obj-$(CONFIG_FB_PMAG_BA)	  += pmag-ba-fb.o
+obj-$(CONFIG_FB_PMAGB_B)	  += pmagb-b-fb.o
+obj-$(CONFIG_FB_MAXINE)		  += maxinefb.o
+obj-$(CONFIG_FB_METRONOME)        += metronomefb.o
+obj-$(CONFIG_FB_BROADSHEET)       += broadsheetfb.o
+obj-$(CONFIG_FB_AUO_K190X)	  += auo_k190x.o
+obj-$(CONFIG_FB_AUO_K1900)	  += auo_k1900fb.o
+obj-$(CONFIG_FB_AUO_K1901)	  += auo_k1901fb.o
+obj-$(CONFIG_FB_S1D13XXX)	  += s1d13xxxfb.o
+obj-$(CONFIG_FB_SH7760)		  += sh7760fb.o
+obj-$(CONFIG_FB_IMX)              += imxfb.o
+obj-$(CONFIG_FB_S3C)		  += s3c-fb.o
+obj-$(CONFIG_FB_S3C2410)	  += s3c2410fb.o
+obj-$(CONFIG_FB_FSL_DIU)	  += fsl-diu-fb.o
+obj-$(CONFIG_FB_COBALT)           += cobalt_lcdfb.o
+obj-$(CONFIG_FB_IBM_GXT4500)	  += gxt4500.o
+obj-$(CONFIG_FB_PS3)		  += ps3fb.o
+obj-$(CONFIG_FB_SM501)            += sm501fb.o
+obj-$(CONFIG_FB_UDL)		  += udlfb.o
+obj-$(CONFIG_FB_SMSCUFX)	  += smscufx.o
+obj-$(CONFIG_FB_XILINX)           += xilinxfb.o
+obj-$(CONFIG_SH_MIPI_DSI)	  += sh_mipi_dsi.o
+obj-$(CONFIG_FB_SH_MOBILE_HDMI)	  += sh_mobile_hdmi.o
+obj-$(CONFIG_FB_SH_MOBILE_MERAM)  += sh_mobile_meram.o
+obj-$(CONFIG_FB_SH_MOBILE_LCDC)	  += sh_mobile_lcdcfb.o
+obj-$(CONFIG_FB_OMAP)             += omap/
+obj-y                             += omap2/
+obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
+obj-$(CONFIG_FB_CARMINE)          += carminefb.o
+obj-$(CONFIG_FB_MB862XX)	  += mb862xx/
+obj-$(CONFIG_FB_MSM)              += msm/
+obj-$(CONFIG_FB_NUC900)           += nuc900fb.o
+obj-$(CONFIG_FB_JZ4740)		  += jz4740_fb.o
+obj-$(CONFIG_FB_PUV3_UNIGFX)      += fb-puv3.o
+obj-$(CONFIG_FB_HYPERV)		  += hyperv_fb.o
+obj-$(CONFIG_FB_OPENCORES)	  += ocfb.o
+
+# Platform or fallback drivers go here
+obj-$(CONFIG_FB_UVESA)            += uvesafb.o
+obj-$(CONFIG_FB_VESA)             += vesafb.o
+obj-$(CONFIG_FB_EFI)              += efifb.o
+obj-$(CONFIG_FB_VGA16)            += vga16fb.o
+obj-$(CONFIG_FB_OF)               += offb.o
+obj-$(CONFIG_FB_BF537_LQ035)      += bf537-lq035.o
+obj-$(CONFIG_FB_BF54X_LQ043)	  += bf54x-lq043fb.o
+obj-$(CONFIG_FB_BFIN_LQ035Q1)     += bfin-lq035q1-fb.o
+obj-$(CONFIG_FB_BFIN_T350MCQB)	  += bfin-t350mcqb-fb.o
+obj-$(CONFIG_FB_BFIN_7393)        += bfin_adv7393fb.o
+obj-$(CONFIG_FB_MX3)		  += mx3fb.o
+obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
+obj-$(CONFIG_FB_MXS)		  += mxsfb.o
+obj-$(CONFIG_FB_SSD1307)	  += ssd1307fb.o
+obj-$(CONFIG_FB_SIMPLE)           += simplefb.o
+
+# the test framebuffer is last
+obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
diff --git a/drivers/video/acornfb.c b/drivers/video/fbdev/acornfb.c
similarity index 100%
rename from drivers/video/acornfb.c
rename to drivers/video/fbdev/acornfb.c
diff --git a/drivers/video/acornfb.h b/drivers/video/fbdev/acornfb.h
similarity index 100%
rename from drivers/video/acornfb.h
rename to drivers/video/fbdev/acornfb.h
diff --git a/drivers/video/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
similarity index 100%
rename from drivers/video/amba-clcd.c
rename to drivers/video/fbdev/amba-clcd.c
diff --git a/drivers/video/amifb.c b/drivers/video/fbdev/amifb.c
similarity index 100%
rename from drivers/video/amifb.c
rename to drivers/video/fbdev/amifb.c
diff --git a/drivers/video/arcfb.c b/drivers/video/fbdev/arcfb.c
similarity index 100%
rename from drivers/video/arcfb.c
rename to drivers/video/fbdev/arcfb.c
diff --git a/drivers/video/arkfb.c b/drivers/video/fbdev/arkfb.c
similarity index 100%
rename from drivers/video/arkfb.c
rename to drivers/video/fbdev/arkfb.c
diff --git a/drivers/video/asiliantfb.c b/drivers/video/fbdev/asiliantfb.c
similarity index 100%
rename from drivers/video/asiliantfb.c
rename to drivers/video/fbdev/asiliantfb.c
diff --git a/drivers/video/atafb.c b/drivers/video/fbdev/atafb.c
similarity index 100%
rename from drivers/video/atafb.c
rename to drivers/video/fbdev/atafb.c
diff --git a/drivers/video/atafb.h b/drivers/video/fbdev/atafb.h
similarity index 100%
rename from drivers/video/atafb.h
rename to drivers/video/fbdev/atafb.h
diff --git a/drivers/video/atafb_iplan2p2.c b/drivers/video/fbdev/atafb_iplan2p2.c
similarity index 100%
rename from drivers/video/atafb_iplan2p2.c
rename to drivers/video/fbdev/atafb_iplan2p2.c
diff --git a/drivers/video/atafb_iplan2p4.c b/drivers/video/fbdev/atafb_iplan2p4.c
similarity index 100%
rename from drivers/video/atafb_iplan2p4.c
rename to drivers/video/fbdev/atafb_iplan2p4.c
diff --git a/drivers/video/atafb_iplan2p8.c b/drivers/video/fbdev/atafb_iplan2p8.c
similarity index 100%
rename from drivers/video/atafb_iplan2p8.c
rename to drivers/video/fbdev/atafb_iplan2p8.c
diff --git a/drivers/video/atafb_mfb.c b/drivers/video/fbdev/atafb_mfb.c
similarity index 100%
rename from drivers/video/atafb_mfb.c
rename to drivers/video/fbdev/atafb_mfb.c
diff --git a/drivers/video/atafb_utils.h b/drivers/video/fbdev/atafb_utils.h
similarity index 100%
rename from drivers/video/atafb_utils.h
rename to drivers/video/fbdev/atafb_utils.h
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
similarity index 100%
rename from drivers/video/atmel_lcdfb.c
rename to drivers/video/fbdev/atmel_lcdfb.c
diff --git a/drivers/video/aty/Makefile b/drivers/video/fbdev/aty/Makefile
similarity index 100%
rename from drivers/video/aty/Makefile
rename to drivers/video/fbdev/aty/Makefile
diff --git a/drivers/video/aty/ati_ids.h b/drivers/video/fbdev/aty/ati_ids.h
similarity index 100%
rename from drivers/video/aty/ati_ids.h
rename to drivers/video/fbdev/aty/ati_ids.h
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/fbdev/aty/aty128fb.c
similarity index 100%
rename from drivers/video/aty/aty128fb.c
rename to drivers/video/fbdev/aty/aty128fb.c
diff --git a/drivers/video/aty/atyfb.h b/drivers/video/fbdev/aty/atyfb.h
similarity index 100%
rename from drivers/video/aty/atyfb.h
rename to drivers/video/fbdev/aty/atyfb.h
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/fbdev/aty/atyfb_base.c
similarity index 100%
rename from drivers/video/aty/atyfb_base.c
rename to drivers/video/fbdev/aty/atyfb_base.c
diff --git a/drivers/video/aty/mach64_accel.c b/drivers/video/fbdev/aty/mach64_accel.c
similarity index 100%
rename from drivers/video/aty/mach64_accel.c
rename to drivers/video/fbdev/aty/mach64_accel.c
diff --git a/drivers/video/aty/mach64_ct.c b/drivers/video/fbdev/aty/mach64_ct.c
similarity index 100%
rename from drivers/video/aty/mach64_ct.c
rename to drivers/video/fbdev/aty/mach64_ct.c
diff --git a/drivers/video/aty/mach64_cursor.c b/drivers/video/fbdev/aty/mach64_cursor.c
similarity index 100%
rename from drivers/video/aty/mach64_cursor.c
rename to drivers/video/fbdev/aty/mach64_cursor.c
diff --git a/drivers/video/aty/mach64_gx.c b/drivers/video/fbdev/aty/mach64_gx.c
similarity index 100%
rename from drivers/video/aty/mach64_gx.c
rename to drivers/video/fbdev/aty/mach64_gx.c
diff --git a/drivers/video/aty/radeon_accel.c b/drivers/video/fbdev/aty/radeon_accel.c
similarity index 100%
rename from drivers/video/aty/radeon_accel.c
rename to drivers/video/fbdev/aty/radeon_accel.c
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/fbdev/aty/radeon_backlight.c
similarity index 100%
rename from drivers/video/aty/radeon_backlight.c
rename to drivers/video/fbdev/aty/radeon_backlight.c
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/fbdev/aty/radeon_base.c
similarity index 100%
rename from drivers/video/aty/radeon_base.c
rename to drivers/video/fbdev/aty/radeon_base.c
diff --git a/drivers/video/aty/radeon_i2c.c b/drivers/video/fbdev/aty/radeon_i2c.c
similarity index 100%
rename from drivers/video/aty/radeon_i2c.c
rename to drivers/video/fbdev/aty/radeon_i2c.c
diff --git a/drivers/video/aty/radeon_monitor.c b/drivers/video/fbdev/aty/radeon_monitor.c
similarity index 100%
rename from drivers/video/aty/radeon_monitor.c
rename to drivers/video/fbdev/aty/radeon_monitor.c
diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/fbdev/aty/radeon_pm.c
similarity index 100%
rename from drivers/video/aty/radeon_pm.c
rename to drivers/video/fbdev/aty/radeon_pm.c
diff --git a/drivers/video/aty/radeonfb.h b/drivers/video/fbdev/aty/radeonfb.h
similarity index 100%
rename from drivers/video/aty/radeonfb.h
rename to drivers/video/fbdev/aty/radeonfb.h
diff --git a/drivers/video/au1100fb.c b/drivers/video/fbdev/au1100fb.c
similarity index 100%
rename from drivers/video/au1100fb.c
rename to drivers/video/fbdev/au1100fb.c
diff --git a/drivers/video/au1100fb.h b/drivers/video/fbdev/au1100fb.h
similarity index 100%
rename from drivers/video/au1100fb.h
rename to drivers/video/fbdev/au1100fb.h
diff --git a/drivers/video/au1200fb.c b/drivers/video/fbdev/au1200fb.c
similarity index 100%
rename from drivers/video/au1200fb.c
rename to drivers/video/fbdev/au1200fb.c
diff --git a/drivers/video/au1200fb.h b/drivers/video/fbdev/au1200fb.h
similarity index 100%
rename from drivers/video/au1200fb.h
rename to drivers/video/fbdev/au1200fb.h
diff --git a/drivers/video/auo_k1900fb.c b/drivers/video/fbdev/auo_k1900fb.c
similarity index 100%
rename from drivers/video/auo_k1900fb.c
rename to drivers/video/fbdev/auo_k1900fb.c
diff --git a/drivers/video/auo_k1901fb.c b/drivers/video/fbdev/auo_k1901fb.c
similarity index 100%
rename from drivers/video/auo_k1901fb.c
rename to drivers/video/fbdev/auo_k1901fb.c
diff --git a/drivers/video/auo_k190x.c b/drivers/video/fbdev/auo_k190x.c
similarity index 100%
rename from drivers/video/auo_k190x.c
rename to drivers/video/fbdev/auo_k190x.c
diff --git a/drivers/video/auo_k190x.h b/drivers/video/fbdev/auo_k190x.h
similarity index 100%
rename from drivers/video/auo_k190x.h
rename to drivers/video/fbdev/auo_k190x.h
diff --git a/drivers/video/bf537-lq035.c b/drivers/video/fbdev/bf537-lq035.c
similarity index 100%
rename from drivers/video/bf537-lq035.c
rename to drivers/video/fbdev/bf537-lq035.c
diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/fbdev/bf54x-lq043fb.c
similarity index 100%
rename from drivers/video/bf54x-lq043fb.c
rename to drivers/video/fbdev/bf54x-lq043fb.c
diff --git a/drivers/video/bfin-lq035q1-fb.c b/drivers/video/fbdev/bfin-lq035q1-fb.c
similarity index 100%
rename from drivers/video/bfin-lq035q1-fb.c
rename to drivers/video/fbdev/bfin-lq035q1-fb.c
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/fbdev/bfin-t350mcqb-fb.c
similarity index 100%
rename from drivers/video/bfin-t350mcqb-fb.c
rename to drivers/video/fbdev/bfin-t350mcqb-fb.c
diff --git a/drivers/video/bfin_adv7393fb.c b/drivers/video/fbdev/bfin_adv7393fb.c
similarity index 100%
rename from drivers/video/bfin_adv7393fb.c
rename to drivers/video/fbdev/bfin_adv7393fb.c
diff --git a/drivers/video/bfin_adv7393fb.h b/drivers/video/fbdev/bfin_adv7393fb.h
similarity index 100%
rename from drivers/video/bfin_adv7393fb.h
rename to drivers/video/fbdev/bfin_adv7393fb.h
diff --git a/drivers/video/broadsheetfb.c b/drivers/video/fbdev/broadsheetfb.c
similarity index 100%
rename from drivers/video/broadsheetfb.c
rename to drivers/video/fbdev/broadsheetfb.c
diff --git a/drivers/video/bt431.h b/drivers/video/fbdev/bt431.h
similarity index 100%
rename from drivers/video/bt431.h
rename to drivers/video/fbdev/bt431.h
diff --git a/drivers/video/bt455.h b/drivers/video/fbdev/bt455.h
similarity index 100%
rename from drivers/video/bt455.h
rename to drivers/video/fbdev/bt455.h
diff --git a/drivers/video/bw2.c b/drivers/video/fbdev/bw2.c
similarity index 100%
rename from drivers/video/bw2.c
rename to drivers/video/fbdev/bw2.c
diff --git a/drivers/video/c2p.h b/drivers/video/fbdev/c2p.h
similarity index 100%
rename from drivers/video/c2p.h
rename to drivers/video/fbdev/c2p.h
diff --git a/drivers/video/c2p_core.h b/drivers/video/fbdev/c2p_core.h
similarity index 100%
rename from drivers/video/c2p_core.h
rename to drivers/video/fbdev/c2p_core.h
diff --git a/drivers/video/c2p_iplan2.c b/drivers/video/fbdev/c2p_iplan2.c
similarity index 100%
rename from drivers/video/c2p_iplan2.c
rename to drivers/video/fbdev/c2p_iplan2.c
diff --git a/drivers/video/c2p_planar.c b/drivers/video/fbdev/c2p_planar.c
similarity index 100%
rename from drivers/video/c2p_planar.c
rename to drivers/video/fbdev/c2p_planar.c
diff --git a/drivers/video/carminefb.c b/drivers/video/fbdev/carminefb.c
similarity index 100%
rename from drivers/video/carminefb.c
rename to drivers/video/fbdev/carminefb.c
diff --git a/drivers/video/carminefb.h b/drivers/video/fbdev/carminefb.h
similarity index 100%
rename from drivers/video/carminefb.h
rename to drivers/video/fbdev/carminefb.h
diff --git a/drivers/video/carminefb_regs.h b/drivers/video/fbdev/carminefb_regs.h
similarity index 100%
rename from drivers/video/carminefb_regs.h
rename to drivers/video/fbdev/carminefb_regs.h
diff --git a/drivers/video/cfbcopyarea.c b/drivers/video/fbdev/cfbcopyarea.c
similarity index 100%
rename from drivers/video/cfbcopyarea.c
rename to drivers/video/fbdev/cfbcopyarea.c
diff --git a/drivers/video/cfbfillrect.c b/drivers/video/fbdev/cfbfillrect.c
similarity index 100%
rename from drivers/video/cfbfillrect.c
rename to drivers/video/fbdev/cfbfillrect.c
diff --git a/drivers/video/cfbimgblt.c b/drivers/video/fbdev/cfbimgblt.c
similarity index 100%
rename from drivers/video/cfbimgblt.c
rename to drivers/video/fbdev/cfbimgblt.c
diff --git a/drivers/video/cg14.c b/drivers/video/fbdev/cg14.c
similarity index 100%
rename from drivers/video/cg14.c
rename to drivers/video/fbdev/cg14.c
diff --git a/drivers/video/cg3.c b/drivers/video/fbdev/cg3.c
similarity index 100%
rename from drivers/video/cg3.c
rename to drivers/video/fbdev/cg3.c
diff --git a/drivers/video/cg6.c b/drivers/video/fbdev/cg6.c
similarity index 100%
rename from drivers/video/cg6.c
rename to drivers/video/fbdev/cg6.c
diff --git a/drivers/video/chipsfb.c b/drivers/video/fbdev/chipsfb.c
similarity index 100%
rename from drivers/video/chipsfb.c
rename to drivers/video/fbdev/chipsfb.c
diff --git a/drivers/video/cirrusfb.c b/drivers/video/fbdev/cirrusfb.c
similarity index 100%
rename from drivers/video/cirrusfb.c
rename to drivers/video/fbdev/cirrusfb.c
diff --git a/drivers/video/clps711xfb.c b/drivers/video/fbdev/clps711xfb.c
similarity index 100%
rename from drivers/video/clps711xfb.c
rename to drivers/video/fbdev/clps711xfb.c
diff --git a/drivers/video/cobalt_lcdfb.c b/drivers/video/fbdev/cobalt_lcdfb.c
similarity index 100%
rename from drivers/video/cobalt_lcdfb.c
rename to drivers/video/fbdev/cobalt_lcdfb.c
diff --git a/drivers/video/controlfb.c b/drivers/video/fbdev/controlfb.c
similarity index 100%
rename from drivers/video/controlfb.c
rename to drivers/video/fbdev/controlfb.c
diff --git a/drivers/video/controlfb.h b/drivers/video/fbdev/controlfb.h
similarity index 100%
rename from drivers/video/controlfb.h
rename to drivers/video/fbdev/controlfb.h
diff --git a/drivers/video/cyber2000fb.c b/drivers/video/fbdev/cyber2000fb.c
similarity index 100%
rename from drivers/video/cyber2000fb.c
rename to drivers/video/fbdev/cyber2000fb.c
diff --git a/drivers/video/cyber2000fb.h b/drivers/video/fbdev/cyber2000fb.h
similarity index 100%
rename from drivers/video/cyber2000fb.h
rename to drivers/video/fbdev/cyber2000fb.h
diff --git a/drivers/video/da8xx-fb.c b/drivers/video/fbdev/da8xx-fb.c
similarity index 100%
rename from drivers/video/da8xx-fb.c
rename to drivers/video/fbdev/da8xx-fb.c
diff --git a/drivers/video/dnfb.c b/drivers/video/fbdev/dnfb.c
similarity index 100%
rename from drivers/video/dnfb.c
rename to drivers/video/fbdev/dnfb.c
diff --git a/drivers/video/edid.h b/drivers/video/fbdev/edid.h
similarity index 100%
rename from drivers/video/edid.h
rename to drivers/video/fbdev/edid.h
diff --git a/drivers/video/efifb.c b/drivers/video/fbdev/efifb.c
similarity index 100%
rename from drivers/video/efifb.c
rename to drivers/video/fbdev/efifb.c
diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/fbdev/ep93xx-fb.c
similarity index 100%
rename from drivers/video/ep93xx-fb.c
rename to drivers/video/fbdev/ep93xx-fb.c
diff --git a/drivers/video/exynos/Kconfig b/drivers/video/fbdev/exynos/Kconfig
similarity index 100%
rename from drivers/video/exynos/Kconfig
rename to drivers/video/fbdev/exynos/Kconfig
diff --git a/drivers/video/exynos/Makefile b/drivers/video/fbdev/exynos/Makefile
similarity index 100%
rename from drivers/video/exynos/Makefile
rename to drivers/video/fbdev/exynos/Makefile
diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/fbdev/exynos/exynos_dp_core.c
similarity index 100%
rename from drivers/video/exynos/exynos_dp_core.c
rename to drivers/video/fbdev/exynos/exynos_dp_core.c
diff --git a/drivers/video/exynos/exynos_dp_core.h b/drivers/video/fbdev/exynos/exynos_dp_core.h
similarity index 100%
rename from drivers/video/exynos/exynos_dp_core.h
rename to drivers/video/fbdev/exynos/exynos_dp_core.h
diff --git a/drivers/video/exynos/exynos_dp_reg.c b/drivers/video/fbdev/exynos/exynos_dp_reg.c
similarity index 100%
rename from drivers/video/exynos/exynos_dp_reg.c
rename to drivers/video/fbdev/exynos/exynos_dp_reg.c
diff --git a/drivers/video/exynos/exynos_dp_reg.h b/drivers/video/fbdev/exynos/exynos_dp_reg.h
similarity index 100%
rename from drivers/video/exynos/exynos_dp_reg.h
rename to drivers/video/fbdev/exynos/exynos_dp_reg.h
diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/fbdev/exynos/exynos_mipi_dsi.c
similarity index 100%
rename from drivers/video/exynos/exynos_mipi_dsi.c
rename to drivers/video/fbdev/exynos/exynos_mipi_dsi.c
diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c b/drivers/video/fbdev/exynos/exynos_mipi_dsi_common.c
similarity index 100%
rename from drivers/video/exynos/exynos_mipi_dsi_common.c
rename to drivers/video/fbdev/exynos/exynos_mipi_dsi_common.c
diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.h b/drivers/video/fbdev/exynos/exynos_mipi_dsi_common.h
similarity index 100%
rename from drivers/video/exynos/exynos_mipi_dsi_common.h
rename to drivers/video/fbdev/exynos/exynos_mipi_dsi_common.h
diff --git a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.c b/drivers/video/fbdev/exynos/exynos_mipi_dsi_lowlevel.c
similarity index 100%
rename from drivers/video/exynos/exynos_mipi_dsi_lowlevel.c
rename to drivers/video/fbdev/exynos/exynos_mipi_dsi_lowlevel.c
diff --git a/drivers/video/exynos/exynos_mipi_dsi_lowlevel.h b/drivers/video/fbdev/exynos/exynos_mipi_dsi_lowlevel.h
similarity index 100%
rename from drivers/video/exynos/exynos_mipi_dsi_lowlevel.h
rename to drivers/video/fbdev/exynos/exynos_mipi_dsi_lowlevel.h
diff --git a/drivers/video/exynos/exynos_mipi_dsi_regs.h b/drivers/video/fbdev/exynos/exynos_mipi_dsi_regs.h
similarity index 100%
rename from drivers/video/exynos/exynos_mipi_dsi_regs.h
rename to drivers/video/fbdev/exynos/exynos_mipi_dsi_regs.h
diff --git a/drivers/video/exynos/s6e8ax0.c b/drivers/video/fbdev/exynos/s6e8ax0.c
similarity index 100%
rename from drivers/video/exynos/s6e8ax0.c
rename to drivers/video/fbdev/exynos/s6e8ax0.c
diff --git a/drivers/video/fb-puv3.c b/drivers/video/fbdev/fb-puv3.c
similarity index 100%
rename from drivers/video/fb-puv3.c
rename to drivers/video/fbdev/fb-puv3.c
diff --git a/drivers/video/fb_ddc.c b/drivers/video/fbdev/fb_ddc.c
similarity index 100%
rename from drivers/video/fb_ddc.c
rename to drivers/video/fbdev/fb_ddc.c
diff --git a/drivers/video/fb_defio.c b/drivers/video/fbdev/fb_defio.c
similarity index 100%
rename from drivers/video/fb_defio.c
rename to drivers/video/fbdev/fb_defio.c
diff --git a/drivers/video/fb_draw.h b/drivers/video/fbdev/fb_draw.h
similarity index 100%
rename from drivers/video/fb_draw.h
rename to drivers/video/fbdev/fb_draw.h
diff --git a/drivers/video/fb_notify.c b/drivers/video/fbdev/fb_notify.c
similarity index 100%
rename from drivers/video/fb_notify.c
rename to drivers/video/fbdev/fb_notify.c
diff --git a/drivers/video/fb_sys_fops.c b/drivers/video/fbdev/fb_sys_fops.c
similarity index 100%
rename from drivers/video/fb_sys_fops.c
rename to drivers/video/fbdev/fb_sys_fops.c
diff --git a/drivers/video/fbcmap.c b/drivers/video/fbdev/fbcmap.c
similarity index 100%
rename from drivers/video/fbcmap.c
rename to drivers/video/fbdev/fbcmap.c
diff --git a/drivers/video/fbcvt.c b/drivers/video/fbdev/fbcvt.c
similarity index 100%
rename from drivers/video/fbcvt.c
rename to drivers/video/fbdev/fbcvt.c
diff --git a/drivers/video/fbmem.c b/drivers/video/fbdev/fbmem.c
similarity index 100%
rename from drivers/video/fbmem.c
rename to drivers/video/fbdev/fbmem.c
diff --git a/drivers/video/fbmon.c b/drivers/video/fbdev/fbmon.c
similarity index 100%
rename from drivers/video/fbmon.c
rename to drivers/video/fbdev/fbmon.c
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbdev/fbsysfs.c
similarity index 100%
rename from drivers/video/fbsysfs.c
rename to drivers/video/fbdev/fbsysfs.c
diff --git a/drivers/video/ffb.c b/drivers/video/fbdev/ffb.c
similarity index 100%
rename from drivers/video/ffb.c
rename to drivers/video/fbdev/ffb.c
diff --git a/drivers/video/fm2fb.c b/drivers/video/fbdev/fm2fb.c
similarity index 100%
rename from drivers/video/fm2fb.c
rename to drivers/video/fbdev/fm2fb.c
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fbdev/fsl-diu-fb.c
similarity index 100%
rename from drivers/video/fsl-diu-fb.c
rename to drivers/video/fbdev/fsl-diu-fb.c
diff --git a/drivers/video/g364fb.c b/drivers/video/fbdev/g364fb.c
similarity index 100%
rename from drivers/video/g364fb.c
rename to drivers/video/fbdev/g364fb.c
diff --git a/drivers/video/gbefb.c b/drivers/video/fbdev/gbefb.c
similarity index 100%
rename from drivers/video/gbefb.c
rename to drivers/video/fbdev/gbefb.c
diff --git a/drivers/video/geode/Kconfig b/drivers/video/fbdev/geode/Kconfig
similarity index 100%
rename from drivers/video/geode/Kconfig
rename to drivers/video/fbdev/geode/Kconfig
diff --git a/drivers/video/geode/Makefile b/drivers/video/fbdev/geode/Makefile
similarity index 100%
rename from drivers/video/geode/Makefile
rename to drivers/video/fbdev/geode/Makefile
diff --git a/drivers/video/geode/display_gx.c b/drivers/video/fbdev/geode/display_gx.c
similarity index 100%
rename from drivers/video/geode/display_gx.c
rename to drivers/video/fbdev/geode/display_gx.c
diff --git a/drivers/video/geode/display_gx1.c b/drivers/video/fbdev/geode/display_gx1.c
similarity index 100%
rename from drivers/video/geode/display_gx1.c
rename to drivers/video/fbdev/geode/display_gx1.c
diff --git a/drivers/video/geode/display_gx1.h b/drivers/video/fbdev/geode/display_gx1.h
similarity index 100%
rename from drivers/video/geode/display_gx1.h
rename to drivers/video/fbdev/geode/display_gx1.h
diff --git a/drivers/video/geode/geodefb.h b/drivers/video/fbdev/geode/geodefb.h
similarity index 100%
rename from drivers/video/geode/geodefb.h
rename to drivers/video/fbdev/geode/geodefb.h
diff --git a/drivers/video/geode/gx1fb_core.c b/drivers/video/fbdev/geode/gx1fb_core.c
similarity index 100%
rename from drivers/video/geode/gx1fb_core.c
rename to drivers/video/fbdev/geode/gx1fb_core.c
diff --git a/drivers/video/geode/gxfb.h b/drivers/video/fbdev/geode/gxfb.h
similarity index 100%
rename from drivers/video/geode/gxfb.h
rename to drivers/video/fbdev/geode/gxfb.h
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/fbdev/geode/gxfb_core.c
similarity index 100%
rename from drivers/video/geode/gxfb_core.c
rename to drivers/video/fbdev/geode/gxfb_core.c
diff --git a/drivers/video/geode/lxfb.h b/drivers/video/fbdev/geode/lxfb.h
similarity index 100%
rename from drivers/video/geode/lxfb.h
rename to drivers/video/fbdev/geode/lxfb.h
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
similarity index 100%
rename from drivers/video/geode/lxfb_core.c
rename to drivers/video/fbdev/geode/lxfb_core.c
diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/fbdev/geode/lxfb_ops.c
similarity index 100%
rename from drivers/video/geode/lxfb_ops.c
rename to drivers/video/fbdev/geode/lxfb_ops.c
diff --git a/drivers/video/geode/suspend_gx.c b/drivers/video/fbdev/geode/suspend_gx.c
similarity index 100%
rename from drivers/video/geode/suspend_gx.c
rename to drivers/video/fbdev/geode/suspend_gx.c
diff --git a/drivers/video/geode/video_cs5530.c b/drivers/video/fbdev/geode/video_cs5530.c
similarity index 100%
rename from drivers/video/geode/video_cs5530.c
rename to drivers/video/fbdev/geode/video_cs5530.c
diff --git a/drivers/video/geode/video_cs5530.h b/drivers/video/fbdev/geode/video_cs5530.h
similarity index 100%
rename from drivers/video/geode/video_cs5530.h
rename to drivers/video/fbdev/geode/video_cs5530.h
diff --git a/drivers/video/geode/video_gx.c b/drivers/video/fbdev/geode/video_gx.c
similarity index 100%
rename from drivers/video/geode/video_gx.c
rename to drivers/video/fbdev/geode/video_gx.c
diff --git a/drivers/video/goldfishfb.c b/drivers/video/fbdev/goldfishfb.c
similarity index 100%
rename from drivers/video/goldfishfb.c
rename to drivers/video/fbdev/goldfishfb.c
diff --git a/drivers/video/grvga.c b/drivers/video/fbdev/grvga.c
similarity index 100%
rename from drivers/video/grvga.c
rename to drivers/video/fbdev/grvga.c
diff --git a/drivers/video/gxt4500.c b/drivers/video/fbdev/gxt4500.c
similarity index 100%
rename from drivers/video/gxt4500.c
rename to drivers/video/fbdev/gxt4500.c
diff --git a/drivers/video/hecubafb.c b/drivers/video/fbdev/hecubafb.c
similarity index 100%
rename from drivers/video/hecubafb.c
rename to drivers/video/fbdev/hecubafb.c
diff --git a/drivers/video/hgafb.c b/drivers/video/fbdev/hgafb.c
similarity index 100%
rename from drivers/video/hgafb.c
rename to drivers/video/fbdev/hgafb.c
diff --git a/drivers/video/hitfb.c b/drivers/video/fbdev/hitfb.c
similarity index 100%
rename from drivers/video/hitfb.c
rename to drivers/video/fbdev/hitfb.c
diff --git a/drivers/video/hpfb.c b/drivers/video/fbdev/hpfb.c
similarity index 100%
rename from drivers/video/hpfb.c
rename to drivers/video/fbdev/hpfb.c
diff --git a/drivers/video/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
similarity index 100%
rename from drivers/video/hyperv_fb.c
rename to drivers/video/fbdev/hyperv_fb.c
diff --git a/drivers/video/i740_reg.h b/drivers/video/fbdev/i740_reg.h
similarity index 100%
rename from drivers/video/i740_reg.h
rename to drivers/video/fbdev/i740_reg.h
diff --git a/drivers/video/i740fb.c b/drivers/video/fbdev/i740fb.c
similarity index 100%
rename from drivers/video/i740fb.c
rename to drivers/video/fbdev/i740fb.c
diff --git a/drivers/video/i810/Makefile b/drivers/video/fbdev/i810/Makefile
similarity index 100%
rename from drivers/video/i810/Makefile
rename to drivers/video/fbdev/i810/Makefile
diff --git a/drivers/video/i810/i810-i2c.c b/drivers/video/fbdev/i810/i810-i2c.c
similarity index 100%
rename from drivers/video/i810/i810-i2c.c
rename to drivers/video/fbdev/i810/i810-i2c.c
diff --git a/drivers/video/i810/i810.h b/drivers/video/fbdev/i810/i810.h
similarity index 100%
rename from drivers/video/i810/i810.h
rename to drivers/video/fbdev/i810/i810.h
diff --git a/drivers/video/i810/i810_accel.c b/drivers/video/fbdev/i810/i810_accel.c
similarity index 100%
rename from drivers/video/i810/i810_accel.c
rename to drivers/video/fbdev/i810/i810_accel.c
diff --git a/drivers/video/i810/i810_dvt.c b/drivers/video/fbdev/i810/i810_dvt.c
similarity index 100%
rename from drivers/video/i810/i810_dvt.c
rename to drivers/video/fbdev/i810/i810_dvt.c
diff --git a/drivers/video/i810/i810_gtf.c b/drivers/video/fbdev/i810/i810_gtf.c
similarity index 100%
rename from drivers/video/i810/i810_gtf.c
rename to drivers/video/fbdev/i810/i810_gtf.c
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/fbdev/i810/i810_main.c
similarity index 100%
rename from drivers/video/i810/i810_main.c
rename to drivers/video/fbdev/i810/i810_main.c
diff --git a/drivers/video/i810/i810_main.h b/drivers/video/fbdev/i810/i810_main.h
similarity index 100%
rename from drivers/video/i810/i810_main.h
rename to drivers/video/fbdev/i810/i810_main.h
diff --git a/drivers/video/i810/i810_regs.h b/drivers/video/fbdev/i810/i810_regs.h
similarity index 100%
rename from drivers/video/i810/i810_regs.h
rename to drivers/video/fbdev/i810/i810_regs.h
diff --git a/drivers/video/igafb.c b/drivers/video/fbdev/igafb.c
similarity index 100%
rename from drivers/video/igafb.c
rename to drivers/video/fbdev/igafb.c
diff --git a/drivers/video/imsttfb.c b/drivers/video/fbdev/imsttfb.c
similarity index 100%
rename from drivers/video/imsttfb.c
rename to drivers/video/fbdev/imsttfb.c
diff --git a/drivers/video/imxfb.c b/drivers/video/fbdev/imxfb.c
similarity index 100%
rename from drivers/video/imxfb.c
rename to drivers/video/fbdev/imxfb.c
diff --git a/drivers/video/intelfb/Makefile b/drivers/video/fbdev/intelfb/Makefile
similarity index 100%
rename from drivers/video/intelfb/Makefile
rename to drivers/video/fbdev/intelfb/Makefile
diff --git a/drivers/video/intelfb/intelfb.h b/drivers/video/fbdev/intelfb/intelfb.h
similarity index 100%
rename from drivers/video/intelfb/intelfb.h
rename to drivers/video/fbdev/intelfb/intelfb.h
diff --git a/drivers/video/intelfb/intelfb_i2c.c b/drivers/video/fbdev/intelfb/intelfb_i2c.c
similarity index 100%
rename from drivers/video/intelfb/intelfb_i2c.c
rename to drivers/video/fbdev/intelfb/intelfb_i2c.c
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
similarity index 100%
rename from drivers/video/intelfb/intelfbdrv.c
rename to drivers/video/fbdev/intelfb/intelfbdrv.c
diff --git a/drivers/video/intelfb/intelfbhw.c b/drivers/video/fbdev/intelfb/intelfbhw.c
similarity index 100%
rename from drivers/video/intelfb/intelfbhw.c
rename to drivers/video/fbdev/intelfb/intelfbhw.c
diff --git a/drivers/video/intelfb/intelfbhw.h b/drivers/video/fbdev/intelfb/intelfbhw.h
similarity index 100%
rename from drivers/video/intelfb/intelfbhw.h
rename to drivers/video/fbdev/intelfb/intelfbhw.h
diff --git a/drivers/video/jz4740_fb.c b/drivers/video/fbdev/jz4740_fb.c
similarity index 100%
rename from drivers/video/jz4740_fb.c
rename to drivers/video/fbdev/jz4740_fb.c
diff --git a/drivers/video/kyro/Makefile b/drivers/video/fbdev/kyro/Makefile
similarity index 100%
rename from drivers/video/kyro/Makefile
rename to drivers/video/fbdev/kyro/Makefile
diff --git a/drivers/video/kyro/STG4000InitDevice.c b/drivers/video/fbdev/kyro/STG4000InitDevice.c
similarity index 100%
rename from drivers/video/kyro/STG4000InitDevice.c
rename to drivers/video/fbdev/kyro/STG4000InitDevice.c
diff --git a/drivers/video/kyro/STG4000Interface.h b/drivers/video/fbdev/kyro/STG4000Interface.h
similarity index 100%
rename from drivers/video/kyro/STG4000Interface.h
rename to drivers/video/fbdev/kyro/STG4000Interface.h
diff --git a/drivers/video/kyro/STG4000OverlayDevice.c b/drivers/video/fbdev/kyro/STG4000OverlayDevice.c
similarity index 100%
rename from drivers/video/kyro/STG4000OverlayDevice.c
rename to drivers/video/fbdev/kyro/STG4000OverlayDevice.c
diff --git a/drivers/video/kyro/STG4000Ramdac.c b/drivers/video/fbdev/kyro/STG4000Ramdac.c
similarity index 100%
rename from drivers/video/kyro/STG4000Ramdac.c
rename to drivers/video/fbdev/kyro/STG4000Ramdac.c
diff --git a/drivers/video/kyro/STG4000Reg.h b/drivers/video/fbdev/kyro/STG4000Reg.h
similarity index 100%
rename from drivers/video/kyro/STG4000Reg.h
rename to drivers/video/fbdev/kyro/STG4000Reg.h
diff --git a/drivers/video/kyro/STG4000VTG.c b/drivers/video/fbdev/kyro/STG4000VTG.c
similarity index 100%
rename from drivers/video/kyro/STG4000VTG.c
rename to drivers/video/fbdev/kyro/STG4000VTG.c
diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
similarity index 100%
rename from drivers/video/kyro/fbdev.c
rename to drivers/video/fbdev/kyro/fbdev.c
diff --git a/drivers/video/leo.c b/drivers/video/fbdev/leo.c
similarity index 100%
rename from drivers/video/leo.c
rename to drivers/video/fbdev/leo.c
diff --git a/drivers/video/macfb.c b/drivers/video/fbdev/macfb.c
similarity index 100%
rename from drivers/video/macfb.c
rename to drivers/video/fbdev/macfb.c
diff --git a/drivers/video/macmodes.c b/drivers/video/fbdev/macmodes.c
similarity index 100%
rename from drivers/video/macmodes.c
rename to drivers/video/fbdev/macmodes.c
diff --git a/drivers/video/macmodes.h b/drivers/video/fbdev/macmodes.h
similarity index 100%
rename from drivers/video/macmodes.h
rename to drivers/video/fbdev/macmodes.h
diff --git a/drivers/video/matrox/Makefile b/drivers/video/fbdev/matrox/Makefile
similarity index 100%
rename from drivers/video/matrox/Makefile
rename to drivers/video/fbdev/matrox/Makefile
diff --git a/drivers/video/matrox/g450_pll.c b/drivers/video/fbdev/matrox/g450_pll.c
similarity index 100%
rename from drivers/video/matrox/g450_pll.c
rename to drivers/video/fbdev/matrox/g450_pll.c
diff --git a/drivers/video/matrox/g450_pll.h b/drivers/video/fbdev/matrox/g450_pll.h
similarity index 100%
rename from drivers/video/matrox/g450_pll.h
rename to drivers/video/fbdev/matrox/g450_pll.h
diff --git a/drivers/video/matrox/i2c-matroxfb.c b/drivers/video/fbdev/matrox/i2c-matroxfb.c
similarity index 100%
rename from drivers/video/matrox/i2c-matroxfb.c
rename to drivers/video/fbdev/matrox/i2c-matroxfb.c
diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/fbdev/matrox/matroxfb_DAC1064.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_DAC1064.c
rename to drivers/video/fbdev/matrox/matroxfb_DAC1064.c
diff --git a/drivers/video/matrox/matroxfb_DAC1064.h b/drivers/video/fbdev/matrox/matroxfb_DAC1064.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_DAC1064.h
rename to drivers/video/fbdev/matrox/matroxfb_DAC1064.h
diff --git a/drivers/video/matrox/matroxfb_Ti3026.c b/drivers/video/fbdev/matrox/matroxfb_Ti3026.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_Ti3026.c
rename to drivers/video/fbdev/matrox/matroxfb_Ti3026.c
diff --git a/drivers/video/matrox/matroxfb_Ti3026.h b/drivers/video/fbdev/matrox/matroxfb_Ti3026.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_Ti3026.h
rename to drivers/video/fbdev/matrox/matroxfb_Ti3026.h
diff --git a/drivers/video/matrox/matroxfb_accel.c b/drivers/video/fbdev/matrox/matroxfb_accel.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_accel.c
rename to drivers/video/fbdev/matrox/matroxfb_accel.c
diff --git a/drivers/video/matrox/matroxfb_accel.h b/drivers/video/fbdev/matrox/matroxfb_accel.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_accel.h
rename to drivers/video/fbdev/matrox/matroxfb_accel.h
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_base.c
rename to drivers/video/fbdev/matrox/matroxfb_base.c
diff --git a/drivers/video/matrox/matroxfb_base.h b/drivers/video/fbdev/matrox/matroxfb_base.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_base.h
rename to drivers/video/fbdev/matrox/matroxfb_base.h
diff --git a/drivers/video/matrox/matroxfb_crtc2.c b/drivers/video/fbdev/matrox/matroxfb_crtc2.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_crtc2.c
rename to drivers/video/fbdev/matrox/matroxfb_crtc2.c
diff --git a/drivers/video/matrox/matroxfb_crtc2.h b/drivers/video/fbdev/matrox/matroxfb_crtc2.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_crtc2.h
rename to drivers/video/fbdev/matrox/matroxfb_crtc2.h
diff --git a/drivers/video/matrox/matroxfb_g450.c b/drivers/video/fbdev/matrox/matroxfb_g450.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_g450.c
rename to drivers/video/fbdev/matrox/matroxfb_g450.c
diff --git a/drivers/video/matrox/matroxfb_g450.h b/drivers/video/fbdev/matrox/matroxfb_g450.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_g450.h
rename to drivers/video/fbdev/matrox/matroxfb_g450.h
diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/fbdev/matrox/matroxfb_maven.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_maven.c
rename to drivers/video/fbdev/matrox/matroxfb_maven.c
diff --git a/drivers/video/matrox/matroxfb_maven.h b/drivers/video/fbdev/matrox/matroxfb_maven.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_maven.h
rename to drivers/video/fbdev/matrox/matroxfb_maven.h
diff --git a/drivers/video/matrox/matroxfb_misc.c b/drivers/video/fbdev/matrox/matroxfb_misc.c
similarity index 100%
rename from drivers/video/matrox/matroxfb_misc.c
rename to drivers/video/fbdev/matrox/matroxfb_misc.c
diff --git a/drivers/video/matrox/matroxfb_misc.h b/drivers/video/fbdev/matrox/matroxfb_misc.h
similarity index 100%
rename from drivers/video/matrox/matroxfb_misc.h
rename to drivers/video/fbdev/matrox/matroxfb_misc.h
diff --git a/drivers/video/maxinefb.c b/drivers/video/fbdev/maxinefb.c
similarity index 100%
rename from drivers/video/maxinefb.c
rename to drivers/video/fbdev/maxinefb.c
diff --git a/drivers/video/mb862xx/Makefile b/drivers/video/fbdev/mb862xx/Makefile
similarity index 100%
rename from drivers/video/mb862xx/Makefile
rename to drivers/video/fbdev/mb862xx/Makefile
diff --git a/drivers/video/mb862xx/mb862xx-i2c.c b/drivers/video/fbdev/mb862xx/mb862xx-i2c.c
similarity index 100%
rename from drivers/video/mb862xx/mb862xx-i2c.c
rename to drivers/video/fbdev/mb862xx/mb862xx-i2c.c
diff --git a/drivers/video/mb862xx/mb862xx_reg.h b/drivers/video/fbdev/mb862xx/mb862xx_reg.h
similarity index 100%
rename from drivers/video/mb862xx/mb862xx_reg.h
rename to drivers/video/fbdev/mb862xx/mb862xx_reg.h
diff --git a/drivers/video/mb862xx/mb862xxfb.h b/drivers/video/fbdev/mb862xx/mb862xxfb.h
similarity index 100%
rename from drivers/video/mb862xx/mb862xxfb.h
rename to drivers/video/fbdev/mb862xx/mb862xxfb.h
diff --git a/drivers/video/mb862xx/mb862xxfb_accel.c b/drivers/video/fbdev/mb862xx/mb862xxfb_accel.c
similarity index 100%
rename from drivers/video/mb862xx/mb862xxfb_accel.c
rename to drivers/video/fbdev/mb862xx/mb862xxfb_accel.c
diff --git a/drivers/video/mb862xx/mb862xxfb_accel.h b/drivers/video/fbdev/mb862xx/mb862xxfb_accel.h
similarity index 100%
rename from drivers/video/mb862xx/mb862xxfb_accel.h
rename to drivers/video/fbdev/mb862xx/mb862xxfb_accel.h
diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/fbdev/mb862xx/mb862xxfbdrv.c
similarity index 100%
rename from drivers/video/mb862xx/mb862xxfbdrv.c
rename to drivers/video/fbdev/mb862xx/mb862xxfbdrv.c
diff --git a/drivers/video/mbx/Makefile b/drivers/video/fbdev/mbx/Makefile
similarity index 100%
rename from drivers/video/mbx/Makefile
rename to drivers/video/fbdev/mbx/Makefile
diff --git a/drivers/video/mbx/mbxdebugfs.c b/drivers/video/fbdev/mbx/mbxdebugfs.c
similarity index 100%
rename from drivers/video/mbx/mbxdebugfs.c
rename to drivers/video/fbdev/mbx/mbxdebugfs.c
diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/fbdev/mbx/mbxfb.c
similarity index 100%
rename from drivers/video/mbx/mbxfb.c
rename to drivers/video/fbdev/mbx/mbxfb.c
diff --git a/drivers/video/mbx/reg_bits.h b/drivers/video/fbdev/mbx/reg_bits.h
similarity index 100%
rename from drivers/video/mbx/reg_bits.h
rename to drivers/video/fbdev/mbx/reg_bits.h
diff --git a/drivers/video/mbx/regs.h b/drivers/video/fbdev/mbx/regs.h
similarity index 100%
rename from drivers/video/mbx/regs.h
rename to drivers/video/fbdev/mbx/regs.h
diff --git a/drivers/video/metronomefb.c b/drivers/video/fbdev/metronomefb.c
similarity index 100%
rename from drivers/video/metronomefb.c
rename to drivers/video/fbdev/metronomefb.c
diff --git a/drivers/video/mmp/Kconfig b/drivers/video/fbdev/mmp/Kconfig
similarity index 61%
rename from drivers/video/mmp/Kconfig
rename to drivers/video/fbdev/mmp/Kconfig
index e9ea39e13722..d4a4ffc24749 100644
--- a/drivers/video/mmp/Kconfig
+++ b/drivers/video/fbdev/mmp/Kconfig
@@ -5,7 +5,7 @@ menuconfig MMP_DISP
 	  Marvell Display Subsystem support.
 
 if MMP_DISP
-source "drivers/video/mmp/hw/Kconfig"
-source "drivers/video/mmp/panel/Kconfig"
-source "drivers/video/mmp/fb/Kconfig"
+source "drivers/video/fbdev/mmp/hw/Kconfig"
+source "drivers/video/fbdev/mmp/panel/Kconfig"
+source "drivers/video/fbdev/mmp/fb/Kconfig"
 endif
diff --git a/drivers/video/mmp/Makefile b/drivers/video/fbdev/mmp/Makefile
similarity index 100%
rename from drivers/video/mmp/Makefile
rename to drivers/video/fbdev/mmp/Makefile
diff --git a/drivers/video/mmp/core.c b/drivers/video/fbdev/mmp/core.c
similarity index 100%
rename from drivers/video/mmp/core.c
rename to drivers/video/fbdev/mmp/core.c
diff --git a/drivers/video/mmp/fb/Kconfig b/drivers/video/fbdev/mmp/fb/Kconfig
similarity index 100%
rename from drivers/video/mmp/fb/Kconfig
rename to drivers/video/fbdev/mmp/fb/Kconfig
diff --git a/drivers/video/mmp/fb/Makefile b/drivers/video/fbdev/mmp/fb/Makefile
similarity index 100%
rename from drivers/video/mmp/fb/Makefile
rename to drivers/video/fbdev/mmp/fb/Makefile
diff --git a/drivers/video/mmp/fb/mmpfb.c b/drivers/video/fbdev/mmp/fb/mmpfb.c
similarity index 100%
rename from drivers/video/mmp/fb/mmpfb.c
rename to drivers/video/fbdev/mmp/fb/mmpfb.c
diff --git a/drivers/video/mmp/fb/mmpfb.h b/drivers/video/fbdev/mmp/fb/mmpfb.h
similarity index 100%
rename from drivers/video/mmp/fb/mmpfb.h
rename to drivers/video/fbdev/mmp/fb/mmpfb.h
diff --git a/drivers/video/mmp/hw/Kconfig b/drivers/video/fbdev/mmp/hw/Kconfig
similarity index 100%
rename from drivers/video/mmp/hw/Kconfig
rename to drivers/video/fbdev/mmp/hw/Kconfig
diff --git a/drivers/video/mmp/hw/Makefile b/drivers/video/fbdev/mmp/hw/Makefile
similarity index 100%
rename from drivers/video/mmp/hw/Makefile
rename to drivers/video/fbdev/mmp/hw/Makefile
diff --git a/drivers/video/mmp/hw/mmp_ctrl.c b/drivers/video/fbdev/mmp/hw/mmp_ctrl.c
similarity index 100%
rename from drivers/video/mmp/hw/mmp_ctrl.c
rename to drivers/video/fbdev/mmp/hw/mmp_ctrl.c
diff --git a/drivers/video/mmp/hw/mmp_ctrl.h b/drivers/video/fbdev/mmp/hw/mmp_ctrl.h
similarity index 100%
rename from drivers/video/mmp/hw/mmp_ctrl.h
rename to drivers/video/fbdev/mmp/hw/mmp_ctrl.h
diff --git a/drivers/video/mmp/hw/mmp_spi.c b/drivers/video/fbdev/mmp/hw/mmp_spi.c
similarity index 100%
rename from drivers/video/mmp/hw/mmp_spi.c
rename to drivers/video/fbdev/mmp/hw/mmp_spi.c
diff --git a/drivers/video/mmp/panel/Kconfig b/drivers/video/fbdev/mmp/panel/Kconfig
similarity index 100%
rename from drivers/video/mmp/panel/Kconfig
rename to drivers/video/fbdev/mmp/panel/Kconfig
diff --git a/drivers/video/mmp/panel/Makefile b/drivers/video/fbdev/mmp/panel/Makefile
similarity index 100%
rename from drivers/video/mmp/panel/Makefile
rename to drivers/video/fbdev/mmp/panel/Makefile
diff --git a/drivers/video/mmp/panel/tpo_tj032md01bw.c b/drivers/video/fbdev/mmp/panel/tpo_tj032md01bw.c
similarity index 100%
rename from drivers/video/mmp/panel/tpo_tj032md01bw.c
rename to drivers/video/fbdev/mmp/panel/tpo_tj032md01bw.c
diff --git a/drivers/video/modedb.c b/drivers/video/fbdev/modedb.c
similarity index 100%
rename from drivers/video/modedb.c
rename to drivers/video/fbdev/modedb.c
diff --git a/drivers/video/msm/Makefile b/drivers/video/fbdev/msm/Makefile
similarity index 100%
rename from drivers/video/msm/Makefile
rename to drivers/video/fbdev/msm/Makefile
diff --git a/drivers/video/msm/mddi.c b/drivers/video/fbdev/msm/mddi.c
similarity index 100%
rename from drivers/video/msm/mddi.c
rename to drivers/video/fbdev/msm/mddi.c
diff --git a/drivers/video/msm/mddi_client_dummy.c b/drivers/video/fbdev/msm/mddi_client_dummy.c
similarity index 100%
rename from drivers/video/msm/mddi_client_dummy.c
rename to drivers/video/fbdev/msm/mddi_client_dummy.c
diff --git a/drivers/video/msm/mddi_client_nt35399.c b/drivers/video/fbdev/msm/mddi_client_nt35399.c
similarity index 100%
rename from drivers/video/msm/mddi_client_nt35399.c
rename to drivers/video/fbdev/msm/mddi_client_nt35399.c
diff --git a/drivers/video/msm/mddi_client_toshiba.c b/drivers/video/fbdev/msm/mddi_client_toshiba.c
similarity index 100%
rename from drivers/video/msm/mddi_client_toshiba.c
rename to drivers/video/fbdev/msm/mddi_client_toshiba.c
diff --git a/drivers/video/msm/mddi_hw.h b/drivers/video/fbdev/msm/mddi_hw.h
similarity index 100%
rename from drivers/video/msm/mddi_hw.h
rename to drivers/video/fbdev/msm/mddi_hw.h
diff --git a/drivers/video/msm/mdp.c b/drivers/video/fbdev/msm/mdp.c
similarity index 100%
rename from drivers/video/msm/mdp.c
rename to drivers/video/fbdev/msm/mdp.c
diff --git a/drivers/video/msm/mdp_csc_table.h b/drivers/video/fbdev/msm/mdp_csc_table.h
similarity index 100%
rename from drivers/video/msm/mdp_csc_table.h
rename to drivers/video/fbdev/msm/mdp_csc_table.h
diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/fbdev/msm/mdp_hw.h
similarity index 100%
rename from drivers/video/msm/mdp_hw.h
rename to drivers/video/fbdev/msm/mdp_hw.h
diff --git a/drivers/video/msm/mdp_ppp.c b/drivers/video/fbdev/msm/mdp_ppp.c
similarity index 100%
rename from drivers/video/msm/mdp_ppp.c
rename to drivers/video/fbdev/msm/mdp_ppp.c
diff --git a/drivers/video/msm/mdp_scale_tables.c b/drivers/video/fbdev/msm/mdp_scale_tables.c
similarity index 100%
rename from drivers/video/msm/mdp_scale_tables.c
rename to drivers/video/fbdev/msm/mdp_scale_tables.c
diff --git a/drivers/video/msm/mdp_scale_tables.h b/drivers/video/fbdev/msm/mdp_scale_tables.h
similarity index 100%
rename from drivers/video/msm/mdp_scale_tables.h
rename to drivers/video/fbdev/msm/mdp_scale_tables.h
diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/fbdev/msm/msm_fb.c
similarity index 100%
rename from drivers/video/msm/msm_fb.c
rename to drivers/video/fbdev/msm/msm_fb.c
diff --git a/drivers/video/mx3fb.c b/drivers/video/fbdev/mx3fb.c
similarity index 100%
rename from drivers/video/mx3fb.c
rename to drivers/video/fbdev/mx3fb.c
diff --git a/drivers/video/mxsfb.c b/drivers/video/fbdev/mxsfb.c
similarity index 100%
rename from drivers/video/mxsfb.c
rename to drivers/video/fbdev/mxsfb.c
diff --git a/drivers/video/n411.c b/drivers/video/fbdev/n411.c
similarity index 100%
rename from drivers/video/n411.c
rename to drivers/video/fbdev/n411.c
diff --git a/drivers/video/neofb.c b/drivers/video/fbdev/neofb.c
similarity index 100%
rename from drivers/video/neofb.c
rename to drivers/video/fbdev/neofb.c
diff --git a/drivers/video/nuc900fb.c b/drivers/video/fbdev/nuc900fb.c
similarity index 100%
rename from drivers/video/nuc900fb.c
rename to drivers/video/fbdev/nuc900fb.c
diff --git a/drivers/video/nuc900fb.h b/drivers/video/fbdev/nuc900fb.h
similarity index 100%
rename from drivers/video/nuc900fb.h
rename to drivers/video/fbdev/nuc900fb.h
diff --git a/drivers/video/nvidia/Makefile b/drivers/video/fbdev/nvidia/Makefile
similarity index 100%
rename from drivers/video/nvidia/Makefile
rename to drivers/video/fbdev/nvidia/Makefile
diff --git a/drivers/video/nvidia/nv_accel.c b/drivers/video/fbdev/nvidia/nv_accel.c
similarity index 100%
rename from drivers/video/nvidia/nv_accel.c
rename to drivers/video/fbdev/nvidia/nv_accel.c
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/fbdev/nvidia/nv_backlight.c
similarity index 100%
rename from drivers/video/nvidia/nv_backlight.c
rename to drivers/video/fbdev/nvidia/nv_backlight.c
diff --git a/drivers/video/nvidia/nv_dma.h b/drivers/video/fbdev/nvidia/nv_dma.h
similarity index 100%
rename from drivers/video/nvidia/nv_dma.h
rename to drivers/video/fbdev/nvidia/nv_dma.h
diff --git a/drivers/video/nvidia/nv_hw.c b/drivers/video/fbdev/nvidia/nv_hw.c
similarity index 100%
rename from drivers/video/nvidia/nv_hw.c
rename to drivers/video/fbdev/nvidia/nv_hw.c
diff --git a/drivers/video/nvidia/nv_i2c.c b/drivers/video/fbdev/nvidia/nv_i2c.c
similarity index 100%
rename from drivers/video/nvidia/nv_i2c.c
rename to drivers/video/fbdev/nvidia/nv_i2c.c
diff --git a/drivers/video/nvidia/nv_local.h b/drivers/video/fbdev/nvidia/nv_local.h
similarity index 100%
rename from drivers/video/nvidia/nv_local.h
rename to drivers/video/fbdev/nvidia/nv_local.h
diff --git a/drivers/video/nvidia/nv_of.c b/drivers/video/fbdev/nvidia/nv_of.c
similarity index 100%
rename from drivers/video/nvidia/nv_of.c
rename to drivers/video/fbdev/nvidia/nv_of.c
diff --git a/drivers/video/nvidia/nv_proto.h b/drivers/video/fbdev/nvidia/nv_proto.h
similarity index 100%
rename from drivers/video/nvidia/nv_proto.h
rename to drivers/video/fbdev/nvidia/nv_proto.h
diff --git a/drivers/video/nvidia/nv_setup.c b/drivers/video/fbdev/nvidia/nv_setup.c
similarity index 100%
rename from drivers/video/nvidia/nv_setup.c
rename to drivers/video/fbdev/nvidia/nv_setup.c
diff --git a/drivers/video/nvidia/nv_type.h b/drivers/video/fbdev/nvidia/nv_type.h
similarity index 100%
rename from drivers/video/nvidia/nv_type.h
rename to drivers/video/fbdev/nvidia/nv_type.h
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
similarity index 100%
rename from drivers/video/nvidia/nvidia.c
rename to drivers/video/fbdev/nvidia/nvidia.c
diff --git a/drivers/video/ocfb.c b/drivers/video/fbdev/ocfb.c
similarity index 100%
rename from drivers/video/ocfb.c
rename to drivers/video/fbdev/ocfb.c
diff --git a/drivers/video/offb.c b/drivers/video/fbdev/offb.c
similarity index 100%
rename from drivers/video/offb.c
rename to drivers/video/fbdev/offb.c
diff --git a/drivers/video/omap/Kconfig b/drivers/video/fbdev/omap/Kconfig
similarity index 100%
rename from drivers/video/omap/Kconfig
rename to drivers/video/fbdev/omap/Kconfig
diff --git a/drivers/video/omap/Makefile b/drivers/video/fbdev/omap/Makefile
similarity index 100%
rename from drivers/video/omap/Makefile
rename to drivers/video/fbdev/omap/Makefile
diff --git a/drivers/video/omap/hwa742.c b/drivers/video/fbdev/omap/hwa742.c
similarity index 100%
rename from drivers/video/omap/hwa742.c
rename to drivers/video/fbdev/omap/hwa742.c
diff --git a/drivers/video/omap/lcd_ams_delta.c b/drivers/video/fbdev/omap/lcd_ams_delta.c
similarity index 100%
rename from drivers/video/omap/lcd_ams_delta.c
rename to drivers/video/fbdev/omap/lcd_ams_delta.c
diff --git a/drivers/video/omap/lcd_h3.c b/drivers/video/fbdev/omap/lcd_h3.c
similarity index 100%
rename from drivers/video/omap/lcd_h3.c
rename to drivers/video/fbdev/omap/lcd_h3.c
diff --git a/drivers/video/omap/lcd_htcherald.c b/drivers/video/fbdev/omap/lcd_htcherald.c
similarity index 100%
rename from drivers/video/omap/lcd_htcherald.c
rename to drivers/video/fbdev/omap/lcd_htcherald.c
diff --git a/drivers/video/omap/lcd_inn1510.c b/drivers/video/fbdev/omap/lcd_inn1510.c
similarity index 100%
rename from drivers/video/omap/lcd_inn1510.c
rename to drivers/video/fbdev/omap/lcd_inn1510.c
diff --git a/drivers/video/omap/lcd_inn1610.c b/drivers/video/fbdev/omap/lcd_inn1610.c
similarity index 100%
rename from drivers/video/omap/lcd_inn1610.c
rename to drivers/video/fbdev/omap/lcd_inn1610.c
diff --git a/drivers/video/omap/lcd_mipid.c b/drivers/video/fbdev/omap/lcd_mipid.c
similarity index 100%
rename from drivers/video/omap/lcd_mipid.c
rename to drivers/video/fbdev/omap/lcd_mipid.c
diff --git a/drivers/video/omap/lcd_osk.c b/drivers/video/fbdev/omap/lcd_osk.c
similarity index 100%
rename from drivers/video/omap/lcd_osk.c
rename to drivers/video/fbdev/omap/lcd_osk.c
diff --git a/drivers/video/omap/lcd_palmte.c b/drivers/video/fbdev/omap/lcd_palmte.c
similarity index 100%
rename from drivers/video/omap/lcd_palmte.c
rename to drivers/video/fbdev/omap/lcd_palmte.c
diff --git a/drivers/video/omap/lcd_palmtt.c b/drivers/video/fbdev/omap/lcd_palmtt.c
similarity index 100%
rename from drivers/video/omap/lcd_palmtt.c
rename to drivers/video/fbdev/omap/lcd_palmtt.c
diff --git a/drivers/video/omap/lcd_palmz71.c b/drivers/video/fbdev/omap/lcd_palmz71.c
similarity index 100%
rename from drivers/video/omap/lcd_palmz71.c
rename to drivers/video/fbdev/omap/lcd_palmz71.c
diff --git a/drivers/video/omap/lcdc.c b/drivers/video/fbdev/omap/lcdc.c
similarity index 100%
rename from drivers/video/omap/lcdc.c
rename to drivers/video/fbdev/omap/lcdc.c
diff --git a/drivers/video/omap/lcdc.h b/drivers/video/fbdev/omap/lcdc.h
similarity index 100%
rename from drivers/video/omap/lcdc.h
rename to drivers/video/fbdev/omap/lcdc.h
diff --git a/drivers/video/omap/omapfb.h b/drivers/video/fbdev/omap/omapfb.h
similarity index 100%
rename from drivers/video/omap/omapfb.h
rename to drivers/video/fbdev/omap/omapfb.h
diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c
similarity index 100%
rename from drivers/video/omap/omapfb_main.c
rename to drivers/video/fbdev/omap/omapfb_main.c
diff --git a/drivers/video/omap/sossi.c b/drivers/video/fbdev/omap/sossi.c
similarity index 100%
rename from drivers/video/omap/sossi.c
rename to drivers/video/fbdev/omap/sossi.c
diff --git a/drivers/video/fbdev/omap2/Kconfig b/drivers/video/fbdev/omap2/Kconfig
new file mode 100644
index 000000000000..c22955d2de9a
--- /dev/null
+++ b/drivers/video/fbdev/omap2/Kconfig
@@ -0,0 +1,10 @@
+config OMAP2_VRFB
+	bool
+
+if ARCH_OMAP2PLUS
+
+source "drivers/video/fbdev/omap2/dss/Kconfig"
+source "drivers/video/fbdev/omap2/omapfb/Kconfig"
+source "drivers/video/fbdev/omap2/displays-new/Kconfig"
+
+endif
diff --git a/drivers/video/omap2/Makefile b/drivers/video/fbdev/omap2/Makefile
similarity index 100%
rename from drivers/video/omap2/Makefile
rename to drivers/video/fbdev/omap2/Makefile
diff --git a/drivers/video/omap2/displays-new/Kconfig b/drivers/video/fbdev/omap2/displays-new/Kconfig
similarity index 100%
rename from drivers/video/omap2/displays-new/Kconfig
rename to drivers/video/fbdev/omap2/displays-new/Kconfig
diff --git a/drivers/video/omap2/displays-new/Makefile b/drivers/video/fbdev/omap2/displays-new/Makefile
similarity index 100%
rename from drivers/video/omap2/displays-new/Makefile
rename to drivers/video/fbdev/omap2/displays-new/Makefile
diff --git a/drivers/video/omap2/displays-new/connector-analog-tv.c b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
similarity index 100%
rename from drivers/video/omap2/displays-new/connector-analog-tv.c
rename to drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
diff --git a/drivers/video/omap2/displays-new/connector-dvi.c b/drivers/video/fbdev/omap2/displays-new/connector-dvi.c
similarity index 100%
rename from drivers/video/omap2/displays-new/connector-dvi.c
rename to drivers/video/fbdev/omap2/displays-new/connector-dvi.c
diff --git a/drivers/video/omap2/displays-new/connector-hdmi.c b/drivers/video/fbdev/omap2/displays-new/connector-hdmi.c
similarity index 100%
rename from drivers/video/omap2/displays-new/connector-hdmi.c
rename to drivers/video/fbdev/omap2/displays-new/connector-hdmi.c
diff --git a/drivers/video/omap2/displays-new/encoder-tfp410.c b/drivers/video/fbdev/omap2/displays-new/encoder-tfp410.c
similarity index 100%
rename from drivers/video/omap2/displays-new/encoder-tfp410.c
rename to drivers/video/fbdev/omap2/displays-new/encoder-tfp410.c
diff --git a/drivers/video/omap2/displays-new/encoder-tpd12s015.c b/drivers/video/fbdev/omap2/displays-new/encoder-tpd12s015.c
similarity index 100%
rename from drivers/video/omap2/displays-new/encoder-tpd12s015.c
rename to drivers/video/fbdev/omap2/displays-new/encoder-tpd12s015.c
diff --git a/drivers/video/omap2/displays-new/panel-dpi.c b/drivers/video/fbdev/omap2/displays-new/panel-dpi.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-dpi.c
rename to drivers/video/fbdev/omap2/displays-new/panel-dpi.c
diff --git a/drivers/video/omap2/displays-new/panel-dsi-cm.c b/drivers/video/fbdev/omap2/displays-new/panel-dsi-cm.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-dsi-cm.c
rename to drivers/video/fbdev/omap2/displays-new/panel-dsi-cm.c
diff --git a/drivers/video/omap2/displays-new/panel-lgphilips-lb035q02.c b/drivers/video/fbdev/omap2/displays-new/panel-lgphilips-lb035q02.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-lgphilips-lb035q02.c
rename to drivers/video/fbdev/omap2/displays-new/panel-lgphilips-lb035q02.c
diff --git a/drivers/video/omap2/displays-new/panel-nec-nl8048hl11.c b/drivers/video/fbdev/omap2/displays-new/panel-nec-nl8048hl11.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-nec-nl8048hl11.c
rename to drivers/video/fbdev/omap2/displays-new/panel-nec-nl8048hl11.c
diff --git a/drivers/video/omap2/displays-new/panel-sharp-ls037v7dw01.c b/drivers/video/fbdev/omap2/displays-new/panel-sharp-ls037v7dw01.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-sharp-ls037v7dw01.c
rename to drivers/video/fbdev/omap2/displays-new/panel-sharp-ls037v7dw01.c
diff --git a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c b/drivers/video/fbdev/omap2/displays-new/panel-sony-acx565akm.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-sony-acx565akm.c
rename to drivers/video/fbdev/omap2/displays-new/panel-sony-acx565akm.c
diff --git a/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c b/drivers/video/fbdev/omap2/displays-new/panel-tpo-td028ttec1.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
rename to drivers/video/fbdev/omap2/displays-new/panel-tpo-td028ttec1.c
diff --git a/drivers/video/omap2/displays-new/panel-tpo-td043mtea1.c b/drivers/video/fbdev/omap2/displays-new/panel-tpo-td043mtea1.c
similarity index 100%
rename from drivers/video/omap2/displays-new/panel-tpo-td043mtea1.c
rename to drivers/video/fbdev/omap2/displays-new/panel-tpo-td043mtea1.c
diff --git a/drivers/video/omap2/dss/Kconfig b/drivers/video/fbdev/omap2/dss/Kconfig
similarity index 100%
rename from drivers/video/omap2/dss/Kconfig
rename to drivers/video/fbdev/omap2/dss/Kconfig
diff --git a/drivers/video/omap2/dss/Makefile b/drivers/video/fbdev/omap2/dss/Makefile
similarity index 100%
rename from drivers/video/omap2/dss/Makefile
rename to drivers/video/fbdev/omap2/dss/Makefile
diff --git a/drivers/video/omap2/dss/apply.c b/drivers/video/fbdev/omap2/dss/apply.c
similarity index 100%
rename from drivers/video/omap2/dss/apply.c
rename to drivers/video/fbdev/omap2/dss/apply.c
diff --git a/drivers/video/omap2/dss/core.c b/drivers/video/fbdev/omap2/dss/core.c
similarity index 100%
rename from drivers/video/omap2/dss/core.c
rename to drivers/video/fbdev/omap2/dss/core.c
diff --git a/drivers/video/omap2/dss/dispc-compat.c b/drivers/video/fbdev/omap2/dss/dispc-compat.c
similarity index 100%
rename from drivers/video/omap2/dss/dispc-compat.c
rename to drivers/video/fbdev/omap2/dss/dispc-compat.c
diff --git a/drivers/video/omap2/dss/dispc-compat.h b/drivers/video/fbdev/omap2/dss/dispc-compat.h
similarity index 100%
rename from drivers/video/omap2/dss/dispc-compat.h
rename to drivers/video/fbdev/omap2/dss/dispc-compat.h
diff --git a/drivers/video/omap2/dss/dispc.c b/drivers/video/fbdev/omap2/dss/dispc.c
similarity index 100%
rename from drivers/video/omap2/dss/dispc.c
rename to drivers/video/fbdev/omap2/dss/dispc.c
diff --git a/drivers/video/omap2/dss/dispc.h b/drivers/video/fbdev/omap2/dss/dispc.h
similarity index 100%
rename from drivers/video/omap2/dss/dispc.h
rename to drivers/video/fbdev/omap2/dss/dispc.h
diff --git a/drivers/video/omap2/dss/dispc_coefs.c b/drivers/video/fbdev/omap2/dss/dispc_coefs.c
similarity index 100%
rename from drivers/video/omap2/dss/dispc_coefs.c
rename to drivers/video/fbdev/omap2/dss/dispc_coefs.c
diff --git a/drivers/video/omap2/dss/display-sysfs.c b/drivers/video/fbdev/omap2/dss/display-sysfs.c
similarity index 100%
rename from drivers/video/omap2/dss/display-sysfs.c
rename to drivers/video/fbdev/omap2/dss/display-sysfs.c
diff --git a/drivers/video/omap2/dss/display.c b/drivers/video/fbdev/omap2/dss/display.c
similarity index 100%
rename from drivers/video/omap2/dss/display.c
rename to drivers/video/fbdev/omap2/dss/display.c
diff --git a/drivers/video/omap2/dss/dpi.c b/drivers/video/fbdev/omap2/dss/dpi.c
similarity index 100%
rename from drivers/video/omap2/dss/dpi.c
rename to drivers/video/fbdev/omap2/dss/dpi.c
diff --git a/drivers/video/omap2/dss/dsi.c b/drivers/video/fbdev/omap2/dss/dsi.c
similarity index 100%
rename from drivers/video/omap2/dss/dsi.c
rename to drivers/video/fbdev/omap2/dss/dsi.c
diff --git a/drivers/video/omap2/dss/dss.c b/drivers/video/fbdev/omap2/dss/dss.c
similarity index 100%
rename from drivers/video/omap2/dss/dss.c
rename to drivers/video/fbdev/omap2/dss/dss.c
diff --git a/drivers/video/omap2/dss/dss.h b/drivers/video/fbdev/omap2/dss/dss.h
similarity index 100%
rename from drivers/video/omap2/dss/dss.h
rename to drivers/video/fbdev/omap2/dss/dss.h
diff --git a/drivers/video/omap2/dss/dss_features.c b/drivers/video/fbdev/omap2/dss/dss_features.c
similarity index 100%
rename from drivers/video/omap2/dss/dss_features.c
rename to drivers/video/fbdev/omap2/dss/dss_features.c
diff --git a/drivers/video/omap2/dss/dss_features.h b/drivers/video/fbdev/omap2/dss/dss_features.h
similarity index 100%
rename from drivers/video/omap2/dss/dss_features.h
rename to drivers/video/fbdev/omap2/dss/dss_features.h
diff --git a/drivers/video/omap2/dss/hdmi.h b/drivers/video/fbdev/omap2/dss/hdmi.h
similarity index 100%
rename from drivers/video/omap2/dss/hdmi.h
rename to drivers/video/fbdev/omap2/dss/hdmi.h
diff --git a/drivers/video/omap2/dss/hdmi4.c b/drivers/video/fbdev/omap2/dss/hdmi4.c
similarity index 100%
rename from drivers/video/omap2/dss/hdmi4.c
rename to drivers/video/fbdev/omap2/dss/hdmi4.c
diff --git a/drivers/video/omap2/dss/hdmi4_core.c b/drivers/video/fbdev/omap2/dss/hdmi4_core.c
similarity index 100%
rename from drivers/video/omap2/dss/hdmi4_core.c
rename to drivers/video/fbdev/omap2/dss/hdmi4_core.c
diff --git a/drivers/video/omap2/dss/hdmi4_core.h b/drivers/video/fbdev/omap2/dss/hdmi4_core.h
similarity index 100%
rename from drivers/video/omap2/dss/hdmi4_core.h
rename to drivers/video/fbdev/omap2/dss/hdmi4_core.h
diff --git a/drivers/video/omap2/dss/hdmi_common.c b/drivers/video/fbdev/omap2/dss/hdmi_common.c
similarity index 100%
rename from drivers/video/omap2/dss/hdmi_common.c
rename to drivers/video/fbdev/omap2/dss/hdmi_common.c
diff --git a/drivers/video/omap2/dss/hdmi_phy.c b/drivers/video/fbdev/omap2/dss/hdmi_phy.c
similarity index 100%
rename from drivers/video/omap2/dss/hdmi_phy.c
rename to drivers/video/fbdev/omap2/dss/hdmi_phy.c
diff --git a/drivers/video/omap2/dss/hdmi_pll.c b/drivers/video/fbdev/omap2/dss/hdmi_pll.c
similarity index 100%
rename from drivers/video/omap2/dss/hdmi_pll.c
rename to drivers/video/fbdev/omap2/dss/hdmi_pll.c
diff --git a/drivers/video/omap2/dss/hdmi_wp.c b/drivers/video/fbdev/omap2/dss/hdmi_wp.c
similarity index 100%
rename from drivers/video/omap2/dss/hdmi_wp.c
rename to drivers/video/fbdev/omap2/dss/hdmi_wp.c
diff --git a/drivers/video/omap2/dss/manager-sysfs.c b/drivers/video/fbdev/omap2/dss/manager-sysfs.c
similarity index 100%
rename from drivers/video/omap2/dss/manager-sysfs.c
rename to drivers/video/fbdev/omap2/dss/manager-sysfs.c
diff --git a/drivers/video/omap2/dss/manager.c b/drivers/video/fbdev/omap2/dss/manager.c
similarity index 100%
rename from drivers/video/omap2/dss/manager.c
rename to drivers/video/fbdev/omap2/dss/manager.c
diff --git a/drivers/video/omap2/dss/output.c b/drivers/video/fbdev/omap2/dss/output.c
similarity index 100%
rename from drivers/video/omap2/dss/output.c
rename to drivers/video/fbdev/omap2/dss/output.c
diff --git a/drivers/video/omap2/dss/overlay-sysfs.c b/drivers/video/fbdev/omap2/dss/overlay-sysfs.c
similarity index 100%
rename from drivers/video/omap2/dss/overlay-sysfs.c
rename to drivers/video/fbdev/omap2/dss/overlay-sysfs.c
diff --git a/drivers/video/omap2/dss/overlay.c b/drivers/video/fbdev/omap2/dss/overlay.c
similarity index 100%
rename from drivers/video/omap2/dss/overlay.c
rename to drivers/video/fbdev/omap2/dss/overlay.c
diff --git a/drivers/video/omap2/dss/rfbi.c b/drivers/video/fbdev/omap2/dss/rfbi.c
similarity index 100%
rename from drivers/video/omap2/dss/rfbi.c
rename to drivers/video/fbdev/omap2/dss/rfbi.c
diff --git a/drivers/video/omap2/dss/sdi.c b/drivers/video/fbdev/omap2/dss/sdi.c
similarity index 100%
rename from drivers/video/omap2/dss/sdi.c
rename to drivers/video/fbdev/omap2/dss/sdi.c
diff --git a/drivers/video/omap2/dss/venc.c b/drivers/video/fbdev/omap2/dss/venc.c
similarity index 100%
rename from drivers/video/omap2/dss/venc.c
rename to drivers/video/fbdev/omap2/dss/venc.c
diff --git a/drivers/video/omap2/dss/venc_panel.c b/drivers/video/fbdev/omap2/dss/venc_panel.c
similarity index 100%
rename from drivers/video/omap2/dss/venc_panel.c
rename to drivers/video/fbdev/omap2/dss/venc_panel.c
diff --git a/drivers/video/omap2/omapfb/Kconfig b/drivers/video/fbdev/omap2/omapfb/Kconfig
similarity index 100%
rename from drivers/video/omap2/omapfb/Kconfig
rename to drivers/video/fbdev/omap2/omapfb/Kconfig
diff --git a/drivers/video/omap2/omapfb/Makefile b/drivers/video/fbdev/omap2/omapfb/Makefile
similarity index 100%
rename from drivers/video/omap2/omapfb/Makefile
rename to drivers/video/fbdev/omap2/omapfb/Makefile
diff --git a/drivers/video/omap2/omapfb/omapfb-ioctl.c b/drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.c
similarity index 100%
rename from drivers/video/omap2/omapfb/omapfb-ioctl.c
rename to drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.c
diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
similarity index 100%
rename from drivers/video/omap2/omapfb/omapfb-main.c
rename to drivers/video/fbdev/omap2/omapfb/omapfb-main.c
diff --git a/drivers/video/omap2/omapfb/omapfb-sysfs.c b/drivers/video/fbdev/omap2/omapfb/omapfb-sysfs.c
similarity index 100%
rename from drivers/video/omap2/omapfb/omapfb-sysfs.c
rename to drivers/video/fbdev/omap2/omapfb/omapfb-sysfs.c
diff --git a/drivers/video/omap2/omapfb/omapfb.h b/drivers/video/fbdev/omap2/omapfb/omapfb.h
similarity index 100%
rename from drivers/video/omap2/omapfb/omapfb.h
rename to drivers/video/fbdev/omap2/omapfb/omapfb.h
diff --git a/drivers/video/omap2/vrfb.c b/drivers/video/fbdev/omap2/vrfb.c
similarity index 100%
rename from drivers/video/omap2/vrfb.c
rename to drivers/video/fbdev/omap2/vrfb.c
diff --git a/drivers/video/p9100.c b/drivers/video/fbdev/p9100.c
similarity index 100%
rename from drivers/video/p9100.c
rename to drivers/video/fbdev/p9100.c
diff --git a/drivers/video/platinumfb.c b/drivers/video/fbdev/platinumfb.c
similarity index 100%
rename from drivers/video/platinumfb.c
rename to drivers/video/fbdev/platinumfb.c
diff --git a/drivers/video/platinumfb.h b/drivers/video/fbdev/platinumfb.h
similarity index 100%
rename from drivers/video/platinumfb.h
rename to drivers/video/fbdev/platinumfb.h
diff --git a/drivers/video/pm2fb.c b/drivers/video/fbdev/pm2fb.c
similarity index 100%
rename from drivers/video/pm2fb.c
rename to drivers/video/fbdev/pm2fb.c
diff --git a/drivers/video/pm3fb.c b/drivers/video/fbdev/pm3fb.c
similarity index 100%
rename from drivers/video/pm3fb.c
rename to drivers/video/fbdev/pm3fb.c
diff --git a/drivers/video/pmag-aa-fb.c b/drivers/video/fbdev/pmag-aa-fb.c
similarity index 100%
rename from drivers/video/pmag-aa-fb.c
rename to drivers/video/fbdev/pmag-aa-fb.c
diff --git a/drivers/video/pmag-ba-fb.c b/drivers/video/fbdev/pmag-ba-fb.c
similarity index 100%
rename from drivers/video/pmag-ba-fb.c
rename to drivers/video/fbdev/pmag-ba-fb.c
diff --git a/drivers/video/pmagb-b-fb.c b/drivers/video/fbdev/pmagb-b-fb.c
similarity index 100%
rename from drivers/video/pmagb-b-fb.c
rename to drivers/video/fbdev/pmagb-b-fb.c
diff --git a/drivers/video/ps3fb.c b/drivers/video/fbdev/ps3fb.c
similarity index 100%
rename from drivers/video/ps3fb.c
rename to drivers/video/fbdev/ps3fb.c
diff --git a/drivers/video/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
similarity index 100%
rename from drivers/video/pvr2fb.c
rename to drivers/video/fbdev/pvr2fb.c
diff --git a/drivers/video/pxa168fb.c b/drivers/video/fbdev/pxa168fb.c
similarity index 100%
rename from drivers/video/pxa168fb.c
rename to drivers/video/fbdev/pxa168fb.c
diff --git a/drivers/video/pxa168fb.h b/drivers/video/fbdev/pxa168fb.h
similarity index 100%
rename from drivers/video/pxa168fb.h
rename to drivers/video/fbdev/pxa168fb.h
diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
similarity index 100%
rename from drivers/video/pxa3xx-gcu.c
rename to drivers/video/fbdev/pxa3xx-gcu.c
diff --git a/drivers/video/pxa3xx-gcu.h b/drivers/video/fbdev/pxa3xx-gcu.h
similarity index 100%
rename from drivers/video/pxa3xx-gcu.h
rename to drivers/video/fbdev/pxa3xx-gcu.h
diff --git a/drivers/video/pxafb.c b/drivers/video/fbdev/pxafb.c
similarity index 100%
rename from drivers/video/pxafb.c
rename to drivers/video/fbdev/pxafb.c
diff --git a/drivers/video/pxafb.h b/drivers/video/fbdev/pxafb.h
similarity index 100%
rename from drivers/video/pxafb.h
rename to drivers/video/fbdev/pxafb.h
diff --git a/drivers/video/q40fb.c b/drivers/video/fbdev/q40fb.c
similarity index 100%
rename from drivers/video/q40fb.c
rename to drivers/video/fbdev/q40fb.c
diff --git a/drivers/video/riva/Makefile b/drivers/video/fbdev/riva/Makefile
similarity index 100%
rename from drivers/video/riva/Makefile
rename to drivers/video/fbdev/riva/Makefile
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/fbdev/riva/fbdev.c
similarity index 100%
rename from drivers/video/riva/fbdev.c
rename to drivers/video/fbdev/riva/fbdev.c
diff --git a/drivers/video/riva/nv_driver.c b/drivers/video/fbdev/riva/nv_driver.c
similarity index 100%
rename from drivers/video/riva/nv_driver.c
rename to drivers/video/fbdev/riva/nv_driver.c
diff --git a/drivers/video/riva/nv_type.h b/drivers/video/fbdev/riva/nv_type.h
similarity index 100%
rename from drivers/video/riva/nv_type.h
rename to drivers/video/fbdev/riva/nv_type.h
diff --git a/drivers/video/riva/nvreg.h b/drivers/video/fbdev/riva/nvreg.h
similarity index 100%
rename from drivers/video/riva/nvreg.h
rename to drivers/video/fbdev/riva/nvreg.h
diff --git a/drivers/video/riva/riva_hw.c b/drivers/video/fbdev/riva/riva_hw.c
similarity index 100%
rename from drivers/video/riva/riva_hw.c
rename to drivers/video/fbdev/riva/riva_hw.c
diff --git a/drivers/video/riva/riva_hw.h b/drivers/video/fbdev/riva/riva_hw.h
similarity index 100%
rename from drivers/video/riva/riva_hw.h
rename to drivers/video/fbdev/riva/riva_hw.h
diff --git a/drivers/video/riva/riva_tbl.h b/drivers/video/fbdev/riva/riva_tbl.h
similarity index 100%
rename from drivers/video/riva/riva_tbl.h
rename to drivers/video/fbdev/riva/riva_tbl.h
diff --git a/drivers/video/riva/rivafb-i2c.c b/drivers/video/fbdev/riva/rivafb-i2c.c
similarity index 100%
rename from drivers/video/riva/rivafb-i2c.c
rename to drivers/video/fbdev/riva/rivafb-i2c.c
diff --git a/drivers/video/riva/rivafb.h b/drivers/video/fbdev/riva/rivafb.h
similarity index 100%
rename from drivers/video/riva/rivafb.h
rename to drivers/video/fbdev/riva/rivafb.h
diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/fbdev/s1d13xxxfb.c
similarity index 100%
rename from drivers/video/s1d13xxxfb.c
rename to drivers/video/fbdev/s1d13xxxfb.c
diff --git a/drivers/video/s3c-fb.c b/drivers/video/fbdev/s3c-fb.c
similarity index 100%
rename from drivers/video/s3c-fb.c
rename to drivers/video/fbdev/s3c-fb.c
diff --git a/drivers/video/s3c2410fb.c b/drivers/video/fbdev/s3c2410fb.c
similarity index 100%
rename from drivers/video/s3c2410fb.c
rename to drivers/video/fbdev/s3c2410fb.c
diff --git a/drivers/video/s3c2410fb.h b/drivers/video/fbdev/s3c2410fb.h
similarity index 100%
rename from drivers/video/s3c2410fb.h
rename to drivers/video/fbdev/s3c2410fb.h
diff --git a/drivers/video/s3fb.c b/drivers/video/fbdev/s3fb.c
similarity index 100%
rename from drivers/video/s3fb.c
rename to drivers/video/fbdev/s3fb.c
diff --git a/drivers/video/sa1100fb.c b/drivers/video/fbdev/sa1100fb.c
similarity index 100%
rename from drivers/video/sa1100fb.c
rename to drivers/video/fbdev/sa1100fb.c
diff --git a/drivers/video/sa1100fb.h b/drivers/video/fbdev/sa1100fb.h
similarity index 100%
rename from drivers/video/sa1100fb.h
rename to drivers/video/fbdev/sa1100fb.h
diff --git a/drivers/video/savage/Makefile b/drivers/video/fbdev/savage/Makefile
similarity index 100%
rename from drivers/video/savage/Makefile
rename to drivers/video/fbdev/savage/Makefile
diff --git a/drivers/video/savage/savagefb-i2c.c b/drivers/video/fbdev/savage/savagefb-i2c.c
similarity index 100%
rename from drivers/video/savage/savagefb-i2c.c
rename to drivers/video/fbdev/savage/savagefb-i2c.c
diff --git a/drivers/video/savage/savagefb.h b/drivers/video/fbdev/savage/savagefb.h
similarity index 100%
rename from drivers/video/savage/savagefb.h
rename to drivers/video/fbdev/savage/savagefb.h
diff --git a/drivers/video/savage/savagefb_accel.c b/drivers/video/fbdev/savage/savagefb_accel.c
similarity index 100%
rename from drivers/video/savage/savagefb_accel.c
rename to drivers/video/fbdev/savage/savagefb_accel.c
diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/fbdev/savage/savagefb_driver.c
similarity index 100%
rename from drivers/video/savage/savagefb_driver.c
rename to drivers/video/fbdev/savage/savagefb_driver.c
diff --git a/drivers/video/sbuslib.c b/drivers/video/fbdev/sbuslib.c
similarity index 100%
rename from drivers/video/sbuslib.c
rename to drivers/video/fbdev/sbuslib.c
diff --git a/drivers/video/sbuslib.h b/drivers/video/fbdev/sbuslib.h
similarity index 100%
rename from drivers/video/sbuslib.h
rename to drivers/video/fbdev/sbuslib.h
diff --git a/drivers/video/sgivwfb.c b/drivers/video/fbdev/sgivwfb.c
similarity index 100%
rename from drivers/video/sgivwfb.c
rename to drivers/video/fbdev/sgivwfb.c
diff --git a/drivers/video/sh7760fb.c b/drivers/video/fbdev/sh7760fb.c
similarity index 100%
rename from drivers/video/sh7760fb.c
rename to drivers/video/fbdev/sh7760fb.c
diff --git a/drivers/video/sh_mipi_dsi.c b/drivers/video/fbdev/sh_mipi_dsi.c
similarity index 100%
rename from drivers/video/sh_mipi_dsi.c
rename to drivers/video/fbdev/sh_mipi_dsi.c
diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/fbdev/sh_mobile_hdmi.c
similarity index 100%
rename from drivers/video/sh_mobile_hdmi.c
rename to drivers/video/fbdev/sh_mobile_hdmi.c
diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
similarity index 100%
rename from drivers/video/sh_mobile_lcdcfb.c
rename to drivers/video/fbdev/sh_mobile_lcdcfb.c
diff --git a/drivers/video/sh_mobile_lcdcfb.h b/drivers/video/fbdev/sh_mobile_lcdcfb.h
similarity index 100%
rename from drivers/video/sh_mobile_lcdcfb.h
rename to drivers/video/fbdev/sh_mobile_lcdcfb.h
diff --git a/drivers/video/sh_mobile_meram.c b/drivers/video/fbdev/sh_mobile_meram.c
similarity index 100%
rename from drivers/video/sh_mobile_meram.c
rename to drivers/video/fbdev/sh_mobile_meram.c
diff --git a/drivers/video/simplefb.c b/drivers/video/fbdev/simplefb.c
similarity index 100%
rename from drivers/video/simplefb.c
rename to drivers/video/fbdev/simplefb.c
diff --git a/drivers/video/sis/300vtbl.h b/drivers/video/fbdev/sis/300vtbl.h
similarity index 100%
rename from drivers/video/sis/300vtbl.h
rename to drivers/video/fbdev/sis/300vtbl.h
diff --git a/drivers/video/sis/310vtbl.h b/drivers/video/fbdev/sis/310vtbl.h
similarity index 100%
rename from drivers/video/sis/310vtbl.h
rename to drivers/video/fbdev/sis/310vtbl.h
diff --git a/drivers/video/sis/Makefile b/drivers/video/fbdev/sis/Makefile
similarity index 100%
rename from drivers/video/sis/Makefile
rename to drivers/video/fbdev/sis/Makefile
diff --git a/drivers/video/sis/init.c b/drivers/video/fbdev/sis/init.c
similarity index 100%
rename from drivers/video/sis/init.c
rename to drivers/video/fbdev/sis/init.c
diff --git a/drivers/video/sis/init.h b/drivers/video/fbdev/sis/init.h
similarity index 100%
rename from drivers/video/sis/init.h
rename to drivers/video/fbdev/sis/init.h
diff --git a/drivers/video/sis/init301.c b/drivers/video/fbdev/sis/init301.c
similarity index 100%
rename from drivers/video/sis/init301.c
rename to drivers/video/fbdev/sis/init301.c
diff --git a/drivers/video/sis/init301.h b/drivers/video/fbdev/sis/init301.h
similarity index 100%
rename from drivers/video/sis/init301.h
rename to drivers/video/fbdev/sis/init301.h
diff --git a/drivers/video/sis/initdef.h b/drivers/video/fbdev/sis/initdef.h
similarity index 100%
rename from drivers/video/sis/initdef.h
rename to drivers/video/fbdev/sis/initdef.h
diff --git a/drivers/video/sis/initextlfb.c b/drivers/video/fbdev/sis/initextlfb.c
similarity index 100%
rename from drivers/video/sis/initextlfb.c
rename to drivers/video/fbdev/sis/initextlfb.c
diff --git a/drivers/video/sis/oem300.h b/drivers/video/fbdev/sis/oem300.h
similarity index 100%
rename from drivers/video/sis/oem300.h
rename to drivers/video/fbdev/sis/oem300.h
diff --git a/drivers/video/sis/oem310.h b/drivers/video/fbdev/sis/oem310.h
similarity index 100%
rename from drivers/video/sis/oem310.h
rename to drivers/video/fbdev/sis/oem310.h
diff --git a/drivers/video/sis/sis.h b/drivers/video/fbdev/sis/sis.h
similarity index 100%
rename from drivers/video/sis/sis.h
rename to drivers/video/fbdev/sis/sis.h
diff --git a/drivers/video/sis/sis_accel.c b/drivers/video/fbdev/sis/sis_accel.c
similarity index 100%
rename from drivers/video/sis/sis_accel.c
rename to drivers/video/fbdev/sis/sis_accel.c
diff --git a/drivers/video/sis/sis_accel.h b/drivers/video/fbdev/sis/sis_accel.h
similarity index 100%
rename from drivers/video/sis/sis_accel.h
rename to drivers/video/fbdev/sis/sis_accel.h
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
similarity index 100%
rename from drivers/video/sis/sis_main.c
rename to drivers/video/fbdev/sis/sis_main.c
diff --git a/drivers/video/sis/sis_main.h b/drivers/video/fbdev/sis/sis_main.h
similarity index 100%
rename from drivers/video/sis/sis_main.h
rename to drivers/video/fbdev/sis/sis_main.h
diff --git a/drivers/video/sis/vgatypes.h b/drivers/video/fbdev/sis/vgatypes.h
similarity index 100%
rename from drivers/video/sis/vgatypes.h
rename to drivers/video/fbdev/sis/vgatypes.h
diff --git a/drivers/video/sis/vstruct.h b/drivers/video/fbdev/sis/vstruct.h
similarity index 100%
rename from drivers/video/sis/vstruct.h
rename to drivers/video/fbdev/sis/vstruct.h
diff --git a/drivers/video/skeletonfb.c b/drivers/video/fbdev/skeletonfb.c
similarity index 100%
rename from drivers/video/skeletonfb.c
rename to drivers/video/fbdev/skeletonfb.c
diff --git a/drivers/video/sm501fb.c b/drivers/video/fbdev/sm501fb.c
similarity index 100%
rename from drivers/video/sm501fb.c
rename to drivers/video/fbdev/sm501fb.c
diff --git a/drivers/video/smscufx.c b/drivers/video/fbdev/smscufx.c
similarity index 100%
rename from drivers/video/smscufx.c
rename to drivers/video/fbdev/smscufx.c
diff --git a/drivers/video/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
similarity index 100%
rename from drivers/video/ssd1307fb.c
rename to drivers/video/fbdev/ssd1307fb.c
diff --git a/drivers/video/sstfb.c b/drivers/video/fbdev/sstfb.c
similarity index 100%
rename from drivers/video/sstfb.c
rename to drivers/video/fbdev/sstfb.c
diff --git a/drivers/video/sticore.h b/drivers/video/fbdev/sticore.h
similarity index 100%
rename from drivers/video/sticore.h
rename to drivers/video/fbdev/sticore.h
diff --git a/drivers/video/stifb.c b/drivers/video/fbdev/stifb.c
similarity index 100%
rename from drivers/video/stifb.c
rename to drivers/video/fbdev/stifb.c
diff --git a/drivers/video/sunxvr1000.c b/drivers/video/fbdev/sunxvr1000.c
similarity index 100%
rename from drivers/video/sunxvr1000.c
rename to drivers/video/fbdev/sunxvr1000.c
diff --git a/drivers/video/sunxvr2500.c b/drivers/video/fbdev/sunxvr2500.c
similarity index 100%
rename from drivers/video/sunxvr2500.c
rename to drivers/video/fbdev/sunxvr2500.c
diff --git a/drivers/video/sunxvr500.c b/drivers/video/fbdev/sunxvr500.c
similarity index 100%
rename from drivers/video/sunxvr500.c
rename to drivers/video/fbdev/sunxvr500.c
diff --git a/drivers/video/svgalib.c b/drivers/video/fbdev/svgalib.c
similarity index 100%
rename from drivers/video/svgalib.c
rename to drivers/video/fbdev/svgalib.c
diff --git a/drivers/video/syscopyarea.c b/drivers/video/fbdev/syscopyarea.c
similarity index 100%
rename from drivers/video/syscopyarea.c
rename to drivers/video/fbdev/syscopyarea.c
diff --git a/drivers/video/sysfillrect.c b/drivers/video/fbdev/sysfillrect.c
similarity index 100%
rename from drivers/video/sysfillrect.c
rename to drivers/video/fbdev/sysfillrect.c
diff --git a/drivers/video/sysimgblt.c b/drivers/video/fbdev/sysimgblt.c
similarity index 100%
rename from drivers/video/sysimgblt.c
rename to drivers/video/fbdev/sysimgblt.c
diff --git a/drivers/video/tcx.c b/drivers/video/fbdev/tcx.c
similarity index 100%
rename from drivers/video/tcx.c
rename to drivers/video/fbdev/tcx.c
diff --git a/drivers/video/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
similarity index 100%
rename from drivers/video/tdfxfb.c
rename to drivers/video/fbdev/tdfxfb.c
diff --git a/drivers/video/tgafb.c b/drivers/video/fbdev/tgafb.c
similarity index 100%
rename from drivers/video/tgafb.c
rename to drivers/video/fbdev/tgafb.c
diff --git a/drivers/video/tmiofb.c b/drivers/video/fbdev/tmiofb.c
similarity index 100%
rename from drivers/video/tmiofb.c
rename to drivers/video/fbdev/tmiofb.c
diff --git a/drivers/video/tridentfb.c b/drivers/video/fbdev/tridentfb.c
similarity index 100%
rename from drivers/video/tridentfb.c
rename to drivers/video/fbdev/tridentfb.c
diff --git a/drivers/video/udlfb.c b/drivers/video/fbdev/udlfb.c
similarity index 100%
rename from drivers/video/udlfb.c
rename to drivers/video/fbdev/udlfb.c
diff --git a/drivers/video/uvesafb.c b/drivers/video/fbdev/uvesafb.c
similarity index 100%
rename from drivers/video/uvesafb.c
rename to drivers/video/fbdev/uvesafb.c
diff --git a/drivers/video/valkyriefb.c b/drivers/video/fbdev/valkyriefb.c
similarity index 100%
rename from drivers/video/valkyriefb.c
rename to drivers/video/fbdev/valkyriefb.c
diff --git a/drivers/video/valkyriefb.h b/drivers/video/fbdev/valkyriefb.h
similarity index 100%
rename from drivers/video/valkyriefb.h
rename to drivers/video/fbdev/valkyriefb.h
diff --git a/drivers/video/vermilion/Makefile b/drivers/video/fbdev/vermilion/Makefile
similarity index 100%
rename from drivers/video/vermilion/Makefile
rename to drivers/video/fbdev/vermilion/Makefile
diff --git a/drivers/video/vermilion/cr_pll.c b/drivers/video/fbdev/vermilion/cr_pll.c
similarity index 100%
rename from drivers/video/vermilion/cr_pll.c
rename to drivers/video/fbdev/vermilion/cr_pll.c
diff --git a/drivers/video/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
similarity index 100%
rename from drivers/video/vermilion/vermilion.c
rename to drivers/video/fbdev/vermilion/vermilion.c
diff --git a/drivers/video/vermilion/vermilion.h b/drivers/video/fbdev/vermilion/vermilion.h
similarity index 100%
rename from drivers/video/vermilion/vermilion.h
rename to drivers/video/fbdev/vermilion/vermilion.h
diff --git a/drivers/video/vesafb.c b/drivers/video/fbdev/vesafb.c
similarity index 100%
rename from drivers/video/vesafb.c
rename to drivers/video/fbdev/vesafb.c
diff --git a/drivers/video/vfb.c b/drivers/video/fbdev/vfb.c
similarity index 100%
rename from drivers/video/vfb.c
rename to drivers/video/fbdev/vfb.c
diff --git a/drivers/video/vga16fb.c b/drivers/video/fbdev/vga16fb.c
similarity index 100%
rename from drivers/video/vga16fb.c
rename to drivers/video/fbdev/vga16fb.c
diff --git a/drivers/video/via/Makefile b/drivers/video/fbdev/via/Makefile
similarity index 100%
rename from drivers/video/via/Makefile
rename to drivers/video/fbdev/via/Makefile
diff --git a/drivers/video/via/accel.c b/drivers/video/fbdev/via/accel.c
similarity index 100%
rename from drivers/video/via/accel.c
rename to drivers/video/fbdev/via/accel.c
diff --git a/drivers/video/via/accel.h b/drivers/video/fbdev/via/accel.h
similarity index 100%
rename from drivers/video/via/accel.h
rename to drivers/video/fbdev/via/accel.h
diff --git a/drivers/video/via/chip.h b/drivers/video/fbdev/via/chip.h
similarity index 100%
rename from drivers/video/via/chip.h
rename to drivers/video/fbdev/via/chip.h
diff --git a/drivers/video/via/debug.h b/drivers/video/fbdev/via/debug.h
similarity index 100%
rename from drivers/video/via/debug.h
rename to drivers/video/fbdev/via/debug.h
diff --git a/drivers/video/via/dvi.c b/drivers/video/fbdev/via/dvi.c
similarity index 100%
rename from drivers/video/via/dvi.c
rename to drivers/video/fbdev/via/dvi.c
diff --git a/drivers/video/via/dvi.h b/drivers/video/fbdev/via/dvi.h
similarity index 100%
rename from drivers/video/via/dvi.h
rename to drivers/video/fbdev/via/dvi.h
diff --git a/drivers/video/via/global.c b/drivers/video/fbdev/via/global.c
similarity index 100%
rename from drivers/video/via/global.c
rename to drivers/video/fbdev/via/global.c
diff --git a/drivers/video/via/global.h b/drivers/video/fbdev/via/global.h
similarity index 100%
rename from drivers/video/via/global.h
rename to drivers/video/fbdev/via/global.h
diff --git a/drivers/video/via/hw.c b/drivers/video/fbdev/via/hw.c
similarity index 100%
rename from drivers/video/via/hw.c
rename to drivers/video/fbdev/via/hw.c
diff --git a/drivers/video/via/hw.h b/drivers/video/fbdev/via/hw.h
similarity index 100%
rename from drivers/video/via/hw.h
rename to drivers/video/fbdev/via/hw.h
diff --git a/drivers/video/via/ioctl.c b/drivers/video/fbdev/via/ioctl.c
similarity index 100%
rename from drivers/video/via/ioctl.c
rename to drivers/video/fbdev/via/ioctl.c
diff --git a/drivers/video/via/ioctl.h b/drivers/video/fbdev/via/ioctl.h
similarity index 100%
rename from drivers/video/via/ioctl.h
rename to drivers/video/fbdev/via/ioctl.h
diff --git a/drivers/video/via/lcd.c b/drivers/video/fbdev/via/lcd.c
similarity index 100%
rename from drivers/video/via/lcd.c
rename to drivers/video/fbdev/via/lcd.c
diff --git a/drivers/video/via/lcd.h b/drivers/video/fbdev/via/lcd.h
similarity index 100%
rename from drivers/video/via/lcd.h
rename to drivers/video/fbdev/via/lcd.h
diff --git a/drivers/video/via/share.h b/drivers/video/fbdev/via/share.h
similarity index 100%
rename from drivers/video/via/share.h
rename to drivers/video/fbdev/via/share.h
diff --git a/drivers/video/via/tblDPASetting.c b/drivers/video/fbdev/via/tblDPASetting.c
similarity index 100%
rename from drivers/video/via/tblDPASetting.c
rename to drivers/video/fbdev/via/tblDPASetting.c
diff --git a/drivers/video/via/tblDPASetting.h b/drivers/video/fbdev/via/tblDPASetting.h
similarity index 100%
rename from drivers/video/via/tblDPASetting.h
rename to drivers/video/fbdev/via/tblDPASetting.h
diff --git a/drivers/video/via/via-core.c b/drivers/video/fbdev/via/via-core.c
similarity index 100%
rename from drivers/video/via/via-core.c
rename to drivers/video/fbdev/via/via-core.c
diff --git a/drivers/video/via/via-gpio.c b/drivers/video/fbdev/via/via-gpio.c
similarity index 100%
rename from drivers/video/via/via-gpio.c
rename to drivers/video/fbdev/via/via-gpio.c
diff --git a/drivers/video/via/via_aux.c b/drivers/video/fbdev/via/via_aux.c
similarity index 100%
rename from drivers/video/via/via_aux.c
rename to drivers/video/fbdev/via/via_aux.c
diff --git a/drivers/video/via/via_aux.h b/drivers/video/fbdev/via/via_aux.h
similarity index 100%
rename from drivers/video/via/via_aux.h
rename to drivers/video/fbdev/via/via_aux.h
diff --git a/drivers/video/via/via_aux_ch7301.c b/drivers/video/fbdev/via/via_aux_ch7301.c
similarity index 100%
rename from drivers/video/via/via_aux_ch7301.c
rename to drivers/video/fbdev/via/via_aux_ch7301.c
diff --git a/drivers/video/via/via_aux_edid.c b/drivers/video/fbdev/via/via_aux_edid.c
similarity index 100%
rename from drivers/video/via/via_aux_edid.c
rename to drivers/video/fbdev/via/via_aux_edid.c
diff --git a/drivers/video/via/via_aux_sii164.c b/drivers/video/fbdev/via/via_aux_sii164.c
similarity index 100%
rename from drivers/video/via/via_aux_sii164.c
rename to drivers/video/fbdev/via/via_aux_sii164.c
diff --git a/drivers/video/via/via_aux_vt1621.c b/drivers/video/fbdev/via/via_aux_vt1621.c
similarity index 100%
rename from drivers/video/via/via_aux_vt1621.c
rename to drivers/video/fbdev/via/via_aux_vt1621.c
diff --git a/drivers/video/via/via_aux_vt1622.c b/drivers/video/fbdev/via/via_aux_vt1622.c
similarity index 100%
rename from drivers/video/via/via_aux_vt1622.c
rename to drivers/video/fbdev/via/via_aux_vt1622.c
diff --git a/drivers/video/via/via_aux_vt1625.c b/drivers/video/fbdev/via/via_aux_vt1625.c
similarity index 100%
rename from drivers/video/via/via_aux_vt1625.c
rename to drivers/video/fbdev/via/via_aux_vt1625.c
diff --git a/drivers/video/via/via_aux_vt1631.c b/drivers/video/fbdev/via/via_aux_vt1631.c
similarity index 100%
rename from drivers/video/via/via_aux_vt1631.c
rename to drivers/video/fbdev/via/via_aux_vt1631.c
diff --git a/drivers/video/via/via_aux_vt1632.c b/drivers/video/fbdev/via/via_aux_vt1632.c
similarity index 100%
rename from drivers/video/via/via_aux_vt1632.c
rename to drivers/video/fbdev/via/via_aux_vt1632.c
diff --git a/drivers/video/via/via_aux_vt1636.c b/drivers/video/fbdev/via/via_aux_vt1636.c
similarity index 100%
rename from drivers/video/via/via_aux_vt1636.c
rename to drivers/video/fbdev/via/via_aux_vt1636.c
diff --git a/drivers/video/via/via_clock.c b/drivers/video/fbdev/via/via_clock.c
similarity index 100%
rename from drivers/video/via/via_clock.c
rename to drivers/video/fbdev/via/via_clock.c
diff --git a/drivers/video/via/via_clock.h b/drivers/video/fbdev/via/via_clock.h
similarity index 100%
rename from drivers/video/via/via_clock.h
rename to drivers/video/fbdev/via/via_clock.h
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/fbdev/via/via_i2c.c
similarity index 100%
rename from drivers/video/via/via_i2c.c
rename to drivers/video/fbdev/via/via_i2c.c
diff --git a/drivers/video/via/via_modesetting.c b/drivers/video/fbdev/via/via_modesetting.c
similarity index 100%
rename from drivers/video/via/via_modesetting.c
rename to drivers/video/fbdev/via/via_modesetting.c
diff --git a/drivers/video/via/via_modesetting.h b/drivers/video/fbdev/via/via_modesetting.h
similarity index 100%
rename from drivers/video/via/via_modesetting.h
rename to drivers/video/fbdev/via/via_modesetting.h
diff --git a/drivers/video/via/via_utility.c b/drivers/video/fbdev/via/via_utility.c
similarity index 100%
rename from drivers/video/via/via_utility.c
rename to drivers/video/fbdev/via/via_utility.c
diff --git a/drivers/video/via/via_utility.h b/drivers/video/fbdev/via/via_utility.h
similarity index 100%
rename from drivers/video/via/via_utility.h
rename to drivers/video/fbdev/via/via_utility.h
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/fbdev/via/viafbdev.c
similarity index 100%
rename from drivers/video/via/viafbdev.c
rename to drivers/video/fbdev/via/viafbdev.c
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/fbdev/via/viafbdev.h
similarity index 100%
rename from drivers/video/via/viafbdev.h
rename to drivers/video/fbdev/via/viafbdev.h
diff --git a/drivers/video/via/viamode.c b/drivers/video/fbdev/via/viamode.c
similarity index 100%
rename from drivers/video/via/viamode.c
rename to drivers/video/fbdev/via/viamode.c
diff --git a/drivers/video/via/viamode.h b/drivers/video/fbdev/via/viamode.h
similarity index 100%
rename from drivers/video/via/viamode.h
rename to drivers/video/fbdev/via/viamode.h
diff --git a/drivers/video/via/vt1636.c b/drivers/video/fbdev/via/vt1636.c
similarity index 100%
rename from drivers/video/via/vt1636.c
rename to drivers/video/fbdev/via/vt1636.c
diff --git a/drivers/video/via/vt1636.h b/drivers/video/fbdev/via/vt1636.h
similarity index 100%
rename from drivers/video/via/vt1636.h
rename to drivers/video/fbdev/via/vt1636.h
diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
similarity index 100%
rename from drivers/video/vt8500lcdfb.c
rename to drivers/video/fbdev/vt8500lcdfb.c
diff --git a/drivers/video/vt8500lcdfb.h b/drivers/video/fbdev/vt8500lcdfb.h
similarity index 100%
rename from drivers/video/vt8500lcdfb.h
rename to drivers/video/fbdev/vt8500lcdfb.h
diff --git a/drivers/video/vt8623fb.c b/drivers/video/fbdev/vt8623fb.c
similarity index 100%
rename from drivers/video/vt8623fb.c
rename to drivers/video/fbdev/vt8623fb.c
diff --git a/drivers/video/w100fb.c b/drivers/video/fbdev/w100fb.c
similarity index 100%
rename from drivers/video/w100fb.c
rename to drivers/video/fbdev/w100fb.c
diff --git a/drivers/video/w100fb.h b/drivers/video/fbdev/w100fb.h
similarity index 100%
rename from drivers/video/w100fb.h
rename to drivers/video/fbdev/w100fb.h
diff --git a/drivers/video/wm8505fb.c b/drivers/video/fbdev/wm8505fb.c
similarity index 100%
rename from drivers/video/wm8505fb.c
rename to drivers/video/fbdev/wm8505fb.c
diff --git a/drivers/video/wm8505fb_regs.h b/drivers/video/fbdev/wm8505fb_regs.h
similarity index 100%
rename from drivers/video/wm8505fb_regs.h
rename to drivers/video/fbdev/wm8505fb_regs.h
diff --git a/drivers/video/wmt_ge_rops.c b/drivers/video/fbdev/wmt_ge_rops.c
similarity index 100%
rename from drivers/video/wmt_ge_rops.c
rename to drivers/video/fbdev/wmt_ge_rops.c
diff --git a/drivers/video/wmt_ge_rops.h b/drivers/video/fbdev/wmt_ge_rops.h
similarity index 100%
rename from drivers/video/wmt_ge_rops.h
rename to drivers/video/fbdev/wmt_ge_rops.h
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
similarity index 100%
rename from drivers/video/xen-fbfront.c
rename to drivers/video/fbdev/xen-fbfront.c
diff --git a/drivers/video/xilinxfb.c b/drivers/video/fbdev/xilinxfb.c
similarity index 100%
rename from drivers/video/xilinxfb.c
rename to drivers/video/fbdev/xilinxfb.c
diff --git a/drivers/video/omap2/Kconfig b/drivers/video/omap2/Kconfig
deleted file mode 100644
index 63b23f87081d..000000000000
--- a/drivers/video/omap2/Kconfig
+++ /dev/null
@@ -1,10 +0,0 @@
-config OMAP2_VRFB
-	bool
-
-if ARCH_OMAP2PLUS
-
-source "drivers/video/omap2/dss/Kconfig"
-source "drivers/video/omap2/omapfb/Kconfig"
-source "drivers/video/omap2/displays-new/Kconfig"
-
-endif
-- 
1.8.3.2


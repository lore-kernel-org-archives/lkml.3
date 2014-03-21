Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbaCUCTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:19:15 -0400
Received: from ozlabs.org ([203.10.76.45]:34499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965106AbaCUCTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:19:12 -0400
Date: Fri, 21 Mar 2014 13:19:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>
Subject: linux-next: manual merge of the omap_dss2 tree with the pm tree
Message-Id: <20140321131906.9a072677e00a47235b644ab5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Mar_2014_13_19_06_+1100_J6M1.W5Qx/dKg_eX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Mar_2014_13_19_06_+1100_J6M1.W5Qx/dKg_eX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/Makefile between commit f167a64e9d67 ("video / output: Drop
display output class support") from the pm tree and commit 844901baede6
("video: move fbdev to drivers/video/fbdev") from the omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/Makefile
index 08d6a4ab3ace,94fe9c486c60..000000000000
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@@ -16,162 -5,11 +5,8 @@@ obj-$(CONFIG_VT)		  +=3D console
  obj-$(CONFIG_LOGO)		  +=3D logo/
  obj-y				  +=3D backlight/
 =20
- obj-$(CONFIG_EXYNOS_VIDEO)     +=3D exynos/
-=20
- obj-$(CONFIG_FB_CFB_FILLRECT)  +=3D cfbfillrect.o
- obj-$(CONFIG_FB_CFB_COPYAREA)  +=3D cfbcopyarea.o
- obj-$(CONFIG_FB_CFB_IMAGEBLIT) +=3D cfbimgblt.o
- obj-$(CONFIG_FB_SYS_FILLRECT)  +=3D sysfillrect.o
- obj-$(CONFIG_FB_SYS_COPYAREA)  +=3D syscopyarea.o
- obj-$(CONFIG_FB_SYS_IMAGEBLIT) +=3D sysimgblt.o
- obj-$(CONFIG_FB_SYS_FOPS)      +=3D fb_sys_fops.o
- obj-$(CONFIG_FB_SVGALIB)       +=3D svgalib.o
- obj-$(CONFIG_FB_MACMODES)      +=3D macmodes.o
- obj-$(CONFIG_FB_DDC)           +=3D fb_ddc.o
- obj-$(CONFIG_FB_DEFERRED_IO)   +=3D fb_defio.o
- obj-$(CONFIG_FB_WMT_GE_ROPS)   +=3D wmt_ge_rops.o
-=20
- # Hardware specific drivers go first
- obj-$(CONFIG_FB_AMIGA)            +=3D amifb.o c2p_planar.o
- obj-$(CONFIG_FB_ARC)              +=3D arcfb.o
- obj-$(CONFIG_FB_CLPS711X)         +=3D clps711xfb.o
- obj-$(CONFIG_FB_CYBER2000)        +=3D cyber2000fb.o
- obj-$(CONFIG_FB_GRVGA)            +=3D grvga.o
- obj-$(CONFIG_FB_PM2)              +=3D pm2fb.o
- obj-$(CONFIG_FB_PM3)		  +=3D pm3fb.o
-=20
- obj-$(CONFIG_FB_I740)		  +=3D i740fb.o
- obj-$(CONFIG_FB_MATROX)		  +=3D matrox/
- obj-$(CONFIG_FB_RIVA)		  +=3D riva/
- obj-$(CONFIG_FB_NVIDIA)		  +=3D nvidia/
- obj-$(CONFIG_FB_ATY)		  +=3D aty/ macmodes.o
- obj-$(CONFIG_FB_ATY128)		  +=3D aty/ macmodes.o
- obj-$(CONFIG_FB_RADEON)		  +=3D aty/
- obj-$(CONFIG_FB_SIS)		  +=3D sis/
- obj-$(CONFIG_FB_VIA)		  +=3D via/
- obj-$(CONFIG_FB_KYRO)             +=3D kyro/
- obj-$(CONFIG_FB_SAVAGE)		  +=3D savage/
- obj-$(CONFIG_FB_GEODE)		  +=3D geode/
- obj-$(CONFIG_FB_MBX)		  +=3D mbx/
- obj-$(CONFIG_FB_NEOMAGIC)         +=3D neofb.o
- obj-$(CONFIG_FB_3DFX)             +=3D tdfxfb.o
- obj-$(CONFIG_FB_CONTROL)          +=3D controlfb.o
- obj-$(CONFIG_FB_PLATINUM)         +=3D platinumfb.o
- obj-$(CONFIG_FB_VALKYRIE)         +=3D valkyriefb.o
- obj-$(CONFIG_FB_CT65550)          +=3D chipsfb.o
- obj-$(CONFIG_FB_IMSTT)            +=3D imsttfb.o
- obj-$(CONFIG_FB_FM2)              +=3D fm2fb.o
- obj-$(CONFIG_FB_VT8623)           +=3D vt8623fb.o
- obj-$(CONFIG_FB_TRIDENT)          +=3D tridentfb.o
- obj-$(CONFIG_FB_LE80578)          +=3D vermilion/
- obj-$(CONFIG_FB_S3)               +=3D s3fb.o
- obj-$(CONFIG_FB_ARK)              +=3D arkfb.o
- obj-$(CONFIG_FB_STI)              +=3D stifb.o
- obj-$(CONFIG_FB_FFB)              +=3D ffb.o sbuslib.o
- obj-$(CONFIG_FB_CG6)              +=3D cg6.o sbuslib.o
- obj-$(CONFIG_FB_CG3)              +=3D cg3.o sbuslib.o
- obj-$(CONFIG_FB_BW2)              +=3D bw2.o sbuslib.o
- obj-$(CONFIG_FB_CG14)             +=3D cg14.o sbuslib.o
- obj-$(CONFIG_FB_P9100)            +=3D p9100.o sbuslib.o
- obj-$(CONFIG_FB_TCX)              +=3D tcx.o sbuslib.o
- obj-$(CONFIG_FB_LEO)              +=3D leo.o sbuslib.o
- obj-$(CONFIG_FB_SGIVW)            +=3D sgivwfb.o
- obj-$(CONFIG_FB_ACORN)            +=3D acornfb.o
- obj-$(CONFIG_FB_ATARI)            +=3D atafb.o c2p_iplan2.o atafb_mfb.o \
-                                      atafb_iplan2p2.o atafb_iplan2p4.o at=
afb_iplan2p8.o
- obj-$(CONFIG_FB_MAC)              +=3D macfb.o
- obj-$(CONFIG_FB_HECUBA)           +=3D hecubafb.o
- obj-$(CONFIG_FB_N411)             +=3D n411.o
- obj-$(CONFIG_FB_HGA)              +=3D hgafb.o
- obj-$(CONFIG_FB_XVR500)           +=3D sunxvr500.o
- obj-$(CONFIG_FB_XVR2500)          +=3D sunxvr2500.o
- obj-$(CONFIG_FB_XVR1000)          +=3D sunxvr1000.o
- obj-$(CONFIG_FB_IGA)              +=3D igafb.o
- obj-$(CONFIG_FB_APOLLO)           +=3D dnfb.o
- obj-$(CONFIG_FB_Q40)              +=3D q40fb.o
- obj-$(CONFIG_FB_TGA)              +=3D tgafb.o
- obj-$(CONFIG_FB_HP300)            +=3D hpfb.o
- obj-$(CONFIG_FB_G364)             +=3D g364fb.o
- obj-$(CONFIG_FB_EP93XX)		  +=3D ep93xx-fb.o
- obj-$(CONFIG_FB_SA1100)           +=3D sa1100fb.o
- obj-$(CONFIG_FB_HIT)              +=3D hitfb.o
- obj-$(CONFIG_FB_ATMEL)		  +=3D atmel_lcdfb.o
- obj-$(CONFIG_FB_PVR2)             +=3D pvr2fb.o
- obj-$(CONFIG_FB_VOODOO1)          +=3D sstfb.o
- obj-$(CONFIG_FB_ARMCLCD)	  +=3D amba-clcd.o
- obj-$(CONFIG_FB_GOLDFISH)         +=3D goldfishfb.o
- obj-$(CONFIG_FB_68328)            +=3D 68328fb.o
- obj-$(CONFIG_FB_GBE)              +=3D gbefb.o
- obj-$(CONFIG_FB_CIRRUS)		  +=3D cirrusfb.o
- obj-$(CONFIG_FB_ASILIANT)	  +=3D asiliantfb.o
- obj-$(CONFIG_FB_PXA)		  +=3D pxafb.o
- obj-$(CONFIG_FB_PXA168)		  +=3D pxa168fb.o
- obj-$(CONFIG_PXA3XX_GCU)	  +=3D pxa3xx-gcu.o
- obj-$(CONFIG_MMP_DISP)           +=3D mmp/
- obj-$(CONFIG_FB_W100)		  +=3D w100fb.o
- obj-$(CONFIG_FB_TMIO)		  +=3D tmiofb.o
- obj-$(CONFIG_FB_AU1100)		  +=3D au1100fb.o
- obj-$(CONFIG_FB_AU1200)		  +=3D au1200fb.o
- obj-$(CONFIG_FB_VT8500)		  +=3D vt8500lcdfb.o
- obj-$(CONFIG_FB_WM8505)		  +=3D wm8505fb.o
- obj-$(CONFIG_FB_PMAG_AA)	  +=3D pmag-aa-fb.o
- obj-$(CONFIG_FB_PMAG_BA)	  +=3D pmag-ba-fb.o
- obj-$(CONFIG_FB_PMAGB_B)	  +=3D pmagb-b-fb.o
- obj-$(CONFIG_FB_MAXINE)		  +=3D maxinefb.o
- obj-$(CONFIG_FB_METRONOME)        +=3D metronomefb.o
- obj-$(CONFIG_FB_BROADSHEET)       +=3D broadsheetfb.o
- obj-$(CONFIG_FB_AUO_K190X)	  +=3D auo_k190x.o
- obj-$(CONFIG_FB_AUO_K1900)	  +=3D auo_k1900fb.o
- obj-$(CONFIG_FB_AUO_K1901)	  +=3D auo_k1901fb.o
- obj-$(CONFIG_FB_S1D13XXX)	  +=3D s1d13xxxfb.o
- obj-$(CONFIG_FB_SH7760)		  +=3D sh7760fb.o
- obj-$(CONFIG_FB_IMX)              +=3D imxfb.o
- obj-$(CONFIG_FB_S3C)		  +=3D s3c-fb.o
- obj-$(CONFIG_FB_S3C2410)	  +=3D s3c2410fb.o
- obj-$(CONFIG_FB_FSL_DIU)	  +=3D fsl-diu-fb.o
- obj-$(CONFIG_FB_COBALT)           +=3D cobalt_lcdfb.o
- obj-$(CONFIG_FB_IBM_GXT4500)	  +=3D gxt4500.o
- obj-$(CONFIG_FB_PS3)		  +=3D ps3fb.o
- obj-$(CONFIG_FB_SM501)            +=3D sm501fb.o
- obj-$(CONFIG_FB_UDL)		  +=3D udlfb.o
- obj-$(CONFIG_FB_SMSCUFX)	  +=3D smscufx.o
- obj-$(CONFIG_FB_XILINX)           +=3D xilinxfb.o
- obj-$(CONFIG_SH_MIPI_DSI)	  +=3D sh_mipi_dsi.o
- obj-$(CONFIG_FB_SH_MOBILE_HDMI)	  +=3D sh_mobile_hdmi.o
- obj-$(CONFIG_FB_SH_MOBILE_MERAM)  +=3D sh_mobile_meram.o
- obj-$(CONFIG_FB_SH_MOBILE_LCDC)	  +=3D sh_mobile_lcdcfb.o
- obj-$(CONFIG_FB_OMAP)             +=3D omap/
- obj-y                             +=3D omap2/
- obj-$(CONFIG_XEN_FBDEV_FRONTEND)  +=3D xen-fbfront.o
- obj-$(CONFIG_FB_CARMINE)          +=3D carminefb.o
- obj-$(CONFIG_FB_MB862XX)	  +=3D mb862xx/
- obj-$(CONFIG_FB_MSM)              +=3D msm/
- obj-$(CONFIG_FB_NUC900)           +=3D nuc900fb.o
- obj-$(CONFIG_FB_JZ4740)		  +=3D jz4740_fb.o
- obj-$(CONFIG_FB_PUV3_UNIGFX)      +=3D fb-puv3.o
- obj-$(CONFIG_FB_HYPERV)		  +=3D hyperv_fb.o
- obj-$(CONFIG_FB_OPENCORES)	  +=3D ocfb.o
-=20
- # Platform or fallback drivers go here
- obj-$(CONFIG_FB_UVESA)            +=3D uvesafb.o
- obj-$(CONFIG_FB_VESA)             +=3D vesafb.o
- obj-$(CONFIG_FB_EFI)              +=3D efifb.o
- obj-$(CONFIG_FB_VGA16)            +=3D vga16fb.o
- obj-$(CONFIG_FB_OF)               +=3D offb.o
- obj-$(CONFIG_FB_BF537_LQ035)      +=3D bf537-lq035.o
- obj-$(CONFIG_FB_BF54X_LQ043)	  +=3D bf54x-lq043fb.o
- obj-$(CONFIG_FB_BFIN_LQ035Q1)     +=3D bfin-lq035q1-fb.o
- obj-$(CONFIG_FB_BFIN_T350MCQB)	  +=3D bfin-t350mcqb-fb.o
- obj-$(CONFIG_FB_BFIN_7393)        +=3D bfin_adv7393fb.o
- obj-$(CONFIG_FB_MX3)		  +=3D mx3fb.o
- obj-$(CONFIG_FB_DA8XX)		  +=3D da8xx-fb.o
- obj-$(CONFIG_FB_MXS)		  +=3D mxsfb.o
- obj-$(CONFIG_FB_SSD1307)	  +=3D ssd1307fb.o
- obj-$(CONFIG_FB_SIMPLE)           +=3D simplefb.o
-=20
- # the test framebuffer is last
- obj-$(CONFIG_FB_VIRTUAL)          +=3D vfb.o
+ obj-y				  +=3D fbdev/
 =20
 -#video output switch sysfs driver
 -obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) +=3D output.o
 -
  obj-$(CONFIG_VIDEOMODE_HELPERS) +=3D display_timing.o videomode.o
  ifeq ($(CONFIG_OF),y)
  obj-$(CONFIG_VIDEOMODE_HELPERS) +=3D of_display_timing.o of_videomode.o

--Signature=_Fri__21_Mar_2014_13_19_06_+1100_J6M1.W5Qx/dKg_eX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTK6GeAAoJEMDTa8Ir7ZwVqRsP/AmZ65CuEIm1DwnWJVYuGBXF
SUkyAOohRgEspQ3IMAr5rivoOc0YSe8Cn+9VfSMDPZKflOStQO7/VFNrlTwryMBV
pCojQXIYHbk5mEv2DHNyOgGa3OeuVVTgtJ+avddfLsAjI5t2aRS0McQbcaxfk2Wf
Wg5HmKAfFeDNJNdIG1YtLYBEInwIdMJBJFviw1j/5tE+IDsKCEWfzAKbdOlAScLc
d2ORCHtIrvy60Mkjx3k5qWdjk2Slfd5SmPRrPPZ6vQ4jI9Gm26dV+wXG1i1OCovY
vLlWP8Y2L+ypvnzxScEKTVKNN34uWq1Vj8Sj1DiM9llvHFQdh0HZWh/2Hvqfvyej
71oVIYFaJh9kUrlJKuwowO6q+rLflgYS5xPllIlUUFoa6g0Sc9l63x5/F8X+0MHv
YQWjTqNQ4R5erBh6Cdm1JS+0wHak9EEsO0vHYHyQHU9UutbkYOranpDMeuzY7o0H
aWGdluiec2ZZyt+NUL0DDgKVMwiVt+fKHBZQG8rK2YLn3qKq8AtG1eQG8PeJSRGi
x6O8tWcfaXxeg2rBxBtjcR9z8fcftp+DCsf5kuikqDR12MzqeL0vJJ/18c2tZGxA
ztZ1+9DQIM/Yz5XgEOfz6fZSDUrb1GW0K10jqDC9Uw3HX64nOw8QbX1IvxujLtLk
z3je8OydmbaTppSudZrS
=VYW+
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Mar_2014_13_19_06_+1100_J6M1.W5Qx/dKg_eX--

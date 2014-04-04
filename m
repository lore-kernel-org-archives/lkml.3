Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaDDJ75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:59:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49044 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaDDJ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:59:54 -0400
Message-ID: <533E8295.3080203@ti.com>
Date: Fri, 4 Apr 2014 12:59:49 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-fbdev <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] main fbdev changes for 3.15
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="XfHaaQavnnaexNwB26kmtn5w5sDvHfVlK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XfHaaQavnnaexNwB26kmtn5w5sDvHfVlK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the main fbdev changes for 3.15.

 Tomi

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9=
ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-main-3.15

for you to fetch changes up to 13ba0ad4490c3dd08b15c430a7a01c6fb45d5bce:

  fbdev: Make the switch from generic to native driver less alarming (201=
4-04-03 12:47:16 +0300)

----------------------------------------------------------------
fbdev changes for 3.15 (main part)

Various fbdev fixes and improvements, but nothing big.

----------------------------------------------------------------
Adam Jackson (1):
      fbdev: Make the switch from generic to native driver less alarming

Alexander Shiyan (6):
      video: imxfb: Use regulator API with LCD class for powering
      video: imxfb: Remove dead declaration of set_imx_fb_info()
      video: imxfb: Remove unused fields from platform data structure
      video: imxfb: Use module_platform_driver()
      video: imxfb: Resolve mismatch between backlight/contrast
      video: imxfb: Convert to SIMPLE_DEV_PM_OPS

Antoine T=E9nart (1):
      video: atmel_lcdfb: ensure the hardware is initialized with the cor=
rect mode

Bo Shen (1):
      Video: atmel: avoid the id of fix screen info is overwritten

Dan Carpenter (1):
      sisfb: fix 1280x720 resolution support

Daniel Mack (4):
      video: pxa3xx-gcu: rename some symbols
      video: pxa3xx-gcu: pass around struct device *
      video: pxa3xx-gcu: provide an empty .open call
      video: pxa3xx-gcu: switch to devres functions

David Herrmann (2):
      fbdev: efifb: add dev->remove() callback
      fbdev: vesafb: add dev->remove() callback

Denis Carikli (1):
      video: imxfb: Add DT default contrast control register property.

Geert Uytterhoeven (1):
      fbdev: FB_OPENCORES should depend on HAS_DMA

Keith Packard (1):
      fbcon: Clean up fbcon data in fb_info on FB_EVENT_FB_UNBIND with 0 =
fbs

Manish Badarkhe (1):
      video: da8xx-fb: Use "SIMPLE_DEV_PM_OPS" macro

Michal Simek (1):
      video: xilinxfb: Move xilinxfb_platform_data directly to the driver=


Mikulas Patocka (10):
      matroxfb: set FBINFO_READS_FAST
      matroxfb: restore the registers M_ACCESS and M_PITCH
      framebuffer: fix cfb_copyarea
      atyfb: remove resolution limit 1600
      mach64: use unaligned access
      atyfb: set FBINFO_READS_FAST
      mach64: fix cursor when character width is not a multiple of 8 pixe=
ls
      tgafb: fix mode setting with fbset
      tgafb: fix data copying
      tgafb: avoid restriction on modes with line length not a multiple o=
f 64

Sachin Kamat (2):
      video: exynos: Remove OF dependency for Exynos DP
      video: s6e8ax0: Use devm_* APIs

Tomi Valkeinen (3):
      OMAPDSS: use DISPC register to detect context loss
      OMAPDSS: Remove unused get_context_loss_count support
      OMAPDSS: convert pixel clock to common videomode style

Wang YanQing (2):
      video: fbdev: uvesafb: Remove redundant NULL check in uvesafb_remov=
e
      video: fbdev: uvesafb: Remove impossible code path in uvesafb_init_=
info

 .../devicetree/bindings/video/fsl,imx-fb.txt       |   4 +
 arch/arm/mach-imx/mach-mx27ads.c                   |  55 ++-
 arch/arm/mach-omap2/display.c                      |   1 -
 drivers/gpu/drm/omapdrm/omap_connector.c           |   6 +-
 drivers/video/Kconfig                              |   2 +-
 drivers/video/atmel_lcdfb.c                        |   8 +-
 drivers/video/aty/atyfb_base.c                     |   7 +-
 drivers/video/aty/mach64_accel.c                   |   3 +-
 drivers/video/aty/mach64_cursor.c                  |  22 +-
 drivers/video/cfbcopyarea.c                        | 153 +++++----
 drivers/video/console/fbcon.c                      |  27 +-
 drivers/video/da8xx-fb.c                           |  22 +-
 drivers/video/efifb.c                              |  13 +-
 drivers/video/exynos/Kconfig                       |   2 +-
 drivers/video/exynos/s6e8ax0.c                     |  13 +-
 drivers/video/fbmem.c                              |   3 +-
 drivers/video/imxfb.c                              | 380 +++++++++------=
------
 drivers/video/matrox/matroxfb_accel.c              |  38 ++-
 drivers/video/matrox/matroxfb_base.c               |   3 +-
 drivers/video/matrox/matroxfb_base.h               |   2 +
 .../video/omap2/displays-new/connector-analog-tv.c |   2 +-
 drivers/video/omap2/displays-new/connector-dvi.c   |   2 +-
 drivers/video/omap2/displays-new/connector-hdmi.c  |   2 +-
 drivers/video/omap2/displays-new/panel-dsi-cm.c    |   2 +-
 .../omap2/displays-new/panel-lgphilips-lb035q02.c  |   2 +-
 .../omap2/displays-new/panel-nec-nl8048hl11.c      |   4 +-
 .../omap2/displays-new/panel-sharp-ls037v7dw01.c   |   2 +-
 .../omap2/displays-new/panel-sony-acx565akm.c      |   2 +-
 .../omap2/displays-new/panel-tpo-td028ttec1.c      |   2 +-
 .../omap2/displays-new/panel-tpo-td043mtea1.c      |   2 +-
 drivers/video/omap2/dss/dispc.c                    |  32 +-
 drivers/video/omap2/dss/display-sysfs.c            |   4 +-
 drivers/video/omap2/dss/display.c                  |   4 +-
 drivers/video/omap2/dss/dpi.c                      |  25 +-
 drivers/video/omap2/dss/dsi.c                      |  16 +-
 drivers/video/omap2/dss/dss.c                      |  16 -
 drivers/video/omap2/dss/dss.h                      |   2 -
 drivers/video/omap2/dss/hdmi4.c                    |   9 +-
 drivers/video/omap2/dss/hdmi_common.c              |  74 ++--
 drivers/video/omap2/dss/sdi.c                      |  15 +-
 drivers/video/omap2/dss/venc.c                     |   4 +-
 drivers/video/omap2/dss/venc_panel.c               |   2 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   8 +-
 drivers/video/pxa3xx-gcu.c                         | 191 +++++------
 drivers/video/sis/init.c                           |   1 +
 drivers/video/tgafb.c                              | 288 ++++-----------=
-
 drivers/video/uvesafb.c                            |  15 +-
 drivers/video/vesafb.c                             |  13 +-
 drivers/video/xilinxfb.c                           |  15 +-
 include/linux/platform_data/video-imxfb.h          |  12 -
 include/linux/xilinxfb.h                           |  30 --
 include/video/omapdss.h                            |   5 +-
 52 files changed, 695 insertions(+), 872 deletions(-)
 delete mode 100644 include/linux/xilinxfb.h


--XfHaaQavnnaexNwB26kmtn5w5sDvHfVlK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTPoKVAAoJEPo9qoy8lh71Os0P/36hV8fnqqW6mKXjevxYu7xY
pZlwof/9V+CDaenJdMPB+medNjBeny9ctt01wpR5ERUoJfCPS6YPYhIT4LKMsFKa
T0nUFbrAIGy93zvyUvjiUR3AgAFcWuEIwB/hWjspjXYD9vnR9HA05OUMM4wq7pAo
QgPwYM3WIPTpfjaPR/aZI6tTHXy4ibit3bXZy2PzktQ5ACTVoD9pgN0atrWx7XBL
QG4W5gJVpjl81r327w69Q9jbhSEEECRCiEcmMvahWx3+f3rv6nuSVMDuEHBJYsQo
p82AP1Oj+DXWoTvbapvMcSNo4aS6SCIuIOmW7sZzPisczbzA0cnSMtp/nYjIymAa
eIaaZO0F8ehEv0Kbq9fVD1VnGZwa+s55mygcXBCC2OceJ9N1yqPnec0AwydyTT+H
aNZXiOPZl4gREUvBHALNqWKrOcdzu2v8rNCgTX7sBPwEEb67emLJpYO59juJlffw
icnvHtB2DBDczwt6y4IwplaWjtc3IIYsKJCzo1XNUoEdy45BtjzNtTFaYzlY2ARv
Mp9UGcbQEq/bgmYiYb5vp3hl9LZWGlieJmu0wJgNZ5OMrTAbVpOK7NwOmMCf/yff
2r7ThduEpSDqb/X9ZVuVcS3uVZwId5umuFk2ZOSVS+Q9frOPmYvH3fq+EiJmX3sA
kJdu5pBR9Bm1whNc2oHT
=pBaF
-----END PGP SIGNATURE-----

--XfHaaQavnnaexNwB26kmtn5w5sDvHfVlK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3D2LOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:14:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41605 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab3D2LOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:14:30 -0400
Message-ID: <517E5613.5020403@ti.com>
Date: Mon, 29 Apr 2013 14:14:27 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] fbdev changes for 3.10
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig781EACB3A432CD150EFE1299"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig781EACB3A432CD150EFE1299
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f=
0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git tags/fbdev-for-3.10

for you to fetch changes up to 9bf9d47a29afbf7a43eae74a988a4aefe88ccbfd:

  Merge branch '3.10/fb-mmap' into for-next (2013-04-26 09:14:47 +0300)

----------------------------------------------------------------

fbdev for 3.10

* use vm_iomap_memory() in various fb drivers to map the fb memory to use=
rspace
* Cleanups for the videomode and display_timing features
* Updates to vt8500, wm8505 and auo-k190x fb drivers

----------------------------------------------------------------
Arnd Bergmann (2):
      video/exynos: remove unnecessary header inclusions
      video/s3c: move platform_data out of arch/arm

Fabio Porcedda (1):
      drivers: video: use module_platform_driver_probe()

Heiko St=FCbner (9):
      AUO-K190x: Use correct line length
      AUO-K190x: add runtime-pm calls to controller init functions
      AUO-K190x: set the correct runtime-pm state in recover
      AUO-K190x: make memory check in check_var more flexible
      AUO-K190x: move var resolution-handling into check_var
      AUO-K190x: make color handling more flexible
      AUO-K190x: add a 16bit truecolor mode
      AUO-K190x: add framebuffer rotation support
      AUO-K190x: Add resolutions for portrait displays

Julia Lawall (1):
      drivers/video/wm8505fb.c: use devm_ functions

Paul Bolle (1):
      ARM: OMAP: remove "config FB_OMAP_CONSISTENT_DMA_SIZE"

Sachin Kamat (1):
      video: wm8505fb: Convert to devm_ioremap_resource()

Timur Tabi (1):
      drivers/video: fsl-diu-fb: add hardware cursor support

Tomi Valkeinen (17):
      videomode: simplify videomode Kconfig and Makefile
      videomode: combine videomode dmt_flags and data_flags
      videomode: create enum for videomode's display flags
      videomode: remove timing_entry_index
      videomode: videomode_from_timing work
      fbdev: Merge fbdev topic branches
      video: vt8500: fix Kconfig for videomode
      fbdev/omapfb: use vm_iomap_memory()
      fbdev/controlfb: use vm_iomap_memory()
      fbdev/fb-puv3: use vm_iomap_memory()
      fbdev/sa1100fb: use vm_iomap_memory()
      fbdev/vermillion: use vm_iomap_memory()
      fbdev/sgivwfb: use vm_iomap_memory()
      fbdev/ps3fb: use vm_iomap_memory()
      fbdev: improve fb_mmap bounds checks
      fbdev: fix check for fb_mmap's mmio availability
      Merge branch '3.10/fb-mmap' into for-next

Tony Prisk (5):
      video: vt8500: Make wmt_ge_rops optional
      video: vt8500: Remove unused platform_data/video-vt8500lcdfb.h
      video: vt8500: Correct descriptions in video/Kconfig
      video: vt8500: Adjust contrast in wm8505 framebuffer driver.
      video: fb: vt8500: Convert framebuffer drivers to standardized bind=
ing

 .../devicetree/bindings/video/via,vt8500-fb.txt    |   48 +---
 .../devicetree/bindings/video/wm,wm8505-fb.txt     |   32 ++-
 arch/arm/boot/dts/vt8500-bv07.dts                  |   34 ++-
 arch/arm/boot/dts/vt8500.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8505-ref.dts                   |   34 ++-
 arch/arm/boot/dts/wm8505.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8650-mid.dts                   |   36 ++-
 arch/arm/boot/dts/wm8650.dtsi                      |    4 +-
 arch/arm/boot/dts/wm8850-w70v2.dts                 |   40 ++--
 arch/arm/boot/dts/wm8850.dtsi                      |    4 +-
 arch/arm/plat-samsung/include/plat/fb.h            |   50 +----
 drivers/gpu/drm/drm_modes.c                        |   20 +-
 drivers/gpu/drm/tilcdc/Kconfig                     |    3 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |    2 +-
 drivers/video/Kconfig                              |   57 ++---
 drivers/video/Makefile                             |    8 +-
 drivers/video/amifb.c                              |   14 +-
 drivers/video/atmel_lcdfb.c                        |   13 +-
 drivers/video/auo_k1900fb.c                        |   11 +-
 drivers/video/auo_k1901fb.c                        |   11 +-
 drivers/video/auo_k190x.c                          |  235 ++++++++++++++=
++----
 drivers/video/controlfb.c                          |   50 ++---
 drivers/video/exynos/exynos_mipi_dsi.c             |    2 -
 drivers/video/exynos/exynos_mipi_dsi_common.c      |    2 -
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c    |    2 -
 drivers/video/fb-puv3.c                            |   14 +-
 drivers/video/fbmem.c                              |    5 +
 drivers/video/fbmon.c                              |   16 +-
 drivers/video/fsl-diu-fb.c                         |  157 ++++++++++++-
 drivers/video/gbefb.c                              |    4 +-
 drivers/video/of_display_timing.c                  |   19 +-
 drivers/video/of_videomode.c                       |    2 +-
 drivers/video/omap/Kconfig                         |   11 -
 drivers/video/omap2/omapfb/omapfb-main.c           |   30 +--
 drivers/video/omap2/vrfb.c                         |   13 +-
 drivers/video/ps3fb.c                              |   18 +-
 drivers/video/s3c-fb.c                             |    3 +-
 drivers/video/sa1100fb.c                           |   16 +-
 drivers/video/sgivwfb.c                            |   20 +-
 drivers/video/sh_mipi_dsi.c                        |   12 +-
 drivers/video/sh_mobile_hdmi.c                     |   12 +-
 drivers/video/smscufx.c                            |    6 +-
 drivers/video/udlfb.c                              |    6 +-
 drivers/video/vermilion/vermilion.c                |   14 +-
 drivers/video/vfb.c                                |    7 +-
 drivers/video/videomode.c                          |   36 +--
 drivers/video/vt8500lcdfb.c                        |   55 ++---
 drivers/video/wm8505fb.c                           |  145 ++++--------
 drivers/video/wmt_ge_rops.h                        |   23 ++
 include/linux/platform_data/video-vt8500lcdfb.h    |   31 ---
 include/linux/platform_data/video_s3c.h            |   54 +++++
 include/video/auo_k190xfb.h                        |    3 +-
 include/video/display_timing.h                     |   57 ++---
 include/video/videomode.h                          |   18 +-
 54 files changed, 799 insertions(+), 728 deletions(-)
 delete mode 100644 include/linux/platform_data/video-vt8500lcdfb.h
 create mode 100644 include/linux/platform_data/video_s3c.h


--------------enig781EACB3A432CD150EFE1299
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRflYTAAoJEPo9qoy8lh71Fi8QAJomTKYmczmDcJwTwAXENjbV
Pmoit/SP6QDK0FyorL3nMO317k9L8izt12VTI+dAq6gu+wJddEaetWZWhofNpMY+
+16y1vHBpIuDbjcHty9gpinr+hwLcH1GppZOtvx5aZhJgqvnvbyHuneEk66bDkQk
RiH69g4ZsZnLJz4mIO0QrL3uqXx9S32xg/3IbJ6oFZPD8NqFFkMYiOTcDL4h1Hh/
RNjHix9q1c5K3sMEWD/sHTxt4opzbFOwjbQVh3QE4TG3FMU4rBSD3CpjIrJEGtvw
XSknFmCt5w8UZqIkq873ZhhvdFyqTuwEUXxQZR7sJmcYC9+s3+dynjOSiQSUJ4fU
MtIYbqGLDz2EYmM8etf1KLrzOhRnBeHW6i/XLT6j0TdsdVY041pBG1tfFxnLnFM5
12pwSxZOe+pZujov1q7V5+pn/6LoPtSqE5eV5ANkVx7h6sH8N66t1ImqJXzTVPB5
saU3CiDlNMENe0fvsapR7Qwrz1av3KxTmEZIwpZJJokO5BBvKaTHwoFxq9ng/22z
4DNvzPYUyLYngYrps7MIVYXJ2PAer1oSZt8v/MbZC8wy+vkXw1HZJlmuo79ZfLjX
RaRpp+z4EbHFMqwtvyGyXe8QdPL1OpIzofOJY7xFFCIB25P7tQ8M+iVEgnZYTDMo
EDtcUjkBG52yvYkmkeDO
=O/Lo
-----END PGP SIGNATURE-----

--------------enig781EACB3A432CD150EFE1299--

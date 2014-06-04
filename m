Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaFDM12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:27:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41849 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaFDM10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:27:26 -0400
Message-ID: <538F10A4.5050708@ti.com>
Date: Wed, 4 Jun 2014 15:27:16 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] main fbdev changes for 3.16
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="TjAnn6wNJdqmI8OipDLCeBQcfjDcbcRlo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TjAnn6wNJdqmI8OipDLCeBQcfjDcbcRlo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the main fbdev changes for 3.16.

 Tomi

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a3962=
3f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-main-3.16

for you to fetch changes up to fbc6c4a13bbfb420eedfdb26a0a859f9c07e8a7b:

  drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap=
 (2014-05-23 13:51:10 +0300)

----------------------------------------------------------------
fbdev changes for 3.16 (main part)

Mainly fixes and small improvements. The biggest change seems to be backl=
ight
control support for mx3fb.

----------------------------------------------------------------
Aaro Koskinen (1):
      video: omap: delete support for early fbmem allocation

Alexander Stein (1):
      video: mx3fb: Add backlight control support

Arnd Bergmann (7):
      video: sh_mobile_lcdcfb depends on meram
      video: clarify I2C dependencies
      video/omap: fix modular build
      video/mbx: fix building debugfs support
      video: export fb_prepare_logo
      video: atmel needs FB_BACKLIGHT
      video/nuc900: allow modular build

Boris BREZILLON (1):
      video: of: display_timing: fix default native-mode setting

Brian W Hart (1):
      fbdev/fb.h: silence warning with -Wsign-compare

Dan Carpenter (1):
      video: mmpfb: cleanup some static checker warnings in probe()

David Ung (1):
      video: Check EDID for HDMI connection

Denis Carikli (1):
      video: mx3fb: Use devm_kzalloc

Fabian Frederick (1):
      fbdev: fbmem: remove positive test on unsigned values

Jean Delvare (3):
      fbdev: Fix tmiofb driver dependencies
      video: exynos: Add a dependency to the menu
      video: Kconfig: Add a dependency to the Goldfish framebuffer driver=


Jingoo Han (1):
      video: pxa3xx-gcu: use devm_ioremap_resource()

Jon Ringle (1):
      video: da8xx-fb: Add support for Densitron 84-0023-001T

Julia Lawall (1):
      video: delete unneeded call to platform_get_drvdata

Lucas Stach (1):
      video: of: display_timing: remove two unsafe error messages

Masami Ichikawa (1):
      fbcon: Fix memory leak in con2fb_release_oldinfo()

Masanari Iida (2):
      video: fbdev: Fix format string mismatch in wm8505fb.c
      video: fbdev: Fix format string mismatch in gbefb.c

Mikulas Patocka (1):
      matroxfb: perform a dummy read of M_STATUS

Richard Weinberger (2):
      video: mmp: Remove references to CPU_MMP3
      video: mmp: Remove references to CPU_PXA988

Rickard Strandqvist (2):
      video: fbdev: grvga.c: Fix for possible null pointer dereference
      video: fbdev: s3fb.c: Fix for possible null pointer dereference

Zhichuang SUN (1):
      drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_=
mmap

 drivers/video/console/fbcon.c              |  1 +
 drivers/video/fbdev/Kconfig                | 11 ++--
 drivers/video/fbdev/bf54x-lq043fb.c        |  2 -
 drivers/video/fbdev/core/fbmem.c           |  7 +--
 drivers/video/fbdev/core/fbmon.c           |  9 +++-
 drivers/video/fbdev/da8xx-fb.c             | 14 +++++
 drivers/video/fbdev/exynos/Kconfig         |  2 +-
 drivers/video/fbdev/fb-puv3.c              |  2 +
 drivers/video/fbdev/gbefb.c                |  2 +-
 drivers/video/fbdev/grvga.c                |  3 +-
 drivers/video/fbdev/matrox/matroxfb_base.h |  2 +-
 drivers/video/fbdev/mbx/Makefile           |  3 +-
 drivers/video/fbdev/mbx/mbxdebugfs.c       |  2 +-
 drivers/video/fbdev/mbx/mbxfb.c            |  2 +
 drivers/video/fbdev/mmp/Kconfig            |  2 +-
 drivers/video/fbdev/mmp/fb/mmpfb.c         |  9 +---
 drivers/video/fbdev/mmp/hw/Kconfig         |  6 +--
 drivers/video/fbdev/mmp/hw/mmp_ctrl.h      | 32 -----------
 drivers/video/fbdev/mx3fb.c                | 85 ++++++++++++++++++++++++=
++++--
 drivers/video/fbdev/omap/Kconfig           |  9 ++++
 drivers/video/fbdev/omap/Makefile          | 23 ++++----
 drivers/video/fbdev/omap/lcdc.c            | 67 +----------------------
 drivers/video/fbdev/omap/omapfb_main.c     |  1 +
 drivers/video/fbdev/pxa3xx-gcu.c           |  6 +--
 drivers/video/fbdev/s3fb.c                 |  3 +-
 drivers/video/fbdev/wm8505fb.c             |  2 +-
 drivers/video/of_display_timing.c          | 10 ++--
 include/linux/fb.h                         |  3 +-
 include/linux/omap-dma.h                   |  2 +-
 29 files changed, 169 insertions(+), 153 deletions(-)


--TjAnn6wNJdqmI8OipDLCeBQcfjDcbcRlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjxCqAAoJEPo9qoy8lh71YksQAILVG7HbSj64fxEkyss/6CDz
H/JJtmr9mWh4cgDKfMxo1/sI+9o6eI+7kWv1RP5aJcp9GkEMu3JlXFIOryajw6uk
2QwPBJ0D83SEctqC1LoMIAiUVaoXTFYm+esnr1lA2ZWU9VGPBMF3eO7WinuTiI8/
sdGVbc9vIkwh0pAGR8fVFRUfcvIpXhjrq1TSBR/iXzma9ThRMt/K6DRePWs10bSP
Fbc3ahlkUWzv7dyKdXV+uSMXCwRJgwhBCnFkNhooXVHfBrkNFn9BETp6Ao2NAb4j
kyAg7NXzjHW9umD12W2fpd1Jr6P+ujtzkEWAy7HfMCaT/2kX4r9tDDs/3X5rbn7E
2tblhdhBTh3IeQEwaZDcfm2zL1rp0AOCgX07BWr+ozOGWz1aYxir4hh8V+8KqvAV
6BNwAnErByapgj0kd2XqUzfDySvZ7vmfZnzfMc0xfDhzQowXPL781hCnZZRSmroc
ihW0E/PP4mNxbwqDyDxZTzGExnIgxNKPEaVPkAW6AsLEDcVJvp5oSVokploU4/b/
RMxTSv2R3LxTi3Vra7b8vW3/qZueSX5wRQuquJ3vhVliXjWgq2il4Akren3tz37W
Ae5t+Gia9vc2BNcJIQ62L+zq6n0t5QOdpZ+/3plQMaI8xWMkQGkugKDBlfaCCq1n
YEK7TeMlGnfjeo5hJ6I7
=C41W
-----END PGP SIGNATURE-----

--TjAnn6wNJdqmI8OipDLCeBQcfjDcbcRlo--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3IEGsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 02:48:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53492 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab3IEGsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 02:48:53 -0400
Message-ID: <5228294E.8050401@ti.com>
Date: Thu, 5 Sep 2013 09:48:46 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] fbdev changes for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="V1XF8LSOtBp6ng7KD1MaW3q2JRFShfLcD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V1XF8LSOtBp6ng7KD1MaW3q2JRFShfLcD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are the fbdev changes for 3.12.

There's a conflict in drivers/video/simplefb.c, which you can resolve by =
using
the version in your tree.

I guess the simplefb changes were taken through Ingo's tree because the s=
eries
includes x86 arch changes, but it would have been nice to see the patches=
 in
the linux-next...

 Tomi

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a=
4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-3.12

for you to fetch changes up to 028cd86b794f4a7f09525587c8e9ab6b03a6fa0f:

  video: da8xx-fb: fix the polarities of the hsync/vsync pulse (2013-08-3=
0 14:51:30 +0300)

----------------------------------------------------------------
fbdev changes for 3.12:

* Improvements to da8xx-fb to make it support v2 of the LCDC IP, used e.g=
=2E in
  BeagleBone
* Himax HX8369 controller support
* Various small fixes and cleanups

----------------------------------------------------------------
Afzal Mohammed (11):
      video: da8xx-fb: fb_check_var enhancement
      video: da8xx-fb: simplify lcd_reset
      video: da8xx-fb: use modedb helper to update var
      video: da8xx-fb: remove unneeded "var" initialization
      video: da8xx-fb: store current display information
      video: da8xx-fb: store clk rate even if !CPUFREQ
      video: da8xx-fb: store struct device *
      video: da8xx-fb: report correct pixclock
      video: da8xx-fb: enable sync lost intr for v2 ip
      video: da8xx-fb: ensure non-null cfg in pdata
      video: da8xx-fb: reorganize panel detection

Alexandre Belloni (1):
      fb: backlight: HX8357: Add HX8369 support

Alexandre Courbot (1):
      simplefb: add support for a8b8g8r8 pixel format

Alexandru Juncu (1):
      matroxfb: replace kmalloc and memset with kzalloc.

Boris BREZILLON (1):
      at91/avr32/atmel_lcdfb: prepare clk before calling enable

Chen Gang (1):
      drivers: video: fbcmap: remove the redundency and incorrect checkin=
gs

Daniel Mack (1):
      fbmem: move EXPORT_SYMBOL annotation next to symbol declarations

Darren Etheridge (13):
      video: da8xx-fb: pix clk and clk div handling cleanup
      video: da8xx-fb: fb_set_par support
      video: da8xx-fb: improve readability of code
      video: da8xx-fb: fix 24bpp raster configuration
      video: da8xx-fb: use devres
      video: da8xx-fb: set upstream clock rate (if reqd)
      video: da8xx-fb: make clock naming consistent
      video: da8xx-fb: let compiler decide what to inline
      video: da8xx-fb: adding am33xx as dependency
      video: da8xx-fb fixing incorrect porch mappings
      video: da8xx-fb: fixing timing off by one errors
      video: da8xx-fb: support lcdc v2 timing register expansion
      video: da8xx-fb: fix the polarities of the hsync/vsync pulse

Fabio Estevam (1):
      video: mxsfb: Let device core handle pinctrl

Greg Kroah-Hartman (1):
      video: output: convert class code to use dev_groups

Julia Lawall (2):
      video: mxsfb: simplify use of devm_ioremap_resource
      video: xilinxfb: replace devm_request_and_ioremap by devm_ioremap_r=
esource

Mark Brown (1):
      video: exynos: Ensure definitions match prototypes

Maxime Ripard (1):
      video: hx8357: Make IM pins optional

Michael Opdenacker (1):
      drivers/video: remove unused parameter in Kconfig

Mythri P K (1):
      OMAPDSS: HDMI: Fix AVI infoframe bug

Peter Jones (1):
      Release efifb's colormap in efifb_destroy()

Shingo Nakao (1):
      backlight: lp855x: set zero brightness at FBBLANK

Tomi Valkeinen (3):
      Merge branch '3.12/da8xx' into 3.12/fbdev
      OMAPDSS: HDMI: Fix possible NULL reference
      OMAPDSS: fix WARN_ON in 'alpha_blending_enabled' sysfs file

 .../bindings/video/simple-framebuffer.txt          |   1 +
 drivers/video/Kconfig                              |  15 +-
 drivers/video/atmel_lcdfb.c                        |   8 +-
 drivers/video/backlight/hx8357.c                   | 269 ++++++++++++--
 drivers/video/backlight/lp855x_bl.c                |   2 +-
 drivers/video/da8xx-fb.c                           | 387 ++++++++++++---=
------
 drivers/video/efifb.c                              |   1 +
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c    |   1 +
 drivers/video/fbcmap.c                             |   7 +-
 drivers/video/fbmem.c                              |  29 +-
 drivers/video/matrox/matroxfb_base.c               |   3 +-
 drivers/video/mxsfb.c                              |  15 +-
 drivers/video/omap2/dss/hdmi.c                     |   5 +-
 drivers/video/omap2/dss/manager-sysfs.c            |   8 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c          |  42 ++-
 drivers/video/output.c                             |  20 +-
 drivers/video/simplefb.c                           |   1 +
 drivers/video/xilinxfb.c                           |   8 +-
 include/video/da8xx-fb.h                           |   5 +
 19 files changed, 542 insertions(+), 285 deletions(-)


--V1XF8LSOtBp6ng7KD1MaW3q2JRFShfLcD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSKClOAAoJEPo9qoy8lh71vt0QAJg9uzLK4ppG11Td/FJA08p8
9hND0gGBDdyWOJe5nNObAUveOGZYIidXnKmGUcGIW7kNmWfKVeVdUGWnD3B8Jv3z
NkHH+ox3+XCBCtH1TWaUY8umHaCnXjHPOW/H6vH3QUBi7Ov8D/cQMQSbu1Vf7xfx
NQtjWOI5Kp8oxE+1CXF6jQRPxBL7dCqmOmHxjETSjk4JazGrXA/5Nc/g8PR0ubnT
tw/GggX0Qe4zKheg1zB3z40kDFlgyMI/3P2VZU8YWG8WD6IhXM5wggx1RrpHfhZi
sDWShThwwr4HmaoUj4ca9APZm5z+5rG6tXp9+O1q/KC2CEndk0iXR7myUfvHIpQp
YWjQrMt6dCebVcMoH367ZOBqks09Bu8Rm0BKX0fkwXtB5/kDdYxnL6uX1WPF0g4H
2FkshPpCM7eGd8HpaCj2VvlZz22J63Gs2U9c1xG073GadVjVw9o1AHDhkA6vjkIg
fJ/rUj9kcAA5RPGLlfvL1n2lRjSvjkuQF7QrLmF5ZCyg18DrU7vn81JCwRXQeJL/
KyYn7m1k8qXUlT3FM7EzfabPvqI9kExgPLVKQFPvjtqhHfSMVb34K2s+cTfcBIZf
bfRum6sDqgu6Dik+H9w88YCF/6SJR/jwm88Y+Bv4jkXo8HuiRjnA5nL0tlIJm6ad
X5E3/pniQc0JqEi47AJk
=A5U0
-----END PGP SIGNATURE-----

--V1XF8LSOtBp6ng7KD1MaW3q2JRFShfLcD--

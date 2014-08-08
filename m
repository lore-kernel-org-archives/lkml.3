Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbaHHLgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:36:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39931 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbaHHLgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:36:32 -0400
Message-ID: <53E4B63C.5050402@ti.com>
Date: Fri, 8 Aug 2014 14:36:28 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev changes for 3.17
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="1sp2B5OnJ3ihALDSUeIr4pQb2m57BpAvF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1sp2B5OnJ3ihALDSUeIr4pQb2m57BpAvF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the fbdev changes for 3.17.

 Tomi


The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42=
ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git tags/fbde=
v-3.17

for you to fetch changes up to e4e42b8ad24cabf4d6d3c20a63f18dd6b954d9c2:

  OMAPDSS: DSI: fix depopulating dsi peripherals (2014-08-08 14:26:36 +03=
00)

----------------------------------------------------------------
fbdev changes for 3.17

* Much better HDMI infoframe support for OMAP
* Cirrus Logic CLPS711X framebuffer driver
* DT support for PL11x CLCD driver
* Various small fixes

----------------------------------------------------------------
Alexander Shiyan (4):
      video: clps711x: Add new Cirrus Logic CLPS711X framebuffer driver
      video: clps711x: Add bindings documentation for CLPS711X framebuffe=
r
      video: clps711x: Fix driver build for CONFIG_FB=3Dm
      video: clps711x: Fix sparse warnings

Archit Taneja (1):
      fbdev: arm has __raw I/O accessors, use them in fb.h

Dan Carpenter (1):
      video/mbx: indent some if statements

Dexuan Cui (1):
      video: hyperv: hyperv_fb: refresh the VM screen by force on VM pani=
c

Emil Goode (1):
      video: vt8500lcdfb: Remove kfree call since devm_kzalloc() is used

Fabian Frederick (1):
      drivers/video/fbdev/sis/sis_main.c: remove unnecessary test on unsi=
gned value

Himangi Saraogi (2):
      video: msm: Introduce the use of the managed version of kzalloc
      drivers/video/fbdev : dereference without an error test

Jingoo Han (1):
      MAINTAINERS: Update Framebuffer file patterns

Joe Perches (1):
      fbdev: da8xx-fb: Use dma_zalloc_coherent

Michael Welling (1):
      drivers: video: fbdev: atmel_lcdfb.c: Add ability to inverted backl=
ight PWM.

Paul Bolle (1):
      video: 68328fb: remove check for CONFIG_FB_68328_INVERT

Pawel Moll (2):
      video: ARM CLCD: Add DT support
      video: ARM CLCD: Fix DT-related build problems

Rasmus Villemoes (1):
      drivers/video/fbdev/sis: Add missing else

Tomi Valkeinen (17):
      OMAPDSS: DISPC: fix debugfs reg dump
      OMAPDSS: DISPC: reject interlace for lcd out
      OMAPDSS: DISPC: clean up dispc_mgr_timings_ok
      OMAPDSS: HDMI: fix name conflict
      OMAPDSS: Kconfig: select HDMI
      OMAPDSS: HDMI4: use common AVI infoframe support
      OMAPDSS: HDMI5: use common AVI infoframe support
      OMAPDSS: HDMI: remove custom avi infoframe
      OMAPDSS: add hdmi ops to hdmi_ops and omap_dss_driver
      OMAPDSS: add hdmi ops to hdmi-connector and tpd12s015
      OMAPDSS: HDMI: add infoframe and hdmi_dvi_mode fields
      OMAPDSS: HDMI4: add support to set infoframe & HDMI mode
      OMAPDSS: HDMI5: add support to set infoframe & HDMI mode
      OMAPDSS: HDMI: remove the unused code
      drm/omap: Add infoframe & dvi/hdmi mode support
      Merge branch '3.17/hdmi-infoframe' into for-next
      OMAPDSS: DSI: fix depopulating dsi peripherals

Vasily Khoruzhick (1):
      video: fbdev: s3c2410fb: Move to clk_prepare_enable/clk_disable_unp=
repare

 .../devicetree/bindings/video/arm,pl11x.txt        | 109 ++++++
 .../devicetree/bindings/video/atmel,lcdc.txt       |   1 +
 .../bindings/video/cirrus,clps711x-fb.txt          |  47 +++
 MAINTAINERS                                        |  74 ++--
 drivers/gpu/drm/omapdrm/omap_connector.c           |  12 +
 drivers/gpu/drm/omapdrm/omap_drv.h                 |   1 +
 drivers/gpu/drm/omapdrm/omap_encoder.c             |  27 ++
 drivers/video/fbdev/68328fb.c                      |   8 +-
 drivers/video/fbdev/Kconfig                        |  23 +-
 drivers/video/fbdev/Makefile                       |   3 +-
 drivers/video/fbdev/amba-clcd.c                    | 263 ++++++++++++++
 drivers/video/fbdev/atmel_lcdfb.c                  |   3 +-
 drivers/video/fbdev/clps711x-fb.c                  | 397 +++++++++++++++=
++++++
 drivers/video/fbdev/da8xx-fb.c                     |   9 +-
 drivers/video/fbdev/hyperv_fb.c                    |  62 +++-
 drivers/video/fbdev/mbx/mbxfb.c                    |   4 +-
 drivers/video/fbdev/msm/mddi_client_dummy.c        |  19 +-
 .../fbdev/omap2/displays-new/connector-hdmi.c      |  19 +
 .../fbdev/omap2/displays-new/encoder-tpd12s015.c   |  20 ++
 .../omap2/displays-new/panel-sony-acx565akm.c      |   5 +
 drivers/video/fbdev/omap2/dss/Kconfig              |   1 +
 drivers/video/fbdev/omap2/dss/dispc.c              |  22 +-
 drivers/video/fbdev/omap2/dss/dsi.c                |   9 +-
 drivers/video/fbdev/omap2/dss/hdmi.h               | 107 +-----
 drivers/video/fbdev/omap2/dss/hdmi4.c              |  53 ++-
 drivers/video/fbdev/omap2/dss/hdmi4_core.c         | 164 ++-------
 drivers/video/fbdev/omap2/dss/hdmi4_core.h         |   1 +
 drivers/video/fbdev/omap2/dss/hdmi5.c              |  53 ++-
 drivers/video/fbdev/omap2/dss/hdmi5_core.c         | 124 +++----
 drivers/video/fbdev/omap2/dss/hdmi_common.c        | 316 ---------------=
-
 drivers/video/fbdev/s3c2410fb.c                    |  10 +-
 drivers/video/fbdev/sis/init.c                     |   2 +-
 drivers/video/fbdev/sis/sis_main.c                 |   4 -
 drivers/video/fbdev/vt8500lcdfb.c                  |   2 -
 include/linux/fb.h                                 |   2 +-
 include/video/omapdss.h                            |   9 +
 36 files changed, 1194 insertions(+), 791 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/arm,pl11x.txt=

 create mode 100644 Documentation/devicetree/bindings/video/cirrus,clps71=
1x-fb.txt
 create mode 100644 drivers/video/fbdev/clps711x-fb.c


--1sp2B5OnJ3ihALDSUeIr4pQb2m57BpAvF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT5LY8AAoJEPo9qoy8lh71SJEQAJ8Fqe1uPROFyMKR3dw4L0H9
fTjNAnYNnG2bdyYGyXIXYfAJCWEEQJ5vY0au6Pvm6yI1TwQNqPYt8z40Tj4zXOqw
6G+adh+NYmeHwWUDXmmEUxOp+olmc12ogK1h+vVYMlPN7fAHmufeDQQSzkCVuh0/
Hgo7xsOfu5kr2F774I/zjRo8OOjI3vG8p6s5l+Mz1s+hZDnOnpSGUkBGfY+0gsiZ
RuJlsy+QycK0/67hgS3KtJnX+6yZdE59fkdh2GaN7dEiwnK/T46R3CYN8bkqtL6i
nBJbSiYnzOmEUBCg7Ee3YEe0sRBmznlzafaL3X9iW0CJoEoRieaD9qZ/nBg7tK74
ZL+XH9zjXnW9C3/5NKf8LKV4bApXTxy0K5f7GhnYH/j3BHxhQTVCFhLu/Vc+2hoF
cIP2SSVClMb0syn7eJe/aM2Tzm0FLD8bc02rc9/ioozvkE367XxNiRryl3eDEr6O
Vu/uPu00Vs2w0Bv6dG/pAEbpj/g1j4PDC3qj3Qwx0j+/rxrMcnm4hamTzSNhXJCy
5l7RtyJ/AYBQ5ypWKCcs7G7KuWmT4pdJd8P2U1PEiN6j1hTDjLlgxBxYeHyiDbR5
9aC2wQ88Qqssys5Vnv3E2eme/ljE/7ztwssQs7//Ez8RtY5P9GsW0OqRbgpzrx8H
e8zo6sHM2Pccvmq6cfMH
=7Qht
-----END PGP SIGNATURE-----

--1sp2B5OnJ3ihALDSUeIr4pQb2m57BpAvF--

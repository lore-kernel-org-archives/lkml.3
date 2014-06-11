Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaFKGJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 02:09:00 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40033 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaFKGI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 02:08:58 -0400
Date: Wed, 11 Jun 2014 08:05:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.16-rc1
Message-ID: <20140611060556.GA14677@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.16-rc1

for you to fetch changes up to 39fd3f99aba3f7683fc9b62e916e4c886a1cb6b0:

  pwm: fsl-ftm: set pwm_chip can_sleep flag (2014-05-23 09:11:21 +0200)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.16-rc1

The majority of these changes are cleanups and fixes across all drivers.
Redundant error messages are removed and more PWM controllers set the
.can_sleep flag to signal that they can't be used in atomic context.

Support is added for the Broadcom Kona family of SoCs and the Intel LPSS
driver can now probe PCI devices in addition to ACPI devices. Upon shut-
down, the pwm-backlight driver will now power off the backlight. It also
uses the new descriptor-based GPIO API for more concise GPIO handling.

A large chunk of these changes also converts platforms to use the lookup
mechanism rather than relying on the global number space to reference
PWM devices. This is largely in preparation for more unification and
cleanups in future patches. Eventually it will allow the legacy PWM API
to be removed.

----------------------------------------------------------------
Ajay Kumar (1):
      pwm: samsung: do not set manual update bit in pwm_samsung_config

Alan Cox (1):
      pwm: lpss: Add support for PCI devices

Alexandre Belloni (12):
      pwm: add period and polarity to struct pwm_lookup
      ARM: shmobile: armadillo: initialize all struct pwm_lookup members
      pwm: renesas-tpu: remove unused struct tpu_pwm_platform_data
      ARM: OMAP3: Beagle: initialize all the struct pwm_lookup members
      ARM: pxa: hx4700: initialize all the struct pwm_lookup members
      pwm: modify PWM_LOOKUP to initialize all struct pwm_lookup members
      ARM: OMAP3: Beagle: use PWM_LOOKUP to initialize struct pwm_lookup
      ARM: shmobile: armadillo: use PWM_LOOKUP to initialize struct pwm_lookup
      ARM: pxa: hx4700: use PWM_LOOKUP to initialize struct pwm_lookup
      leds: leds-pwm: retrieve configured PWM period
      pwm-backlight: retrieve configured PWM period
      pwm: atmel: set pwm_chip can_sleep flag

Alexandre Courbot (2):
      ARM: SAMSUNG: remove GPIO flags in dev-backlight
      pwm-backlight: switch to gpiod interface

Axel Lin (4):
      pwm: twl: Really disable twl6030 PWMs
      pwm: lp3943: Set pwm_chip can_sleep flag
      pwm: ab8500: Fix wrong value shift for disable/enable PWM
      pwm: fsl-ftm: set pwm_chip can_sleep flag

Beniamino Galvani (1):
      pwm: spear: fix check on pwmchip_add() return value

Jingoo Han (9):
      pwm: ab8500: Remove unnecessary OOM messages
      pwm: i.MX: Remove unnecessary OOM messages
      pwm: pxa: Remove unnecessary OOM messages
      pwm: renesas-tpu: Remove unnecessary OOM messages
      pwm: spear: Remove unnecessary OOM messages
      pwm: tegra: Remove unnecessary OOM messages
      pwm: pwm-tiecap: Remove unnecessary OOM messages
      pwm: tiehrpwm: Remove unnecessary OOM messages
      pwm: vt8500: Remove unnecessary OOM messages

Shawn Guo (1):
      pwm: mxs: set pwm_chip can_sleep flag

Thierry Reding (3):
      pwm: Document signal polarity convention
      pwm-backlight: Disable backlight on shutdown
      pwm: lpss: Fix const qualifier and sparse warnings

Tim Kryger (2):
      Documentation: dt: Add Kona PWM binding
      pwm: kona: Introduce Kona PWM controller support

Wolfram Sang (2):
      pwm: tiehrpwm: don't build PM related functions when not needed
      pwm: tiehrpwm: inline accessor functions

 .../devicetree/bindings/pwm/bcm-kona-pwm.txt       |  21 ++
 Documentation/pwm.txt                              |  10 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   3 +-
 arch/arm/mach-pxa/hx4700.c                         |   3 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |  14 +-
 arch/arm/plat-samsung/dev-backlight.c              |   2 -
 drivers/leds/leds-pwm.c                            |   5 +-
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/core.c                                 |   8 +-
 drivers/pwm/pwm-ab8500.c                           |  13 +-
 drivers/pwm/pwm-atmel.c                            |   1 +
 drivers/pwm/pwm-bcm-kona.c                         | 318 +++++++++++++++++++++
 drivers/pwm/pwm-fsl-ftm.c                          |   1 +
 drivers/pwm/pwm-imx.c                              |   4 +-
 drivers/pwm/pwm-lp3943.c                           |   1 +
 drivers/pwm/pwm-lpss.c                             | 161 +++++++++--
 drivers/pwm/pwm-mxs.c                              |   1 +
 drivers/pwm/pwm-pxa.c                              |   4 +-
 drivers/pwm/pwm-renesas-tpu.c                      |  23 +-
 drivers/pwm/pwm-samsung.c                          |   3 -
 drivers/pwm/pwm-spear.c                            |   6 +-
 drivers/pwm/pwm-tegra.c                            |   4 +-
 drivers/pwm/pwm-tiecap.c                           |   4 +-
 drivers/pwm/pwm-tiehrpwm.c                         |  10 +-
 drivers/pwm/pwm-twl.c                              |   8 -
 drivers/pwm/pwm-vt8500.c                           |   4 +-
 drivers/video/backlight/pwm_bl.c                   |  87 +++---
 include/linux/platform_data/pwm-renesas-tpu.h      |  16 --
 include/linux/pwm.h                                |   6 +-
 include/linux/pwm_backlight.h                      |   5 +-
 31 files changed, 578 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
 create mode 100644 drivers/pwm/pwm-bcm-kona.c
 delete mode 100644 include/linux/platform_data/pwm-renesas-tpu.h

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTl/HEAAoJEN0jrNd/PrOhbP8QAKBnuo59lBr4jlvEg1QWoten
HXa4pRQWBUPV+Kssr5IuUKBKk3KAwog1kubzoi3u+JmGgZrBtOIjyiI7kSxUQI/I
cAxgSdNFSrVaAcfUHAi/e+C274jqV11mfyLzVaTm1tRC8ROkUhy7vSR73N0ybLDU
+I6DOs14ugOKfsEuQsgHyL5JejowTRRaMyBDFfma6jL1Wpc8y2jUzSwyUkaxjapl
x9xEYUN7lJxzkVWeYYaLWEONeQYPBn9NoQc26Ma8HbwH3SAMS/E9cevgcKPxYPNf
Dm+TmpGa1wM0LmqDtsPTCInBLjidpDyYK36EybpDJbOYxxCTe8+EwbnMSXJYJMWw
sO1zkQhnCZ3Z9UIBiKORFQ2F2KlzpzDr69WlQZ5P1qH3QooB8Q3gRnTXuPtIfgTT
M0Pa/MTneInnbwLQQz9PNVLpOMhhHrQxkPYrB0iu2FWzZ90qLCqvj8kVWuh9bqjx
XnBKHEEdFB1gtlUtOq5gWy86i6oA/Zg63uc0uvwFP6EN/KutdldwEIoTtX+xy2jY
jCB8q8w7HenbB0gE+b/bWVJcfzYFebvyCUlaJDbl+uYwX5/nqxjGa2xDNyMz+Ssn
OsrNO6wpCTqjkQ9W1H2qa2shg+UIwh1eJmzcTs+ffOUaHjkA1QnZjuv5gH4NWq+d
NJsZyw/a7xlPfeo26gMe
=5j+N
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--

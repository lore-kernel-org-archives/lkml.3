Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3KPLzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:55:22 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60076 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3KPLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:55:14 -0500
Date: Sat, 16 Nov 2013 12:54:53 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.13-rc1
Message-ID: <20131116115452.GA12315@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.13-rc1

for you to fetch changes up to 1b3f25ce991d528bd0d825b3f14a45904037a382:

  Documentation/pwm: Update supported SoC name for pwm-samsung (2013-11-11 10:23:56 +0100)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.13-rc1

Mostly bug fixes and clean up. There is a new driver, which is actually
moving a custom PWM driver from drivers/misc.

The majority of the patches are enhancements to the device tree support
in the pwm-backlight driver. Backlights can now additionally be powered
using a regulator and enabled using a GPIO in addition to just the PWM
input.

----------------------------------------------------------------
Boris BREZILLON (2):
      pwm: atmel-tcb: add missing clk source config
      pwm: atmel-tcb: fix max time computation for slow clk source

H Hartley Sweeten (1):
      pwm: add ep93xx PWM support

Huayi Li (1):
      pwm_backlight: avoid short blank screen while doing hibernation

Mike Dunn (1):
      pwm-backlight: Allow for non-increasing brightness levels

Sachin Kamat (10):
      pwm: imx: Include linux/of.h header
      pwm: samsung: Include linux/of.h header
      pwm: twl-led: Include linux/of.h header
      pwm: twl: Include linux/of.h header
      pwm: mxs: Remove redundant of_match_ptr
      pwm: lpc32xx: Remove redundant of_match_ptr
      pwm: imx: Remove redundant of_match_ptr
      Documentation/pwm: Fix trivial typos
      pwm: samsung: Fix kernel warning while unexporting a channel
      Documentation/pwm: Update supported SoC name for pwm-samsung

Thierry Reding (14):
      pwm-backlight: Improve readability
      pwm-backlight: Refactor backlight power on/off
      pwm-backlight: Track enable state
      pwm-backlight: Add optional enable GPIO
      ARM: OMAP: Initialize PWM backlight enable_gpio field
      ARM: pxa: Initialize PWM backlight enable_gpio field
      ARM: SAMSUNG: Initialize PWM backlight enable_gpio field
      ARM: shmobile: Initialize PWM backlight enable_gpio field
      unicore32: Initialize PWM backlight enable_gpio field
      pwm-backlight: Use new enable_gpio field
      pwm-backlight: Add power supply support
      pwm-backlight: Fix brightness adjustment
      pwm-backlight: Remove unused variable
      MAINTAINERS: Move PWM subsystem tree to kernel.org

Wolfram Sang (1):
      pwm: don't use devm_pinctrl_get_select_default() in probe

 .../devicetree/bindings/pwm/pwm-samsung.txt        |   2 +-
 .../bindings/video/backlight/pwm-backlight.txt     |   7 +
 Documentation/pwm.txt                              |   4 +-
 MAINTAINERS                                        |   3 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   1 +
 arch/arm/mach-pxa/cm-x300.c                        |   1 +
 arch/arm/mach-pxa/colibri-pxa270-income.c          |   1 +
 arch/arm/mach-pxa/ezx.c                            |   1 +
 arch/arm/mach-pxa/hx4700.c                         |   1 +
 arch/arm/mach-pxa/lpd270.c                         |   1 +
 arch/arm/mach-pxa/magician.c                       |   1 +
 arch/arm/mach-pxa/mainstone.c                      |   1 +
 arch/arm/mach-pxa/mioa701.c                        |   1 +
 arch/arm/mach-pxa/palm27x.c                        |   1 +
 arch/arm/mach-pxa/palmtc.c                         |  35 +--
 arch/arm/mach-pxa/palmte2.c                        |   1 +
 arch/arm/mach-pxa/pcm990-baseboard.c               |   1 +
 arch/arm/mach-pxa/raumfeld.c                       |   1 +
 arch/arm/mach-pxa/tavorevb.c                       |   2 +
 arch/arm/mach-pxa/viper.c                          |   1 +
 arch/arm/mach-pxa/z2.c                             |   2 +
 arch/arm/mach-pxa/zylonite.c                       |   1 +
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   1 +
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   1 +
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   1 +
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   1 +
 arch/arm/mach-s3c64xx/mach-smartq.c                |   1 +
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   1 +
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   1 +
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   1 +
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   1 +
 arch/arm/mach-shmobile/board-armadillo800eva.c     |   1 +
 arch/arm/plat-samsung/dev-backlight.c              |   5 +
 arch/unicore32/kernel/puv3-nb0916.c                |   1 +
 drivers/misc/Kconfig                               |  13 -
 drivers/misc/Makefile                              |   1 -
 drivers/misc/ep93xx_pwm.c                          | 286 ---------------------
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-atmel-tcb.c                        |   4 +-
 drivers/pwm/pwm-ep93xx.c                           | 230 +++++++++++++++++
 drivers/pwm/pwm-imx.c                              |   3 +-
 drivers/pwm/pwm-lpc32xx.c                          |   2 +-
 drivers/pwm/pwm-mxs.c                              |   2 +-
 drivers/pwm/pwm-samsung.c                          |   3 +-
 drivers/pwm/pwm-tiecap.c                           |   6 -
 drivers/pwm/pwm-tiehrpwm.c                         |   6 -
 drivers/pwm/pwm-twl-led.c                          |   1 +
 drivers/pwm/pwm-twl.c                              |   1 +
 drivers/video/backlight/pwm_bl.c                   | 166 +++++++++---
 include/linux/pwm_backlight.h                      |   5 +
 52 files changed, 434 insertions(+), 392 deletions(-)
 delete mode 100644 drivers/misc/ep93xx_pwm.c
 create mode 100644 drivers/pwm/pwm-ep93xx.c

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSh10MAAoJEN0jrNd/PrOhiiYQAKekSWzyfd9RJKdeeqXOPr9R
M6gls327ikovLVfeCOHGdFTef4xHrb9TAH20SBpwiDk2vFF7q08KrJn+VwyB2zwX
xmGYgZKD4x2o4hmBjyxje15bGoOQowedN29qxcxI9JFVFAbhlLhuwawEb0LO1A6S
JcxKJxtMSiupg2lBU9AGlYPc3XDlUIX8uMsodACCsni+yduK8tPwr7L+XokoZIkE
sogQaT+ELnwej/AXfUQ+DZCZpzsEFrC7Uilq3+gQ04TS43kkLmYZZuiTWqFNCyOm
c0QcTptKDpX1ZbUhhP+8bQAuTqjMowLu9VvHaC6LLIDG4sN4veN/+1ZJFhDD9jH9
LHluDzviD31HMWYGCZNRj7RMC1KU4l06OqiMBsTIZ88bOE/VXdaQW0ggDlKqj/OE
N31og/ZHjVgxZiRrDpehOd7Ozavy27p2pFaS4LHS8oI9qecqZ7sV7xhI5POSUHyu
E4m6oL3qV5CVLUbA4Hn9KOv0NeEXghgDllzfE0z37XP05nYWUbHDjG4uRXgqGoFY
ShprW62YF4rGV59O7tSM0NuXosuagi7Zn4hkDdbYbpOnp4qE3x5qctDZ6/DIaKjB
LZN4+p6uw4h8a977dd0sMsYVJS1KksRp0+duaZd90AR/He/gLw2fZr53p880uDEf
dYaO5gB7W9zAzscCj6ga
=NTVe
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3CROWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:22:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3CROWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:22:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for v3.9-rc3
Date: Mon, 18 Mar 2013 14:22:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181422.14942.arnd@arndb.de>
X-Provags-ID: V02:K0:fcQtUipCIPAcCSoLbuCZz6kuVUzGuk9OJJu9hDiNNTV
 n7SphCvFMRorNGZam+zjdF1wOGki1amFxNT3SUnJ9i6/tLLqJr
 15B49udvB0ubVTyORROutHoo6JNxYdqZvadjSPpcc/1BC2HjaH
 Qslp+8t8hyRSHh+/blGZLVMDtMKP/N/7Sz1tBXfRkUm231Gmd8
 PD2uGdNbpK2bPVK4rTsPjuOmOVGp3bw8tKzZ2ekJ+/iPCHynpV
 xR+4mQuaj6t3AOop1zKkNu+eJiplXYZ9r16rBRgi+NoI2lWxn6
 f6ENia4A0aqXfKkA25b9M9jnWFmrHJP7tfxiH95VaeMv/I9gug
 yL+OgEfphmrBUivF5uaU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 27f423fe120df3a7488dd750b4e0508f03c325b6:

  ARM: spear3xx: Use correct pl080 header file (2013-03-12 10:56:32 +0100)

are available in the git repository at:

  git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to b4811bacbc68f6e17d442df88f98afaa9394d4f5:

  ARM: fix CONFIG_VIRT_TO_BUS handling (2013-03-18 13:49:57 +0000)

----------------------------------------------------------------
arm-soc: bug fixes for 3.9-rc3

Things are calming down for arm-soc as well. This set of bug fixes is
dominated in size by the at91 platform bug fixes. Some of them were
meant to go through the framebuffer tree during the merge window, but
since the framebuffer maintainer could not be reached, I offered to
take them here. The other notable at91 change is the addition of pinctrl
definitions to fix the NAND controller.

The rest are mostly simple regression fixes:

* Our removal of VIRT_TO_BUS conflicted with Stephen Rothwell's
  renaming of the Kconfig symbol. You will get a trivial merge conflict
  here, we still want to remove it.
* missing bits for clocks on imx and s5pv210
* missing header inclusions in mmp and shmobile
* typos in s5pv210 camera and vt8500 clock support code

and three trivial fixes for pre-3.8 bugs:

* an old bogus build warning in the joystick driver
* a misleading Kconfig description
* a NULL pointer check on davinci
----------------------------------------------------------------
Please note that the branch is based on the previous fixes tag that got
pulled into v3.9-rc3, since some of the patches were applied before 
the old tag got merged.

----------------------------------------------------------------

Arnd Bergmann (12):
      Merge tag 'davinci-for-v3.9-rc/fixes' of git://git.kernel.org/.../nsekhar/linux-davinci into fixes
      clk: vt8500: Fix "fix device clock divisor calculations"
      [media] s5p-fimc: fix s5pv210 build
      input/joystick: use get_cycles on ARM
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge branch 'v3.9-samsung-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge at91 lcdfb bug fixes into fixes
      Merge branch 'armsoc/fix' of git://github.com/hzhuang1/linux into fixes
      Merge tag 'arm-imx-fixes-for-3.9-rc' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge tag 'renesas-fixes-for-v3.9' of git://git.kernel.org/.../horms/renesas into fixes
      ARM: fix CONFIG_VIRT_TO_BUS handling
      Merge tag 'v3.9-rc3' into fixes


Haojian Zhuang (1):
      ARM: mmp: add platform_device head file in gplugd

Johan Hovold (2):
      atmel_lcdfb: fix 16-bpp modes on older SOCs
      ARM: at91: fix LCD-wiring mode

Ludovic Desroches (2):
      ARM: at91: add gpio suspend/resume support when using pinctrl
      ARM: at91: fix infinite loop in at91_irq_suspend/resume

Matt Porter (1):
      ARM: davinci: edma: fix dmaengine induced null pointer dereference on da830

Padmavathi Venna (1):
      ARM: EXYNOS: Add #dma-cells for generic dma binding support for PL330

Richard Genoud (2):
      ARM: at91: dt: at91sam9x5: correct NAND pins comments
      ARM: at91: dt: at91sam9x5: complete NAND pinctrl

Sascha Hauer (2):
      ARM: i.MX25: Fix DT compilation
      ARM: i.MX35: enable MAX clock

Simon Horman (1):
      ARM: shmobile: marzen: Include mmc/host.h

Stephen Boyd (1):
      ARM: Scorpion is a v7 architecture, not v6

Sylwester Nawrocki (1):
      ARM: S5PV210: Fix PL330 DMA controller clkdev entries

 arch/arm/Kconfig                       | 11 ++++-------
 arch/arm/boot/dts/at91sam9x5.dtsi      | 28 ++++++++++++++++++++++++++--
 arch/arm/boot/dts/exynos4.dtsi         |  9 +++++++++
 arch/arm/boot/dts/exynos5440.dtsi      |  6 ++++++
 arch/arm/mach-at91/include/mach/gpio.h |  8 ++++++++
 arch/arm/mach-at91/irq.c               | 20 ++++++++------------
 arch/arm/mach-at91/pm.c                | 10 ++++++++--
 arch/arm/mach-davinci/dma.c            |  3 +++
 arch/arm/mach-footbridge/Kconfig       |  1 +
 arch/arm/mach-imx/clk-imx35.c          |  1 +
 arch/arm/mach-imx/imx25-dt.c           |  5 +++++
 arch/arm/mach-mmp/gplugd.c             |  1 +
 arch/arm/mach-s5pv210/clock.c          | 36 ++++++++++++++++++------------------
 arch/arm/mach-s5pv210/mach-goni.c      |  2 +-
 arch/arm/mach-shmobile/board-marzen.c  |  1 +
 drivers/clk/clk-vt8500.c               |  2 +-
 drivers/input/joystick/analog.c        |  8 ++------
 drivers/pinctrl/pinctrl-at91.c         | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/video/atmel_lcdfb.c            | 22 +++++++++++++++-------
 include/video/atmel_lcdc.h             |  2 +-
 20 files changed, 179 insertions(+), 58 deletions(-)

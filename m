Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3GZAlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:41:00 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53142 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab3GZAk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:40:57 -0400
Date: Thu, 25 Jul 2013 17:41:00 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.11-rc
Message-ID: <20130726004100.GA5131@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 515c0967205f2e6d0ca1602ce0de65f9aec1d215:

  mfd: max8925: fix dt code for backlight (2013-07-25 16:57:00 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.11-rc

This is a largeish batch of fixes, mostly because I missed -rc2 due to
travel/vacation. So in number these are a bit more than ideal unless
you amortize them over two -rcs.

Quick breakdown:
 - Defconfig updates
   - Making multi_v7_defconfig useful on more hardware to encourage
     single-image usage
   - Davinci and nomadik updates due to new code merged this merge window
 - Fixes for UART on Samsung platforms, both PM and clock-related
 - A handful of warning fixes from defconfig builds, including for
   max8925 backlight and pxamci (both with appropriate acks)
 - Exynos5440 fixes for LPAE configuration, PM
 - ...plus a bunch of other smaller changes all over the place

I expect to switch to regressions-or-severe-bugs-only fixes from here
on out.

----------------------------------------------------------------
Alexander Shiyan (1):
      ARM: i.MX27: Typo fix

Amit Daniel Kachhap (1):
      ARM: SAMSUNG: Add SAMSUNG_PM config option to select pm

Arnd Bergmann (1):
      ARM: pxa: propagate errors from regulator_enable() to pxamci

Fabio Estevam (2):
      ARM: dts: imx51-babbage: Pass a real clock to the codec
      ARM: multi_v7_defconfig: Select USB chipidea driver

Guennadi Liakhovetski (1):
      dmaengine: shdma: fix a build failure on platforms with no DMA support

Kukjin Kim (1):
      ARM: EXYNOS: skip pm support on exynos5440

Laurent Pinchart (1):
      ARM i.MX53: mba53: Fix PWM backlight DT node

Linus Walleij (2):
      ARM: nomadik: update defconfig base
      ARM: nomadik: configure for NO_HZ and HRTIMERS

Liu Ying (1):
      ARM: i.MX6Q: correct emi_sel clock muxing

Markus Pargmann (1):
      ARM: imx27: Fix documentation for SPLL clock

Mike Frysinger (1):
      ARM: footbridge: fix overlapping PCI mappings

Olof Johansson (7):
      Merge tag 'davinci-fixes-for-v3.11-rc2' of git://git.kernel.org/.../nsekhar/linux-davinci into fixes
      Merge tag 'omap-for-v3.11/fixes-against-rc1' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'imx-fixes-3.11' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'nomadik-defconfig-for-arm-soc' of git://git.kernel.org/.../linusw/linux-nomadik into fixes
      ARM: omap5: Only select errata 798181 if SMP
      Merge tag 'samsung-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      mfd: max8925: fix dt code for backlight

Philipp Zabel (2):
      ARM i.MX53: Fix UART pad configuration
      ARM i.MX6Q: Fix IOMUXC GPR1 defines for ENET_CLK_SEL and IPU1/2_MUX

Rob Herring (1):
      ARM: highbank: Only touch common coherency control register fields

Roger Quadros (1):
      ARM: OMAP2+: Provide alias to USB PHY clock

Sachin Kamat (1):
      ARM: EXYNOS: Update CONFIG_ARCH_NR_GPIO for Exynos

Sekhar Nori (2):
      ARM: davinci: make file local variables static
      ARM: davinci: defconfig: enable EDMA driver

Shawn Guo (2):
      ARM: mxs: saif0 is the clock provider to sgtl5000
      ARM: imx: fix vf610 enet module clock selection

Srinivas Kandagatla (2):
      ARM: dts: STi: Fix pinconf setup for STiH416 serial2
      ARM: STi: Set correct ARM ERRATAs.

Subash Patel (1):
      ARM: EXYNOS: change the PHYSMEM_BITS and SECTION_SIZE

Sylwester Nawrocki (1):
      ARM: S3C24XX: Add missing clkdev entries for s3c2440 UART

Thomas Abraham (1):
      ARM: EXYNOS: Enable 64-bit DMA for EXYNOS5440 if LPAE is enabled

Tony Lindgren (3):
      ARM: multi_v7: Enabled omap4430 sdp nfsroot
      ARM: dts: Add missing vmmc2 regulator for twl
      Merge branch 'omap-for-v3.11/dt-fixes' into omap-for-v3.11/fixes

Ulf Hansson (1):
      ARM: nomadik: Update MMC defconfigs

Vincent Stehlé (2):
      ARM: keystone: fix compilation warning
      ARM: zynq: fix compilation warning

Wei Yongjun (1):
      ARM: edma: remove duplicated include from edma.c

Yadwinder Singh Brar (2):
      ARM: SAMSUNG: Save/restore only selected uart's registers
      ARM: EXYNOS: Fix low level debug support

 .../devicetree/bindings/clock/imx27-clock.txt      |   1 +
 arch/arm/Kconfig                                   |   3 +-
 arch/arm/boot/dts/imx28-apx4devkit.dts             |   2 +-
 arch/arm/boot/dts/imx28-evk.dts                    |   2 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |   2 +-
 arch/arm/boot/dts/imx28.dtsi                       |   1 +
 arch/arm/boot/dts/imx51-babbage.dts                |  13 +-
 arch/arm/boot/dts/imx53-mba53.dts                  |   2 +-
 arch/arm/boot/dts/imx53.dtsi                       |  32 ++--
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |  10 +-
 arch/arm/boot/dts/stih416.dtsi                     |   2 +-
 arch/arm/boot/dts/twl4030.dtsi                     |   6 +
 arch/arm/boot/dts/vf610.dtsi                       |   8 +-
 arch/arm/common/edma.c                             |   1 -
 arch/arm/configs/da8xx_omapl_defconfig             |   2 +
 arch/arm/configs/davinci_all_defconfig             |   2 +
 arch/arm/configs/multi_v7_defconfig                |   6 +-
 arch/arm/configs/nhk8815_defconfig                 |   7 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   2 +-
 arch/arm/mach-davinci/dm355.c                      |   2 +-
 arch/arm/mach-davinci/dm365.c                      |   2 +-
 arch/arm/mach-exynos/Kconfig                       |   1 +
 arch/arm/mach-exynos/Makefile                      |   2 +-
 arch/arm/mach-exynos/common.c                      |  26 ----
 arch/arm/mach-exynos/common.h                      |   1 -
 arch/arm/mach-exynos/cpuidle.c                     |   1 +
 arch/arm/mach-exynos/include/mach/memory.h         |   5 +
 arch/arm/mach-exynos/pm.c                          |   6 +
 arch/arm/mach-footbridge/dc21285.c                 |   2 -
 arch/arm/mach-highbank/highbank.c                  |   7 +-
 arch/arm/mach-imx/clk-imx6q.c                      |   5 +-
 arch/arm/mach-imx/clk-vf610.c                      |   2 +
 arch/arm/mach-imx/mx27.h                           |   2 +-
 arch/arm/mach-keystone/keystone.c                  |   2 +-
 arch/arm/mach-omap2/Kconfig                        |   2 +-
 arch/arm/mach-omap2/board-generic.c                |  23 ++-
 arch/arm/mach-pxa/em-x270.c                        |  17 ++-
 arch/arm/mach-pxa/mainstone.c                      |   3 +-
 arch/arm/mach-pxa/pcm990-baseboard.c               |   3 +-
 arch/arm/mach-pxa/poodle.c                         |   4 +-
 arch/arm/mach-pxa/spitz.c                          |   4 +-
 arch/arm/mach-pxa/stargate2.c                      |   3 +-
 arch/arm/mach-s3c24xx/clock-s3c2410.c              | 161 +++++++++++++--------
 arch/arm/mach-s3c24xx/clock-s3c2440.c              |   3 +
 arch/arm/mach-sti/Kconfig                          |   3 +-
 arch/arm/mach-zynq/common.c                        |   2 +-
 arch/arm/plat-samsung/Kconfig                      |   7 +
 arch/arm/plat-samsung/Makefile                     |   2 +-
 arch/arm/plat-samsung/include/plat/clock.h         |   5 +
 arch/arm/plat-samsung/include/plat/pm.h            |   8 +-
 arch/arm/plat-samsung/pm.c                         |  14 +-
 drivers/mmc/host/pxamci.c                          |   2 +-
 drivers/video/backlight/max8925_bl.c               |  41 +++---
 include/dt-bindings/clock/vf610-clock.h            |   4 +-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |  16 +-
 include/linux/platform_data/mmc-pxamci.h           |   2 +-
 include/linux/shdma-base.h                         |   4 +
 57 files changed, 307 insertions(+), 196 deletions(-)

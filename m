Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaAWSr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:47:26 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:41114 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaAWSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:47:15 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/6] ARM: SoC non-critical fixes for 3.14
Date: Thu, 23 Jan 2014 10:36:23 -0800
Message-Id: <1390502188-16896-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1390502188-16896-1-git-send-email-olof@lixom.net>
References: <1390502188-16896-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As usual, we have a batch of fixes that weren't considered significant
enough to warrant going into the later -rcs for previous release, so
they are queued up on this branch.

A handful of these are for various DT fixups for Samsung platforms,
and a handful of other minor things.

There are also a couple of stable-marked patches for mvebu -- they came in
quite late and we decided to keep them deferred until the first -stable
release to get more coverage instead of squeezing them into 3.13.

----------------------------------------------------------------

The following changes since commit 0dc3fd0249a295863900984e02dd4bb89204205b:

  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-nc-for-linus

for you to fetch changes up to 099c2e9ef671519d4c7f9d49782845adc4f54a39:

  Merge tag 'omap-for-v3.14/fixes-not-urgent-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into next/fixes-non-critical

----------------------------------------------------------------

Alexander Shiyan (1):
      ARM: SAMSUNG: Fix switching FIFO in arch_enable_uart_fifo function

Barry Song (1):
      irqchip: sirf: set IRQ_LEVEL status_flags

Doug Anderson (2):
      ARM: dts: Add the missing "\" key in non-US keyboards for exynos5250-snow
      ARM: dts: Fix exynos5250-snow's search key to be L_META

Ezequiel Garcia (4):
      ARM: OMAP2+: Select USB PHY for AM335x SoC
      ARM: OMAP2+: gpmc: Move initialization outside the gpmc_t condition
      ARM: OMAP2+: gpmc: Introduce gpmc_set_legacy()
      ARM: OMAP2+: gpmc: Move legacy GPMC width setting

Gregory CLEMENT (4):
      ARM: mvebu: Add support to get the ID and the revision of a SoC
      ARM: mvebu: Add quirk for i2c for the OpenBlocks AX3-4 board
      i2c: mv64xxx: Fix bus hang on A0 version of the Armada XP SoCs
      i2c: mv64xxx: Document the newly introduced Armada XP A0 compatible

Jean-Jacques Hiblot (1):
      ARM: at91: smc: bug fix in sam9_smc_cs_read()

Josh Cartwright (1):
      ARM: msm: trout: fix uninit var warning

Jyri Sarha (1):
      ARM: OMAP2+: enable AM33xx SOC EVM audio

Kevin Hilman (3):
      Merge branch 'qcom/fixes' into next/fixes-non-critical
      Merge tag 'mvebu-fixes-3.13' of git://git.infradead.org/linux-mvebu into next/fixes-non-critical
      Merge tag 'omap-for-v3.14/fixes-not-urgent-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical

Lee Jones (1):
      ARM: u300: Remove '0x's from U300 DTS file

Nishanth Menon (2):
      Documentation: dt: OMAP: explicitly state SoC compatible strings
      ARM: OMAP2+: board-generic: update SoC compatibility strings

Olof Johansson (4):
      Merge tag 'samsung-fixes' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      Merge tag 'samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      Merge branch 'qcom/fixes' into next/fixes-non-critical
      Merge tag 'u300-for-arm-soc-1' of git://git.kernel.org/.../linusw/linux-stericsson into next/fixes-non-critical

Sachin Kamat (4):
      ARM: dts: Add missing op_mode property to PMIC on Arndale
      ARM: dts: Add missing frequency property to exynos5250
      ARM: dts: Fix a typo in exynos5420-pinctrl.dtsi
      ARM: dts: Update display clock frequency for Origen-4412

Seungwon Jeon (1):
      ARM: dts: add clock provider for mshc node for Exynos4412 SOC

Stefan Weil (1):
      ARM: bcm2835: Fix grammar in help message

Stephen Boyd (1):
      ARM: dts: msm: Fix gpio interrupt and reg length

Tomasz Figa (4):
      ARM: S3C64XX: Correct card detect type for HSMMC1 for MINI6410
      clk: samsung: exynos4: Fix definition of div_mmc_pre4 divider
      ARM: dts: Fix definition of MSHC device tree nodes for exynos4x12
      ARM: dts: Use MSHC controller for eMMC memory for exynos4412-trats2

Tushar Behera (1):
      ARM: dts: Update display clock frequency for Origen-4210

Uwe Kleine-König (1):
      ARM: u300: fix timekeeping when periodic mode is used

Wei Yongjun (1):
      ARM: u300: fix return value check in __u300_init_boardpower()


 .../devicetree/bindings/arm/omap/omap.txt       |  53 +++++++++
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt     |   6 +-
 arch/arm/boot/dts/exynos4210-origen.dts         |   2 +-
 arch/arm/boot/dts/exynos4412-odroidx.dts        |   5 +-
 arch/arm/boot/dts/exynos4412-origen.dts         |   7 +-
 arch/arm/boot/dts/exynos4412-trats2.dts         |  20 +++-
 arch/arm/boot/dts/exynos4412.dtsi               |   7 --
 arch/arm/boot/dts/exynos4x12.dtsi               |  13 ++
 arch/arm/boot/dts/exynos5250-arndale.dts        |   2 +
 arch/arm/boot/dts/exynos5250-snow.dts           |   3 +-
 arch/arm/boot/dts/exynos5250.dtsi               |   2 +
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi       |   2 +-
 arch/arm/boot/dts/qcom-msm8660-surf.dts         |   4 +-
 arch/arm/boot/dts/qcom-msm8960-cdp.dts          |   2 +-
 arch/arm/boot/dts/ste-u300.dts                  |   6 +-
 arch/arm/configs/omap2plus_defconfig            |   3 +
 arch/arm/mach-at91/sam9_smc.c                   |   2 +-
 arch/arm/mach-bcm2835/Kconfig                   |   2 +-
 arch/arm/mach-msm/board-trout.c                 |  12 +-
 arch/arm/mach-mvebu/Makefile                    |   2 +-
 arch/arm/mach-mvebu/armada-370-xp.c             |  32 +++++
 arch/arm/mach-mvebu/mvebu-soc-id.c              | 119 +++++++++++++++++++
 arch/arm/mach-mvebu/mvebu-soc-id.h              |  32 +++++
 arch/arm/mach-omap2/board-generic.c             |   7 ++
 arch/arm/mach-omap2/gpmc-nand.c                 |  50 ++++----
 arch/arm/mach-s3c64xx/mach-mini6410.c           |  10 ++
 arch/arm/mach-u300/regulator.c                  |   4 +-
 arch/arm/mach-u300/timer.c                      |  38 +++---
 arch/arm/plat-samsung/include/plat/uncompress.h |   2 +
 drivers/clk/samsung/clk-exynos4.c               |   3 +-
 drivers/i2c/busses/i2c-mv64xxx.c                |   5 +
 drivers/irqchip/irq-sirfsoc.c                   |   3 +-
 32 files changed, 381 insertions(+), 79 deletions(-)
 create mode 100644 arch/arm/mach-mvebu/mvebu-soc-id.c
 create mode 100644 arch/arm/mach-mvebu/mvebu-soc-id.h

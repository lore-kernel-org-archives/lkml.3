Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3LDF5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:57:02 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55754 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3LDF5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:57:00 -0500
Date: Tue, 3 Dec 2013 21:54:44 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.13-rc
Message-ID: <20131204055444.GA23507@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit a31ab44ef5d07c6707df4a9ad2c8affd2d62ff4b:

  ARM: bcm2835: add missing #xxx-cells to I2C nodes (2013-11-25 21:56:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to a5c6e87a7b224bdbf57875a9da8f340f5a6abc5a:

  arm: dts: socfpga: Change some clocks of gate-clk type to perip-clk (2013-12-03 14:19:53 -0800)

----------------------------------------------------------------
ARM: SoC fixes for 3.13-rc

Another batch of fixes for ARM SoCs for 3.13. The diffstat is large,
mostly because of:

- Another set of fixes to fix regressions caused by moving OMAP from board
  files to DT. Tony thinks this was the last major set of fixes, with
  maybe just a few small patches to follow.
- More fixes for Marvell platforms, most dealing with misdescribed PCIe
  hardware, i.e. incorrect number of busses on some SoCs, etc. The line
  delta adds up due to various ranges moving around when this is fixed.

But there's also:

- Some smaller tweaks to defconfigs to make more boards bootable in my
  test setup for better coverage.
- There are also a few other smaller fixes, a short series for at91, a couple
  of reverts for ux500, etc.

----------------------------------------------------------------
Andi Shyti (1):
      u8500_defconfig: allow creation and mounting of devtmpfs

Arnaud Ebalard (2):
      ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable
      ARM: mvebu: fix second and third PCIe unit of Armada XP mv78260

Balaji T K (2):
      ARM: dts: omap4-panda-common: Fix pin muxing for wl12xx
      ARM: dts: omap4-sdp: Fix pin muxing for wl12xx

Brent Taylor (1):
      ARM: at91: fixed unresolved symbol "at91_pm_set_standby" when built without CONFIG_PM

Daniel Lezcano (1):
      ARM: ux500: u8500_defconfig: add missing cpuidle option

Dinh Nguyen (2):
      arm: socfpga: Enable ARM_TWD for socfpga
      arm: dts: socfpga: Change some clocks of gate-clk type to perip-clk

Enric Balletbo i Serra (7):
      ARM: dts: omap3-igep: Fix bus-width for mmc1
      ARM: dts: omap3-igep: Add support for LBEE1USJYC WiFi connected to SDIO
      ARM: dts: omap3-igep: Update to use the TI AM/DM37x processor
      ARM: dts: AM33XX BASE0033: add pinmux and hdmi node to enable display
      ARM: dts: AM33XX BASE0033: add pinmux and user led support
      ARM: dts: AM33XX BASE0033: add 32KBit EEPROM support
      ARM: dts: AM33XX IGEP0033: add USB support

Florian Vaussard (1):
      ARM: dts: Fix the name of supplies for smsc911x shared by OMAP

Gregory CLEMENT (1):
      ARM: mvebu: use the virtual CPU registers to access coherency registers

Jarkko Nikula (1):
      ARM: dts: omap3-beagle: Add omap-twl4030 audio support

Javier Martinez Canillas (4):
      ARM: OMAP2+: dss-common: change IGEP's DVI DDC i2c bus
      ARM: dts: omap3-igep0020: Add pinmux setup for i2c devices
      ARM: dts: omap3-igep0020: Add pinmuxing for DVI output
      ARM: dts: omap3-igep0020: name twl4030 VPLL2 regulator as vdds_dsi

Joel Fernandes (1):
      ARM: OMAP2+: Disable POSTED mode for errata i103 and i767

Linus Walleij (2):
      Revert "ARM: ux500: Remove AUXDATA relating to SDI (MMC) clock-name bindings"
      Revert "ARM: ux500: Stop passing MMC's platform data for Device Tree boots"

Ludovic Desroches (1):
      ARM: at91: sama5d3: reduce TWI internal clock frequency

Nicolas Ferre (1):
      ARM: at91: add usart3 alias to dtsi

Olof Johansson (9):
      Merge tag 'ux500-fixes-v3.13-1' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'ux500-defconfig-v3.13-rcs' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'omap-for-v3.13/fixes-against-rc1-take2' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'mvebu-dt-fixes-3.13' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      ARM: multi_v7_defconfig: enable network for BeagleBone Black
      Merge tag 'omap-for-v3.13/more-dt-regressions' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      ARM: sunxi_defconfig: enable NFS, TMPFS, PRINTK_TIME and nfsroot support
      ARM: multi_v7_defconfig: enable SDHCI_BCM_KONA and MMC_BLOCK_MINORS=16

Rajendra Nayak (1):
      ARM: OMAP2+: Powerdomain: Fix unchecked dereference of arch_pwrdm

Roger Quadros (1):
      ARM: dts: omap3-beagle: Fix USB host on beagle boards (for 3.13)

Thomas Petazzoni (1):
      ARM: mvebu: re-enable PCIe on Armada 370 DB

Tony Lindgren (5):
      ARM: OMAP2+: Fix more missing data for omap3.dtsi file
      ARM: OMAP2+: Add fixed regulator to omap2plus_defconfig
      ARM: OMAP2+: Fix eMMC on n900 with device tree
      mmc: omap: Fix DMA configuration to not rely on device id
      mmc: omap: Fix I2C dependency and make driver usable with device tree

 Documentation/devicetree/bindings/mmc/ti-omap.txt |  54 +++++++++++
 arch/arm/boot/dts/am335x-base0033.dts             |  79 ++++++++++++++++
 arch/arm/boot/dts/am335x-igep0033.dtsi            |  29 ++++++
 arch/arm/boot/dts/armada-370-db.dts               |  28 +++---
 arch/arm/boot/dts/armada-370-xp.dtsi              |   2 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi          |  24 ++---
 arch/arm/boot/dts/armada-xp-mv78260.dtsi          | 109 +++++++++++++++++-----
 arch/arm/boot/dts/at91sam9x5_usart3.dtsi          |   4 +
 arch/arm/boot/dts/omap-gpmc-smsc911x.dtsi         |   4 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts             |   7 ++
 arch/arm/boot/dts/omap3-beagle.dts                |  21 +++++
 arch/arm/boot/dts/omap3-igep.dtsi                 |  85 +++++++++++++++--
 arch/arm/boot/dts/omap3-igep0020.dts              |  50 +++++++++-
 arch/arm/boot/dts/omap3-igep0030.dts              |   4 +-
 arch/arm/boot/dts/omap3-n900.dts                  |  23 ++++-
 arch/arm/boot/dts/omap3.dtsi                      |  42 +++++++++
 arch/arm/boot/dts/omap4-panda-common.dtsi         |  20 ++--
 arch/arm/boot/dts/omap4-sdp.dts                   |  12 +--
 arch/arm/boot/dts/socfpga.dtsi                    |   7 +-
 arch/arm/configs/multi_v7_defconfig               |   3 +
 arch/arm/configs/omap2plus_defconfig              |   1 +
 arch/arm/configs/sunxi_defconfig                  |   7 ++
 arch/arm/configs/u8500_defconfig                  |   3 +
 arch/arm/mach-at91/pm.h                           |   4 +
 arch/arm/mach-at91/sama5d3.c                      |   6 +-
 arch/arm/mach-omap2/dss-common.c                  |   2 +-
 arch/arm/mach-omap2/pdata-quirks.c                |   1 +
 arch/arm/mach-omap2/powerdomain.c                 |   3 +-
 arch/arm/mach-socfpga/Kconfig                     |   1 +
 arch/arm/mach-ux500/cpu-db8500.c                  |   4 +
 arch/arm/plat-omap/include/plat/dmtimer.h         |   5 +-
 drivers/mmc/host/omap.c                           |  45 +++++----
 32 files changed, 575 insertions(+), 114 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/ti-omap.txt

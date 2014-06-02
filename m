Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaFBViQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:38:16 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63895 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFBViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:07 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=204/7=5D=20ARM=3A=20SoC=20board=20support=20updates=20for=203=2E16?=
Date: Mon,  2 Jun 2014 14:04:07 -0700
Message-Id: <1401743050-7379-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401743050-7379-1-git-send-email-olof@lixom.net>
References: <1401743050-7379-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bulk of this branch is updates for Renesas Shmobile. They are still
doing some enablement for classic boards first, and then come up with DT
bindings when they've had a chance to learn more about the hardware. Not
necessarily a bad way to go about it, and they're looking at moving some
of the temporary board code resulting from it to drivers/staging instead
to avoid the churn here.

As a result of the shmobile clock cleanups, we end up merging quite a
bit of SH code here as well. We ended up merging it here instead of in
the cleanup branch due to the other board changes depending on it.


Conflicts:

arch/arm/boot/dts/Makefile:
	Keep genmai, delete kxm9d and genmap-reference. (Yes, the same
	target exists for LEGACY and MULTI in this case).

----------------------------------------------------------------

The following changes since commit 41faf937ee7ab1297151ddf2ca0151157fd0405a:

  Merge tag 'soc-for-3.16' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-for-3.16

for you to fetch changes up to 03a2ec647be0394b2b94b7a6a8af2310ad704c72:

  Merge tag 'davinci-for-v3.16/board' of git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci into next/boards

----------------------------------------------------------------

Alexandre Belloni (1):
      ARM: multi_v7_defconfig: Select CONFIG_MACH_BERLIN_BG2Q

Andrew Lunn (2):
      ARM: mvebu_v5_defconfig: Enable sound modules needed for t5325
      ARM: multi_v5_defconfig: Enable sound modules needed for t5325

Antoine Ténart (1):
      ARM: multi_v7_defconfig: select CONFIG_GPIO_DWAPB

Brian Norris (1):
      ARM: mvebu: defconfig: add MTD_SPI_NOR (new dependency for M25P80)

Ezequiel Garcia (2):
      ARM: mvebu: Enable nfsroot in the defconfig
      ARM: mvebu: enable fhandle in the defconfigs

Geert Uytterhoeven (5):
      ARM: shmobile: multiplatform: Enable MSIOF in defconfig
      ARM: shmobile: koelsch-reference: Work around core clock issues
      ARM: shmobile: koelsch legacy: Enable Quad SPI transfers for the SPI FLASH
      ARM: shmobile: lager legacy: Enable Quad SPI transfers for the SPI FLASH
      ARM: shmobile: Add forward declaration of struct clk to silence warning

Gregory CLEMENT (1):
      ARM: configs: enable XHCI mvebu support in multi_v7_defconfig

Kuninori Morimoto (3):
      ARM: shmobile: bockw: remove old style audio clock
      ARM: shmobile: bockw: switch to use dai info for R-Car sound
      ARM: shmobile: lager: switch to use dai info for R-Car sound

Lad, Prabhakar (1):
      ARM: sunxi: drop CONFIG_COMMON_CLK_DEBUG

Laurent Pinchart (69):
      clocksource: sh_cmt: Use request_irq() instead of setup_irq()
      clocksource: sh_cmt: Split channel fields from sh_cmt_priv
      clocksource: sh_cmt: Rename struct sh_cmt_priv to sh_cmt_device
      clocksource: sh_cmt: Split channel setup to separate function
      clocksource: sh_cmt: Constify name argument to sh_cmt_register()
      clocksource: sh_cmt: Rename mapbase/mapbase_str to mapbase_ch/mapbase
      clocksource: sh_cmt: Add memory base to sh_cmt_channel structure
      clocksource: sh_cmt: Add index to struct sh_cmt_channel
      clocksource: sh_cmt: Replace kmalloc + memset with kzalloc
      clocksource: sh_cmt: Allocate channels dynamically
      clocksource: sh_cmt: Split static information from sh_cmt_device
      clocksource: sh_cmt: Replace hardcoded register values with macros
      clocksource: sh_cmt: Set cpumask to cpu_possible_mask
      clocksource: sh_cmt: Hardcode CMT clock event rating to 125
      clocksource: sh_cmt: Hardcode CMT clock source rating to 125
      clocksource: sh_cmt: Add support for multiple channels per device
      clocksource: sh_cmt: Rename clock to "fck" in the non-legacy case
      clocksource: sh_cmt: Remove FSF mail address from GPL notice
      clocksource: sh_cmt: Sort headers alphabetically
      clocksource: sh_cmt: Request IRQ for clock event device only
      clocksource: sh_tmu: Use request_irq() instead of setup_irq()
      clocksource: sh_tmu: Split channel fields from sh_tmu_priv
      clocksource: sh_tmu: Rename struct sh_tmu_priv to sh_tmu_device
      clocksource: sh_tmu: Split channel setup to separate function
      clocksource: sh_tmu: Constify name argument to sh_tmu_register()
      clocksource: sh_tmu: Add memory base to sh_tmu_channel structure
      clocksource: sh_tmu: Add index to struct sh_tmu_channel
      clocksource: sh_tmu: Replace kmalloc + memset with kzalloc
      clocksource: sh_tmu: Allocate channels dynamically
      clocksource: sh_tmu: Replace hardcoded register values with macros
      clocksource: sh_tmu: Hardcode TMU clock event and source ratings to 200
      clocksource: sh_tmu: Add support for multiple channels per device
      clocksource: sh_tmu: Rename clock to "fck" in the non-legacy case
      clocksource: sh_tmu: Remove FSF mail address from GPL notice
      clocksource: sh_tmu: Sort headers alphabetically
      clocksource: sh_mtu2: Use request_irq() instead of setup_irq()
      clocksource: sh_mtu2: Turn sh_mtu2_priv fields into local variables
      clocksource: sh_mtu2: Split channel fields from sh_mtu2_priv
      clocksource: sh_mtu2: Rename struct sh_mtu2_priv to sh_mtu2_device
      clocksource: sh_mtu2: Split channel setup to separate function
      clocksource: sh_mtu2: Constify name argument to sh_mtu2_register()
      clocksource: sh_mtu2: Add memory base to sh_mtu2_channel structure
      clocksource: sh_mtu2: Add index to struct sh_mtu2_channel
      clocksource: sh_mtu2: Replace kmalloc + memset with kzalloc
      clocksource: sh_mtu2: Allocate channels dynamically
      clocksource: sh_mtu2: Replace hardcoded register values with macros
      clocksource: sh_mtu2: Set cpumask to cpu_possible_mask
      clocksource: sh_mtu2: Hardcode MTU2 clock event rating to 200
      clocksource: sh_mtu2: Add support for multiple channels per device
      clocksource: sh_mtu2: Rename clock to "fck" in the non-legacy case
      clocksource: sh_mtu2: Remove FSF mail address from GPL notice
      clocksource: sh_mtu2: Sort headers alphabetically
      sh: Switch to new style CMT device
      ARM: shmobile: sh7372: Switch to new style CMT device
      ARM: shmobile: sh73a0: Switch to new style CMT device
      ARM: shmobile: r8a73a4: Switch to new style CMT device
      ARM: shmobile: r8a7740: Switch to new style CMT device
      ARM: shmobile: r8a7790: Switch to new style CMT device
      ARM: shmobile: r8a7791: Switch to new style CMT device
      sh: Switch to new style TMU device
      ARM: shmobile: sh7372: Switch to new style TMU device
      ARM: shmobile: sh73a0: Switch to new style TMU device
      ARM: shmobile: r8a7740: Switch to new style TMU device
      ARM: shmobile: r8a7778: Switch to new style TMU device
      ARM: shmobile: r8a7779: Switch to new style TMU device
      sh: Switch to new style MTU2 device
      ARM: shmobile: r7s72100: Switch to new style MTU2 device
      ARM: shmobile: lager: Enable SCIF0 and SCIF1 serial ports in DT
      ARM: shmobile: koelsch: Enable SCIF0 and SCIF1 serial ports in DT

Magnus Damm (9):
      ARM: shmobile: Include i2c-shmobile.c in shmobile_defconfig
      ARM: shmobile: Include at24.c in shmobile_defconfig
      ARM: shmobile: Enable HIGHMEM in shmobile_defconfig
      ARM: shmobile: Enable VSP1 in shmobile_defconfig
      ARM: shmobile: Use shmobile_clk_workaround() on Lager
      ARM: shmobile: Use shmobile_clk_workaround() on Koelsch
      ARM: shmobile: Add Lager clock workarounds for SDHI and MMCIF
      ARM: shmobile: Add Koelsch clock workarounds for SDHI
      ARM: shmobile: Minor cleanup of the Armadillo legacy board code

Olof Johansson (14):
      Merge tag 'renesas-defconfig-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'renesas/clock' into next/boards
      Merge tag 'renesas-boards-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'mvebu-defconfig-3.16' of git://git.infradead.org/linux-mvebu into next/boards
      Merge tag 'renesas-boards2-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'depends/clockevents-cleanups' into next/boards
      Merge tag 'renesas-clock-cleanup2-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-dt-scif-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-r7s72100-ccf-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'sunxi-defconfig-for-3.16' of https://github.com/mripard/linux into next/boards
      Merge tag 'tegra-for-3.16-defconfig' of git://git.kernel.org/.../tegra/linux into next/boards
      Merge tag 'renesas-r7s72100-ccf2-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'omap-for-v3.16/board-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge tag 'davinci-for-v3.16/board' of git://git.kernel.org/.../nsekhar/linux-davinci into next/boards

Paul Bolle (6):
      ARM: OMAP: omap3stalker: remove two Kconfig macros
      ARM: OMAP: remove some dead code
      ARM: OMAP: SX1: remove check for CONFIG_SX1_OLD_FLASH
      ARM: OMAP: AM3517EVM: remove check for CONFIG_PANEL_SHARP_LQ043T1DG01
      ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP
      ARM: davinci: remove checks for CONFIG_USB_MUSB_PERIPHERAL

Sebastian Reichel (1):
      ARM: OMAP2+: Add support for RNG on DT booted N900

Simon Horman (7):
      ARM: shmobile: Enable USB [EO]HCI HCD support in shmobile_defconfig
      ARM: shmobile: koelsch: Annotate clk_names with __initconst
      ARM: shmobile: lager: Annotate clk_names with __initconst
      ARM: shmobile: koelsch-reference: Annotate clk_enables as __initconst
      ARM: shmobile: lager-reference: Work around core clock issues
      Merge tag 'renesas-clock-for-v3.16' into cmt-mtu2-tmu-cleanups-for-v3.16
      Merge branch 'clockevents/cmt-mtu2-tmu-cleanups' of git://git.linaro.org/people/daniel.lezcano/linux into cmt-mtu2-tmu-cleanups-for-v3.16

Stefan Agner (1):
      ARM: add drivers for Colibri T30 to multi_v7_defconfig

Stephen Warren (2):
      ARM: multi_v7: enable AT24C EEPROM driver
      ARM: tegra: tegra_defconfig updates

Thomas Petazzoni (3):
      ARM: configs: add CONFIG_MMC_SDHCI_PXAV3 to the mvebu_v7_defconfig
      ARM: configs: add ahci_mvebu to mvebu_v7_defconfig
      ARM: configs: add CONFIG_MMC_SDHCI_PXAV3 to the multi_v7_defconfig

Ulrich Hecht (1):
      ARM: shmobile: Enable USBHS gadget support in shmobile_defconfig

Wolfram Sang (16):
      ARM: shmobile: r7s72100: document MSTP clock support
      ARM: shmobile: r7s72100: add essential clock nodes to dtsi
      ARM: shmobile: r7s72100: genmai: populate nodes for external clocks
      ARM: shmobile: r7s72100: add scif nodes to dtsi
      ARM: shmobile: r7s72100: genmai: add uart alias and activate scif2 as console
      ARM: shmobile: r7s72100: genmai: platform scif devices only for legacy support
      ARM: shmobile: r7s72100: add i2c clocks to dtsi
      ARM: shmobile: r7s72100: remove I2C DT clocks from legacy clock support
      ARM: shmobile: r7s72100: add spi clocks to dtsi
      ARM: shmobile: r7s72100: remove SPI DT clocks from legacy clock support
      ARM: shmobile: r7s72100: use workaround for non DT-clocks
      ARM: shmobile: Remove non-multiplatform Genmai reference support
      ARM: shmobile: genmai-reference: Remove legacy clock support
      ARM: shmobile: Sync Genmai DTS with Genmai reference DTS
      ARM: shmobile: Let Genmai multiplatform boot with Genmai DTB
      ARM: shmobile: Remove Genmai reference DTS


 .../bindings/clock/renesas,cpg-mstp-clocks.txt  |   1 +
 arch/arm/boot/dts/Makefile                      |   3 +-
 arch/arm/boot/dts/r7s72100-genmai-reference.dts |  42 -
 arch/arm/boot/dts/r7s72100-genmai.dts           |  30 +-
 arch/arm/boot/dts/r7s72100.dtsi                 | 215 ++++-
 arch/arm/boot/dts/r8a7790-lager.dts             |  21 +-
 arch/arm/boot/dts/r8a7791-koelsch.dts           |  21 +-
 arch/arm/configs/davinci_all_defconfig          |   1 -
 arch/arm/configs/dove_defconfig                 |   2 +-
 arch/arm/configs/kirkwood_defconfig             |   1 +
 arch/arm/configs/multi_v5_defconfig             |   3 +-
 arch/arm/configs/multi_v7_defconfig             |  11 +
 arch/arm/configs/mvebu_v5_defconfig             |   5 +-
 arch/arm/configs/mvebu_v7_defconfig             |   9 +
 arch/arm/configs/shmobile_defconfig             |  14 +
 arch/arm/configs/sunxi_defconfig                |   1 -
 arch/arm/configs/tegra_defconfig                |  10 +
 arch/arm/mach-davinci/board-dm355-evm.c         |   4 -
 arch/arm/mach-davinci/board-dm355-leopard.c     |   4 -
 arch/arm/mach-omap1/board-h2.c                  |   2 +-
 arch/arm/mach-omap1/board-h3.c                  |   2 +-
 arch/arm/mach-omap1/board-innovator.c           |   2 +-
 arch/arm/mach-omap1/board-osk.c                 |   2 +-
 arch/arm/mach-omap1/board-sx1.c                 |  26 -
 arch/arm/mach-omap1/pm.c                        |  13 +-
 arch/arm/mach-omap2/board-am3517evm.c           |   5 -
 arch/arm/mach-omap2/board-omap3stalker.c        |   4 -
 arch/arm/mach-omap2/pdata-quirks.c              |  12 +
 arch/arm/mach-shmobile/Kconfig                  |  11 -
 arch/arm/mach-shmobile/Makefile                 |   1 -
 arch/arm/mach-shmobile/Makefile.boot            |   1 -
 arch/arm/mach-shmobile/board-armadillo800eva.c  |   7 +-
 arch/arm/mach-shmobile/board-bockw.c            |  63 +-
 arch/arm/mach-shmobile/board-genmai-reference.c |  18 +-
 arch/arm/mach-shmobile/board-genmai.c           |  44 +
 .../arm/mach-shmobile/board-koelsch-reference.c |  71 +-
 arch/arm/mach-shmobile/board-koelsch.c          |   2 +-
 arch/arm/mach-shmobile/board-lager-reference.c  |  69 +-
 arch/arm/mach-shmobile/board-lager.c            |  29 +-
 arch/arm/mach-shmobile/clock-r7s72100.c         |  11 +-
 arch/arm/mach-shmobile/clock-r8a73a4.c          |   2 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |  10 +-
 arch/arm/mach-shmobile/clock-r8a7778.c          |   4 +-
 arch/arm/mach-shmobile/clock-r8a7779.c          |   4 +-
 arch/arm/mach-shmobile/clock-r8a7790.c          |   2 +-
 arch/arm/mach-shmobile/clock-r8a7791.c          |   2 +-
 arch/arm/mach-shmobile/clock-sh7372.c           |   9 +-
 arch/arm/mach-shmobile/clock-sh73a0.c           |   5 +-
 arch/arm/mach-shmobile/include/mach/clock.h     |   1 +
 arch/arm/mach-shmobile/setup-r7s72100.c         |  69 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c          |  17 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          | 133 +--
 arch/arm/mach-shmobile/setup-r8a7778.c          |  28 +-
 arch/arm/mach-shmobile/setup-r8a7779.c          |  66 +-
 arch/arm/mach-shmobile/setup-r8a7790.c          |  25 +-
 arch/arm/mach-shmobile/setup-r8a7791.c          |  25 +-
 arch/arm/mach-shmobile/setup-sh7372.c           |  89 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |  92 +-
 arch/sh/kernel/cpu/clock-cpg.c                  |  10 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c           |  66 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7264.c          |   4 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7269.c          |   4 +-
 arch/sh/kernel/cpu/sh2a/setup-mxg.c             |  98 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c          |  98 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c          | 133 +--
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c          | 164 +---
 arch/sh/kernel/cpu/sh2a/setup-sh7264.c          | 140 +--
 arch/sh/kernel/cpu/sh2a/setup-sh7269.c          | 133 +--
 arch/sh/kernel/cpu/sh3/setup-sh7705.c           |  78 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c           |  78 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c           |  78 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c           | 228 +----
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c          |  78 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c           | 138 +--
 arch/sh/kernel/cpu/sh4/setup-sh7760.c           |  78 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c          |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c          |   2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c          |   6 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c          |  10 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c          |  10 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c          |  12 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c          |   4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c          |   8 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c          |  16 +-
 arch/sh/kernel/cpu/sh4a/clock-shx3.c            |   8 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c          |  96 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c          |  96 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c          |  96 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c          | 172 +---
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c          | 173 +---
 arch/sh/kernel/cpu/sh4a/setup-sh7734.c          | 235 +----
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c          |  48 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c          | 154 +--
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c          | 230 +----
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c          | 154 +--
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c          | 154 +--
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c          | 299 +-----
 arch/sh/kernel/cpu/sh4a/setup-shx3.c            | 150 +--
 arch/sh/kernel/cpu/sh5/setup-sh5.c              |  79 +-
 drivers/clocksource/sh_cmt.c                    | 956 ++++++++++++-------
 drivers/clocksource/sh_mtu2.c                   | 488 +++++++---
 drivers/clocksource/sh_tmu.c                    | 541 +++++++----
 drivers/usb/phy/phy-isp1301-omap.c              |   2 +-
 include/dt-bindings/clock/r7s72100-clock.h      |  41 +
 include/linux/sh_timer.h                        |   1 +
 105 files changed, 2435 insertions(+), 4790 deletions(-)
 delete mode 100644 arch/arm/boot/dts/r7s72100-genmai-reference.dts
 create mode 100644 include/dt-bindings/clock/r7s72100-clock.h

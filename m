Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910Ab3AXFEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:04:41 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:37312 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3AXFEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:04:35 -0500
Date: Wed, 23 Jan 2013 21:04:40 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: arm-soc fixes for 3.8-rc
Message-ID: <20130124050440.GA9151@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 4ad3041d3b76632c02b50aa384a8f21d7d15bac0:

  Merge tag 'imx-fixes-3.8-3' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes (2013-01-23 20:35:02 -0800)

----------------------------------------------------------------

ARM: arm-soc fixes for 3.8

Here's a long-pending fixes pull request for arm-soc (I didn't send one
in the -rc4 cycle).

The largest delta is for a fixup of error paths in the mvsdio
driver. There's also a header file move for a driver that hadn't been
properly converted to multiplatform on i.MX, which was causing build
failures when included.

The rest are the normal mix of small fixes all over the place; sunxi,
omap, imx, mvebu, etc, etc.

----------------------------------------------------------------
Alim Akhtar (1):
      ARM: dts: correct the dw-mshc timing properties as per binding

Andrew Lunn (1):
      mmc: mvsdio: use devm_ API to simplify/correct error paths.

Cong Ding (1):
      clk: mvebu/clk-cpu.c: fix memory leakage

Dimitris Papastamos (1):
      ARM: S3C64XX: Fix up IRQ mapping for balblair on Cragganmore

Fabio Estevam (1):
      video: imxfb: Do not crash on reboot

Gregory CLEMENT (1):
      arm: mvebu: Fix memory size for Armada 370 DB

Gwenhael Goavec-Merou (2):
      ARM: imx: platform-imx-fb: modifies platform device name
      video: imxfb: fix imxfb_info configuration order

Jon Hunter (1):
      ARM: OMAP2: Fix missing omap2xxx_clkt_vps_late_init function calls

Linus Walleij (1):
      ARM: integrator: move syscon remap for AP PCIv3

Luciano Coelho (1):
      ARM: OMAP2+: omap4-panda: add UART2 muxing for WiLink shared transport

Maxime Ripard (1):
      ARM: sunxi: Use the Synosys APB UART instead of ns8250

Olof Johansson (8):
      Merge tag 'mvebu_fixes_for_v3.8-rc3' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'imx-fixes-3.8-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'sunxi-fixes-for-3.8-rc4' of git://github.com/mripard/linux into fixes
      Merge branch 'v3.8-samsung-fixes-3' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'imx-fixes-rc' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge tag 'omap-for-v3.8-rc4/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'mvebu_fixes_for_v3.8-rc5' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'imx-fixes-3.8-3' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes

Pantelis Antoniou (1):
      ARM: OMAP2+: DT node Timer iteration fix

Peter Ujfalusi (2):
      ARM: OMAP4: clock data: Lock ABE DPLL on all revisions
      ARM: OMAP4: hwmod_data: Correct IDLEMODE for McPDM

Rob Clark (1):
      ARM: OMAP2+: fix build break for omapdrm

Sascha Hauer (1):
      [media] coda: Fix build due to iram.h rename

Sebastian Hesselbarth (2):
      ARM: Dove: add Cubox sdhci card detect gpio
      ARM: kirkwood: fix missing #interrupt-cells property

Shawn Guo (3):
      ARM: imx: fix build error with !CONFIG_SMP
      ARM: imx: disable cpu in .cpu_kill hook
      ARM: imx: correct low-power mode setting

Simon Guinot (1):
      ARM: Kirkwood: fix ns2 gpios by converting to pinctrl

Thomas Petazzoni (1):
      arm: mvebu: use global interrupts for GPIOs on Armada XP

Tomasz Figa (1):
      ARM: S3C64XX: Fix build error with CONFIG_S3C_DEV_FB disabled

Tony Lindgren (3):
      arm: mvebu: Fix compile for multiplatform when ARMv6 is selected
      Merge tag 'omap-fixes-b-for-v3.8-rc' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.8-rc4/fixes
      ARM: OMAP2+: Fix section warning for omap_init_ocp2scp()

Uwe Kleine-König (1):
      ARM: compile fix for DEBUG_LL=y && MMU=n

 arch/arm/boot/dts/armada-370-db.dts                |  2 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           | 14 ++--
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           | 21 +++--
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           | 21 +++--
 arch/arm/boot/dts/cros5250-common.dtsi             | 12 +--
 arch/arm/boot/dts/dove-cubox.dts                   | 14 +++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  8 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi         | 16 ++++
 arch/arm/boot/dts/kirkwood.dtsi                    |  2 +
 arch/arm/boot/dts/sunxi.dtsi                       |  6 +-
 arch/arm/kernel/debug.S                            |  2 +
 arch/arm/mach-imx/Kconfig                          |  1 +
 arch/arm/mach-imx/clk-imx6q.c                      |  3 +
 arch/arm/mach-imx/common.h                         |  1 +
 arch/arm/mach-imx/devices/platform-imx-fb.c        |  2 +-
 arch/arm/mach-imx/hotplug.c                        | 10 ++-
 arch/arm/mach-imx/iram_alloc.c                     |  3 +-
 arch/arm/mach-imx/platsmp.c                        |  1 +
 arch/arm/mach-imx/pm-imx6q.c                       |  1 +
 arch/arm/mach-integrator/pci_v3.c                  | 14 +++-
 arch/arm/mach-kirkwood/board-ns2.c                 | 38 ---------
 arch/arm/mach-mvebu/Makefile                       |  2 +
 arch/arm/mach-omap2/board-omap4panda.c             |  6 ++
 arch/arm/mach-omap2/cclock2420_data.c              |  2 +
 arch/arm/mach-omap2/cclock2430_data.c              |  2 +
 arch/arm/mach-omap2/cclock44xx_data.c              | 13 ++-
 arch/arm/mach-omap2/devices.c                      |  2 +-
 arch/arm/mach-omap2/drm.c                          |  3 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  6 +-
 arch/arm/mach-omap2/timer.c                        |  8 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |  2 +-
 arch/arm/mach-s3c64xx/pm.c                         |  2 +
 drivers/clk/mvebu/clk-cpu.c                        |  9 ++-
 drivers/media/platform/coda.c                      |  2 +-
 drivers/mmc/host/mvsdio.c                          | 92 +++++++---------------
 drivers/video/imxfb.c                              | 13 ++-
 .../linux/platform_data/imx-iram.h                 |  0
 37 files changed, 176 insertions(+), 180 deletions(-)
 rename arch/arm/mach-imx/iram.h => include/linux/platform_data/imx-iram.h (100%)

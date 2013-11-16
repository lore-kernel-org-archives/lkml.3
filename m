Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3KPIVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:21:02 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62178 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3KPIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:20:53 -0500
Date: Sat, 16 Nov 2013 00:18:30 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] ARM: SoC fixes for 3.13 merge window
Message-ID: <20131116081830.GA22051@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit 10d0c9705e80bbd3d587c5fad24599aabaca6688:

  Merge tag 'devicetree-for-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2013-11-12 16:52:17 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 6886059f2ef5d62c73e87a905e84fa4f87d56074:

  Merge tag 'omap-for-v3.13/fixes-for-merge-window-take2' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2013-11-15 15:17:59 -0800)

----------------------------------------------------------------

ARM: SoC fixes for 3.13 merge window

A first set of batches of fixes for 3.13. The diffstat is large mostly
because we're adding a defconfig for a family that's been lacking it, and
there's some missing clock information added for i.MX and OMAP.

The at91 new code is around dealing with RTC/RTT reset at boot to fix possible
hangs due to pending wakeup interrupts coming in during early boot.

----------------------------------------------------------------
Alexander Shiyan (1):
      ARM: dts: i.MX51: Fix OTG PHY clock

Alexandre Courbot (1):
      ARM: tegra: init fuse before setting reset handler

Eric Witcher (1):
      ARM: OMAP: devicetree: fix SPI node compatible property syntax items

Jiada Wang (1):
      ARM: i.MX6q: fix the wrong parent of can_root clock

Joel Fernandes (1):
      doc: devicetree: Add bindings documentation for omap-des driver

Johan Hovold (2):
      ARM: at91: fix hanged boot due to early rtc-interrupt
      ARM: at91: fix hanged boot due to early rtt-interrupt

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Linus Walleij (1):
      MAINTAINERS: drop discontinued mailing list

Lokesh Vutla (1):
      ARM: dts: doc: Document missing compatible property for omap-sham driver

Lothar Waßmann (1):
      ARM: imx6q: add missing sentinel to divider table

Nishanth Menon (1):
      ARM: OMAP2+: omap_device: maintain sane runtime pm status around suspend/resume

Olof Johansson (7):
      Merge tag 'imx-fixes-3.13' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      ARM: vt8500: add defconfig for v6/v7 chips
      ARM: sti: only select errata 764369 if SMP
      ARM: highbank: only select errata 764369 if SMP
      video: exynos_mipi_dsim: Remove unused variable
      Merge tag 'at91-fixes-non-critical' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'omap-for-v3.13/fixes-for-merge-window-take2' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Roger Quadros (1):
      pinctrl: single: call pcs_soc->rearm() whenever IRQ mask is changed

Shawn Guo (6):
      ARM: imx: remove imx_src_prepare_restart() call
      ARM: imx: improve mxc_restart() on the SRC bit writes
      ARM: imx: v7_cpu_resume() is needed by imx6sl build
      ARM: imx: add sleep for pllv3 relock
      ARM: imx: pllv3 needs relock in .set_rate() call
      ARM: imx: set up pllv3 POWER and BYPASS sequentially

Tomi Valkeinen (3):
      ARM: OMAP4: use CLK_SET_RATE_PARENT for dss_dss_clk
      ARM: OMAP3: use CLK_SET_RATE_PARENT for dss clocks
      ARM: OMAP3: fix dpll4_m3_ck and dpll4_m4_ck dividers

Tony Lindgren (2):
      Merge tag 'for-v3.13/clock-fixes-a' of git://git.kernel.org/.../pjw/omap-pending into xxx-dt
      ARM: OMAP2+: Fix build for dra7xx without omap4 and 5

Wei Yongjun (2):
      ARM: OMAP2+: smsc911x: fix return value check in gpmc_smsc911x_init()
      ARM: OMAP3: Beagle: fix return value check in beagle_opp_init()

 .../devicetree/bindings/crypto/omap-des.txt        | 30 ++++++++
 .../devicetree/bindings/crypto/omap-sham.txt       |  2 +-
 Documentation/devicetree/bindings/spi/omap-spi.txt |  4 +-
 MAINTAINERS                                        |  1 -
 arch/arm/boot/dts/imx51.dtsi                       |  2 +-
 arch/arm/configs/vt8500_v6_v7_defconfig            | 90 ++++++++++++++++++++++
 arch/arm/mach-at91/Makefile                        |  2 +-
 arch/arm/mach-at91/at91sam9260.c                   |  2 +
 arch/arm/mach-at91/at91sam9261.c                   |  2 +
 arch/arm/mach-at91/at91sam9263.c                   |  3 +
 arch/arm/mach-at91/at91sam9g45.c                   |  3 +
 arch/arm/mach-at91/at91sam9n12.c                   |  6 ++
 arch/arm/mach-at91/at91sam9rl.c                    |  3 +
 arch/arm/mach-at91/at91sam9x5.c                    |  6 ++
 arch/arm/mach-at91/generic.h                       |  2 +
 arch/arm/mach-at91/include/mach/at91sam9n12.h      |  5 ++
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |  5 ++
 arch/arm/mach-at91/include/mach/sama5d3.h          |  5 ++
 arch/arm/mach-at91/sama5d3.c                       |  6 ++
 arch/arm/mach-at91/sysirq_mask.c                   | 71 +++++++++++++++++
 arch/arm/mach-highbank/Kconfig                     |  2 +-
 arch/arm/mach-imx/Makefile                         |  4 +-
 arch/arm/mach-imx/clk-imx6q.c                      |  7 +-
 arch/arm/mach-imx/clk-pllv3.c                      | 51 ++++++++----
 arch/arm/mach-imx/common.h                         |  5 --
 arch/arm/mach-imx/src.c                            | 15 ----
 arch/arm/mach-imx/system.c                         | 12 ++-
 arch/arm/mach-integrator/integrator_cp.c           |  3 +-
 arch/arm/mach-omap2/Makefile                       |  2 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |  2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c              | 58 +++++++++++---
 arch/arm/mach-omap2/cclock44xx_data.c              |  3 +-
 arch/arm/mach-omap2/gpmc-smsc911x.c                |  2 +-
 arch/arm/mach-omap2/omap_device.c                  | 13 +++-
 arch/arm/mach-omap2/prm44xx_54xx.h                 |  3 +-
 arch/arm/mach-sti/Kconfig                          |  2 +-
 arch/arm/mach-tegra/tegra.c                        |  2 +-
 drivers/pinctrl/pinctrl-single.c                   | 10 +--
 drivers/video/exynos/exynos_mipi_dsi.c             |  1 -
 39 files changed, 367 insertions(+), 80 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/omap-des.txt
 create mode 100644 arch/arm/configs/vt8500_v6_v7_defconfig
 create mode 100644 arch/arm/mach-at91/sysirq_mask.c

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3GAXgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 19:36:19 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49789 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3GAXgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 19:36:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
User-Agent: alot/0.3.4
To: torvalds@linux-foundation.org
Message-ID: <20130701233614.10823.24820@quantum>
Subject: [GIT PULL] clk: changes for 3.11
Date: Mon, 01 Jul 2013 16:36:14 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus-3.11

for you to fetch changes up to 45e3ec3784aec0d194740b75b547bfabca448ff3:

  clk: tegra: fix ifdef for tegra_periph_reset_assert inline (2013-06-24 14:17:59 -0700)

----------------------------------------------------------------
The common clock framework changes for 3.11 include new clock drivers
across several different platforms and architectures, fixes to existing
drivers, a MAINTAINERS file fix and improvements to the basic clock
types that allow them to be of use to more platforms than before. Only a
few fixes to the core framework are included with most all of the
changes landing in the various clock drivers themselves.

----------------------------------------------------------------
Alexandre Courbot (1):
      clk: tegra114: correctly output clk_32k

Arnd Bergmann (1):
      clk: tegra: provide tegra_periph_reset_assert alternative

Axel Lin (2):
      clk: wm831x: Fix update wrong register for enable/disable FLL
      clk: wm831x: Fix wm831x_clkout_get_parent

Daniel Tang (1):
      clk: Add TI-Nspire clock drivers

Fabio Baltieri (1):
      clk: ux500: abx500-clk: rename ux500 audio codec aliases

Giacomo A. Catenazzi (1):
      clk: sunxi: "cpu_data" is defined in header files of some architectures

Haojian Zhuang (3):
      clk: mux: add CLK_MUX_HIWORD_MASK
      clk: divider: add CLK_DIVIDER_HIWORD_MASK flag
      clk: gate: add CLK_GATE_HIWORD_MASK

Heiko Stübner (1):
      clk: add support for Rockchip gate clocks

Jean-Francois Moine (1):
      clk: si5351: declare all device IDs for module loading

Jingoo Han (1):
      clk: use platform_{get,set}_drvdata()

Maxime Ripard (1):
      clk: sun5i: Add compatibles for Allwinner A13

Mikko Perttunen (1):
      clk: tegra114: Fix msenc clock register

Paul Walmsley (3):
      clk: tegra: T114: add FCPU clock shaper programming, needed by the DFLL
      clk: tegra: T114: add DFLL source clocks
      clk: tegra: T114: add DFLL DVCO reset control

Pawel Moll (2):
      clk: vexpress: Use full node name to identify individual clocks
      clk: vexpress: Make the clock drivers directly available for arm64

Peter De Schrijver (12):
      clk: tegra: pllc and pllxc should use pdiv_map
      clk: tegra: pllp_out2 divider is int only
      clk: tegra: allow PLL m,n,p init from SoC files
      clk: tegra: PLL m,n,p init for Tegra114
      clk: tegra: fix pllre initilization
      clk: tegra: fix sclk_parents
      clk: tegra: Add fields for override bits
      clk: tegra: override bits for Tegra114 PLLM
      clk: tegra: override bits for Tegra30 PLLM
      clk: tegra: Use override bits when needed
      clk: use clk_get_rate() for debugfs
      clk: honor CLK_GET_RATE_NOCACHE in clk_set_rate

Philippe Begnic (4):
      clk: ux500: Pass clock base adresses in initcall for u8540 and u9540
      mfd: db8500: Update register definition for u8540 clock
      mfd: db8500: Update BML clock register for db8580
      clk: ux500: Clocks definition for u8540

Prashant Gaikwad (2):
      clk: tegra: fix clk_out parents list
      clk: tegra: Use common of_clk_init function

Saravana Kannan (2):
      clk: Fix race condition between clk_set_parent and clk_enable()
      clk: Disable unused clocks after deferred probing is done

Sebastian Hesselbarth (3):
      clk: si5351: Allow user to define disabled state for every clock output
      clk: add non CONFIG_OF routines for clk-provider
      clk: si5351: Allow to build without CONFIG_OF

Shawn Guo (1):
      clk: divider: do not propagate rate change request when unnecessary

Soren Brinkmann (1):
      clk: Always notify whole subtree when reparenting

Stephen Warren (2):
      MAINTAINERS: make drivers/clk entry match subdirs
      clk: tegra: fix ifdef for tegra_periph_reset_assert inline

Tang Yuantian (2):
      clk: add PowerPC corenet clock driver support
      clk: mpc85xx: Update the compatible string

Tony Prisk (2):
      clk: vt8500: Add support for clocks on the WM8850 SoCs
      clk: vt8500: Remove unnecessary divisor adjustment in vtwm_dclk_set_rate()

Tushar Behera (4):
      clk: exynos5250: Update cpufreq related clocks for EXYNOS5250
      clk: exynos5250: Add sclk_mpll to the parent list of mout_cpu clock
      clk: samsung: Add MUX_FA macro to pass flag and alias
      clk: exynos4: Fix clock aliases for cpufreq related clocks

 .../devicetree/bindings/clock/nspire-clock.txt     |  24 +
 .../devicetree/bindings/clock/rockchip.txt         |  74 +++
 .../devicetree/bindings/clock/silabs,si5351.txt    |   5 +
 Documentation/devicetree/bindings/clock/sunxi.txt  | 117 +----
 .../bindings/clock/sunxi/sun4i-a10-gates.txt       |  93 ++++
 .../bindings/clock/sunxi/sun5i-a13-gates.txt       |  58 +++
 Documentation/devicetree/bindings/clock/vt8500.txt |   2 +
 MAINTAINERS                                        |   5 +-
 arch/arm/mach-tegra/common.c                       |   4 +-
 arch/arm/mach-ux500/cpu.c                          |   6 +-
 arch/powerpc/platforms/Kconfig.cputype             |   1 +
 drivers/clk/Kconfig                                |  10 +-
 drivers/clk/Makefile                               |   3 +
 drivers/clk/clk-divider.c                          |  25 +-
 drivers/clk/clk-gate.c                             |  25 +-
 drivers/clk/clk-mux.c                              |  17 +-
 drivers/clk/clk-nspire.c                           | 153 ++++++
 drivers/clk/clk-ppc-corenet.c                      | 280 ++++++++++
 drivers/clk/clk-si5351.c                           |  79 ++-
 drivers/clk/clk-si5351.h                           |   1 +
 drivers/clk/clk-twl6040.c                          |   4 +-
 drivers/clk/clk-vt8500.c                           |  75 ++-
 drivers/clk/clk-wm831x.c                           |  14 +-
 drivers/clk/clk.c                                  | 100 ++--
 drivers/clk/rockchip/Makefile                      |   5 +
 drivers/clk/rockchip/clk-rockchip.c                |  94 ++++
 drivers/clk/samsung/clk-exynos4.c                  |  21 +-
 drivers/clk/samsung/clk-exynos5250.c               |   8 +-
 drivers/clk/samsung/clk.h                          |   3 +
 drivers/clk/sunxi/clk-sunxi.c                      |  35 +-
 drivers/clk/tegra/clk-pll.c                        | 281 +++++-----
 drivers/clk/tegra/clk-tegra114.c                   | 270 +++++++++-
 drivers/clk/tegra/clk-tegra20.c                    |   3 +-
 drivers/clk/tegra/clk-tegra30.c                    |  25 +-
 drivers/clk/tegra/clk.c                            |  12 -
 drivers/clk/tegra/clk.h                            |  62 +--
 drivers/clk/ux500/abx500-clk.c                     |   8 +-
 drivers/clk/ux500/u8540_clk.c                      | 564 ++++++++++++++++++++-
 drivers/clk/ux500/u9540_clk.c                      |   4 +-
 drivers/clk/versatile/clk-vexpress-osc.c           |   4 +-
 drivers/mfd/db8500-prcmu.c                         |   1 +
 drivers/mfd/dbx500-prcmu-regs.h                    |   1 +
 include/linux/clk-provider.h                       |  62 ++-
 include/linux/clk/tegra.h                          |   6 +-
 include/linux/mfd/abx500/ab8500-sysctrl.h          |   4 +-
 include/linux/mfd/dbx500-prcmu.h                   |  12 +
 include/linux/platform_data/clk-ux500.h            |   6 +-
 include/linux/platform_data/si5351.h               |  18 +
 48 files changed, 2265 insertions(+), 419 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nspire-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/rockchip.txt
 create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun4i-a10-gates.txt
 create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun5i-a13-gates.txt
 create mode 100644 drivers/clk/clk-nspire.c
 create mode 100644 drivers/clk/clk-ppc-corenet.c
 create mode 100644 drivers/clk/rockchip/Makefile
 create mode 100644 drivers/clk/rockchip/clk-rockchip.c

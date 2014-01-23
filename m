Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaAWTFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:05:54 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64658 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaAWTFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:05:52 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, arm@kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140123190332.4167.23361@quantum>
Subject: [GIT PULL] clk: changes for 3.14, part 1
Date: Thu, 23 Jan 2014 11:03:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.14-part1

for you to fetch changes up to 2e84d75116c17c2034e917b411250d2d11755435:

  devicetree: bindings: Document qcom,mmcc (2014-01-16 12:01:07 -0800)

----------------------------------------------------------------
The first half of the clk framework pull request is made up almost
entirely of new platform/driver support. There are some conversions of
existing drivers to the common-clock Device Tree binding, and a few
non-critical fixes to the framework.

Due to an entirely unnecessary cyclical dependency with the arm-soc tree
this pull request is broken into two pieces. The second piece will be
sent out after arm-soc sends you the pull request that merged in core
support for the HiSilicon 3620 platform. That same pull request from
arm-soc depends on this pull request to merge in those HiSilicon bits
without causing build failures.

----------------------------------------------------------------
Abhilash Kesavan (4):
      clk: samsung: exynos5250: Fix ACP gate register offset
      clk: samsung: exynos5250: Add MDMA0 clocks
      ARM: dts: exynos5250: Fix MDMA0 clock number
      clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg clock

Alex Elder (1):
      clk: clean up everything on debugfs error

Alexandre Courbot (1):
      clk: tegra: add FUSE clock device

Andrew Bresticker (8):
      clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks
      clk: exynos5250: register APLL rate table
      clk: exynos-audss: convert to platform device
      clk: exynos-audss: allow input clocks to be specified in device tree
      clk: exynos5250: add clock ID for div_pcm0
      ARM: dts: exynos5250: add input clocks to audss clock controller
      clk: exynos-audss: add support for Exynos 5420
      ARM: dts: exynos5420: add input clocks to audss clock controller

Andrew Chew (1):
      clk: tegra: Set the clk parent of host1x to pll_p

Andrzej Hajda (8):
      ARM: exynos4: create a DT header defining CLK IDs
      clk: exynos4: replace clock ID private enums with IDs from DT header
      ARM: exynos5250: create a DT header defining CLK IDs
      clk: exynos5250: replace clock ID private enums with IDs from DT header
      ARM: exynos5420: create a DT header defining CLK IDs
      clk: exynos5420: replace clock ID private enums with IDs from DT header
      ARM: exynos5440: create a DT header defining CLK IDs
      clk: exynos5440: replace clock ID private enums with IDs from DT header

Barry Song (1):
      clk: sirf: re-arch to make the codes support both prima2 and atlas6

Boris BREZILLON (2):
      clk: add clk accuracy retrieval support
      clk: add accuracy support for fixed clock

Chander Kashyap (1):
      clk: exynos5420: fix cpll clock register offsets

Chen-Yu Tsai (1):
      clk: sunxi: Allwinner A20 output clock support

Dinh Nguyen (1):
      clk: socfpga: Remove check for "reg" property in socfpga_clk_init

Emilio López (11):
      clk: composite: .determine_rate support
      clk: sunxi: factors: fix off-by-one masks
      clk: sunxi: factors: clear variables before using them
      clk: sunxi: protect core clocks from accidental shutdown
      clk: sunxi: register factors clocks behind composite
      clk: sunxi: clean the magic number of mux parents
      clk: sunxi: add gating support to PLL1
      clk: sunxi: make factors_clk_setup return the clock it registers
      clk: sunxi: add PLL5 and PLL6 support
      clk: sunxi: mod0 support
      clk: sunxi: support better factor DT nodes

Ezequiel Garcia (2):
      clk: mvebu: Add Core Divider clock
      clk: fixed-factor: Fix device-tree binding typo

Grygorii Strashko (1):
      clk: keystone: gate: fix error handling on init

Haojian Zhuang (3):
      clk: hisilicon: add common clock support
      clk: hi3620: fix wrong flags on divider
      clk: hi3620: add gate clock flag

Jisheng Zhang (1):
      clk: mvebu: staticize of_cpu_clk_setup

Joseph Lo (2):
      clk: tegra124: add wait_for_reset and disable_clock for tegra_cpu_car_ops
      clk: tegra124: add suspend/resume function for tegra_cpu_car_ops

Krzysztof Kozlowski (1):
      clk: exynos: File scope reg_save array should depend on PM_SLEEP

Laurent Pinchart (3):
      clk: shmobile: Add R-Car Gen2 clocks support
      clk: shmobile: Add DIV6 clock support
      clk: shmobile: Add MSTP clock support

Mark Zhang (3):
      clk: tegra: Correct sbc mux width & parent
      clk: tegra: Fix vde/2d/3d clock src offset
      clk: tegra: Set the clock parent of gr2d/gr3d to pll_c2

Mike Turquette (15):
      Merge tag 'sunxi-clk-for-3.13' of https://github.com/mripard/linux into clk-next-sunxi-rebase
      Merge branch 'clk-tegra-next' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-next-tegra
      Merge branch 'clk/clk-unregister' of git://linuxtv.org/snawrocki/samsung into clk-next-unregister
      Merge branch 'clk-next-shmobile' into clk-next
      Merge tag 'clk-hisilicon' of git://git.kernel.org/.../hzhuang1/linux into clk-next-hisilicon
      Merge tag 'zynq-clk-for-3.14-v2' of git://git.xilinx.com/linux-xlnx into clk-next
      Merge tag 'mvebu-clk-3.14' of git://git.infradead.org/linux-mvebu into clk-next
      Merge tag 'renesas-clock-for-v3.14' of git://git.kernel.org/.../horms/renesas into clk-next-shmobile2
      clk: remove CONFIG_COMMON_CLK_DEBUG
      Merge tag 'sunxi-clk-3.14-for-mike' of https://bitbucket.org/emiliolopez/linux into clk-next-sunxi
      Merge branch 'for_3.14/keystone-clk' of git://git.kernel.org/.../ssantosh/linux-keystone into clk-next-keystone
      Merge branch 'clk-next-unregister' into clk-next
      Merge tag 'for_3.14/samsung-clk' of git://git.kernel.org/.../tfiga/samsung-clk into clk-next-samsung
      Merge branch 'clk-next-shmobile' into clk-next
      clk: composite: pass mux_hw into determine_rate

Mikko Perttunen (1):
      clk: tegra114: Initialize clocks needed for HDMI

Murali Karicheri (1):
      clk: keystone: use clkod register bits for postdiv

Peter De Schrijver (27):
      ARM: tegra114: add missing clocks to binding
      clk: tegra: replace enum tegra114_clk by binding header
      clk: tegra: add TEGRA_DIVIDER_ROUND_UP for periph clks
      clk: tegra: PLLE spread spectrum control
      ARM: tegra30: add missing CLK IDs
      clk: tegra: simplify periph clock data
      clk: tegra: common periph_clk_enb_refcnt and clks
      clk: tegra: Add TEGRA_PERIPH_NO_DIV flag
      clk: tegra: move some PLLC and PLLXC init to clk-pll.c
      clk: tegra: use pll_ref as the pll_e parent
      clk: tegra: move fields to tegra_clk_pll_params
      clk: tegra: add header for common tegra clock IDs
      clk: tegra: add common infra for DT clocks
      clk: tegra: add clkdev registration infra
      clk: tegra: move audio clk to common file
      clk: tegra: move periph clocks to common file
      clk: tegra: move PMC, fixed clocks to common files
      clk: tegra: introduce common gen4 super clock
      clk: tegra: move tegra30 to common infra
      clk: tegra: move tegra20 to common infra
      clk: tegra: Add support for PLLSS
      clk: tegra: Add periph regs bank X
      clk: tegra: add locking to periph clks
      clk: tegra: add TEGRA_PERIPH_NO_GATE
      clk: tegra124: Add common clk IDs to clk-id.h
      clk: tegra124: Add new peripheral clocks
      clk: tegra124: Add support for Tegra124 clocks

Sachin Kamat (11):
      clk: SPEAr: Staticize clk_frac_ops
      clk: tegra: Staticize local variables in clk-pll.c
      clk: tegra: Staticize tegra_clk_periph_nodiv_ops
      clk: socfpga: Use NULL instead of 0
      clk: versatile: Staticize clk_sp810_timerclken_of_get
      clk: mvebu: Staticize of_cpu_clk_setup
      clk: vt8500: Staticize vtwm_pll_ops
      clk: ux500: Remove extra semicolon
      clk: si570: Remove redundant of_match_ptr helper
      clk: max77686: Remove redundant break
      clk: exynos5250: Add CLK_SET_RATE_PARENT flag to mout_apll

Seung-Woo Kim (1):
      clk: samsung: exynos4: Correct SRC_MFC register

Soren Brinkmann (2):
      clk: si570: Add a driver for SI570 oscillators
      clk/zynq/clkc: Add 'fclk-enable' feature

Stephen Boyd (15):
      clk: Fix debugfs reparenting NULL pointer dereference
      reset: Silence warning in reset-controller.h
      clk: Add set_rate_and_parent() op
      clk: qcom: Add a regmap type clock struct
      clk: qcom: Add support for phase locked loops (PLLs)
      clk: qcom: Add support for root clock generators (RCGs)
      clk: qcom: Add support for branches/gate clocks
      clk: qcom: Add reset controller support
      clk: qcom: Add support for MSM8960's global clock controller (GCC)
      clk: qcom: Add support for MSM8960's multimedia clock controller (MMCC)
      clk: qcom: Add support for MSM8974's global clock controller (GCC)
      clk: qcom: Add support for MSM8974's multimedia clock controller (MMCC)
      clk: qcom: Add support for MSM8660's global clock controller (GCC)
      devicetree: bindings: Document qcom,gcc
      devicetree: bindings: Document qcom,mmcc

Sylwester Nawrocki (5):
      omap3isp: Modify clocks registration to avoid circular references
      clk: Provide not locked variant of of_clk_get_from_provider()
      clkdev: Fix race condition in clock lookup from device tree
      clk: Add common __clk_get(), __clk_put() implementations
      clk: Implement clk_unregister

Takashi Yoshii (1):
      clk: emev2: Add support for emev2 SMU clocks with DT

Thierry Reding (6):
      clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d
      clk: tegra: Fix clock rate computation
      clk: tegra: Initialize secondary gr3d clock on Tegra30
      clk: tegra: Properly setup PWM clock on Tegra30
      clk: tegra: Initialize DSI low-power clocks
      clk: tegra: Do not print errors for clk_round_rate()

Tomasz Figa (17):
      Merge branch 'samsung-fixes' into samsung-next-base
      clk: samsung: exynos5250: Sort definitions by registers and bitfield
      clk: samsung: exynos5250: Make names of mux and div clocks consistent
      clk: samsung: exynos5250: Fix parents of gate clocks from GSCL domain
      clk: samsung: exynos5250: Fix parent of gate clocks from DISP1 domain
      clk: samsung: exynos5250: Add missing unpopulated mux parents
      clk: samsung: exynos5250: Correct parent list of audio muxes
      clk: samsung: exynos5250: Fix parents of gate clocks from MFC domain
      MAINTAINERS: Add entry for Samsung SoC clock drivers
      clk: max77686: Correct callback used for checking clock status
      clk: max77686: Provide .recalc_rate() operation
      clk: max77686: Refactor successful exit of probe function
      clk: max77686: Make max77686_clk_register() return struct clk *
      clk: max77686: Fix clean-up in error and remove paths
      clk: max77686: Refactor driver data handling
      clk: max77686: Register OF clock provider
      ARM: dts: Add clock provider specific properties to max77686 node

Ulf Hansson (1):
      MAINTAINERS: Add maintainer for the ARM Ux500 clock driver

Valentine Barshak (2):
      clk: shmobile: Fix MSTP clock index
      clk: shmobile: Fix MSTP clock array initialization

Victor N. Ramos Mello (1):
      drivers: clk: sunxi: Fix memory leakage in clk-sunxi.c

Wei Yongjun (1):
      clk: tegra: fix __clk_lookup() return value checks

 Documentation/clk.txt                              |    7 +
 .../devicetree/bindings/clock/clk-exynos-audss.txt |   39 +-
 .../devicetree/bindings/clock/emev2-clock.txt      |   98 +
 .../devicetree/bindings/clock/exynos5250-clock.txt |    3 +
 .../devicetree/bindings/clock/fixed-clock.txt      |    3 +
 .../bindings/clock/fixed-factor-clock.txt          |    4 +-
 .../devicetree/bindings/clock/hi3620-clock.txt     |   19 +
 .../devicetree/bindings/clock/keystone-pll.txt     |    8 +-
 .../devicetree/bindings/clock/maxim,max77686.txt   |   38 +
 .../bindings/clock/nvidia,tegra124-car.txt         |   59 +
 .../devicetree/bindings/clock/qcom,gcc.txt         |   21 +
 .../devicetree/bindings/clock/qcom,mmcc.txt        |   21 +
 .../bindings/clock/renesas,cpg-div6-clocks.txt     |   28 +
 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |   51 +
 .../clock/renesas,rcar-gen2-cpg-clocks.txt         |   32 +
 .../devicetree/bindings/clock/silabs,si570.txt     |   39 +
 Documentation/devicetree/bindings/clock/sunxi.txt  |   10 +-
 .../devicetree/bindings/clock/zynq-7000.txt        |    4 +
 Documentation/devicetree/bindings/mfd/max77686.txt |    3 +
 MAINTAINERS                                        |   14 +
 arch/arm/boot/dts/cros5250-common.dtsi             |    1 +
 arch/arm/boot/dts/exynos4412-odroidx.dts           |    1 +
 arch/arm/boot/dts/exynos4412-trats2.dts            |    1 +
 arch/arm/boot/dts/exynos5250.dtsi                  |    4 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |    4 +-
 arch/arm/include/asm/clkdev.h                      |    2 +
 arch/blackfin/include/asm/clkdev.h                 |    2 +
 arch/mips/include/asm/clkdev.h                     |    2 +
 arch/sh/include/asm/clkdev.h                       |    2 +
 drivers/clk/Kconfig                                |   22 +-
 drivers/clk/Makefile                               |    6 +-
 drivers/clk/clk-composite.c                        |   28 +
 drivers/clk/clk-fixed-rate.c                       |   43 +-
 drivers/clk/clk-max77686.c                         |   97 +-
 drivers/clk/clk-si570.c                            |  531 ++++
 drivers/clk/clk-vt8500.c                           |    2 +-
 drivers/clk/clk.c                                  |  371 ++-
 drivers/clk/clk.h                                  |   16 +
 drivers/clk/clkdev.c                               |   12 +-
 drivers/clk/hisilicon/Makefile                     |    5 +
 drivers/clk/hisilicon/clk-hi3620.c                 |  242 ++
 drivers/clk/hisilicon/clk.c                        |  171 ++
 drivers/clk/hisilicon/clk.h                        |  103 +
 drivers/clk/hisilicon/clkgate-separated.c          |  130 +
 drivers/clk/keystone/gate.c                        |   12 +-
 drivers/clk/keystone/pll.c                         |   24 +-
 drivers/clk/mvebu/Kconfig                          |    5 +
 drivers/clk/mvebu/Makefile                         |    1 +
 drivers/clk/mvebu/clk-corediv.c                    |  223 ++
 drivers/clk/mvebu/clk-cpu.c                        |    2 +-
 drivers/clk/qcom/Kconfig                           |   47 +
 drivers/clk/qcom/Makefile                          |   14 +
 drivers/clk/qcom/clk-branch.c                      |  159 ++
 drivers/clk/qcom/clk-branch.h                      |   56 +
 drivers/clk/qcom/clk-pll.c                         |  222 ++
 drivers/clk/qcom/clk-pll.h                         |   66 +
 drivers/clk/qcom/clk-rcg.c                         |  517 ++++
 drivers/clk/qcom/clk-rcg.h                         |  159 ++
 drivers/clk/qcom/clk-rcg2.c                        |  291 ++
 drivers/clk/qcom/clk-regmap.c                      |  114 +
 drivers/clk/qcom/clk-regmap.h                      |   45 +
 drivers/clk/qcom/gcc-msm8660.c                     | 2819 ++++++++++++++++++
 drivers/clk/qcom/gcc-msm8960.c                     | 2993 ++++++++++++++++++++
 drivers/clk/qcom/gcc-msm8974.c                     | 2694 ++++++++++++++++++
 drivers/clk/qcom/mmcc-msm8960.c                    | 2321 +++++++++++++++
 drivers/clk/qcom/mmcc-msm8974.c                    | 2625 +++++++++++++++++
 drivers/clk/qcom/reset.c                           |   63 +
 drivers/clk/qcom/reset.h                           |   37 +
 drivers/clk/samsung/clk-exynos-audss.c             |  161 +-
 drivers/clk/samsung/clk-exynos4.c                  |  859 +++---
 drivers/clk/samsung/clk-exynos5250.c               |  697 +++--
 drivers/clk/samsung/clk-exynos5420.c               |  650 ++---
 drivers/clk/samsung/clk-exynos5440.c               |   81 +-
 drivers/clk/shmobile/Makefile                      |    7 +
 drivers/clk/shmobile/clk-div6.c                    |  185 ++
 drivers/clk/shmobile/clk-emev2.c                   |  104 +
 drivers/clk/shmobile/clk-mstp.c                    |  233 ++
 drivers/clk/shmobile/clk-rcar-gen2.c               |  298 ++
 drivers/clk/sirf/Makefile                          |    5 +
 drivers/clk/sirf/atlas6.h                          |   31 +
 drivers/clk/sirf/clk-atlas6.c                      |  152 +
 drivers/clk/{clk-prima2.c => sirf/clk-common.c}    |  264 +-
 drivers/clk/sirf/clk-prima2.c                      |  151 +
 drivers/clk/sirf/prima2.h                          |   25 +
 drivers/clk/socfpga/clk.c                          |    6 +-
 drivers/clk/spear/clk-frac-synth.c                 |    2 +-
 drivers/clk/sunxi/clk-factors.c                    |   67 +-
 drivers/clk/sunxi/clk-factors.h                    |   16 +-
 drivers/clk/sunxi/clk-sunxi.c                      |  493 +++-
 drivers/clk/tegra/Makefile                         |    7 +-
 drivers/clk/tegra/clk-id.h                         |  235 ++
 drivers/clk/tegra/clk-periph-gate.c                |    8 +-
 drivers/clk/tegra/clk-periph.c                     |   34 +-
 drivers/clk/tegra/clk-pll.c                        |  417 ++-
 drivers/clk/tegra/clk-tegra-audio.c                |  215 ++
 drivers/clk/tegra/clk-tegra-fixed.c                |  111 +
 drivers/clk/tegra/clk-tegra-periph.c               |  674 +++++
 drivers/clk/tegra/clk-tegra-pmc.c                  |  132 +
 drivers/clk/tegra/clk-tegra-super-gen4.c           |  149 +
 drivers/clk/tegra/clk-tegra114.c                   | 1687 +++--------
 drivers/clk/tegra/clk-tegra124.c                   | 1424 ++++++++++
 drivers/clk/tegra/clk-tegra20.c                    |  818 ++----
 drivers/clk/tegra/clk-tegra30.c                    | 1506 +++-------
 drivers/clk/tegra/clk.c                            |  166 ++
 drivers/clk/tegra/clk.h                            |  115 +-
 drivers/clk/ux500/clk-prcmu.c                      |    2 +-
 drivers/clk/versatile/clk-sp810.c                  |    2 +-
 drivers/clk/zynq/clkc.c                            |   18 +-
 drivers/media/platform/omap3isp/isp.c              |   22 +-
 drivers/media/platform/omap3isp/isp.h              |    1 +
 include/dt-bindings/clk/exynos-audss-clk.h         |    3 +-
 include/dt-bindings/clock/exynos4.h                |  244 ++
 include/dt-bindings/clock/exynos5250.h             |  160 ++
 include/dt-bindings/clock/exynos5420.h             |  188 ++
 include/dt-bindings/clock/exynos5440.h             |   42 +
 include/dt-bindings/clock/hi3620-clock.h           |  152 +
 include/dt-bindings/clock/qcom,gcc-msm8660.h       |  276 ++
 include/dt-bindings/clock/qcom,gcc-msm8960.h       |  313 ++
 include/dt-bindings/clock/qcom,gcc-msm8974.h       |  320 +++
 include/dt-bindings/clock/qcom,mmcc-msm8960.h      |  137 +
 include/dt-bindings/clock/qcom,mmcc-msm8974.h      |  161 ++
 include/dt-bindings/clock/tegra114-car.h           |    8 +-
 include/dt-bindings/clock/tegra124-car.h           |  341 +++
 include/dt-bindings/clock/tegra30-car.h            |   10 +-
 include/dt-bindings/reset/qcom,gcc-msm8660.h       |  134 +
 include/dt-bindings/reset/qcom,gcc-msm8960.h       |  118 +
 include/dt-bindings/reset/qcom,gcc-msm8974.h       |   96 +
 include/dt-bindings/reset/qcom,mmcc-msm8960.h      |   93 +
 include/dt-bindings/reset/qcom,mmcc-msm8974.h      |   62 +
 include/linux/clk-private.h                        |    8 +-
 include/linux/clk-provider.h                       |   30 +
 include/linux/clk.h                                |   17 +
 include/linux/clk/shmobile.h                       |   19 +
 include/linux/clkdev.h                             |    5 +
 include/linux/reset-controller.h                   |    1 +
 135 files changed, 28392 insertions(+), 4584 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/emev2-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/hi3620-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77686.txt
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,mmcc.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,cpg-div6-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,cpg-mstp-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/silabs,si570.txt
 create mode 100644 drivers/clk/clk-si570.c
 create mode 100644 drivers/clk/clk.h
 create mode 100644 drivers/clk/hisilicon/Makefile
 create mode 100644 drivers/clk/hisilicon/clk-hi3620.c
 create mode 100644 drivers/clk/hisilicon/clk.c
 create mode 100644 drivers/clk/hisilicon/clk.h
 create mode 100644 drivers/clk/hisilicon/clkgate-separated.c
 create mode 100644 drivers/clk/mvebu/clk-corediv.c
 create mode 100644 drivers/clk/qcom/Kconfig
 create mode 100644 drivers/clk/qcom/Makefile
 create mode 100644 drivers/clk/qcom/clk-branch.c
 create mode 100644 drivers/clk/qcom/clk-branch.h
 create mode 100644 drivers/clk/qcom/clk-pll.c
 create mode 100644 drivers/clk/qcom/clk-pll.h
 create mode 100644 drivers/clk/qcom/clk-rcg.c
 create mode 100644 drivers/clk/qcom/clk-rcg.h
 create mode 100644 drivers/clk/qcom/clk-rcg2.c
 create mode 100644 drivers/clk/qcom/clk-regmap.c
 create mode 100644 drivers/clk/qcom/clk-regmap.h
 create mode 100644 drivers/clk/qcom/gcc-msm8660.c
 create mode 100644 drivers/clk/qcom/gcc-msm8960.c
 create mode 100644 drivers/clk/qcom/gcc-msm8974.c
 create mode 100644 drivers/clk/qcom/mmcc-msm8960.c
 create mode 100644 drivers/clk/qcom/mmcc-msm8974.c
 create mode 100644 drivers/clk/qcom/reset.c
 create mode 100644 drivers/clk/qcom/reset.h
 create mode 100644 drivers/clk/shmobile/Makefile
 create mode 100644 drivers/clk/shmobile/clk-div6.c
 create mode 100644 drivers/clk/shmobile/clk-emev2.c
 create mode 100644 drivers/clk/shmobile/clk-mstp.c
 create mode 100644 drivers/clk/shmobile/clk-rcar-gen2.c
 create mode 100644 drivers/clk/sirf/Makefile
 create mode 100644 drivers/clk/sirf/atlas6.h
 create mode 100644 drivers/clk/sirf/clk-atlas6.c
 rename drivers/clk/{clk-prima2.c => sirf/clk-common.c} (82%)
 create mode 100644 drivers/clk/sirf/clk-prima2.c
 create mode 100644 drivers/clk/sirf/prima2.h
 create mode 100644 drivers/clk/tegra/clk-id.h
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c
 create mode 100644 drivers/clk/tegra/clk-tegra-fixed.c
 create mode 100644 drivers/clk/tegra/clk-tegra-periph.c
 create mode 100644 drivers/clk/tegra/clk-tegra-pmc.c
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 include/dt-bindings/clock/exynos4.h
 create mode 100644 include/dt-bindings/clock/exynos5250.h
 create mode 100644 include/dt-bindings/clock/exynos5420.h
 create mode 100644 include/dt-bindings/clock/exynos5440.h
 create mode 100644 include/dt-bindings/clock/hi3620-clock.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8660.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8960.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-msm8974.h
 create mode 100644 include/dt-bindings/clock/qcom,mmcc-msm8960.h
 create mode 100644 include/dt-bindings/clock/qcom,mmcc-msm8974.h
 create mode 100644 include/dt-bindings/clock/tegra124-car.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8660.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8960.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-msm8974.h
 create mode 100644 include/dt-bindings/reset/qcom,mmcc-msm8960.h
 create mode 100644 include/dt-bindings/reset/qcom,mmcc-msm8974.h
 create mode 100644 include/linux/clk/shmobile.h

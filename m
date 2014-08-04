Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaHDSDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:03:47 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42452 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaHDSDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:03:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140804180341.5867.48453@quantum>
Subject: [GIT PULL] clk: changes for 3.17
Date: Mon, 04 Aug 2014 11:03:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 449437778bd09b73a5e51554f7219706da08917f:

  clk: spear3xx: Set proper clock parent of uart1/2 (2014-07-13 07:12:11 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.17

for you to fetch changes up to b11a6face1b6d5518319f797a74e22bb4309daa9:

  clk: Add missing of_clk_set_defaults export (2014-08-04 09:48:39 -0700)

----------------------------------------------------------------
The clock framework changes for 3.17 are mostly additions of new clock
drivers and fixes/enhancements to existing clock drivers. There are also
some non-critical fixes and improvements to the framework core.

Changes to the clock framework core include:
* improvements to printks on errors
* flattening the previously hierarchal structure of per-clock entries
  in debugfs
* allow per-clock debugfs entries that are specific to a particular
  clock driver
* configure initial clock parent and/or initial clock rate from Device
  Tree
* several feature enhancements to the composite clock type
* misc fixes

New clock drivers added include:
* TI Palmas PMIC
* Allwinner A23 SoC
* Qualcomm APQ8084 and IPQ8064 SoCs
* Rockchip rk3188, rk3066 and rk3288 SoCs
* STMicroelectronics STiH407 SoC
* Cirrus Logic CLPS711X SoC

Many fixes, feature enhancements and further clock tree support for
existing clock drivers also were merged, such as Samsung's "ARMCLK down"
power saving feature for their Exynos4 & Exynos5 SoCs.

----------------------------------------------------------------
Alexander Shiyan (2):
      clk: Add CLPS711X clk driver
      clk: clps711x: Add DT bindings documentation

Alexandre Belloni (1):
      clk: at91: main: warn when the main crystal frequency is not set

Boris BREZILLON (1):
      clk: composite: support determine_rate using rate_ops->round_rate + mux_ops->set_parent

Chen-Yu Tsai (9):
      clk: sunxi: register clock gates with clkdev
      clk: sunxi: move "ahb_sdram" to protected clock list
      clk: sunxi: Support factor clocks with N factor starting not from 0
      clk: sunxi: Add support for table-based divider clocks
      clk: sunxi: Add A23 clocks support
      clk: sunxi: Add A23 APB0 divider clock support
      clk: sunxi: Fix gate indexing for sun6i-a31-apb0-gates
      clk: sunxi: sun6i-apb0-gates: use bitmaps for valid gate indices
      clk: sunxi: sun6i-a31-apb0-gates: Add A23 APB0 support

Chris Brand (1):
      clk: Propagate any error return from debug_init()

Dan Carpenter (1):
      clk: checking wrong variable in __set_clk_parents()

Emilio López (2):
      clk: sunxi: add __iomem markings to MMIO pointers
      clk: sunxi: staticize structures and arrays

Gabriel FERNANDEZ (15):
      clk: st: Update ST clock binding documentation
      clk: st: use static const for stm_fs tables
      clk: st: use static const for clkgen_pll_data tables
      clk: st: Remove uncessary (void *) cast
      clk: st: Adds Flexgen clock binding
      clk: st: STiH407: Support for Flexgen Clocks
      clk: st: STiH407: Support for A9 MUX Clocks
      clk: st: STiH407: Support for clockgenA0
      clk: st: Add polarity bit indication
      clk: st: Add quadfs reset handling
      clk: st: STiH407: Support for clockgenC0
      clk: st: STiH407: Support for clockgenD0/D2/D3
      clk: st: STiH407: Support for clockgenA9
      clk: st: Update frequency tables for fs660c32 and fs432c65
      clk: st: Use round to closest divider flag

Georgi Djakov (4):
      clk: qcom: Add APQ8084 Global Clock Controller documentation
      clk: qcom: Add APQ8084 Global Clock Controller support
      clk: qcom: Add APQ8084 clocks for SATA, PCIe and UFS
      clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support

Heiko Stübner (9):
      clk: composite: allow read-only clocks
      clk: rockchip: add basic infrastructure for clock branches
      clk: rockchip: add clock type for pll clocks and pll used on rk3066
      clk: rockchip: add reset controller
      dt-bindings: add documentation for rk3188 clock and reset unit
      clk: rockchip: add clock driver for rk3188 and rk3066 clocks
      dt-bindings: add documentation for rk3288 cru
      clk: rockchip: add clock controller for rk3288
      ARM: rockchip: Select ARCH_HAS_RESET_CONTROLLER

Jingchang Lu (1):
      clk: ppc-corenet: Fix Section mismatch warning

Jonghwa Lee (1):
      clk: exynos4: Add PPMU IP block source clocks.

Karol Wrona (1):
      clk: s2mps11: Fix clk_ops

Krzysztof Kozlowski (3):
      clk: samsung: exynos4: Enable ARMCLK down feature
      clk: samsung: exynos3250: Enable ARMCLK down feature
      clk: samsung: Make of_device_id array const

Kumar Gala (1):
      clk: qcom: Add support for IPQ8064's global clock controller (GCC)

Mike Turquette (10):
      Merge remote-tracking branch 'linaro/clk-next' into clk-next
      Merge branch 'clk-fixes' into clk-next
      Merge tag 'tegra-clk-3.17-1' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-next-tegra
      Merge branch 'clk-fixes' into clk-next
      clk: composite: improve rate_hw sanity check logic
      Merge branch 'clk-rockchip' into clk-next
      Merge branch 'for-v3.17/ti-clk-driver' of github.com:t-kristo/linux-pm into clk-next-ti
      Merge tag 'qcom-clocks-for-3.17' of git://git.kernel.org/.../galak/linux-qcom into clk-next-msm
      Merge tag 'sunxi-clocks-for-3.17' of git://git.kernel.org/.../mripard/linux into clk-next-sunxi
      Merge tag 'for_3.17/samsung-clk' of git://git.kernel.org/.../tfiga/samsung-clk into clk-next-samsung

Mikko Perttunen (3):
      clk: tegra: Enable hardware control of SATA PLL
      clk: tegra: Add SATA clocks to Tegra124 initialization table
      clk: tegra: Use XUSB-compatible SATA PLL sequence

Peter De Schrijver (5):
      clk: tegra: fix vi_sensor clocks on Tegra124
      clk: flatten clk tree in debugfs
      clk: tegra124: init table updates
      clk: tegra: export clock names for debugging
      clk: define and export clk_debugs_add_file

Peter Ujfalusi (2):
      dt/bindings: Binding documentation for Palmas clk32kg and clk32kgaudio clocks
      clk: Add driver for Palmas clk32kg and clk32kgaudio clocks

Pratyush Anand (1):
      ARM: SPEAr13xx: Fix pcie clock name

Roger Quadros (1):
      CLK: ti: dra7: Initialize USB_DPLL

Sachin Kamat (1):
      clk: Fix build warnings

Srinivas Kandagatla (1):
      clk: qcom: add clocks necessary for apq8064 sdcc

Stephen Boyd (8):
      clkdev: Don't print errors on probe defer
      clk: qcom: Fully support apq8064 global clock control
      clk: qcom: Support bypass RCG configuration
      clk: qcom: Fix MN frequency tables, parent map, and jpegd
      clk: qcom: Fix PLL rate configurations
      clk: qcom: mdp_lut_clk is a child of mdp_src
      clk: qcom: pll: Add support for configuring SR PLLs
      clk: qcom: Add support for APQ8064 multimedia clocks

Sylwester Nawrocki (3):
      clk: samsung: Register clk provider only after registering its all clocks
      clk: Support for clock parents and rates assigned from device tree
      clk: Add missing of_clk_set_defaults export

Tero Kristo (1):
      MAINTAINERS: add TI Clock driver

Thomas Abraham (1):
      clk: samsung: register exynos5420 apll/kpll configuration data

Tomasz Figa (6):
      Merge branch 'v3.16-samsung-clk-fixes-1' into samsung-clk-next
      clk: samsung: exynos4: Add missing CPU/DMC clock hierarchy
      clk: samsung: exynos4: Add CLKOUT clock hierarchy
      clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
      ARM: dts: exynos: Update PMU node with CLKOUT related data
      clk: samsung: trivial: Correct typo in author's name

Vikas Sajjan (1):
      clk: samsung: exynos5420: Setup clocks before system suspend

 .../devicetree/bindings/arm/samsung/pmu.txt        |   30 +
 .../bindings/clock/clk-palmas-clk32kg-clocks.txt   |   35 +
 .../devicetree/bindings/clock/clock-bindings.txt   |   36 +
 .../devicetree/bindings/clock/clps711x-clock.txt   |   19 +
 .../devicetree/bindings/clock/qcom,gcc.txt         |    2 +
 .../devicetree/bindings/clock/qcom,mmcc.txt        |    2 +
 .../bindings/clock/rockchip,rk3188-cru.txt         |   61 +
 .../bindings/clock/rockchip,rk3288-cru.txt         |   61 +
 .../devicetree/bindings/clock/rockchip.txt         |    3 +
 .../bindings/clock/st/st,clkgen-divmux.txt         |   28 +-
 .../devicetree/bindings/clock/st/st,clkgen-mux.txt |    6 +-
 .../devicetree/bindings/clock/st/st,clkgen-pll.txt |   17 +-
 .../bindings/clock/st/st,clkgen-prediv.txt         |    8 +-
 .../devicetree/bindings/clock/st/st,clkgen-vcc.txt |   34 +-
 .../devicetree/bindings/clock/st/st,clkgen.txt     |   59 +-
 .../devicetree/bindings/clock/st/st,flexgen.txt    |  119 +
 .../devicetree/bindings/clock/st/st,quadfs.txt     |   15 +-
 Documentation/devicetree/bindings/clock/sunxi.txt  |    7 +
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/exynos4210.dtsi                  |   10 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |    7 +
 arch/arm/boot/dts/exynos5250.dtsi                  |    3 +
 arch/arm/boot/dts/exynos5420.dtsi                  |    3 +
 arch/arm/mach-rockchip/Kconfig                     |    1 +
 drivers/base/platform.c                            |    5 +
 drivers/clk/Kconfig                                |    7 +
 drivers/clk/Makefile                               |    5 +
 drivers/clk/at91/clk-main.c                        |    1 +
 drivers/clk/clk-clps711x.c                         |  192 ++
 drivers/clk/clk-composite.c                        |   79 +-
 drivers/clk/clk-conf.c                             |  144 +
 drivers/clk/clk-palmas.c                           |  307 ++
 drivers/clk/clk-ppc-corenet.c                      |    2 +-
 drivers/clk/clk-s2mps11.c                          |   33 +-
 drivers/clk/clk.c                                  |  134 +-
 drivers/clk/clkdev.c                               |    5 +-
 drivers/clk/qcom/Kconfig                           |   25 +
 drivers/clk/qcom/Makefile                          |    3 +
 drivers/clk/qcom/clk-pll.c                         |   15 +-
 drivers/clk/qcom/clk-pll.h                         |    2 +
 drivers/clk/qcom/clk-rcg.c                         |   51 +-
 drivers/clk/qcom/clk-rcg.h                         |    1 +
 drivers/clk/qcom/common.c                          |   39 +-
 drivers/clk/qcom/common.h                          |    6 +
 drivers/clk/qcom/gcc-apq8084.c                     | 3611 ++++++++++++++++++++
 drivers/clk/qcom/gcc-ipq806x.c                     | 2424 +++++++++++++
 drivers/clk/qcom/gcc-msm8960.c                     |  583 +++-
 drivers/clk/qcom/mmcc-apq8084.c                    | 3352 ++++++++++++++++++
 drivers/clk/qcom/mmcc-msm8960.c                    |  526 ++-
 drivers/clk/qcom/mmcc-msm8974.c                    |   10 +-
 drivers/clk/rockchip/Makefile                      |    6 +
 drivers/clk/rockchip/clk-pll.c                     |  431 +++
 drivers/clk/rockchip/clk-rk3188.c                  |  672 ++++
 drivers/clk/rockchip/clk-rk3288.c                  |  717 ++++
 drivers/clk/rockchip/clk.c                         |  244 ++
 drivers/clk/rockchip/clk.h                         |  347 ++
 drivers/clk/rockchip/softrst.c                     |  118 +
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos-clkout.c            |  153 +
 drivers/clk/samsung/clk-exynos3250.c               |   43 +
 drivers/clk/samsung/clk-exynos4.c                  |  231 +-
 drivers/clk/samsung/clk-exynos5250.c               |    4 +-
 drivers/clk/samsung/clk-exynos5260.c               |    2 +
 drivers/clk/samsung/clk-exynos5410.c               |    2 +
 drivers/clk/samsung/clk-exynos5420.c               |   61 +-
 drivers/clk/samsung/clk-exynos5440.c               |    4 +-
 drivers/clk/samsung/clk-s3c2410.c                  |    2 +
 drivers/clk/samsung/clk-s3c2412.c                  |    2 +
 drivers/clk/samsung/clk-s3c2443.c                  |    2 +
 drivers/clk/samsung/clk-s3c64xx.c                  |    2 +
 drivers/clk/samsung/clk.c                          |   21 +-
 drivers/clk/samsung/clk.h                          |    4 +-
 drivers/clk/spear/spear1310_clock.c                |    6 +-
 drivers/clk/spear/spear1340_clock.c                |    2 +-
 drivers/clk/st/Makefile                            |    2 +-
 drivers/clk/st/clk-flexgen.c                       |  331 ++
 drivers/clk/st/clkgen-fsyn.c                       |  223 +-
 drivers/clk/st/clkgen-mux.c                        |   12 +-
 drivers/clk/st/clkgen-pll.c                        |   94 +-
 drivers/clk/sunxi/Makefile                         |    4 +-
 drivers/clk/sunxi/clk-a20-gmac.c                   |    2 +-
 drivers/clk/sunxi/clk-factors.c                    |    2 +-
 drivers/clk/sunxi/clk-factors.h                    |    1 +
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c           |   76 +-
 drivers/clk/sunxi/clk-sun6i-apb0.c                 |    2 +-
 drivers/clk/sunxi/clk-sun6i-ar100.c                |    4 +-
 drivers/clk/sunxi/clk-sun8i-apb0.c                 |   68 +
 drivers/clk/sunxi/clk-sunxi.c                      |  129 +-
 drivers/clk/tegra/clk-pll.c                        |   19 +
 drivers/clk/tegra/clk-tegra-periph.c               |    4 +-
 drivers/clk/tegra/clk-tegra114.c                   |   31 +-
 drivers/clk/tegra/clk-tegra124.c                   |   10 +-
 drivers/clk/tegra/clk.c                            |    6 +
 drivers/clk/ti/clk-7xx.c                           |   11 +
 drivers/i2c/i2c-core.c                             |    5 +
 drivers/spi/spi.c                                  |    5 +
 include/dt-bindings/clock/clps711x-clock.h         |   27 +
 include/dt-bindings/clock/exynos4.h                |   25 +-
 include/dt-bindings/clock/exynos5250.h             |    2 +-
 include/dt-bindings/clock/exynos5420.h             |    2 +-
 include/dt-bindings/clock/exynos5440.h             |    2 +-
 include/dt-bindings/clock/qcom,gcc-apq8084.h       |  351 ++
 include/dt-bindings/clock/qcom,gcc-ipq806x.h       |  293 ++
 include/dt-bindings/clock/qcom,gcc-msm8960.h       |   11 +
 include/dt-bindings/clock/qcom,mmcc-apq8084.h      |  183 +
 include/dt-bindings/clock/qcom,mmcc-msm8960.h      |    8 +
 include/dt-bindings/clock/rk3066a-cru.h            |   35 +
 include/dt-bindings/clock/rk3188-cru-common.h      |  249 ++
 include/dt-bindings/clock/rk3188-cru.h             |   51 +
 include/dt-bindings/clock/rk3288-cru.h             |  278 ++
 include/dt-bindings/mfd/palmas.h                   |   18 +
 include/dt-bindings/reset/qcom,gcc-apq8084.h       |  109 +
 include/dt-bindings/reset/qcom,gcc-ipq806x.h       |  132 +
 include/dt-bindings/reset/qcom,gcc-msm8960.h       |   16 +
 include/dt-bindings/reset/qcom,mmcc-apq8084.h      |   64 +
 include/dt-bindings/reset/qcom,mmcc-msm8960.h      |    8 +
 include/linux/clk-provider.h                       |    5 +
 include/linux/clk/clk-conf.h                       |   20 +
 118 files changed, 17745 insertions(+), 397 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas-clk32kg-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clps711x-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/rockchip,rk3188-cru.txt
 create mode 100644 Documentation/devicetree/bindings/clock/rockchip,rk3288-cru.txt
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,flexgen.txt
 create mode 100644 drivers/clk/clk-clps711x.c
 create mode 100644 drivers/clk/clk-conf.c
 create mode 100644 drivers/clk/clk-palmas.c
 create mode 100644 drivers/clk/qcom/gcc-apq8084.c
 create mode 100644 drivers/clk/qcom/gcc-ipq806x.c
 create mode 100644 drivers/clk/qcom/mmcc-apq8084.c
 create mode 100644 drivers/clk/rockchip/clk-pll.c
 create mode 100644 drivers/clk/rockchip/clk-rk3188.c
 create mode 100644 drivers/clk/rockchip/clk-rk3288.c
 create mode 100644 drivers/clk/rockchip/clk.c
 create mode 100644 drivers/clk/rockchip/clk.h
 create mode 100644 drivers/clk/rockchip/softrst.c
 create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
 create mode 100644 drivers/clk/st/clk-flexgen.c
 create mode 100644 drivers/clk/sunxi/clk-sun8i-apb0.c
 create mode 100644 include/dt-bindings/clock/clps711x-clock.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-apq8084.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-ipq806x.h
 create mode 100644 include/dt-bindings/clock/qcom,mmcc-apq8084.h
 create mode 100644 include/dt-bindings/clock/rk3066a-cru.h
 create mode 100644 include/dt-bindings/clock/rk3188-cru-common.h
 create mode 100644 include/dt-bindings/clock/rk3188-cru.h
 create mode 100644 include/dt-bindings/clock/rk3288-cru.h
 create mode 100644 include/dt-bindings/mfd/palmas.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-apq8084.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-ipq806x.h
 create mode 100644 include/dt-bindings/reset/qcom,mmcc-apq8084.h
 create mode 100644 include/linux/clk/clk-conf.h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaFFXmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:42:36 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64277 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaFFXme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:42:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140606234227.10062.49153@quantum>
Subject: [GIT PULL] clk: changes for 3.16
Date: Fri, 06 Jun 2014 16:42:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.16

for you to fetch changes up to 3cbcb16095f916f50a5a55066fcc4be06946ce1e:

  mmc: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi SoCs (2014-06-03 16:52:34 -0700)

----------------------------------------------------------------
The clock framework changes for 3.16 are pretty typical: mostly clock
driver additions and fixes. There are additions to the clock core code
for some of the basic types (e.g. the common divider type has some fixes
and featured added to it).

One minor annoyance is a last-minute dependency that wasn't handled
quite right. ba0fae3 in this pull request depends on
include/dt-bindings/clock/berlin2.h, which is already in your tree via
the arm-soc pull request. Building for the berlin platform will break
when the clk tree is built on it's own, but merged into your master
branch everything should be fine.

----------------------------------------------------------------
Alex Elder (13):
      clk: bcm281xx: warn if ccu_wait_bit() fails
      clk: bcm281xx: use init_data.name for clock name
      clk: bcm281xx: change some symbol names
      clk: bcm281xx: initialize CCU structures statically
      clk: bcm281xx: define CCU clock data statically
      clk: bcm281xx: add clock policy support
      clk: bcm281xx: add clock hysteresis support
      clk: bcm281xx: move compatible string definitions
      ARM: dts: revise kona clock binding document
      ARM: dts: define clock binding for bcm21664
      clk: bcm21664: use common clock framework
      ARM: dts: use real clocks for bcm21664
      clk: bcm/kona: implement determine_rate()

Alexandre Belloni (3):
      clk: berlin: add driver for BG2x simple PLLs
      clk: berlin: add driver for BG2x complex divider cells
      clk: berlin: add core clock driver for BG2Q

Anders Berg (1):
      clk: Add clock driver for AXM55xx SoC

Andrew Bresticker (2):
      clk: tegra: Fix xusb_hs_src clock hierarchy
      clk: tegra: Initialize xusb clocks

Arnd Bergmann (2):
      clk/versatile: export symbols for impd1
      clk: export __clk_round_rate for providers

Boris BREZILLON (1):
      MAINTAINERS: add AT91 Clock Support entry

Colin Ian King (1):
      clk: versatile: free icst on error return

David Lanzendörfer (1):
      mmc: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi SoCs

Dinh Nguyen (1):
      clk: socfpga: add divider registers to the main pll outputs

Emilio López (2):
      clk: sunxi: factors: automatic reparenting support
      clk: sunxi: Implement MMC phase control

Fabio Estevam (1):
      Documentation: clock: fixed-clock: Remove unsupported 'gpios' property

Geert Uytterhoeven (4):
      clk: Fixup spacing in comments
      clk: Improve clk_ops documentation
      clk: Improve clock-indices binding documentation
      clk: Neaten clk_summary output

Georgi Djakov (1):
      clk: qcom: Fix blsp2_ahb_clk register offset

Hans de Goede (1):
      clk: sunxi: Fixup clk_sunxi_mmc_phase_control to take a clk rather then a hw_clk

Heiko Stuebner (1):
      clk: divider: add CLK_DIVIDER_READ_ONLY flag

Jim Lin (2):
      clk: tegra: Enable hardware control of PLLE
      clk: tegra: Fix xusb_fs_src mux

Krzysztof Kozlowski (3):
      clk: s2mps11: Add missing of_node_put and of_clk_del_provider
      clk: s2mps11: Remove useless check for clk_table
      clk: s2mps11: Add support for S2MPS14 clocks

Kumar Gala (2):
      clk: qcom: Add basic support for APQ8064 global clock controller clocks
      clk: qcom: Various fixes for MSM8960's global clock controller

Laurent Pinchart (1):
      clk: shmobile: mstp: Fix the is_enabled() operation

Linus Walleij (1):
      clk: impd1: add pclk clocks

Maxime COQUELIN (3):
      clk: divider: Add round to closest divider
      clk: divider: Optimize clk_divider_bestdiv loop
      clk: divider: Fix table round up function

Michal Simek (1):
      clk: si570: Fix email address specifiction

Mike Turquette (10):
      Merge branch 'clk-fixes' into clk-next
      Merge tag 'socfpga-clk-update-for-v3.16' of git://git.rocketboards.org/linux-socfpga-next into clk-next-socfpga
      Merge tag 'clk-mvebu-3.16' of git://git.infradead.org/linux-mvebu into clk-next-mvebu
      Merge tag 'clk-hisi-for-v3.16' of https://git.kernel.org/.../hzhuang1/linux into clk-next-hisilicon
      Merge branch 'clk-fixes' into clk-next
      Merge tag 'zynq-clk-for-3.16' of git://git.xilinx.com/linux-xlnx into clk-next-zynq
      Merge remote-tracking branch 'linaro/clk-next' into clk-next
      Merge branch 'clk-fixes' into clk-next
      Merge tag 'clk-tegra-fixes-3.15' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-fixes
      Merge branch 'clk-fixes' into clk-next

Sachin Kamat (1):
      clk/exynos4: Fix compilation warning

Sebastian Hesselbarth (2):
      clk: berlin: add driver for BG2x audio/video PLL
      clk: berlin: add core clock driver for BG2/BG2CD

Simon Horman (3):
      clk: shmobile: r8a7779: Add clocks support
      clk: shmobile: r8a7779: Add MSTP clock support
      ARM: shmobile: r8a7779: Add clock index macros for DT sources

Soren Brinkmann (1):
      clk: zynq: Leave debug clocks in bootup state

Stephen Boyd (14):
      clk: Don't check for missing ops in clk_set_parent()
      clk: Consolidate recalc rate logic
      clk: Ignore error and NULL pointers passed to clk_{unprepare, disable}()
      clk: qcom: Consolidate common probe code
      clk: qcom: Fix msm8660 GCC probe
      clk: u300: Terminate of match table
      clk: st: Terminate of match table
      clk: qcom: Fix clk_rcg2_is_enabled() check
      clk: qcom: Fix mmcc-8974's PLL configurations
      clk: qcom: Return highest rate when round_rate() exceeds plan
      clk: qcom: Support display RCG clocks
      clk: qcom: Properly support display clocks on msm8974
      clk: qcom: Support msm8974pro global clock control hardware
      clk: qcom: Return error pointers for unimplemented clocks

Sylwester Nawrocki (1):
      clk: Add of_clk_get_by_clkspec() helper

Thierry Reding (3):
      clk: tegra: Fix PLLE programming
      clk: tegra: Introduce divider mask and shift helpers
      clk: tegra: Fix enabling of PLLE

Thomas Petazzoni (1):
      clk: mvebu: add Orion5x clock driver

Tomasz Figa (1):
      clk: divider: Fix overflow in clk_divider_bestdiv

Ulrich Hecht (1):
      clk: shmobile: Add R8A7740-specific clock support

Valentin Ilie (1):
      clk: st: Fix memory leak

Zhangfei Gao (3):
      clk: hisi: use clk_register_mux_table in hisi_clk_register_mux
      clk: hisi: add hisi_clk_register_gate
      clk: hisi: add clk-hix5hd2.c

 Documentation/clk.txt                              |   16 +-
 .../devicetree/bindings/clock/bcm-kona-clock.txt   |  116 ++-
 .../devicetree/bindings/clock/clock-bindings.txt   |    9 +-
 .../devicetree/bindings/clock/fixed-clock.txt      |    1 -
 .../devicetree/bindings/clock/hix5hd2-clock.txt    |   31 +
 .../devicetree/bindings/clock/lsi,axm5516-clks.txt |   29 +
 .../devicetree/bindings/clock/mvebu-core-clock.txt |    8 +
 .../devicetree/bindings/clock/qcom,gcc.txt         |    3 +
 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |    1 +
 .../bindings/clock/renesas,r8a7740-cpg-clocks.txt  |   41 +
 .../bindings/clock/renesas,r8a7779-cpg-clocks.txt  |   27 +
 .../devicetree/bindings/mmc/sunxi-mmc.txt          |   43 +
 MAINTAINERS                                        |    5 +
 arch/arm/boot/dts/bcm21664.dtsi                    |  164 +--
 drivers/clk/Kconfig                                |    8 +-
 drivers/clk/Makefile                               |    3 +
 drivers/clk/bcm/Kconfig                            |    2 +-
 drivers/clk/bcm/Makefile                           |    1 +
 drivers/clk/bcm/clk-bcm21664.c                     |  290 ++++++
 drivers/clk/bcm/clk-bcm281xx.c                     |  231 ++---
 drivers/clk/bcm/clk-kona-setup.c                   |  229 +++--
 drivers/clk/bcm/clk-kona.c                         |  266 ++++-
 drivers/clk/bcm/clk-kona.h                         |  160 ++-
 drivers/clk/berlin/Makefile                        |    4 +
 drivers/clk/berlin/berlin2-avpll.c                 |  393 ++++++++
 drivers/clk/berlin/berlin2-avpll.h                 |   36 +
 drivers/clk/berlin/berlin2-div.c                   |  265 +++++
 drivers/clk/berlin/berlin2-div.h                   |   89 ++
 drivers/clk/berlin/berlin2-pll.c                   |  117 +++
 drivers/clk/berlin/berlin2-pll.h                   |   37 +
 drivers/clk/berlin/bg2.c                           |  691 +++++++++++++
 drivers/clk/berlin/bg2q.c                          |  389 ++++++++
 drivers/clk/berlin/common.h                        |   29 +
 drivers/clk/clk-axm5516.c                          |  615 ++++++++++++
 drivers/clk/clk-divider.c                          |   95 +-
 drivers/clk/clk-s2mps11.c                          |   88 +-
 drivers/clk/clk-si570.c                            |    2 +-
 drivers/clk/clk-u300.c                             |    1 +
 drivers/clk/clk.c                                  |   47 +-
 drivers/clk/clk.h                                  |    1 +
 drivers/clk/clkdev.c                               |   34 +-
 drivers/clk/hisilicon/Makefile                     |    1 +
 drivers/clk/hisilicon/clk-hix5hd2.c                |  101 ++
 drivers/clk/hisilicon/clk.c                        |   41 +-
 drivers/clk/hisilicon/clk.h                        |    3 +
 drivers/clk/mvebu/Kconfig                          |    4 +
 drivers/clk/mvebu/Makefile                         |    1 +
 drivers/clk/mvebu/orion.c                          |  210 ++++
 drivers/clk/qcom/Kconfig                           |    4 +-
 drivers/clk/qcom/Makefile                          |    1 +
 drivers/clk/qcom/clk-rcg.h                         |    3 +
 drivers/clk/qcom/clk-rcg2.c                        |  304 +++++-
 drivers/clk/qcom/common.c                          |  101 ++
 drivers/clk/qcom/common.h                          |   34 +
 drivers/clk/qcom/gcc-msm8660.c                     |   77 +-
 drivers/clk/qcom/gcc-msm8960.c                     |  109 +-
 drivers/clk/qcom/gcc-msm8974.c                     |  207 ++--
 drivers/clk/qcom/mmcc-msm8960.c                    |   78 +-
 drivers/clk/qcom/mmcc-msm8974.c                    |  198 ++--
 drivers/clk/samsung/clk-exynos4.c                  |    4 +-
 drivers/clk/shmobile/Makefile                      |    2 +
 drivers/clk/shmobile/clk-mstp.c                    |    2 +-
 drivers/clk/shmobile/clk-r8a7740.c                 |  199 ++++
 drivers/clk/shmobile/clk-r8a7779.c                 |  180 ++++
 drivers/clk/socfpga/clk-gate.c                     |    1 -
 drivers/clk/socfpga/clk-periph.c                   |   22 +-
 drivers/clk/socfpga/clk.h                          |    4 +
 drivers/clk/st/clkgen-pll.c                        |    5 +-
 drivers/clk/sunxi/clk-factors.c                    |   36 +
 drivers/clk/sunxi/clk-sunxi.c                      |   37 +
 drivers/clk/tegra/clk-id.h                         |    1 +
 drivers/clk/tegra/clk-pll.c                        |   97 +-
 drivers/clk/tegra/clk-tegra-periph.c               |   10 +-
 drivers/clk/tegra/clk-tegra114.c                   |   22 +-
 drivers/clk/tegra/clk-tegra124.c                   |   21 +-
 drivers/clk/versatile/clk-icst.c                   |    2 +
 drivers/clk/versatile/clk-impd1.c                  |   38 +-
 drivers/clk/zynq/clkc.c                            |   12 +
 drivers/mmc/host/Kconfig                           |    7 +
 drivers/mmc/host/Makefile                          |    1 +
 drivers/mmc/host/sunxi-mmc.c                       | 1049 ++++++++++++++++++++
 include/dt-bindings/clock/bcm21664.h               |   62 ++
 include/dt-bindings/clock/bcm281xx.h               |   12 +
 include/dt-bindings/clock/hix5hd2-clock.h          |   58 ++
 include/dt-bindings/clock/qcom,gcc-msm8960.h       |    7 +-
 include/dt-bindings/clock/qcom,gcc-msm8974.h       |    4 +
 include/dt-bindings/clock/r8a7779-clock.h          |   64 ++
 include/dt-bindings/clock/tegra114-car.h           |    3 +-
 include/dt-bindings/clock/tegra124-car.h           |    3 +-
 include/dt-bindings/reset/qcom,gcc-msm8960.h       |    2 +-
 include/linux/clk-provider.h                       |  127 +--
 include/linux/clk/shmobile.h                       |    3 +
 include/linux/clk/sunxi.h                          |   22 +
 93 files changed, 7265 insertions(+), 948 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/hix5hd2-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/lsi,axm5516-clks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,r8a7740-cpg-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/renesas,r8a7779-cpg-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/sunxi-mmc.txt
 create mode 100644 drivers/clk/bcm/clk-bcm21664.c
 create mode 100644 drivers/clk/berlin/Makefile
 create mode 100644 drivers/clk/berlin/berlin2-avpll.c
 create mode 100644 drivers/clk/berlin/berlin2-avpll.h
 create mode 100644 drivers/clk/berlin/berlin2-div.c
 create mode 100644 drivers/clk/berlin/berlin2-div.h
 create mode 100644 drivers/clk/berlin/berlin2-pll.c
 create mode 100644 drivers/clk/berlin/berlin2-pll.h
 create mode 100644 drivers/clk/berlin/bg2.c
 create mode 100644 drivers/clk/berlin/bg2q.c
 create mode 100644 drivers/clk/berlin/common.h
 create mode 100644 drivers/clk/clk-axm5516.c
 create mode 100644 drivers/clk/hisilicon/clk-hix5hd2.c
 create mode 100644 drivers/clk/mvebu/orion.c
 create mode 100644 drivers/clk/qcom/common.c
 create mode 100644 drivers/clk/qcom/common.h
 create mode 100644 drivers/clk/shmobile/clk-r8a7740.c
 create mode 100644 drivers/clk/shmobile/clk-r8a7779.c
 create mode 100644 drivers/mmc/host/sunxi-mmc.c
 create mode 100644 include/dt-bindings/clock/bcm21664.h
 create mode 100644 include/dt-bindings/clock/hix5hd2-clock.h
 create mode 100644 include/dt-bindings/clock/r8a7779-clock.h
 create mode 100644 include/linux/clk/sunxi.h

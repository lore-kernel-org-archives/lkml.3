Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3D2R0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:26:16 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61878 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3D2R0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:26:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
User-Agent: alot/0.3.4
To: torvalds@linux-foundation.org
Message-ID: <20130429172606.8923.61396@quantum>
Subject: [GIT PULL] clk: changes for 3.10
Date: Mon, 29 Apr 2013 10:26:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus-3.10

for you to fetch changes up to 1e435256d625c203660f0105f1155cd2af283051:

  clk: add clk_ignore_unused option to keep boot clocks on (2013-04-27 23:03:43 -0700)

----------------------------------------------------------------
The common clock framework changes for 3.10 include many fixes for
existing platforms, as well as adoption of the framework by new
platforms and devices.  Some long-needed fixes to the core framework are
here as well as new features such as improved initialization of clocks
from DT as well as framework reentrancy for nested clock operations.

----------------------------------------------------------------
Axel Lin (1):
      clk: mvebu: Fix valid value range checking for cpu_freq_select

Eduardo Valentin (1):
      documentation: clk: fix couple of misspelling

Emilio López (7):
      clk: arm: sunxi: Add a new clock driver for sunxi SOCs
      arm: sunxi: Add useful information about sunxi clocks
      clk: sunxi: rename compatible strings
      clk: sunxi: Add support for AXI, AHB, APB0 and APB1 gates
      clk: sunxi: drop CLK_IGNORE_UNUSED
      clk: sunxi: drop an unnecesary kmalloc
      clk: sunxi: Unify oscillator clock

Fabio Estevam (2):
      clk: mxs: Fix sparse warnings
      ARM: imx: adapt clk_busy_mux to new clk_mux struct

Gregory CLEMENT (1):
      clk: add device tree fixed-factor-clock binding support

James Hogan (1):
      clk: fix clk_mux::flags kerneldoc

Jean-Francois Moine (1):
      clk: mvebu: Use common of_clk_init() function

Lars-Peter Clausen (1):
      clk: Add axi-clkgen driver

Maxime Coquelin (1):
      clk: ux500: Fix prcmu clocks registration

Michal Simek (1):
      clk: zynq: Add missing zynq clk header

Mike Turquette (5):
      clk: abstract locking out into helper functions
      clk: allow reentrant calls into the clk framework
      clk: composite: rename 'div' references to 'rate'
      clk: composite: allow fixed rates & fixed dividers
      clk: ux500: fix mismatched types

Olof Johansson (1):
      clk: add clk_ignore_unused option to keep boot clocks on

Pawel Moll (1):
      clk: vexpress: Add separate SP810 driver

Peter De Schrijver (1):
      clk: add table lookup to mux

Prashant Gaikwad (1):
      clk: Add composite clock type

Sachin Kamat (1):
      clk: Fix incorrect return type in clk.c

Sebastian Hesselbarth (3):
      clk: add si5351 i2c common clock driver
      clk: export __clk_get_flags for modular clock providers
      clk: si5351: make clk-si5351 depend on CONFIG_OF

Soren Brinkmann (2):
      clk: divider: Introduce CLK_DIVIDER_ALLOW_ZERO flag
      clk: Properly handle notifier return values

Tony Prisk (1):
      clk: vt8500: Missing breaks in vtwm_pll_round_rate/_set_rate.

Ulf Hansson (9):
      clk: Introduce optional is_prepared callback
      clk: Unprepare the unused prepared slow clocks at late init
      clk: Introduce optional unprepare_unused callback
      clk: ux500: Support is_prepared callback for clk-prcmu
      clk: Restructure code for __clk_reparent
      clk: Fixup errorhandling for clk_set_parent
      clk: Fixup locking issues for clk_set_parent
      clk: ux500: Add support for sysctrl clocks
      clk: ux500: abx500: Define clock tree for ab850x

Vipul Kumar Samar (1):
      clk:SPEAr1340: Correct parent clock configuration

Wei Yongjun (1):
      clk: prima2: fix return value check in sirfsoc_of_clk_init()

 Documentation/arm/sunxi/clocks.txt                 |   56 +
 Documentation/clk.txt                              |   15 +-
 .../devicetree/bindings/clock/axi-clkgen.txt       |   22 +
 .../bindings/clock/fixed-factor-clock.txt          |   24 +
 .../devicetree/bindings/clock/silabs,si5351.txt    |  114 ++
 Documentation/devicetree/bindings/clock/sunxi.txt  |  151 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/kernel-parameters.txt                |    8 +
 arch/arm/mach-imx/clk-busy.c                       |    2 +-
 arch/arm/mach-vexpress/v2m.c                       |    8 +-
 drivers/clk/Kconfig                                |   18 +
 drivers/clk/Makefile                               |    4 +
 drivers/clk/clk-axi-clkgen.c                       |  331 +++++
 drivers/clk/clk-composite.c                        |  210 +++
 drivers/clk/clk-divider.c                          |    5 +-
 drivers/clk/clk-fixed-factor.c                     |   36 +
 drivers/clk/clk-mux.c                              |   50 +-
 drivers/clk/clk-prima2.c                           |    2 +-
 drivers/clk/clk-si5351.c                           | 1510 ++++++++++++++++++++
 drivers/clk/clk-si5351.h                           |  155 ++
 drivers/clk/clk-vt8500.c                           |    2 +
 drivers/clk/clk-zynq.c                             |    1 +
 drivers/clk/clk.c                                  |  406 ++++--
 drivers/clk/mvebu/clk-core.c                       |    4 +-
 drivers/clk/mvebu/clk-cpu.c                        |   17 +-
 drivers/clk/mvebu/clk-cpu.h                        |   22 -
 drivers/clk/mvebu/clk.c                            |    6 +-
 drivers/clk/mxs/clk.c                              |    1 +
 drivers/clk/spear/spear1340_clock.c                |   18 +-
 drivers/clk/sunxi/Makefile                         |    5 +
 drivers/clk/sunxi/clk-factors.c                    |  180 +++
 drivers/clk/sunxi/clk-factors.h                    |   27 +
 drivers/clk/sunxi/clk-sunxi.c                      |  469 ++++++
 drivers/clk/tegra/clk.h                            |   27 +-
 drivers/clk/ux500/Makefile                         |    1 +
 drivers/clk/ux500/abx500-clk.c                     |   71 +-
 drivers/clk/ux500/clk-prcmu.c                      |  136 +-
 drivers/clk/ux500/clk-sysctrl.c                    |  221 +++
 drivers/clk/ux500/clk.h                            |   34 +-
 drivers/clk/versatile/Makefile                     |    2 +-
 drivers/clk/versatile/clk-sp810.c                  |  188 +++
 drivers/clk/versatile/clk-vexpress.c               |   49 -
 drivers/clocksource/sunxi_timer.c                  |    4 +-
 include/linux/clk-private.h                        |    2 +-
 include/linux/clk-provider.h                       |   63 +-
 include/linux/clk.h                                |    8 +-
 include/linux/clk/sunxi.h                          |   22 +
 include/linux/platform_data/si5351.h               |  114 ++
 48 files changed, 4518 insertions(+), 304 deletions(-)
 create mode 100644 Documentation/arm/sunxi/clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/axi-clkgen.txt
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-factor-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/silabs,si5351.txt
 create mode 100644 Documentation/devicetree/bindings/clock/sunxi.txt
 create mode 100644 drivers/clk/clk-axi-clkgen.c
 create mode 100644 drivers/clk/clk-composite.c
 create mode 100644 drivers/clk/clk-si5351.c
 create mode 100644 drivers/clk/clk-si5351.h
 delete mode 100644 drivers/clk/mvebu/clk-cpu.h
 create mode 100644 drivers/clk/sunxi/Makefile
 create mode 100644 drivers/clk/sunxi/clk-factors.c
 create mode 100644 drivers/clk/sunxi/clk-factors.h
 create mode 100644 drivers/clk/sunxi/clk-sunxi.c
 create mode 100644 drivers/clk/ux500/clk-sysctrl.c
 create mode 100644 drivers/clk/versatile/clk-sp810.c
 create mode 100644 include/linux/clk/sunxi.h
 create mode 100644 include/linux/platform_data/si5351.h

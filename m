Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaFOHiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 03:38:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59445 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaFOHiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 03:38:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20140615073805.6562.72932@quantum>
Subject: [GIT PULL] clk: changes for 3.16, part 2
Date: Sun, 15 Jun 2014 00:38:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 963649d735c8b6eb0f97e82c54f02426ff3f1f45:

  Merge tag 'for-linus-3.16-merge-window' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs (2014-06-08 14:35:19 -0700)

are available in the git repository at:


  git://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.16-part2

for you to fetch changes up to b640a6037c9ecd1f0ad23a8e9b4ca5f5b4112508:

  Merge tag 'sunxi-clk-for-3.16-2' of https://github.com/mripard/linux into clk-next (2014-06-11 07:11:59 -0700)

----------------------------------------------------------------

This pull request contains the second half the of the clk changes for
3.16. They are simply fixes and code refactoring for the OMAP clock
drivers. The sunxi clock driver changes include splitting out the one
mega-driver into several smaller pieces and adding support for the A31
SoC clocks.

----------------------------------------------------------------
Andrii Tseglytskyi (1):
      ARM: OMAP5+: dpll: support Duty Cycle Correction(DCC)

Boris BREZILLON (2):
      clk: sunxi: add PRCM (Power/Reset/Clock Management) clks support
      clk: sunxi: document PRCM clock compatible strings

Emilio López (1):
      clk: sunxi: document new A31 USB clock compatible

Maxime Ripard (7):
      clk: sunxi: Implement A31 USB clock
      clk: sunxi: Remove calls to clk_put
      clk: sunxi: Move the 24M oscillator to a file of its own
      clk: sunxi: Move the GMAC clock to a file of its own
      clk: sunxi: Rework clock protection code
      clk: sun6i: Protect CPU clock
      clk: sun6i: Protect SDRAM gating bit

Mike Turquette (2):
      Merge branch 'for-v3.16/ti-clk-drv' of github.com:t-kristo/linux-pm into clk-next
      Merge tag 'sunxi-clk-for-3.16-2' of https://github.com/mripard/linux into clk-next

Nishanth Menon (2):
      CLK: TI: dpll: support OMAP5 MPU DPLL that need special handling for higher frequencies
      ARM: dts: OMAP5/DRA7: use omap5-mpu-dpll-clock capable of dealing with higher frequencies

Peter Ujfalusi (4):
      ARM: dts: dra7xx-clocks: Correct name for atl clkin3 clock
      dt:/bindings: DRA7 ATL (Audio Tracking Logic) clock bindings
      CLK: TI: Driver for DRA7 ATL (Audio Tracking Logic)
      CLK: TI: clk-54xx: Set the rate for dpll_abe_m2x2_ck

Tero Kristo (8):
      CLK: TI: DPLL: simplify autoidle register detection logic
      CLK: TI: DPLL: add support for omap2 core dpll
      CLK: TI: APLL: add support for omap2 aplls
      CLK: TI: gate: fixed DT binding documentation bugs
      CLK: TI: interface: add support for omap2430 specific interface clock
      CLK: TI: OMAP2: add clock init support
      ARM: OMAP2: clock: add DT boot support for cpufreq_ck
      CLK: TI: gate: add composite interface clock to OMAP2 only build

 Documentation/devicetree/bindings/clock/sunxi.txt  |   4 +
 .../devicetree/bindings/clock/ti/apll.txt          |  24 +-
 .../devicetree/bindings/clock/ti/dpll.txt          |  10 +
 .../devicetree/bindings/clock/ti/dra7-atl.txt      |  96 +++++++
 .../devicetree/bindings/clock/ti/gate.txt          |  29 +-
 .../devicetree/bindings/clock/ti/interface.txt     |   2 +
 arch/arm/boot/dts/dra7xx-clocks.dtsi               |  24 +-
 arch/arm/boot/dts/omap54xx-clocks.dtsi             |   2 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c       |  53 ++++
 arch/arm/mach-omap2/clock.h                        |  13 -
 arch/arm/mach-omap2/clock2xxx.h                    |   4 -
 arch/arm/mach-omap2/dpll3xxx.c                     |   9 +
 drivers/clk/sunxi/Makefile                         |   4 +
 drivers/clk/sunxi/clk-a10-hosc.c                   |  73 +++++
 drivers/clk/sunxi/clk-a20-gmac.c                   | 119 ++++++++
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c           |  99 +++++++
 drivers/clk/sunxi/clk-sun6i-apb0.c                 |  77 +++++
 drivers/clk/sunxi/clk-sun6i-ar100.c                | 233 +++++++++++++++
 drivers/clk/sunxi/clk-sunxi.c                      | 239 ++++------------
 drivers/clk/ti/Makefile                            |   4 +-
 drivers/clk/ti/apll.c                              | 181 ++++++++++++
 drivers/clk/ti/clk-2xxx.c                          | 256 +++++++++++++++++
 drivers/clk/ti/clk-54xx.c                          |   6 +
 drivers/clk/ti/clk-7xx.c                           |   2 +-
 drivers/clk/ti/clk-dra7-atl.c                      | 312 +++++++++++++++++++++
 drivers/clk/ti/dpll.c                              | 138 ++++++---
 drivers/clk/ti/gate.c                              |   2 +-
 drivers/clk/ti/interface.c                         |  11 +
 include/dt-bindings/clk/ti-dra7-atl.h              |  40 +++
 include/linux/clk/ti.h                             |  35 ++-
 30 files changed, 1836 insertions(+), 265 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/ti/dra7-atl.txt
 create mode 100644 drivers/clk/sunxi/clk-a10-hosc.c
 create mode 100644 drivers/clk/sunxi/clk-a20-gmac.c
 create mode 100644 drivers/clk/sunxi/clk-sun6i-apb0-gates.c
 create mode 100644 drivers/clk/sunxi/clk-sun6i-apb0.c
 create mode 100644 drivers/clk/sunxi/clk-sun6i-ar100.c
 create mode 100644 drivers/clk/ti/clk-2xxx.c
 create mode 100644 drivers/clk/ti/clk-dra7-atl.c
 create mode 100644 include/dt-bindings/clk/ti-dra7-atl.h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637Ab3DCOnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:43:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18024 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab3DCOnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:43:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 03 Apr 2013 07:42:09 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <achew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 00/14] Tegra114 clockframework
Date: Wed, 3 Apr 2013 17:40:34 +0300
Message-ID: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the nineth version of the Tegra114 clockframework. It is based on the
next-20130320-fixed branch of
git://nv-tegra.nvidia.com/user/swarren/linux-2.6.git,
http://patchwork.ozlabs.org/patch/229972/ and
http://patchwork.ozlabs.org/patch/229978/ and
http://patchwork.ozlabs.org/patch/233415/

It has been boottested on Dalmore.

Changes from v8:

* Added pdiv table for PLLU
* Fixed clock initialization for audio

Changes from v7:

* Fixed dummy operations
* Removed some duplicates from the binding document
* Fixed tegra114_clk enum to be in line with the binding document
* Removed __initdata from tegra_periph_clk_list and
  tegra_periph_nodiv_clk_list
* Mark csite clock as CLK_IGNORE_UNUSED
* Fixed mux mask for disp1 and disp2
* Fixed initializations for PLLX, PLLC, PLLC2 and PLCC3
* Converted clk_pll_wait_for_lock() to use a mask instead of a single bit
* added TEGRA_PLL_HAS_LOCK_ENABLE flag

Changes from v6:

* Remove clock-frequency from DT serial nodes
* Remove useless 'cpu' clock from binding documentation
* Use HW gate control for PLLU divided outputs
* Fix clock ID for 'd_audio' clock
* Add dummy cpu car ops to ease making a bisectable series

Changes from v5:

* Add initialization code for PLLC
* Remove some unnecessary clocks
* Fix bug in PLL locking refactoring
* Add super clocks
* Remove most calls to clk_register_clkdev() for the peripheral clocks

Changes from v4:

* Split the new PLL types patch into smaller patches
* Fix some bugs in the PLL patches

Changes from v3:

* Merge with for-next branch
* Provide empty tegra_cpu_car_ops to make SMP boot not crash

Changes from v2:

* Added missing PLLs
* Added bindings to tegra114.dtsi
* Moved the table patch for clk-mux.c to 'clk: add table lookup to mux'
* Bugfixes

Changes from v1:

* Remove SATA and PCIe clocks. They don't appear in the internal TRM, so I
  assume they don't exist.
* Rebase on top of Hiroshi's latest Tegra114 patches
* More generic mux code. This is necessary for the AHUB and DAM clocks.


Peter De Schrijver (14):
  clk: tegra: provide dummy cpu car ops
  clk: tegra: Refactor PLL programming code
  clk: tegra: Add TEGRA_PLL_BYPASS flag
  clk: tegra: introduce TEGRA_PLL_HAS_LOCK_ENABLE
  clk: tegra: Add PLL post divider table
  clk: tegra: move from a lock bit idx to a lock mask
  clk: tegra: Add new fields and PLL types for Tegra114
  clk: tegra: Add flags to tegra_clk_periph()
  clk: tegra: Workaround for Tegra114 MSENC problem
  ARM: tegra: Define Tegra114 CAR binding
  clk: tegra: Implement clocks for Tegra114
  clk: tegra: devicetree match for nvidia,tegra114-car
  ARM: dt: Add references to tegra_car clocks
  clk: tegra: Remove forced clk_enable of uartd

 .../bindings/clock/nvidia,tegra114-car.txt         |  317 +++
 arch/arm/boot/dts/tegra114-dalmore.dts             |    1 -
 arch/arm/boot/dts/tegra114-pluto.dts               |    1 -
 arch/arm/boot/dts/tegra114.dtsi                    |    8 +-
 drivers/clk/tegra/Makefile                         |    1 +
 drivers/clk/tegra/clk-periph-gate.c                |    9 +
 drivers/clk/tegra/clk-periph.c                     |   11 +-
 drivers/clk/tegra/clk-pll.c                        | 1194 ++++++++++--
 drivers/clk/tegra/clk-tegra114.c                   | 2085 ++++++++++++++++++++
 drivers/clk/tegra/clk-tegra20.c                    |  173 +-
 drivers/clk/tegra/clk-tegra30.c                    |  265 ++--
 drivers/clk/tegra/clk.c                            |    4 +-
 drivers/clk/tegra/clk.h                            |   95 +-
 13 files changed, 3805 insertions(+), 359 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt
 create mode 100644 drivers/clk/tegra/clk-tegra114.c

-- 
1.7.7.rc0.72.g4b5ea.dirty


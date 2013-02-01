Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3BAKST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:18:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17172 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3BAKSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:18:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 01 Feb 2013 02:16:17 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: "moderated list:OPEN FIRMWARE AND..." 
	<devicetree-discuss@lists.ozlabs.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:TEGRA SUPPORT" <linux-tegra@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v5 00/10] Tegra114 clockframework
Date: Fri, 1 Feb 2013 12:16:42 +0200
Message-ID: <1359713860-16631-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth version of the Tegra114 clockframework. It is based on the
for-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git and
http://www.spinics.net/lists/arm-kernel/msg220452.html.

It has been boottested on Pluto.

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

TODO:

* Remove clk_register_clkdev() where possible
* PLL clock init functions are incomplete and/or need refactoring
* Superclocks are missing
* The audio clocks are almost the same then Tegra30. Refactor the code to
  avoid duplication.
* Should blink and blink_override be clocks?

Peter De Schrijver (10):
  clk: tegra: Refactor PLL programming code
  clk: tegra: Add TEGRA_PLL_BYPASS flag
  clk: tegra: Add PLL post divider table
  clk: tegra: Add new fields and PLL types for Tegra114
  clk: tegra: Add flags to tegra_clk_periph()
  clk: tegra: Workaround for Tegra114 MSENC problem
  ARM: tegra: Define Tegra114 CAR binding
  ARM: dt: Add references to tegra_car clocks
  clk: tegra: Implement clocks for Tegra114
  clk: tegra: devicetree match for nvidia,tegra114-car

 .../bindings/clock/nvidia,tegra114-car.txt         |  311 +++
 arch/arm/boot/dts/tegra114.dtsi                    |    7 +-
 drivers/clk/tegra/Makefile                         |    1 +
 drivers/clk/tegra/clk-periph-gate.c                |    9 +
 drivers/clk/tegra/clk-periph.c                     |   11 +-
 drivers/clk/tegra/clk-pll.c                        |  940 +++++++++-
 drivers/clk/tegra/clk-tegra114.c                   | 2002 ++++++++++++++++++++
 drivers/clk/tegra/clk-tegra20.c                    |  153 +-
 drivers/clk/tegra/clk-tegra30.c                    |  243 ++--
 drivers/clk/tegra/clk.c                            |    1 +
 drivers/clk/tegra/clk.h                            |   85 +-
 11 files changed, 3481 insertions(+), 282 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra114-car.txt
 create mode 100644 drivers/clk/tegra/clk-tegra114.c


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3JUN4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:56:46 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5891 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3JUN4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:56:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Oct 2013 06:52:05 -0700
Date: Mon, 21 Oct 2013 16:56:38 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: pull request for Tegra clock rework and Tegra124 clock support
Message-ID: <20131021135638.GA10943@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

This pull request contains both the tegra clock rework patches
([PATCH v6 00/15] Introduce common infra for tegra clocks)
and the patches to support Tegra124 ([PATCH v4 0/7] Tegra124 clock support)

The following changes since commit d031acfc0b8376209e5b429513766e7028e40e1d:

  clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d (2013-10-16 19:49:25 +0300)

are available in the git repository at:
  git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-tegra124-0

Joseph Lo (2):
      clk: tegra124: add wait_for_reset and disable_clock for tegra_cpu_car_ops
      clk: tegra124: add suspend/resume function for tegra_cpu_car_ops

Peter De Schrijver (20):
      ARM: tegra30: add missing CLK IDs
      clk: tegra: simplify periph clock data
      clk: tegra: common periph_clk_enb_refcnt and clks
      clk: tegra: Add TEGRA_PERIPH_NO_DIV flag
      clk: tegra: move some PLLC and PLLXC init to clk-pll.c
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
      clk: tegra124: Add common clk IDs to clk-id.h
      clk: tegra124: Add new peripheral clocks
      clk: tegra124: Add support for Tegra124 clocks

 .../bindings/clock/nvidia,tegra124-car.txt         |   59 +
 drivers/clk/tegra/Makefile                         |    7 +-
 drivers/clk/tegra/clk-id.h                         |  233 +++
 drivers/clk/tegra/clk-periph-gate.c                |    8 +-
 drivers/clk/tegra/clk-periph.c                     |   18 +-
 drivers/clk/tegra/clk-pll.c                        |  356 ++++--
 drivers/clk/tegra/clk-tegra-audio.c                |  215 +++
 drivers/clk/tegra/clk-tegra-fixed.c                |  111 ++
 drivers/clk/tegra/clk-tegra-periph.c               |  644 ++++++++
 drivers/clk/tegra/clk-tegra-pmc.c                  |  131 ++
 drivers/clk/tegra/clk-tegra-super-gen4.c           |  149 ++
 drivers/clk/tegra/clk-tegra114.c                   | 1540 +++++---------------
 drivers/clk/tegra/clk-tegra124.c                   | 1430 ++++++++++++++++++
 drivers/clk/tegra/clk-tegra20.c                    |  811 ++++-------
 drivers/clk/tegra/clk-tegra30.c                    | 1492 ++++++-------------
 drivers/clk/tegra/clk.c                            |  166 +++
 drivers/clk/tegra/clk.h                            |  104 +-
 include/dt-bindings/clock/tegra124-car.h           |  340 +++++
 include/dt-bindings/clock/tegra30-car.h            |   10 +-
 19 files changed, 4940 insertions(+), 2884 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
 create mode 100644 drivers/clk/tegra/clk-id.h
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c
 create mode 100644 drivers/clk/tegra/clk-tegra-fixed.c
 create mode 100644 drivers/clk/tegra/clk-tegra-periph.c
 create mode 100644 drivers/clk/tegra/clk-tegra-pmc.c
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 include/dt-bindings/clock/tegra124-car.h

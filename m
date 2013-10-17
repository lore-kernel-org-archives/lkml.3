Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3JQMll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:41:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13602 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab3JQMlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:41:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Oct 2013 05:41:39 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 00/15] Introduce common infra for tegra clocks
Date: Thu, 17 Oct 2013 15:41:13 +0300
Message-ID: <1382013674-12901-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces common infrastructure for clocks which exist in
several Tegra SoCs. We also also move Tegra20, Tegra30 and Tegra114 to
this new infrastructure.

Changes since v1:
+ move common clks allocation to patch 2                                                                                                                       
+ adapt also Tegra20 and Tegra30 to the changes in patch 2                                                                                                     

Changes since v2:
+ move Tegra20 and Tegra30 to the common infrastructure
+ bug fixes and comments
+ merge clk-tegra-osc.c and clk-tegra-fixed.c in 1 file

Changes since v3:
+ aggregate all changes for Tegra20 and Tegra30 into 1 file per SoC
+ add CLK_SET_RATE_PARENT for NODIV clocks to fix some warnings on Tegra30
+ rename tegra_clk_periph_banks()

Peter De Schrijver (15):
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

 drivers/clk/tegra/Makefile               |    6 +-
 drivers/clk/tegra/clk-id.h               |  213 ++++
 drivers/clk/tegra/clk-periph-gate.c      |    8 +-
 drivers/clk/tegra/clk-periph.c           |   18 +-
 drivers/clk/tegra/clk-pll.c              |  233 +++--
 drivers/clk/tegra/clk-tegra-audio.c      |  213 ++++
 drivers/clk/tegra/clk-tegra-fixed.c      |  113 +++
 drivers/clk/tegra/clk-tegra-periph.c     |  590 ++++++++++++
 drivers/clk/tegra/clk-tegra-pmc.c        |  131 +++
 drivers/clk/tegra/clk-tegra-super-gen4.c |  151 +++
 drivers/clk/tegra/clk-tegra114.c         | 1540 +++++++-----------------------
 drivers/clk/tegra/clk-tegra20.c          |  809 ++++++----------
 drivers/clk/tegra/clk-tegra30.c          | 1492 +++++++++--------------------
 drivers/clk/tegra/clk.c                  |  156 +++
 drivers/clk/tegra/clk.h                  |   99 ++-
 include/dt-bindings/clock/tegra30-car.h  |   10 +-
 16 files changed, 2899 insertions(+), 2883 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-id.h
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c
 create mode 100644 drivers/clk/tegra/clk-tegra-fixed.c
 create mode 100644 drivers/clk/tegra/clk-tegra-periph.c
 create mode 100644 drivers/clk/tegra/clk-tegra-pmc.c
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c

-- 
1.7.7.rc0.72.g4b5ea.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab3JOOy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:54:58 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11581 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab3JOOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:54:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 07:54:55 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v3 00/19] Introduce common infra for tegra clocks
Date: Tue, 15 Oct 2013 17:52:45 +0300
Message-ID: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
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

Boottested on dalmore, beaverboard and seaboard.                                                                                                               

--

based on:

git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-0

Peter De Schrijver (19):
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
  clk: tegra30: replace enum by binding header
  clk: tegra20: replace enum by binding header
  clk: tegra20: move tegra20 to common clkdev
  clk: tegra30: move tegra30 to common clkdev
  clk: tegra20: move to common periph clk
  clk: tegra30: move to common tegra clk infra

 drivers/clk/tegra/Makefile               |    6 +-
 drivers/clk/tegra/clk-id.h               |  213 ++++
 drivers/clk/tegra/clk-periph-gate.c      |    8 +-
 drivers/clk/tegra/clk-periph.c           |   15 +-
 drivers/clk/tegra/clk-pll.c              |  233 +++--
 drivers/clk/tegra/clk-tegra-audio.c      |  213 ++++
 drivers/clk/tegra/clk-tegra-fixed.c      |  113 +++
 drivers/clk/tegra/clk-tegra-periph.c     |  590 +++++++++++
 drivers/clk/tegra/clk-tegra-pmc.c        |  131 +++
 drivers/clk/tegra/clk-tegra-super-gen4.c |  151 +++
 drivers/clk/tegra/clk-tegra114.c         | 1601 ++++++------------------------
 drivers/clk/tegra/clk-tegra20.c          |  809 ++++++----------
 drivers/clk/tegra/clk-tegra30.c          | 1492 +++++++++-------------------
 drivers/clk/tegra/clk.c                  |  158 +++
 drivers/clk/tegra/clk.h                  |  101 ++-
 include/dt-bindings/clock/tegra30-car.h  |   10 +-
 16 files changed, 2902 insertions(+), 2942 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-id.h
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c
 create mode 100644 drivers/clk/tegra/clk-tegra-fixed.c
 create mode 100644 drivers/clk/tegra/clk-tegra-periph.c
 create mode 100644 drivers/clk/tegra/clk-tegra-pmc.c
 create mode 100644 drivers/clk/tegra/clk-tegra-super-gen4.c

-- 
1.7.7.rc0.72.g4b5ea.dirty


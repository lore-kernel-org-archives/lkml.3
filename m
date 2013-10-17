Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3JQNMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:12:54 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14405 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JQNMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:12:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Oct 2013 06:12:52 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/7] Tegra124 clock support
Date: Thu, 17 Oct 2013 16:12:44 +0300
Message-ID: <1382015565-20139-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces support for the Tegra124 CAR clocks.
Based on '[PATCH v4 00/15] Introduce common infra for tegra clocks'

changes since v1:

+ suspend/resume for LP1 (Joseph Lo)
+ fixed some comments
+ account for changes to the common infra code

changes since v2:

+ simplified PLLSS support
+ added binding document
+ minor fixes

Joseph Lo (2):
  clk: tegra124: add wait_for_reset and disable_clock for
    tegra_cpu_car_ops
  clk: tegra124: add suspend/resume function for tegra_cpu_car_ops

Peter De Schrijver (5):
  clk: tegra: Add support for PLLSS
  clk: tegra: Add periph regs bank X
  clk: tegra124: Add common clk IDs to clk-id.h
  clk: tegra124: Add new peripheral clocks
  clk: tegra124: Add support for Tegra124 clocks

 .../bindings/clock/nvidia,tegra124-car.txt         |   59 +
 drivers/clk/tegra/Makefile                         |    1 +
 drivers/clk/tegra/clk-id.h                         |   20 +
 drivers/clk/tegra/clk-pll.c                        |  124 ++
 drivers/clk/tegra/clk-tegra-periph.c               |   54 +
 drivers/clk/tegra/clk-tegra124.c                   | 1428 ++++++++++++++++++++
 drivers/clk/tegra/clk.c                            |   10 +
 drivers/clk/tegra/clk.h                            |    5 +
 include/dt-bindings/clock/tegra124-car.h           |  340 +++++
 9 files changed, 2041 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 include/dt-bindings/clock/tegra124-car.h

-- 
1.7.7.rc0.72.g4b5ea.dirty


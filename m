Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaGOPZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:25:30 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3104 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaGOPZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:25:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jul 2014 08:13:50 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/6] clock support for Tegra132
Date: Tue, 15 Jul 2014 18:24:30 +0300
Message-ID: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra132 has almost the same clock structure as Tegra124, except for the CPU
related clocks.

Patch 1 is a small change to not stop initializing clocks when an error is
	encountered
Patch 2 makes tegra_clocks_apply_init_table an arch_initcall to make it work
	on ARM64
Patch 3 updates the Tegra124 binding doc with the details about the clock
	changes for Tegra132
Patch 4 adds a new binding for the CPU clocks on Tegra132
Patch 5 Implements the changes to the CAR clocks for Tegra132
Patch 6 Implements the new Tegar132 ccplex clocks

Peter De Schrijver (6):
  clk: tegra: don't abort clk init on error
  clk: tegra: make tegra_clocks_apply_init_table arch_initcall
  clk: tegra: Update binding doc Tegra132
  clk: tegra: add nvidia,tegra132-ccplex-clk binding
  clk: tegra: Add support for Tegra132 CAR clocks
  clk: tegra: Add Tegra132 ccplex clocks

 .../bindings/clock/nvidia,tegra124-car.txt         |    8 +++--
 .../bindings/clock/nvidia,tegra132-ccplex-clk.txt  |   27 ++++++++++++++++
 arch/arm/mach-tegra/tegra.c                        |    3 --
 drivers/clk/tegra/Makefile                         |    2 +
 drivers/clk/tegra/clk-tegra124.c                   |   32 ++++++++++++++++++++
 drivers/clk/tegra/clk.c                            |    9 ++++--
 include/dt-bindings/clock/tegra132-ccplex.h        |   12 +++++++
 include/linux/clk/tegra.h                          |    2 -
 8 files changed, 84 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra132-ccplex-clk.txt
 create mode 100644 include/dt-bindings/clock/tegra132-ccplex.h

-- 
1.7.7.rc0.72.g4b5ea.dirty


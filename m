Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaLPW6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:58:53 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:35028 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLPW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:58:51 -0500
MBOX-Line: From paul@pwsan.com Tue Dec 16 12:38:24 2014
Subject: [PATCH 0/4] clk: tegra: add support for the Tegra132 CAR IP block
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
From: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thierry Reding <treding@nvidia.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 16 Dec 2014 12:38:24 -0800
Message-ID: <20141216203813.22980.2301.stgit@chromeos-P9X79>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series follows up on Peter De Schrijver's posting of a Tegra132
CAR series in July of this year.  It adds common clock framework
support for the Tegra132 CAR IP block.

The patches are based on next-20141209 and have been compiled and
boot-tested on a Tegra30 Beaver board, a Tegra114 Dalmore board, and a
Tegra124 Jetson TK1.  They've also been tested on a Tegra132 Norrin
FFD board, with some other patches applied since support for that
board isn't completely upstream (but is coming shortly).

Intended for v3.20.

- Paul

---

Paul Walmsley (2):
      clk: tegra:  split Tegra124 clock header file
      clk: tegra: Add support for the Tegra132 CAR IP block

Peter De Schrijver (2):
      clk: tegra: make tegra_clocks_apply_init_table() arch_initcall
      clk: tegra: Update binding doc for Tegra132


 .../bindings/clock/nvidia,tegra124-car.txt         |   10 -
 arch/arm/mach-tegra/tegra.c                        |    2 
 drivers/clk/tegra/Makefile                         |    1 
 drivers/clk/tegra/clk-pll.c                        |   10 -
 drivers/clk/tegra/clk-tegra124.c                   |  130 +++++++-
 drivers/clk/tegra/clk.c                            |    7 
 include/dt-bindings/clock/tegra124-car-common.h    |  345 ++++++++++++++++++++
 include/dt-bindings/clock/tegra124-car.h           |  345 +-------------------
 include/linux/clk/tegra.h                          |    2 
 9 files changed, 494 insertions(+), 358 deletions(-)
 create mode 100644 include/dt-bindings/clock/tegra124-car-common.h



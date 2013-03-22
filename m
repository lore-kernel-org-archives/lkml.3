Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3CVMmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:42:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15074 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab3CVMmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:42:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 05:42:22 -0700
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
Subject: [PATCH v8 01/14] clk: tegra: provide dummy cpu car ops
Date: Fri, 22 Mar 2013 14:39:18 +0200
Message-ID: <1363956029-31873-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1363956029-31873-1-git-send-email-pdeschrijver@nvidia.com>
References: <1363956029-31873-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tegra_boot_secondary() relies on some of the car ops. This means having an
uninitialized tegra_cpu_car_ops will lead to an early boot panic.
Providing a dummy struct avoids this and makes adding Tegra114 clock support
in a bisectable way a lot easier.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index a603b9a..a6f2fa6 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -22,7 +22,8 @@
 #include "clk.h"
 
 /* Global data of Tegra CPU CAR ops */
-struct tegra_cpu_car_ops *tegra_cpu_car_ops;
+static struct tegra_cpu_car_ops dummy_car_ops;
+struct tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;
 
 void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 				struct clk *clks[], int clk_max)
-- 
1.7.7.rc0.72.g4b5ea.dirty


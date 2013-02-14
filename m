Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab3BNOxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:53:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4765 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab3BNOxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:53:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Feb 2013 06:53:14 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: tegra: provide dummy cpu car ops
Date: Thu, 14 Feb 2013 16:52:57 +0200
Message-ID: <1360853581-9756-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
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

--

Stephen,

Should this be a separate patch or should I make this part of new release of
the Tegra114 clock series?

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index a603b9a..f6c141f 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -22,7 +22,8 @@
 #include "clk.h"
 
 /* Global data of Tegra CPU CAR ops */
-struct tegra_cpu_car_ops *tegra_cpu_car_ops;
+static struct tegra_cpu_car_ops *dummy_car_ops;
+struct tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;
 
 void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 				struct clk *clks[], int clk_max)
-- 
1.7.7.rc0.72.g4b5ea.dirty


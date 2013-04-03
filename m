Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669Ab3DCOzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:55:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19272 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643Ab3DCOzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:55:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 03 Apr 2013 07:54:33 -0700
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
Subject: [PATCH v9 12/14] clk: tegra: devicetree match for nvidia,tegra114-car
Date: Wed, 3 Apr 2013 17:40:46 +0300
Message-ID: <1365000110-8916-13-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
References: <1365000110-8916-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |    1 +
 drivers/clk/tegra/clk.h |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 70b7a47..923ca7e 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -77,6 +77,7 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 static const struct of_device_id tegra_dt_clk_match[] = {
 	{ .compatible = "nvidia,tegra20-car", .data = tegra20_clock_init },
 	{ .compatible = "nvidia,tegra30-car", .data = tegra30_clock_init },
+	{ .compatible = "nvidia,tegra114-car", .data = tegra114_clock_init },
 	{ }
 };
 
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index fb48f04..e056562 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -583,6 +583,12 @@ void tegra30_clock_init(struct device_node *np);
 static inline void tegra30_clock_init(struct device_node *np) {}
 #endif /* CONFIG_ARCH_TEGRA_3x_SOC */
 
+#ifdef CONFIG_ARCH_TEGRA_114_SOC
+void tegra114_clock_init(struct device_node *np);
+#else
+static inline void tegra114_clock_init(struct device_node *np) {}
+#endif /* CONFIG_ARCH_TEGRA114_SOC */
+
 typedef void (*tegra_clk_apply_init_table_func)(void);
 extern tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
-- 
1.7.7.rc0.72.g4b5ea.dirty


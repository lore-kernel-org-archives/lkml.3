Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab3JOO4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:56:32 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10498 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3JOO41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:56:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 Oct 2013 07:52:03 -0700
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
Subject: [PATCH v3 08/19] clk: tegra: add common infra for DT clocks
Date: Tue, 15 Oct 2013 17:52:53 +0300
Message-ID: <1381848794-11761-9-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common infrastructure for sharing clock initialization between
SoCs.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |    9 +++++++++
 drivers/clk/tegra/clk.h |    7 +++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 1253217..c8c84ce 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -214,6 +214,15 @@ void __init tegra_add_of_provider(struct device_node *np)
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 }
 
+struct clk ** __init tegra_lookup_dt_id(int clk_id,
+					struct tegra_clk *tegra_clk)
+{
+	if (tegra_clk[clk_id].present)
+		return &clks[tegra_clk[clk_id].dt_id];
+	else
+		return NULL;
+}
+
 tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
 void __init tegra_clocks_apply_init_table(void)
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index a73a678..be45705 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -568,6 +568,11 @@ struct tegra_clk_duplicate {
 		},				\
 	}
 
+struct tegra_clk {
+	int			dt_id;
+	bool			present;
+};
+
 void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 		struct clk *clks[], int clk_max);
 
@@ -577,6 +582,8 @@ void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 struct tegra_clk_periph_regs *get_reg_bank(int clkid);
 struct clk **tegra_clk_init(int num, int periph_banks);
 
+struct clk **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
+
 void tegra_add_of_provider(struct device_node *np);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty


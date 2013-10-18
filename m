Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3JRNpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:45:16 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12793 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab3JRNpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:45:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Oct 2013 06:40:43 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/7] clk: tegra: Add periph regs bank X
Date: Fri, 18 Oct 2013 16:44:59 +0300
Message-ID: <1382103904-6398-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382103904-6398-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra124 has an extra bank of peripheral clock registers. Add it to the
generic peripheral clock code.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 14d2532..a12a5f5 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -57,6 +57,8 @@
 #define RST_DEVICES_CLR_V		0x434
 #define RST_DEVICES_SET_W		0x438
 #define RST_DEVICES_CLR_W		0x43c
+#define RST_DEVICES_SET_X		0x290
+#define RST_DEVICES_CLR_X		0x294
 
 /* Global data of Tegra CPU CAR ops */
 static struct tegra_cpu_car_ops dummy_car_ops;
@@ -109,6 +111,14 @@ static struct tegra_clk_periph_regs periph_regs[] = {
 		.rst_set_reg = RST_DEVICES_SET_W,
 		.rst_clr_reg = RST_DEVICES_CLR_W,
 	},
+	[5] = {
+		.enb_reg = CLK_OUT_ENB_X,
+		.enb_set_reg = CLK_OUT_ENB_SET_X,
+		.enb_clr_reg = CLK_OUT_ENB_CLR_X,
+		.rst_reg = RST_DEVICES_X,
+		.rst_set_reg = RST_DEVICES_SET_X,
+		.rst_clr_reg = RST_DEVICES_CLR_X,
+	},
 };
 
 struct tegra_clk_periph_regs *get_reg_bank(int clkid)
-- 
1.7.7.rc0.72.g4b5ea.dirty


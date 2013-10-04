Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab3JDJRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:17:31 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11241 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JDJR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:17:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Oct 2013 02:13:30 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH 2/5] clk: tegra: Add periph regs bank X
Date: Fri, 4 Oct 2013 12:12:41 +0300
Message-ID: <1380878014-22088-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
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
index c8c84ce..0240dc3 100644
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
 
 struct tegra_clk_periph_regs * __init get_reg_bank(int clkid)
-- 
1.7.7.rc0.72.g4b5ea.dirty


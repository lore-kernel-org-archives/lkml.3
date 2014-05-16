Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaEPXHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:07:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52409 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaEPXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:07:18 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/7] clk: qcom: Fix mmcc-8974's PLL configurations
Date: Fri, 16 May 2014 16:07:09 -0700
Message-Id: <1400281634-9313-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
References: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We forgot to add the status bit for the PLLs and we were using
the wrong register and masks for configuration, leading to
unexpected PLL configurations. Fix this.

Fixes: d8b212014e69 (clk: qcom: Add support for MSM8974's multimedia clock controller (MMCC))
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/mmcc-msm8974.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-msm8974.c b/drivers/clk/qcom/mmcc-msm8974.c
index 60b7c24a5cd6..62200bbc759e 100644
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -170,6 +170,7 @@ static struct clk_pll mmpll0 = {
 	.config_reg = 0x0014,
 	.mode_reg = 0x0000,
 	.status_reg = 0x001c,
+	.status_bit = 17,
         .clkr.hw.init = &(struct clk_init_data){
                 .name = "mmpll0",
                 .parent_names = (const char *[]){ "xo" },
@@ -193,9 +194,10 @@ static struct clk_pll mmpll1 = {
 	.l_reg = 0x0044,
 	.m_reg = 0x0048,
 	.n_reg = 0x004c,
-	.config_reg = 0x0054,
+	.config_reg = 0x0050,
 	.mode_reg = 0x0040,
 	.status_reg = 0x005c,
+	.status_bit = 17,
         .clkr.hw.init = &(struct clk_init_data){
                 .name = "mmpll1",
                 .parent_names = (const char *[]){ "xo" },
@@ -219,7 +221,7 @@ static struct clk_pll mmpll2 = {
 	.l_reg = 0x4104,
 	.m_reg = 0x4108,
 	.n_reg = 0x410c,
-	.config_reg = 0x4114,
+	.config_reg = 0x4110,
 	.mode_reg = 0x4100,
 	.status_reg = 0x411c,
         .clkr.hw.init = &(struct clk_init_data){
@@ -234,9 +236,10 @@ static struct clk_pll mmpll3 = {
 	.l_reg = 0x0084,
 	.m_reg = 0x0088,
 	.n_reg = 0x008c,
-	.config_reg = 0x0094,
+	.config_reg = 0x0090,
 	.mode_reg = 0x0080,
 	.status_reg = 0x009c,
+	.status_bit = 17,
         .clkr.hw.init = &(struct clk_init_data){
                 .name = "mmpll3",
                 .parent_names = (const char *[]){ "xo" },
@@ -2319,7 +2322,7 @@ static const struct pll_config mmpll1_config = {
 	.vco_val = 0x0,
 	.vco_mask = 0x3 << 20,
 	.pre_div_val = 0x0,
-	.pre_div_mask = 0x3 << 12,
+	.pre_div_mask = 0x7 << 12,
 	.post_div_val = 0x0,
 	.post_div_mask = 0x3 << 8,
 	.mn_ena_mask = BIT(24),
@@ -2333,7 +2336,7 @@ static struct pll_config mmpll3_config = {
 	.vco_val = 0x0,
 	.vco_mask = 0x3 << 20,
 	.pre_div_val = 0x0,
-	.pre_div_mask = 0x3 << 12,
+	.pre_div_mask = 0x7 << 12,
 	.post_div_val = 0x0,
 	.post_div_mask = 0x3 << 8,
 	.mn_ena_mask = BIT(24),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


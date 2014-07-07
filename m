Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaGHA33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:29:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaGGXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.14 79/94] clk: qcom: Fix mmcc-8974s PLL configurations
Date: Mon,  7 Jul 2014 16:58:09 -0700
Message-Id: <20140707235759.105792569@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 437ae6a1b8f2eedebfbf0f6572e19ca5c58a3f71 upstream.

We forgot to add the status bit for the PLLs and we were using
the wrong register and masks for configuration, leading to
unexpected PLL configurations. Fix this.

Fixes: d8b212014e69 (clk: qcom: Add support for MSM8974's multimedia clock controller (MMCC))
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/mmcc-msm8974.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -169,6 +169,7 @@ static struct clk_pll mmpll0 = {
 	.config_reg = 0x0014,
 	.mode_reg = 0x0000,
 	.status_reg = 0x001c,
+	.status_bit = 17,
         .clkr.hw.init = &(struct clk_init_data){
                 .name = "mmpll0",
                 .parent_names = (const char *[]){ "xo" },
@@ -192,9 +193,10 @@ static struct clk_pll mmpll1 = {
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
@@ -218,7 +220,7 @@ static struct clk_pll mmpll2 = {
 	.l_reg = 0x4104,
 	.m_reg = 0x4108,
 	.n_reg = 0x410c,
-	.config_reg = 0x4114,
+	.config_reg = 0x4110,
 	.mode_reg = 0x4100,
 	.status_reg = 0x411c,
         .clkr.hw.init = &(struct clk_init_data){
@@ -233,9 +235,10 @@ static struct clk_pll mmpll3 = {
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
@@ -2318,7 +2321,7 @@ static const struct pll_config mmpll1_co
 	.vco_val = 0x0,
 	.vco_mask = 0x3 << 20,
 	.pre_div_val = 0x0,
-	.pre_div_mask = 0x3 << 12,
+	.pre_div_mask = 0x7 << 12,
 	.post_div_val = 0x0,
 	.post_div_mask = 0x3 << 8,
 	.mn_ena_mask = BIT(24),
@@ -2332,7 +2335,7 @@ static struct pll_config mmpll3_config =
 	.vco_val = 0x0,
 	.vco_mask = 0x3 << 20,
 	.pre_div_val = 0x0,
-	.pre_div_mask = 0x3 << 12,
+	.pre_div_mask = 0x7 << 12,
 	.post_div_val = 0x0,
 	.post_div_mask = 0x3 << 8,
 	.mn_ena_mask = BIT(24),



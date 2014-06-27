Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaF0N3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:29:50 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:54049 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbaF0N0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:36 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v2 03/14] drivers: clk: st: use static const for clkgen_pll_data tables
Date: Fri, 27 Jun 2014 15:25:00 +0200
Message-Id: <1403875511-7710-4-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

converts clkgen_pll_data tables into static const

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 drivers/clk/st/clkgen-pll.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
index d8b9b1a..cdf23db 100644
--- a/drivers/clk/st/clkgen-pll.c
+++ b/drivers/clk/st/clkgen-pll.c
@@ -59,7 +59,7 @@ static const struct clk_ops st_pll800c65_ops;
 static const struct clk_ops stm_pll3200c32_ops;
 static const struct clk_ops st_pll1200c32_ops;
 
-static struct clkgen_pll_data st_pll1600c65_ax = {
+static const struct clkgen_pll_data st_pll1600c65_ax = {
 	.pdn_status	= CLKGEN_FIELD(0x0, 0x1,			19),
 	.locked_status	= CLKGEN_FIELD(0x0, 0x1,			31),
 	.mdiv		= CLKGEN_FIELD(0x0, C65_MDIV_PLL1600_MASK,	0),
@@ -67,7 +67,7 @@ static struct clkgen_pll_data st_pll1600c65_ax = {
 	.ops		= &st_pll1600c65_ops
 };
 
-static struct clkgen_pll_data st_pll800c65_ax = {
+static const struct clkgen_pll_data st_pll800c65_ax = {
 	.pdn_status	= CLKGEN_FIELD(0x0,	0x1,			19),
 	.locked_status	= CLKGEN_FIELD(0x0,	0x1,			31),
 	.mdiv		= CLKGEN_FIELD(0x0,	C65_MDIV_PLL800_MASK,	0),
@@ -76,7 +76,7 @@ static struct clkgen_pll_data st_pll800c65_ax = {
 	.ops		= &st_pll800c65_ops
 };
 
-static struct clkgen_pll_data st_pll3200c32_a1x_0 = {
+static const struct clkgen_pll_data st_pll3200c32_a1x_0 = {
 	.pdn_status	= CLKGEN_FIELD(0x0,	0x1,			31),
 	.locked_status	= CLKGEN_FIELD(0x4,	0x1,			31),
 	.ndiv		= CLKGEN_FIELD(0x0,	C32_NDIV_MASK,		0x0),
@@ -93,7 +93,7 @@ static struct clkgen_pll_data st_pll3200c32_a1x_0 = {
 	.ops		= &stm_pll3200c32_ops,
 };
 
-static struct clkgen_pll_data st_pll3200c32_a1x_1 = {
+static const struct clkgen_pll_data st_pll3200c32_a1x_1 = {
 	.pdn_status	= CLKGEN_FIELD(0xC,	0x1,			31),
 	.locked_status	= CLKGEN_FIELD(0x10,	0x1,			31),
 	.ndiv		= CLKGEN_FIELD(0xC,	C32_NDIV_MASK,		0x0),
@@ -111,7 +111,7 @@ static struct clkgen_pll_data st_pll3200c32_a1x_1 = {
 };
 
 /* 415 specific */
-static struct clkgen_pll_data st_pll3200c32_a9_415 = {
+static const struct clkgen_pll_data st_pll3200c32_a9_415 = {
 	.pdn_status	= CLKGEN_FIELD(0x0,	0x1,			0),
 	.locked_status	= CLKGEN_FIELD(0x6C,	0x1,			0),
 	.ndiv		= CLKGEN_FIELD(0x0,	C32_NDIV_MASK,		9),
@@ -122,7 +122,7 @@ static struct clkgen_pll_data st_pll3200c32_a9_415 = {
 	.ops		= &stm_pll3200c32_ops,
 };
 
-static struct clkgen_pll_data st_pll3200c32_ddr_415 = {
+static const struct clkgen_pll_data st_pll3200c32_ddr_415 = {
 	.pdn_status	= CLKGEN_FIELD(0x0,	0x1,			0),
 	.locked_status	= CLKGEN_FIELD(0x100,	0x1,			0),
 	.ndiv		= CLKGEN_FIELD(0x8,	C32_NDIV_MASK,		0),
@@ -135,7 +135,7 @@ static struct clkgen_pll_data st_pll3200c32_ddr_415 = {
 	.ops		= &stm_pll3200c32_ops,
 };
 
-static struct clkgen_pll_data st_pll1200c32_gpu_415 = {
+static const struct clkgen_pll_data st_pll1200c32_gpu_415 = {
 	.pdn_status	= CLKGEN_FIELD(0x144,	0x1,			3),
 	.locked_status	= CLKGEN_FIELD(0x168,	0x1,			0),
 	.ldf		= CLKGEN_FIELD(0x0,	C32_LDF_MASK,		3),
@@ -146,7 +146,7 @@ static struct clkgen_pll_data st_pll1200c32_gpu_415 = {
 };
 
 /* 416 specific */
-static struct clkgen_pll_data st_pll3200c32_a9_416 = {
+static const struct clkgen_pll_data st_pll3200c32_a9_416 = {
 	.pdn_status	= CLKGEN_FIELD(0x0,	0x1,			0),
 	.locked_status	= CLKGEN_FIELD(0x6C,	0x1,			0),
 	.ndiv		= CLKGEN_FIELD(0x8,	C32_NDIV_MASK,		0),
@@ -157,7 +157,7 @@ static struct clkgen_pll_data st_pll3200c32_a9_416 = {
 	.ops		= &stm_pll3200c32_ops,
 };
 
-static struct clkgen_pll_data st_pll3200c32_ddr_416 = {
+static const struct clkgen_pll_data st_pll3200c32_ddr_416 = {
 	.pdn_status	= CLKGEN_FIELD(0x0,	0x1,			0),
 	.locked_status	= CLKGEN_FIELD(0x10C,	0x1,			0),
 	.ndiv		= CLKGEN_FIELD(0x8,	C32_NDIV_MASK,		0),
@@ -170,7 +170,7 @@ static struct clkgen_pll_data st_pll3200c32_ddr_416 = {
 	.ops		= &stm_pll3200c32_ops,
 };
 
-static struct clkgen_pll_data st_pll1200c32_gpu_416 = {
+static const struct clkgen_pll_data st_pll1200c32_gpu_416 = {
 	.pdn_status	= CLKGEN_FIELD(0x8E4,	0x1,			3),
 	.locked_status	= CLKGEN_FIELD(0x90C,	0x1,			0),
 	.ldf		= CLKGEN_FIELD(0x0,	C32_LDF_MASK,		3),
@@ -450,9 +450,8 @@ static void __init clkgena_c65_pll_setup(struct device_node *np)
 	 * PLL0 HS (high speed) output
 	 */
 	clk_data->clks[0] = clkgen_pll_register(parent_name,
-						&st_pll1600c65_ax,
-						reg + CLKGENAx_PLL0_OFFSET,
-						clk_name);
+			(struct clkgen_pll_data *) &st_pll1600c65_ax,
+			reg + CLKGENAx_PLL0_OFFSET, clk_name);
 
 	if (IS_ERR(clk_data->clks[0]))
 		goto err;
@@ -480,9 +479,8 @@ static void __init clkgena_c65_pll_setup(struct device_node *np)
 	 * PLL1 output
 	 */
 	clk_data->clks[2] = clkgen_pll_register(parent_name,
-						&st_pll800c65_ax,
-						reg + CLKGENAx_PLL1_OFFSET,
-						clk_name);
+			(struct clkgen_pll_data *) &st_pll800c65_ax,
+			reg + CLKGENAx_PLL1_OFFSET, clk_name);
 
 	if (IS_ERR(clk_data->clks[2]))
 		goto err;
-- 
1.9.1


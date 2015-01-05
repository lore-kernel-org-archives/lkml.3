Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbbAEI5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:57:39 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30978 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbbAEI47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:56:59 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d6-54aa51da3e04
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] clk: si5351: Constify clock names and struct regmap_config
Date: Mon, 05 Jan 2015 09:56:48 +0100
Message-id: <1420448209-8033-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xy7q3AleFGHzvMbZ4/cLQ4vKuOWwW
	TydcZLP4caabxYHF43JfL5PHnWt72Dz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4+ruPqaC
	9XwVk27NYm1g/MXdxcjBISFgItG4i62LkRPIFJO4cG89kM3FISSwlFHi260j7CAJIYE+JonL
	n2pBbDYBY4nNy5eANYgI5EvMWnebBcRmFjCU+PnuD1i9sIC/xPUDc8DiLAKqEk9vt4LZvAJu
	EouXP2WCWCYncfLYZNYJjNwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoR4/usOxqXH
	rA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhHfdLaAQb0piZVVqUX58UWlOavEhRiYOTqkG
	xkzh0hfz9vwo13QUrLx34AO7yS12z/37FkUu4Hi3bon697KKPYHCmVK3m41ZdTzTvpt8b5Kt
	Yi939Feedy3dwPhXk9m2srxlqtOblv+6G5h8S/nk+e6CRT7Zdclzsk4yejVtmmPee3B76aFD
	wZOzvA5dDlbYvGSTw2q1vWE9vhW2hWbbX2gYKbEUZyQaajEXFScCAGtOHSHaAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Replace doubled const in the arrays of clock names with proper const
pointer to const data. This fixes the warnings:

drivers/clk/clk-si5351.c:71:25: warning: duplicate const
drivers/clk/clk-si5351.c:74:25: warning: duplicate const
drivers/clk/clk-si5351.c:77:25: warning: duplicate const
drivers/clk/clk-si5351.c:80:25: warning: duplicate const

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-si5351.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 3b2a66f78755..44ea107cfc67 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -68,16 +68,16 @@ struct si5351_driver_data {
 	struct si5351_hw_data	*clkout;
 };
 
-static const char const *si5351_input_names[] = {
+static const char * const si5351_input_names[] = {
 	"xtal", "clkin"
 };
-static const char const *si5351_pll_names[] = {
+static const char * const si5351_pll_names[] = {
 	"plla", "pllb", "vxco"
 };
-static const char const *si5351_msynth_names[] = {
+static const char * const si5351_msynth_names[] = {
 	"ms0", "ms1", "ms2", "ms3", "ms4", "ms5", "ms6", "ms7"
 };
-static const char const *si5351_clkout_names[] = {
+static const char * const si5351_clkout_names[] = {
 	"clk0", "clk1", "clk2", "clk3", "clk4", "clk5", "clk6", "clk7"
 };
 
@@ -207,7 +207,7 @@ static bool si5351_regmap_is_writeable(struct device *dev, unsigned int reg)
 	return true;
 }
 
-static struct regmap_config si5351_regmap_config = {
+static const struct regmap_config si5351_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
-- 
1.9.1


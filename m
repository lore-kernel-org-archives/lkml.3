Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826Ab3DHDnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:43:11 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37142 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444Ab3DHDnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:43:09 -0400
Message-ID: <1365392582.16955.1.camel@phoenix>
Subject: [PATCH] clk: mvebu: Fix valid value range checking for
 cpu_freq_select
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 11:43:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_freq_select is used as array subscript, thus the valid value range
is 0 ... ARRAY_SIZE() - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clk/mvebu/clk-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mvebu/clk-core.c b/drivers/clk/mvebu/clk-core.c
index 1b4e333..0a53edb 100644
--- a/drivers/clk/mvebu/clk-core.c
+++ b/drivers/clk/mvebu/clk-core.c
@@ -156,7 +156,7 @@ static u32 __init armada_370_get_cpu_freq(void __iomem *sar)
 
 	cpu_freq_select = ((readl(sar) >> SARL_A370_PCLK_FREQ_OPT) &
 			   SARL_A370_PCLK_FREQ_OPT_MASK);
-	if (cpu_freq_select > ARRAY_SIZE(armada_370_cpu_frequencies)) {
+	if (cpu_freq_select >= ARRAY_SIZE(armada_370_cpu_frequencies)) {
 		pr_err("CPU freq select unsupported %d\n", cpu_freq_select);
 		cpu_freq = 0;
 	} else
@@ -278,7 +278,7 @@ static u32 __init armada_xp_get_cpu_freq(void __iomem *sar)
 	cpu_freq_select |= (((readl(sar+4) >> SARH_AXP_PCLK_FREQ_OPT) &
 			     SARH_AXP_PCLK_FREQ_OPT_MASK)
 			    << SARH_AXP_PCLK_FREQ_OPT_SHIFT);
-	if (cpu_freq_select > ARRAY_SIZE(armada_xp_cpu_frequencies)) {
+	if (cpu_freq_select >= ARRAY_SIZE(armada_xp_cpu_frequencies)) {
 		pr_err("CPU freq select unsupported: %d\n", cpu_freq_select);
 		cpu_freq = 0;
 	} else
-- 
1.7.10.4




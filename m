Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbbAWXoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:44:25 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60326 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbAWXoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:44:23 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] clk: zynq: Force CPU_2X clock to be ungated
Date: Fri, 23 Jan 2015 15:44:13 -0800
Message-Id: <1422056653-11271-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.2.1.g63c5777
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU_2X clock does not have a classical in kernel user, but is,
amongst other things, required for OCM and debug access. Make sure this
clock does not mistakenly disabled during boot up by enabling it in the
platforms clock driver.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
I just noticed this on Linus' latest tip. I can't remember having had issues
connecting the debugger before, but it might be a candidate for stable in case
people report something like that.

	Sören

 drivers/clk/zynq/clkc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index c363106ed726..f8469315161d 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -346,6 +346,7 @@ static void __init zynq_clk_setup(struct device_node *np)
 	clks[cpu_2x] = clk_register_gate(NULL, clk_output_name[cpu_2x],
 			"cpu_2x_div", CLK_IGNORE_UNUSED, SLCR_ARM_CLK_CTRL,
 			26, 0, &armclk_lock);
+	clk_prepare_enable(clks[cpu_2x]);
 
 	clk = clk_register_fixed_factor(NULL, "cpu_1x_div", "cpu_div", 0, 1,
 			4 + 2 * tmp);
-- 
2.2.2.1.g63c5777


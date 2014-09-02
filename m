Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaIBXE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:04:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35346 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbaIBXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:04:09 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 3/3] clk: zynq: Move const initdata into correct code section
Date: Tue,  2 Sep 2014 16:02:09 -0700
Message-Id: <1409698929-30143-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409698929-30143-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409698929-30143-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __initconst instead of __initdata for constant init data.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/zynq/clkc.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 6ab793ac8c2c..9037bebd69f7 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -85,24 +85,22 @@ static DEFINE_SPINLOCK(canmioclk_lock);
 static DEFINE_SPINLOCK(dbgclk_lock);
 static DEFINE_SPINLOCK(aperclk_lock);
 
-static const char dummy_nm[] __initconst = "dummy_name";
-
-static const char *armpll_parents[] __initdata = {"armpll_int", "ps_clk"};
-static const char *ddrpll_parents[] __initdata = {"ddrpll_int", "ps_clk"};
-static const char *iopll_parents[] __initdata = {"iopll_int", "ps_clk"};
-static const char *gem0_mux_parents[] __initdata = {"gem0_div1", dummy_nm};
-static const char *gem1_mux_parents[] __initdata = {"gem1_div1", dummy_nm};
-static const char *can0_mio_mux2_parents[] __initdata = {"can0_gate",
+static const char *armpll_parents[] __initconst = {"armpll_int", "ps_clk"};
+static const char *ddrpll_parents[] __initconst = {"ddrpll_int", "ps_clk"};
+static const char *iopll_parents[] __initconst = {"iopll_int", "ps_clk"};
+static const char *gem0_mux_parents[] __initconst = {"gem0_div1", "dummy_name"};
+static const char *gem1_mux_parents[] __initconst = {"gem1_div1", "dummy_name"};
+static const char *can0_mio_mux2_parents[] __initconst = {"can0_gate",
 	"can0_mio_mux"};
-static const char *can1_mio_mux2_parents[] __initdata = {"can1_gate",
+static const char *can1_mio_mux2_parents[] __initconst = {"can1_gate",
 	"can1_mio_mux"};
-static const char *dbg_emio_mux_parents[] __initdata = {"dbg_div",
-	dummy_nm};
+static const char *dbg_emio_mux_parents[] __initconst = {"dbg_div",
+	"dummy_name"};
 
-static const char *dbgtrc_emio_input_names[] __initdata = {"trace_emio_clk"};
-static const char *gem0_emio_input_names[] __initdata = {"gem0_emio_clk"};
-static const char *gem1_emio_input_names[] __initdata = {"gem1_emio_clk"};
-static const char *swdt_ext_clk_input_names[] __initdata = {"swdt_ext_clk"};
+static const char *dbgtrc_emio_input_names[] __initconst = {"trace_emio_clk"};
+static const char *gem0_emio_input_names[] __initconst = {"gem0_emio_clk"};
+static const char *gem1_emio_input_names[] __initconst = {"gem1_emio_clk"};
+static const char *swdt_ext_clk_input_names[] __initconst = {"swdt_ext_clk"};
 
 static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
 		const char *clk_name, void __iomem *fclk_ctrl_reg,
@@ -230,6 +228,7 @@ static void __init zynq_clk_setup(struct device_node *np)
 	const char *periph_parents[4];
 	const char *swdt_ext_clk_mux_parents[2];
 	const char *can_mio_mux_parents[NUM_MIO_PINS];
+	const char *dummy_nm = "dummy_name";
 
 	pr_info("Zynq clock init\n");
 
-- 
2.1.0.1.g27b9230


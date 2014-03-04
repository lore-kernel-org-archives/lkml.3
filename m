Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaCDQUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:20:50 -0500
Received: from top.free-electrons.com ([176.31.233.9]:41950 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754598AbaCDQUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:20:46 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 1/7] clk: sunxi: Remove calls to clk_put
Date: Tue,  4 Mar 2014 17:17:58 +0100
Message-Id: <1393949884-892-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393949884-892-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393949884-892-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of clk_put must disable the clock first. This also means that as long
as the clock is enabled the driver should hold a reference to that clock.
Hence, the call to clk_put here are bogus and should be removed.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 23baad9..7119c02 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1290,17 +1290,13 @@ static void __init sunxi_clock_protect(void)
 
 	/* memory bus clock - sun5i+ */
 	clk = clk_get(NULL, "mbus");
-	if (!IS_ERR(clk)) {
+	if (!IS_ERR(clk))
 		clk_prepare_enable(clk);
-		clk_put(clk);
-	}
 
 	/* DDR clock - sun4i+ */
 	clk = clk_get(NULL, "pll5_ddr");
-	if (!IS_ERR(clk)) {
+	if (!IS_ERR(clk))
 		clk_prepare_enable(clk);
-		clk_put(clk);
-	}
 }
 
 static void __init sunxi_init_clocks(void)
-- 
1.9.0


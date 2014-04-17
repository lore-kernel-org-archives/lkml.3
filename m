Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaDQIuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:50:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54364 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbaDQIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:50:06 -0400
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
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v6 1/8] clk: sunxi: Remove calls to clk_put
Date: Thu, 17 Apr 2014 10:46:12 +0200
Message-Id: <1397724379-15398-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of clk_put must disable the clock first. This also means that as long
as the clock is enabled the driver should hold a reference to that clock.
Hence, the call to clk_put here are bogus and should be removed.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/sunxi/clk-sunxi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index bd7dc733c1ca..b1fde0f89bc1 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1297,17 +1297,13 @@ static void __init sunxi_clock_protect(void)
 
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
1.9.1


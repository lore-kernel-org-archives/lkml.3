Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbaEDRAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:00:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaEDPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 009/158] CLK: TI: OMAP4/5/DRA7: Remove gpmc_fck from dummy clocks
Date: Sun,  4 May 2014 11:38:38 -0400
Message-Id: <20140504154031.290826844@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Vaussard <florian.vaussard@epfl.ch>

commit 8559087f0e9722a95df43fa5968bd1ee42bcf540 upstream.

When arch/arm/mach-omap2/gpmc.c calls clk_get(..., "fck"), it will
get a dummy clock and try to use it. As the rate is configured to zero,
this will result in several divisions by zero, and misconfigured
timings, with devices on the bus being lost in the La La Land.

It is better to remove gpmc_fck from the dummy clocks, so that gpmc.c
can fail gracefully.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
Acked-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ti/clk-44xx.c |    1 -
 drivers/clk/ti/clk-54xx.c |    1 -
 drivers/clk/ti/clk-7xx.c  |    1 -
 3 files changed, 3 deletions(-)

--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -222,7 +222,6 @@ static struct ti_dt_clk omap44xx_clks[]
 	DT_CLK(NULL, "auxclk5_src_ck", "auxclk5_src_ck"),
 	DT_CLK(NULL, "auxclk5_ck", "auxclk5_ck"),
 	DT_CLK(NULL, "auxclkreq5_ck", "auxclkreq5_ck"),
-	DT_CLK("50000000.gpmc", "fck", "dummy_ck"),
 	DT_CLK("omap_i2c.1", "ick", "dummy_ck"),
 	DT_CLK("omap_i2c.2", "ick", "dummy_ck"),
 	DT_CLK("omap_i2c.3", "ick", "dummy_ck"),
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -182,7 +182,6 @@ static struct ti_dt_clk omap54xx_clks[]
 	DT_CLK(NULL, "auxclk3_src_ck", "auxclk3_src_ck"),
 	DT_CLK(NULL, "auxclk3_ck", "auxclk3_ck"),
 	DT_CLK(NULL, "auxclkreq3_ck", "auxclkreq3_ck"),
-	DT_CLK(NULL, "gpmc_ck", "dummy_ck"),
 	DT_CLK("omap_i2c.1", "ick", "dummy_ck"),
 	DT_CLK("omap_i2c.2", "ick", "dummy_ck"),
 	DT_CLK("omap_i2c.3", "ick", "dummy_ck"),
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -262,7 +262,6 @@ static struct ti_dt_clk dra7xx_clks[] =
 	DT_CLK(NULL, "vip1_gclk_mux", "vip1_gclk_mux"),
 	DT_CLK(NULL, "vip2_gclk_mux", "vip2_gclk_mux"),
 	DT_CLK(NULL, "vip3_gclk_mux", "vip3_gclk_mux"),
-	DT_CLK(NULL, "gpmc_ck", "dummy_ck"),
 	DT_CLK("omap_i2c.1", "ick", "dummy_ck"),
 	DT_CLK("omap_i2c.2", "ick", "dummy_ck"),
 	DT_CLK("omap_i2c.3", "ick", "dummy_ck"),



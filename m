Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaBXQZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:25:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:54491 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578AbaBXQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:25:09 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/5] clk: sun6i: Protect SDRAM gating bit
Date: Mon, 24 Feb 2014 17:22:45 +0100
Message-Id: <1393258967-4843-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent the SDRAM controller from being gated by force-enabling it in the clock
driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 6cfcd23..d9b4a41 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1302,6 +1302,13 @@ static void __init sunxi_clock_protect(void)
 		clk_put(clk);
 	}
 
+	/* DDR Gating clock - sun6i */
+	clk = clk_get(NULL, "ahb1_sdram");
+	if (!IS_ERR(clk)) {
+		clk_prepare_enable(clk);
+		clk_put(clk);
+	}
+
 	/* CPU clocks - sun6i */
 	clk = clk_get(NULL, "cpu");
 	if (!IS_ERR(clk)) {
-- 
1.9.0


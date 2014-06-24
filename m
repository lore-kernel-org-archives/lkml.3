Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaFXKAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:00:33 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41917 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaFXKAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:00:31 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v3 3/6] clk: sunxi: Support factor clocks with N factor starting not from 0
Date: Tue, 24 Jun 2014 17:59:37 +0800
Message-Id: <1403603980-31101-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403603980-31101-1-git-send-email-wens@csie.org>
References: <1403603980-31101-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLLs on newer Allwinner SoC's, such as the A31 and A23, have a
N multiplier factor that starts from 1, not 0.

This patch adds an option to the factor clk driver's config data
structures to specify the base value of N.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/clk/sunxi/clk-factors.c | 2 +-
 drivers/clk/sunxi/clk-factors.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index 3806d97..2057c8a 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -62,7 +62,7 @@ static unsigned long clk_factors_recalc_rate(struct clk_hw *hw,
 		p = FACTOR_GET(config->pshift, config->pwidth, reg);
 
 	/* Calculate the rate */
-	rate = (parent_rate * n * (k + 1) >> p) / (m + 1);
+	rate = (parent_rate * (n + config->n_start) * (k + 1) >> p) / (m + 1);
 
 	return rate;
 }
diff --git a/drivers/clk/sunxi/clk-factors.h b/drivers/clk/sunxi/clk-factors.h
index 02e1a43..d2d0efa 100644
--- a/drivers/clk/sunxi/clk-factors.h
+++ b/drivers/clk/sunxi/clk-factors.h
@@ -15,6 +15,7 @@ struct clk_factors_config {
 	u8 mwidth;
 	u8 pshift;
 	u8 pwidth;
+	u8 n_start;
 };
 
 struct clk_factors {
-- 
2.0.0


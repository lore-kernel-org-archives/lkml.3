Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbaDBNtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:49:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40475 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784AbaDBNtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:49:05 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
Date: Wed, 2 Apr 2014 16:48:45 +0300
Message-ID: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ABE DPLL frequency need to be lowered from 361267200
to 180633600 to facilitate the ATL requironments.
The dpll_abe_m2x2_ck clock need to be set to double
of ABE DPLL rate in order to have correct clocks
for audio.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/clk/ti/clk-7xx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index f7e40734c819..19a55bf407dd 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -16,7 +16,7 @@
 #include <linux/clkdev.h>
 #include <linux/clk/ti.h>
 
-#define DRA7_DPLL_ABE_DEFFREQ				361267200
+#define DRA7_DPLL_ABE_DEFFREQ				180633600
 #define DRA7_DPLL_GMAC_DEFFREQ				1000000000
 
 
@@ -322,6 +322,11 @@ int __init dra7xx_dt_clk_init(void)
 	if (rc)
 		pr_err("%s: failed to configure ABE DPLL!\n", __func__);
 
+	dpll_ck = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
+	rc = clk_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ * 2);
+	if (rc)
+		pr_err("%s: failed to configure ABE DPLL m2x2!\n", __func__);
+
 	dpll_ck = clk_get_sys(NULL, "dpll_gmac_ck");
 	rc = clk_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
 	if (rc)
-- 
1.9.1


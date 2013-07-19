Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144Ab3GSRRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:17:22 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42551 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3GSRRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:17:09 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/2] clk/zynq/pll: Use #defines for fbdiv min/max values
Date: Fri, 19 Jul 2013 10:16:45 -0700
Message-Id: <1374254205-9912-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <1374254205-9912-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1374254205-9912-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more descriptive #defines for the minimum and maximum PLL
feedback divider.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/zynq/pll.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/zynq/pll.c b/drivers/clk/zynq/pll.c
index 67f1b5e..26a8d8b 100644
--- a/drivers/clk/zynq/pll.c
+++ b/drivers/clk/zynq/pll.c
@@ -50,6 +50,9 @@ struct zynq_pll {
 #define PLLCTRL_RESET_MASK	1
 #define PLLCTRL_RESET_SHIFT	0
 
+#define PLL_FBDIV_MIN	13
+#define PLL_FBDIV_MAX	66
+
 /**
  * zynq_pll_round_rate() - Round a clock frequency
  * @hw:		Handle between common and hardware-specific interfaces
@@ -63,10 +66,10 @@ static long zynq_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 	u32 fbdiv;
 
 	fbdiv = DIV_ROUND_CLOSEST(rate, *prate);
-	if (fbdiv < 13)
-		fbdiv = 13;
-	else if (fbdiv > 66)
-		fbdiv = 66;
+	if (fbdiv < PLL_FBDIV_MIN)
+		fbdiv = PLL_FBDIV_MIN;
+	else if (fbdiv > PLL_FBDIV_MAX)
+		fbdiv = PLL_FBDIV_MAX;
 
 	return *prate * fbdiv;
 }
-- 
1.8.3.3


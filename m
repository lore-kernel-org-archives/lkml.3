Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaJJN54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:57:56 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:46287 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaJJN5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:57:52 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH] clk: qcom: Fix duplicate rbcpr clock name
Date: Fri, 10 Oct 2014 16:57:24 +0300
Message-Id: <1412949444-9792-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a duplication in a clock name for apq8084 platform that causes
the following warning: "RBCPR_CLK_SRC" redefined

Resolve this by adding a MMSS_ prefix to this clock and making its name
coherent with msm8974 platform.

Fixes: 2b46cd23a5a2 ("clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support")
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/clk/qcom/mmcc-apq8084.c               |    2 +-
 include/dt-bindings/clock/qcom,mmcc-apq8084.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
index dab988ab8cf1..157139a5c1ca 100644
--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -3122,7 +3122,7 @@ static struct clk_regmap *mmcc_apq8084_clocks[] = {
 	[ESC1_CLK_SRC] = &esc1_clk_src.clkr,
 	[HDMI_CLK_SRC] = &hdmi_clk_src.clkr,
 	[VSYNC_CLK_SRC] = &vsync_clk_src.clkr,
-	[RBCPR_CLK_SRC] = &rbcpr_clk_src.clkr,
+	[MMSS_RBCPR_CLK_SRC] = &rbcpr_clk_src.clkr,
 	[RBBMTIMER_CLK_SRC] = &rbbmtimer_clk_src.clkr,
 	[MAPLE_CLK_SRC] = &maple_clk_src.clkr,
 	[VDP_CLK_SRC] = &vdp_clk_src.clkr,
diff --git a/include/dt-bindings/clock/qcom,mmcc-apq8084.h b/include/dt-bindings/clock/qcom,mmcc-apq8084.h
index a929f86d0ddd..d72b5b35f15e 100644
--- a/include/dt-bindings/clock/qcom,mmcc-apq8084.h
+++ b/include/dt-bindings/clock/qcom,mmcc-apq8084.h
@@ -60,7 +60,7 @@
 #define ESC1_CLK_SRC			43
 #define HDMI_CLK_SRC			44
 #define VSYNC_CLK_SRC			45
-#define RBCPR_CLK_SRC			46
+#define MMSS_RBCPR_CLK_SRC		46
 #define RBBMTIMER_CLK_SRC		47
 #define MAPLE_CLK_SRC			48
 #define VDP_CLK_SRC			49
-- 
1.7.9.5


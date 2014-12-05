Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaLEXeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:34:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaLEW4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@linaro.org>
Subject: [PATCH 3.17 120/122] clk: qcom: Fix duplicate rbcpr clock name
Date: Fri,  5 Dec 2014 14:44:54 -0800
Message-Id: <20141205223324.261643265@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgi Djakov <gdjakov@mm-sol.com>

commit 9a6cb70f40b0268297024949eb0a2689e3b7769b upstream.

There is a duplication in a clock name for apq8084 platform that causes
the following warning: "RBCPR_CLK_SRC" redefined

Resolve this by adding a MMSS_ prefix to this clock and making its name
coherent with msm8974 platform.

Fixes: 2b46cd23a5a2 ("clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support")
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/mmcc-apq8084.c               |    2 +-
 include/dt-bindings/clock/qcom,mmcc-apq8084.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -3122,7 +3122,7 @@ static struct clk_regmap *mmcc_apq8084_c
 	[ESC1_CLK_SRC] = &esc1_clk_src.clkr,
 	[HDMI_CLK_SRC] = &hdmi_clk_src.clkr,
 	[VSYNC_CLK_SRC] = &vsync_clk_src.clkr,
-	[RBCPR_CLK_SRC] = &rbcpr_clk_src.clkr,
+	[MMSS_RBCPR_CLK_SRC] = &rbcpr_clk_src.clkr,
 	[RBBMTIMER_CLK_SRC] = &rbbmtimer_clk_src.clkr,
 	[MAPLE_CLK_SRC] = &maple_clk_src.clkr,
 	[VDP_CLK_SRC] = &vdp_clk_src.clkr,
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



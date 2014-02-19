Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaBSOUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:20:10 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:48275 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbaBSOUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:20:07 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] clk: qcom: Add missing clock at index GCC_XO_CLK for MSM8974
Date: Wed, 19 Feb 2014 16:18:41 +0200
Message-Id: <1392819521-25734-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Accessing GCC on MSM8974 trough <&gcc GCC_XO_CLK> lead to NULL
pointer dereference. Fix this.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/clk/qcom/gcc-msm8974.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
index 51d457e..98be7ea 100644
--- a/drivers/clk/qcom/gcc-msm8974.c
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -2625,6 +2625,8 @@ static int gcc_msm8974_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
+	clks[GCC_XO_CLK] = clk;
+
 	/* Should move to DT node? */
 	clk = clk_register_fixed_rate(dev, "sleep_clk_src", NULL,
 				      CLK_IS_ROOT, 32768);
-- 
1.7.9.5


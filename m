Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaEPRFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:05:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53706 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaEPRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:05:18 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: qcom: Fix msm8660 GCC probe
Date: Fri, 16 May 2014 10:05:14 -0700
Message-Id: <1400259914-28121-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When consolidating the msm8660 GCC probe code I forgot to keep
around these temporary clock registrations. Put them back so the
clock tree is not entirely orphaned.

Fixes: 49fc825f0cc2 (clk: qcom: Consolidate common probe code)
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/gcc-msm8660.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/clk/qcom/gcc-msm8660.c b/drivers/clk/qcom/gcc-msm8660.c
index 44bc6fa64d78..0c4b727ae429 100644
--- a/drivers/clk/qcom/gcc-msm8660.c
+++ b/drivers/clk/qcom/gcc-msm8660.c
@@ -2718,6 +2718,18 @@ MODULE_DEVICE_TABLE(of, gcc_msm8660_match_table);
 
 static int gcc_msm8660_probe(struct platform_device *pdev)
 {
+	struct clk *clk;
+	struct device *dev = &pdev->dev;
+
+	/* Temporary until RPM clocks supported */
+	clk = clk_register_fixed_rate(dev, "cxo", NULL, CLK_IS_ROOT, 19200000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	clk = clk_register_fixed_rate(dev, "pxo", NULL, CLK_IS_ROOT, 27000000);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	return qcom_cc_probe(pdev, &gcc_msm8660_desc);
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


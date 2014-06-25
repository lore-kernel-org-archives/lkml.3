Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbaFYVoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:44:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43908 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaFYVoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:44:22 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Clark <robdclark@gmail.com>
Subject: [PATCH] clk: qcom: HDMI source sel is 3 not 2
Date: Wed, 25 Jun 2014 14:44:19 -0700
Message-Id: <1403732659-14033-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HDMI PLL input to the tv mux is supposed to be 3, not 2. Fix
the code so that we can properly select the HDMI PLL.

Fixes: 6d00b56fe "clk: qcom: Add support for MSM8960's multimedia clock controller (MMCC)"
Reported-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/mmcc-msm8960.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index 12f3c0b64fcd..4c449b3170f6 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -1209,7 +1209,7 @@ static struct clk_branch rot_clk = {
 
 static u8 mmcc_pxo_hdmi_map[] = {
 	[P_PXO]		= 0,
-	[P_HDMI_PLL]	= 2,
+	[P_HDMI_PLL]	= 3,
 };
 
 static const char *mmcc_pxo_hdmi[] = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


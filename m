Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaEPXHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:07:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52401 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbaEPXHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:07:17 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/7] clk: qcom: Fix clk_rcg2_is_enabled() check
Date: Fri, 16 May 2014 16:07:08 -0700
Message-Id: <1400281634-9313-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
References: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the bit is set the clock is off so we should be checking for
a clear bit, not a set bit. Invert the logic.

Fixes: bcd61c0f535a (clk: qcom: Add support for root clock generators (RCGs))
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/clk-rcg2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 00f878a04d3f..0996a3a39855 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -55,7 +55,7 @@ static int clk_rcg2_is_enabled(struct clk_hw *hw)
 	if (ret)
 		return ret;
 
-	return (cmd & CMD_ROOT_OFF) != 0;
+	return (cmd & CMD_ROOT_OFF) == 0;
 }
 
 static u8 clk_rcg2_get_parent(struct clk_hw *hw)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


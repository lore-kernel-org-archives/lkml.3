Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaEPXH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:07:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52413 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbaEPXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:07:18 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/7] clk: qcom: Return highest rate when round_rate() exceeds plan
Date: Fri, 16 May 2014 16:07:10 -0700
Message-Id: <1400281634-9313-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
References: <1400281634-9313-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers may want to call clk_set_rate() with a very large
number to force the clock to go as fast as it possibly can
without having to know the range between the highest rate and
second highest rate. Add support for this by defaulting to the
highest rate in the frequency table if we can't find a frequency
greater than what is requested.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/clk-rcg2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 0996a3a39855..cbecaec30562 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -181,7 +181,8 @@ struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
 		if (rate <= f->freq)
 			return f;
 
-	return NULL;
+	/* Default to our fastest rate */
+	return f - 1;
 }
 
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


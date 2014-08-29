Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaH2Ttb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:49:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40387 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaH2Tta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:49:30 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>
Subject: [PATCH] clk: qcom: Fix sdc 144kHz frequency entry
Date: Fri, 29 Aug 2014 12:49:26 -0700
Message-Id: <1409341766-24366-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pre-divider for the sdc clocks only has 2 bits in it, so we
can't possibly divide by anything larger than 4 here.
Furthermore, we program the value of ~(n - m) and the n value is
larger than 8 bits (max of 256). Replace this entry with 200kHz
which is close enough to 144kHz to be usable.

Cc: Kumar Gala <galak@codeaurora.org>
Cc: Andy Gross <agross@codeaurora.org>
Fixes: 24d8fba44af3 "clk: qcom: Add support for IPQ8064's global clock controller (GCC)"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/gcc-ipq806x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq806x.c b/drivers/clk/qcom/gcc-ipq806x.c
index 4032e510d9aa..3b83b7dd78c7 100644
--- a/drivers/clk/qcom/gcc-ipq806x.c
+++ b/drivers/clk/qcom/gcc-ipq806x.c
@@ -1095,7 +1095,7 @@ static struct clk_branch prng_clk = {
 };
 
 static const struct freq_tbl clk_tbl_sdc[] = {
-	{    144000, P_PXO,   5, 18,625 },
+	{    200000, P_PXO,   2, 2, 125 },
 	{    400000, P_PLL8,  4, 1, 240 },
 	{  16000000, P_PLL8,  4, 1,   6 },
 	{  17070000, P_PLL8,  1, 2,  45 },
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


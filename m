Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbaGORPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:15:36 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58941 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaGORCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:11 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 19/94] clk: qcom: HDMI source sel is 3 not 2
Date: Tue, 15 Jul 2014 20:00:34 +0300
Message-Id: <1405443709-15288-19-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The HDMI PLL input to the tv mux is supposed to be 3, not 2. Fix
the code so that we can properly select the HDMI PLL.

Fixes: 6d00b56fe "clk: qcom: Add support for MSM8960's multimedia clock controller (MMCC)"
Reported-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/qcom/mmcc-msm8960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index 12f3c0b..4c449b3 100644
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
1.7.10.4


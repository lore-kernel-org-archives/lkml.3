Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301AbaGOXkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:40:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933925AbaGOXOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.15 39/84] clk: qcom: HDMI source sel is 3 not 2
Date: Tue, 15 Jul 2014 16:17:36 -0700
Message-Id: <20140715231714.371129972@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit c556bcddc78096caeb46dbe3ad0314dd951f1665 upstream.

The HDMI PLL input to the tv mux is supposed to be 3, not 2. Fix
the code so that we can properly select the HDMI PLL.

Fixes: 6d00b56fe "clk: qcom: Add support for MSM8960's multimedia clock controller (MMCC)"
Reported-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/mmcc-msm8960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -1208,7 +1208,7 @@ static struct clk_branch rot_clk = {
 
 static u8 mmcc_pxo_hdmi_map[] = {
 	[P_PXO]		= 0,
-	[P_HDMI_PLL]	= 2,
+	[P_HDMI_PLL]	= 3,
 };
 
 static const char *mmcc_pxo_hdmi[] = {



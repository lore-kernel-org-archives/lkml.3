Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaLDBFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:05:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54826 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLDBFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:05:45 -0500
Message-ID: <547FB368.8020003@codeaurora.org>
Date: Wed, 03 Dec 2014 17:05:44 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Rajendra Nayak <rnayak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kenneth Westfield <kwestfie@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 6/8] clk: qcom: Add IPQ806X LPASS clock controller
 (LCC) driver
References: <1416965735-10583-1-git-send-email-sboyd@codeaurora.org> <1416965735-10583-7-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1416965735-10583-7-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 05:35 PM, Stephen Boyd wrote:
> +
> +static struct clk_regmap_div mi2s_div_clk = {
> +	.reg = 0x48,
> +	.shift = 10,
> +	.width = 4,
> +	.clkr = {
> +		.hw.init = &(struct clk_init_data){
> +			.name = "mi2s_div_clk",
> +			.parent_names = lcc_mi2s_parents,
> +			.num_parents = 1,
> +			.ops = &clk_regmap_div_ops,
> +		},
> +	},
> +};

Oops this is wrong. Let's fold in this patch.

diff --git a/drivers/clk/qcom/lcc-ipq806x.c b/drivers/clk/qcom/lcc-ipq806x.c
index 80a1ecf2fe69..121ffde25dc3 100644
--- a/drivers/clk/qcom/lcc-ipq806x.c
+++ b/drivers/clk/qcom/lcc-ipq806x.c
@@ -188,7 +188,7 @@ static struct clk_branch mi2s_bit_div_clk = {
 		.enable_mask = BIT(15),
 		.hw.init = &(struct clk_init_data){
 			.name = "mi2s_bit_div_clk",
-			.parent_names = lcc_mi2s_parents,
+			.parent_names = (const char *[]){ "mi2s_div_clk" },
 			.num_parents = 1,
 			.ops = &clk_branch_ops,
 			.flags = CLK_SET_RATE_PARENT,


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project


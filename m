Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaJCRt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 13:49:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49736 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJCRtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 13:49:24 -0400
Message-ID: <542EE1A3.9050408@codeaurora.org>
Date: Fri, 03 Oct 2014 10:49:23 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1] clk: qcom: Add support for regmap clock dividers
References: <1412097655-10662-1-git-send-email-gdjakov@mm-sol.com> <542D953F.3030701@codeaurora.org> <542EBCFE.9050602@mm-sol.com>
In-Reply-To: <542EBCFE.9050602@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/14 08:13, Georgi Djakov wrote:
> On 10/02/2014 09:11 PM, Stephen Boyd wrote:
>> On 09/30/14 10:20, Georgi Djakov wrote:
>> +					unsigned long parent_rate)
>> +{
>> +	struct clk_regmap *rclk = to_clk_regmap(hw);
>> +	struct clkdiv_regmap *clkdiv = to_clkdiv_regmap(rclk);
>> +	unsigned int div, val;
>> +
>> +	regmap_read(rclk->regmap, clkdiv->reg, &val);
>> +	if (!val)
>> +		return parent_rate;
>> +
>> +	div = (val >> clkdiv->shift) & ((1 << clkdiv->width)-1);
>> +
>> +	return parent_rate / div;
>> I don't know if you saw the patch to split out the clk-divider.c logic
>> from the readl/writel patch I sent[1]? That could make this slightly
>> smaller.
>> tabl
> Could you please provide a link to that patch?

Doh, here it is: https://lkml.org/lkml/2014/9/5/762


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaJCSID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:08:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50571 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaJCSH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:07:59 -0400
Message-ID: <542EE5FE.9080806@codeaurora.org>
Date: Fri, 03 Oct 2014 11:07:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 04/15] clk: divider: Make generic for usage elsewhere
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org> <1409957256-23729-5-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1409957256-23729-5-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 15:47, Stephen Boyd wrote:
> +
> +int divider_get_val(unsigned long rate, unsigned long parent_rate,
> +		    const struct clk_div_table *table, u8 width,
> +		    unsigned long flags)
> +{
>  	unsigned int div, value;
> -	unsigned long flags = 0;
> -	u32 val;
>  
>  	div = DIV_ROUND_UP(parent_rate, rate);
>  
> -	if (!_is_valid_div(divider, div))
> +	if (!_is_valid_div(table, div, flags))
>  		return -EINVAL;
>  
> -	value = _get_val(divider, div);
> +	value = _get_val(table, div, flags);
> +
> +	min_t(unsigned int, value, div_mask(width));
> +
> +	return 0;

This should be return value, not return 0.

> +}
> +EXPORT_SYMBOL_GPL(divider_get_val);
>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


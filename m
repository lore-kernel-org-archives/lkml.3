Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbbAETeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:34:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44638 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbbAETee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:34:34 -0500
Message-ID: <54AAE748.9010200@codeaurora.org>
Date: Mon, 05 Jan 2015 11:34:32 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: Re: [PATCH] clk: fix possible null pointer dereference
References: <1420473863-30696-1-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1420473863-30696-1-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 08:04 AM, Stanimir Varbanov wrote:
> The commit 646cafc6 (clk: Change clk_ops->determine_rate to
> return a clk_hw as the best parent) opens a possibility for
> null pointer dereference, fix this.
>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>

Yep. Hopefully we can clean this all up soon.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

> ---
>  drivers/clk/clk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index f4963b7..d48ac71 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1366,7 +1366,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>  		new_rate = clk->ops->determine_rate(clk->hw, rate,
>  						    &best_parent_rate,
>  						    &parent_hw);
> -		parent = parent_hw->clk;
> +		parent = parent_hw ? parent_hw->clk : NULL;
>  	} else if (clk->ops->round_rate) {
>  		new_rate = clk->ops->round_rate(clk->hw, rate,
>  						&best_parent_rate);


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project


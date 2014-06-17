Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967695AbaFQWdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:33:14 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61291 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250AbaFQWdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:33:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1402702591-21087-1-git-send-email-sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1402702591-21087-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <20140617223305.32686.15540@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clkdev: Don't print errors on probe defer
Date: Tue, 17 Jun 2014 15:33:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2014-06-13 16:36:31)
> This error message can spam the logs if you have lots of probe
> deferals due to missing clocks. Just silence the error in this
> case because the driver should try again later.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Looks OK to me. Russell?

Regards,
Mike

> ---
>  drivers/clk/clkdev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index f890b901c6bc..da4bda8b7fc7 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -101,8 +101,9 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
>                 if (!IS_ERR(clk))
>                         break;
>                 else if (name && index >= 0) {
> -                       pr_err("ERROR: could not get clock %s:%s(%i)\n",
> -                               np->full_name, name ? name : "", index);
> +                       if (PTR_ERR(clk) != -EPROBE_DEFER)
> +                               pr_err("ERROR: could not get clock %s:%s(%i)\n",
> +                                       np->full_name, name ? name : "", index);
>                         return clk;
>                 }
>  
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

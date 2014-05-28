Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaE1CQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:16:08 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34343 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaE1CQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:16:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399479850-25292-1-git-send-email-t.figa@samsung.com>
Cc: "Maxime COQUELIN" <maxime.coquelin@st.com>, linux-kernel@vger.kernel.org,
        "Tomasz Figa" <t.figa@samsung.com>
References: <1399479850-25292-1-git-send-email-t.figa@samsung.com>
Message-ID: <20140528021602.10062.60638@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: divider: Fix overflow in clk_divider_bestdiv
Date: Tue, 27 May 2014 19:16:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomasz Figa (2014-05-07 09:24:10)
> Commit c686078 ("clk: divider: Add round to closest divider") introduced
> a helper function to check whether given divisor is the best one instead
> of direct check. However due to int type used instead of unsigned long
> for passing calculated rates to this function in certain cases an
> overflow could occur, for example when trying to obtain maximum possible
> clock rate by calling clk_round_rate(..., UINT_MAX).
> 
> This patch fixes this issue by changing the type of rate, now and best
> arguments of the function to unsigned long, which is the type that
> should be used for clock rates.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>

Sorry for the long wait. This one flew under the radar. Applied to
clk-next.

Regards,
Mike

> ---
>  drivers/clk/clk-divider.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index c572945..e0b360a 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -232,7 +232,7 @@ static int _div_round(struct clk_divider *divider, unsigned long parent_rate,
>  }
>  
>  static bool _is_best_div(struct clk_divider *divider,
> -               int rate, int now, int best)
> +               unsigned long rate, unsigned long now, unsigned long best)
>  {
>         if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
>                 return abs(rate - now) < abs(rate - best);
> -- 
> 1.9.2
> 

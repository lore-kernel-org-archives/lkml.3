Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaEWVj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:39:29 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55802 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaEWVjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:39:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maxime COQUELIN <maxime.coquelin@st.com>,
        "Fabio Estevam" <festevam@gmail.com>,
        "Shawn Guo" <shawn.guo@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com>
Cc: maxime.coquelin@st.com
References: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com>
Message-ID: <20140523213915.23136.16939@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: divider: Fix table round up function
Date: Fri, 23 May 2014 14:39:15 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Maxime COQUELIN (2014-05-07 09:48:52)
> Commit 1d9fe6b97 ("clk: divider: Fix best div calculation for power-of-two and
> table dividers") introduces a regression in its _table_round_up function.
> 
> When the divider passed to this function is greater than the max divider
> available in the table, this function returns table's max divider.
> Problem is that it causes an infinite loop in clk_divider_bestdiv() because
> _next_div() will never return a value greater than maxdiv.
> 
> Instead of returning table's max divider, this patch returns INT_MAX.
> 
> Reported-by: Fabio Estevam <festevam@gmail.com>
> Reported-by: Shawn Guo <shawn.guo@freescale.com>
> Tested-by: Fabio Estevam <festevam@gmail.com>
> Cc: Mike Turquette <mike.turquette@linaro.org>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Pulled into clk-fixes for -rc7.

Regards,
Mike

> ---
>  drivers/clk/clk-divider.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index b3c8396..cf9114a 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -158,7 +158,7 @@ static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
>  static int _round_up_table(const struct clk_div_table *table, int div)
>  {
>         const struct clk_div_table *clkt;
> -       int up = _get_table_maxdiv(table);
> +       int up = INT_MAX;
>  
>         for (clkt = table; clkt->div; clkt++) {
>                 if (clkt->div == div)
> -- 
> 1.9.1
> 

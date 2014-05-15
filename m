Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaEOQvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:51:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54601 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaEOQvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:51:23 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-21-5374f0833679
Message-id: <5374F07E.9070106@samsung.com>
Date: Thu, 15 May 2014 18:51:10 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: linux-arm-kernel@lists.infradead.org
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Maxime COQUELIN <maxime.coquelin@st.com>
Subject: Re: [PATCH] clk: divider: Fix overflow in clk_divider_bestdiv
References: <1399479850-25292-1-git-send-email-t.figa@samsung.com>
In-reply-to: <1399479850-25292-1-git-send-email-t.figa@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xq7rNH0qCDZ5MEbDY9Pgaq8XlXXPY
	LB6dXsxm8XTCRTYHFo871/aweWxeUu/x9MdeZo/Pm+QCWKK4bFJSczLLUov07RK4Mi69ky24
	y13RsG0mWwPjXs4uRk4OCQETiZvdK5ggbDGJC/fWs4HYQgJLGSW65jN2MXIB2Z8ZJb7+PgVU
	xMHBK6AlseydNkgNi4CqxLJ598B62QTUJD43PALr5QcqWdN0nQWkXFQgQuLxBSGQMK+AoMSP
	yfdYQGwRAQ2JKV2P2UFsZoESiUs/7zCC2MICbhLLN95ngjjBSeLl9h6wkZwCzhKftl9lg6jX
	kdjfOg3KlpfYvOYt8wRGwVlIVsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GCHB/GUH4+JjVocYBTgYlXh4O/YXBwuxJpYVV+YeYpTgYFYS4TV/XhIsxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgTGv91Th7jijd86exyXntpzbHvTGLC148beXFddSl8Q6nUzcFSgz68XUgKwX
	VWtXdt4QTFhpcO7eEyevKZ6f5rm+edbwPXRHkZlzZf+HtnitpGXB304Fsz1RYv0vdiXM4Xb/
	h5I64d43wfJfXgoK59pIrJIV8ixZukh01Y4zL/lOp0r1tAsqhyuxFGckGmoxFxUnAgA5zYPn
	RAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 07.05.2014 18:24, Tomasz Figa wrote:
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
> -		int rate, int now, int best)
> +		unsigned long rate, unsigned long now, unsigned long best)
>  {
>  	if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
>  		return abs(rate - now) < abs(rate - best);
> 

Ping. It's quite important fix as the issue makes all Exynos boards
using sdhci-s3c almost unusable.

Best regards,
Tomasz

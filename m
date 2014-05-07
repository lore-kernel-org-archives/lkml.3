Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaEGQvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:51:14 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35891 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbaEGQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:51:13 -0400
Message-ID: <536A645B.9000709@st.com>
Date: Wed, 7 May 2014 18:50:35 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, <linux-arm-kernel@lists.infradead.org>
Cc: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: divider: Fix overflow in clk_divider_bestdiv
References: <1399479850-25292-1-git-send-email-t.figa@samsung.com>
In-Reply-To: <1399479850-25292-1-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.129.6.132]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-07_05:2014-05-07,2014-05-07,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 05/07/2014 06:24 PM, Tomasz Figa wrote:
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
Good catch.

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime
>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>   drivers/clk/clk-divider.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index c572945..e0b360a 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -232,7 +232,7 @@ static int _div_round(struct clk_divider *divider, unsigned long parent_rate,
>   }
>
>   static bool _is_best_div(struct clk_divider *divider,
> -		int rate, int now, int best)
> +		unsigned long rate, unsigned long now, unsigned long best)
>   {
>   	if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
>   		return abs(rate - now) < abs(rate - best);
>

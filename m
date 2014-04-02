Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaDBOMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:12:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38096 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbaDBOMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:12:23 -0400
Message-ID: <533C1AC2.1000307@ti.com>
Date: Wed, 2 Apr 2014 17:12:18 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
References: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 04:48 PM, Peter Ujfalusi wrote:
> ABE DPLL frequency need to be lowered from 361267200
> to 180633600 to facilitate the ATL requironments.
> The dpll_abe_m2x2_ck clock need to be set to double
> of ABE DPLL rate in order to have correct clocks
> for audio.

Do you have some sort of TRM reference for this?

-Tero

>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>   drivers/clk/ti/clk-7xx.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
> index f7e40734c819..19a55bf407dd 100644
> --- a/drivers/clk/ti/clk-7xx.c
> +++ b/drivers/clk/ti/clk-7xx.c
> @@ -16,7 +16,7 @@
>   #include <linux/clkdev.h>
>   #include <linux/clk/ti.h>
>
> -#define DRA7_DPLL_ABE_DEFFREQ				361267200
> +#define DRA7_DPLL_ABE_DEFFREQ				180633600
>   #define DRA7_DPLL_GMAC_DEFFREQ				1000000000
>
>
> @@ -322,6 +322,11 @@ int __init dra7xx_dt_clk_init(void)
>   	if (rc)
>   		pr_err("%s: failed to configure ABE DPLL!\n", __func__);
>
> +	dpll_ck = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
> +	rc = clk_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ * 2);
> +	if (rc)
> +		pr_err("%s: failed to configure ABE DPLL m2x2!\n", __func__);
> +
>   	dpll_ck = clk_get_sys(NULL, "dpll_gmac_ck");
>   	rc = clk_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
>   	if (rc)
>


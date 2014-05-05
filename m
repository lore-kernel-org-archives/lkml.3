Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaEEMXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:23:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54952 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbaEEMXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:23:05 -0400
Message-ID: <53678269.2000306@ti.com>
Date: Mon, 5 May 2014 15:22:01 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <davem@davemloft.net>, <richardcochran@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <dborkman@redhat.com>,
        <ast@plumgrid.com>, <tklauser@distanz.ch>, <mpa@pengutronix.de>,
        <bhutchings@solarflare.com>, <zonque@gmail.com>, <balbi@ti.com>,
        <mugunthanvnm@ti.com>, <mturquette@linaro.org>,
        <linux@arm.linux.org.uk>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v2 5/6] ARM: AM43xx: clk: Change the cpts ref clock source
 to dpll_core_m5 clk
References: <1399012324-20737-1-git-send-email-george.cherian@ti.com> <1399012324-20737-6-git-send-email-george.cherian@ti.com>
In-Reply-To: <1399012324-20737-6-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 09:32 AM, George Cherian wrote:
> cpsw_cpts_rft_clk has got the choice of 3 clocksources
>   -dpll_core_m4_ck
>   -dpll_core_m5_ck
>   -dpll_disp_m2_ck
>
> By default dpll_core_m4_ck is selected, witn this as clock
> source the CPTS doesnot work properly. It gives clockcheck errors
> while running PTP.
>
>   clockcheck: clock jumped backward or running slower than expected!
>
> By selecting dpll_core_m5_ck as the clocksource fixes this issue.
> In AM335x dpll_core_m5_ck is the default clocksource.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>

Acked-by: Tero Kristo <t-kristo@ti.com>

> ---
>   drivers/clk/ti/clk-43xx.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/drivers/clk/ti/clk-43xx.c b/drivers/clk/ti/clk-43xx.c
> index 67c8de5..b4877e0 100644
> --- a/drivers/clk/ti/clk-43xx.c
> +++ b/drivers/clk/ti/clk-43xx.c
> @@ -110,9 +110,25 @@ static struct ti_dt_clk am43xx_clks[] = {
>
>   int __init am43xx_dt_clk_init(void)
>   {
> +	struct clk *clk1, *clk2;
> +
>   	ti_dt_clocks_register(am43xx_clks);
>
>   	omap2_clk_disable_autoidle_all();
>
> +	/*
> +	 * cpsw_cpts_rft_clk  has got the choice of 3 clocksources
> +	 * dpll_core_m4_ck, dpll_core_m5_ck and dpll_disp_m2_ck.
> +	 * By default dpll_core_m4_ck is selected, witn this as clock
> +	 * source the CPTS doesnot work properly. It gives clockcheck errors
> +	 * while running PTP.
> +	 * clockcheck: clock jumped backward or running slower than expected!
> +	 * By selecting dpll_core_m5_ck as the clocksource fixes this issue.
> +	 * In AM335x dpll_core_m5_ck is the default clocksource.
> +	 */
> +	clk1 = clk_get_sys(NULL, "cpsw_cpts_rft_clk");
> +	clk2 = clk_get_sys(NULL, "dpll_core_m5_ck");
> +	clk_set_parent(clk1, clk2);
> +
>   	return 0;
>   }
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaGBOXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:23:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53360 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbaGBOXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:23:10 -0400
Message-ID: <53B415E2.9090203@ti.com>
Date: Wed, 2 Jul 2014 17:23:30 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 1/8] CLK: ti: dra7: Initialize USB_DPLL
References: <1394197751-28984-1-git-send-email-rogerq@ti.com> <1394197751-28984-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1394197751-28984-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 03:09 PM, Roger Quadros wrote:
> USB_DPLL must be initialized and locked at boot so that
> USB modules can work.
>
> Also program USB_DLL_M2 output to half rate.
>
> CC: Mike Turquette <mturquette@linaro.org>
> CC: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   drivers/clk/ti/clk-7xx.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)

Hi,

Resurrecting this patch, as it seems the clock-parenting stuff via DT 
hasn't really moved that much forward.

Thus, this patch has been now queued for 3.17, thanks.

-Tero

>
> diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
> index 9977653..f89f3c2 100644
> --- a/drivers/clk/ti/clk-7xx.c
> +++ b/drivers/clk/ti/clk-7xx.c
> @@ -18,6 +18,7 @@
>
>   #define DRA7_DPLL_ABE_DEFFREQ				361267200
>   #define DRA7_DPLL_GMAC_DEFFREQ				1000000000
> +#define DRA7_DPLL_USB_DEFFREQ				960000000
>
>
>   static struct ti_dt_clk dra7xx_clks[] = {
> @@ -328,5 +329,15 @@ int __init dra7xx_dt_clk_init(void)
>   	if (rc)
>   		pr_err("%s: failed to configure GMAC DPLL!\n", __func__);
>
> +	dpll_ck = clk_get_sys(NULL, "dpll_usb_ck");
> +	rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ);
> +	if (rc)
> +		pr_err("%s: failed to configure USB DPLL!\n", __func__);
> +
> +	dpll_ck = clk_get_sys(NULL, "dpll_usb_m2_ck");
> +	rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ/2);
> +	if (rc)
> +		pr_err("%s: failed to set USB_DPLL M2 OUT\n", __func__);
> +
>   	return rc;
>   }
>


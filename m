Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3HAPGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:06:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52061 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3HAPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:06:32 -0400
Message-ID: <51FA7976.8020707@ti.com>
Date: Thu, 1 Aug 2013 10:06:30 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <rnayak@ti.com>, <benoit.cousson@linaro.org>,
        <balbi@ti.com>, <george.cherian@ti.com>, <kishon@ti.com>,
        <dmurphy@ti.com>, <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] CLK: ti: dra7: Initialize USB_DPLL
References: <1375369134-26398-1-git-send-email-rogerq@ti.com> <1375369134-26398-2-git-send-email-rogerq@ti.com>
In-Reply-To: <1375369134-26398-2-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 09:58 AM, Roger Quadros wrote:
> USB_DPLL must be initialized and locked at boot so that
> USB modules can work.
>
> Also program USB_DLL_M2 output to half rate.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   drivers/clk/omap/clk-7xx.c |   11 +++++++++++
>   1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/clk/omap/clk-7xx.c b/drivers/clk/omap/clk-7xx.c
> index ddb39dd..f444513 100644
> --- a/drivers/clk/omap/clk-7xx.c
> +++ b/drivers/clk/omap/clk-7xx.c
> @@ -19,6 +19,7 @@
>
>   #define DRA7_DPLL_ABE_DEFFREQ				361267200
>   #define DRA7_DPLL_GMAC_DEFFREQ				1000000000
> +#define DRA7_DPLL_USB_DEFFREQ				960000000
>
>
>   static struct omap_dt_clk dra7xx_clks[] = {
> @@ -63,5 +64,15 @@ int __init dra7xx_clk_init(void)
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
As I had mentioned on [1] - we are going to see similar needs keep 
popping up. there is no need to hack this up for even more peripherals :(

http://marc.info/?l=linux-omap&m=137536803106017&w=2

-- 
Regards,
Nishanth Menon

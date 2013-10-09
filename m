Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3JIHLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:11:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46895 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3JIHLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:11:42 -0400
Message-ID: <52550180.1000506@ti.com>
Date: Wed, 9 Oct 2013 10:10:56 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] Revert "ARM: OMAP2+: Provide alias to USB PHY
 clock"
References: <1381226799-29158-1-git-send-email-rogerq@ti.com> <1381226799-29158-6-git-send-email-rogerq@ti.com>
In-Reply-To: <1381226799-29158-6-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 10/08/2013 01:06 PM, Roger Quadros wrote:
> This reverts commit 741532c4a995be11815cb72d4d7a48f442a22fea.
> 
> The proper clock reference is provided in device tree so we
> no longer need this.

Could you please Ack this one? I think it is best if it goes through Benoit's tree.

cheers,
-roger

> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/mach-omap2/board-generic.c |   23 +----------------------
>  1 files changed, 1 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index cd85b36..da4e9b2 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -15,7 +15,6 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
>  #include <linux/irqdomain.h>
> -#include <linux/clk.h>
>  
>  #include <asm/mach/arch.h>
>  
> @@ -36,21 +35,6 @@ static struct of_device_id omap_dt_match_table[] __initdata = {
>  	{ }
>  };
>  
> -/*
> - * Create alias for USB host PHY clock.
> - * Remove this when clock phandle can be provided via DT
> - */
> -static void __init legacy_init_ehci_clk(char *clkname)
> -{
> -	int ret;
> -
> -	ret = clk_add_alias("main_clk", NULL, clkname, NULL);
> -	if (ret) {
> -		pr_err("%s:Failed to add main_clk alias to %s :%d\n",
> -						__func__, clkname, ret);
> -	}
> -}
> -
>  static void __init omap_generic_init(void)
>  {
>  	omap_sdrc_init(NULL, NULL);
> @@ -61,15 +45,10 @@ static void __init omap_generic_init(void)
>  	 * HACK: call display setup code for selected boards to enable omapdss.
>  	 * This will be removed when omapdss supports DT.
>  	 */
> -	if (of_machine_is_compatible("ti,omap4-panda")) {
> +	if (of_machine_is_compatible("ti,omap4-panda"))
>  		omap4_panda_display_init_of();
> -		legacy_init_ehci_clk("auxclk3_ck");
> -
> -	}
>  	else if (of_machine_is_compatible("ti,omap4-sdp"))
>  		omap_4430sdp_display_init_of();
> -	else if (of_machine_is_compatible("ti,omap5-uevm"))
> -		legacy_init_ehci_clk("auxclk1_ck");
>  }
>  
>  #ifdef CONFIG_SOC_OMAP2420
> 


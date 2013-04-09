Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160Ab3DIIyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:54:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46896 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935034Ab3DIIyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:54:20 -0400
Message-ID: <5163D72B.5040205@ti.com>
Date: Tue, 9 Apr 2013 10:54:03 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <rnayak@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH] ARM: OMAP4: HWMOD: make 'ocp2scp_usb_phy_phy_48m" as
 the main clock
References: <1365496101-7829-1-git-send-email-kishon@ti.com>
In-Reply-To: <1365496101-7829-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 04/09/2013 10:28 AM, Kishon Vijay Abraham I wrote:
> commit 92702d (ARM: OMAP4: PM: fix PM regression introduced by recent
> clock cleanup) makes the 'ocp2scp_usb_phy_phy_48m' as optional
> functional clock causing regression in MUSB. But this 48MHz clock is a
> mandatory clock for usb phy attached to ocp2scp and hence made as the main
> clock for ocp2scp.

It is a fix for 3.9-rcX?

Regards,
Benoit

> 
> Cc: Keerthy <j-keerthy@ti.com>
> Cc: Benoît Cousson <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> index 9e05765..c1fb090 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -2714,16 +2714,12 @@ static struct omap_ocp2scp_dev ocp2scp_dev_attr[] = {
>  	{ }
>  };
>  
> -static struct omap_hwmod_opt_clk ocp2scp_usb_phy_opt_clks[] = {
> -	{ .role = "48mhz", .clk = "ocp2scp_usb_phy_phy_48m" },
> -};
> -
>  /* ocp2scp_usb_phy */
>  static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
>  	.name		= "ocp2scp_usb_phy",
>  	.class		= &omap44xx_ocp2scp_hwmod_class,
>  	.clkdm_name	= "l3_init_clkdm",
> -	.main_clk	= "func_48m_fclk",
> +	.main_clk	= "ocp2scp_usb_phy_phy_48m",
>  	.prcm = {
>  		.omap4 = {
>  			.clkctrl_offs = OMAP4_CM_L3INIT_USBPHYOCP2SCP_CLKCTRL_OFFSET,
> @@ -2732,8 +2728,6 @@ static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
>  		},
>  	},
>  	.dev_attr	= ocp2scp_dev_attr,
> -	.opt_clks	= ocp2scp_usb_phy_opt_clks,
> -	.opt_clks_cnt	= ARRAY_SIZE(ocp2scp_usb_phy_opt_clks),
>  };
>  
>  /*
> 


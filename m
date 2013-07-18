Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab3GRHCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:02:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33580 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335Ab3GRHCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:02:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18f3/qb4Z+W815dyk3WxOo1
Date: Thu, 18 Jul 2013 00:02:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, kyungmin.park@samsung.com, balbi@ti.com,
        jg1.han@samsung.com, s.nawrocki@samsung.com, kgene.kim@samsung.com,
        grant.likely@linaro.org, arnd@arndb.de, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com
Subject: Re: [PATCH 04/15] ARM: OMAP: USB: Add phy binding information
Message-ID: <20130718070219.GM7656@atomide.com>
References: <1374129984-765-1-git-send-email-kishon@ti.com>
 <1374129984-765-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374129984-765-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [130717 23:53]:
> In order for controllers to get PHY in case of non dt boot, the phy
> binding information (phy device name) should be added in the platform
> data of the controller.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/mach-omap2/usb-musb.c |    3 +++
>  include/linux/usb/musb.h       |    3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
> index 8c4de27..6aa7cbf 100644
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -85,6 +85,9 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>  	musb_plat.mode = board_data->mode;
>  	musb_plat.extvbus = board_data->extvbus;
>  
> +	if (cpu_is_omap34xx())
> +		musb_plat.phy_label = "twl4030";
> +
>  	if (soc_is_am35xx()) {
>  		oh_name = "am35x_otg_hs";
>  		name = "musb-am35x";

I don't think there's a USB PHY on non-twl4030 chips, so this should
be OK:

Acked-by: Tony Lindgren <tony@atomide.com>


> diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
> index 053c268..596f8c8 100644
> --- a/include/linux/usb/musb.h
> +++ b/include/linux/usb/musb.h
> @@ -104,6 +104,9 @@ struct musb_hdrc_platform_data {
>  	/* for clk_get() */
>  	const char	*clock;
>  
> +	/* phy label */
> +	const char	*phy_label;
> +
>  	/* (HOST or OTG) switch VBUS on/off */
>  	int		(*set_vbus)(struct device *dev, int is_on);
>  
> -- 
> 1.7.10.4
> 

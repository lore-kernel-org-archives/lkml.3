Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3GPMoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:44:54 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12005 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3GPMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:44:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18831mS0Kmp7Yb4FbciYoEL
Date: Tue, 16 Jul 2013 05:44:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/4] arm: omap: Add phy binding info for musb in
 plat data
Message-ID: <20130716124442.GZ7656@atomide.com>
References: <1373282057-20181-1-git-send-email-kishon@ti.com>
 <1373282057-20181-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373282057-20181-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [130708 04:20]:
> In order for controllers to get PHY in case of non dt boot, the phy
> binding information (phy label) should be added in the platform
> data of the controller.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/usb-musb.c |    3 +++
>  include/linux/usb/musb.h       |    3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
> index 8c4de27..20b42de 100644
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -85,6 +85,9 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>  	musb_plat.mode = board_data->mode;
>  	musb_plat.extvbus = board_data->extvbus;
>  
> +	if (cpu_is_omap34xx())
> +		musb_plat.phy_name = "twl4030";
> +
>  	if (soc_is_am35xx()) {
>  		oh_name = "am35x_otg_hs";
>  		name = "musb-am35x";
> diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
> index 053c268..c05d46d 100644
> --- a/include/linux/usb/musb.h
> +++ b/include/linux/usb/musb.h
> @@ -104,6 +104,9 @@ struct musb_hdrc_platform_data {
>  	/* for clk_get() */
>  	const char	*clock;
>  
> +	/* phy device label */
> +	const char	*phy_name;
> +
>  	/* (HOST or OTG) switch VBUS on/off */
>  	int		(*set_vbus)(struct device *dev, int is_on);
>  
> -- 
> 1.7.10.4
> 

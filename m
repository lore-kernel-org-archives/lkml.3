Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbaHYR0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:26:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57931 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaHYR0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:26:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199XhszqenisoXQAFaXuzCv
Date: Mon, 25 Aug 2014 10:26:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, Dave Gerlach <d-gerlach@ti.com>
Subject: Re: [PATCH 2/3] pinctrl: single: Add DRA7 pinctrl compatibility
Message-ID: <20140825172602.GN17254@atomide.com>
References: <1408716062-26055-1-git-send-email-nm@ti.com>
 <1408716062-26055-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408716062-26055-3-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140822 07:03]:
> DRA7 pinctrl definitions now differ from traditional 16 bit OMAP pin
> ctrl definitions, in that all 32 bits are used to describe a single pin
> 
> Also the location of wakeupenable and event bits have changed.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  .../bindings/pinctrl/ti,omap-pinctrl.txt           |    1 +
>  drivers/pinctrl/pinctrl-single.c                   |    7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
> index 156d964..d45386d 100644
> --- a/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
> @@ -5,5 +5,6 @@ Required properties:
>    "ti,omap3-padconf" - OMAP3 compatible pinctrl
>    "ti,omap4-padconf" - OMAP4 compatible pinctrl
>    "ti,omap5-padconf" - OMAP5 compatible pinctrl
> +  "ti,dra7-padconf" - DRA7 compatible pinctrl
>  
>  See Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt for further details.
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 95dd9cf..598d600 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -1981,6 +1981,12 @@ static const struct pcs_soc_data pinctrl_single_omap_wkup = {
>  	.irq_status_mask = (1 << 15),	/* OMAP_WAKEUP_EVENT */
>  };
>  
> +static const struct pcs_soc_data pinctrl_single_dra7 = {
> +	.flags = PCS_QUIRK_SHARED_IRQ,
> +	.irq_enable_mask = (1 << 24),	/* WAKEUPENABLE */
> +	.irq_status_mask = (1 << 25),	/* WAKEUPEVENT */
> +};
> +
>  static const struct pcs_soc_data pinctrl_single = {
>  };
>  
> @@ -1992,6 +1998,7 @@ static struct of_device_id pcs_of_match[] = {
>  	{ .compatible = "ti,omap3-padconf", .data = &pinctrl_single_omap_wkup },
>  	{ .compatible = "ti,omap4-padconf", .data = &pinctrl_single_omap_wkup },
>  	{ .compatible = "ti,omap5-padconf", .data = &pinctrl_single_omap_wkup },
> +	{ .compatible = "ti,dra7-padconf", .data = &pinctrl_single_dra7 },
>  	{ .compatible = "pinctrl-single", .data = &pinctrl_single },
>  	{ .compatible = "pinconf-single", .data = &pinconf_single },
>  	{ },
> -- 
> 1.7.9.5
> 

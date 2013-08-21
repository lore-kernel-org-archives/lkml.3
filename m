Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3HUIEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:04:53 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25040 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3HUIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:04:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18TKtdYzRZaIKmVdOYgg93E
Date: Wed, 21 Aug 2013 01:04:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
Subject: Re: [RESEND PATCH] ARM: OMAP: TI81XX: add always-on powerdomain
 for TI81XX
Message-ID: <20130821080444.GD7656@atomide.com>
References: <1376986544-26714-1-git-send-email-aida.mynzhasova@skitlab.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376986544-26714-1-git-send-email-aida.mynzhasova@skitlab.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

Care to queue or ack this one?

* Aida Mynzhasova <aida.mynzhasova@skitlab.ru> [130820 01:22]:
> This patch adds alwon powerdomain support for TI81XX, which is required
> for stable functioning of a big number of TI81XX subsystems.
> 
> Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
> ---
>  arch/arm/mach-omap2/powerdomains3xxx_data.c | 8 ++++++++
>  arch/arm/mach-omap2/prcm-common.h           | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/powerdomains3xxx_data.c b/arch/arm/mach-omap2/powerdomains3xxx_data.c
> index e2d4bd8..328c103 100644
> --- a/arch/arm/mach-omap2/powerdomains3xxx_data.c
> +++ b/arch/arm/mach-omap2/powerdomains3xxx_data.c
> @@ -336,6 +336,13 @@ static struct powerdomain dpll5_pwrdm = {
>  	.voltdm		  = { .name = "core" },
>  };
>  
> +static struct powerdomain alwon_81xx_pwrdm = {
> +	.name		  = "alwon_pwrdm",
> +	.prcm_offs	  = TI81XX_PRM_ALWON_MOD,
> +	.pwrsts		  = PWRSTS_OFF_ON,
> +	.voltdm		  = { .name = "core" },
> +};
> +
>  static struct powerdomain device_81xx_pwrdm = {
>  	.name		  = "device_pwrdm",
>  	.prcm_offs	  = TI81XX_PRM_DEVICE_MOD,
> @@ -442,6 +449,7 @@ static struct powerdomain *powerdomains_am35x[] __initdata = {
>  };
>  
>  static struct powerdomain *powerdomains_ti81xx[] __initdata = {
> +	&alwon_81xx_pwrdm,
>  	&device_81xx_pwrdm,
>  	&active_816x_pwrdm,
>  	&default_816x_pwrdm,
> diff --git a/arch/arm/mach-omap2/prcm-common.h b/arch/arm/mach-omap2/prcm-common.h
> index ff1ac4a..0e841fd 100644
> --- a/arch/arm/mach-omap2/prcm-common.h
> +++ b/arch/arm/mach-omap2/prcm-common.h
> @@ -58,6 +58,7 @@
>  #define TI816X_PRM_IVAHD1_MOD			0x0d00
>  #define TI816X_PRM_IVAHD2_MOD			0x0e00
>  #define TI816X_PRM_SGX_MOD				0x0f00
> +#define TI81XX_PRM_ALWON_MOD			0x1800
>  
>  /* 24XX register bits shared between CM & PRM registers */
>  
> -- 
> 1.8.1.2
> 

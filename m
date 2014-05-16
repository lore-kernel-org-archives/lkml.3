Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaEPVKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:10:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59973 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753139AbaEPVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:10:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Ot5crNBvWZias1HMUUrdm
Date: Fri, 16 May 2014 14:10:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: omap3stalker: remove two Kconfig macros
Message-ID: <20140516211029.GD12881@atomide.com>
References: <1400179065.11786.14.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400179065.11786.14.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [140515 11:38]:
> Checks for CONFIG_OMAP2_VENC_OUT_TYPE_SVIDEO and
> CONFIG_OMAP2_VENC_OUT_TYPE_COMPOSITE were added in v2.6.35. But the
> related Kconfig symbols have never been added to the tree. Remove these
> checks.
> 
> Initialize connector_type to OMAP_DSS_VENC_TYPE_COMPOSITE explicitly.
> That's what's happening currently: OMAP_DSS_VENC_TYPE_COMPOSITE equals
> zero and connector_type remains zero since both checks currently fail.

Thanks applying into omap-for-v3.16/board.

Tony
 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  arch/arm/mach-omap2/board-omap3stalker.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
> index 119efaf5808a..a2e035e0792a 100644
> --- a/arch/arm/mach-omap2/board-omap3stalker.c
> +++ b/arch/arm/mach-omap2/board-omap3stalker.c
> @@ -121,11 +121,7 @@ static struct platform_device omap3stalker_tfp410_device = {
>  static struct connector_atv_platform_data omap3stalker_tv_pdata = {
>  	.name = "tv",
>  	.source = "venc.0",
> -#if defined(CONFIG_OMAP2_VENC_OUT_TYPE_SVIDEO)
> -	.connector_type = OMAP_DSS_VENC_TYPE_SVIDEO,
> -#elif defined(CONFIG_OMAP2_VENC_OUT_TYPE_COMPOSITE)
>  	.connector_type = OMAP_DSS_VENC_TYPE_COMPOSITE,
> -#endif
>  	.invert_polarity = false,
>  };
>  
> -- 
> 1.9.0
> 

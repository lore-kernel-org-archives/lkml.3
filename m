Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab3CTQaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:30:52 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:39513 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980Ab3CTQav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:30:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18FWYNMdZpVQ3tenJYdbfjy
Date: Wed, 20 Mar 2013 09:30:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: fix typo "CONFIG_SMC91x_MODULE"
Message-ID: <20130320163043.GM16413@atomide.com>
References: <1362744397.5994.58.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362744397.5994.58.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [130308 04:10]:
> There's a (rather subtle) typo in "CONFIG_SMC91x_MODULE". Fix it once
> and for all by using IS_ENABLED(), which is designed to avoid issues
> like this.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested! And this needs build- and runtime testing, especially for the
> MODULE case!

Thanks looks good to me. Since this is for legacy platforms and been
broken for quite a while, I'll apply it into omap-for-v3.10/fixes-non-critical.

Regards,

Tony
 
>  arch/arm/mach-omap2/board-2430sdp.c | 2 +-
>  arch/arm/mach-omap2/board-h4.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
> index a3e0aaa..cb0596b 100644
> --- a/arch/arm/mach-omap2/board-2430sdp.c
> +++ b/arch/arm/mach-omap2/board-2430sdp.c
> @@ -166,7 +166,7 @@ static void __init sdp2430_display_init(void)
>  	omap_display_init(&sdp2430_dss_data);
>  }
>  
> -#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91x_MODULE)
> +#if IS_ENABLED(CONFIG_SMC91X)
>  
>  static struct omap_smc91x_platform_data board_smc91x_data = {
>  	.cs		= 5,
> diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
> index 812c829..5b4ec51 100644
> --- a/arch/arm/mach-omap2/board-h4.c
> +++ b/arch/arm/mach-omap2/board-h4.c
> @@ -246,7 +246,7 @@ static u32 is_gpmc_muxed(void)
>  		return 0;
>  }
>  
> -#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91x_MODULE)
> +#if IS_ENABLED(CONFIG_SMC91X)
>  
>  static struct omap_smc91x_platform_data board_smc91x_data = {
>  	.cs		= 1,
> -- 
> 1.7.11.7
> 

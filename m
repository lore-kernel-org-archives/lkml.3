Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3IRUj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:39:59 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57408 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3IRUj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:39:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18c7VyXZ1oG5T5EZk6b1wWW
Date: Wed, 18 Sep 2013 13:39:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] RX-51: Add support for OMAP3 ROM Random Number
 Generator
Message-ID: <20130918203949.GI9994@atomide.com>
References: <201303281854.02847@pali>
 <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <1379534757-20870-3-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379534757-20870-3-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130918 13:15]:
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Description please, then also add a note that this makes
sense to do as a platform device at least until we have
some ARM generic way to deal with SMC calls.

>  arch/arm/mach-omap2/board-rx51.c  |   10 ++++++++++
>  arch/arm/mach-omap2/omap-secure.c |   11 +++++++++++
>  arch/arm/mach-omap2/omap-secure.h |    1 +
>  3 files changed, 22 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
> index db168c9..c2a3e39 100644
> --- a/arch/arm/mach-omap2/board-rx51.c
> +++ b/arch/arm/mach-omap2/board-rx51.c
> @@ -93,6 +93,14 @@ static struct omap_musb_board_data musb_board_data = {
>  	.power			= 0,
>  };
>  
> +static struct platform_device omap3_rom_rng_device = {
> +	.name		= "omap_rng",
> +	.id		= -1,
> +	.dev	= {
> +		.platform_data	= rx51_secure_rng_call,
> +	},
> +};
> +
>  static void __init rx51_init(void)
>  {
>  	struct omap_sdrc_params *sdrc_params;
> @@ -113,6 +121,8 @@ static void __init rx51_init(void)
>  		/* set IBE to 1 */
>  		rx51_secure_update_aux_cr(BIT(6), 0);
>  #endif
> +		pr_info("RX-51: Registring OMAP3 HWRNG device\n");
> +		platform_device_register(&omap3_rom_rng_device);
>  	}
>  
>  	/* Ensure SDRC pins are mux'd for self-refresh */

Maybe this should be in board-rx51-peripherals.c instead?

That way we can initialize the legacy platform devices
from there for DT based booting too and don't have to
move code around when moving to DT based booting.

Regards,

Tony

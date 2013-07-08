Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3GHMBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:01:14 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60560 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3GHMBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:01:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/SkhNJF14iCMDWYUT+fznw
Date: Mon, 8 Jul 2013 05:01:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@infradead.org,
        arm@kernel.org
Subject: Re: [PATCH 6/8] ARM: OMAP: omap_common_late_init may be unused
Message-ID: <20130708120110.GX5523@atomide.com>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
 <1373041417-217728-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373041417-217728-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130705 09:28]:
> Some OMAP SoCs use this function while others do not, and that
> causes a warning when building multi_v7_defconfig. Marking the
> function __maybe_unused silences the harmless warning without the
> need to add complex #ifdef logic.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
> index fe3253a..4a3f06f 100644
> --- a/arch/arm/mach-omap2/io.c
> +++ b/arch/arm/mach-omap2/io.c
> @@ -394,7 +394,7 @@ static void __init omap_hwmod_init_postsetup(void)
>  	omap_pm_if_early_init();
>  }
>  
> -static void __init omap_common_late_init(void)
> +static void __init __maybe_unused omap_common_late_init(void)
>  {
>  	omap_mux_late_init();
>  	omap2_common_pm_late_init();
> -- 
> 1.8.3.1
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaHTNZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:25:39 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46186 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHTNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:25:37 -0400
Date: Wed, 20 Aug 2014 06:25:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        "open list:WATCHDOG DEVICE D..." <linux-watchdog@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] booke_wdt: Fix build failure as a module
Message-ID: <20140820132527.GB8664@roeck-us.net>
References: <1408504328-11324-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408504328-11324-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 11:12:07PM -0400, Pranith Kumar wrote:
> Building booke_wdt fails when trying to build as a module as there is no
> early_param() in module. Fix by enclosing within MODULE check.
> 
Might make more sense to replace the early_param with a normal module parameter.
Taking the module parameter away if the driver is built as module seems to be
a bit excessive.

Any idea why early_param was chosen over a standard module parameter ?

Guenter

> Also remove notrace attribute as it is implicit in the __init attribute.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  drivers/watchdog/booke_wdt.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
> index 08a7853..8a26b54 100644
> --- a/drivers/watchdog/booke_wdt.c
> +++ b/drivers/watchdog/booke_wdt.c
> @@ -41,8 +41,9 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
>  #define WDTP_MASK	(TCR_WP_MASK)
>  #endif
>  
> +#ifndef MODULE
>  /* Checks wdt=x and wdt_period=xx command-line option */
> -notrace int __init early_parse_wdt(char *p)
> +int __init early_parse_wdt(char *p)
>  {
>  	if (p && strncmp(p, "0", 1) != 0)
>  		booke_wdt_enabled = 1;
> @@ -63,6 +64,8 @@ int __init early_parse_wdt_period(char *p)
>  }
>  early_param("wdt_period", early_parse_wdt_period);
>  
> +#endif /* #ifndef MODULE */
> +
>  #ifdef CONFIG_PPC_FSL_BOOK3E
>  
>  /* For the specified period, determine the number of seconds
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3C3Sg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 14:36:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37657 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab3C3Sg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 14:36:56 -0400
Date: Sat, 30 Mar 2013 19:36:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130330183654.GH28947@amd.pavel.ucw.cz>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +u32 rx51_secure_dispatcher(u32 idx, u32 flag, u32 nargs, u32 arg1, u32 arg2,
> +			   u32 arg3, u32 arg4)
> +{
> +	u32 ret;
> +	u32 param[5];
> +
> +	param[0] = nargs+1;
> +	param[1] = arg1;
> +	param[2] = arg2;
> +	param[3] = arg3;
> +	param[4] = arg4;
> +
> +	/*
> +	 * Secure API needs physical address
> +	 * pointer for the parameters
> +	 */
> +	flush_cache_all();
> +	outer_clean_range(__pa(param), __pa(param + 5));
> +	ret = rx51_ppa_smc(idx, flag, __pa(param));
> +
> +	return ret;
> +}

You can do without ret variable... Also more detailed changelog would
be nice... like what exact problem this works around.

<google>

So... some CPU errata where code sharing virtual addresses could be
executed improperly?
								
> @@ -103,6 +104,12 @@ static void __init rx51_init(void)
>  	rx51_peripherals_init();
>  	rx51_camera_init();
>  
> +#ifdef CONFIG_ARM_ERRATA_430973
> +	printk(KERN_INFO "Enabling ARM errata 430973 workaround.\n");
> +	/* set IBE to 1 */
> +	rx51_secure_update_aux_cr(1 << 6, 0);
> +#endif
> +

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

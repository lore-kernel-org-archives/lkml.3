Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbbA2L2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:28:24 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33903 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbbA2L2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:28:22 -0500
Date: Thu, 29 Jan 2015 11:28:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        sylvain.rochet@finsecur.com, peda@axentia.se,
        sergei.shtylyov@cogentembedded.com, linux@maxim.org.za
Subject: Re: [PATCH v4 05/13] pm: at91: move the copying the sram function to
 the sram initializationi phase
Message-ID: <20150129112800.GV26493@n2100.arm.linux.org.uk>
References: <1422409172-24178-1-git-send-email-wenyou.yang@atmel.com>
 <1422409396-24394-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422409396-24394-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 09:43:16AM +0800, Wenyou Yang wrote:
> -#ifdef CONFIG_AT91_SLOW_CLOCK
> -				/* copy slow_clock handler to SRAM, and call it */
> -				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
> -#endif
>  				slow_clock(at91_pmc_base, at91_ramc_base[0],
>  					   at91_ramc_base[1],
>  					   at91_pm_data.memctrl);
> @@ -272,6 +268,9 @@ static void __init at91_pm_sram_init(void)
>  	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
>  	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz, false);
>  
> +	/* Copy the slow_clock handler to SRAM */
> +	memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
> +

Why is this code not using the fncpy() support for copying functions.
Why is it not checking the return code from __arm_ioremap_exec() or
gen_pool_virt_to_phys() for failure?

This looks like quite a massive review failure when this code was
originally merged.  It needs fixing.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.

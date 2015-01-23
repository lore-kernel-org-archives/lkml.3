Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbbAWQu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:50:28 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:43518 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbAWQuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:50:25 -0500
Date: Fri, 23 Jan 2015 17:50:20 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        peda@axentia.se, linux-arm-kernel@lists.infradead.org
Message-ID: <20150123165020.GA24210@gradator.net>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
 <1421741825-18226-8-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421741825-18226-8-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH 07/12] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wenyou,


On Tue, Jan 20, 2015 at 04:17:00PM +0800, Wenyou Yang wrote:
> 
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 691e6db..a1010f0 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c


> @@ -145,62 +145,51 @@ extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0,
>  			    void __iomem *ramc1, int memctrl);
>  extern u32 at91_slow_clock_sz;
>  
> +static void at91_pm_suspend(suspend_state_t state)
> +{
      (...)
> +	slow_clock(at91_pmc_base, at91_ramc_base[0],
> +			at91_ramc_base[1], pm_data);
> +}


> -			if (slow_clock) {
> -				slow_clock(at91_pmc_base, at91_ramc_base[0],
> -					   at91_ramc_base[1],
> -					   at91_pm_data.memctrl);
      (...)
> +               at91_pm_suspend(state);


By doing that you removed the condition "if (slow_clock)".

But slow_clock can still be NULL, see commit d2e4679, there are multiple 
reasons which ends up with a NULL slow_clock.


Sylvain

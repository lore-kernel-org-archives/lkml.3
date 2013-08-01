Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3HAFqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:46:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58867 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab3HAFqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:46:30 -0400
Message-ID: <51F9F626.80306@ti.com>
Date: Thu, 1 Aug 2013 11:16:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <arm@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 03/18] ARM: davinci: Switch to sched_clock_register()
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org> <1375309877-16617-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1375309877-16617-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 August 2013 04:01 AM, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
> 
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-davinci/time.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
> index 7a55b5c..6d5440a 100644
> --- a/arch/arm/mach-davinci/time.c
> +++ b/arch/arm/mach-davinci/time.c
> @@ -285,7 +285,7 @@ static struct clocksource clocksource_davinci = {
>  /*
>   * Overwrite weak default sched_clock with something more precise
>   */
> -static u32 notrace davinci_read_sched_clock(void)
> +static u64 notrace davinci_read_sched_clock(void)
>  {
>  	return timer32_read(&timers[TID_CLOCKSOURCE]);
>  }
> @@ -392,7 +392,7 @@ void __init davinci_timer_init(void)
>  				    davinci_clock_tick_rate))
>  		printk(err, clocksource_davinci.name);
>  
> -	setup_sched_clock(davinci_read_sched_clock, 32,
> +	sched_clock_register(davinci_read_sched_clock, 32,
>  			  davinci_clock_tick_rate);

Please fix the line break to align with open parens. Otherwise looks
good. I tested it on DA850 EVM as well. With above fixed:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar


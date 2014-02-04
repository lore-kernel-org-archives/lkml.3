Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaBDTPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:15:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37229 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaBDTPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:15:02 -0500
Date: Tue, 4 Feb 2014 11:15:00 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: footbridge: Switch to sched_clock_register()
Message-ID: <20140204191500.GB20528@codeaurora.org>
References: <1389922207-5154-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389922207-5154-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Stephen Boyd wrote:
> The 32 bit sched_clock interface supports 64 bits since 3.13-rc1.
> Upgrade to the 64 bit function to allow us to remove the 32 bit
> registration interface.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Russell,

Can you please apply this for 3.14? This is the last user of the
deprecated interface in linus' tree. Once this is merged I will
remove setup_sched_clock(). It's 7945/1 in the patch tracker.

> 
> Based on rmk/for-next
> 
>  arch/arm/mach-footbridge/dc21285-timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-footbridge/dc21285-timer.c b/arch/arm/mach-footbridge/dc21285-timer.c
> index 3971104d32d4..5d2725fd878c 100644
> --- a/arch/arm/mach-footbridge/dc21285-timer.c > +++ b/arch/arm/mach-footbridge/dc21285-timer.c
> @@ -125,7 +125,7 @@ void __init footbridge_timer_init(void)
>  	clockevents_config_and_register(ce, rate, 0x4, 0xffffff);
>  }
>  
> -static u32 notrace footbridge_read_sched_clock(void)
> +static u64 notrace footbridge_read_sched_clock(void)
>  {
>  	return ~*CSR_TIMER3_VALUE;
>  }
> @@ -138,5 +138,5 @@ void __init footbridge_sched_clock(void)
>  	*CSR_TIMER3_CLR = 0;
>  	*CSR_TIMER3_CNTL = TIMER_CNTL_ENABLE | TIMER_CNTL_DIV16;
>  
> -	setup_sched_clock(footbridge_read_sched_clock, 24, rate);
> +	sched_clock_register(footbridge_read_sched_clock, 24, rate);
>  }
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3GVIKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:10:05 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:40904
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab3GVIJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:09:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 22 Jul 2013 16:10:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 10/17] clocksource: mxs_timer: Switch to
 sched_clock_register()
Message-ID: <20130722081025.GE20271@S2101-09.ap.freescale.net>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <1374189690-10810-11-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1374189690-10810-11-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:21:23PM -0700, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

BTW, will the series break setup_sched_clock() users that are not
converted, like arch/arm/mach-imx/time.c?  I can understand that's the
consequence of not moving things into drivers/ folder :)

Shawn

> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clocksource/mxs_timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
> index 0f5e65f..445b68a 100644
> --- a/drivers/clocksource/mxs_timer.c
> +++ b/drivers/clocksource/mxs_timer.c
> @@ -222,7 +222,7 @@ static struct clocksource clocksource_mxs = {
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
>  
> -static u32 notrace mxs_read_sched_clock_v2(void)
> +static u64 notrace mxs_read_sched_clock_v2(void)
>  {
>  	return ~readl_relaxed(mxs_timrot_base + HW_TIMROT_RUNNING_COUNTn(1));
>  }
> @@ -236,7 +236,7 @@ static int __init mxs_clocksource_init(struct clk *timer_clk)
>  	else {
>  		clocksource_mmio_init(mxs_timrot_base + HW_TIMROT_RUNNING_COUNTn(1),
>  			"mxs_timer", c, 200, 32, clocksource_mmio_readl_down);
> -		setup_sched_clock(mxs_read_sched_clock_v2, 32, c);
> +		sched_clock_register(mxs_read_sched_clock_v2, 32, c);
>  	}
>  
>  	return 0;
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 


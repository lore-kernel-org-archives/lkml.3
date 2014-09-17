Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaIQBJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:09:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51314 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaIQBJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:09:25 -0400
Date: Tue, 16 Sep 2014 18:09:23 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Michael Opdenacker <michael@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: timer-sp: ensure interrupt is cleared at
 sp804_clockevents_init
Message-ID: <20140917010923.GB10233@codeaurora.org>
References: <1410914571-8388-1-git-send-email-chanho.min@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410914571-8388-1-git-send-email-chanho.min@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Chanho Min wrote:
> When sp804 is registerd as clock event device, it may not be added to

s/registerd/registered/

> tick device if the higher rated device is already registerd. In this case,

s/registerd/registered/

> for uncertan reason, inetrrupt is occured without event_handler it cause

s/inetrrupt/interrupt/

> kernel panic. So Interrupt should be cleared before clockevent is registered.
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  arch/arm/common/timer-sp.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
> index fd6bff0..b658873 100644
> --- a/arch/arm/common/timer-sp.c
> +++ b/arch/arm/common/timer-sp.c
> @@ -205,6 +205,8 @@ void __init __sp804_clockevents_init(void __iomem *base, unsigned int irq, struc
>  
>  	writel(0, base + TIMER_CTRL);
>  
> +	/* Ensure interrupt is cleared */
> +	writel(1, clkevt_base + TIMER_INTCLR);
>  	setup_irq(irq, &sp804_timer_irq);
>  	clockevents_config_and_register(evt, rate, 0xf, 0xffffffff);

Or just flip the order of clockevents_config_and_register() and
setup_irq()? We've done this in other clockevents drivers.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

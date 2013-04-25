Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab3DYOTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:19:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:44177 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3DYOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:18:59 -0400
Date: Thu, 25 Apr 2013 16:18:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Andres Salomon <dilinger@queued.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
In-Reply-To: <51793172.9030802@pengutronix.de>
Message-ID: <alpine.LFD.2.02.1304251618220.21884@ionos>
References: <517687AB.1040309@pengutronix.de> <1366722524-25991-1-git-send-email-mkl@pengutronix.de> <51793172.9030802@pengutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Marc Kleine-Budde wrote:

> On 04/23/2013 03:08 PM, Marc Kleine-Budde wrote:
> > The commit
> > 
> >     77cc982 clocksource: use clockevents_config_and_register() where possible
> > 
> > switches from manually calculating min_delta_ns (and others) and
> > clockevents_register_device() to automatic calculation via
> > clockevents_config_and_register(). During this conversation the "+ 1" in
> > 
> >     min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
> > 
> > was lost. This leads to problems with schedule_delayed_work() with a delay of
> > "1". Resulting in the work not scheduled in time.
> > 
> > This patch fixes the problem by increasing the min_delta to "2" ticks.
> > 
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> Who will take care of this patch?

If you had cc'ed me in the first place ...
 
> Marc
> 
> > ---
> >  drivers/clocksource/tcb_clksrc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
> > index 8a61872..7cf6dc7 100644
> > --- a/drivers/clocksource/tcb_clksrc.c
> > +++ b/drivers/clocksource/tcb_clksrc.c
> > @@ -197,7 +197,7 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
> >  
> >  	clkevt.clkevt.cpumask = cpumask_of(0);
> >  
> > -	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
> > +	clockevents_config_and_register(&clkevt.clkevt, 32768, 2, 0xffff);
> >  
> >  	setup_irq(irq, &tc_irqaction);
> >  }
> > 
> 
> 
> -- 
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |
> 
> 

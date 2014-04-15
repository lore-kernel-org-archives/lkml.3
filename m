Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaDOVxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:53:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:60610 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDOVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:53:19 -0400
Date: Tue, 15 Apr 2014 23:53:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Xiubo Li <Li.Xiubo@freescale.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: vf_pit_timer: fix pit_read_sched_clock
In-Reply-To: <534D27AB.7070109@linaro.org>
Message-ID: <alpine.DEB.2.02.1404152352560.22697@ionos.tec.linutronix.de>
References: <1397558929-12123-1-git-send-email-Li.Xiubo@freescale.com> <534D27AB.7070109@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Daniel Lezcano wrote:
> On 04/15/2014 12:48 PM, Xiubo Li wrote:
> > The pit_read_sched_clock mean to getting the current counter value,
> > and the vf pit timer is a down count timer, this should return
> > the counter value or the cycles elapsed.
> > 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >   drivers/clocksource/vf_pit_timer.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clocksource/vf_pit_timer.c
> > b/drivers/clocksource/vf_pit_timer.c
> > index 02821b0..a918bc4 100644
> > --- a/drivers/clocksource/vf_pit_timer.c
> > +++ b/drivers/clocksource/vf_pit_timer.c
> > @@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(void)
> > 
> >   static u64 pit_read_sched_clock(void)
> >   {
> > -	return __raw_readl(clksrc_base + PITCVAL);
> > +	return ~__raw_readl(clksrc_base + PITCVAL);
> >   }
> > 
> >   static int __init pit_clocksource_init(unsigned long rate)
> > 
> 
> Hi Xiubo,
> 
> thanks for the patch but this has already been fixed [1] and is available in
> the timers/urgent branch.

It's in Linus tree already and tagged for stable.

Thanks,

	tglx

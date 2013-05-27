Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab3E0N6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:58:51 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:39797 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3E0N6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:58:50 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 09:58:50 EDT
Date: Mon, 27 May 2013 16:49:10 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] clocksource: dw_apb: fix error check
Message-ID: <20130527134910.GU5037@tarshish>
References: <90d7cc35674bf04806531eb2e9836fdc382868d9.1369655478.git.baruch@tkos.co.il>
 <51A35C2F.4000201@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A35C2F.4000201@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, May 27, 2013 at 03:14:23PM +0200, Daniel Lezcano wrote:
> On 05/27/2013 01:51 PM, Baruch Siach wrote:
> > irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
> > This breaks on platforms that have NO_IRQ != 0.
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> 
> Shouldn't the 'irq_of_parse_and_map' function to be fixed and return
> NO_IRQ in case of error ? (even if some code checks the return value is
> 'zero' in case of error [1], while some other code checks NO_IRQ [2]).

Probably not. See http://lwn.net/Articles/470820/.

baruch

> [1]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/devicetree.c#n124
> 
> [2]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/powerpc/sysdev/fsl_msi.c#n344
> 
> 
> >  drivers/clocksource/dw_apb_timer_of.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
> > index 9fdb4d3..843d43b 100644
> > --- a/drivers/clocksource/dw_apb_timer_of.c
> > +++ b/drivers/clocksource/dw_apb_timer_of.c
> > @@ -47,7 +47,7 @@ static void add_clockevent(struct device_node *event_timer)
> >  	u32 irq, rate;
> >  
> >  	irq = irq_of_parse_and_map(event_timer, 0);
> > -	if (irq == NO_IRQ)
> > +	if (irq == 0)
> >  		panic("No IRQ for clock event timer");
> >  
> >  	timer_get_base_and_rate(event_timer, &iobase, &rate);

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3HLDDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 23:03:36 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:38464 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3HLDDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 23:03:35 -0400
Date: Mon, 12 Aug 2013 06:03:29 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linux-Xtensa] Re: [PATCH] time: sched_clock: fix integer
 overflow
Message-ID: <20130812030329.GB6440@tarshish>
References: <232c026d1b8d2556679aea56cf77a6811f9a96c5.1374054369.git.baruch@tkos.co.il>
 <20130729055939.GK5161@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729055939.GK5161@tarshish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, John,

On Mon, Jul 29, 2013 at 08:59:39AM +0300, Baruch Siach wrote:
> On Wed, Jul 17, 2013 at 12:46:53PM +0300, Baruch Siach wrote:
> > The expression '(1 << 32)' happens to evaluate as 0 on ARM, but it evaluates as
> > 1 on xtensa and x86_64. This zeros sched_clock_mask, and breaks sched_clock().
> > Set the type of 1 to 'unsigned long long' to get the value we need.
> 
> Ping? -rc3 is out, and this bug (which currently breaks xtensa) is not fixed 
> yet. Please consider applying.

Sorry to bother again, but -rc5 is here and xtensa sched_clock is still 
broken.

baruch

> > Reported-by: Max Filippov <jcmvbkbc@gmail.com>
> > Tested-by: Max Filippov <jcmvbkbc@gmail.com>
> > Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  kernel/time/sched_clock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
> > index a326f27..0b479a6 100644
> > --- a/kernel/time/sched_clock.c
> > +++ b/kernel/time/sched_clock.c
> > @@ -121,7 +121,7 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
> >  	BUG_ON(bits > 32);
> >  	WARN_ON(!irqs_disabled());
> >  	read_sched_clock = read;
> > -	sched_clock_mask = (1 << bits) - 1;
> > +	sched_clock_mask = (1ULL << bits) - 1;
> >  	cd.rate = rate;
> >  
> >  	/* calculate the mult/shift to convert counter ticks to ns. */
> > -- 

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaJHPUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:20:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:38368 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaJHPUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:20:48 -0400
Date: Wed, 8 Oct 2014 17:20:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v4 21/29] nios2: Time keeping
In-Reply-To: <3820417.zXtDk8QPj1@wuerfel>
Message-ID: <alpine.DEB.2.11.1410081719340.4292@nanos>
References: <1412760595-3935-1-git-send-email-lftan@altera.com> <1412760595-3935-22-git-send-email-lftan@altera.com> <alpine.DEB.2.11.1410081240110.4292@nanos> <3820417.zXtDk8QPj1@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014, Arnd Bergmann wrote:
> On Wednesday 08 October 2014 12:44:32 Thomas Gleixner wrote:
> > > +static int num_called;
> > > +static void __init nios2_time_init(struct device_node *timer)
> > > +{
> > > +     switch (num_called) {
> > > +     case 0:
> > > +             nios2_clockevent_init(timer);
> > > +             break;
> > > +     case 1:
> > > +             nios2_clocksource_init(timer);
> > > +             break;
> > > +     default:
> > > +             break;
> > > +     }
> > > +
> > > +     num_called++;
> > > +}
> > 
> > Eew. So this depends on the DT ordering. If thats wrong, then stuff
> > will be initialized in the wrong oder. 
> > 
> > > +CLOCKSOURCE_OF_DECLARE(nios2_timer, "altr,timer-1.0", nios2_time_init);
> > 
> > Why can't you have separate match entries with where one calls
> > nios2_clockevent_init and the other nios2_clocksource_init?
> 
> I believe we have the same logic in other drivers as well, the intention
> being that if you have multiple identical timers, the first one will
> be used as clockevent and the second one (if there is more than one)
> becomes the clocksource.
> 
> If the hardware is really identical, I would argue that the comaptible
> string ought to be the same as well, as the DT is not supposed to
> care about what the timers are used for in Linux.

So why do we need two calls at all if we have one piece of hardware
which has two functions? We know that already, don't we?

Thanks,

	tglx

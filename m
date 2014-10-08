Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaJHPR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:17:56 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52315 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbaJHPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:17:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH v4 21/29] nios2: Time keeping
Date: Wed, 08 Oct 2014 17:17:46 +0200
Message-ID: <3820417.zXtDk8QPj1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410081240110.4292@nanos>
References: <1412760595-3935-1-git-send-email-lftan@altera.com> <1412760595-3935-22-git-send-email-lftan@altera.com> <alpine.DEB.2.11.1410081240110.4292@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TPgJ3XN6N+FYJBOE2hfKdHgjPiQJ/muLkFwlVVUQfPg
 hhf9PsIM2eRq0gRlNqZGBsX95YOKUuhVlFIqdYiJxQGeJ1O3QS
 sSq9FSzLDNgE/lLXtL2MobrhPHxRORcIAlm1dXfMB15/MmRSns
 XcnECKAu1rnnlet9PWk6rstDqPtsm7HQ9LsoLhXkDtw1ujViyL
 YDh56WVjf/o5Od9t+/8zm5gKTad8bwOLH+mkjwA11NcuHo9PCD
 NCJFn+HPgKvRBa/MVkGzCybgYGO3NPCEZRdn4+n71ch9jyik+m
 QNHsw75KxxebHvV9kXzN30byzNQOERgEmELIUUffEwx/uFDYIz
 VdbAkpnK3kPiN9Ez1hRA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 12:44:32 Thomas Gleixner wrote:
> > +static int num_called;
> > +static void __init nios2_time_init(struct device_node *timer)
> > +{
> > +     switch (num_called) {
> > +     case 0:
> > +             nios2_clockevent_init(timer);
> > +             break;
> > +     case 1:
> > +             nios2_clocksource_init(timer);
> > +             break;
> > +     default:
> > +             break;
> > +     }
> > +
> > +     num_called++;
> > +}
> 
> Eew. So this depends on the DT ordering. If thats wrong, then stuff
> will be initialized in the wrong oder. 
> 
> > +CLOCKSOURCE_OF_DECLARE(nios2_timer, "altr,timer-1.0", nios2_time_init);
> 
> Why can't you have separate match entries with where one calls
> nios2_clockevent_init and the other nios2_clocksource_init?

I believe we have the same logic in other drivers as well, the intention
being that if you have multiple identical timers, the first one will
be used as clockevent and the second one (if there is more than one)
becomes the clocksource.

If the hardware is really identical, I would argue that the comaptible
string ought to be the same as well, as the DT is not supposed to
care about what the timers are used for in Linux.

	Arnd

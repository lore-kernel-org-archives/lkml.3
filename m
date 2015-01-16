Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbbAPKff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:35:35 -0500
Received: from down.free-electrons.com ([37.187.137.238]:32993 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365AbbAPKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:35:32 -0500
Date: Fri, 16 Jan 2015 11:35:30 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] clocksource: don't suspend/resume when unused
Message-ID: <20150116103530.GB3843@piout.net>
References: <1421399874-29119-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421399874-29119-3-git-send-email-alexandre.belloni@free-electrons.com>
 <alpine.DEB.2.11.1501161122320.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501161122320.5526@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/2015 at 11:23:32 +0100, Thomas Gleixner wrote :
> On Fri, 16 Jan 2015, Alexandre Belloni wrote:
> 
> > There is no point in calling suspend/resume for unused
> > clocksources.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >  kernel/time/clocksource.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> > index 920a4da58eb0..baea4e42ae90 100644
> > --- a/kernel/time/clocksource.c
> > +++ b/kernel/time/clocksource.c
> > @@ -493,7 +493,7 @@ void clocksource_suspend(void)
> >  	struct clocksource *cs;
> >  
> >  	list_for_each_entry_reverse(cs, &clocksource_list, list)
> > -		if (cs->suspend)
> > +		if (cs->suspend && (cs->flags & CLOCK_SOURCE_USED))
> >  			cs->suspend(cs);
> 
> This might be dangerous. If the clocksource has no enable/disable
> callbacks, but suspend/resume, then you might leave it enabled across
> suspend.
> 

Isn't that already the case?
Right now, if you call clocksource_suspend, it doesn't matter whether
the clocksource has an enable or not, it will be suspended. Maybe I'm
mistaken but my patch doesn't seem to change that behaviour.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

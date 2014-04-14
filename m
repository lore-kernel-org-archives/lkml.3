Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaDNLDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:03:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50560 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaDNLC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:02:57 -0400
Date: Mon, 14 Apr 2014 13:02:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
Message-ID: <20140414110245.GG11096@twins.programming.kicks-ass.net>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
 <CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
 <20140410143857.GA27654@localhost.localdomain>
 <CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
 <20140411145333.GC3438@localhost.localdomain>
 <20140411151825.GX11096@twins.programming.kicks-ass.net>
 <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 10:08:30PM +0530, Viresh Kumar wrote:
> On 11 April 2014 20:48, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Apr 11, 2014 at 04:53:35PM +0200, Frederic Weisbecker wrote:
> 
> > I think there's assumptions that tick runs on the local cpu;
> 
> Yes, many function behave that way, i.e. with smp_processor_id() as
> CPU.
> 
> > also what
> > are you going to do when running it on all remote cpus takes longer than
> > the tick?
> >
> >> Otherwise (and ideally) we need to make the scheduler code able to handle long periods without
> >> calling scheduler_tick(). But this is a lot more plumbing. And the scheduler has gazillions
> >> accounting stuffs to handle. Sounds like a big nightmare to take that direction.
> >
> > So i'm not at all sure what you guys are talking about, but it seems to
> > me you should all put down the bong and have a detox round instead.
> >
> > This all sounds like a cure worse than the problem.
> 
> So, what I was working on isn't ready yet but I would like to show what lines
> I have been trying on. In case that is completely incorrect and I should stop
> making that work :)
> 
> Please share your feedback about this (Yes there are several parts broken
> currently, specially the assumption that tick runs on local CPU):

I'm still not sure _what_ you're trying to solve here. What are you
doing and why?

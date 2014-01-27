Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaA0QyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:54:12 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34541 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaA0QyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:54:10 -0500
Date: Mon, 27 Jan 2014 08:54:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rcu: Eliminate softirq processing from rcutree
Message-ID: <20140127165405.GK9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387773533.5369.16.camel@marge.simpson.net>
 <20131224193636.GD19211@linux.vnet.ibm.com>
 <1387940854.5373.8.camel@marge.simpson.net>
 <20131225075544.GE19211@linux.vnet.ibm.com>
 <1387993057.5346.17.camel@marge.simpson.net>
 <20140117171441.GG5785@linutronix.de>
 <1390015514.5444.46.camel@marge.simpson.net>
 <20140124195014.GB29981@linutronix.de>
 <1390626760.3625.17.camel@marge.simpson.net>
 <1390799444.5425.61.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390799444.5425.61.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012716-8236-0000-0000-000006726EA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 06:10:44AM +0100, Mike Galbraith wrote:
> On Sat, 2014-01-25 at 06:12 +0100, Mike Galbraith wrote: 
> > On Fri, 2014-01-24 at 20:50 +0100, Sebastian Andrzej Siewior wrote: 
> > > * Mike Galbraith | 2014-01-18 04:25:14 [+0100]:
> > > 
> > > >> ># timers-do-not-raise-softirq-unconditionally.patch
> > > >> ># rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch
> > > >> >
> > > >> >..those two out does seem to have stabilized the thing.
> > > >> 
> > > >> timers-do-not-raise-softirq-unconditionally.patch is on its way out.
> > > >> 
> > > >> rtmutex-use-a-trylock-for-waiter-lock-in-trylock.patch confues me.
> > > >> Didn't you report once that your box deadlocks without this patch? Now
> > > >> your 64way box on the other hand does not work with it?
> > > >
> > > >If 'do not raise' is applied, 'use a trylock' won't save you.  If 'do
> > > is this just an observation or you do know why it won't save me?
> > 
> > It's an observation from beyond the grave from the 64 core box that it
> > repeatedly did NOT save :)  Autopsy photos below.
> > 
> > I've built 3.12.8-rt9 with Stevens v2 "timer: Raise softirq if there's
> > irq_work" to see if it'll survive.
> 
> And it did, configured both as nohz_tick, and nohz_full_all.  The irqs
> are enabled warning in can_stop_full_tick() fired for nohz_full_all, but
> that's it.
> 
> For grins, I also applied Paul's v3 timer latency series while testing
> nohz_full_all config.   The box was heavily loaded the vast majority of
> the time, but it didn't explode or do anything obviously evil.

Cool!  May I add your Tested-by?

							Thanx, Paul


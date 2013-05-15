Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3EOSHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:07:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759672Ab3EOSHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:07:36 -0400
Date: Wed, 15 May 2013 13:50:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130515175017.GS23604@redhat.com>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
 <20130515165915.GE13916@laptop.home>
 <20130515171153.GF13916@laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515171153.GF13916@laptop.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 07:11:53PM +0200, Peter Zijlstra wrote:
> On Wed, May 15, 2013 at 06:59:15PM +0200, Peter Zijlstra wrote:
> > On Wed, May 15, 2013 at 11:27:02AM -0400, Steven Rostedt wrote:
> > > Right now perf requires a tick, not sure exactly why, but you can look
> > > at the code in perf_event_task_tick(). Thus if NO_HZ_FULL sees that a
> > > perf tick is pending, it won't disable ticks. Unfortunately, the
> > > watchdogs, both NMI and soft lockup, use the perf infrastructure to
> > > trigger NMIs or interrupts. This adds a perf element on the rotate list
> > > and keeps NO_HZ_FULL from *ever* activating.
> > > 
> > 
> > Hmm.. Stephane had a bunch of patches converting the rotation thing to
> > an hrtimer. I seem to have forgotten what happened to them but I can't
> > seem to find them merged.
> > 
> > I'll go look.
> > 
> > That leaves the frequency stuff, but the watchdog doesn't use that.
> > 
> > At which point we could run the watchdog without perf_event_task_tick().
> 
> Found them:
> 
> 1364991694-5876-1-git-send-email-eranian@google.com
> 
> Looks like they were stuck in my inbox and never applied, so I just did.
> They should appear in tip soonish.

That was easy.  Next problem! :-p

Thanks Peter!

Cheers,
Don


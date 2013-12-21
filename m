Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3LUKF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:05:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47812 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3LUKFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:05:24 -0500
Date: Sat, 21 Dec 2013 11:05:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131221100500.GG7959@laptop.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123353.180539582@infradead.org>
 <20131218165508.GB30183@twins.programming.kicks-ass.net>
 <20131220171343.GL2480@laptop.programming.kicks-ass.net>
 <20131220123707.44fb7192@gandalf.local.home>
 <20131220174200.GX16438@laptop.programming.kicks-ass.net>
 <20131220132323.524cf2b1@gandalf.local.home>
 <20131220214413.GF7959@laptop.programming.kicks-ass.net>
 <20131220182946.09ca0f04@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220182946.09ca0f04@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 06:29:46PM -0500, Steven Rostedt wrote:
> On Fri, 20 Dec 2013 22:44:13 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> 
> > @@ -5056,10 +5018,28 @@ static int sched_cpu_inactive(struct not
> >  	switch (action & ~CPU_TASKS_FROZEN) {
> >  	case CPU_DOWN_PREPARE:
> >  		set_cpu_active((long)hcpu, false);
> > -		return NOTIFY_OK;
> > -	default:
> > -		return NOTIFY_DONE;
> > +		break;
> >  	}
> > +
> > +	switch (action) {
> > +	case CPU_DOWN_PREPARE: /* explicitly allow suspend */
> 
> Instead of the double switch (which is quite confusing), what about
> just adding:
> 
> 	if (!(action & CPU_TASKS_FROZEN))
> 
> I mean, the above switch gets called for both cases, this only gets
> called for the one case. This case is a subset of the above. I don't
> see why an if () would not be better than a double (confusing) switch().

I don't see the confusion in the double switch(), but sure an if would
work too I suppose.

> Also, it seems that this change also does not return NOTIFY_DONE if
> something other than CPU_DOWN_PREPARE is passed in.

Yeah, I had a look but couldn't find an actual difference between
NOTIFY_DONE and NOTIFY_OK. Maybe I missed it..

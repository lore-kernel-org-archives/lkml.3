Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3K0PBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:01:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18463 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751871Ab3K0PBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:01:01 -0500
Date: Wed, 27 Nov 2013 10:00:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127100056.4f3fe29c@gandalf.local.home>
In-Reply-To: <20131127142649.GC13532@twins.programming.kicks-ass.net>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
	<20131120163318.10253e43@gandalf.local.home>
	<5295F711.5010708@gmail.com>
	<20131127091647.4e16ce53@gandalf.local.home>
	<20131127142649.GC13532@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 15:26:49 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 27, 2013 at 09:16:47AM -0500, Steven Rostedt wrote:
> > On Wed, 27 Nov 2013 14:43:45 +0100
> > Juri Lelli <juri.lelli@gmail.com> wrote:
> > diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> > > index f76f8d6..ad94604 100644
> > > --- a/kernel/trace/trace_selftest.c
> > > +++ b/kernel/trace/trace_selftest.c
> > > @@ -1023,16 +1023,16 @@ trace_selftest_startup_nop(struct tracer *trace, struct trace_array *tr)
> > >  static int trace_wakeup_test_thread(void *data)
> > >  {
> > >  	/* Make this a -deadline thread */
> > > -	struct sched_param2 paramx = {
> > > +	static const struct sched_param2 param = {
> > >  		.sched_priority = 0,
> > > +		.sched_flags = 0,
> > >  		.sched_runtime = 100000ULL,
> > >  		.sched_deadline = 10000000ULL,
> > >  		.sched_period = 10000000ULL
> > > -		.sched_flags = 0
> > 
> > Assigning structures like this, you don't need to set the zero fields.
> > all fields not explicitly stated, are set to zero.
> 
> Only because its static. Otherwise unnamed members have indeterminate
> value after initialization.

Hmm, I wonder if there's a gcc extension that guarantees it. Because I
could have sworn I've seen initialization of structures that expected
zero'd behavior elsewhere in the kernel.

-- Steve

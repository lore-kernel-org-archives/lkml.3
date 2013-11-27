Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3K0Oem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:34:42 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:47129 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3K0Oek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:34:40 -0500
Date: Wed, 27 Nov 2013 15:34:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127143435.GD25043@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
 <1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
 <20131120163318.10253e43@gandalf.local.home>
 <5295F711.5010708@gmail.com>
 <20131127091647.4e16ce53@gandalf.local.home>
 <20131127142649.GC13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127142649.GC13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

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

I think for 'struct' C will initialize them to zero, even if they are 
not mentioned and even if they are on the stack.

It will only be indeterminate when it's not initialized at all.

Thanks,

	Ingo

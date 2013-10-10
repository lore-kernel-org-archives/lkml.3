Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3JJQwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:52:34 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54222 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3JJQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:52:32 -0400
Date: Thu, 10 Oct 2013 18:52:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010165229.GC12998@gmail.com>
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
 <20131010121908.GB28601@twins.programming.kicks-ass.net>
 <20131010145738.GA5167@gmail.com>
 <20131010152612.GA13375@redhat.com>
 <20131010090044.7f12ddaf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010090044.7f12ddaf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 Oct 2013 17:26:12 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > On 10/10, Ingo Molnar wrote:
> > >
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > > But the thing is; our sense of NR_CPUS has shifted, where it used to be
> > > > ok to do something like:
> > > >
> > > >   for_each_cpu()
> > > >
> > > > With preemption disabled; it gets to be less and less sane to do 
> > > > so, simply because 'common' hardware has 256+ CPUs these days. If 
> > > > we cannot rely on preempt disable to exclude hotplug, we must use 
> > > > get_online_cpus(), but get_online_cpus() is global state and thus 
> > > > cannot be used at any sort of frequency.
> > >
> > > So ... why not make it _really_ cheap, i.e. the read lock costing 
> > > nothing, and tie CPU hotplug to freezing all tasks in the system?
> > >
> > > Actual CPU hot unplugging and repluggin is _ridiculously_ rare in a 
> > > system, I don't understand how we tolerate _any_ overhead from this 
> > > utter slowpath.
> > 
> > Well, iirc Srivatsa (cc'ed) pointed out that some systems do 
> > cpu_down/up quite often to save the power.
> 
> cpu hotremove already uses stop_machine, so such an approach shouldn't 
> actually worsen things (a lot) for them?

Also, using CPU hotremove to save power, instead of implementing proper 
power aware scheduling, is very broken to begin with.

Thanks,

	Ingo

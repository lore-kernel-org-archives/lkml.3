Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3JBMXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:23:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3JBMXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:23:47 -0400
Date: Wed, 2 Oct 2013 14:16:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, tony.luck@intel.com,
        bp@alien8.de
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131002121625.GB21581@redhat.com>
References: <20130925175055.GA25914@redhat.com> <20130928144720.GL15690@laptop.programming.kicks-ass.net> <20130928163104.GA23352@redhat.com> <7632387.20FXkuCITr@vostro.rjw.lan> <524B0233.8070203@linux.vnet.ibm.com> <20131001173615.GW3657@laptop.programming.kicks-ass.net> <20131001174508.GA17411@redhat.com> <20131001175640.GQ15690@laptop.programming.kicks-ass.net> <20131001180750.GA18261@redhat.com> <20131001190515.GI5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001190515.GI5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Paul E. McKenney wrote:
>
> On Tue, Oct 01, 2013 at 08:07:50PM +0200, Oleg Nesterov wrote:
> > On 10/01, Peter Zijlstra wrote:
> > >
> > > On Tue, Oct 01, 2013 at 07:45:08PM +0200, Oleg Nesterov wrote:
> > > >
> > > > I tend to agree with Srivatsa... Without a strong reason it would be better
> > > > to preserve the current logic: "some time after" should not be after the
> > > > next CPU_DOWN/UP*. But I won't argue too much.
> > >
> > > Nah, I think breaking it is the right thing :-)
> >
> > I don't really agree but I won't argue ;)
>
> The authors of arch/x86/kernel/cpu/mcheck/mce.c would seem to be the
> guys who would need to complain, given that they seem to have the only
> use in 3.11.

mce_cpu_callback() is fine, it ignores POST_DEAD if CPU_TASKS_FROZEN.

Oleg.


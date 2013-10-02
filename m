Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3JBMZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:25:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44527 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3JBMZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:25:28 -0400
Date: Wed, 2 Oct 2013 14:25:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131002122507.GB28601@twins.programming.kicks-ass.net>
References: <20130928144720.GL15690@laptop.programming.kicks-ass.net>
 <20130928163104.GA23352@redhat.com>
 <7632387.20FXkuCITr@vostro.rjw.lan>
 <524B0233.8070203@linux.vnet.ibm.com>
 <20131001173615.GW3657@laptop.programming.kicks-ass.net>
 <20131001174508.GA17411@redhat.com>
 <20131001175640.GQ15690@laptop.programming.kicks-ass.net>
 <20131001180750.GA18261@redhat.com>
 <20131002090859.GE12926@twins.programming.kicks-ass.net>
 <20131002121356.GA21581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002121356.GA21581@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 02:13:56PM +0200, Oleg Nesterov wrote:
> On 10/02, Peter Zijlstra wrote:
> > And given the construct; I'm not entirely sure you can do away with the
> > sync_sched() in between. While its clear to me you can merge the two
> > into one; leaving it out entirely doesn't seem right.
> 
> Could you explain?

Somehow I thought the fastpath got enabled; it doesn't since we never
hit GP_IDLE, so we don't actually need that.

You're right.

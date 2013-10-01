Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3JAPmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:42:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab3JAPl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:41:58 -0400
Date: Tue, 1 Oct 2013 17:34:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131001153451.GB3515@redhat.com>
References: <20130926111042.GS3081@twins.programming.kicks-ass.net> <20130926165840.GA863@redhat.com> <20130926175016.GI3657@laptop.programming.kicks-ass.net> <20130927181532.GA8401@redhat.com> <20130927204116.GJ15690@laptop.programming.kicks-ass.net> <20131001035604.GW19582@linux.vnet.ibm.com> <20131001141429.GA32423@redhat.com> <20131001144537.GC5790@linux.vnet.ibm.com> <20131001144820.GP3657@laptop.programming.kicks-ass.net> <20131001152449.GD5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001152449.GD5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Paul E. McKenney wrote:
>
> On Tue, Oct 01, 2013 at 04:48:20PM +0200, Peter Zijlstra wrote:
> > On Tue, Oct 01, 2013 at 07:45:37AM -0700, Paul E. McKenney wrote:
> > > If you don't have cpuhp_seq, you need some other way to avoid
> > > counter overflow.  Which might be provided by limited number of
> > > tasks, or, on 64-bit systems, 64-bit counters.
> >
> > How so? PID space is basically limited to 30 bits, so how could we
> > overflow a 32bit reference counter?
>
> Nesting.

Still it seems that UINT_MAX / PID_MAX_LIMIT has enough room.

But again, OK lets make it ulong. The question is, how cpuhp_seq can
help and why we can't kill it.

Oleg.


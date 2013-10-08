Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3JHQe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:34:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33015 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3JHQe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:34:56 -0400
Date: Tue, 8 Oct 2013 09:34:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
Message-ID: <20131008163447.GN5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131004184614.GA17536@redhat.com>
 <20131004184629.GA17550@redhat.com>
 <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com>
 <20131004153012.19245adb@gandalf.local.home>
 <CA+55aFwda1pErt32162S_1gq=Kkge7Gj3n2sm_rOopAtz2bVUQ@mail.gmail.com>
 <20131005171746.GA17664@redhat.com>
 <20131008091339.GN3081@twins.programming.kicks-ass.net>
 <20131008153325.GB16558@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008153325.GB16558@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100816-1344-0000-0000-00000243634F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 05:33:25PM +0200, Oleg Nesterov wrote:
> On 10/08, Peter Zijlstra wrote:
> >
> > I think Linus meant to have rcu_sync_{enter,exit} as inlines with a
> > const enum argument for the gp_type.
> >
> > That said; yes that will generate better code, but also more code, and
> > like Steven already argued performance isn't really an issue here since
> > we're going to potentially sleep for a rather long time.
> 
> Yes, I do not think that we should make them "inline". Plus we need the
> non-inline rcu_sync_func() anyway.

Yep.  Now if it was rcu_read_lock() rather than synchronize_rcu(),
it would be different.  ;-)

							Thanx, Paul

> Thanks again for the last series you sent.
> 
> Oleg.
> 


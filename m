Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3JER2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:28:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab3JER2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:28:24 -0400
Date: Sat, 5 Oct 2013 19:21:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
Message-ID: <20131005172118.GA18191@redhat.com>
References: <20131004184614.GA17536@redhat.com> <20131004184629.GA17550@redhat.com> <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com> <20131004153012.19245adb@gandalf.local.home> <CA+55aFwda1pErt32162S_1gq=Kkge7Gj3n2sm_rOopAtz2bVUQ@mail.gmail.com> <20131004194251.GX15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004194251.GX15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 04, 2013 at 12:38:37PM -0700, Linus Torvalds wrote:
> > On Fri, Oct 4, 2013 at 12:30 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > As all the rcu_synchronization() methods (on non UP) are quite
> > > expensive, I doubt that this optimization is worth anything.
> >
> > Maybe. It just annoys me, because afaik, the function that gets called
> > is always static per callsite.
>
> Yes, very much so indeed. Worst is that we have no users of the regular
> RCU and RCU_BH variants and only included them for completeness since
> the general operation is just as valid for those.

And personally I think we should keep type/ops for completeness anyway,
even if we do not have RCU and RCU_BH users. But perhaps we can kill
RCU_SYNC and RCU_BH_SYNC enums/entries until we have a user.

Oleg.


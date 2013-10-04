Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3JDHSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:18:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39479 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3JDHSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:18:30 -0400
Date: Fri, 4 Oct 2013 09:18:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131004071814.GS28601@twins.programming.kicks-ass.net>
References: <20131002150518.675931976@infradead.org>
 <20131003164117.GD5790@linux.vnet.ibm.com>
 <20131003184001.GM28601@twins.programming.kicks-ass.net>
 <20131003184719.GA11996@redhat.com>
 <20131003192135.GR5790@linux.vnet.ibm.com>
 <20131003193206.GA17796@redhat.com>
 <20131003193319.GB17796@redhat.com>
 <20131003195026.GT5790@linux.vnet.ibm.com>
 <20131003200002.GA23768@redhat.com>
 <20131003211009.GA4127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003211009.GA4127@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:10:09PM +0200, Oleg Nesterov wrote:
> On 10/03, Oleg Nesterov wrote:
> >
> > So unless Peter objects I'll write the changelogs (always nontrivial task),
> > test, and send these 2 patches + "add ops->barr() / rcu_sync_wait_for_cb"
> > tomorrow.
> 
> And, can't resist, probably another patch below (incomplete, needs the
> obvious change in cpu.c and the new trivial __complete_locked() helper).
> 
> Hmm. But when I look at wait_for_completion() I think it is buggy. Will
> try to send the fix tomorrow.
> 
> Oleg.
> 
> rcusync: introduce rcu_sync_struct->exclusive mode

What's exclusive to mean? One writer at a time? Why don't use use the
waitqueue in exclusive mode and use a single wake_up instead of
wake_up_all()?


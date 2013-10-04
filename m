Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3JDLgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 07:36:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44246 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3JDLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 07:36:34 -0400
Date: Fri, 4 Oct 2013 13:36:07 +0200
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
Message-ID: <20131004113607.GI3081@twins.programming.kicks-ass.net>
References: <20131003184001.GM28601@twins.programming.kicks-ass.net>
 <20131003184719.GA11996@redhat.com>
 <20131003192135.GR5790@linux.vnet.ibm.com>
 <20131003193206.GA17796@redhat.com>
 <20131003193319.GB17796@redhat.com>
 <20131003195026.GT5790@linux.vnet.ibm.com>
 <20131003200002.GA23768@redhat.com>
 <20131003211009.GA4127@redhat.com>
 <20131004071814.GS28601@twins.programming.kicks-ass.net>
 <20131004111513.GA5699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004111513.GA5699@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 01:15:13PM +0200, Oleg Nesterov wrote:
> Of course we can fix this, but wait_for_completion/complete already
> does the necessary work: x->done acts as a resource counter which is
> always checked/incremented/decremented under the same lock.

Urgh, so now you're not using a semaphore as completion but using a
completion as semaphore.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3JCSmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:42:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3JCSmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:42:05 -0400
Date: Thu, 3 Oct 2013 20:41:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] hotplug: Optimize cpu_hotplug_{begin,done}() using
 rcu_sync
Message-ID: <20131003184151.GN28601@twins.programming.kicks-ass.net>
References: <20131002145655.361606532@infradead.org>
 <20131002150518.748974359@infradead.org>
 <20131003164838.GF5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003164838.GF5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 09:48:38AM -0700, Paul E. McKenney wrote:
> > -enum { readers_fast = 0, readers_slow, readers_block };
> > +enum { readers_slow, readers_block };
> 
> It took me a bit to realize that readers_fast is obsoleted by the
> rcu_sync_is_idle() above.  ;-)

Yeah.. I pondered changing/adding to the rcu_sync interface to allow
using gp_count like status to avoid the extra variable, but decided
against it for now.

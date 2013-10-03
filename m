Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3JCSqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:46:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59417 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3JCSqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:46:16 -0400
Date: Thu, 3 Oct 2013 11:46:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20131003184607.GQ5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131002145655.361606532@infradead.org>
 <20131002150518.748974359@infradead.org>
 <20131003164838.GF5790@linux.vnet.ibm.com>
 <20131003184151.GN28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003184151.GN28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100318-3532-0000-0000-000001E289B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 08:41:51PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 03, 2013 at 09:48:38AM -0700, Paul E. McKenney wrote:
> > > -enum { readers_fast = 0, readers_slow, readers_block };
> > > +enum { readers_slow, readers_block };
> > 
> > It took me a bit to realize that readers_fast is obsoleted by the
> > rcu_sync_is_idle() above.  ;-)
> 
> Yeah.. I pondered changing/adding to the rcu_sync interface to allow
> using gp_count like status to avoid the extra variable, but decided
> against it for now.

Should be OK as is -- people who haven't reviewed the old version with
readers_fast are unlikely to be confused by the current setup.

							Thanx, Paul


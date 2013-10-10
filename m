Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3JJQuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:50:52 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39710 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3JJQut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:50:49 -0400
Date: Thu, 10 Oct 2013 18:50:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20131010165045.GB12998@gmail.com>
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
 <20131010121908.GB28601@twins.programming.kicks-ass.net>
 <20131010145738.GA5167@gmail.com>
 <20131010152134.GQ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010152134.GQ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Oct 10, 2013 at 04:57:38PM +0200, Ingo Molnar wrote:
>
> > So ... why not make it _really_ cheap, i.e. the read lock costing 
> > nothing, and tie CPU hotplug to freezing all tasks in the system?
> 
> Such that we freeze regular tasks in userspace and kernel tasks in their 
> special freezer callback so as to guarantee minimal state?

Yes, absolutely.

Thanks,

	Ingo

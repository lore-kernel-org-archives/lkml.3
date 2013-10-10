Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3JJRf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:35:58 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37795 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3JJRf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:35:57 -0400
Date: Thu, 10 Oct 2013 19:35:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010173553.GC26430@gmail.com>
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
 <20131010121908.GB28601@twins.programming.kicks-ass.net>
 <20131010145738.GA5167@gmail.com>
 <20131010152134.GQ3081@twins.programming.kicks-ass.net>
 <20131010165045.GB12998@gmail.com>
 <20131010171353.GM5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010171353.GM5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Oct 10, 2013 at 06:50:46PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, Oct 10, 2013 at 04:57:38PM +0200, Ingo Molnar wrote:
> > >
> > > > So ... why not make it _really_ cheap, i.e. the read lock costing 
> > > > nothing, and tie CPU hotplug to freezing all tasks in the system?
> > > 
> > > Such that we freeze regular tasks in userspace and kernel tasks in 
> > > their special freezer callback so as to guarantee minimal state?
> > 
> > Yes, absolutely.
> 
> That does add quite a bit of latency to the hotplug operations, which 
> IIRC slows down things like boot, suspend, and resume.

I think it should _speed up_ suspend: instead of bringing down each CPU 
one by one, they could just be all stopped.

Same for bootup - it's not really a hotplug operation in the traditional 
sense, as all CPUs are 'present' at once, and they could be added in one 
group operation instead of serializing the bootup.

Also, most CPU bootup sequences are serialized.

It would slow down individual CPU hotplug/hotunplug - and that is what is 
a really rare operation outside broken schemes to save power ...

Thanks,

	Ingo

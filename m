Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3JJQnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:43:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3JJQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:43:06 -0400
Date: Thu, 10 Oct 2013 09:43:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-Id: <20131010094355.6f75e5a2.akpm@linux-foundation.org>
In-Reply-To: <20131010123631.1be60315@gandalf.local.home>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
	<20131010090044.7f12ddaf.akpm@linux-foundation.org>
	<20131010123631.1be60315@gandalf.local.home>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 12:36:31 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 10 Oct 2013 09:00:44 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > It's been ages since I looked at this stuff :( Although it isn't used
> > much, memory hotplug manages to use stop_machine() on the add/remove
> > (ie, "writer") side and nothing at all on the "reader" side.  Is there
> > anything which fundamentally prevents cpu hotplug from doing the same?
> 
> 
> I would think that memory hotplug may require stop machine as all CPUs
> may touch that memory.

Sure.

> But we would like to remove stomp machine from
> CPU hotplug.

We do?  That's news.  It wasn't mentioned in the changelog and should
have been.  Why?  

> Why prevent all CPUs from running when we want to remove
> one?

So get_online_cpus() goes away.  Nothing is more scalable than nothing!

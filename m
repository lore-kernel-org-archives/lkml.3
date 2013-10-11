Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3JKGJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:09:50 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:57510 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3JKGJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:09:48 -0400
Date: Fri, 11 Oct 2013 08:09:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131011060944.GB4975@gmail.com>
References: <20131010090044.7f12ddaf.akpm@linux-foundation.org>
 <20131010123631.1be60315@gandalf.local.home>
 <20131010094355.6f75e5a2.akpm@linux-foundation.org>
 <20131010165337.GT3081@twins.programming.kicks-ass.net>
 <20131010131305.58558079@gandalf.local.home>
 <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
 <20131010183409.GP13848@laptop.programming.kicks-ass.net>
 <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
 <20131010150444.51f9c929@gandalf.local.home>
 <CA+55aFw+gXxp-S0XxVGH=9TfudNSDRnFmntT6mK9B1Wbp2mDOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw+gXxp-S0XxVGH=9TfudNSDRnFmntT6mK9B1Wbp2mDOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 10, 2013 at 12:04 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I'm wondering if we can have a for_each_cpu() that only disables 
> > preemption in the loop.
> 
> I think we'd generally want to have it be something the loop asks for.
> 
> If the loop is just some kind of "gather statistics" thing, I don't 
> think it's required. The cost per loop is so low (usually adding up a 
> couple of words) that the downside drowns the upside.
> 
> And we could easily look at MAXSMP (or NR_CPUS) at compile-time, and not 
> do it for common small values (although it looks like Fedora defaults to 
> 128 CPU's for their distro kernels, which seems a bit excessive - too 
> many by far for normal people, too few for the crazy big ones).

Ubuntu has it at 256, so I guess Fedora is even a bit conservative ;-)

Thanks,

	Ingo

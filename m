Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3LBMgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:36:07 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:38582 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3LBMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:36:03 -0500
Date: Mon, 2 Dec 2013 13:35:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>, Scott Norton <scott.norton@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
Message-ID: <20131202123559.GA21756@gmail.com>
References: <20131126085256.GD789@laptop.programming.kicks-ass.net>
 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
 <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
 <20131128115946.GD13532@twins.programming.kicks-ass.net>
 <20131201121022.GB12115@gmail.com>
 <20131201125604.GH16796@laptop.programming.kicks-ass.net>
 <20131201165538.GA12864@gmail.com>
 <CA+55aFz-v62jWpTqzAhrf5rGS5drbvgG-XHDDN6cdHCLB+kMxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz-v62jWpTqzAhrf5rGS5drbvgG-XHDDN6cdHCLB+kMxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Dec 1, 2013 at 8:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Keeping the page invariant would bring significant performance 
> > advantages to hashing.
> 
> Or not. Rather, it would make things much worse. The virtual address 
> is much simpler and better to avoid needing any page table lookup 
> etc crap. The key is just the mm and the virtual address, and no 
> silly page table walks etc necessary.

In theory the CPU could give us the phyisical page address, as the TLB 
is already there: for most futex ops when the kernel runs we just 
attempted access of the virtual address on the user-space side, so the 
hardware already did the hard work of looking up everything in the 
page tables and has it cached most likely.

But yeah, you are right :-/

Thanks,

	ngo

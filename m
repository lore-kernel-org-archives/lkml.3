Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3LAM4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 07:56:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53597 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3LAM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 07:56:37 -0500
Date: Sun, 1 Dec 2013 13:56:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
Message-ID: <20131201125604.GH16796@laptop.programming.kicks-ass.net>
References: <20131125203358.156292370@linutronix.de>
 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
 <20131126085256.GD789@laptop.programming.kicks-ass.net>
 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
 <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
 <20131128115946.GD13532@twins.programming.kicks-ass.net>
 <20131201121022.GB12115@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131201121022.GB12115@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 01, 2013 at 01:10:22PM +0100, Ingo Molnar wrote:
> But more importantly, since these are all NUMA systems, would it make 
> sense to create per node hashes on NUMA? Each futex would be enqueued 
> into the hash belonging to its own page's node.

Can't do that; we hash on vaddr, the actual page can move between nodes
while a futex is queued.

This would mean that the waiting futex is queued on another node than
the waker is looking.

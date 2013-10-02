Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3JBMvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:51:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3JBMvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:51:08 -0400
Date: Wed, 2 Oct 2013 14:50:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20131002125052.GE28601@twins.programming.kicks-ass.net>
References: <20130821083130.GM3258@twins.programming.kicks-ass.net>
 <20130821113551.GA1472@redhat.com>
 <20130821123311.GA31370@twins.programming.kicks-ass.net>
 <20130821142356.GC31370@twins.programming.kicks-ass.net>
 <20130821164146.GA15194@redhat.com>
 <20131001140525.GE24825@localhost.localdomain>
 <20131001155633.GR3657@laptop.programming.kicks-ass.net>
 <20131001164708.GG24825@localhost.localdomain>
 <20131001165957.GT3657@laptop.programming.kicks-ass.net>
 <20131002124539.GF7941@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002124539.GF7941@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 02:45:41PM +0200, Frederic Weisbecker wrote:
> On Tue, Oct 01, 2013 at 06:59:57PM +0200, Peter Zijlstra wrote:
> > On Tue, Oct 01, 2013 at 06:47:10PM +0200, Frederic Weisbecker wrote:
> > > Yeah thinking more about it, the preempt disable was probably not
> > > necessary. Now that's trading 2 atomics + 1 Lock/Unlock with 2 Lock/Unlock.
> > 
> > It trades the current 2 atomics for 2 LOCK/UNLOCK. And on x86_64 that's
> > 2 atomics.
> 
> Do you mean 2 atomics for LOCK/UNLOCK? Or is that pair optimized somehow
> in x86?

Unlock isn't an atomic on x86_64; it can be on certain i386 builds. See
UNLOCK_LOCK_PREFIX.

> > 
> > So all we get is some extra branches; which we must hope for don't
> > actually mess things up too bad.
> > 
> > Ohh.. wait a sec.. we also call local_clock() which includes another
> > atomic :/ Bugger.. 
> 
> Yeah. Anyway, I'm going to try something on top of that. May be we'll get
> a fresher mind and ideas on how to optimize that all after.

Fair enough.

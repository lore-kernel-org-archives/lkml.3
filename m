Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3JBQB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:01:26 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65258 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab3JBQBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:01:22 -0400
Date: Wed, 2 Oct 2013 18:01:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20131002160116.GG7941@localhost.localdomain>
References: <20130821113551.GA1472@redhat.com>
 <20130821123311.GA31370@twins.programming.kicks-ass.net>
 <20130821142356.GC31370@twins.programming.kicks-ass.net>
 <20130821164146.GA15194@redhat.com>
 <20131001140525.GE24825@localhost.localdomain>
 <20131001155633.GR3657@laptop.programming.kicks-ass.net>
 <20131001164708.GG24825@localhost.localdomain>
 <20131001165957.GT3657@laptop.programming.kicks-ass.net>
 <20131002124539.GF7941@localhost.localdomain>
 <524C2F45.4040401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C2F45.4040401@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 07:35:49AM -0700, Arjan van de Ven wrote:
> On 10/2/2013 5:45 AM, Frederic Weisbecker wrote:
> >On Tue, Oct 01, 2013 at 06:59:57PM +0200, Peter Zijlstra wrote:
> >>On Tue, Oct 01, 2013 at 06:47:10PM +0200, Frederic Weisbecker wrote:
> >>>Yeah thinking more about it, the preempt disable was probably not
> >>>necessary. Now that's trading 2 atomics + 1 Lock/Unlock with 2 Lock/Unlock.
> >>
> >>It trades the current 2 atomics for 2 LOCK/UNLOCK. And on x86_64 that's
> >>2 atomics.
> >
> >Do you mean 2 atomics for LOCK/UNLOCK? Or is that pair optimized somehow
> >in x86?
> 
> unlock is not actually an atomic.
> 
> and on some modern machines, neither is the lock, for the uncontended case ;-)
> 

Yeah, we are never getting short on black magic as the time goes :)

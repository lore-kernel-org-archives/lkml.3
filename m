Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbbAFMUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:20:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:53835 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbbAFMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:20:23 -0500
Date: Tue, 6 Jan 2015 13:20:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106122006.GW29390@twins.programming.kicks-ass.net>
References: <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106114842.GP10476@twins.programming.kicks-ass.net>
 <20150106120121.GB26845@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106120121.GB26845@kmo-pixel>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 04:01:21AM -0800, Kent Overstreet wrote:
> On Tue, Jan 06, 2015 at 12:48:42PM +0100, Peter Zijlstra wrote:
> > 
> > 
> > Looking at that closure stuff, why is there an smp_mb() in
> > closure_wake_up() ? Typically wakeup only needs to imply a wmb.
> > 
> > Also note that __closure_wake_up() starts with a fully serializing
> > instruction (xchg) and thereby already implies the full barrier.
> 
> Probably no good reason, that code is pretty old :)
> 
> If I was to hazard a guess, I had my own lockless linked lists before llist.h
> existed and perhaps I did it with atomic_xchg() - which was at least documented
> to not imply a barrier. I suppose it should just be dropped.

We (probably me) should probably audit all the atomic_xchg()
implementations and documentation and fix that. I was very much under
the impression it should imply a full barrier (and it certainly does on
x86), the documentation should state the rule that any atomic_ function
that returns a result is fully serializing, therefore, because
atomic_xchg() has a return value, it should too.

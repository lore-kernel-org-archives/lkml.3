Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaBSLHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:07:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaBSLHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:07:39 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alec Teal <a.teal@warwick.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140218214713.GV14089@laptop.programming.kicks-ass.net>
References: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <530296CD.5050503@warwick.ac.uk>
	 <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.c!om>
	 <1392737465.18779.7644.camel@triegel.csb>
	 <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
	 <1392758516.18779.8378.camel@triegel.csb>
	 <20140218214713.GV14089@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Feb 2014 12:07:02 +0100
Message-ID: <1392808022.18779.8674.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 22:47 +0100, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 10:21:56PM +0100, Torvald Riegel wrote:
> > Yes, I do.  But that seems to be "volatile" territory.  It crosses the
> > boundaries of the abstract machine, and thus is input/output.  Which
> > fraction of your atomic accesses can read values produced by hardware?
> > I would still suppose that lots of synchronization is not affected by
> > this.
> 
> Its not only hardware; also the kernel/user boundary has this same
> problem. We cannot a-priory say what userspace will do; in fact, because
> we're a general purpose OS, we must assume it will willfully try its
> bestest to wreck whatever assumptions we make about its behaviour.

That's a good note, and I think a distinct case from those below,
because here you're saying that you can't assume that the userspace code
follows the C11 semantics ...

> We also have loadable modules -- much like regular userspace DSOs -- so
> there too we cannot say what will or will not happen.
> 
> We also have JITs that generate code on demand.

.. whereas for those, you might assume that the other code follows C11
semantics and the same ABI, which makes this just a normal case already
handled as (see my other replies nearby in this thread).

> And I'm absolutely sure (with the exception of the JITs, its not an area
> I've worked on) that we have atomic usage across all those boundaries.

That would be fine as long as all involved parties use the same memory
model and ABI to implement it.

(Of course, I'm assuming here that the compiler is aware of sharing with
other entities, which is always the case except in those corner case
like accesses to (void*)0x123 magically aliasing with something else).


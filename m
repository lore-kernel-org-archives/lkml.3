Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBRVrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:47:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36944 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaBRVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:47:22 -0500
Date: Tue, 18 Feb 2014 22:47:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torvald Riegel <triegel@redhat.com>
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
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218214713.GV14089@laptop.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392758516.18779.8378.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:21:56PM +0100, Torvald Riegel wrote:
> Yes, I do.  But that seems to be "volatile" territory.  It crosses the
> boundaries of the abstract machine, and thus is input/output.  Which
> fraction of your atomic accesses can read values produced by hardware?
> I would still suppose that lots of synchronization is not affected by
> this.

Its not only hardware; also the kernel/user boundary has this same
problem. We cannot a-priory say what userspace will do; in fact, because
we're a general purpose OS, we must assume it will willfully try its
bestest to wreck whatever assumptions we make about its behaviour.

We also have loadable modules -- much like regular userspace DSOs -- so
there too we cannot say what will or will not happen.

We also have JITs that generate code on demand.

And I'm absolutely sure (with the exception of the JITs, its not an area
I've worked on) that we have atomic usage across all those boundaries.

I must agree with Linus, global state driven optimizations are crack
brained; esp. for atomics. We simply cannot know all state at compile
time. The best we can hope for are local optimizations.

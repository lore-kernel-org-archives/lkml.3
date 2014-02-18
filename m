Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaBRVxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:53:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaBRVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:53:03 -0500
Date: Tue, 18 Feb 2014 22:52:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Alec Teal <a.teal@warwick.ac.uk>, Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218215256.GW14089@laptop.programming.kicks-ass.net>
References: <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <530296CD.5050503@warwick.ac.uk>
 <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
 <1392737465.18779.7644.camel@triegel.csb>
 <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
 <20140218171609.GP4250@linux.vnet.ibm.com>
 <1392759615.18779.8429.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392759615.18779.8429.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 4.	Some drivers allow user-mode code to mmap() some of their
> > 	state.  Any changes undertaken by the user-mode code would
> > 	be invisible to the compiler.
> 
> A good point, but a compiler that doesn't try to (incorrectly) assume
> something about the semantics of mmap will simply see that the mmap'ed
> data will escape to stuff if can't analyze, so it will not be able to
> make a proof.
> 
> This is different from, for example, malloc(), which is guaranteed to
> return "fresh" nonaliasing memory.

The kernel side of this is different.. it looks like 'normal' memory, we
just happen to allow it to end up in userspace too.

But on that point; how do you tell the compiler the difference between
malloc() and mmap()? Is that some function attribute?

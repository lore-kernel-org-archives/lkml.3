Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaBRVr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaBRVrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:47:55 -0500
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
In-Reply-To: <20140218214047.GU14089@laptop.programming.kicks-ass.net>
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
	 <20140218214047.GU14089@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 22:47:15 +0100
Message-ID: <1392760035.18779.8449.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 22:40 +0100, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 10:21:56PM +0100, Torvald Riegel wrote:
> > Well, that's how atomics that aren't volatile are defined in the
> > standard.  I can see that you want something else too, but that doesn't
> > mean that the other thing is broken.
> 
> Well that other thing depends on being able to see the entire program at
> compile time. PaulMck already listed various ways in which this is
> not feasible even for normal userspace code.
> 
> In particular; DSOs and JITs were mentioned.

No it doesn't depend on whole-program analysis being possible.  Because
if it isn't, then a correct compiler will just not do certain
optimizations simply because it can't prove properties required for the
optimization to hold.  With the exception of access to objects via magic
numbers (e.g., fixed and known addresses (see my reply to Paul), which
are outside of the semantics specified in the standard), I don't see a
correctness problem here.


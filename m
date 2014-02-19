Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaBSPYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:24:31 -0500
Received: from mail.lang.hm ([64.81.33.126]:53589 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaBSPYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:24:30 -0500
Date: Wed, 19 Feb 2014 07:23:27 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Torvald Riegel <triegel@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <1392760035.18779.8449.camel@triegel.csb>
Message-ID: <alpine.DEB.2.02.1402190722040.2147@nftneq.ynat.uz>
References: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>  <1392486310.18779.6447.camel@triegel.csb>  <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>  <1392666947.18779.6838.camel@triegel.csb> 
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>  <530296CD.5050503@warwick.ac.uk>  <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.c!om>  <1392737465.18779.7644.camel@triegel.csb>  <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
  <1392758516.18779.8378.camel@triegel.csb>  <20140218214047.GU14089@laptop.programming.kicks-ass.net> <1392760035.18779.8449.camel@triegel.csb>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Torvald Riegel wrote:

> On Tue, 2014-02-18 at 22:40 +0100, Peter Zijlstra wrote:
>> On Tue, Feb 18, 2014 at 10:21:56PM +0100, Torvald Riegel wrote:
>>> Well, that's how atomics that aren't volatile are defined in the
>>> standard.  I can see that you want something else too, but that doesn't
>>> mean that the other thing is broken.
>>
>> Well that other thing depends on being able to see the entire program at
>> compile time. PaulMck already listed various ways in which this is
>> not feasible even for normal userspace code.
>>
>> In particular; DSOs and JITs were mentioned.
>
> No it doesn't depend on whole-program analysis being possible.  Because
> if it isn't, then a correct compiler will just not do certain
> optimizations simply because it can't prove properties required for the
> optimization to hold.  With the exception of access to objects via magic
> numbers (e.g., fixed and known addresses (see my reply to Paul), which
> are outside of the semantics specified in the standard), I don't see a
> correctness problem here.

Are you really sure that the compiler can figure out every possible thing that a 
loadable module or JITed code can access? That seems like a pretty strong claim.

David Lang

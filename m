Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaBJLqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:46:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJLqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:46:15 -0500
Date: Mon, 10 Feb 2014 12:46:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140210114605.GI9987@twins.programming.kicks-ass.net>
References: <20140206192743.GH4250@linux.vnet.ibm.com>
 <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391992071.18779.99.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 01:27:51AM +0100, Torvald Riegel wrote:
> > Initial state: x == y == 0
> > 
> > T1:	r1 = atomic_load_explicit(x, memory_order_relaxed);
> > 	atomic_store_explicit(42, y, memory_order_relaxed);
> > 	if (r1 != 42)
> > 		atomic_store_explicit(r1, y, memory_order_relaxed);
> > 
> > T2:	r2 = atomic_load_explicit(y, memory_order_relaxed);
> > 	atomic_store_explicit(r2, x, memory_order_relaxed);
> 
> Intuitively, this is wrong because this let's the program take a step
> the abstract machine wouldn't do.  This is different to the sequential
> code that Peter posted because it uses atomics, and thus one can't
> easily assume that the difference is not observable.

Yeah, my bad for not being familiar with the atrocious crap C11 made of
atomics :/


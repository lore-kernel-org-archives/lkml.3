Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBJLsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:48:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42968 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaBJLsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:21 -0500
Date: Mon, 10 Feb 2014 12:48:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>, Torvald Riegel <triegel@redhat.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140210114813.GJ9987@twins.programming.kicks-ass.net>
References: <20140206185910.GE27276@mudshark.cambridge.arm.com>
 <20140206192743.GH4250@linux.vnet.ibm.com>
 <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207180216.GP4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:02:16AM -0800, Paul E. McKenney wrote:
> As near as I can tell, compiler writers hate the idea of prohibiting
> speculative-store optimizations because it requires them to introduce
> both control and data dependency tracking into their compilers.  Many of
> them seem to hate dependency tracking with a purple passion.  At least,
> such a hatred would go a long way towards explaining the incomplete
> and high-overhead implementations of memory_order_consume, the long
> and successful use of idioms based on the memory_order_consume pattern
> notwithstanding [*].  ;-)

Just tell them that because the hardware provides control dependencies
we actually use and rely on them.

Not that I expect they care too much what we do, given the current state
of things.

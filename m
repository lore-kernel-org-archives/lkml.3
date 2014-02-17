Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaBQWRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:17:05 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45181 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaBQWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:14:29 -0500
Date: Mon, 17 Feb 2014 14:14:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Richard Biener <richard.guenther@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Torvald Riegel <triegel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140217221423.GK4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140207180216.GP4250@linux.vnet.ibm.com>
 <1391992071.18779.99.camel@triegel.csb>
 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
 <20140211155941.GU4250@linux.vnet.ibm.com>
 <1392185194.18779.2239.camel@triegel.csb>
 <20140212091907.GA3545@laptop.programming.kicks-ass.net>
 <20140212174209.GA4250@linux.vnet.ibm.com>
 <20140212181205.GD27965@twins.programming.kicks-ass.net>
 <20140217181815.GA1934@linux.vnet.ibm.com>
 <99178341-b6c8-4546-957c-2ea4031b4fe0@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99178341-b6c8-4546-957c-2ea4031b4fe0@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C3512F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 09:39:54PM +0100, Richard Biener wrote:
> On February 17, 2014 7:18:15 PM GMT+01:00, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >On Wed, Feb 12, 2014 at 07:12:05PM +0100, Peter Zijlstra wrote:
> >> On Wed, Feb 12, 2014 at 09:42:09AM -0800, Paul E. McKenney wrote:
> >> > You need volatile semantics to force the compiler to ignore any
> >proofs
> >> > it might otherwise attempt to construct.  Hence all the
> >ACCESS_ONCE()
> >> > calls in my email to Torvald.  (Hopefully I translated your example
> >> > reasonably.)
> >> 
> >> My brain gave out for today; but it did appear to have the right
> >> structure.
> >
> >I can relate.  ;-)
> >
> >> I would prefer it C11 would not require the volatile casts. It should
> >> simply _never_ speculate with atomic writes, volatile or not.
> >
> >I agree with not needing volatiles to prevent speculated writes. 
> >However,
> >they will sometimes be needed to prevent excessive load/store
> >combining.
> >The compiler doesn't have the runtime feedback mechanisms that the
> >hardware has, and thus will need help from the developer from time
> >to time.
> >
> >Or maybe the Linux kernel simply waits to transition to C11 relaxed
> >atomics
> >until the compiler has learned to be sufficiently conservative in its
> >load-store combining decisions.
> 
> Sounds backwards. Currently the compiler does nothing to the atomics. I'm sure we'll eventually add something. But if testing coverage is zero outside then surely things get worse, not better with time.

Perhaps we solve this chicken-and-egg problem by creating a test suite?

							Thanx, Paul


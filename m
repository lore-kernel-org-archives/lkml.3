Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBJPGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:06:06 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37865 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaBJPGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:06:02 -0500
Date: Mon, 10 Feb 2014 07:04:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Torvald Riegel <triegel@redhat.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140210150443.GJ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <20140210114813.GJ9987@twins.programming.kicks-ass.net>
 <20140210114929.GF17766@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210114929.GF17766@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021015-8236-0000-0000-000006EA7F1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:49:29AM +0000, Will Deacon wrote:
> On Mon, Feb 10, 2014 at 11:48:13AM +0000, Peter Zijlstra wrote:
> > On Fri, Feb 07, 2014 at 10:02:16AM -0800, Paul E. McKenney wrote:
> > > As near as I can tell, compiler writers hate the idea of prohibiting
> > > speculative-store optimizations because it requires them to introduce
> > > both control and data dependency tracking into their compilers.  Many of
> > > them seem to hate dependency tracking with a purple passion.  At least,
> > > such a hatred would go a long way towards explaining the incomplete
> > > and high-overhead implementations of memory_order_consume, the long
> > > and successful use of idioms based on the memory_order_consume pattern
> > > notwithstanding [*].  ;-)
> > 
> > Just tell them that because the hardware provides control dependencies
> > we actually use and rely on them.
> 
> s/control/address/ ?

Both are important, but as Peter's reply noted, it was control
dependencies under discussion.  Data dependencies (which include the
ARM/PowerPC notion of address dependencies) are called out by the standard
already, but control dependencies are not.  I am not all that satisified
by current implementations of data dependencies, admittedly.  Should
be an interesting discussion.  ;-)

							Thanx, Paul


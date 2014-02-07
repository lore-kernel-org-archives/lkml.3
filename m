Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaBGSDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:03:30 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38714 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaBGSD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:03:28 -0500
Date: Fri, 7 Feb 2014 10:03:20 -0800
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
Message-ID: <20140207180320.GQ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140206192743.GH4250@linux.vnet.ibm.com>
 <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207170654.GQ5002@laptop.programming.kicks-ass.net>
 <20140207171336.GU5976@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207171336.GU5976@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020718-7164-0000-0000-000005C5E14D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 05:13:36PM +0000, Will Deacon wrote:
> On Fri, Feb 07, 2014 at 05:06:54PM +0000, Peter Zijlstra wrote:
> > On Fri, Feb 07, 2014 at 04:55:48PM +0000, Will Deacon wrote:
> > > Hi Paul,
> > > 
> > > On Fri, Feb 07, 2014 at 04:50:28PM +0000, Paul E. McKenney wrote:
> > > > On Fri, Feb 07, 2014 at 08:44:05AM +0100, Peter Zijlstra wrote:
> > > > > On Thu, Feb 06, 2014 at 08:20:51PM -0800, Paul E. McKenney wrote:
> > > > > > Hopefully some discussion of out-of-thin-air values as well.
> > > > > 
> > > > > Yes, absolutely shoot store speculation in the head already. Then drive
> > > > > a wooden stake through its hart.
> > > > > 
> > > > > C11/C++11 should not be allowed to claim itself a memory model until that
> > > > > is sorted.
> > > > 
> > > > There actually is a proposal being put forward, but it might not make ARM
> > > > and Power people happy because it involves adding a compare, a branch,
> > > > and an ISB/isync after every relaxed load...  Me, I agree with you,
> > > > much preferring the no-store-speculation approach.
> > > 
> > > Can you elaborate a bit on this please? We don't permit speculative stores
> > > in the ARM architecture, so it seems counter-intuitive that GCC needs to
> > > emit any additional instructions to prevent that from happening.
> > > 
> > > Stores can, of course, be observed out-of-order but that's a lot more
> > > reasonable :)
> > 
> > This is more about the compiler speculating on stores; imagine:
> > 
> >   if (x)
> >   	y = 1;
> >   else
> >   	y = 2;
> > 
> > The compiler is allowed to change that into:
> > 
> >   y = 2;
> >   if (x)
> >   	y = 1;
> > 
> > Which is of course a big problem when you want to rely on the ordering.
> 
> Understood, but that doesn't explain why Paul wants to add ISB/isync
> instructions which affect the *CPU* rather than the compiler!

Hey!!!  -I- don't want to add those instructions!  Others do.
Unfortunately, lots of others.

							Thanx, Paul


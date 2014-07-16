Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbaGPN1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:27:48 -0400
Received: from mail.efficios.com ([78.47.125.74]:34611 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaGPN1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:27:45 -0400
Date: Wed, 16 Jul 2014 13:27:42 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Message-ID: <1939765690.15175.1405517261974.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140716131855.GT8690@linux.vnet.ibm.com>
References: <20140707222345.GA6320@linux.vnet.ibm.com> <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com> <20140708075902.GM19379@twins.programming.kicks-ass.net> <20140708153117.GJ4603@linux.vnet.ibm.com> <20140714115738.GW19379@twins.programming.kicks-ass.net> <20140716121626.GM8690@linux.vnet.ibm.com> <20140716130534.GB19379@twins.programming.kicks-ass.net> <20140716131855.GT8690@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 3/4] documentation: Add acquire/release
 barriers to pairing rules
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.29.13]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: documentation: Add acquire/release barriers to pairing rules
Thread-Index: R30FLcfUBsd839fj+uKcGpp5EvDF6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> To: "Peter Zijlstra" <peterz@infradead.org>
> Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
> akpm@linux-foundation.org, "mathieu desnoyers" <mathieu.desnoyers@efficios.com>, josh@joshtriplett.org,
> niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
> dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
> Sent: Wednesday, July 16, 2014 9:18:55 AM
> Subject: Re: [PATCH tip/core/rcu 3/4] documentation: Add acquire/release barriers to pairing rules
> 
> On Wed, Jul 16, 2014 at 03:05:34PM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 16, 2014 at 05:16:26AM -0700, Paul E. McKenney wrote:
> > > On Mon, Jul 14, 2014 at 01:57:38PM +0200, Peter Zijlstra wrote:
> > > > On Tue, Jul 08, 2014 at 08:31:17AM -0700, Paul E. McKenney wrote:
> > > > 
> > > > > Good point, how about the following?
> > > > > 
> > > > > 	General barriers pair with each other, though they also pair
> > > > > 	with most other types of barriers, albeit without transitivity.
> > > > 
> > > > > 	An acquire barrier pairs with a release barrier, but both may also
> > > > > 	pair with other barriers, including of course general barriers.
> > > > 
> > > > > 	A write barrier pairs with a data dependency barrier, an acquire
> > > > > 	barrier, a release barrier, a read barrier, or a general barrier.
> > > > 
> > > > > 	Similarly a read barrier or a data dependency barrier pairs
> > > > > 	with a write barrier, an acquire barrier, a release barrier,
> > > > > 	or a general barrier:
> > > > 
> > > > It might be clearer with the added whitespace, or as an explicit list
> > > > I
> > > > suppose, but yes.
> > > 
> > > If I get ambitious, I might try making a table out of it, but I am not
> > > yet sure how I would set that up.  Something about having to say a lot
> > > in each cell, but with only a small amount of room in which to say it.
> > 
> > 
> >       |  mb | wmb | rmb | rbd | acq | rel |
> >  -----+-----+-----+-----+-----+-----+-----+
> >    mb |  X  |  X  |  X  |  X  |  X  |  X  |
> >  -----+-----+-----+-----+-----+-----+-----+
> >   wmb |  X  |     |  X  |  X  |     |     |
> >  -----+-----+-----+-----+-----+-----+-----+
> >   rmb |  X  |  X  |     |     |     |     |
> >  -----+-----+-----+-----+-----+-----+-----+
> >   rbd |  X  |  X  |     |     |     |     |
> >  -----+-----+-----+-----+-----+-----+-----+
> >   acq |  X  |     |     |     |     |  X  |
> >  -----+-----+-----+-----+-----+-----+-----+
> >   rel |  X  |     |     |     |  X  |     |
> >  -----+-----+-----+-----+-----+-----+-----+
> > 
> > (where rbd is read_barrier_depends).
> > 
> > Which is not entirely filled out, in particular I didn't do the creative
> > acq/rel bits.
> 
> Also needs to reflect that wmb really can pair with wmb.  See for example
> Scenario 15 of https://lwn.net/Articles/573436/.  Then again, your point
> might be that Scenario 15 is not all that useful, which is true in my
> experience -- though a good way to cause someone to find a use is to leave
> it out of such a table...
> 
> > > > Ah, I was more thinking of the fact that ACQUIRE/RELEASE are
> > > > semi-permeable while READ/WRITE are memop dependent.
> > > > 
> > > > So any combination will be a semi-permeable memop dependent thing,
> > > > which is the most narrow barrier possible.
> > > > 
> > > > So if we thing of ACQUIRE/RELEASE as being 'half' a full barrier,
> > > > separated in direction, and READ/WRITE as being 'half' a full barrier
> > > > separated on type, then the combination is a 'quarter' barrier.
> > > > 
> > > > Not arguing they're not useful, just saying we need to be extra
> > > > careful.
> > > 
> > > I do agree completely about the need for extra care!
> > > 
> > > For whatever it is worth, the permeability and read-write properties
> > > are isolated to each barrier in the pair.  For example, with "a" and
> > > "b" both initially zero:
> > > 
> > > 	CPU 1				CPU 2
> > > 	-----				-----
> > > 	ACCESS_ONCE(a) = 1;		r1 = b;
> > > 	smp_store_release(&b, 1);	smp_rmb();
> > > 	ACCESS_ONCE(c) = 1;		r2 = a;
> > > 					ACCESS_ONCE(c) = 2;
> > > 
> > > The outcome r1==1&&r2==0 is prohibited, but the ordering of the stores
> > > to "c" are not ordered: CPU 1's smp_store_release() does not affect
> > > later accesses, and CPU 2's smp_rmb() does not order stores.
> > > 
> > > Not sure that it is worth adding this sort of example, though.
> > 
> > Yeah, not sure either. Maybe just a big fat caution if you pair acq/rel
> > with anything other than its opposite or a general barrier.
> > 
> > Maybe use small 'x' for acq/rel + rmb/wmb and put a caution in the
> > 'legend' for 'x'.
> 
> When I expand things out, I end up wanting each cell to hold a
> scenario from the tables in https://lwn.net/Articles/573436/ and
> https://lwn.net/Articles/573497/, probably along with some cautions
> on what it does not do as well.  :-(

The table you just proposed seems to fit well as a "memory barrier
cheat sheet" to remind the usual pairing that can be explained in
a single sentence each.

Then you could point out that this table is indeed incomplete, and
point to a separate URL for detailed explanation of the more elaborate,
seldom used pairing.

Thoughts ?

Thanks,

Mathieu

> 
> 							Thanx, Paul
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

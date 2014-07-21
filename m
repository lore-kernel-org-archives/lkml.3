Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaGUVl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:41:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:33946 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaGUVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:41:24 -0400
Date: Mon, 21 Jul 2014 23:41:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Waiman Long <Waiman.Long@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
In-Reply-To: <20140721211801.GA12149@gmail.com>
Message-ID: <alpine.DEB.2.10.1407212330090.20847@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <20140721211801.GA12149@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Ingo Molnar wrote:
> * Waiman Long <Waiman.Long@hp.com> wrote:
> 
> > Testing done on a 4-socket Westmere-EX boxes with 40 cores (HT off) 
> > showed the following performance data (average kops/s) with various 
> > load factor (number of pause instructions) used in the critical 
> > section using an userspace mutex microbenchmark.
> > 
> >   Threads  Load	Waiting Futex	Spinning Futex 	  %Change
> >   -------  ----	-------------	--------------	  -------
> >     256	     1	     6894	    8883	    +29%
> >     256	    10	     3656	    4912	    +34%
> >     256	    50	     1332	    4358	   +227%
> >     256	   100	      792	    2753	   +248%
> >      10	     1	     6382	    4838	    -24%
> >      10	    10	     3614	    4748	    +31%
> >      10	    50	     1319	    3900	   +196%
> >      10	   100	      782	    2459	   +214%
> >       2	     1	     7905	    7194	   -9.0%
> >       2	    10	     4556	    4717	   +3.5%
> >       2	    50	     2191	    4167	    +90%
> >       2	   100	     1767	    2407	    +36%
> 
> So the numbers look interesting - but it would be _really_ important 
> to provide noise/sttdev figures in a sixth column as well (denoted in 
> percentage units, not in benchmark units), so that we know how 
> significant a particular speedup (or slowdown) is.

We care about that, once we have something which

 - Has a proper design

 - Covers all the corner cases of futexes

 - Does not introduce a gazillions of new lines of codes in futex.c

 - Does not create another set of subtle security issues. I'm so not
   interested to do the same exercise again - my brain still suffers.

The numbers provided are completely irrelevant as the implementation
is just the most idiotic approach to avoid all corner cases of
futexes, error handling and the proper treatment of detached kernel
state for the price of adding a completely unreviewable clusterfuck to
futex.c.

So, no. Don't encourage that number wankery any further. It's going
nowhere, period.

Thanks,

	tglx



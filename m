Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3I0PfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:35:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56302 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3I0PfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:35:01 -0400
Date: Fri, 27 Sep 2013 17:34:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] checkpatch: Make the memory barrier test noisier
Message-ID: <20130927153434.GG15690@laptop.programming.kicks-ass.net>
References: <1380236265.3467.103.camel@schen9-DESK>
 <20130927060213.GA6673@gmail.com>
 <20130927112323.GJ3657@laptop.programming.kicks-ass.net>
 <1380289495.17366.91.camel@joe-AO722>
 <20130927134802.GA15690@laptop.programming.kicks-ass.net>
 <1380291257.17366.103.camel@joe-AO722>
 <20130927142605.GC15690@laptop.programming.kicks-ass.net>
 <1380292495.17366.106.camel@joe-AO722>
 <20130927145007.GD15690@laptop.programming.kicks-ass.net>
 <20130927151749.GA2149@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927151749.GA2149@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 08:17:50AM -0700, Paul E. McKenney wrote:
> > Barriers are fundamentally about order; and order only makes sense if
> > there's more than 1 party to the game.
> 
> Oddly enough, there is one exception that proves the rule...  On Itanium,
> suppose we have the following code, with x initially equal to zero:
> 
> CPU 1: ACCESS_ONCE(x) = 1;
> 
> CPU 2: r1 = ACCESS_ONCE(x); r2 = ACCESS_ONCE(x);
> 
> Itanium architects have told me that it really is possible for CPU 2 to
> see r1==1 and r2==0.  Placing a memory barrier between CPU 2's pair of
> fetches prevents this, but without any other memory barrier to pair with.

Oh man.. its really past time to sink that itanic already.

I suppose it allows the cpu to reorder the reads in its pipeline and the
memory barrier disallows this. Curious.. does our memory-barriers.txt
file mention this 'fun' fact?

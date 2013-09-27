Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3I0PSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:18:01 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39253 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3I0PR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:17:59 -0400
Date: Fri, 27 Sep 2013 08:17:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20130927151749.GA2149@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1380235333.3229.39.camel@j-VirtualBox>
 <1380236265.3467.103.camel@schen9-DESK>
 <20130927060213.GA6673@gmail.com>
 <20130927112323.GJ3657@laptop.programming.kicks-ass.net>
 <1380289495.17366.91.camel@joe-AO722>
 <20130927134802.GA15690@laptop.programming.kicks-ass.net>
 <1380291257.17366.103.camel@joe-AO722>
 <20130927142605.GC15690@laptop.programming.kicks-ass.net>
 <1380292495.17366.106.camel@joe-AO722>
 <20130927145007.GD15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927145007.GD15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092715-1542-0000-0000-000001CDEB87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 04:50:07PM +0200, Peter Zijlstra wrote:
> On Fri, Sep 27, 2013 at 07:34:55AM -0700, Joe Perches wrote:
> > That would make it seem as if all barriers are SMP no?
> 
> I would think any memory barrier is ordering against someone else; if
> not smp then a device/hardware -- like for instance the hardware page
> table walker.
> 
> Barriers are fundamentally about order; and order only makes sense if
> there's more than 1 party to the game.

Oddly enough, there is one exception that proves the rule...  On Itanium,
suppose we have the following code, with x initially equal to zero:

CPU 1: ACCESS_ONCE(x) = 1;

CPU 2: r1 = ACCESS_ONCE(x); r2 = ACCESS_ONCE(x);

Itanium architects have told me that it really is possible for CPU 2 to
see r1==1 and r2==0.  Placing a memory barrier between CPU 2's pair of
fetches prevents this, but without any other memory barrier to pair with.

> > Maybe just refer to Documentation/memory-barriers.txt
> > and/or say something like "please document appropriately"
> 
> Documentation/memory-barriers.txt is always good; appropriately doesn't
> seem to quantify anything much at all. Someone might think:
> 
> /*  */
> smp_mb();
> 
> appropriate... 

I end up doing this:

/* */
smp_mb(); /* See above block comment. */

But it would be nice for the prior comment to be recognized as belonging
to the memory barrier without the additional "See above" comment.

In any case, please feel free to add:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

to the original checkpatch.pl patch.

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaBQWxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:53:00 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42897 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaBQWw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:52:59 -0500
Date: Mon, 17 Feb 2014 14:52:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/6] Documentation/memory-barriers.txt:
 ACCESS_ONCE() provides cache coherence
Message-ID: <20140217225253.GM4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217212625.GA4083@linux.vnet.ibm.com>
 <1392672413-5114-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392672413-5114-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140217214056.GB7941@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217214056.GB7941@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1542-0000-0000-0000065316EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:40:56PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 01:26:49PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The ACCESS_ONCE() primitive provides cache coherence, but the
> > documentation does not clearly state this.  This commit therefore upgrades
> > the documentation.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Punctuation nit below; otherwise:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> >  Documentation/memory-barriers.txt | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> > index 102dc19c4119..ad6db1d48f1f 100644
> > --- a/Documentation/memory-barriers.txt
> > +++ b/Documentation/memory-barriers.txt
> > @@ -1249,6 +1249,23 @@ The ACCESS_ONCE() function can prevent any number of optimizations that,
> >  while perfectly safe in single-threaded code, can be fatal in concurrent
> >  code.  Here are some examples of these sorts of optimizations:
> >  
> > + (*) The compiler is within its rights to reorder loads and stores
> > +     to the same variable, and in some cases, the CPU is within its
> > +     rights to reorder loads to the same variable.  This means that
> > +     the following code:
> > +
> > +	a[0] = x;
> > +	a[1] = x;
> > +
> > +     Might result in an older value of x stored in a[1] than in a[0].
> > +     Prevent both the compiler and the CPU from doing this as follows:
> > +
> > +	a[0] = ACCESS_ONCE(x);
> > +	a[1] = ACCESS_ONCE(x);
> > +
> > +     In short, ACCESS_ONCE() provides "cache coherence" for accesses from
> > +     multiple CPUs to a single variable.
> 
> You don't need to "quote" the well-established term "cache coherence".

Good point, fixed and applied your Reviewed-by, thank you!

							Thanx, Paul

> >   (*) The compiler is within its rights to merge successive loads from
> >       the same variable.  Such merging can cause the compiler to "optimize"
> >       the following code:
> > -- 
> > 1.8.1.5
> > 
> 


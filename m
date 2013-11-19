Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3KSXGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:06:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37901 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3KSXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:06:07 -0500
Date: Tue, 19 Nov 2013 15:05:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>, "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH v5 2/4] MCS Lock: optimizations and extra comments
Message-ID: <20131119230542.GW4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1383935697.git.tim.c.chen@linux.intel.com>
 <1383940325.11046.415.camel@schen9-DESK>
 <20131119191310.GO4138@linux.vnet.ibm.com>
 <1384901861.11046.449.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384901861.11046.449.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111923-8236-0000-0000-000003F85B74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:57:41PM -0800, Tim Chen wrote:
> On Tue, 2013-11-19 at 11:13 -0800, Paul E. McKenney wrote:
> > On Fri, Nov 08, 2013 at 11:52:05AM -0800, Tim Chen wrote:
> > > 
> > > +/*
> > > + * Releases the lock. The caller should pass in the corresponding node that
> > > + * was used to acquire the lock.
> > > + */
> > >  static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> > >  {
> > >  	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
> > > @@ -51,7 +60,7 @@ static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *nod
> > >  		/*
> > >  		 * Release the lock by setting it to NULL
> > >  		 */
> > > -		if (cmpxchg(lock, node, NULL) == node)
> > > +		if (likely(cmpxchg(lock, node, NULL) == node))
> > 
> > Agreed here as well.  Takes a narrow race to hit this.
> > 
> > So, did your testing exercise this path?  If the answer is "yes", 
> 
> 
> Paul,
> 
> I did some instrumentation and confirmed that the path in question has 
> been exercised.  So this patch should be okay.

Very good!

							Thanx, Paul


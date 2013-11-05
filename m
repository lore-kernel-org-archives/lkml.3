Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3KETar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:30:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:51958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3KETap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:30:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="404072598"
Subject: Re: [PATCH v2 4/4] MCS Lock: Make mcs_spinlock.h includable in
 other files
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
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
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>
In-Reply-To: <20131105185717.GZ16117@laptop.programming.kicks-ass.net>
References: <cover.1383670202.git.tim.c.chen@linux.intel.com>
	 <1383673359.11046.280.camel@schen9-DESK>
	 <20131105185717.GZ16117@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Nov 2013 11:30:42 -0800
Message-ID: <1383679842.11046.298.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 19:57 +0100, Peter Zijlstra wrote:
> On Tue, Nov 05, 2013 at 09:42:39AM -0800, Tim Chen wrote:
> > + * The _raw_mcs_spin_lock() function should not be called directly. Instead,
> > + * users should call mcs_spin_lock().
> >   */
> > -static noinline
> > -void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> > +static inline
> > +void _raw_mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> >  {
> >  	struct mcs_spinlock *prev;
> >  
> 
> So why keep it in the header at all?

I also made the suggestion originally of keeping both lock and unlock in
mcs_spinlock.c.  Wonder if Waiman decides to keep them in header 
because in-lining the unlock function makes execution a bit faster?

Tim


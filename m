Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3KFQIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:08:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60119 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3KFQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:08:53 -0500
Date: Wed, 6 Nov 2013 17:08:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH v2 4/4] MCS Lock: Make mcs_spinlock.h includable in other
 files
Message-ID: <20131106160815.GR10651@twins.programming.kicks-ass.net>
References: <cover.1383670202.git.tim.c.chen@linux.intel.com>
 <1383673359.11046.280.camel@schen9-DESK>
 <20131105185717.GZ16117@laptop.programming.kicks-ass.net>
 <1383679842.11046.298.camel@schen9-DESK>
 <527A60E3.3000106@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A60E3.3000106@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:31:47AM -0500, Waiman Long wrote:
> On 11/05/2013 02:30 PM, Tim Chen wrote:
> >On Tue, 2013-11-05 at 19:57 +0100, Peter Zijlstra wrote:
> >>On Tue, Nov 05, 2013 at 09:42:39AM -0800, Tim Chen wrote:
> >>>+ * The _raw_mcs_spin_lock() function should not be called directly. Instead,
> >>>+ * users should call mcs_spin_lock().
> >>>   */
> >>>-static noinline
> >>>-void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> >>>+static inline
> >>>+void _raw_mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> >>>  {
> >>>  	struct mcs_spinlock *prev;
> >>>
> >>So why keep it in the header at all?
> >I also made the suggestion originally of keeping both lock and unlock in
> >mcs_spinlock.c.  Wonder if Waiman decides to keep them in header
> >because in-lining the unlock function makes execution a bit faster?
> >
> >Tim
> >
> 
> I was following the example of the spinlock code where the lock function is
> not inlined, but the unlock function is. I have no objection to make them
> both as non-inlined functions, if you think that is the right move.

I don't care, what I do find odd is the existence of
_raw_mcs_spin_lock(). If you want to out-of-line it, just move the
entire thing into a .c file already.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaBBV6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:58:24 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33084 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaBBV6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:58:23 -0500
Date: Sun, 2 Feb 2014 13:58:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH v2 2/5] mutex: Modify the way optimistic spinners are
 queued
Message-ID: <20140202215817.GE4333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-3-git-send-email-jason.low2@hp.com>
 <20140128202334.GO9012@linux.vnet.ibm.com>
 <1390947041.2807.28.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390947041.2807.28.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020221-8236-0000-0000-000006A65D43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 02:10:41PM -0800, Jason Low wrote:
> On Tue, 2014-01-28 at 12:23 -0800, Paul E. McKenney wrote:
> > On Tue, Jan 28, 2014 at 11:13:13AM -0800, Jason Low wrote:
> > >  		/*
> > >  		 * The cpu_relax() call is a compiler barrier which forces
> > > @@ -514,6 +511,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> > >  		 */
> > >  		arch_mutex_cpu_relax();
> > >  	}
> > > +	mspin_unlock(MLOCK(lock), &node);
> > >  slowpath:
> > 
> > Are there any remaining goto statements to slowpath?  If so, they need
> > to release the lock.  If not, this label should be removed.
> 
> Yes, if the mutex_can_spin_on_owner() returns false, then the thread
> goes to directly slowpath, bypassing the optimistic spinning loop. In
> that case, the thread avoids acquiring the MCS lock, and doesn't unlock
> the MCS lock.

Got it, apologies for my confusion!

							Thanx, Paul


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaA1WKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:10:45 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46632 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaA1WKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:10:44 -0500
Message-ID: <1390947041.2807.28.camel@j-VirtualBox>
Subject: Re: [PATCH v2 2/5] mutex: Modify the way optimistic spinners are
 queued
From: Jason Low <jason.low2@hp.com>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@redhat.com, peterz@infradead.org, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 14:10:41 -0800
In-Reply-To: <20140128202334.GO9012@linux.vnet.ibm.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-3-git-send-email-jason.low2@hp.com>
	 <20140128202334.GO9012@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 12:23 -0800, Paul E. McKenney wrote:
> On Tue, Jan 28, 2014 at 11:13:13AM -0800, Jason Low wrote:
> >  		/*
> >  		 * The cpu_relax() call is a compiler barrier which forces
> > @@ -514,6 +511,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> >  		 */
> >  		arch_mutex_cpu_relax();
> >  	}
> > +	mspin_unlock(MLOCK(lock), &node);
> >  slowpath:
> 
> Are there any remaining goto statements to slowpath?  If so, they need
> to release the lock.  If not, this label should be removed.

Yes, if the mutex_can_spin_on_owner() returns false, then the thread
goes to directly slowpath, bypassing the optimistic spinning loop. In
that case, the thread avoids acquiring the MCS lock, and doesn't unlock
the MCS lock.

Thanks,
Jason


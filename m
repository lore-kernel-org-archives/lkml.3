Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaA1VRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:17:48 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:47930 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbaA1VRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:17:22 -0500
Message-ID: <1390943840.11839.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 2/5] mutex: Modify the way optimistic spinners are
 queued
From: Davidlohr Bueso <davidlohr@hp.com>
To: paulmck@linux.vnet.ibm.com
Cc: Jason Low <jason.low2@hp.com>, mingo@redhat.com, peterz@infradead.org,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 13:17:20 -0800
In-Reply-To: <20140128202334.GO9012@linux.vnet.ibm.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-3-git-send-email-jason.low2@hp.com>
	 <20140128202334.GO9012@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 12:23 -0800, Paul E. McKenney wrote:
> On Tue, Jan 28, 2014 at 11:13:13AM -0800, Jason Low wrote:
> > ...
> >  		if (!owner && (need_resched() || rt_task(task)))
> > -			goto slowpath;
> > +			break;
> > 
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

We still have the !mutex_can_spin_on_owner case.

Thanks,
Davidlohr


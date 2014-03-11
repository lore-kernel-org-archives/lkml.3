Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaCKPd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:33:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56978 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaCKPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:33:55 -0400
Date: Tue, 11 Mar 2014 16:33:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking/mutexes: Modify the way optimistic
 spinners are queued
Message-ID: <20140311153344.GX27965@twins.programming.kicks-ass.net>
References: <1390936396-3962-3-git-send-email-jason.low2@hp.com>
 <tip-47667fa1502e4d759df87e9cc7fbc0f202483361@git.kernel.org>
 <1394551460.11149.6.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394551460.11149.6.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 08:24:20AM -0700, Jason Low wrote:
> On Tue, 2014-03-11 at 05:41 -0700, tip-bot for Jason Low wrote:
> 
> > diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> > index e6d646b..82dad2c 100644
> > --- a/kernel/locking/mutex.c
> > +++ b/kernel/locking/mutex.c
> > @@ -403,9 +403,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> >  	if (!mutex_can_spin_on_owner(lock))
> >  		goto slowpath;
> >  
> > +	mcs_spin_lock(&lock->mcs_lock, &node);
> >  	for (;;) {
> >  		struct task_struct *owner;
> > -		struct mcs_spinlock  node;
> 
> Hi Peter, Ingo,
> 
> The "struct mcs_spinlock node" still needs to be moved to the beginning
> of __mutex_lock_common() right?

Crud; I thought I fixed that since you pointed that out the last time.

Anyway; later patches make the argument go away, so its a bisect fail at
worst, not sure that's worth fixing at this point :/

sorry about that.

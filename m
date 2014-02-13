Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBMR1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:27:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49027 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaBMR1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:27:15 -0500
Date: Thu, 13 Feb 2014 18:26:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 7/8] locking: Introduce qrwlock
Message-ID: <20140213172657.GF3545@laptop.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.796912337@infradead.org>
 <52FA6941.4060102@hp.com>
 <52FA844B.7070003@hp.com>
 <20140213163546.GF6835@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213163546.GF6835@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 05:35:46PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 03:12:59PM -0500, Waiman Long wrote:
> > Using the same locktest program to repetitively take a single rwlock with
> > programmable number of threads and count their execution times. Each
> > thread takes the lock 5M times on a 4-socket 40-core Westmere-EX
> > system. I bound all the threads to different CPUs with the following
> > 3 configurations:
> > 
> >  1) Both CPUs and lock are in the same node
> >  2) CPUs and lock are in different nodes
> >  3) Half of the CPUs are in same node as the lock & the other half
> >     are remote
> 
> I can't find these configurations in the below numbers; esp the first is
> interesting because most computers out there have no nodes.
> 
> > Two types of qrwlock are tested:
> >  1) Use MCS lock
> >  2) Use ticket lock
> 
> arch_spinlock_t; you forget that if you change that to an MCS style lock
> this one goes along for free.

Furthermore; comparing the current rwlock to the ticket-rwlock already
shows an improvement, so on that aspect its worth it as well.

And there's also the paravirt people to consider; a fair rwlock will
make them unhappy; and I'm hoping that their current paravirt ticket
stuff is sufficient to deal with the ticket-rwlock without them having
to come and wreck things again.

Similarly; qspinlock needs paravirt support.



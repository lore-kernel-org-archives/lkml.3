Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaBJVCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:02:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36176 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaBJVCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:02:39 -0500
Date: Mon, 10 Feb 2014 22:02:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/8] mutex: In mutex_can_spin_on_owner(), return false if
 task need_resched()
Message-ID: <20140210210224.GZ5002@laptop.programming.kicks-ass.net>
References: <20140210195820.834693028@infradead.org>
 <20140210203659.465074341@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210203659.465074341@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 08:58:22PM +0100, Peter Zijlstra wrote:

Bah, I forgot Quilt eats the From: headers and I forgot to re-add them.
They're still present in the queue, just lost in mailing :/

> The mutex_can_spin_on_owner() function should also return false if the
> task needs to be rescheduled to avoid entering the MCS queue when it
> needs to reschedule.
> 
> Cc: chegu_vinod@hp.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: Waiman.Long@hp.com
> Cc: torvalds@linux-foundation.org
> Cc: tglx@linutronix.de
> Cc: riel@redhat.com
> Cc: akpm@linux-foundation.org
> Cc: davidlohr@hp.com
> Cc: hpa@zytor.com
> Cc: andi@firstfloor.org
> Cc: aswin@hp.com
> Cc: mingo@kernel.org
> Cc: scott.norton@hp.com
> Signed-off-by: Jason Low <jason.low2@hp.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1390936396-3962-2-git-send-email-jason.low2@hp.com
> ---
>  kernel/locking/mutex.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -166,6 +166,9 @@ static inline int mutex_can_spin_on_owne
>  	struct task_struct *owner;
>  	int retval = 1;
>  
> +	if (need_resched())
> +		return 0;
> +
>  	rcu_read_lock();
>  	owner = ACCESS_ONCE(lock->owner);
>  	if (owner)
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaA1UUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:20:50 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:56541 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaA1UUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:20:46 -0500
Date: Tue, 28 Jan 2014 12:20:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH v2 1/5] mutex: In mutex_can_spin_on_owner(), return false
 if task need_resched()
Message-ID: <20140128202042.GN9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
 <1390936396-3962-2-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390936396-3962-2-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012820-8236-0000-0000-0000067D5989
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:13:12AM -0800, Jason Low wrote:
> The mutex_can_spin_on_owner() function should also return false if the
> task needs to be rescheduled to avoid entering the MCS queue when it
> needs to reschedule.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

But I cannot help asking how this affects performance.  (My guess is
"not much", but always good to know.)

> ---
>  kernel/locking/mutex.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 4dd6e4c..85c6be1 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -212,6 +212,9 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
>  	struct task_struct *owner;
>  	int retval = 1;
> 
> +	if (need_resched())
> +		return 0;
> +
>  	rcu_read_lock();
>  	owner = ACCESS_ONCE(lock->owner);
>  	if (owner)
> -- 
> 1.7.1
> 


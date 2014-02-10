Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaBJVwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:52:35 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:35164 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBJVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:52:31 -0500
Date: Mon, 10 Feb 2014 16:52:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org
Subject: Re: lockdep: strange %s#5 lock name
Message-ID: <20140210215224.GB25350@mtj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
 <20140210192846.GF27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210192846.GF27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 08:28:46PM +0100, Peter Zijlstra wrote:
> Lol.. its correct afaict:
> 
> struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
> 					       unsigned int flags,
> 					       int max_active,
> 					       struct lock_class_key *key,
> 					       const char *lock_name, ...)
> {
> 	...
> 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
> 
> 
> 
> So while its called lock_name, it looks like the argument is a format.

Heh, yeah, that's silly.

> I suppose the below was what was intended...
> 
> ---
>  kernel/workqueue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 82ef9f3b7473..861d8ddd92a2 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4202,7 +4202,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
>  	INIT_LIST_HEAD(&wq->flusher_overflow);
>  	INIT_LIST_HEAD(&wq->maydays);
>  
> -	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
> +	lockdep_init_map(&wq->lockdep_map, wq->name, key, 0);

Looks good to me.  Can you please post the patch with SOB?

Thanks!

-- 
tejun

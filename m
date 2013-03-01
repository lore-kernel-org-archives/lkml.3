Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab3CANJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:09:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab3CANJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:09:11 -0500
Date: Fri, 1 Mar 2013 14:09:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: luciarosculete@gmail.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] semaphore: give an unlikely for down's timeout
In-Reply-To: <1362128628-18457-1-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.LNX.2.00.1303011408230.25001@pobox.suse.cz>
References: <1362128628-18457-1-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013, liguang wrote:

> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>


Makes sense. Adding Andrew to CC.

> ---
>  kernel/semaphore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/semaphore.c b/kernel/semaphore.c
> index 4567fc0..9c7017d 100644
> --- a/kernel/semaphore.c
> +++ b/kernel/semaphore.c
> @@ -214,7 +214,7 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
>  	for (;;) {
>  		if (signal_pending_state(state, task))
>  			goto interrupted;
> -		if (timeout <= 0)
> +		if (unlikely(timeout <= 0))
>  			goto timed_out;
>  		__set_task_state(task, state);
>  		raw_spin_unlock_irq(&sem->lock);
> -- 
> 1.7.2.5
> 

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaIPHs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:48:27 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52898 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaIPHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:48:26 -0400
Date: Tue, 16 Sep 2014 09:48:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, dbueso@suse.de
Subject: Re: [PATCH 2/2] locking/rwsem-spinlock: Cleanup down_read()
Message-ID: <20140916074821.GA21542@gmail.com>
References: <1410500066-5909-1-git-send-email-dave@stgolabs.net>
 <1410500066-5909-2-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410500066-5909-2-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <dave@stgolabs.net> wrote:

> ... when returning from a successful lock acquisition. The horror!
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  kernel/locking/rwsem-spinlock.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
> index 2c93571..07e456c 100644
> --- a/kernel/locking/rwsem-spinlock.c
> +++ b/kernel/locking/rwsem-spinlock.c
> @@ -130,7 +130,7 @@ void __sched __down_read(struct rw_semaphore *sem)
>  		/* granted */
>  		sem->count++;
>  		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
> -		goto out;
> +		return;
>  	}
>  
>  	tsk = current;
> @@ -155,8 +155,6 @@ void __sched __down_read(struct rw_semaphore *sem)
>  	}
>  
>  	tsk->state = TASK_RUNNING;
> - out:
> -	;
>  }

It following an existing 'out' pattern found elsewhere in the 
file - I don't think there's much wrong about that per se - 
especially in locking code we try to not return from the middle 
of the flow.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbbAOToP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:44:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbbAOToN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:44:13 -0500
Date: Thu, 15 Jan 2015 20:43:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 3/3] signal: use current->state helpers
Message-ID: <20150115194316.GB28727@redhat.com>
References: <1421305154-14788-1-git-send-email-dave@stgolabs.net> <1421305154-14788-3-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421305154-14788-3-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Davidlohr Bueso wrote:
>
> Call __set_current_state() instead of assigning the new state directly.
> These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
> track of who changed the state.

Acked-by: Oleg Nesterov <oleg@redhat.com>

> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/signal.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 33a5275..a390499 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3550,7 +3550,7 @@ SYSCALL_DEFINE2(signal, int, sig, __sighandler_t, handler)
>  SYSCALL_DEFINE0(pause)
>  {
>  	while (!signal_pending(current)) {
> -		current->state = TASK_INTERRUPTIBLE;
> +		__set_current_state(TASK_INTERRUPTIBLE);
>  		schedule();
>  	}
>  	return -ERESTARTNOHAND;
> @@ -3563,7 +3563,7 @@ int sigsuspend(sigset_t *set)
>  	current->saved_sigmask = current->blocked;
>  	set_current_blocked(set);
>  
> -	current->state = TASK_INTERRUPTIBLE;
> +	__set_current_state(TASK_INTERRUPTIBLE);
>  	schedule();
>  	set_restore_sigmask();
>  	return -ERESTARTNOHAND;
> -- 
> 2.1.2
> 


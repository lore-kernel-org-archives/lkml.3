Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaIKTSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:18:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50320 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaIKTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:18:34 -0400
Date: Thu, 11 Sep 2014 12:18:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: roy.qing.li@gmail.com
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be,
        jkosina@suse.cz, paulmck@linux.vnet.ibm.com, richard@nod.at,
        oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] signal: replace !likely with unlikely!
Message-ID: <20140911191830.GA31511@roeck-us.net>
References: <1410396496-13845-1-git-send-email-roy.qing.li@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410396496-13845-1-git-send-email-roy.qing.li@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 08:48:16AM +0800, roy.qing.li@gmail.com wrote:
> From: Li RongQing <roy.qing.li@gmail.com> 
> 
> !likely() is hard to be understood, and I do not know if compiler can
> optimise this condition, but unlikely(!()) is clear
> 
> Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
> ---
>  kernel/signal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 8f0876f..6156cfa 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1571,7 +1571,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
>  	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>  
>  	ret = -1;
> -	if (!likely(lock_task_sighand(t, &flags)))
> +	if (unlikely(!lock_task_sighand(t, &flags)))

I wonder if you tested this code. Seems to be unlikely (punt not intended).

Guenter

>  		goto ret;
>  
>  	ret = 1; /* the signal is ignored */
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

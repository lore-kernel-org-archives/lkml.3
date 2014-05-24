Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaEXVxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 17:53:34 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34064 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaEXVxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 17:53:33 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 24 May 2014 14:53:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] lib/debugobjects.c: convert printk to pr_foo()
Message-ID: <20140524215322.GA24038@thin>
References: <1400936768-24897-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400936768-24897-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 03:06:08PM +0200, Fabian Frederick wrote:
> Convert all except KERN_DEBUG

Why not KERN_DEBUG?

> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  lib/debugobjects.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index e0731c3..ea4c737 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -218,7 +218,7 @@ static void debug_objects_oom(void)
>  	unsigned long flags;
>  	int i;
>  
> -	printk(KERN_WARNING "ODEBUG: Out of memory. ODEBUG disabled\n");
> +	pr_warn("ODEBUG: Out of memory. ODEBUG disabled\n");
>  
>  	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
>  		raw_spin_lock_irqsave(&db->lock, flags);
> @@ -292,11 +292,9 @@ static void debug_object_is_on_stack(void *addr, int onstack)
>  
>  	limit++;
>  	if (is_on_stack)
> -		printk(KERN_WARNING
> -		       "ODEBUG: object is on stack, but not annotated\n");
> +		pr_warn("ODEBUG: object is on stack, but not annotated\n");
>  	else
> -		printk(KERN_WARNING
> -		       "ODEBUG: object is not on stack, but annotated\n");
> +		pr_warn("ODEBUG: object is not on stack, but annotated\n");
>  	WARN_ON(1);
>  }
>  
> @@ -985,7 +983,7 @@ static void __init debug_objects_selftest(void)
>  	if (check_results(&obj, ODEBUG_STATE_NONE, ++fixups, ++warnings))
>  		goto out;
>  #endif
> -	printk(KERN_INFO "ODEBUG: selftest passed\n");
> +	pr_info("ODEBUG: selftest passed\n");
>  
>  out:
>  	debug_objects_fixups = oldfixups;
> @@ -1090,7 +1088,7 @@ void __init debug_objects_mem_init(void)
>  		debug_objects_enabled = 0;
>  		if (obj_cache)
>  			kmem_cache_destroy(obj_cache);
> -		printk(KERN_WARNING "ODEBUG: out of memory.\n");
> +		pr_warn("ODEBUG: out of memory.\n");
>  	} else
>  		debug_objects_selftest();
>  }
> -- 
> 1.8.4.5
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaEXVyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 17:54:23 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:38845 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaEXVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 17:54:22 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 24 May 2014 14:54:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] lib/debugobjects.c: add pr_fmt to logging
Message-ID: <20140524215412.GB24038@thin>
References: <1400936815-24956-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400936815-24956-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 03:06:55PM +0200, Fabian Frederick wrote:
> Add ODEBUG: prefix to pr_fmt
> 
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  lib/debugobjects.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index ea4c737..b628247 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -7,6 +7,9 @@
>   *
>   * For licencing details see kernel-base/COPYING
>   */
> +
> +#define pr_fmt(fmt) "ODEBUG: " fmt
> +
>  #include <linux/debugobjects.h>
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
> @@ -218,7 +221,7 @@ static void debug_objects_oom(void)
>  	unsigned long flags;
>  	int i;
>  
> -	pr_warn("ODEBUG: Out of memory. ODEBUG disabled\n");
> +	pr_warn("Out of memory. ODEBUG disabled\n");
>  
>  	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
>  		raw_spin_lock_irqsave(&db->lock, flags);
> @@ -292,9 +295,9 @@ static void debug_object_is_on_stack(void *addr, int onstack)
>  
>  	limit++;
>  	if (is_on_stack)
> -		pr_warn("ODEBUG: object is on stack, but not annotated\n");
> +		pr_warn("object is on stack, but not annotated\n");
>  	else
> -		pr_warn("ODEBUG: object is not on stack, but annotated\n");
> +		pr_warn("object is not on stack, but annotated\n");
>  	WARN_ON(1);
>  }
>  
> @@ -983,7 +986,7 @@ static void __init debug_objects_selftest(void)
>  	if (check_results(&obj, ODEBUG_STATE_NONE, ++fixups, ++warnings))
>  		goto out;
>  #endif
> -	pr_info("ODEBUG: selftest passed\n");
> +	pr_info("selftest passed\n");
>  
>  out:
>  	debug_objects_fixups = oldfixups;
> @@ -1088,7 +1091,7 @@ void __init debug_objects_mem_init(void)
>  		debug_objects_enabled = 0;
>  		if (obj_cache)
>  			kmem_cache_destroy(obj_cache);
> -		pr_warn("ODEBUG: out of memory.\n");
> +		pr_warn("out of memory.\n");
>  	} else
>  		debug_objects_selftest();
>  }
> -- 
> 1.8.4.5
> 

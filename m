Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbaE2Pv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:51:28 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:37997 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbaE2Pv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:51:27 -0400
X-Originating-IP: 50.43.32.211
Date: Thu, 29 May 2014 08:51:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 2/3] lib/debugobjects.c: add pr_fmt to logging
Message-ID: <20140529155116.GB31286@thin>
References: <20140529092408.c030386edd36b5f5983609e3@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529092408.c030386edd36b5f5983609e3@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:24:08AM +0200, Fabian Frederick wrote:
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
> 1.9.1
> 

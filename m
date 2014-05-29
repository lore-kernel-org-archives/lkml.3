Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbaE2Pvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:51:54 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52242 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbaE2Pvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:51:53 -0400
X-Originating-IP: 50.43.32.211
Date: Thu, 29 May 2014 08:51:47 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 3/3] lib/debugobjects.c: convert printk(KERN_DEBUG to
 pr_debug
Message-ID: <20140529155147.GC31286@thin>
References: <20140529092532.850a410f6df7b3ae57726a41@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529092532.850a410f6df7b3ae57726a41@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:25:32AM +0200, Fabian Frederick wrote:
> Direct conversion of one KERN_DEBUG message without DEBUG definition
> (suggested by Josh Triplett)
> 
> That message will now be disabled by default.
> (see Documentation/CodingStyle Chapter 13)
> 
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  lib/debugobjects.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index b628247..547f7f9 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -1061,8 +1061,8 @@ static int __init debug_objects_replace_static_objects(void)
>  	}
>  	local_irq_enable();
>  
> -	printk(KERN_DEBUG "ODEBUG: %d of %d active objects replaced\n", cnt,
> -	       obj_pool_used);
> +	pr_debug("%d of %d active objects replaced\n",
> +		 cnt, obj_pool_used);
>  	return 0;
>  free:
>  	hlist_for_each_entry_safe(obj, tmp, &objects, node) {
> -- 
> 1.9.1

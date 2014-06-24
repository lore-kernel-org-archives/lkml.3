Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaFXWTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:19:01 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60647 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaFXWTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:19:00 -0400
Date: Tue, 24 Jun 2014 15:18:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/vmalloc.c: add a schedule point to vmalloc()
In-Reply-To: <1403618407.3796.15.camel@edumazet-glaptop2.roam.corp.google.com>
Message-ID: <alpine.DEB.2.02.1406241517560.29176@chino.kir.corp.google.com>
References: <1403618407.3796.15.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Eric Dumazet wrote:

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index f64632b67196..05a145ed1332 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1602,6 +1602,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  			goto fail;
>  		}
>  		area->pages[i] = page;
> +		cond_resched();
>  	}
>  
>  	if (map_vm_area(area, prot, &pages))

Now that we pass the gfp mask into vmalloc() and all allocations aren't 
inherently GFP_KERNEL, I think this should only be done for (gfp_mask & 
__GFP_WAIT).

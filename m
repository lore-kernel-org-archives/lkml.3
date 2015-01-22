Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbbAVXTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:19:23 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44907 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbAVXTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:19:20 -0500
Date: Thu, 22 Jan 2015 15:19:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Skvortsov <andrej.skvortzov@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: suppress BUG messages for
 kmem_cache_alloc/kmem_cache_free
In-Reply-To: <1421932519-21036-1-git-send-email-Andrej.Skvortzov@gmail.com>
Message-ID: <alpine.DEB.2.10.1501221518020.27807@chino.kir.corp.google.com>
References: <1421932519-21036-1-git-send-email-Andrej.Skvortzov@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Andrey Skvortsov wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index ceee1d7..6bcd031 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2404,7 +2404,7 @@ redo:
>  	 */
>  	do {
>  		tid = this_cpu_read(s->cpu_slab->tid);
> -		c = this_cpu_ptr(s->cpu_slab);
> +		c = raw_cpu_ptr(s->cpu_slab);
>  	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
>  
>  	/*
> @@ -2670,7 +2670,7 @@ redo:
>  	 */
>  	do {
>  		tid = this_cpu_read(s->cpu_slab->tid);
> -		c = this_cpu_ptr(s->cpu_slab);
> +		c = raw_cpu_ptr(s->cpu_slab);
>  	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
>  
>  	/* Same with comment on barrier() in slab_alloc_node() */

This should already be fixed with 
http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch

You can find the latest mmotm, which was just released, at 
http://ozlabs.org/~akpm/mmotm and it should be in linux-next tomorrow.

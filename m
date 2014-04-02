Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbaDBGLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 02:11:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:44962 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaDBGLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 02:11:20 -0400
Message-ID: <533BAA03.9000406@parallels.com>
Date: Wed, 2 Apr 2014 10:11:15 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <glommer@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <devel@openvz.org>
Subject: Re: [PATCH -mm v2 2/2] mm: get rid of __GFP_KMEMCG
References: <cover.1396335798.git.vdavydov@parallels.com> <c50644c5c979fbe21e72cc2751876ceaff6ef495.1396335798.git.vdavydov@parallels.com> <xr93a9c4k13q.fsf@gthelen.mtv.corp.google.com>
In-Reply-To: <xr93a9c4k13q.fsf@gthelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 04:48 AM, Greg Thelen wrote:
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 3dd389aa91c7..6d6959292e00 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -358,17 +358,6 @@ kmem_cache_alloc_node_trace(struct kmem_cache *s,
>  #include <linux/slub_def.h>
>  #endif
>  
> -static __always_inline void *
> -kmalloc_order(size_t size, gfp_t flags, unsigned int order)
> -{
> -	void *ret;
> -
> -	flags |= (__GFP_COMP | __GFP_KMEMCG);
> -	ret = (void *) __get_free_pages(flags, order);
> -	kmemleak_alloc(ret, size, 1, flags);
> -	return ret;
> -}
> -
> Removing this from the header file breaks builds without
> CONFIG_TRACING.
> Example:
>     % make allnoconfig && make -j4 mm/
>     [...]
>     include/linux/slab.h: In function ‘kmalloc_order_trace’:
>     include/linux/slab.h:367:2: error: implicit declaration of function ‘kmalloc_order’ [-Werror=implicit-function-declaration]

Oh, my bad - forgot to add the function declaration :-(

The fixed version is on its way. Thank you for catching this!

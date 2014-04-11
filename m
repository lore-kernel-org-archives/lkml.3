Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbaDKQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:09:26 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:44697 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759445AbaDKQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:51 -0400
Date: Fri, 11 Apr 2014 11:07:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, devel@openvz.org, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@gmail.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH -mm v2.2] mm: get rid of __GFP_KMEMCG
In-Reply-To: <1396537559-17453-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1404111104550.13278@nuc>
References: <1396419365-351-1-git-send-email-vdavydov@parallels.com> <1396537559-17453-1-git-send-email-vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014, Vladimir Davydov wrote:

> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -358,16 +358,7 @@ kmem_cache_alloc_node_trace(struct kmem_cache *s,
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
> +extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order);


Hmmm... This was intentional inlined to allow inline expansion for calls
to kmalloc with large constants. The inline expansion directly converts
these calls to page allocator calls avoiding slab overhead.


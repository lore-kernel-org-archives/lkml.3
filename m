Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaDRNpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:45:03 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59165 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaDRNo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:44:59 -0400
Date: Fri, 18 Apr 2014 09:44:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: mhocko@suse.cz, akpm@linux-foundation.org, glommer@gmail.com,
        cl@linux-foundation.org, penberg@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org
Subject: Re: [PATCH RFC -mm v2 2/3] memcg, slab: merge
 memcg_{bind,release}_pages to memcg_{un}charge_slab
Message-ID: <20140418134453.GC26283@cmpxchg.org>
References: <cover.1397804745.git.vdavydov@parallels.com>
 <49f7f2d048e56fac4d29dd5b39f6f76c7bdd6bec.1397804745.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49f7f2d048e56fac4d29dd5b39f6f76c7bdd6bec.1397804745.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 12:04:48PM +0400, Vladimir Davydov wrote:
> Currently we have two pairs of kmemcg-related functions that are called
> on slab alloc/free. The first is memcg_{bind,release}_pages that count
> the total number of pages allocated on a kmem cache. The second is
> memcg_{un}charge_slab that {un}charge slab pages to kmemcg resource
> counter. Let's just merge them to keep the code clean.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  include/linux/memcontrol.h |    4 ++--
>  mm/memcontrol.c            |   22 ++++++++++++++++++++--
>  mm/slab.c                  |    2 --
>  mm/slab.h                  |   25 ++-----------------------
>  mm/slub.c                  |    2 --
>  5 files changed, 24 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 087a45314181..d38d190f4cec 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -506,8 +506,8 @@ void memcg_update_array_size(int num_groups);
>  struct kmem_cache *
>  __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
>  
> -int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size);
> -void memcg_uncharge_kmem(struct mem_cgroup *memcg, u64 size);
> +int __memcg_charge_slab(struct kmem_cache *cachep, gfp_t gfp, int order);
> +void __memcg_uncharge_slab(struct kmem_cache *cachep, int order);

I like the patch overall, but why the __prefix and not just
memcg_charge_slab() and memcg_uncharge_slab()?

Not a show stopper, though:
Acked-by: Johannes Weiner <hannes@cmpxchg.org>

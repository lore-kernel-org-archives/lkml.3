Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaIVULm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:11:42 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:48288 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbaIVULl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:11:41 -0400
Date: Mon, 22 Sep 2014 16:11:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] memcg: move memcg_update_cache_size to slab_common.c
Message-ID: <20140922201137.GB5373@cmpxchg.org>
References: <e768785511927d65bd3e6d9f65ab2a9851a3d73d.1411054735.git.vdavydov@parallels.com>
 <0689062e28e13375241dcc64df2a398c9d606c64.1411054735.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0689062e28e13375241dcc64df2a398c9d606c64.1411054735.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 07:50:20PM +0400, Vladimir Davydov wrote:
> The only reason why this function lives in memcontrol.c is that it
> depends on memcg_caches_array_size. However, we can pass the new array
> size immediately to it instead of new_id+1 so that it will be free of
> any memcontrol.c dependencies.
> 
> So let's move this function to slab_common.c and make it static.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Christoph Lameter <cl@linux.com>

Looks good.  One nit below, but not a show stopper.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> @@ -646,11 +646,13 @@ int memcg_limited_groups_array_size;
>  struct static_key memcg_kmem_enabled_key;
>  EXPORT_SYMBOL(memcg_kmem_enabled_key);
>  
> +static void memcg_free_cache_id(int id);

Any chance you could re-order this code to avoid the forward decl?
memcg_alloc_cache_id() and memcg_free_cache_id() are new functions
anyway, might as well put the definition above the callsites.

Thanks!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaEGMph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:45:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaEGMpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:45:35 -0400
Date: Wed, 7 May 2014 14:45:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 2/2] memcg: cleanup kmem cache creation/destruction
 functions naming
Message-ID: <20140507124533.GF9489@dhcp22.suse.cz>
References: <a4aa62026c10fc709e8bf13542b29cf771381394.1399450112.git.vdavydov@parallels.com>
 <c3bef5d3667668f89a4acabda64eb79d730037ec.1399450112.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3bef5d3667668f89a4acabda64eb79d730037ec.1399450112.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-05-14 12:15:30, Vladimir Davydov wrote:
> Current names are rather inconsistent. Let's try to improve them.

Yes the old names are a giant mess. I am not sure the new ones are
that much better however.
 
> Brief change log:
> 
> ** old name **                          ** new name **
> 
> kmem_cache_create_memcg                 kmem_cache_request_memcg_copy

Both are bad because the first suggests we are creating memcg and the second that
we are requesting a copy of memcg.

memcg_alloc_kmem_cache?

_copy suffix is a bit confusing. E.g. copy_mm and others either to
shallow or deep copy depending on the context. This one always creats a
deep copy. Also why it is imporatant to treat the created caches as
copies?

> memcg_kmem_create_cache                 memcg_copy_kmem_cache

memcg_register_kmem_cache? It also allocates so this name is a bit
awkward as well.

> memcg_kmem_destroy_cache                memcg_destroy_kmem_cache_copy

memcg_unregister_kmem_cache to match the above?

> __kmem_cache_destroy_memcg_children     __kmem_cache_destroy_memcg_copies
> kmem_cache_destroy_memcg_children       kmem_cache_destroy_memcg_copies

_children suffix is really confusing because they have different meaning in
memcg and refer to children groups.

memcg_cleanup_kmem_chache_memcg_params? It doesn't have to live in the
kmem_cache namespace because it only does only memcg kmem specific
stuff.

> mem_cgroup_destroy_all_caches           memcg_destroy_kmem_cache_copies
> 
> create_work                             memcg_kmem_cache_copy_work

memcg_register_cache_work?

> memcg_create_cache_work_func            memcg_kmem_cache_copy_work_func

memcg_register_cache_func?

> memcg_create_cache_enqueue              memcg_schedule_kmem_cache_copy

memcg_schedule_register_cache?

-- 
Michal Hocko
SUSE Labs

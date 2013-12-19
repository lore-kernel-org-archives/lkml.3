Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3LSJDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:03:33 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:26418 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab3LSJD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:03:29 -0500
X-Greylist: delayed 2760 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 04:03:28 EST
Message-ID: <52B2AB7C.1010803@parallels.com>
Date: Thu, 19 Dec 2013 12:17:00 +0400
From: Vasily Averin <vvs@parallels.com>
Organization: Parallels
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@gmail.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        cgroups@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org
Subject: Re: [Devel] [PATCH 1/6] slab: cleanup kmem_cache_create_memcg()
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
In-Reply-To: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 05:16 PM, Vladimir Davydov wrote:
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -176,8 +176,9 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
>  	get_online_cpus();
>  	mutex_lock(&slab_mutex);
>  
> -	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
> -		goto out_locked;
> +	err = kmem_cache_sanity_check(memcg, name, size);
> +	if (err)
> +		goto out_unlock;
>  
>  	/*
>  	 * Some allocators will constraint the set of valid flags to a subset

Theoretically in future kmem_cache_sanity_check() can return positive value.
Probably it's better to check (err < 0) in caller ?

Thank you,
	Vasily Averin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaFYG6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:58:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbaFYG6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:58:47 -0400
Date: Wed, 25 Jun 2014 08:58:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 3/3] page-cgroup: fix flags definition
Message-ID: <20140625065844.GC10223@dhcp22.suse.cz>
References: <9f5abf8dcb07fe5462f12f81867f199c22e883d3.1403626729.git.vdavydov@parallels.com>
 <aacc50fb60eeb9cbe14e07235310fb9295b2658b.1403626729.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacc50fb60eeb9cbe14e07235310fb9295b2658b.1403626729.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-06-14 20:33:06, Vladimir Davydov wrote:
> Since commit a9ce315aaec1f ("mm: memcontrol: rewrite uncharge API"),

I guess the sha comes from linux-next. Andrew will probably just fold
this into mm-memcontrol-rewrite-uncharge-api.patch but the sha should be
removed otherwise.

> PCG_* flags are used as bit masks, but they are still defined in a enum
> as bit numbers. Fix it.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/page_cgroup.h |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index fb60e4a466c0..9065a61345a1 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -1,12 +1,10 @@
>  #ifndef __LINUX_PAGE_CGROUP_H
>  #define __LINUX_PAGE_CGROUP_H
>  
> -enum {
> -	/* flags for mem_cgroup */
> -	PCG_USED,	/* This page is charged to a memcg */
> -	PCG_MEM,	/* This page holds a memory charge */
> -	PCG_MEMSW,	/* This page holds a memory+swap charge */
> -};
> +/* flags for mem_cgroup */
> +#define PCG_USED	0x01	/* This page is charged to a memcg */
> +#define PCG_MEM		0x02	/* This page holds a memory charge */
> +#define PCG_MEMSW	0x04	/* This page holds a memory+swap charge */
>  
>  struct pglist_data;
>  
> @@ -44,7 +42,7 @@ struct page *lookup_cgroup_page(struct page_cgroup *pc);
>  
>  static inline int PageCgroupUsed(struct page_cgroup *pc)
>  {
> -	return test_bit(PCG_USED, &pc->flags);
> +	return !!(pc->flags & PCG_USED);
>  }
>  #else /* !CONFIG_MEMCG */
>  struct page_cgroup;
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs

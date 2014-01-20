Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaATQsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:48:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaATQsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:48:03 -0500
Date: Mon, 20 Jan 2014 17:48:01 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH TRIVIAL] memcg: remove unused code from
 kmem_cache_destroy_work_func
Message-ID: <20140120164801.GF2626@dhcp22.suse.cz>
References: <1390209723-11869-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390209723-11869-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, it seems as a left over from an earlier code reworks but
22933152934f3 doesn't seem to contain any code following that if-else
so maybe review driven changes.

On Mon 20-01-14 13:22:03, Vladimir Davydov wrote:
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7f1a356..7f1511d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3311,11 +3311,9 @@ static void kmem_cache_destroy_work_func(struct work_struct *w)
>  	 * So if we aren't down to zero, we'll just schedule a worker and try
>  	 * again
>  	 */
> -	if (atomic_read(&cachep->memcg_params->nr_pages) != 0) {
> +	if (atomic_read(&cachep->memcg_params->nr_pages) != 0)
>  		kmem_cache_shrink(cachep);
> -		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
> -			return;
> -	} else
> +	else
>  		kmem_cache_destroy(cachep);
>  }
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBJIXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:23:41 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59324 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaBJIXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:23:33 -0500
Date: Mon, 10 Feb 2014 09:23:24 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, linux-mm@kva.suse.de
Subject: Re: [PATCH 7/9] mm: Mark functions as static in page_cgroup.c
Message-ID: <20140210082324.GA3204@dhcp22.suse.cz>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
 <6054d570fc83c3d4f3de240d6da488f876e21450.1391167128.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6054d570fc83c3d4f3de240d6da488f876e21450.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-02-14 17:41:34, Rashika Kheria wrote:
> Mark functions as static in page_cgroup.c because they are not used
> outside this file.
> 
> This eliminates the following warning in mm/page_cgroup.c:
> mm/page_cgroup.c:177:6: warning: no previous prototype for ‘__free_page_cgroup’ [-Wmissing-prototypes]
> mm/page_cgroup.c:190:15: warning: no previous prototype for ‘online_page_cgroup’ [-Wmissing-prototypes]
> mm/page_cgroup.c:225:15: warning: no previous prototype for ‘offline_page_cgroup’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/page_cgroup.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 6d757e3a..6ec349c 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -174,7 +174,7 @@ static void free_page_cgroup(void *addr)
>  	}
>  }
>  
> -void __free_page_cgroup(unsigned long pfn)
> +static void __free_page_cgroup(unsigned long pfn)
>  {
>  	struct mem_section *ms;
>  	struct page_cgroup *base;
> @@ -187,9 +187,9 @@ void __free_page_cgroup(unsigned long pfn)
>  	ms->page_cgroup = NULL;
>  }
>  
> -int __meminit online_page_cgroup(unsigned long start_pfn,
> -			unsigned long nr_pages,
> -			int nid)
> +static int __meminit online_page_cgroup(unsigned long start_pfn,
> +				unsigned long nr_pages,
> +				int nid)
>  {
>  	unsigned long start, end, pfn;
>  	int fail = 0;
> @@ -222,8 +222,8 @@ int __meminit online_page_cgroup(unsigned long start_pfn,
>  	return -ENOMEM;
>  }
>  
> -int __meminit offline_page_cgroup(unsigned long start_pfn,
> -		unsigned long nr_pages, int nid)
> +static int __meminit offline_page_cgroup(unsigned long start_pfn,
> +				unsigned long nr_pages, int nid)
>  {
>  	unsigned long start, end, pfn;
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Michal Hocko
SUSE Labs

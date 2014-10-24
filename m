Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbaJXS3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:29:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46765 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbaJXS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:29:14 -0400
Date: Fri, 24 Oct 2014 20:29:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: memcontrol: remove bogus NULL check after
 mem_cgroup_from_task()
Message-ID: <20141024182911.GA18956@dhcp22.suse.cz>
References: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 24-10-14 09:49:47, Johannes Weiner wrote:
> That function acts like a typecast - unless NULL is passed in, no NULL
> can come out.  task_in_mem_cgroup() callers don't pass NULL tasks.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks and sorry about my bogus version earlier today.

Acked-by: Michal Hocko <mhocko@suse.cz

> ---
>  mm/memcontrol.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 23cf27cca370..bdf8520979cf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1335,7 +1335,7 @@ static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  bool task_in_mem_cgroup(struct task_struct *task,
>  			const struct mem_cgroup *memcg)
>  {
> -	struct mem_cgroup *curr = NULL;
> +	struct mem_cgroup *curr;
>  	struct task_struct *p;
>  	bool ret;
>  
> @@ -1351,8 +1351,7 @@ bool task_in_mem_cgroup(struct task_struct *task,
>  		 */
>  		rcu_read_lock();
>  		curr = mem_cgroup_from_task(task);
> -		if (curr)
> -			css_get(&curr->css);
> +		css_get(&curr->css);
>  		rcu_read_unlock();
>  	}
>  	/*
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs

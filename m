Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbaJXOlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:41:45 -0400
Received: from mx2.parallels.com ([199.115.105.18]:35687 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaJXOlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:41:10 -0400
Date: Fri, 24 Oct 2014 18:41:01 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] mm: memcontrol: remove bogus NULL check after
 mem_cgroup_from_task()
Message-ID: <20141024144101.GA28055@esperanza>
References: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:49:47AM -0400, Johannes Weiner wrote:
> That function acts like a typecast - unless NULL is passed in, no NULL
> can come out.  task_in_mem_cgroup() callers don't pass NULL tasks.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaBJO3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:29:15 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41844 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaBJO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:29:14 -0500
Date: Mon, 10 Feb 2014 15:29:11 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/8] memcg: remove unnecessary !mm check from
 try_get_mem_cgroup_from_mm()
Message-ID: <20140210142911.GJ7117@dhcp22.suse.cz>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
 <1391792665-21678-6-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391792665-21678-6-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-02-14 12:04:22, Johannes Weiner wrote:
> Users pass either a mm that has been established under task lock, or
> use a verified current->mm, which means the task can't be exiting.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e1d7f33227e4..689fffdee471 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1075,13 +1075,6 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
>  {
>  	struct mem_cgroup *memcg = NULL;
>  
> -	if (!mm)
> -		return NULL;
> -	/*
> -	 * Because we have no locks, mm->owner's may be being moved to other
> -	 * cgroup. We use css_tryget() here even if this looks
> -	 * pessimistic (rather than adding locks here).
> -	 */
>  	rcu_read_lock();
>  	do {
>  		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
> -- 
> 1.8.5.3
> 

-- 
Michal Hocko
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaE1HoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:44:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbaE1HoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:44:12 -0400
Date: Wed, 28 May 2014 09:44:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next] memcg-mm-introduce-lowlimit-reclaim-fix2.patch
Message-ID: <20140528074409.GA9895@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-05-14 14:36:04, Hugh Dickins wrote:
> mem_cgroup_within_guarantee() oopses in _raw_spin_lock_irqsave() when
> booted with cgroup_disable=memory.  Fix that in the obvious inelegant
> way for now - though I hope we are moving towards a world in which
> almost all of the mem_cgroup_disabled() tests will vanish, with a
> root_mem_cgroup which can handle the basics even when disabled.
> 
> I bet there's a neater way of doing this, rearranging the loop (and we
> shall want to avoid spinlocking on root_mem_cgroup when we reach that
> new world), but that's the kind of thing I'd get wrong in a hurry!
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
> 
>  mm/memcontrol.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- mmotm/mm/memcontrol.c	2014-05-21 18:12:18.072022438 -0700
> +++ linux/mm/memcontrol.c	2014-05-21 19:34:30.608546905 -0700
> @@ -2793,6 +2793,9 @@ static struct mem_cgroup *mem_cgroup_loo
>  bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
>  		struct mem_cgroup *root)
>  {
> +	if (mem_cgroup_disabled())
> +		return false;
> +
>  	do {
>  		if (!res_counter_low_limit_excess(&memcg->res))
>  			return true;

-- 
Michal Hocko
SUSE Labs

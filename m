Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaEWOSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:18:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaEWOSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:18:22 -0400
Date: Fri, 23 May 2014 16:18:20 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 8/9] mm: memcontrol: rewrite charge API
Message-ID: <20140523141820.GE22135@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-9-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398889543-23671-9-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 16:25:42, Johannes Weiner wrote:
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d3961fce1d54..6f48e292ffe7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2574,163 +2574,6 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -/**
> - * mem_cgroup_try_charge - try charging a memcg
> - * @memcg: memcg to charge
> - * @nr_pages: number of pages to charge
> - * @oom: trigger OOM if reclaim fails
> - *
> - * Returns 0 if @memcg was charged successfully, -EINTR if the charge
> - * was bypassed to root_mem_cgroup, and -ENOMEM if the charge failed.
> - */
> -static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
> -				 gfp_t gfp_mask,
> -				 unsigned int nr_pages,
> -				 bool oom)

Why haven't you simply renamed mem_cgroup_try_charge to try_charge here?
The code move is really hard to review.
[...]
-- 
Michal Hocko
SUSE Labs

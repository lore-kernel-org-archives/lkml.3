Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaE1Hoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:44:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbaE1Hoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:44:37 -0400
Date: Wed, 28 May 2014 09:44:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next]
 vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-o
 om-control-fix.patch
Message-ID: <20140528074436.GB9895@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1405271432400.4485@eggly.anvils>
 <alpine.LSU.2.11.1405271436200.4485@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405271436200.4485@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-05-14 14:38:40, Hugh Dickins wrote:
> mem_cgroup_swappiness() oopses immediately when
> booted with cgroup_disable=memory.  Fix that in the obvious inelegant
> way for now - though I hope we are moving towards a world in which
> almost all of the mem_cgroup_disabled() tests will vanish, with a
> root_mem_cgroup which can handle the basics even when disabled.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
> 
>  mm/memcontrol.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- mmotm/mm/memcontrol.c	2014-05-21 18:12:18.072022438 -0700
> +++ linux/mm/memcontrol.c	2014-05-21 19:34:30.608546905 -0700
> @@ -1531,7 +1531,7 @@ static unsigned long mem_cgroup_margin(s
>  int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>  {
>  	/* root ? */
> -	if (!memcg->css.parent)
> +	if (mem_cgroup_disabled() || !memcg->css.parent)
>  		return vm_swappiness;
>  
>  	return memcg->swappiness;

-- 
Michal Hocko
SUSE Labs

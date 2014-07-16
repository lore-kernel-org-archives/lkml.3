Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbaGPIyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:54:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758429AbaGPIyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:54:05 -0400
Date: Wed, 16 Jul 2014 10:54:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20140716085402.GD7121@dhcp22.suse.cz>
References: <20140716182641.5c27a6be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716182641.5c27a6be@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-07-14 18:26:41, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> mm/memcontrol.c:5269:12: error: 'CFTYPE_INSANE' undeclared here (not in a function)
>    .flags = CFTYPE_INSANE,
>             ^
> 
> Caused by commit 8fa6a8baeffc ("memcg: deprecate memory.force_empty
> knob") interacting with commits a8ddc8215e1a ("cgroup: distinguish the
> default and legacy hierarchies when handling cftypes") and 05ebb6e60f04
> ("cgroup: make CFTYPE_ONLY_ON_DFL and CFTYPE_NO_ internal to cgroup
> core") from the cgroup tree.
>
> I applied the following fix up patch:

This basically means dropping the page from Andrew's tree after the
above cgroups changes. I am sorry but I was really busy last few weeks
so I didn't follow cgroups changes closely. I will post a patch that
deals with the dfl hierarchy.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 16 Jul 2014 18:20:59 +1000
> Subject: [PATCH] memcg-deprecate-memoryforce_empty-knob-fix2
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/memcontrol.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8fa6602a32cd..e1c9699b157b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5266,7 +5266,6 @@ static struct cftype mem_cgroup_files[] = {
>  	},
>  	{
>  		.name = "force_empty",
> -		.flags = CFTYPE_INSANE,
>  		.write = mem_cgroup_force_empty_write,
>  	},
>  	{
> -- 
> 2.0.1
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Michal Hocko
SUSE Labs

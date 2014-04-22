Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaDVNeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:34:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbaDVNeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:34:14 -0400
Date: Tue, 22 Apr 2014 15:34:10 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memcg: kill start_kernel()->mm_init_owner(init_mm)
Message-ID: <20140422133410.GP29311@dhcp22.suse.cz>
References: <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com>
 <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
 <20140416135741.GA9407@redhat.com>
 <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
 <20140418162359.GA4398@redhat.com>
 <20140418172631.GA13323@redhat.com>
 <20140418182444.GB22235@dhcp22.suse.cz>
 <20140418184441.GA26046@redhat.com>
 <20140418191259.GA7413@redhat.com>
 <20140418191322.GB7413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418191322.GB7413@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-04-14 21:13:22, Oleg Nesterov wrote:
> Remove start_kernel()->mm_init_owner(&init_mm, &init_task).
> 
> This doesn't really hurt but unnecessary and misleading. init_task
> is the "swapper" thread == current, its ->mm is always NULL. And
> init_mm can only be used as ->active_mm, not as ->mm.

OK, this should work because mem_cgroup_from_task can handle NULL
task so even if somebody provided init_mm it will work properly.

But to be honest, I have no idea why mm_init_owner was called here.

> mm_init_owner() has a single caller with this patch, perhaps it
> should die. mm_init() can initialize ->owner under #ifdef.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  init/main.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 3815895..17090bb 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -507,7 +507,6 @@ asmlinkage void __init start_kernel(void)
>  	page_address_init();
>  	pr_notice("%s", linux_banner);
>  	setup_arch(&command_line);
> -	mm_init_owner(&init_mm, &init_task);
>  	mm_init_cpumask(&init_mm);
>  	setup_command_line(command_line);
>  	setup_nr_cpu_ids();
> -- 
> 1.5.5.1
> 
> 

-- 
Michal Hocko
SUSE Labs

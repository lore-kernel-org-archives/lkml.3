Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaATNNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:13:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaATNNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:13:40 -0500
Date: Mon, 20 Jan 2014 14:13:37 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Aristeu Rozanski <aris@redhat.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vivek Goyal <vgoyal@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/6] cgroup: clean up cgroup_subsys names and
 initialization
Message-ID: <20140120131337.GD2626@dhcp22.suse.cz>
References: <1389982317-22225-1-git-send-email-tj@kernel.org>
 <1389982317-22225-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389982317-22225-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-01-14 13:11:54, Tejun Heo wrote:
> cgroup_subsys is a bit messier than it needs to be.
> 
> * The name of a subsys can be different from its internal identifier
>   defined in cgroup_subsys.h.  Most subsystems use the matching name
>   but three - cpu, memory and perf_event - use different ones.
> 
> * cgroup_subsys_id enums are postfixed with _subsys_id and each
>   cgroup_subsys is postfixed with _subsys.  cgroup.h is widely
>   included throughout various subsystems, it doesn't and shouldn't
>   have claim on such generic names which don't have any qualifier
>   indicating that they belong to cgroup.
> 
> * cgroup_subsys->subsys_id should always equal the matching
>   cgroup_subsys_id enum; however, we require each controller to
>   initialize it and then BUG if they don't match, which is a bit
>   silly.
> 
> This patch cleans up cgroup_subsys names and initialization by doing
> the followings.
> 
> * cgroup_subsys_id enums are now postfixed with _cgrp_id, and each
>   cgroup_subsys with _cgrp_subsys.
> 
> * With the above, renaming subsys identifiers to match the userland
>   visible names doesn't cause any naming conflicts.  All non-matching
>   identifiers are renamed to match the official names.
> 
>   cpu_cgroup -> cpu
>   mem_cgroup -> memory
>   perf -> perf_event
> 
> * controllers no longer need to initialize ->subsys_id and ->name.
>   They're generated in cgroup core and set automatically during boot.
> 
> * Redundant cgroup_subsys declarations removed.
> 
> * While updating BUG_ON()s in cgroup_init_early(), convert them to
>   WARN()s.  BUGging that early during boot is stupid - the kernel
>   can't print anything, even through serial console and the trap
>   handler doesn't even link stack frame properly for back-tracing.
> 
> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: "David S. Miller" <davem@davemloft.net>

For memcg and hugetlb
Acked-by: Michal Hocko <mhocko@suse.cz>

[...]

Thanks!
-- 
Michal Hocko
SUSE Labs

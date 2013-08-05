Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3HESLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab3HESLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:11:06 -0400
Date: Mon, 5 Aug 2013 14:10:49 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Matt Helsley <matthltc@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 15/23] cgroup: make hierarchy iterators deal with
 cgroup_subsys_state instead of cgroup
Message-ID: <20130805181049.GC7878@redhat.com>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-16-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375393801-4817-16-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 05:49:53PM -0400, Tejun Heo wrote:
> cgroup is currently in the process of transitioning to using css
> (cgroup_subsys_state) as the primary handle instead of cgroup in
> subsystem API.  For hierarchy iterators, this is beneficial because
> 
> * In most cases, css is the only thing subsystems care about anyway.
> 
> * On the planned unified hierarchy, iterations for different
>   subsystems will need to skip over different subtrees of the
>   hierarchy depending on which subsystems are enabled on each cgroup.
>   Passing around css makes it unnecessary to explicitly specify the
>   subsystem in question as css is intersection between cgroup and
>   subsystem
> 
> * For the planned unified hierarchy, css's would need to be created
>   and destroyed dynamically independent from cgroup hierarchy.  Having
>   cgroup core manage css iteration makes enforcing deref rules a lot
>   easier.
> 
> Most subsystem conversions are straight-forward.  Noteworthy changes
> are
> 
> * blkio: cgroup_to_blkcg() is no longer used.  Removed.
> 
> * freezer: cgroup_freezer() is no longer used.  Removed.
> 
> * devices: cgroup_to_devcgroup() is no longer used.  Removed.

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu


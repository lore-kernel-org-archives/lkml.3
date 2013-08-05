Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3HES5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab3HES5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:57:41 -0400
Date: Mon, 5 Aug 2013 14:57:23 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH cgroup/for-3.12] cgroup: make css_for_each_descendant()
 and friends include the origin css in the iteration
Message-ID: <20130805185723.GD7878@redhat.com>
References: <20130804230703.GA12029@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130804230703.GA12029@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 07:07:03PM -0400, Tejun Heo wrote:
> I've been wanting to do this for some time and given all the recent
> API updates now seems like a pretty good opportunity.  Verified
> freezer and blkcg.  The conversions are mostly straight forward but
> I'd much appreciate acks from controller maintainers.
> 
> The patch is on top of
> 
>   cgroup/for-3.12 61584e3f4 ("cgroup: Merge branch 'for-3.11-fixes' into for-3.12")
> + [1] cgroup: use cgroup_subsys_state as the primary subsystem interface handle
> + [2] cgroup: make cgroup_event specific to memcg
> 
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-descendant-update
> 
> Thanks.
> 
> [1] https://lkml.org/lkml/2013/8/1/722
> [2] http://thread.gmane.org/gmane.linux.kernel.cgroups/8726
> 
> ------- 8< -------
> 
> From 0e84b0865ab8a87f1c1443e4777c20c7f14e13b6 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Sun, 4 Aug 2013 19:01:23 -0400
> 
> Previously, all css descendant iterators didn't include the origin
> (root of subtree) css in the iteration.  The reasons were maintaining
> consistency with css_for_each_child() and that at the time of
> introduction more use cases needed skipping the origin anyway;
> however, given that css_is_descendant() considers self to be a
> descendant, omitting the origin css has become more confusing and
> looking at the accumulated use cases rather clearly indicates that
> including origin would result in simpler code overall.
> 
> While this is a change which can easily lead to subtle bugs, cgroup
> API including the iterators has recently gone through major
> restructuring and no out-of-tree changes will be applicable without
> adjustments making this a relatively acceptable opportunity for this
> type of change.
> 
> The conversions are mostly straight-forward.  If the iteration block
> had explicit origin handling before or after, it's moved inside the
> iteration.  If not, if (pos == origin) continue; is added.  Some
> conversions add extra reference get/put around origin handling by
> consolidating origin handling and the rest.  While the extra ref
> operations aren't strictly necessary, this shouldn't cause any
> noticeable difference.

Looks good. Thanks for the heads up, saved some hours of head scratching
:)

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu


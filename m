Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3HEOVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3HEOVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:21:15 -0400
Date: Mon, 5 Aug 2013 10:19:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 12/23] cgroup: pass around cgroup_subsys_state instead of
 cgroup in file methods
Message-ID: <20130805141955.GC2274@redhat.com>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375393801-4817-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 05:49:50PM -0400, Tejun Heo wrote:
> cgroup is currently in the process of transitioning to using struct
> cgroup_subsys_state * as the primary handle instead of struct cgroup.
> Please see the previous commit which converts the subsystem methods
> for rationale.
> 
> This patch converts all cftype file operations to take @css instead of
> @cgroup.  cftypes for the cgroup core files don't have their subsytem
> pointer set.  These will automatically use the dummy_css added by the
> previous patch and can be converted the same way.
> 
> Most subsystem conversions are straight forwards but there are some
> interesting ones.
> 
> * freezer: update_if_frozen() is also converted to take @css instead
>   of @cgroup for consistency.  This will make the code look simpler
>   too once iterators are converted to use css.
> 
> * memory/vmpressure: mem_cgroup_from_css() needs to be exported to
>   vmpressure while mem_cgroup_from_cont() can be made static.
>   Updated accordingly.
> 
> * cpu: cgroup_tg() doesn't have any user left.  Removed.
> 
> * cpuacct: cgroup_ca() doesn't have any user left.  Removed.
> 
> * hugetlb: hugetlb_cgroup_form_cgroup() doesn't have any user left.
>   Removed.
> 
> * net_cls: cgrp_cls_state() doesn't have any user left.  Removed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Matt Helsley <matthltc@us.ibm.com>
> Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  block/blk-cgroup.c         |   6 +-
>  block/blk-throttle.c       |  32 ++++-----
>  block/cfq-iosched.c        |  90 ++++++++++++-------------

blk-cgroup.c, blk-throttle.c and cfq-iosched.c bits look good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

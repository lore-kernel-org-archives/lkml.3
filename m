Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaA2Kr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:47:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47201 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaA2KrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:47:23 -0500
Date: Wed, 29 Jan 2014 11:47:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
Message-ID: <20140129104712.GD9636@twins.programming.kicks-ass.net>
References: <1390953585-16554-1-git-send-email-tj@kernel.org>
 <1390953585-16554-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390953585-16554-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:59:43PM -0500, Tejun Heo wrote:
> cgroup->name handling became quite complicated over time involving
> dedicated struct cgroup_name for RCU protection.  Now that cgroup is
> on kernfs, we can drop all of it and simply use kernfs_name/path() and
> friends.  Replace cgroup->name and all related code with kernfs
> name/path constructs.
> 
> * Reimplement cgroup_name() and cgroup_path() as thin wrappers on top
>   of kernfs counterparts, which involves semantic changes.
>   pr_cont_cgroup_name() and pr_cont_cgroup_path() added.
> 
> * cgroup->name handling dropped from cgroup_rename().
> 
> * All users of cgroup_name/path() updated to the new semantics.  Users
>   which were formatting the string just to printk them are converted
>   to use pr_cont_cgroup_name/path() instead, which simplifies things
>   quite a bit.  As cgroup_name() no longer requires RCU read lock
>   around it, RCU lockings which were protecting only cgroup_name() are
>   removed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Peter Zijlstra <peterz@infradead.org>


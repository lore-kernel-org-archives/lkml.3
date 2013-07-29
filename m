Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab3G2Sbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:31:46 -0400
Received: from mail-ye0-f177.google.com ([209.85.213.177]:41449 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3G2Sbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:31:45 -0400
Date: Mon, 29 Jul 2013 14:31:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 3/8] cgroup: implement cgroup_from_id()
Message-ID: <20130729183139.GE26076@mtj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614DF.9010508@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F614DF.9010508@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 03:08:15PM +0800, Li Zefan wrote:
> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
> +{
> +	rcu_lockdep_assert(rcu_read_lock_held(),
> +			   "cgroup_from_id() needs rcu_read_lock()"
> +			   " protection");

Maybe we want to add notation for &cgroup_mutex for completeness?

> +	return idr_find(&ss->root->cgroup_idr, id);
> +}

And maybe inline it?

Thanks.

-- 
tejun

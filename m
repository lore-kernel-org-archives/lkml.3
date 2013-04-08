Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936503Ab3DHPn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:43:27 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53177 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936279Ab3DHPn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:43:26 -0400
Date: Mon, 8 Apr 2013 08:43:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/8] cgroup: implement cgroup_from_id()
Message-ID: <20130408154319.GD3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627DEB.4090104@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627DEB.4090104@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:20:59PM +0800, Li Zefan wrote:
> +/**
> + * cgroup_from_id - lookup cgroup by id
> + * @ss: cgroup subsys to be looked into.
> + * @id: the id
> + *
> + * Returns pointer to cgroup if there is valid one with id.
> + * NULL if not. Should be called under rcu_read_lock()
> + */
> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
> +{

	rcu_lockdep_assert(rcu_read_lock_held(), ...);

> +	return idr_find(&ss->root->cgroup_idr, id);

Thanks.

-- 
tejun

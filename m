Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965201Ab3DHPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:39:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46595 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab3DHPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:39:47 -0400
Date: Mon, 8 Apr 2013 08:39:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
Message-ID: <20130408153942.GC3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627DBB.5050005@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51627DBB.5050005@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Mon, Apr 08, 2013 at 04:20:11PM +0800, Li Zefan wrote:
> +/**
> + * cgroup_is_ancestor - test "root" cgroup is an ancestor of "child"
> + * @child: the cgroup to be tested.
> + * @root: the cgroup supposed to be an ancestor of the child.

Please explain locking in the comment.  (I know it only requires both
cgroups to be accessible but being explicit is nice.)

> + * Returns true if "root" is an ancestor of "child" in its hierarchy.
> + */
> +bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root)

s/root/ancestor/

> +{
> +	int depth = child->depth;
> +
> +	if (depth < root->depth)
> +		return false;
> +
> +	while (depth-- != root->depth)
> +		child = child->parent;

Just walk up till it meets the ancestor or reaches root.  Why bother
with depth?

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab3BZC1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:27:11 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:36902 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3BZC1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:27:08 -0500
Date: Mon, 25 Feb 2013 18:27:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Message-ID: <20130226022703.GA13837@htj.dyndns.org>
References: <512B01FA.5020506@huawei.com>
 <512B020D.9040504@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512B020D.9040504@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 02:17:49PM +0800, Li Zefan wrote:
> cgroup_name() returns the name of a cgroup and it must be called with
> rcu_read_lock() held.
> 
> This will be used by cpuset.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
...
>  /**
> + * cgroup_name - get the name of a cgroup
> + * @cgrp: the cgroup in question
> + *
> + * Must be called with rcu_read_lock() held.
> + */
> +char *cgroup_name(const struct cgroup *cgrp)
> +{
> +	if (!cgrp->parent)
> +		return "/";
> +	else
> +		return rcu_dereference(cgrp->name)->name;
> +}

Can't we initialize ->name of root cgroup to "/" and lose the
conditional?  We can lose the wrapper altogether but if you're worried
that sparse check isn't enough, we can have trivial inline wrapper,
but in that case it probably would help to rename cgrp->name to, say,
cgrp->__name and put a comment directing people to the accessing
wrapper which should probably return const char *.

Thanks.

-- 
tejun

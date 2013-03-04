Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab3CDRui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:50:38 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33209 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab3CDRug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:50:36 -0500
Date: Mon, 4 Mar 2013 09:50:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] cgroup: fix cgroup_path() vs rename() race
Message-ID: <20130304175032.GD30413@htj.dyndns.org>
References: <51305264.2080602@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51305264.2080602@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 03:01:56PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> As accessing dentry->name must be protected by dentry->d_lock or
> parent inode's i_mutex, while on the other hand cgroup-path() can
> be called with some irq-safe spinlocks held, we can't generate
> cgroup path using dentry->d_name.
> 
> Alternatively we make a copy of dentry->d_name and save it in
> cgrp->name when a cgroup is created, and update cgrp->name at
> rename().
> 
> v5: use flexible array instead of zero-size array.
> v4: - allocate root_cgroup_name and all root_cgroup->name points to it.
>     - add cgroup_name() wrapper.
> v3: use kfree_rcu() instead of synchronize_rcu() in user-visible path.
> v2: make cgrp->name RCU safe.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.10.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaBRXVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:21:05 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:50945 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaBRXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:21:00 -0500
Date: Tue, 18 Feb 2014 18:20:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: add a validation check to cgroup_add_cftyps()
Message-ID: <20140218232056.GL31892@mtj.dyndns.org>
References: <530176EE.6030605@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530176EE.6030605@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:41:50AM +0800, Li Zefan wrote:
> Fengguang reported this bug:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000003c
> IP: [<cc90b4ad>] cgroup_cfts_commit+0x27/0x1c1
> ...
> Call Trace:
>   [<cc9d1129>] ? kmem_cache_alloc_trace+0x33f/0x3b7
>   [<cc90c6fc>] cgroup_add_cftypes+0x8f/0xca
>   [<cd78b646>] cgroup_init+0x6a/0x26a
>   [<cd764d7d>] start_kernel+0x4d7/0x57a
>   [<cd7642ef>] i386_start_kernel+0x92/0x96
> 
> This happens in a corner case. If CGROUP_SCHED=y but CFS_BANDWIDTH=n &&
> FAIR_GROUP_SCHED=n && RT_GROUP_SCHED=n, we have:
> 
> cpu_files[] = {
> 	{ }	/* terminate */
> }
> 
> When we pass cpu_files to cgroup_apply_cftypes(), as cpu_files[0].ss
> is NULL, we'll access NULL pointer.
> 
> The bug was introduced by commit de00ffa56ea3132c6013fc8f07133b8a1014cf53
> ("cgroup: make cgroup_subsys->base_cftypes use cgroup_add_cftypes()").
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.15.  Thanks.

-- 
tejun

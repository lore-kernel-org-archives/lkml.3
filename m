Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3D0OXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 10:23:31 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42510 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3D0OXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 10:23:30 -0400
Date: Sat, 27 Apr 2013 07:23:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: fix cpu hotplug vs rebuild_sched_domains()
 race
Message-ID: <20130427142325.GA25051@mtj.dyndns.org>
References: <517BA01C.6060806@huawei.com>
 <517BA02C.8080005@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517BA02C.8080005@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 05:53:48PM +0800, Li Zefan wrote:
> rebuild_sched_domains() might pass doms with offlined cpu to
> partition_sched_domains(), which results in an oops:
> 
> general protection fault: 0000 [#1] SMP
> ...
> RIP: 0010:[<ffffffff81077a1e>]  [<ffffffff81077a1e>] get_group+0x6e/0x90
> ...
> Call Trace:
>  [<ffffffff8107f07c>] build_sched_domains+0x70c/0xcb0
>  [<ffffffff8107f2a7>] ? build_sched_domains+0x937/0xcb0
>  [<ffffffff81173f64>] ? kfree+0xe4/0x1b0
>  [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
>  [<ffffffff8107f905>] partition_sched_domains+0x2e5/0x470
>  [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
>  [<ffffffff810c9007>] ? generate_sched_domains+0xc7/0x530
>  [<ffffffff810c94a8>] rebuild_sched_domains_locked+0x38/0x70
>  [<ffffffff810cb4a4>] cpuset_write_resmask+0x1a4/0x500
>  [<ffffffff810c8700>] ? cpuset_mount+0xe0/0xe0
>  [<ffffffff810c7f50>] ? cpuset_read_u64+0x100/0x100
>  [<ffffffff810be890>] ? cgroup_iter_next+0x90/0x90
>  [<ffffffff810cb300>] ? cpuset_css_offline+0x70/0x70
>  [<ffffffff810c1a73>] cgroup_file_write+0x133/0x2e0
>  [<ffffffff8118995b>] vfs_write+0xcb/0x130
>  [<ffffffff8118a174>] sys_write+0x64/0xa0
> 
> Reported-by: Li Zhong <zhong@linux.vnet.ibm.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.10.

Thanks.

-- 
tejun

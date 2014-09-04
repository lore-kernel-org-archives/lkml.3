Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaIDQiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:38:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45609 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaIDQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:38:46 -0400
Date: Fri, 5 Sep 2014 01:38:40 +0900
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] cgroup: check cgroup liveliness before unbreaking
 kernfs
Message-ID: <20140904163840.GA26364@mtj.dyndns.org>
References: <540809FB.8020901@huawei.com>
 <54080A1A.7070207@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54080A1A.7070207@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 02:43:38PM +0800, Li Zefan wrote:
> When cgroup_kn_lock_live() is called through some kernfs operation and
> another thread is calling cgroup_rmdir(), we'll trigger the warning in
> cgroup_get().
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1228 at kernel/cgroup.c:1034 cgroup_get+0x89/0xa0()
> ...
> Call Trace:
>  [<c16ee73d>] dump_stack+0x41/0x52
>  [<c10468ef>] warn_slowpath_common+0x7f/0xa0
>  [<c104692d>] warn_slowpath_null+0x1d/0x20
>  [<c10bb999>] cgroup_get+0x89/0xa0
>  [<c10bbe58>] cgroup_kn_lock_live+0x28/0x70
>  [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
>  [<c10be5b2>] cgroup_tasks_write+0x12/0x20
>  [<c10bb7b0>] cgroup_file_write+0x40/0x130
>  [<c11aee71>] kernfs_fop_write+0xd1/0x160
>  [<c1148e58>] vfs_write+0x98/0x1e0
>  [<c114934d>] SyS_write+0x4d/0xa0
>  [<c16f656b>] sysenter_do_call+0x12/0x12
> ---[ end trace 6f2e0c38c2108a74 ]---
> 
> Fix this by calling css_tryget() instead of cgroup_get().
> 
> v2:
> - move cgroup_tryget() right below cgroup_get() definition. (Tejun)
> 
> Cc: <stable@vger.kernel.org> # 3.15+
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.17-fixes.

Thanks.

-- 
tejun

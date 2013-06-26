Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3FZJOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:14:50 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:50475 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FZJOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:14:47 -0400
Message-ID: <51CAB0DB.5000706@huawei.com>
Date: Wed, 26 Jun 2013 17:14:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <trinity@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: fix cgroupfs_root early destruction
 path
References: <51C9D17B.5090208@oracle.com> <20130626010454.GD30407@mtj.dyndns.org>
In-Reply-To: <20130626010454.GD30407@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/26 9:04, Tejun Heo wrote:
> cgroupfs_root used to have ->actual_subsys_mask in addition to
> ->subsys_mask.  a8a648c4ac ("cgroup: remove
> cgroup->actual_subsys_mask") removed it noting that the subsys_mask is
> essentially temporary and doesn't belong in cgroupfs_root; however,
> the patch made it impossible to tell whether a cgroupfs_root actually
> has the subsystems bound or just have the bits set leading to the
> following BUG when trying to mount with subsystems which are already
> mounted elsewhere.
> 
>  kernel BUG at kernel/cgroup.c:1038!
>  invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>  ...
>  CPU: 1 PID: 7973 Comm: mount Tainted: G        W    3.10.0-rc7-next-20130625-sasha-00011-g1c1dc0e #1105
>  task: ffff880fc0ae8000 ti: ffff880fc0b9a000 task.ti: ffff880fc0b9a000
>  RIP: 0010:[<ffffffff81249b29>]  [<ffffffff81249b29>] rebind_subsystems+0x409/0x5f0
>  ...
>  Call Trace:
>   [<ffffffff8124bd4f>] cgroup_kill_sb+0xff/0x210
>   [<ffffffff813d21af>] deactivate_locked_super+0x4f/0x90
>   [<ffffffff8124f3b3>] cgroup_mount+0x673/0x6e0
>   [<ffffffff81257169>] cpuset_mount+0xd9/0x110
>   [<ffffffff813d2580>] mount_fs+0xb0/0x2d0
>   [<ffffffff81404afd>] vfs_kern_mount+0xbd/0x180
>   [<ffffffff814070b5>] do_new_mount+0x145/0x2c0
>   [<ffffffff814085d6>] do_mount+0x356/0x3c0
>   [<ffffffff8140873d>] SyS_mount+0xfd/0x140
>   [<ffffffff854eb600>] tracesys+0xdd/0xe2
> 
> We still want rebind_subsystems() to take added/removed masks, so
> let's fix it by marking whether a cgroupfs_root has finished binding
> or not.  Also, document what's going on around ->subsys_mask
> initialization so that similar mistakes aren't repeated.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Li Zefan <lizefan@huawei.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3DAMGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:06:23 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:54284 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3DAMGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <31775765.508251364807825241.JavaMail.weblogic@epml02>
References: <31775765.508251364807825241.JavaMail.weblogic@epml02>
Date: Mon, 1 Apr 2013 05:06:20 -0700
Message-ID: <CAOMFOmUjjwXg1utrfnGty+LF--ad=85AQtJ57k3jJwL1yN954Q@mail.gmail.com>
Subject: Re: [3.9-rc5] INFO: task umount:29671 blocked for more than 120 seconds
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: jongman.heo@samsung.com, Guo Chao <yan@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Guo Chao  who fixed similar bug recently

On Mon, Apr 1, 2013 at 2:17 AM, Jongman Heo <jongman.heo@samsung.com> wrote:
>
> Hi guys,
>
> I hit following warning with 3.9-rc5, during unmount (the device was mounted via loop device, in case it matters).
>
> Jongman.
>
> [ 3600.583547] INFO: task umount:29671 blocked for more than 120 seconds.
> [ 3600.583552] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 3600.583555] umount          D 0000000000000001     0 29671  29632 0x00000000
> [ 3600.583561]  ffff88011ecb5c98 0000000000000086 ffff880130ccade0 0000000000013e40
> [ 3600.583566]  ffff88011ecb5fd8 ffff88011ecb4010 0000000000013e40 0000000000013e40
> [ 3600.583571]  ffff88011ecb5fd8 0000000000013e40 ffff880132518000 ffff880130ccade0
> [ 3600.583575] Call Trace:
> [ 3600.583583]  [<ffffffff816fb669>] schedule+0x29/0x70
> [ 3600.583589]  [<ffffffff816fb98e>] schedule_preempt_disabled+0xe/0x10
> [ 3600.583593]  [<ffffffff816fa0af>] __mutex_lock_slowpath+0xdf/0x160
> [ 3600.583598]  [<ffffffff811e433e>] ? release_sysfs_dirent+0x7e/0x100
> [ 3600.583603]  [<ffffffff816f9fab>] mutex_lock+0x2b/0x50
> [ 3600.583607]  [<ffffffff8149a8aa>] loop_clr_fd+0x24a/0x2e0
> [ 3600.583612]  [<ffffffff816fce3e>] ? _raw_spin_lock+0xe/0x20
> [ 3600.583617]  [<ffffffff8149a9b8>] lo_release+0x78/0x90
> [ 3600.583622]  [<ffffffff811a94e4>] __blkdev_put+0x194/0x1d0
> [ 3600.583628]  [<ffffffff811a957d>] blkdev_put+0x5d/0x160
> [ 3600.583633]  [<ffffffff811719bd>] kill_block_super+0x4d/0x80
> [ 3600.583638]  [<ffffffff81171f35>] deactivate_locked_super+0x45/0x70
> [ 3600.583643]  [<ffffffff81172dda>] deactivate_super+0x4a/0x70
> [ 3600.583648]  [<ffffffff8118e538>] mntput_no_expire+0xf8/0x150
> [ 3600.583653]  [<ffffffff8118eded>] sys_umount+0xcd/0x3e0
> [ 3600.583659]  [<ffffffff817058d9>] system_call_fastpath+0x16/0x1b
> [ 3600.583663] INFO: task blkid:29673 blocked for more than 120 seconds.
> [ 3600.583665] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 3600.583667] blkid           D ffffffff81807f20     0 29673      1 0x00000000
> [ 3600.583672]  ffff88011338fa88 0000000000000082 ffff880130ccc4d0 0000000000013e40
> [ 3600.583677]  ffff88011338ffd8 ffff88011338e010 0000000000013e40 0000000000013e40
> [ 3600.583681]  ffff88011338ffd8 0000000000013e40 ffff880132b416f0 ffff880130ccc4d0
> [ 3600.583686] Call Trace:
> [ 3600.583691]  [<ffffffff816fb669>] schedule+0x29/0x70
> [ 3600.583695]  [<ffffffff816fb98e>] schedule_preempt_disabled+0xe/0x10
> [ 3600.583700]  [<ffffffff816fa0af>] __mutex_lock_slowpath+0xdf/0x160
> [ 3600.583704]  [<ffffffff816f9fab>] mutex_lock+0x2b/0x50
> [ 3600.583709]  [<ffffffff811a9723>] __blkdev_get+0x73/0x480
> [ 3600.583714]  [<ffffffff811a9e90>] ? blkdev_get+0x360/0x360
> [ 3600.583719]  [<ffffffff811a9b81>] blkdev_get+0x51/0x360
> [ 3600.583724]  [<ffffffff816fce3e>] ? _raw_spin_lock+0xe/0x20
> [ 3600.583729]  [<ffffffff811a9e90>] ? blkdev_get+0x360/0x360
> [ 3600.583734]  [<ffffffff811a9ef2>] blkdev_open+0x62/0x80
> [ 3600.583739]  [<ffffffff8116d82e>] do_dentry_open+0x23e/0x2c0
> [ 3600.583743]  [<ffffffff8116d9c5>] finish_open+0x35/0x50
> [ 3600.583748]  [<ffffffff8117c7b6>] do_last+0x696/0xe50
> [ 3600.583752]  [<ffffffff81166984>] ? kmem_cache_alloc_trace+0xc4/0x120
> [ 3600.583757]  [<ffffffff8117f7c8>] path_openat+0xb8/0x490
> [ 3600.583762]  [<ffffffff8117fcd9>] do_filp_open+0x49/0xa0
> [ 3600.583767]  [<ffffffff816fce3e>] ? _raw_spin_lock+0xe/0x20
> [ 3600.583772]  [<ffffffff8118c4e5>] ? __alloc_fd+0xb5/0x160
> [ 3600.583777]  [<ffffffff8116d498>] do_sys_open+0x108/0x1f0
> [ 3600.583781]  [<ffffffff8116d5c1>] sys_open+0x21/0x30
> [ 3600.583786]  [<ffffffff817058d9>] system_call_fastpath+0x16/0x1b

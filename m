Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3EQHbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:31:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50503 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3EQHbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:31:33 -0400
Message-ID: <5195DCBC.4010506@huawei.com>
Date: Fri, 17 May 2013 15:31:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: <sedat.dilek@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Can someone please fix this ?
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing this since 3.8-rcX. It's very annoying...

[  634.543378] ======================================================
[  634.543378] [ INFO: possible circular locking dependency detected ]
[  634.543380] 3.10.0-rc1-0.7-default+ #8 Not tainted
[  634.543381] -------------------------------------------------------
[  634.543382] kworker/3:1/66 is trying to acquire lock:
[  634.543392]  (&fb_info->lock){+.+.+.}, at: [<ffffffff81293107>] lock_fb_info+0x27/0x60
[  634.543393]
[  634.543393] but task is already holding lock:
[  634.543401]  (console_lock){+.+.+.}, at: [<ffffffff8131bc13>] console_callback+0x13/0x130
[  634.543401]
[  634.543401] which lock already depends on the new lock.
[  634.543401]
[  634.543402]
[  634.543402] the existing dependency chain (in reverse order) is:
[  634.543404]
[  634.543404] -> #1 (console_lock){+.+.+.}:
[  634.543409]        [<ffffffff810aa50c>] lock_acquire+0xdc/0x110
[  634.543413]        [<ffffffff8104101f>] console_lock+0x5f/0x70
[  634.543416]        [<ffffffff81294092>] register_framebuffer+0x262/0x350
[  634.543422]        [<ffffffff81ad477c>] vesafb_probe+0x654/0x928
[  634.543427]        [<ffffffff8133c69d>] platform_drv_probe+0x3d/0x70
[  634.543430]        [<ffffffff8133a601>] driver_probe_device+0xc1/0x3e0
[  634.543433]        [<ffffffff8133a9bb>] __driver_attach+0x9b/0xa0
[  634.543435]        [<ffffffff81338718>] bus_for_each_dev+0x98/0xc0
[  634.543437]        [<ffffffff8133a351>] driver_attach+0x21/0x30
[  634.543440]        [<ffffffff81339c81>] bus_add_driver+0x111/0x270
[  634.543442]        [<ffffffff8133b088>] driver_register+0x68/0x150
[  634.543444]        [<ffffffff8133c516>] platform_driver_register+0x46/0x50
[  634.543447]        [<ffffffff8133c53b>] platform_driver_probe+0x1b/0xb0
[  634.543449]        [<ffffffff81ad3fcf>] vesafb_init+0xff/0x258
[  634.543455]        [<ffffffff8100032a>] do_one_initcall+0x15a/0x1c0
[  634.543459]        [<ffffffff81aa28e1>] kernel_init_freeable+0x15d/0x1f3
[  634.543464]        [<ffffffff81484e8e>] kernel_init+0xe/0x180
[  634.543470]        [<ffffffff814a665c>] ret_from_fork+0x7c/0xb0
[  634.543472]
[  634.543472] -> #0 (&fb_info->lock){+.+.+.}:
[  634.543474]        [<ffffffff810aa06d>] __lock_acquire+0x14dd/0x18a0
[  634.543476]        [<ffffffff810aa50c>] lock_acquire+0xdc/0x110
[  634.543479]        [<ffffffff81498d90>] mutex_lock_nested+0x40/0x390
[  634.543481]        [<ffffffff81293107>] lock_fb_info+0x27/0x60
[  634.543484]        [<ffffffff812a00d9>] fbcon_blank+0x289/0x2d0
[  634.543486]        [<ffffffff8131bb63>] do_blank_screen+0x1c3/0x260
[  634.543488]        [<ffffffff8131bc9c>] console_callback+0x9c/0x130
[  634.543494]        [<ffffffff81061fb5>] process_one_work+0x205/0x570
[  634.543496]        [<ffffffff81064bb3>] worker_thread+0x133/0x420
[  634.543499]        [<ffffffff8106b31e>] kthread+0xde/0xf0
[  634.543502]        [<ffffffff814a665c>] ret_from_fork+0x7c/0xb0
[  634.543502]
[  634.543502] other info that might help us debug this:
[  634.543502]
[  634.543503]  Possible unsafe locking scenario:
[  634.543503]
[  634.543503]        CPU0                    CPU1
[  634.543504]        ----                    ----
[  634.543505]   lock(console_lock);
[  634.543507]                                lock(&fb_info->lock);
[  634.543508]                                lock(console_lock);
[  634.543509]   lock(&fb_info->lock);
[  634.543510]
[  634.543510]  *** DEADLOCK ***
[  634.543510]
[  634.543511] 3 locks held by kworker/3:1/66:
[  634.543516]  #0:  (events){.+.+.+}, at: [<ffffffff81061f1e>] process_one_work+0x16e/0x570
[  634.543520]  #1:  (console_work){+.+...}, at: [<ffffffff81061f1e>] process_one_work+0x16e/0x570
[  634.543523]  #2:  (console_lock){+.+.+.}, at: [<ffffffff8131bc13>] console_callback+0x13/0x130
[  634.543524]
[  634.543524] stack backtrace:
[  634.543526] CPU: 3 PID: 66 Comm: kworker/3:1 Not tainted 3.10.0-rc1-0.7-default+ #8
[  634.543527] Hardware name: Huawei Technologies Co., Ltd. Tecal RH2285          /BC11BTSA              , BIOS CTSAV036 04/27/2011
[  634.543530] Workqueue: events console_callback
[  634.543534]  ffffffff81e498a0 ffff880bf910f9f8 ffffffff814984cc ffff880bf910fa38
[  634.543536]  ffffffff810a71f3 0000000000000003 0000000000000050 0000000000000003
[  634.543539]  0000000000000000 ffff880bf91426d0 0000878a84046138 ffff880bf910fb18
[  634.543540] Call Trace:
[  634.543543]  [<ffffffff814984cc>] dump_stack+0x19/0x1d
[  634.543545]  [<ffffffff810a71f3>] print_circular_bug+0x223/0x330
[  634.543547]  [<ffffffff810aa06d>] __lock_acquire+0x14dd/0x18a0
[  634.543552]  [<ffffffff812a9802>] ? bitfill_aligned+0xe2/0x140
[  634.543554]  [<ffffffff810aa50c>] lock_acquire+0xdc/0x110
[  634.543556]  [<ffffffff81293107>] ? lock_fb_info+0x27/0x60
[  634.543559]  [<ffffffff81498d90>] mutex_lock_nested+0x40/0x390
[  634.543561]  [<ffffffff81293107>] ? lock_fb_info+0x27/0x60
[  634.543563]  [<ffffffff812a3d39>] ? bit_clear+0xd9/0xf0
[  634.543567]  [<ffffffff810718b6>] ? blocking_notifier_call_chain+0x16/0x20
[  634.543570]  [<ffffffff8129d22c>] ? fbcon_clear+0x12c/0x1e0
[  634.543572]  [<ffffffff81293107>] lock_fb_info+0x27/0x60
[  634.543575]  [<ffffffff812a00d9>] fbcon_blank+0x289/0x2d0
[  634.543578]  [<ffffffff8149d414>] ? _raw_spin_unlock_irqrestore+0x44/0x70
[  634.543580]  [<ffffffff810a882d>] ? trace_hardirqs_on_caller+0x14d/0x1f0
[  634.543582]  [<ffffffff810a88dd>] ? trace_hardirqs_on+0xd/0x10
[  634.543587]  [<ffffffff8105069b>] ? try_to_del_timer_sync+0x5b/0x70
[  634.543589]  [<ffffffff810a882d>] ? trace_hardirqs_on_caller+0x14d/0x1f0
[  634.543592]  [<ffffffff8131bb63>] do_blank_screen+0x1c3/0x260
[  634.543594]  [<ffffffff8131bc9c>] console_callback+0x9c/0x130
[  634.543597]  [<ffffffff81061fb5>] process_one_work+0x205/0x570
[  634.543599]  [<ffffffff81061f1e>] ? process_one_work+0x16e/0x570
[  634.543601]  [<ffffffff81064bb3>] worker_thread+0x133/0x420
[  634.543603]  [<ffffffff810a88dd>] ? trace_hardirqs_on+0xd/0x10
[  634.543605]  [<ffffffff81064a80>] ? manage_workers+0x320/0x320
[  634.543607]  [<ffffffff8106b31e>] kthread+0xde/0xf0
[  634.543610]  [<ffffffff8106b240>] ? __init_kthread_worker+0x70/0x70
[  634.543613]  [<ffffffff814a665c>] ret_from_fork+0x7c/0xb0
[  634.543615]  [<ffffffff8106b240>] ? __init_kthread_worker+0x70/0x70

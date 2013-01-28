Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3A1Giq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 01:38:46 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:38671 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3A1Gio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 01:38:44 -0500
MIME-Version: 1.0
Date: Mon, 28 Jan 2013 01:38:43 -0500
Message-ID: <CAHFgRy_DfbyP47W95ikd8Jw4UxncV0KdaRD8M=4+ibp55M73vA@mail.gmail.com>
Subject: Linus GIT 3.8.0-rc5: INFO: possible circular locking dependency
 detected -- ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff81052611>] __blocking_notifier_call_chain+0x49/0x80
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,
At the bottom of this message you will find dmesg output showing this
problem from the current Linus GIT tree.
Here is the test of the message you wrote about this
(http://marc.info/?l=dri-devel&m=135905755124554&w=2):
--------------------------
Patches for the know issues around console_lock vs fbdev_notifier are in -mm:

http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
http://ozlabs.org/~akpm/mmots/broken-out/fb-yet-another-band-aid-for-fixing-lockdep-mess.patch

Unfortunately the patches seem to be stuck there for now despite quite
a few reports about this (including seemingly relevant background
noise about hangs in distro bugzillas).
-Daniel
----------------------------------

[  489.832113] [ INFO: possible circular locking dependency detected ]
[  489.832115] 3.8.0-rc5 #99 Not tainted
[  489.832116] -------------------------------------------------------
[  489.832117] 99video/4306 is trying to acquire lock:
[  489.832129]  ((fb_notifier_list).rwsem){.+.+.+}, at:
[<ffffffff81052611>] __blocking_notifier_call_chain+0x49/0x80
[  489.832130]
[  489.832130] but task is already holding lock:
[  489.832136]  (console_lock){+.+.+.}, at: [<ffffffff8125d25e>]
store_fbstate+0x43/0x71
[  489.832137]
[  489.832137] which lock already depends on the new lock.
[  489.832137]
[  489.832138]
[  489.832138] the existing dependency chain (in reverse order) is:
[  489.832141]
[  489.832141] -> #1 (console_lock){+.+.+.}:
[  489.832146]        [<ffffffff81079aa8>] lock_acquire+0xfe/0x14d
[  489.832150]        [<ffffffff8102f680>] console_lock+0x64/0x66
[  489.832154]        [<ffffffff812b06ef>] register_con_driver+0x33/0x123
[  489.832158]        [<ffffffff812b0f13>] take_over_console+0x21/0x266
[  489.832161]        [<ffffffff812617e0>] fbcon_takeover+0x56/0x98
[  489.832165]        [<ffffffff812652f4>] fbcon_event_notify+0x3b6/0x6e4
[  489.832169]        [<ffffffff8147584a>] notifier_call_chain+0x8c/0xc0
[  489.832173]        [<ffffffff81052627>]
__blocking_notifier_call_chain+0x5f/0x80
[  489.832176]        [<ffffffff81052657>] blocking_notifier_call_chain+0xf/0x11
[  489.832181]        [<ffffffff812582f2>] fb_notifier_call_chain+0x16/0x18
[  489.832184]        [<ffffffff812595de>] register_framebuffer+0x216/0x27a
[  489.832189]        [<ffffffff81ac6e48>] vesafb_probe+0x6df/0x75f
[  489.832193]        [<ffffffff81333d70>] platform_drv_probe+0x34/0x5e
[  489.832196]        [<ffffffff8133254b>] driver_probe_device+0x90/0x19b
[  489.832199]        [<ffffffff813326a4>] __driver_attach+0x4e/0x6f
[  489.832202]        [<ffffffff81330d02>] bus_for_each_dev+0x52/0x85
[  489.832205]        [<ffffffff8133208a>] driver_attach+0x19/0x1b
[  489.832208]        [<ffffffff81331d49>] bus_add_driver+0xf7/0x21a
[  489.832211]        [<ffffffff81332bf3>] driver_register+0x8c/0x110
[  489.832214]        [<ffffffff81333805>] platform_driver_register+0x41/0x43
[  489.832217]        [<ffffffff8133381f>] platform_driver_probe+0x18/0x8a
[  489.832220]        [<ffffffff81ac6726>] vesafb_init+0x215/0x258
[  489.832224]        [<ffffffff81000232>] do_one_initcall+0x7a/0x130
[  489.832228]        [<ffffffff81aa4bfb>] kernel_init_freeable+0x109/0x191
[  489.832233]        [<ffffffff8145d421>] kernel_init+0x9/0xd1
[  489.832236]        [<ffffffff814786ec>] ret_from_fork+0x7c/0xb0
[  489.832240]
[  489.832240] -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
[  489.832242]        [<ffffffff8107925d>] __lock_acquire+0xacc/0xe0c
[  489.832245]        [<ffffffff81079aa8>] lock_acquire+0xfe/0x14d
[  489.832249]        [<ffffffff81470d7a>] down_read+0x3f/0x4b
[  489.832253]        [<ffffffff81052611>]
__blocking_notifier_call_chain+0x49/0x80
[  489.832257]        [<ffffffff81052657>] blocking_notifier_call_chain+0xf/0x11
[  489.832260]        [<ffffffff812582f2>] fb_notifier_call_chain+0x16/0x18
[  489.832263]        [<ffffffff812586d9>] fb_set_suspend+0x22/0x4b
[  489.832266]        [<ffffffff8125d269>] store_fbstate+0x4e/0x71
[  489.832270]        [<ffffffff8132e98f>] dev_attr_store+0x13/0x1f
[  489.832274]        [<ffffffff81163064>] sysfs_write_file+0xe9/0x121
[  489.832278]        [<ffffffff81106546>] vfs_write+0x91/0xd0
[  489.832281]        [<ffffffff81106738>] sys_write+0x5a/0x8b
[  489.832284]        [<ffffffff81478792>] system_call_fastpath+0x16/0x1b
[  489.832285]
[  489.832285] other info that might help us debug this:
[  489.832285]
[  489.832286]  Possible unsafe locking scenario:
[  489.832286]
[  489.832287]        CPU0                    CPU1
[  489.832288]        ----                    ----
[  489.832290]   lock(console_lock);
[  489.832292]                                lock((fb_notifier_list).rwsem);
[  489.832294]                                lock(console_lock);
[  489.832296]   lock((fb_notifier_list).rwsem);
[  489.832297]
[  489.832297]  *** DEADLOCK ***
[  489.832297]
[  489.832298] 4 locks held by 99video/4306:
[  489.832304]  #0:  (&buffer->mutex){+.+.+.}, at:
[<ffffffff81162fb2>] sysfs_write_file+0x37/0x121
[  489.832310]  #1:  (s_active#204){.+.+.+}, at: [<ffffffff8116304c>]
sysfs_write_file+0xd1/0x121
[  489.832315]  #2:  (&fb_info->lock){+.+.+.}, at:
[<ffffffff81258698>] lock_fb_info+0x18/0x37
[  489.832321]  #3:  (console_lock){+.+.+.}, at: [<ffffffff8125d25e>]
store_fbstate+0x43/0x71
[  489.832321]
[  489.832321] stack backtrace:
[  489.832324] Pid: 4306, comm: 99video Not tainted 3.8.0-rc5 #99
[  489.832325] Call Trace:
[  489.832330]  [<ffffffff8146aca7>] print_circular_bug+0x1f6/0x204
[  489.832333]  [<ffffffff8107925d>] __lock_acquire+0xacc/0xe0c
[  489.832337]  [<ffffffff81079aa8>] lock_acquire+0xfe/0x14d
[  489.832341]  [<ffffffff81052611>] ? __blocking_notifier_call_chain+0x49/0x80
[  489.832345]  [<ffffffff81470d7a>] down_read+0x3f/0x4b
[  489.832348]  [<ffffffff81052611>] ? __blocking_notifier_call_chain+0x49/0x80
[  489.832352]  [<ffffffff81052611>] __blocking_notifier_call_chain+0x49/0x80
[  489.832356]  [<ffffffff81052657>] blocking_notifier_call_chain+0xf/0x11
[  489.832359]  [<ffffffff812582f2>] fb_notifier_call_chain+0x16/0x18
[  489.832362]  [<ffffffff812586d9>] fb_set_suspend+0x22/0x4b
[  489.832365]  [<ffffffff8102f680>] ? console_lock+0x64/0x66
[  489.832368]  [<ffffffff8125d269>] store_fbstate+0x4e/0x71
[  489.832372]  [<ffffffff8132e98f>] dev_attr_store+0x13/0x1f
[  489.832375]  [<ffffffff81163064>] sysfs_write_file+0xe9/0x121
[  489.832378]  [<ffffffff81106546>] vfs_write+0x91/0xd0
[  489.832381]  [<ffffffff81106738>] sys_write+0x5a/0x8b
[  489.832385]  [<ffffffff81478792>] system_call_fastpath+0x16/0x1b
[  490.115770] PM: Syncing filesystems ... done.

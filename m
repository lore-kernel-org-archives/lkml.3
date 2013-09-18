Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3IRAhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:37:41 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52753 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab3IRAhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:37:40 -0400
MIME-Version: 1.0
Date: Tue, 17 Sep 2013 17:37:39 -0700
Message-ID: <CACtBk7oZOAt0ZZM4V1LabROibLkomDuLHFRXcuh=2FVi5jWp3Q@mail.gmail.com>
Subject: Help. INFO: possible circular locking dependency detected
From: Sean Combs <clutchshooter@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend-to-RAM, I see an info message below.   Could anybody
advice how to debug this problem or anyone has experienced this
before?  (ARM mach)

Thanks a lot for any help.

[  172.637547] ======================================================
[  172.637555] [ INFO: possible circular locking dependency detected ]
[  172.637565] 3.10.5+ #1 Not tainted
[  172.637573] -------------------------------------------------------
[  172.637581] kworker/u12:0/6 is trying to acquire lock:
[  172.637628]  (cpu_add_remove_lock){+.+.+.}, at: [<c002973c>]
cpu_maps_update_begin+0x20/0x28
[  172.637635]
[  172.637635] but task is already holding lock:
[  172.637671]  (console_lock){+.+.+.}, at: [<c0028974>]
suspend_console+0x30/0x54
[  172.637679]
[  172.637679] which lock already depends on the new lock.
[  172.637679]
[  172.637686]
[  172.637686] the existing dependency chain (in reverse order) is:
[  172.637714]
[  172.637714] -> #2 (console_lock){+.+.+.}:
[  172.637734]        [<c008d880>] check_prevs_add+0x704/0x874
[  172.637752]        [<c008dfd0>] validate_chain.isra.24+0x5e0/0x9b0
[  172.637769]        [<c00909f0>] __lock_acquire+0x3fc/0xbcc
[  172.637786]        [<c009186c>] lock_acquire+0xa4/0x208
[  172.637804]        [<c002656c>] console_lock+0x70/0x88
[  172.637824]        [<c075f950>] console_cpu_notify+0x28/0x34
[  172.637844]        [<c07733f8>] notifier_call_chain+0x74/0x138
[  172.637864]        [<c0057374>] __raw_notifier_call_chain+0x24/0x2c
[  172.637880]        [<c002953c>] __cpu_notify+0x38/0x54
[  172.637896]        [<c0029578>] cpu_notify+0x20/0x24
[  172.637913]        [<c0029710>] cpu_notify_nofail+0x18/0x24
[  172.637929]        [<c075d9f0>] _cpu_down+0x108/0x2b8
[  172.637946]        [<c075dbd4>] cpu_down+0x34/0x50
[  172.637962]        [<c075e4f4>] store_online+0x40/0x84
[  172.637981]        [<c034e430>] dev_attr_store+0x28/0x34
[  172.638000]        [<c019c4a0>] sysfs_write_file+0x17c/0x1ac
[  172.638018]        [<c01318b4>] vfs_write+0xc0/0x19c
[  172.638034]        [<c0131cb0>] SyS_write+0x4c/0x80
[  172.638053]        [<c000efa0>] ret_fast_syscall+0x0/0x48
[  172.638081]
[  172.638081] -> #1 (cpu_hotplug.lock){+.+.+.}:
[  172.638098]        [<c008d880>] check_prevs_add+0x704/0x874
[  172.638116]        [<c008dfd0>] validate_chain.isra.24+0x5e0/0x9b0
[  172.638132]        [<c00909f0>] __lock_acquire+0x3fc/0xbcc
[  172.638149]        [<c009186c>] lock_acquire+0xa4/0x208
[  172.638166]        [<c076dc78>] mutex_lock_nested+0x74/0x3f8
[  172.638183]        [<c00295b8>] cpu_hotplug_begin+0x3c/0x68
[  172.638200]        [<c075f988>] _cpu_up+0x2c/0x15c
[  172.638216]        [<c075fb24>] cpu_up+0x6c/0x8c
[  172.638236]        [<c0a90774>] smp_init+0x9c/0xd4
[  172.638254]        [<c0a8293c>] kernel_init_freeable+0x78/0x1cc
[  172.638270]        [<c075d694>] kernel_init+0x18/0xf4
[  172.638288]        [<c000f068>] ret_from_fork+0x14/0x20
[  172.638316]
[  172.638316] -> #0 (cpu_add_remove_lock){+.+.+.}:
[  172.638335]        [<c0763aa0>] print_circular_bug+0x70/0x2e4
[  172.638352]        [<c008d9c0>] check_prevs_add+0x844/0x874
[  172.638370]        [<c008dfd0>] validate_chain.isra.24+0x5e0/0x9b0
[  172.638387]        [<c00909f0>] __lock_acquire+0x3fc/0xbcc
[  172.638404]        [<c009186c>] lock_acquire+0xa4/0x208
[  172.638421]        [<c076dc78>] mutex_lock_nested+0x74/0x3f8
[  172.638438]        [<c002973c>] cpu_maps_update_begin+0x20/0x28
[  172.638455]        [<c0029a24>] disable_nonboot_cpus+0x20/0xf4
[  172.638476]        [<c007df64>] suspend_devices_and_enter+0x1b0/0x574
[  172.638494]        [<c007e4f8>] pm_suspend+0x1d0/0x288
[  172.638512]        [<c007e6b0>] try_to_suspend+0xc0/0xdc
[  172.638530]        [<c0047e44>] process_one_work+0x1c8/0x684
[  172.638547]        [<c0048738>] worker_thread+0x144/0x394
[  172.638565]        [<c00508a4>] kthread+0xb4/0xc0
[  172.638582]        [<c000f068>] ret_from_fork+0x14/0x20
[  172.638590]
[  172.638590] other info that might help us debug this:
[  172.638590]
[  172.638630] Chain exists of:
[  172.638630]   cpu_add_remove_lock --> cpu_hotplug.lock --> console_lock
[  172.638630]
[  172.638637]  Possible unsafe locking scenario:
[  172.638637]
[  172.638644]        CPU0                    CPU1
[  172.638651]        ----                    ----
[  172.638668]   lock(console_lock);
[  172.638685]                                lock(cpu_hotplug.lock);
[  172.638703]                                lock(console_lock);
[  172.638720]   lock(cpu_add_remove_lock);
[  172.638726]
[  172.638726]  *** DEADLOCK ***
[  172.638726]
[  172.638735] 5 locks held by kworker/u12:0/6:
[  172.638774]  #0:  (autosleep){.+.+.+}, at: [<c0047db4>]
process_one_work+0x138/0x684
[  172.638813]  #1:  (suspend_work){+.+.+.}, at: [<c0047db4>]
process_one_work+0x138/0x684
[  172.638853]  #2:  (autosleep_lock){+.+.+.}, at: [<c007e628>]
try_to_suspend+0x38/0xdc
[  172.638893]  #3:  (pm_mutex){+.+.+.}, at: [<c007e36c>] pm_suspend+0x44/0x288
[  172.638933]  #4:  (console_lock){+.+.+.}, at: [<c0028974>]
suspend_console+0x30/0x54
[  172.638939]
[  172.638939] stack backtrace:
[  172.638952] CPU: 0 PID: 6 Comm: kworker/u12:0 Not tainted 3.10.5+ #1
[  172.638973] Workqueue: autosleep try_to_suspend
[  172.638997] [<c0016658>] (unwind_backtrace+0x0/0x144) from
[<c00134ec>] (show_stack+0x20/0x24)
[  172.639017] [<c00134ec>] (show_stack+0x20/0x24) from [<c0768c38>]
(dump_stack+0x20/0x28)
[  172.639038] [<c0768c38>] (dump_stack+0x20/0x28) from [<c0763cc0>]
(print_circular_bug+0x290/0x2e4)
[  172.639057] [<c0763cc0>] (print_circular_bug+0x290/0x2e4) from
[<c008d9c0>] (check_prevs_add+0x844/0x874)
[  172.639075] [<c008d9c0>] (check_prevs_add+0x844/0x874) from
[<c008dfd0>] (validate_chain.isra.24+0x5e0/0x9b0)
[  172.639093] [<c008dfd0>] (validate_chain.isra.24+0x5e0/0x9b0) from
[<c00909f0>] (__lock_acquire+0x3fc/0xbcc)
[  172.639111] [<c00909f0>] (__lock_acquire+0x3fc/0xbcc) from
[<c009186c>] (lock_acquire+0xa4/0x208)
[  172.639128] [<c009186c>] (lock_acquire+0xa4/0x208) from
[<c076dc78>] (mutex_lock_nested+0x74/0x3f8)
[  172.639146] [<c076dc78>] (mutex_lock_nested+0x74/0x3f8) from
[<c002973c>] (cpu_maps_update_begin+0x20/0x28)
[  172.639164] [<c002973c>] (cpu_maps_update_begin+0x20/0x28) from
[<c0029a24>] (disable_nonboot_cpus+0x20/0xf4)
[  172.639184] [<c0029a24>] (disable_nonboot_cpus+0x20/0xf4) from
[<c007df64>] (suspend_devices_and_enter+0x1b0/0x574)
[  172.639204] [<c007df64>] (suspend_devices_and_enter+0x1b0/0x574)
from [<c007e4f8>] (pm_suspend+0x1d0/0x288)
[  172.639223] [<c007e4f8>] (pm_suspend+0x1d0/0x288) from [<c007e6b0>]
(try_to_suspend+0xc0/0xdc)
[  172.639242] [<c007e6b0>] (try_to_suspend+0xc0/0xdc) from
[<c0047e44>] (process_one_work+0x1c8/0x684)
[  172.639259] [<c0047e44>] (process_one_work+0x1c8/0x684) from
[<c0048738>] (worker_thread+0x144/0x394)
[  172.639278] [<c0048738>] (worker_thread+0x144/0x394) from
[<c00508a4>] (kthread+0xb4/0xc0)
[  172.639296] [<c00508a4>] (kthread+0xb4/0xc0) from [<c000f068>]
(ret_from_fork+0x14/0x20)
[  172.639307] Disabling non-boot CPUs ...

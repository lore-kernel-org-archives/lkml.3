Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3GTO3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:29:14 -0400
Received: from mail.tomasu.net ([64.85.170.232]:48745 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab3GTO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:29:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jul 2013 10:29:12 EDT
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: hung task with 3.9.8/3.10.1
Date: Sat, 20 Jul 2013 08:21:38 -0600
Message-ID: <137450198.fYZy8Ria9U@balsa>
User-Agent: KMail/4.10.5 (Linux/3.9-1-amd64; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently picked up an older IBM System x3650 server for some virtualization and
web stuff, and after installing (oldstable) and upgrading (curent sid) debian, it hangs for a while on
bootup trying to modprobe some driver (logs to follow). It booted fine with the
old debian 2.6.32 kernel, but I felt it was a good idea not to use an ancient
kernel.

[  240.592039] INFO: task modprobe:597 blocked for more than 120 seconds.
[  240.592101] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.592161] modprobe        D ffff88013fd53ec0     0   597    566 0x20020004
[  240.592166]  ffff880137ddd7f0 0000000000000082 ffff88013aea00c0 0000000000013ec0
[  240.592171]  ffff8801395b7fd8 ffff8801395b7fd8 ffff880137ddd7f0 ffff8801392d8c00
[  240.592175]  0000000000000000 0000000000000000 ffff8801392d8f78 0000000000000000
[  240.592179] Call Trace:
[  240.592198]  [<ffffffffa01702c7>] ? i801_transaction+0xa4/0xe9 [i2c_i801]
[  240.592206]  [<ffffffff81057c9a>] ? abort_exclusive_wait+0x79/0x79
[  240.592211]  [<ffffffffa0170de3>] ? i801_access+0x7a6/0x888 [i2c_i801]
[  240.592217]  [<ffffffff8105cfba>] ? __wake_up_common+0x3f/0x71
[  240.592223]  [<ffffffff81381acf>] ? _raw_spin_unlock_irqrestore+0xc/0xd
[  240.592228]  [<ffffffff8113c926>] ? ep_poll_callback+0xe0/0xf9
[  240.592235]  [<ffffffffa01efbbc>] ? i2c_smbus_xfer+0xc3/0x11d [i2c_core]
[  240.592241]  [<ffffffffa01f0069>] ? idr_find.constprop.13+0x25/0x30 [i2c_core]
[  240.592247]  [<ffffffffa01f09e9>] ? i2c_default_probe+0x83/0xd0 [i2c_core]
[  240.592252]  [<ffffffffa01f0069>] ? idr_find.constprop.13+0x25/0x30 [i2c_core]
[  240.592258]  [<ffffffffa01ef5de>] ? i2c_check_addr_busy+0x2c/0x42 [i2c_core]
[  240.592263]  [<ffffffffa01f0ad3>] ? i2c_do_add_adapter+0x9d/0x1ff [i2c_core]
[  240.592269]  [<ffffffff811c5a5d>] ? kobject_uevent_env+0x3f8/0x43a
[  240.592274]  [<ffffffffa01f0c35>] ? i2c_do_add_adapter+0x1ff/0x1ff [i2c_core]
[  240.592280]  [<ffffffffa01f0c35>] ? i2c_do_add_adapter+0x1ff/0x1ff [i2c_core]
[  240.592285]  [<ffffffff812768a2>] ? bus_for_each_dev+0x4b/0x7c
[  240.592291]  [<ffffffffa01f0c35>] ? i2c_do_add_adapter+0x1ff/0x1ff [i2c_core]
[  240.592296]  [<ffffffffa01ef37c>] ? i2c_for_each_dev+0x29/0x3f [i2c_core]
[  240.592302]  [<ffffffffa01f001f>] ? i2c_register_driver+0x7a/0x9f [i2c_core]
[  240.592312]  [<ffffffffa0061000>] ? 0xffffffffa0060fff
[  240.592317]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x12a
[  240.592321]  [<ffffffffa0061000>] ? 0xffffffffa0060fff
[  240.592326]  [<ffffffff810832d3>] ? load_module+0x1ae4/0x1dcd
[  240.592330]  [<ffffffff8107fe02>] ? free_notes_attrs+0x3c/0x3c
[  240.592335]  [<ffffffff8108365a>] ? sys_init_module+0x9e/0xab
[  240.592340]  [<ffffffff813882ec>] ? sysenter_dispatch+0x7/0x21
[  240.592344] INFO: task modprobe:674 blocked for more than 120 seconds.
[  240.592401] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.592460] modprobe        D ffff88013fc93ec0     0   674    528 0x20020006
[  240.592463]  ffff880137e05100 0000000000000082 ffff88013ae9f7b0 0000000000013ec0
[  240.592468]  ffff8801386d1fd8 ffff8801386d1fd8 ffff880137e05100 ffffffffa01f20e0
[  240.592472]  ffff880137e05100 ffffffffa01f20e4 0000000000000002 0000000000000000
[  240.592476] Call Trace:
[  240.592482]  [<ffffffff81381398>] ? schedule_preempt_disabled+0x5/0x6
[  240.592486]  [<ffffffff813804a5>] ? __mutex_lock_common.isra.6+0x145/0x161
[  240.592493]  [<ffffffffa01f06a4>] ? i2c_register_adapter+0x1f6/0x1f6 [i2c_core]
[  240.592496]  [<ffffffff813802d7>] ? mutex_lock+0x17/0x27
[  240.592502]  [<ffffffffa01f06b5>] ? i2c_add_adapter+0x11/0x59 [i2c_core]
[  240.592507]  [<ffffffffa02106aa>] ? __i2c_bit_add_bus+0x33/0x284 [i2c_algo_bit]
[  240.592546]  [<ffffffffa042fead>] ? radeon_i2c_create+0x1b8/0x1ea [radeon]
[  240.592570]  [<ffffffffa041a011>] ? radeon_combios_i2c_init+0x5b/0x227 [radeon]
[  240.592599]  [<ffffffffa042dbbc>] ? radeon_modeset_init+0x8da/0x916 [radeon]
[  240.592629]  [<ffffffffa0432728>] ? radeon_ib_ring_tests+0x3b/0x9b [radeon]
[  240.592652]  [<ffffffffa0412560>] ? radeon_driver_load_kms+0xb1/0xf5 [radeon]
[  240.592664]  [<ffffffffa0280e21>] ? drm_get_pci_dev+0x152/0x259 [drm]
[  240.592685]  [<ffffffffa04100f0>] ? radeon_pci_probe+0xd4/0xf6 [radeon]
[  240.592706]  [<ffffffffa0410102>] ? radeon_pci_probe+0xe6/0xf6 [radeon]
[  240.592711]  [<ffffffff811e1c50>] ? local_pci_probe+0x33/0x58
[  240.592715]  [<ffffffff81278052>] ? driver_probe_device+0x1b0/0x1b0
[  240.592719]  [<ffffffff811e1d2f>] ? pci_device_probe+0xba/0xde
[  240.592723]  [<ffffffff81277f34>] ? driver_probe_device+0x92/0x1b0
[  240.592727]  [<ffffffff812780a5>] ? __driver_attach+0x53/0x73
[  240.592730]  [<ffffffff812768a2>] ? bus_for_each_dev+0x4b/0x7c
[  240.592735]  [<ffffffff81277775>] ? bus_add_driver+0xd5/0x1f4
[  240.592739]  [<ffffffffa0313000>] ? 0xffffffffa0312fff
[  240.592743]  [<ffffffff812785cf>] ? driver_register+0x87/0xfe
[  240.592747]  [<ffffffffa0313000>] ? 0xffffffffa0312fff
[  240.592750]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x12a
[  240.592754]  [<ffffffffa0313000>] ? 0xffffffffa0312fff
[  240.592758]  [<ffffffff810832d3>] ? load_module+0x1ae4/0x1dcd
[  240.592762]  [<ffffffff8107fe02>] ? free_notes_attrs+0x3c/0x3c
[  240.592766]  [<ffffffff8108365a>] ? sys_init_module+0x9e/0xab
[  240.592770]  [<ffffffff813882ec>] ? sysenter_dispatch+0x7/0x21

These are the hung tasks:

root       597  0.0  0.0   3988   688 ?        D    06:25   0:00 /sbin/modprobe -b dmi:bvnIBM:bvr-[GGE146BUS-1.17]-:bd12/11/2009:svnIBM:pnIBMSystemx3650-[7979AC1]-:pvr:rvnIBM:rnSystemPlanar:rvr:cvnIBM:ct17:cvr:
root       674  0.0  0.0   5104  1736 ?        D    06:25   0:00 /sbin/modprobe -b pci:v00001002d0000515Esv00001014sd00000305bc03sc00i00

I've tried debian's 3.9 and 3.10 kernel.

Is this a known issue? Maybe I need to provide some kind of boot parameter?

Thanks.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net

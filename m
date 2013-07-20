Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3GTXUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:20:19 -0400
Received: from mail.tomasu.net ([64.85.170.232]:39283 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab3GTXUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:20:17 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: hung task with 3.9.8/3.10.1
Date: Sat, 20 Jul 2013 17:19:30 -0600
Message-ID: <31240603.zcuBEB4roc@balsa>
User-Agent: KMail/4.10.5 (Linux/3.9-1-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <137450198.fYZy8Ria9U@balsa>
References: <137450198.fYZy8Ria9U@balsa>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 20 July 2013 08:21:38 Thomas Fjellstrom wrote:
> I recently picked up an older IBM System x3650 server for some
> virtualization and web stuff, and after installing (oldstable) and
> upgrading (curent sid) debian, it hangs for a while on bootup trying to
> modprobe some driver (logs to follow). It booted fine with the old debian
> 2.6.32 kernel, but I felt it was a good idea not to use an ancient kernel.
> 
> [  240.592039] INFO: task modprobe:597 blocked for more than 120 seconds.
> [  240.592101] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message. [  240.592161] modprobe        D ffff88013fd53ec0     0   597
>    566 0x20020004 [  240.592166]  ffff880137ddd7f0 0000000000000082
> ffff88013aea00c0 0000000000013ec0 [  240.592171]  ffff8801395b7fd8
> ffff8801395b7fd8 ffff880137ddd7f0 ffff8801392d8c00 [  240.592175] 
> 0000000000000000 0000000000000000 ffff8801392d8f78 0000000000000000 [ 
> 240.592179] Call Trace:
> [  240.592198]  [<ffffffffa01702c7>] ? i801_transaction+0xa4/0xe9 [i2c_i801]
> [  240.592206]  [<ffffffff81057c9a>] ? abort_exclusive_wait+0x79/0x79 [ 
> 240.592211]  [<ffffffffa0170de3>] ? i801_access+0x7a6/0x888 [i2c_i801] [ 
> 240.592217]  [<ffffffff8105cfba>] ? __wake_up_common+0x3f/0x71
> [  240.592223]  [<ffffffff81381acf>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> [  240.592228]  [<ffffffff8113c926>] ? ep_poll_callback+0xe0/0xf9
> [  240.592235]  [<ffffffffa01efbbc>] ? i2c_smbus_xfer+0xc3/0x11d [i2c_core]
> [  240.592241]  [<ffffffffa01f0069>] ? idr_find.constprop.13+0x25/0x30
> [i2c_core] [  240.592247]  [<ffffffffa01f09e9>] ?
> i2c_default_probe+0x83/0xd0 [i2c_core] [  240.592252]  [<ffffffffa01f0069>]
> ? idr_find.constprop.13+0x25/0x30 [i2c_core] [  240.592258] 
> [<ffffffffa01ef5de>] ? i2c_check_addr_busy+0x2c/0x42 [i2c_core] [ 
> 240.592263]  [<ffffffffa01f0ad3>] ? i2c_do_add_adapter+0x9d/0x1ff
> [i2c_core] [  240.592269]  [<ffffffff811c5a5d>] ?
> kobject_uevent_env+0x3f8/0x43a [  240.592274]  [<ffffffffa01f0c35>] ?
> i2c_do_add_adapter+0x1ff/0x1ff [i2c_core] [  240.592280] 
> [<ffffffffa01f0c35>] ? i2c_do_add_adapter+0x1ff/0x1ff [i2c_core] [ 
> 240.592285]  [<ffffffff812768a2>] ? bus_for_each_dev+0x4b/0x7c
> [  240.592291]  [<ffffffffa01f0c35>] ? i2c_do_add_adapter+0x1ff/0x1ff
> [i2c_core] [  240.592296]  [<ffffffffa01ef37c>] ?
> i2c_for_each_dev+0x29/0x3f [i2c_core] [  240.592302]  [<ffffffffa01f001f>]
> ? i2c_register_driver+0x7a/0x9f [i2c_core] [  240.592312] 
> [<ffffffffa0061000>] ? 0xffffffffa0060fff
> [  240.592317]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x12a
> [  240.592321]  [<ffffffffa0061000>] ? 0xffffffffa0060fff
> [  240.592326]  [<ffffffff810832d3>] ? load_module+0x1ae4/0x1dcd
> [  240.592330]  [<ffffffff8107fe02>] ? free_notes_attrs+0x3c/0x3c
> [  240.592335]  [<ffffffff8108365a>] ? sys_init_module+0x9e/0xab
> [  240.592340]  [<ffffffff813882ec>] ? sysenter_dispatch+0x7/0x21
> [  240.592344] INFO: task modprobe:674 blocked for more than 120 seconds.
> [  240.592401] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> this message. [  240.592460] modprobe        D ffff88013fc93ec0     0   674
>    528 0x20020006 [  240.592463]  ffff880137e05100 0000000000000082
> ffff88013ae9f7b0 0000000000013ec0 [  240.592468]  ffff8801386d1fd8
> ffff8801386d1fd8 ffff880137e05100 ffffffffa01f20e0 [  240.592472] 
> ffff880137e05100 ffffffffa01f20e4 0000000000000002 0000000000000000 [ 
> 240.592476] Call Trace:
> [  240.592482]  [<ffffffff81381398>] ? schedule_preempt_disabled+0x5/0x6
> [  240.592486]  [<ffffffff813804a5>] ?
> __mutex_lock_common.isra.6+0x145/0x161 [  240.592493]  [<ffffffffa01f06a4>]
> ? i2c_register_adapter+0x1f6/0x1f6 [i2c_core] [  240.592496] 
> [<ffffffff813802d7>] ? mutex_lock+0x17/0x27
> [  240.592502]  [<ffffffffa01f06b5>] ? i2c_add_adapter+0x11/0x59 [i2c_core]
> [  240.592507]  [<ffffffffa02106aa>] ? __i2c_bit_add_bus+0x33/0x284
> [i2c_algo_bit] [  240.592546]  [<ffffffffa042fead>] ?
> radeon_i2c_create+0x1b8/0x1ea [radeon] [  240.592570]  [<ffffffffa041a011>]
> ? radeon_combios_i2c_init+0x5b/0x227 [radeon] [  240.592599] 
> [<ffffffffa042dbbc>] ? radeon_modeset_init+0x8da/0x916 [radeon] [ 
> 240.592629]  [<ffffffffa0432728>] ? radeon_ib_ring_tests+0x3b/0x9b [radeon]
> [  240.592652]  [<ffffffffa0412560>] ? radeon_driver_load_kms+0xb1/0xf5
> [radeon] [  240.592664]  [<ffffffffa0280e21>] ? drm_get_pci_dev+0x152/0x259
> [drm] [  240.592685]  [<ffffffffa04100f0>] ? radeon_pci_probe+0xd4/0xf6
> [radeon] [  240.592706]  [<ffffffffa0410102>] ? radeon_pci_probe+0xe6/0xf6
> [radeon] [  240.592711]  [<ffffffff811e1c50>] ? local_pci_probe+0x33/0x58
> [  240.592715]  [<ffffffff81278052>] ? driver_probe_device+0x1b0/0x1b0
> [  240.592719]  [<ffffffff811e1d2f>] ? pci_device_probe+0xba/0xde
> [  240.592723]  [<ffffffff81277f34>] ? driver_probe_device+0x92/0x1b0
> [  240.592727]  [<ffffffff812780a5>] ? __driver_attach+0x53/0x73
> [  240.592730]  [<ffffffff812768a2>] ? bus_for_each_dev+0x4b/0x7c
> [  240.592735]  [<ffffffff81277775>] ? bus_add_driver+0xd5/0x1f4
> [  240.592739]  [<ffffffffa0313000>] ? 0xffffffffa0312fff
> [  240.592743]  [<ffffffff812785cf>] ? driver_register+0x87/0xfe
> [  240.592747]  [<ffffffffa0313000>] ? 0xffffffffa0312fff
> [  240.592750]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x12a
> [  240.592754]  [<ffffffffa0313000>] ? 0xffffffffa0312fff
> [  240.592758]  [<ffffffff810832d3>] ? load_module+0x1ae4/0x1dcd
> [  240.592762]  [<ffffffff8107fe02>] ? free_notes_attrs+0x3c/0x3c
> [  240.592766]  [<ffffffff8108365a>] ? sys_init_module+0x9e/0xab
> [  240.592770]  [<ffffffff813882ec>] ? sysenter_dispatch+0x7/0x21
> 
> These are the hung tasks:
> 
> root       597  0.0  0.0   3988   688 ?        D    06:25   0:00
> /sbin/modprobe -b
> dmi:bvnIBM:bvr-[GGE146BUS-1.17]-:bd12/11/2009:svnIBM:pnIBMSystemx3650-[7979
> AC1]-:pvr:rvnIBM:rnSystemPlanar:rvr:cvnIBM:ct17:cvr: root       674  0.0 
> 0.0   5104  1736 ?        D    06:25   0:00 /sbin/modprobe -b
> pci:v00001002d0000515Esv00001014sd00000305bc03sc00i00
> 
> I've tried debian's 3.9 and 3.10 kernel.
> 
> Is this a known issue? Maybe I need to provide some kind of boot parameter?

I've done a reinstall because I goofed and booted the wrong pxe image. It was
running x86 instead of amd64. All fixed now, and the problem still persists.

[  240.436030] INFO: task modprobe:524 blocked for more than 120 seconds.
[  240.436093] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.436153] modprobe        D ffff88013fd93fc0     0   524    521 0x00000004
[  240.436158]  ffff880138a5e100 0000000000000082 0000000000013fc0 ffff880139659fd8
[  240.436163]  ffff880139659fd8 ffff880138a5e100 ffff880139659cd0 ffff880139a03064
[  240.436168]  ffff880139a03060 0000000000000000 ffff880139a03068 ffffffff8137c77a
[  240.436172] Call Trace:
[  240.436183]  [<ffffffff8137c77a>] ? schedule_preempt_disabled+0x5/0x6
[  240.436187]  [<ffffffff8137b78b>] ? __mutex_lock_common.isra.9+0x152/0x1e2
[  240.436193]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.436202]  [<ffffffff8137b607>] ? mutex_lock+0x16/0x25
[  240.436206]  [<ffffffff812716ba>] ? __driver_attach+0x28/0x73
[  240.436210]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.436215]  [<ffffffff8126fe37>] ? bus_for_each_dev+0x6b/0x75
[  240.436219]  [<ffffffff81270d95>] ? bus_add_driver+0xeb/0x1f0
[  240.436223]  [<ffffffff81271b6a>] ? driver_register+0x82/0xeb
[  240.436235]  [<ffffffffa0225000>] ? 0xffffffffa0224fff
[  240.436243]  [<ffffffffa022501b>] ? shpcd_init+0x1b/0x1000 [shpchp]
[  240.436247]  [<ffffffffa0225000>] ? 0xffffffffa0224fff
[  240.436253]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x106
[  240.436259]  [<ffffffff81080c2d>] ? load_module+0x127a/0x1dfc
[  240.436263]  [<ffffffff8107dc20>] ? store_uevent+0x32/0x32
[  240.436268]  [<ffffffff8108184b>] ? SyS_init_module+0x9c/0xa9
[  240.436273]  [<ffffffff813821e9>] ? system_call_fastpath+0x16/0x1b
[  240.436278] INFO: task modprobe:535 blocked for more than 120 seconds.
[  240.436335] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.436394] modprobe        D ffff88013fd93fc0     0   535    526 0x00000004
[  240.436398]  ffff8801386dd770 0000000000000086 0000000000013fc0 ffff880138489fd8
[  240.436403]  ffff880138489fd8 ffff8801386dd770 ffff880138489cd0 ffff880139a03064
[  240.436407]  ffff880139a03060 0000000000000000 ffff880139a03068 ffffffff8137c77a
[  240.436411] Call Trace:
[  240.436416]  [<ffffffff8137c77a>] ? schedule_preempt_disabled+0x5/0x6
[  240.436420]  [<ffffffff8137b78b>] ? __mutex_lock_common.isra.9+0x152/0x1e2
[  240.436424]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.436428]  [<ffffffff8137b607>] ? mutex_lock+0x16/0x25
[  240.436431]  [<ffffffff812716ba>] ? __driver_attach+0x28/0x73
[  240.436435]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.436439]  [<ffffffff8126fe37>] ? bus_for_each_dev+0x6b/0x75
[  240.436443]  [<ffffffff81270d95>] ? bus_add_driver+0xeb/0x1f0
[  240.436447]  [<ffffffff81271b6a>] ? driver_register+0x82/0xeb
[  240.436451]  [<ffffffffa02c9000>] ? 0xffffffffa02c8fff
[  240.436461]  [<ffffffffa02c905e>] ? ioat_init_module+0x5e/0x1000 [ioatdma]
[  240.436465]  [<ffffffffa02c9000>] ? 0xffffffffa02c8fff
[  240.436468]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x106
[  240.436473]  [<ffffffff81080c2d>] ? load_module+0x127a/0x1dfc
[  240.436476]  [<ffffffff8107dc20>] ? store_uevent+0x32/0x32
[  240.436482]  [<ffffffff8108184b>] ? SyS_init_module+0x9c/0xa9
[  240.436486]  [<ffffffff813821e9>] ? system_call_fastpath+0x16/0x1b
[  240.436489] INFO: task modprobe:536 blocked for more than 120 seconds.
[  240.436547] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.436606] modprobe        D ffff88013fc93fc0     0   536    527 0x00000004
[  240.436610]  ffff880138a28770 0000000000000082 0000000000013fc0 ffff88013848bfd8
[  240.436614]  ffff88013848bfd8 ffff880138a28770 ffff88013848bcd8 ffff880139a03064
[  240.436618]  ffff880139a03060 0000000000000000 ffff880139a03068 ffffffff8137c77a
[  240.436622] Call Trace:
[  240.436627]  [<ffffffff8137c77a>] ? schedule_preempt_disabled+0x5/0x6
[  240.436631]  [<ffffffff8137b78b>] ? __mutex_lock_common.isra.9+0x152/0x1e2
[  240.436635]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.436639]  [<ffffffff8137b607>] ? mutex_lock+0x16/0x25
[  240.436643]  [<ffffffff812716ba>] ? __driver_attach+0x28/0x73
[  240.436647]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.436651]  [<ffffffff8126fe37>] ? bus_for_each_dev+0x6b/0x75
[  240.436655]  [<ffffffff81270d95>] ? bus_add_driver+0xeb/0x1f0
[  240.436659]  [<ffffffff81271b6a>] ? driver_register+0x82/0xeb
[  240.436663]  [<ffffffffa00c5000>] ? 0xffffffffa00c4fff
[  240.436669]  [<ffffffffa00c502d>] ? i5000_init+0x2d/0x1000 [i5000_edac]
[  240.436673]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x106
[  240.436677]  [<ffffffff81080c2d>] ? load_module+0x127a/0x1dfc
[  240.436681]  [<ffffffff8107dc20>] ? store_uevent+0x32/0x32
[  240.436686]  [<ffffffff8108184b>] ? SyS_init_module+0x9c/0xa9
[  240.436690]  [<ffffffff813821e9>] ? system_call_fastpath+0x16/0x1b
[  240.436696] INFO: task modprobe:566 blocked for more than 120 seconds.
[  240.436754] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.436813] modprobe        D ffff88013fd93fc0     0   566    553 0x00000004
[  240.436817]  ffff88013961c870 0000000000000082 0000000000013fc0 ffff880139739fd8
[  240.436821]  ffff880139739fd8 ffff88013961c870 ffff880139739b88 ffffffffa02522f4
[  240.436825]  ffffffffa02522f0 0000000000000000 ffffffffa02522f8 ffffffff8137c77a
[  240.436829] Call Trace:
[  240.436835]  [<ffffffff8137c77a>] ? schedule_preempt_disabled+0x5/0x6
[  240.436839]  [<ffffffff8137b78b>] ? __mutex_lock_common.isra.9+0x152/0x1e2
[  240.436844]  [<ffffffff8137b607>] ? mutex_lock+0x16/0x25
[  240.436851]  [<ffffffffa024fabe>] ? i2c_register_adapter+0x259/0x284 [i2c_core]
[  240.436858]  [<ffffffffa01ef9e0>] ? i801_probe+0x306/0x3f3 [i2c_i801]
[  240.436863]  [<ffffffff8137ce1c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
[  240.436868]  [<ffffffff81279708>] ? __pm_runtime_resume+0x5d/0x69
[  240.436874]  [<ffffffff811dadf6>] ? local_pci_probe+0x33/0x58
[  240.436877]  [<ffffffff811daed5>] ? pci_device_probe+0xba/0xde
[  240.436882]  [<ffffffff81271540>] ? driver_probe_device+0x92/0x1b3
[  240.436886]  [<ffffffff812716e5>] ? __driver_attach+0x53/0x73
[  240.436890]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.436894]  [<ffffffff8126fe37>] ? bus_for_each_dev+0x6b/0x75
[  240.436898]  [<ffffffff81270d95>] ? bus_add_driver+0xeb/0x1f0
[  240.436902]  [<ffffffff81271b6a>] ? driver_register+0x82/0xeb
[  240.436907]  [<ffffffffa01fc000>] ? 0xffffffffa01fbfff
[  240.436912]  [<ffffffffa01fc0ab>] ? i2c_i801_init+0xab/0x1000 [i2c_i801]
[  240.436917]  [<ffffffffa01fc000>] ? 0xffffffffa01fbfff
[  240.436920]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x106
[  240.436925]  [<ffffffff81080c2d>] ? load_module+0x127a/0x1dfc
[  240.436929]  [<ffffffff8107dc20>] ? store_uevent+0x32/0x32
[  240.436934]  [<ffffffff8108184b>] ? SyS_init_module+0x9c/0xa9
[  240.436938]  [<ffffffff813821e9>] ? system_call_fastpath+0x16/0x1b
[  240.436945] INFO: task modprobe:598 blocked for more than 120 seconds.
[  240.437002] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.437061] modprobe        D ffff8801387e1080     0   598    584 0x00000004
[  240.437065]  ffff8801387e1080 0000000000000086 0000000000013fc0 ffff880137dfdfd8
[  240.437069]  ffff880137dfdfd8 ffff880138911400 0000000000000000 ffff880138911790
[  240.437073]  0000000000000000 0000000000000000 0000000000000000 ffffffffa01ef2f5
[  240.437077] Call Trace:
[  240.437083]  [<ffffffffa01ef2f5>] ? i801_transaction+0xa1/0xe4 [i2c_i801]
[  240.437089]  [<ffffffff81056b46>] ? finish_wait+0x60/0x60
[  240.437094]  [<ffffffffa01f01a0>] ? i801_access+0x6d3/0x876 [i2c_i801]
[  240.437099]  [<ffffffff8137ce1c>] ? _raw_spin_unlock_irqrestore+0xc/0xd
[  240.437105]  [<ffffffff81136d78>] ? ep_poll_callback+0xde/0xf7
[  240.437111]  [<ffffffffa024eb8c>] ? i2c_smbus_xfer+0xcb/0x121 [i2c_core]
[  240.437117]  [<ffffffffa024fe55>] ? i2c_default_probe+0x95/0xf7 [i2c_core]
[  240.437123]  [<ffffffffa024ffd6>] ? i2c_do_add_adapter+0x11f/0x1fe [i2c_core]
[  240.437128]  [<ffffffff810f5a70>] ? kfree+0x3a/0x6d
[  240.437134]  [<ffffffff811bfa56>] ? kobject_uevent_env+0x3d7/0x40f
[  240.437140]  [<ffffffffa02500be>] ? __process_new_adapter+0x9/0x9 [i2c_core]
[  240.437144]  [<ffffffff8126fe37>] ? bus_for_each_dev+0x6b/0x75
[  240.437150]  [<ffffffffa02500be>] ? __process_new_adapter+0x9/0x9 [i2c_core]
[  240.437155]  [<ffffffffa024e48e>] ? i2c_for_each_dev+0x2a/0x43 [i2c_core]
[  240.437161]  [<ffffffffa024f222>] ? i2c_register_driver+0x95/0x99 [i2c_core]
[  240.437165]  [<ffffffffa0032000>] ? 0xffffffffa0031fff
[  240.437169]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x106
[  240.437174]  [<ffffffff81080c2d>] ? load_module+0x127a/0x1dfc
[  240.437177]  [<ffffffff8107dc20>] ? store_uevent+0x32/0x32
[  240.437182]  [<ffffffff8108184b>] ? SyS_init_module+0x9c/0xa9
[  240.437186]  [<ffffffff813821e9>] ? system_call_fastpath+0x16/0x1b
[  240.437190] INFO: task modprobe:627 blocked for more than 120 seconds.
[  240.437247] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.437307] modprobe        D ffff88013fd53fc0     0   627    622 0x00000006
[  240.437310]  ffff8801389067b0 0000000000000082 0000000000013fc0 ffff880137e9ffd8
[  240.437315]  ffff880137e9ffd8 ffff8801389067b0 ffff880137e9fa48 ffffffffa02522f4
[  240.437319]  ffffffffa02522f0 0000000000000000 ffffffffa02522f8 ffffffff8137c77a
[  240.437323] Call Trace:
[  240.437329]  [<ffffffff8137c77a>] ? schedule_preempt_disabled+0x5/0x6
[  240.437333]  [<ffffffff8137b78b>] ? __mutex_lock_common.isra.9+0x152/0x1e2
[  240.437339]  [<ffffffffa024fae9>] ? i2c_register_adapter+0x284/0x284 [i2c_core]
[  240.437343]  [<ffffffff8137b607>] ? mutex_lock+0x16/0x25
[  240.437349]  [<ffffffffa024fafa>] ? i2c_add_adapter+0x11/0x5b [i2c_core]
[  240.437354]  [<ffffffffa026e699>] ? __i2c_bit_add_bus+0x33/0x284 [i2c_algo_bit]
[  240.437397]  [<ffffffffa049aa7f>] ? radeon_i2c_create+0x1be/0x1f3 [radeon]
[  240.437427]  [<ffffffffa04852b1>] ? radeon_combios_i2c_init+0x5e/0x215 [radeon]
[  240.437461]  [<ffffffffa049819c>] ? radeon_modeset_init+0x1fe/0x8f8 [radeon]
[  240.437487]  [<ffffffffa047c939>] ? radeon_debugfs_add_files+0xc2/0xc9 [radeon]
[  240.437515]  [<ffffffffa047d722>] ? radeon_driver_load_kms+0xb2/0xf8 [radeon]
[  240.437527]  [<ffffffffa02d8e35>] ? drm_get_pci_dev+0x152/0x262 [drm]
[  240.437531]  [<ffffffff810f5a70>] ? kfree+0x3a/0x6d
[  240.437535]  [<ffffffff811dadf6>] ? local_pci_probe+0x33/0x58
[  240.437539]  [<ffffffff811daed5>] ? pci_device_probe+0xba/0xde
[  240.437543]  [<ffffffff81271540>] ? driver_probe_device+0x92/0x1b3
[  240.437547]  [<ffffffff812716e5>] ? __driver_attach+0x53/0x73
[  240.437550]  [<ffffffff81271692>] ? __device_attach+0x31/0x31
[  240.437554]  [<ffffffff8126fe37>] ? bus_for_each_dev+0x6b/0x75
[  240.437559]  [<ffffffff81270d95>] ? bus_add_driver+0xeb/0x1f0
[  240.437562]  [<ffffffff81271b6a>] ? driver_register+0x82/0xeb
[  240.437566]  [<ffffffffa0524000>] ? 0xffffffffa0523fff
[  240.437570]  [<ffffffff8100209e>] ? do_one_initcall+0x74/0x106
[  240.437574]  [<ffffffff81080c2d>] ? load_module+0x127a/0x1dfc
[  240.437578]  [<ffffffff8107dc20>] ? store_uevent+0x32/0x32
[  240.437583]  [<ffffffff8108184b>] ? SyS_init_module+0x9c/0xa9
[  240.437587]  [<ffffffff813821e9>] ? system_call_fastpath+0x16/0x1b

Since I had to update my pxe setup, I updated to the latest debian netboot
image, and a newer base install, which came with a 3.2 kernel which doesn't
appear to have this issue.


> Thanks.
-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net

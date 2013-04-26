Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3DZM7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:59:19 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:37007 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751387Ab3DZM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:59:17 -0400
Message-ID: <517A7A23.4050705@newflow.co.uk>
Date: Fri, 26 Apr 2013 13:59:15 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: BUG: Unable to handle kernel NULL pointer dereference (cpsw driver)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just got this on my AM335x board.

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.9.0-rc8-00020-g6e8f1be-dirty (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot 2012.11) ) #210 Thu Apr 25 13:00:09 BST 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: Newflow AM335x NanoBone
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES1.0 (neon )
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: console=ttyO0,115200n8 noinitrd ip=off mem=256M rootwait=1 ubi.mtd=7,2048 rootfstype=ubifs root=ubi0:rootfs
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 255MB = 255MB total
[    0.000000] Memory: 247484k/247484k available, 14660k reserved, 0K highmem

...

[    2.592307] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.598775] davinci_mdio 4a101000.mdio: detected phy mask fffffffc
[    2.608358] libphy: 4a101000.mdio: probed
[    2.612692] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver SMSC LAN8710/LAN8720
[    2.622390] davinci_mdio 4a101000.mdio: phy[1]: device 4a101000.mdio:01, driver SMSC LAN8710/LAN8720
[    2.632354] Detected MACID = 00:18:31:93:44:39
[    2.639792] cpsw: Detected MACID = 00:18:31:93:44:3a
[    2.647041] Unable to handle kernel NULL pointer dereference at virtual address 000000bc
[    2.655613] pgd = c0004000
[    2.658475] [000000bc] *pgd=00000000
[    2.662298] Internal error: Oops: 805 [#1] ARM
[    2.667005] CPU: 0    Not tainted  (3.9.0-rc8-00020-g6e8f1be-dirty #210)
[    2.674109] PC is at rtnl_fill_ifinfo+0x380/0x7d0
[    2.679090] LR is at dev_get_stats+0x64/0xb0
[    2.683605] pc : [<c0337610>]    lr : [<c032be8c>]    psr: 40000113
[    2.683605] sp : cf04dca0  ip : 00000000  fp : 00000000
[    2.695742] r10: cf331800  r9 : cf3318b4  r8 : c05d2cdc
[    2.701263] r7 : cf04dca8  r6 : cf31e000  r5 : cf04dd84  r4 : cf17fbc0
[    2.708165] r3 : 000000b8  r2 : 00000000  r1 : 00000017  r0 : cf17fbc0
[    2.715069] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    2.722797] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    2.728870] Process swapper (pid: 1, stack limit = 0xcf04c238)
[    2.735037] Stack: (0xcf04dca0 to 0xcf04e000)
[    2.739649] dca0: 00000010 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.748297] dcc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.756949] dce0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.765600] dd00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.774251] dd20: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.782901] dd40: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.791548] dd60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.800197] dd80: 000000d0 00000001 00000000 00000000 cf31e000 ffffffff 00000010 cf17fbc0
[    2.808847] dda0: 00000000 40000000 00000000 c0339c38 00000000 ffffffff 00000000 00000000
[    2.817499] ddc0: 00000000 00000000 cf31e000 cf31e000 c05d2488 c032d128 cf31e000 cf0ba010
[    2.826151] dde0: cf31edc0 c0b01e20 cf0ba000 c0444958 cf31e800 c032d1c8 c04448b8 c02967bc
[    2.834802] de00: cf0b9940 cf31edc0 cf04b340 cf31ee20 cf0ba010 cf0ba000 cf31ee20 cf31e800
[    2.843453] de20: cf0bcea0 cf0ba010 d0892800 d0892a00 d0892a20 d0892a40 d0892a60 d08928c0
[    2.852105] de40: d08928e0 00000008 00000001 0000003c 4a102000 4a102000 00002000 00000010
[    2.860756] de60: 00000001 cf31ea80 d0892d00 0000000a 00000400 00000002 00000008 00000002
[    2.869406] de80: c0b00a7c cf0ba010 c0b00a7c c05dea70 00000000 c0b00a8c c058664c c05cc984
[    2.878057] dea0: 00000000 c02408b8 c02408a0 c023f658 cf0ba010 cf0ba010 cf0ba010 c05cc984
[    2.886708] dec0: cf0ba044 00000000 c057194c c058664c 0000006c c023f920 c05cc984 c023f88c
[    2.895361] dee0: cf04dee8 c023db1c cf0444a8 cf0ac210 c057194c c05cc984 c05c6580 cf2f6c40
[    2.904013] df00: 00000000 c023e400 c050f208 c05cc984 c05cc984 00000007 c057d0c0 00000000
[    2.912664] df20: c057194c c023ff10 00000000 c057d0e0 00000007 c057d0c0 00000000 c057194c
[    2.921313] df40: 0000006c c055281c 00000007 00000007 60000113 c057d0dc c057d0e0 00000007
[    2.929964] df60: c057d0c0 c05e3d80 c0552168 0000006c 00000000 c05529d8 00000007 00000007
[    2.938614] df80: c0552168 00000000 00000000 c0418e84 00000000 00000000 00000000 00000000
[    2.947266] dfa0: 00000000 c0418e8c 00000000 c00141f0 00000000 00000000 00000000 00000000
[    2.955916] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.964567] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 f7dfdfff f7fadfff
[    2.973233] [<c0337610>] (rtnl_fill_ifinfo+0x380/0x7d0) from [<c0339c38>] (rtmsg_ifinfo+0x60/0xd4)
[    2.982719] [<c0339c38>] (rtmsg_ifinfo+0x60/0xd4) from [<c032d128>] (register_netdevice+0x430/0x4bc)
[    2.992384] [<c032d128>] (register_netdevice+0x430/0x4bc) from [<c032d1c8>] (register_netdev+0x14/0x24)
[    3.002333] [<c032d1c8>] (register_netdev+0x14/0x24) from [<c02967bc>] (cpsw_probe+0xd30/0xf60)
[    3.011546] [<c02967bc>] (cpsw_probe+0xd30/0xf60) from [<c02408b8>] (platform_drv_probe+0x18/0x1c)
[    3.021028] [<c02408b8>] (platform_drv_probe+0x18/0x1c) from [<c023f658>] (driver_probe_device+0x138/0x36c)
[    3.031336] [<c023f658>] (driver_probe_device+0x138/0x36c) from [<c023f920>] (__driver_attach+0x94/0x98)
[    3.041379] [<c023f920>] (__driver_attach+0x94/0x98) from [<c023db1c>] (bus_for_each_dev+0x68/0x8c)
[    3.050955] [<c023db1c>] (bus_for_each_dev+0x68/0x8c) from [<c023e400>] (bus_add_driver+0x1c0/0x25c)
[    3.060622] [<c023e400>] (bus_add_driver+0x1c0/0x25c) from [<c023ff10>] (driver_register+0x78/0x144)
[    3.070291] [<c023ff10>] (driver_register+0x78/0x144) from [<c055281c>] (do_one_initcall+0x98/0x16c)
[    3.079957] [<c055281c>] (do_one_initcall+0x98/0x16c) from [<c05529d8>] (kernel_init_freeable+0xe8/0x1ac)
[    3.090088] [<c05529d8>] (kernel_init_freeable+0xe8/0x1ac) from [<c0418e8c>] (kernel_init+0x8/0xe4)
[    3.099676] [<c0418e8c>] (kernel_init+0x8/0xe4) from [<c00141f0>] (ret_from_fork+0x14/0x24)
[    3.108514] Code: e1a00004 e597c000 e589c004 e597c008 (e583c004)
[    3.115012] ---[ end trace 798c03cb45c865a6 ]---
[    3.119927] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    3.119927]

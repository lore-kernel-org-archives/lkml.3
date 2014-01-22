Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaAVXto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:49:44 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:49354 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbaAVXtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:49:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140122164100.GE15937@n2100.arm.linux.org.uk>
References: <CACUGKYPXficVuqDgy6_Tnh9b-VOXDNK=+nqb6U5O6NpcZOGGpQ@mail.gmail.com>
	<20140122164100.GE15937@n2100.arm.linux.org.uk>
Date: Wed, 22 Jan 2014 15:49:39 -0800
Message-ID: <CACUGKYPakuAGOWb+RetqNhEBvRP-+Pmtu2_4a2zuV0bFR0QJRA@mail.gmail.com>
Subject: Re: Internal error: Oops: 17 [#1] ARM
From: John Tobias <john.tobias.ph@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Just to confirm that the error I posted previously exist in 3.13
released. Just be noted that some patches related to eMMC/sdhci has
been applied in order to boot the 3.13 on my board.
Addition to that, I was getting additional errors (please see below):
- It happened during the reboot.

Cc'ng Dong Aisheng.



[   11.229139] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   11.237244] pgd = 80004000
[   11.239956] [00000000] *pgd=00000000
[   11.243555] Internal error: Oops: 17 [#1] ARM
[   11.247917] Modules linked in: bt8xxx(O) sd8xxx(O) mlan(PO)
[   11.253561] CPU: 0 PID: 37 Comm: mmcqd/0 Tainted: P           O 3.13.0 #5
[   11.260355] task: bfb00000 ti: bfb6e000 task.ti: bfb6e000
[   11.265766] PC is at sg_next+0xc/0x34
[   11.269440] LR is at sdhci_send_command+0x990/0xf50
[   11.274323] pc : [<802a3874>]    lr : [<803a2bc8>]    psr: 200f0093
[   11.274323] sp : bfb6fd20  ip : bfb6fd30  fp : bfb6fd2c
[   11.285803] r10: 00000003  r9 : bfa67440  r8 : bf957010
[   11.291030] r7 : 808487bc  r6 : 600f0013  r5 : bfb43d4c  r4 : bfb43ce4
[   11.297560] r3 : 81784e62  r2 : 00000000  r1 : bfb6a800  r0 : 00000000
[   11.304091] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[   11.311490] Control: 10c53c7d  Table: beeec059  DAC: 00000015
[   11.317239] Process mmcqd/0 (pid: 37, stack limit = 0xbfb6e238)
[   11.323162] Stack: (0xbfb6fd20 to 0xbfb70000)
[   11.327530] fd20: bfb6fd8c bfb6fd30 803a2bc8 802a3874 00000002
00000000 bfb6fd5c bfb6fd48
[   11.335713] fd40: 8001d1d0 00000002 80e04788 80845840 bfb6fd8c
bfb6a800 803a7558 8001d190
[   11.343896] fd60: 803a7418 bfa67000 bfb43c6c bfa67470 600f0013
bfa67440 0000002d bfa67000
[   11.352079] fd80: bfb6fdb4 bfb6fd90 803a3a48 803a2244 bfb43c6c
bfa67000 8089fed0 bfb43d4c
[   11.360262] fda0: bfb6fe7c bfb43ec0 bfb6fdec bfb6fdb8 8038d3e0
803a388c bfb6fdd4 bfb6fdc8
[   11.368444] fdc0: 8005b7c4 bfa673d8 bfb43e18 00000000 00000001
bfb43d8c 00000001 bfb6fe7c
[   11.376626] fde0: bfb6fe3c bfb6fdf0 8038e538 8038d2c4 bfb6fe3c
bfb43da0 8039d0a4 00000000
[   11.384809] fe00: bfb00000 8005344c bfb6fe08 bfb6fe08 bfb6fe34
bfbfc000 bfb43c24 bfb6a000
[   11.392992] fe20: bfb44b60 bfb43c68 bfb6a000 bfb43c6c bfb6feac
bfb6fe40 8039e214 8038e278
[   11.401175] fe40: bfb44b60 bfb43c24 bfb6fe74 bfb6fe58 80292194
80276c0c bfb4fc00 bef024c0
[   11.409357] fe60: 00000000 00000000 00000000 bfb6fe78 bfb43c00
bfbfc000 00000002 00000080
[   11.417541] fe80: 00000000 bfb6a000 bfbfc000 00000000 00000000
bfb43c24 bfb43c00 bfa67000
[   11.425724] fea0: bfb6feec bfb6feb0 8039edc0 8039e158 00000000
122c8000 bfb6fed4 bfb6fec8
[   11.433908] fec0: 8005b7c4 bfb44b60 bfb6e000 00000000 122c8000
00000001 bfbfc000 bfb43c24
[   11.442091] fee0: bfb6ff24 bfb6fef0 8039f830 8039ebf0 bfb6e030
bfb43c2c 8039f780 bfb51a80
[   11.450273] ff00: 00000000 bfb43c24 8039f780 00000000 00000000
00000000 bfb6ffac bfb6ff28
[   11.458456] ff20: 80043658 8039f78c bfb6ff44 00000000 8005b7c4
bfb43c24 00000000 00000001
[   11.466639] ff40: dead4ead ffffffff ffffffff 808a8990 00000000
00000000 807239a4 bfb6ff5c
[   11.474822] ff60: bfb6ff5c 00000000 00000001 dead4ead ffffffff
ffffffff 808a8990 00000000
[   11.483006] ff80: 00000000 807239a4 bfb6ff88 bfb6ff88 bfb51a80
80043574 00000000 00000000
[   11.491188] ffa0: 00000000 bfb6ffb0 8000f348 80043580 00000000
00000000 00000000 00000000
[   11.499370] ffc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   11.507552] ffe0: 00000000 00000000 00000000 00000000 00000013
00000000 55055703 d17847e7
[   11.515729] Backtrace:
[   11.518203] [<802a3868>] (sg_next+0x0/0x34) from [<803a2bc8>]
(sdhci_send_command+0x990/0xf50)
[   11.526826] [<803a2238>] (sdhci_send_command+0x0/0xf50) from
[<803a3a48>] (sdhci_request+0x1c8/0x278)
[   11.536056] [<803a3880>] (sdhci_request+0x0/0x278) from
[<8038d3e0>] (mmc_start_request+0x128/0x24c)
[   11.545190]  r9:bfb43ec0 r8:bfb6fe7c r7:bfb43d4c r6:8089fed0 r5:bfa67000
r4:bfb43c6c
[   11.553118] [<8038d2b8>] (mmc_start_request+0x0/0x24c) from
[<8038e538>] (mmc_start_req+0x2cc/0x378)
[   11.562251]  r8:bfb6fe7c r7:00000001 r6:bfb43d8c r5:00000001 r4:00000000
[   11.569033] [<8038e26c>] (mmc_start_req+0x0/0x378) from
[<8039e214>] (mmc_blk_issue_rw_rq+0xc8/0xa98)
[   11.578261] [<8039e14c>] (mmc_blk_issue_rw_rq+0x0/0xa98) from
[<8039edc0>] (mmc_blk_issue_rq+0x1dc/0x4cc)
[   11.587836] [<8039ebe4>] (mmc_blk_issue_rq+0x0/0x4cc) from
[<8039f830>] (mmc_queue_thread+0xb0/0x14c)
[   11.597069] [<8039f780>] (mmc_queue_thread+0x0/0x14c) from
[<80043658>] (kthread+0xe4/0xf8)
[   11.605433] [<80043574>] (kthread+0x0/0xf8) from [<8000f348>]
(ret_from_fork+0x14/0x20)
[   11.613439]  r7:00000000 r6:00000000 r5:80043574 r4:bfb51a80
[   11.619164] Code: e89da800 e1a0c00d e92dd800 e24cb004 (e5903000)
[   11.625266] ---[ end trace e52024b248222184 ]---
[   11.629889] Kernel panic - not syncing: Fatal exception
[   32.238311] BUG: spinlock lockup suspected on CPU#0, mmcqd/0/37
[   32.244246]  lock: 0xbfa67470, .magic: dead4ead, .owner:
mmcqd/0/37, .owner_cpu: 0
[   32.251825] CPU: 0 PID: 37 Comm: mmcqd/0 Tainted: P      D    O 3.13.0 #5
[   32.258616] Backtrace:
[   32.261096] [<80012ef8>] (dump_backtrace+0x0/0x118) from
[<80013238>] (show_stack+0x20/0x24)
[   32.269536]  r6:3b4181c0 r5:bfa67470 r4:bfb00000 r3:00000000
[   32.275265] [<80013218>] (show_stack+0x0/0x24) from [<805b4cdc>]
(dump_stack+0x24/0x28)
[   32.283287] [<805b4cb8>] (dump_stack+0x0/0x28) from [<805b2680>]
(spin_dump+0x94/0x9c)
[   32.291215] [<805b25ec>] (spin_dump+0x0/0x9c) from [<800603fc>]
(do_raw_spin_lock+0x118/0x14c)
[   32.299827]  r5:00000000 r4:3b4181c0
[   32.303442] [<800602e4>] (do_raw_spin_lock+0x0/0x14c) from
[<805bb8a0>] (_raw_spin_lock_irqsave+0x58/0x64)
[   32.313109] [<805bb848>] (_raw_spin_lock_irqsave+0x0/0x64) from
[<803a4c40>] (sdhci_timeout_timer+0x24/0xd0)
[   32.322936]  r6:bfb6f918 r5:bfa67470 r4:bfa67440
[   32.327612] [<803a4c1c>] (sdhci_timeout_timer+0x0/0xd0) from
[<8002ef6c>] (call_timer_fn+0x94/0x17c)
[   32.336745]  r6:bfb6f918 r5:bfa67528 r4:80898454 r3:00000000
[   32.342471] [<8002eed8>] (call_timer_fn+0x0/0x17c) from
[<8002f594>] (run_timer_softirq+0x1b0/0x258)
[   32.351614] [<8002f3e4>] (run_timer_softirq+0x0/0x258) from
[<80027bd0>] (__do_softirq+0x148/0x314)
[   32.360666] [<80027a88>] (__do_softirq+0x0/0x314) from [<800281b8>]
(irq_exit+0xc8/0x110)
[   32.368852] [<800280f0>] (irq_exit+0x0/0x110) from [<8000fc64>]
(handle_IRQ+0x4c/0x94)
[   32.376770]  r4:80872034 r3:00000120
[   32.380384] [<8000fc18>] (handle_IRQ+0x0/0x94) from [<800085a0>]
(gic_handle_irq+0x3c/0x64)
[   32.388736]  r6:bfb6fa68 r5:80842e64 r4:c080e10c r3:000000a0
[   32.394461] [<80008564>] (gic_handle_irq+0x0/0x64) from
[<80013d84>] (__irq_svc+0x44/0x58)
[   32.402729] Exception stack(0xbfb6fa68 to 0xbfb6fab0)
[   32.407789] fa60:                   000355f9 ffffffff 000025ed
80295740 00000048 80871ff4
[   32.415974] fa80: 00002580 00002648 00000001 808a6448 808a5fc4
bfb6fad4 bfb6fab0 bfb6fab0
[   32.424154] faa0: 805b145c 80295770 200f0113 ffffffff
[   32.429207]  r7:bfb6fa9c r6:ffffffff r5:200f0113 r4:80295770
[   32.434937] [<805b1294>] (panic+0x0/0x1dc) from [<800135c8>]
(die+0x38c/0x3a0)
[   32.442160]  r3:00000001 r2:00000000 r1:00000001 r0:80720a90
[   32.447879]  r7:bfb6e000
[   32.450438] [<8001323c>] (die+0x0/0x3a0) from [<805b1284>]
(__do_kernel_fault.part.11+0x74/0x84)
[   32.459239] [<805b1210>] (__do_kernel_fault.part.11+0x0/0x84) from
[<80019d8c>] (do_page_fault+0x1cc/0x3d4)
[   32.468981]  r7:00000017 r3:bfb6fcd8
[   32.472594] [<80019bc0>] (do_page_fault+0x0/0x3d4) from
[<80008440>] (do_DataAbort+0x48/0xa8)
[   32.481127] [<800083f8>] (do_DataAbort+0x0/0xa8) from [<80013d1c>]
(__dabt_svc+0x3c/0x60)
[   32.489307] Exception stack(0xbfb6fcd8 to 0xbfb6fd20)
[   32.494362] fcc0:
    00000000 bfb6a800
[   32.502545] fce0: 00000000 81784e62 bfb43ce4 bfb43d4c 600f0013
808487bc bf957010 bfa67440
[   32.510730] fd00: 00000003 bfb6fd2c bfb6fd30 bfb6fd20 803a2bc8
802a3874 200f0093 ffffffff
[   32.518908]  r8:bf957010 r7:bfb6fd0c r6:ffffffff r5:200f0093 r4:802a3874
[   32.525696] [<802a3868>] (sg_next+0x0/0x34) from [<803a2bc8>]
(sdhci_send_command+0x990/0xf50)
[   32.534317] [<803a2238>] (sdhci_send_command+0x0/0xf50) from
[<803a3a48>] (sdhci_request+0x1c8/0x278)
[   32.543548] [<803a3880>] (sdhci_request+0x0/0x278) from
[<8038d3e0>] (mmc_start_request+0x128/0x24c)
[   32.552681]  r9:bfb43ec0 r8:bfb6fe7c r7:bfb43d4c r6:8089fed0 r5:bfa67000
r4:bfb43c6c
[   32.560605] [<8038d2b8>] (mmc_start_request+0x0/0x24c) from
[<8038e538>] (mmc_start_req+0x2cc/0x378)
[   32.569738]  r8:bfb6fe7c r7:00000001 r6:bfb43d8c r5:00000001 r4:00000000
[   32.576520] [<8038e26c>] (mmc_start_req+0x0/0x378) from
[<8039e214>] (mmc_blk_issue_rw_rq+0xc8/0xa98)
[   32.585749] [<8039e14c>] (mmc_blk_issue_rw_rq+0x0/0xa98) from
[<8039edc0>] (mmc_blk_issue_rq+0x1dc/0x4cc)
[   32.595324] [<8039ebe4>] (mmc_blk_issue_rq+0x0/0x4cc) from
[<8039f830>] (mmc_queue_thread+0xb0/0x14c)
[   32.604556] [<8039f780>] (mmc_queue_thread+0x0/0x14c) from
[<80043658>] (kthread+0xe4/0xf8)
[   32.612916] [<80043574>] (kthread+0x0/0xf8) from [<8000f348>]
(ret_from_fork+0x14/0x20)
[   32.620922]  r7:00000000 r6:00000000 r5:80043574 r4:bfb51a80
[   32.626642] mmc0: Timeout waiting for hardware interrupt.
[   32.632066] Unable to handle kernel NULL pointer dereference at
virtual address 0000000c
[   32.640161] pgd = 80004000
[   32.642871] [0000000c] *pgd=00000000
[   32.646468] Internal error: Oops: 17 [#2] ARM
[   32.650830] Modules linked in: bt8xxx(O) sd8xxx(O) mlan(PO)
[   32.656474] CPU: 0 PID: 37 Comm: mmcqd/0 Tainted: P      D    O 3.13.0 #5
[   32.663266] task: bfb00000 ti: bfb6e000 task.ti: bfb6e000
[   32.668674] PC is at arm_dma_sync_sg_for_cpu+0x44/0x8c
[   32.673817] LR is at arm_dma_sync_sg_for_cpu+0x68/0x8c
[   32.678961] pc : [<80018f7c>]    lr : [<80018fa0>]    psr: 800f0193
[   32.678961] sp : bfb6f870  ip : bfb6f870  fp : bfb6f894
[   32.690442] r10: bfa67440  r9 : 00000002  r8 : bf957010
[   32.695670] r7 : 600f0013  r6 : 808487bc  r5 : 00000002  r4 : 00000000
[   32.702199] r3 : 81784e62  r2 : 0003bdf8  r1 : 81009000  r0 : 00000000
[   32.708732] Flags: Nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[   32.716130] Control: 10c53c7d  Table: beeec059  DAC: 00000015
[   32.721878] Process mmcqd/0 (pid: 37, stack limit = 0xbfb6e238)
[   32.727800] Stack: (0xbfb6f870 to 0xbfb70000)
[   32.732164] f860:                                     bfa67440
bfb43d4c 600f0113 bfb6e000
[   32.740348] f880: 00000100 00000002 bfb6f8dc bfb6f898 803a3d70
80018f44 00000000 bfa67440
[   32.748533] f8a0: bfb6f8cc bfb6f8b0 805b27a8 800651e4 807765b4
bfa67440 bfa67470 600f0113
[   32.756717] f8c0: bfb6e000 00000100 803a4c1c bfa67440 bfb6f8fc
bfb6f8e0 803a4ca0 803a3b04
[   32.764902] f8e0: 00000000 80898454 bfa67528 bfb6f918 bfb6f954
bfb6f900 8002ef6c 803a4c28
[   32.773086] f900: 00000002 00000000 8002eed8 800a657c 808a6a80
bfa67440 80e1030c 00000000
[   32.781271] f920: 00000000 80776904 8005b7c4 808a6a80 bfa67528
808a6908 00000000 bfb6f970
[   32.789455] f940: 803a4c1c bfa67440 bfb6f9a4 bfb6f958 8002f594
8002eee4 808a76b0 808a74b0
[   32.797639] f960: 808a72b0 8084c550 00200200 80898454 bfb6f970
bfb6f970 bfb6e000 00000001
[   32.805823] f980: 00000004 808a6908 808a6904 bfb6e000 808a6448
00000001 bfb6fa0c bfb6f9a8
[   32.814007] f9a0: 80027bd0 8002f3f0 805bb750 800602f0 00208840
8084ab98 ffff931d 8084c550
[   32.822191] f9c0: bfb6e028 808a68c0 0000000a 80852688 00000004
00000100 808a6900 808983f0
[   32.830375] f9e0: c080e100 bfb6e010 00000057 00000000 c080e100
00000001 808a6448 808a5fc4
[   32.838560] fa00: bfb6fa24 bfb6fa10 800281b8 80027a94 00000120
80872034 bfb6fa44 bfb6fa28
[   32.846744] fa20: 8000fc64 800280fc 000000a0 c080e10c 80842e64
bfb6fa68 bfb6fa64 bfb6fa48
[   32.854928] fa40: 800085a0 8000fc24 80295770 200f0113 ffffffff
bfb6fa9c bfb6fad4 bfb6fa68
[   32.863112] fa60: 80013d84 80008570 000355f9 ffffffff 000025ed
80295740 00000048 80871ff4
[   32.871296] fa80: 00002580 00002648 00000001 808a6448 808a5fc4
bfb6fad4 bfb6fab0 bfb6fab0
[   32.879480] faa0: 805b145c 80295770 200f0113 ffffffff 80847c88
0000000b 80847c88 bfb6fadc
[   32.887664] fac0: 00000001 bfb6e000 bfb6fb6c bfb6fae8 800135c8
805b12a4 80720a90 00000001
[   32.895848] fae0: 00000000 00000001 bfb6e238 0000000b 00000000
00000008 00000000 807209e4
[   32.904032] fb00: 600f0193 807209ec 65b00000 61643938 20303038
30613165 64303063 32396520
[   32.912218] fb20: 30386464 32652030 30626334 28203430 30393565
30303033 80002029 805b2774
[   32.920403] fb40: 80796d74 00000000 00000017 00000000 bfb6fcd8
00000000 bfb00000 00000003
[   32.928587] fb60: bfb6fb84 bfb6fb70 805b1284 80013248 bfb6fcd8
00000017 bfb6fc24 bfb6fb88
[   32.936771] fb80: 80019d8c 805b121c 80058e68 800a669c c0804730
a00f0193 80848d94 bfa67440
[   32.944956] fba0: bfb6fbbc bfb6fbb0 80058f30 80058e48 bfb6fbd4
bfb6fbc0 805bba30 80058f28
[   32.953140] fbc0: 80848d90 80842050 bfb6fbec bfb6fbd8 8001d1d0
803a4030 00000000 bfa67470
[   32.961324] fbe0: 00000000 bfa67440 c080e100 bfb6e030 00000000
bfa67470 00000000 00000017
[   32.969508] fc00: 80019bc0 808488ac 00000000 bfb6fcd8 bfa67440
00000003 bfb6fcd4 bfb6fc28
[   32.977692] fc20: 80008440 80019bcc 00000000 00000000 00000000
8001d284 bfb6fc94 bfb6fc48
[   32.985876] fc40: 8005df6c 8005ba94 00000002 00000080 00000000
8001d284 00000000 bfb00000
[   32.994060] fc60: bfb6e000 805bba30 a00f0093 bfa67440 bfb6fc9c
bfb6fc80 80058e68 800a669c
[   33.002244] fc80: c0804730 bfb00000 bfb6e000 80013d14 bfb6fd0c
bf957010 bfb6fcc4 bfb6fca8
[   33.010428] fca0: 80058e68 800a669c 803a2bc8 802a3874 200f0093
802a3874 200f0093 ffffffff
[   33.018612] fcc0: bfb6fd0c bf957010 bfb6fd2c bfb6fcd8 80013d1c
80008404 00000000 bfb6a800
[   33.026796] fce0: 00000000 81784e62 bfb43ce4 bfb43d4c 600f0013
808487bc bf957010 bfa67440
[   33.034980] fd00: 00000003 bfb6fd2c bfb6fd30 bfb6fd20 803a2bc8
802a3874 200f0093 ffffffff
[   33.043164] fd20: bfb6fd8c bfb6fd30 803a2bc8 802a3874 00000002
00000000 bfb6fd5c bfb6fd48
[   33.051348] fd40: 8001d1d0 00000002 80e04788 80845840 bfb6fd8c
bfb6a800 803a7558 8001d190
[   33.059532] fd60: 803a7418 bfa67000 bfb43c6c bfa67470 600f0013
bfa67440 0000002d bfa67000
[   33.067716] fd80: bfb6fdb4 bfb6fd90 803a3a48 803a2244 bfb43c6c
bfa67000 8089fed0 bfb43d4c
[   33.075900] fda0: bfb6fe7c bfb43ec0 bfb6fdec bfb6fdb8 8038d3e0
803a388c bfb6fdd4 bfb6fdc8
[   33.084085] fdc0: 8005b7c4 bfa673d8 bfb43e18 00000000 00000001
bfb43d8c 00000001 bfb6fe7c
[   33.092269] fde0: bfb6fe3c bfb6fdf0 8038e538 8038d2c4 bfb6fe3c
bfb43da0 8039d0a4 00000000
[   33.100453] fe00: bfb00000 8005344c bfb6fe08 bfb6fe08 bfb6fe34
bfbfc000 bfb43c24 bfb6a000
[   33.108637] fe20: bfb44b60 bfb43c68 bfb6a000 bfb43c6c bfb6feac
bfb6fe40 8039e214 8038e278
[   33.116821] fe40: bfb44b60 bfb43c24 bfb6fe74 bfb6fe58 80292194
80276c0c bfb4fc00 bef024c0
[   33.125005] fe60: 00000000 00000000 00000000 bfb6fe78 bfb43c00
bfbfc000 00000002 00000080
[   33.133189] fe80: 00000000 bfb6a000 bfbfc000 00000000 00000000
bfb43c24 bfb43c00 bfa67000
[   33.141373] fea0: bfb6feec bfb6feb0 8039edc0 8039e158 00000000
122c8000 bfb6fed4 bfb6fec8
[   33.149557] fec0: 8005b7c4 bfb44b60 bfb6e000 00000000 122c8000
00000001 bfbfc000 bfb43c24
[   33.157741] fee0: bfb6ff24 bfb6fef0 8039f830 8039ebf0 bfb6e030
bfb43c2c 8039f780 bfb51a80
[   33.165926] ff00: 00000000 bfb43c24 8039f780 00000000 00000000
00000000 bfb6ffac bfb6ff28
[   33.174109] ff20: 80043658 8039f78c bfb6ff44 00000000 8005b7c4
bfb43c24 00000000 00000001
[   33.182293] ff40: dead4ead ffffffff ffffffff 808a8990 00000000
00000000 807239a4 bfb6ff5c
[   33.190477] ff60: bfb6ff5c 00000000 00000001 dead4ead ffffffff
ffffffff 808a8990 00000000
[   33.198662] ff80: 00000000 807239a4 bfb6ff88 bfb6ff88 bfb51a80
80043574 00000000 00000000
[   33.206846] ffa0: 00000000 bfb6ffb0 8000f348 80043580 00000000
00000000 00000000 00000000
[   33.215029] ffc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   33.223212] ffe0: 00000000 00000000 00000000 00000000 00000013
00000000 55055703 d17847e7
[   33.231390] Backtrace:
[   33.233862] [<80018f38>] (arm_dma_sync_sg_for_cpu+0x0/0x8c) from
[<803a3d70>] (sdhci_finish_data+0x278/0x380)
[   33.243779]  r9:00000002 r8:00000100 r7:bfb6e000 r6:600f0113 r5:bfb43d4c
r4:bfa67440
[   33.251706] [<803a3af8>] (sdhci_finish_data+0x0/0x380) from
[<803a4ca0>] (sdhci_timeout_timer+0x84/0xd0)
[   33.261197] [<803a4c1c>] (sdhci_timeout_timer+0x0/0xd0) from
[<8002ef6c>] (call_timer_fn+0x94/0x17c)
[   33.270330]  r6:bfb6f918 r5:bfa67528 r4:80898454 r3:00000000
[   33.276056] [<8002eed8>] (call_timer_fn+0x0/0x17c) from
[<8002f594>] (run_timer_softirq+0x1b0/0x258)
[   33.285197] [<8002f3e4>] (run_timer_softirq+0x0/0x258) from
[<80027bd0>] (__do_softirq+0x148/0x314)
[   33.294248] [<80027a88>] (__do_softirq+0x0/0x314) from [<800281b8>]
(irq_exit+0xc8/0x110)
[   33.302435] [<800280f0>] (irq_exit+0x0/0x110) from [<8000fc64>]
(handle_IRQ+0x4c/0x94)
[   33.310353]  r4:80872034 r3:00000120
[   33.313965] [<8000fc18>] (handle_IRQ+0x0/0x94) from [<800085a0>]
(gic_handle_irq+0x3c/0x64)
[   33.322317]  r6:bfb6fa68 r5:80842e64 r4:c080e10c r3:000000a0
[   33.328040] [<80008564>] (gic_handle_irq+0x0/0x64) from
[<80013d84>] (__irq_svc+0x44/0x58)
[   33.336306] Exception stack(0xbfb6fa68 to 0xbfb6fab0)
[   33.341365] fa60:                   000355f9 ffffffff 000025ed
80295740 00000048 80871ff4
[   33.349548] fa80: 00002580 00002648 00000001 808a6448 808a5fc4
bfb6fad4 bfb6fab0 bfb6fab0
[   33.357728] faa0: 805b145c 80295770 200f0113 ffffffff
[   33.362781]  r7:bfb6fa9c r6:ffffffff r5:200f0113 r4:80295770
[   33.368513] [<805b1294>] (panic+0x0/0x1dc) from [<800135c8>]
(die+0x38c/0x3a0)
[   33.375738]  r3:00000001 r2:00000000 r1:00000001 r0:80720a90
[   33.381456]  r7:bfb6e000
[   33.384012] [<8001323c>] (die+0x0/0x3a0) from [<805b1284>]
(__do_kernel_fault.part.11+0x74/0x84)
[   33.392808] [<805b1210>] (__do_kernel_fault.part.11+0x0/0x84) from
[<80019d8c>] (do_page_fault+0x1cc/0x3d4)
[   33.402549]  r7:00000017 r3:bfb6fcd8
[   33.406163] [<80019bc0>] (do_page_fault+0x0/0x3d4) from
[<80008440>] (do_DataAbort+0x48/0xa8)
[   33.414694] [<800083f8>] (do_DataAbort+0x0/0xa8) from [<80013d1c>]
(__dabt_svc+0x3c/0x60)
[   33.422874] Exception stack(0xbfb6fcd8 to 0xbfb6fd20)
[   33.427928] fcc0:
    00000000 bfb6a800
[   33.436113] fce0: 00000000 81784e62 bfb43ce4 bfb43d4c 600f0013
808487bc bf957010 bfa67440
[   33.444297] fd00: 00000003 bfb6fd2c bfb6fd30 bfb6fd20 803a2bc8
802a3874 200f0093 ffffffff
[   33.452475]  r8:bf957010 r7:bfb6fd0c r6:ffffffff r5:200f0093 r4:802a3874
[   33.459263] [<802a3868>] (sg_next+0x0/0x34) from [<803a2bc8>]
(sdhci_send_command+0x990/0xf50)
[   33.467883] [<803a2238>] (sdhci_send_command+0x0/0xf50) from
[<803a3a48>] (sdhci_request+0x1c8/0x278)
[   33.477112] [<803a3880>] (sdhci_request+0x0/0x278) from
[<8038d3e0>] (mmc_start_request+0x128/0x24c)
[   33.486247]  r9:bfb43ec0 r8:bfb6fe7c r7:bfb43d4c r6:8089fed0 r5:bfa67000
r4:bfb43c6c
[   33.494172] [<8038d2b8>] (mmc_start_request+0x0/0x24c) from
[<8038e538>] (mmc_start_req+0x2cc/0x378)
[   33.503307]  r8:bfb6fe7c r7:00000001 r6:bfb43d8c r5:00000001 r4:00000000
[   33.510087] [<8038e26c>] (mmc_start_req+0x0/0x378) from
[<8039e214>] (mmc_blk_issue_rw_rq+0xc8/0xa98)
[   33.519313] [<8039e14c>] (mmc_blk_issue_rw_rq+0x0/0xa98) from
[<8039edc0>] (mmc_blk_issue_rq+0x1dc/0x4cc)
[   33.528887] [<8039ebe4>] (mmc_blk_issue_rq+0x0/0x4cc) from
[<8039f830>] (mmc_queue_thread+0xb0/0x14c)
[   33.538116] [<8039f780>] (mmc_queue_thread+0x0/0x14c) from
[<80043658>] (kthread+0xe4/0xf8)
[   33.546476] [<80043574>] (kthread+0x0/0xf8) from [<8000f348>]
(ret_from_fork+0x14/0x20)
[   33.554480]  r7:00000000 r6:00000000 r5:80043574 r4:bfb51a80
[   33.560205] Code: 01a06003 e3570000 d89dabf0 e3a05000 (e594100c)
[   33.566306] ---[ end trace e52024b248222185 ]--


Regards,

john

On Wed, Jan 22, 2014 at 8:41 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 22, 2014 at 08:23:36AM -0800, John Tobias wrote:
>> Hello all,
>>
>> I am using 3.13-rc1 kernel on iMX6SL processor. My filesystem is in
>> eMMC running SDR50.
>> Is anyone here encountered these problem and if there's any existing
>> patch that I can get?.
>
> How reproducable is this?  I notice you're using 3.13-rc1 too, it could
> be the bug has already been fixed in a later kernel version.  -rc1
> kernels are really the "fresh after lots of new feature merging" kernels
> which should always be expected to be rather buggy.
>
> Linux kernel "release candidates" are not "we think this is going to be
> a final kernel, please test it" but -rc1 marks the end of the new
> feature merging and the beginning of the stablisation phase.
>
> --
> FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
> in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
> Estimate before purchase was "up to 13.2Mbit".

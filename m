Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3KAN4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:56:39 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:41315 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3KAN4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:56:37 -0400
MIME-Version: 1.0
In-Reply-To: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
Date: Fri, 1 Nov 2013 14:56:36 +0100
Message-ID: <CACmBeS2TiiTJ_n0bEzXGKN8B=U9EKXeVtrE2q0jgxsxf5TBivw@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] clk: clock deregistration support
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, linux-mips@linux-mips.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, jiada_wang@mentor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just letting you know, the following warning from __clk_get is now
printed, and not printed after revert (git revert
0b35b92fb3600a2f9ca114a6142db95f760d55f5).

Is the driver doing something it shouldn't be doing?

moxart_of_pll_clk_init() source can be found here:
http://www.spinics.net/lists/arm-kernel/msg278572.html

boot log:
Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.12.0-rc7-next-20131031+ (i@Ildjarn)
(gcc version 4.6.3 (crosstool-NG 1.16.0) ) #1043 PREEMPT Fri Nov 1
09:34:07 CET 2013
[    0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine model: MOXA UC-7112-LX
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 8192
[    0.000000] free_area_init_node: node 0, pgdat c03802ac,
node_mem_map c0941000
[    0.000000]   Normal zone: 72 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 8192 pages, LIFO batch:0
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 8120
[    0.000000] Kernel command line: debug loglevel=9
console=ttyS0,115200n8 root=/dev/mmcblk0p1 rw rootwait
[    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
[    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Memory: 22920K/32768K available (2725K kernel code,
106K rwdata, 560K rodata, 156K init, 5880K bss, 9848K reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
[    0.000000]       .text : 0xc0008000 - 0xc033d84c   (3287 kB)
[    0.000000]       .init : 0xc033e000 - 0xc0365394   ( 157 kB)
[    0.000000]       .data : 0xc0366000 - 0xc0380ae0   ( 107 kB)
[    0.000000]        .bss : 0xc0380aec - 0xc093ebbc   (5881 kB)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at include/linux/kref.h:47
__clk_get+0x54/0x68()
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
3.12.0-rc7-next-20131031+ #1043
[    0.000000] [<c000d214>] (unwind_backtrace+0x0/0xf4) from
[<c000b964>] (show_stack+0x18/0x1c)
[    0.000000] [<c000b964>] (show_stack+0x18/0x1c) from [<c02715e0>]
(dump_stack+0x20/0x28)
[    0.000000] [<c02715e0>] (dump_stack+0x20/0x28) from [<c0013ab0>]
(warn_slowpath_common+0x64/0x84)
[    0.000000] [<c0013ab0>] (warn_slowpath_common+0x64/0x84) from
[<c0013ba4>] (warn_slowpath_null+0x24/0x2c)
[    0.000000] [<c0013ba4>] (warn_slowpath_null+0x24/0x2c) from
[<c01e5c00>] (__clk_get+0x54/0x68)
[    0.000000] [<c01e5c00>] (__clk_get+0x54/0x68) from [<c01e334c>]
(of_clk_get+0x64/0x7c)
[    0.000000] [<c01e334c>] (of_clk_get+0x64/0x7c) from [<c03508f0>]
(moxart_of_pll_clk_init+0xd8/0x15c)
[    0.000000] [<c03508f0>] (moxart_of_pll_clk_init+0xd8/0x15c) from
[<c0350588>] (of_clk_init+0x48/0x70)
[    0.000000] [<c0350588>] (of_clk_init+0x48/0x70) from [<c03425f0>]
(moxart_init_time+0x14/0x1c)
[    0.000000] [<c03425f0>] (moxart_init_time+0x14/0x1c) from
[<c034005c>] (time_init+0x28/0x3c)
[    0.000000] [<c034005c>] (time_init+0x28/0x3c) from [<c033e954>]
(start_kernel+0x1d0/0x2dc)
[    0.000000] [<c033e954>] (start_kernel+0x1d0/0x2dc) from
[<00008040>] (0x8040)
[    0.000000] ---[ end trace 3406ff24bd97382e ]---
[    0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns,
wraps every 21474836480000000ns
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] kmemleak: Early log buffer exceeded (672), please
increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE


Regards,
Jonas

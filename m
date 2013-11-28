Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3K1Jzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:55:33 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:57753 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab3K1Jz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:55:29 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Lockup on Sun Fire V240 under load
Date: Thu, 28 Nov 2013 10:46:07 +0100
Message-ID: <32994976.A7tuLDhD29@devpool02>
User-Agent: KMail/4.11.3 (Linux/3.12.1-1.g999c17a-desktop; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recompiled both binutils and gcc in parallel (independent of each other). 
Only minutes after I started this the machine locked up. The machine has 8GiB 
of RAM and was otherwise idle.

Greetings,

Eike

[233026.041133] BUG: NMI Watchdog detected LOCKUP on CPU1, ip 0043d6f8, registers:
[233026.137243] CPU: 1 PID: 362 Comm: khugepaged Not tainted 3.12.1 #3
[233026.219590] task: fffff8033a1e6000 ti: fffff8033a0a4000 task.ti: fffff8033a0a4000
[233026.319095] TSTATE: 0000004480e01602 TPC: 000000000043d6f8 TNPC: 000000000043d6fc Y: 00000000    Not tainted
[233026.449493] TPC: <cheetah_xcall_deliver+0x178/0x2a0>
[233026.515814] g0: 0000000000000000 g1: fffff8133c820008 g2: 0000000000000001 g3: 000000000001869e
[233026.631333] g4: fffff8033a1e6000 g5: fffff8133c59e000 g6: fffff8033a0a4000 g7: 0000000000000000
[233026.746850] o0: 0000000000000018 o1: 0000000000000000 o2: 0000000000000001 o3: 0000000000000000
[233026.862369] o4: 0000000000000000 o5: 0000000000000003 sp: fffff8033a0a6821 ret_pc: 000000000043d704
[233026.982462] RPC: <cheetah_xcall_deliver+0x184/0x2a0>
[233027.048794] l0: 000000000000ffff l1: 0000000000000001 l2: 0000000000000001 l3: 0000000000000002
[233027.164314] l4: ffffffffffffffff l5: 0000000000000016 l6: fffff8133c820040 l7: fffff8133c820000
[233027.279836] i0: fffff8133c820010 i1: 0000000000000001 i2: 0000000000000002 i3: 0000000000000040
[233027.395354] i4: 0000000000000050 i5: 0000000000000060 i6: fffff8033a0a68e1 i7: 000000000043d410
[233027.510872] I7: <xcall_deliver+0x110/0x140>
[233027.566907] Call Trace:
[233027.600078]  [000000000043d410] xcall_deliver+0x110/0x140
[233027.672135]  [000000000043e5c0] smp_flush_tlb_page+0x40/0xa0
[233027.747624]  [0000000000452d70] tlb_batch_add_one+0x90/0xc0
[233027.821968]  [0000000000521c90] ptep_clear_flush+0x30/0x40
[233027.895162]  [000000000051c4d8] try_to_unmap_one+0x78/0x480
[233027.969505]  [000000000051d138] try_to_unmap_anon+0x78/0x140
[233028.044991]  [000000000051d290] try_to_unmap+0x50/0x80
[233028.113618]  [0000000000537a64] migrate_pages+0x3c4/0x720
[233028.185674]  [000000000050cfd4] compact_zone+0x2b4/0x400
[233028.256582]  [000000000050d430] compact_zone_order+0x90/0xc0
[233028.332070]  [000000000050d524] try_to_compact_pages+0xc4/0x120
[233028.410989]  [00000000004f3694] __alloc_pages_direct_compact+0x54/0x1c0
[233028.499053]  [00000000004f3d48] __alloc_pages_nodemask+0x548/0x8a0
[233028.581410]  [0000000000530810] alloc_pages_vma+0x50/0x120
[233028.654603]  [00000000005396c0] khugepaged+0x620/0xf80
[233028.723232]  [0000000000481d08] kthread+0x88/0xa0
[233028.786130] CPU: 1 PID: 362 Comm: khugepaged Not tainted 3.12.1 #3
[233028.868479] Call Trace:
[233028.901654]  [00000000008780e8] perfctr_irq+0x2a8/0x360
[233028.971419]  [00000000004209f4] tl0_irq15+0x14/0x20
[233029.036608]  [000000000043d6f8] cheetah_xcall_deliver+0x178/0x2a0
[233029.117815]  [000000000043d410] xcall_deliver+0x110/0x140
[233029.189870]  [000000000043e5c0] smp_flush_tlb_page+0x40/0xa0
[233029.265356]  [0000000000452d70] tlb_batch_add_one+0x90/0xc0
[233029.339699]  [0000000000521c90] ptep_clear_flush+0x30/0x40
[233029.412898]  [000000000051c4d8] try_to_unmap_one+0x78/0x480
[233029.487241]  [000000000051d138] try_to_unmap_anon+0x78/0x140
[233029.562726]  [000000000051d290] try_to_unmap+0x50/0x80
[233029.631350]  [0000000000537a64] migrate_pages+0x3c4/0x720
[233029.703407]  [000000000050cfd4] compact_zone+0x2b4/0x400
[233029.774318]  [000000000050d430] compact_zone_order+0x90/0xc0
[233029.849806]  [000000000050d524] try_to_compact_pages+0xc4/0x120
[233029.928721]  [00000000004f3694] __alloc_pages_direct_compact+0x54/0x1c0
[233030.016789]  [00000000004f3d48] __alloc_pages_nodemask+0x548/0x8a0


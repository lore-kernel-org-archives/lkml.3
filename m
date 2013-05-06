Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3EFSx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:53:57 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:62649 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3EFSx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:53:56 -0400
MIME-Version: 1.0
Date: Mon, 6 May 2013 11:53:56 -0700
X-Google-Sender-Auth: _cJNxNflw2J9d9FsI-rk_xxFrwU
Message-ID: <CAE9FiQUTV_e9De-6zCPs6OQrVAUJV2VLZDBmxFpJtnjNO3rKfw@mail.gmail.com>
Subject: RCU init call bootmem allocation after slub us ready.
From: Yinghai Lu <yinghai@kernel.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=160, Nodes=8
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=160.
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at mm/nobootmem.c:234
___alloc_bootmem_nopanic+0x3a/0x7d()
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
3.9.0-yh-10495-gfc7ffbc-dirty #1543
[    0.000000] Hardware name: Oracle Corporation  Sun Fire X4800 M2 /
   , BIOS 15013200    04/19/2012
[    0.000000]  0000000000000009 ffffffff82a01e58 ffffffff8209dc61
ffffffff82a01e98
[    0.000000]  ffffffff8108a9d0 0000000000000000 0000000000000000
0000000000000200
[    0.000000]  ffffffffffffffff 0000000000000040 0000000000000000
ffffffff82a01ea8
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8209dc61>] dump_stack+0x19/0x1b
[    0.000000]  [<ffffffff8108a9d0>] warn_slowpath_common+0x70/0xa0
[    0.000000]  [<ffffffff8108aa1a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff82dd54cd>] ___alloc_bootmem_nopanic+0x3a/0x7d
[    0.000000]  [<ffffffff82dd5695>] __alloc_bootmem+0x12/0x38
[    0.000000]  [<ffffffff82de976a>] alloc_bootmem_cpumask_var+0x1a/0x21
[    0.000000]  [<ffffffff82dce4da>] rcu_init+0x66/0x283
[    0.000000]  [<ffffffff82dd15ed>] ? perf_event_init+0x136/0x15f
[    0.000000]  [<ffffffff82dabf95>] start_kernel+0x24a/0x423
[    0.000000]  [<ffffffff82dababe>] ? repair_env_string+0x5e/0x5e
[    0.000000]  [<ffffffff820936b6>] ? __memblock_reserve+0x81/0x89
[    0.000000]  [<ffffffff82dab5a8>] x86_64_start_reservations+0x2f/0x31
[    0.000000]  [<ffffffff82dab79e>] x86_64_start_kernel+0x1f4/0x1fc
[    0.000000] ---[ end trace 53ae8bb075006d8f ]---

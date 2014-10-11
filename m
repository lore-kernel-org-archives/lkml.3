Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaJKFPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 01:15:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:40855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaJKFPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 01:15:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,696,1406617200"; 
   d="scan'208";a="587125580"
Date: Sat, 11 Oct 2014 13:15:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000040
Message-ID: <20141011051530.GA21803@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuyang,

FYI, we noticed the below changes on commit

445d95d7c384741d133251a9adac935866591c92 ("sched: Remove update_rq_runnable_avg")

+------------------------------------------+------------+------------+
|                                          | 80213c03c4 | 445d95d7c3 |
+------------------------------------------+------------+------------+
| boot_successes                           | 7          | 10         |
| boot_failures                            | 0          | 5          |
| BUG:unable_to_handle_kernel              | 0          | 5          |
| Oops                                     | 0          | 5          |
| RIP:print_cfs_group_stats                | 0          | 5          |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 5          |
| backtrace:vfs_read                       | 0          | 5          |
| backtrace:SyS_read                       | 0          | 5          |
+------------------------------------------+------------+------------+


repeat count: 267
2014-10-10 18:20:23 ./case-anon-wx-rand-mt
2014-10-10 18:20:23 ./usemem --runtime 300 -t 4 --prealloc --random 514360832
[   67.303839] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[   67.304014] IP: [<ffffffff810b1d52>] print_cfs_rq+0x4a3/0xa96
[   67.304014] PGD 7cd1f067 PUD 7ccbe067 PMD 0 
[   67.315030] Oops: 0000 [#1] SMP 
[   67.315030] Modules linked in: snd_pcsp
[   67.315030] CPU: 3 PID: 4013 Comm: sched_debug Not tainted 3.17.0-g4bb7030 #2846
[   67.315030] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   67.315030] task: ffff88007c6ecb00 ti: ffff88007ccac000 task.ti: ffff88007ccac000
[   67.315030] RIP: 0010:[<ffffffff810b1d52>]  [<ffffffff810b1d52>] print_cfs_rq+0x4a3/0xa96
[   67.315030] RSP: 0018:ffff88007ccafd60  EFLAGS: 00010086
[   67.315030] RAX: ffff88011a814000 RBX: ffff88007c47afe8 RCX: 0000000000000513
[   67.315030] RDX: ffff88007ccafd00 RSI: 0000000000000000 RDI: 0000000000001000
[   67.315030] RBP: ffff88007ccafda8 R08: 0000000000000000 R09: 0000000000000001
[   67.315030] R10: ffff88007ccafcc8 R11: 0000000000000000 R12: 0000000000000000
[   67.315030] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffffffffffff
[   67.315030] FS:  00007f6216ddd700(0000) GS:ffff88011b400000(0000) knlGS:0000000000000000
[   67.315030] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   67.315030] CR2: 0000000000000040 CR3: 000000007c6ce000 CR4: 00000000000006e0
[   67.315030] Stack:
[   67.315030]  0000002b20db6a16 0000000000000086 0000000000000000 0000000000000000
[   67.315030]  ffff88011afd47b8 0000000000000000 ffff88007c47afe8 00000000001d4700
[   67.315030]  0000000000000000 ffff88007ccafde8 ffffffff810aac54 ffff88011afd4870
[   67.315030] Call Trace:
[   67.315030]  [<ffffffff810aac54>] print_cfs_stats+0x99/0xe0
[   67.315030]  [<ffffffff810b14b5>] print_cpu+0x57d/0x955
[   67.315030]  [<ffffffff811685b7>] ? might_fault+0x59/0xb4
[   67.315030]  [<ffffffff810b18a4>] sched_debug_show+0x17/0x22
[   67.315030]  [<ffffffff811b66f8>] seq_read+0x16a/0x33e
[   67.315030]  [<ffffffff811cc9f2>] ? fsnotify+0x267/0x28c
[   67.315030]  [<ffffffff811e58f0>] proc_reg_read+0x48/0x67
[   67.315030]  [<ffffffff811e58a8>] ? proc_reg_write+0x67/0x67
[   67.315030]  [<ffffffff81197b2d>] vfs_read+0xa6/0x144
[   67.315030]  [<ffffffff811985c5>] SyS_read+0x51/0x92
[   67.315030]  [<ffffffff81b4c729>] system_call_fastpath+0x16/0x1b
[   67.315030] Code: f0 00 00 00 31 c0 e8 d6 85 a8 00 49 8b 84 24 c8 00 00 00 48 85 db 48 8b 75 c8 48 8b 80 d8 00 00 00 4c 8b 24 f0 0f 84 17 03 00 00 <4d> 8b 6c 24 40 4c 89 ef e8 9b eb ff ff 4c 89 ef 48 89 45 d0 e8 
[   67.315030] RIP  [<ffffffff810b1d52>] print_cfs_rq+0x4a3/0xa96
[   67.315030]  RSP <ffff88007ccafd60>
[   67.315030] CR2: 0000000000000040
[   67.315030] ---[ end trace c7479625085660d8 ]---
[   67.315030] Kernel panic - not syncing: Fatal exception


Thanks,
Fengguang

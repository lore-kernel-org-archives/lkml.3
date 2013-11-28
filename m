Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3K1HHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:07:07 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:65280 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3K1HHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:07:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311271902230.5120@chino.kir.corp.google.com>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
	<tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
	<CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
	<20131121150344.GG10022@twins.programming.kicks-ass.net>
	<CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
	<CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
	<alpine.DEB.2.02.1311271902230.5120@chino.kir.corp.google.com>
Date: Wed, 27 Nov 2013 23:07:04 -0800
X-Google-Sender-Auth: 3AYtngfaV1RXDTNzV2ijawhz_uU
Message-ID: <CAE9FiQUVLT3PL3ON_VRrNB6p9TxFU_-X_dkcb6dLvzonmmW7ag@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
From: Yinghai Lu <yinghai@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 7:02 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 21 Nov 2013, Yinghai Lu wrote:
>
>> original one in linus's tree:
>>
>> [    8.952728] NMI watchdog: enabled on all CPUs, permanently consumes
>> one hw-PMU counter.
>> [    8.965697] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000010
>> [    8.969495] IP: [<ffffffff810d7b53>] update_group_power+0x1d3/0x250
>
> This should have been fixed by Srikar's patch, no?

maybe not related, now in another system, linus's tree + Srikar's patch.

got

[   33.546361] divide error: 0000 [#1]
SMP
[   33.589436] Modules linked in:
[   33.592869] CPU: 15 PID: 567 Comm: kworker/u482:0 Not tainted
3.13.0-rc1-yh-00324-gcf1be1c-dirty #10
[   33.603075] Hardware name: Oracle Corporation
[   33.609571] calling  ipc_ns_init+0x0/0x14 @ 1
[   33.609575] initcall ipc_ns_init+0x0/0x14 returned 0 after 0 usecs
[   33.609577] calling  init_mmap_min_addr+0x0/0x16 @ 1
[   33.609579] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[   33.609583] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[   33.609621] initcall init_cpufreq_transition_notifier_list+0x0/0x1b
returned 0 after 0 usecs
[   33.609624] calling  net_ns_init+0x0/0xfa @ 1
[   33.677194] task: ffff897c5ba5c8c0 ti: ffff897c5ba8e000 task.ti:
ffff897c5ba8e000
[   33.685558] RIP: 0010:[<ffffffff810dbf2c>]  [<ffffffff810dbf2c>]
find_busiest_group+0x2ac/0x880
[   33.695310] RSP: 0000:ffff897c5ba8f9a8  EFLAGS: 00010046
[   33.701253] RAX: 000000000001dfff RBX: 00000000ffffffff RCX: 000000000001e000
[   33.709226] RDX: 0000000000000000 RSI: 0000000000000078 RDI: 0000000000000000
[   33.717198] RBP: ffff897c5ba8fb08 R08: 0000000000000000 R09: 0000000000000000
[   33.725178] R10: 0000000000000000 R11: 000000000001e000 R12: ffff897c5ba8fa90
[   33.733156] R13: ffff897c5ad61d80 R14: 0000000000000000 R15: ffff897c5ba8fba0
[   33.741132] FS:  0000000000000000(0000) GS:ffff897d7c200000(0000)
knlGS:0000000000000000
[   33.750164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   33.756593] CR2: 0000000000000168 CR3: 0000000002a14000 CR4: 00000000001407e0
[   33.764571] Stack:
[   33.766822]  0000000000000000 0000000000000046 0000000000000048
0000000000000000
[   33.775141]  ffff897c5ad61d98 ffff897c5ba8fa20 0000000000000036
00000000000003ab
[   33.783461]  00000000000003ab 0000000000000139 00000000000044e8
0000000100000003
[   33.791789] Call Trace:
[   33.794549]  [<ffffffff810dc6c8>] load_balance+0x1c8/0x8d0
[   33.800701]  [<ffffffff810ee65b>] ? __lock_acquire+0xadb/0xce0
[   33.807222]  [<ffffffff810dd2d1>] idle_balance+0x101/0x1c0
[   33.813355]  [<ffffffff810dd214>] ? idle_balance+0x44/0x1c0
[   33.819618]  [<ffffffff8207a5bb>] __schedule+0x2cb/0xa10
[   33.825584]  [<ffffffff810e86c8>] ? trace_hardirqs_off_caller+0x28/0x160
[   33.833089]  [<ffffffff810e880d>] ? trace_hardirqs_off+0xd/0x10
[   33.839731]  [<ffffffff810d3b84>] ? local_clock+0x34/0x60
[   33.845788]  [<ffffffff810ba7bb>] ? worker_thread+0x2db/0x370
[   33.852241]  [<ffffffff8207f8a0>] ? _raw_spin_unlock_irq+0x30/0x40
[   33.859150]  [<ffffffff8207ad65>] schedule+0x65/0x70
[   33.864700]  [<ffffffff810ba7c0>] worker_thread+0x2e0/0x370
[   33.870932]  [<ffffffff810ec17d>] ? trace_hardirqs_on+0xd/0x10
[   33.877472]  [<ffffffff810ba4e0>] ? manage_workers.isra.17+0x330/0x330
[   33.884789]  [<ffffffff810c18c8>] kthread+0x108/0x110
[   33.890441]  [<ffffffff810c17c0>] ? __init_kthread_worker+0x70/0x70
[   33.897465]  [<ffffffff8208812c>] ret_from_fork+0x7c/0xb0
[   33.903504]  [<ffffffff810c17c0>] ? __init_kthread_worker+0x70/0x70
[   33.910508] Code: 89 85 b8 fe ff ff 49 8b 45 10 41 8b 75 0c 44 8b
50 08 44 8b 58 04 89 f0 48 c1 e0 0a 45 89 d1 49 8d 44 01 ff 48 89 c2
48 c1 fa 3f <49> f7 f9 31 d2 49 89 c1 89 f0 44 89 de 41 f7 f1 48 81 c6
00 02
[   33.932375] RIP  [<ffffffff810dbf2c>] find_busiest_group+0x2ac/0x880
[   33.939491]  RSP <ffff897c5ba8f9a8>
[   33.943418] ---[ end trace 7a833c0cac54cac8 ]---

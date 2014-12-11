Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbaLKHfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:35:52 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:63386 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaLKHfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <tip-e9220e591375af6d02604c261999df570fba744f@git.kernel.org>
References: <20141205084147.313026156@linutronix.de>
	<tip-e9220e591375af6d02604c261999df570fba744f@git.kernel.org>
Date: Wed, 10 Dec 2014 23:35:50 -0800
X-Google-Sender-Auth: LCEW601QbPFzS1vbpJM1DB6-TEM
Message-ID: <CAE9FiQU=Q8paxTJpqN8GFGYeq6u-E=VBtyQSVzVNYnJGEybtqw@mail.gmail.com>
Subject: Re: [tip:x86/apic] iommu/vt-d: Move iommu preparatory allocations to irq_remap_ops.prepare
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 3:26 PM, tip-bot for Thomas Gleixner
<tipbot@zytor.com> wrote:
> Commit-ID:  e9220e591375af6d02604c261999df570fba744f
> Gitweb:     http://git.kernel.org/tip/e9220e591375af6d02604c261999df570fba744f
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Fri, 5 Dec 2014 08:48:32 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sat, 6 Dec 2014 00:19:25 +0100
>
> iommu/vt-d: Move iommu preparatory allocations to irq_remap_ops.prepare
>
> The whole iommu setup for irq remapping is a convoluted mess. The
> iommu detect function gets called from mem_init() and the prepare
> callback gets called from enable_IR_x2apic() for unknown reasons.

Got

[  134.510969] calling  ahci_pci_driver_init+0x0/0x1b @ 1
[  134.511387] ahci 0000:00:1f.2: version 3.0
[  134.530941]   alloc irq_desc for 91 on node 0
[  134.531168]   alloc irq_desc for 92 on node 0
[  134.550728]   alloc irq_desc for 93 on node 0
[  134.550995]   alloc irq_desc for 94 on node 0
[  134.551199]   alloc irq_desc for 95 on node 0
[  134.570871]   alloc irq_desc for 96 on node 0
[  134.571090]   alloc irq_desc for 97 on node 0
[  134.571303]   alloc irq_desc for 98 on node 0
[  134.590974]   alloc irq_desc for 99 on node 0
[  134.591205]   alloc irq_desc for 100 on node 0
[  134.610882]   alloc irq_desc for 101 on node 0
[  134.611136]   alloc irq_desc for 102 on node 0
[  134.611364]   alloc irq_desc for 103 on node 0
[  134.630992]   alloc irq_desc for 104 on node 0
[  134.631232]   alloc irq_desc for 105 on node 0
[  134.650885]   alloc irq_desc for 106 on node 0
[  134.651246] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[  134.670926] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[  134.671349] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ccc ems sxs
[  134.691158] ahci 0000:00:1f.2: with iommu 3 : domain 10
[  134.751560] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000118
[  134.751997] IP: [<ffffffff81eafe50>] modify_irte+0x40/0xd0
[  134.770893] PGD 0
[  134.771011] Oops: 0000 [#1] SMP
[  134.771195] Modules linked in:
[  134.771344] CPU: 0 PID: 2169 Comm: kworker/0:1 Tainted: G        W
[  134.811557] Workqueue: events work_for_cpu_fn
[  134.830823] task: ffff881024725240 ti: ffff8810252f8000 task.ti:
ffff8810252f8000
[  134.831176] RIP: 0010:[<ffffffff81eafe50>]  [<ffffffff81eafe50>]
modify_irte+0x40/0xd0
[  134.851029] RSP: 0000:ffff8810252fba18  EFLAGS: 00010096
[  134.851276] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000be00bd
[  134.871322] RDX: 0000000000000000 RSI: ffffffff81eafe3f RDI: 0000000000000046
[  134.891061] RBP: ffff8810252fba48 R08: 0000000000000001 R09: 0000000000000001
[  134.891393] R10: ffff881024725240 R11: 0000000000000292 R12: 0000000000000000
[  134.911249] R13: 0000000000000096 R14: ffff881022b181d0 R15: ffff880079268260
[  134.930824] FS:  0000000000000000(0000) GS:ffff88103de00000(0000)
knlGS:0000000000000000
[  134.931202] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  134.950966] CR2: 0000000000000118 CR3: 0000000002c1a000 CR4: 00000000000007f0
[  134.970775] Stack:
[  134.970883]  ffff8810252fba88 0000000000000046 ffff881022f6c660
ffff881026d00000
[  134.971253]  000000000000005c ffff880079268200 ffff8810252fba58
ffffffff81eaff26
[  134.991066]  ffff8810252fba78 ffffffff81106761 ffff880079268200
ffff88103d889400
[  135.010908] Call Trace:
[  135.011038]  [<ffffffff81eaff26>] intel_irq_remapping_activate+0x16/0x20
[  135.030800]  [<ffffffff81106761>] irq_domain_activate_irq+0x41/0x50
[  135.031103]  [<ffffffff8110674b>] irq_domain_activate_irq+0x2b/0x50
[  135.050857]  [<ffffffff81103f19>] irq_startup+0x29/0x70
[  135.051091]  [<ffffffff81102857>] __setup_irq+0x327/0x590
[  135.070849]  [<ffffffff81a3d820>] ? ahci_bad_pmp_check_ready+0x70/0x70
[  135.071143]  [<ffffffff81102c42>] request_threaded_irq+0xf2/0x150
[  135.090972]  [<ffffffff81a3d820>] ? ahci_bad_pmp_check_ready+0x70/0x70
[  135.091295]  [<ffffffff81a3ff90>] ? ahci_host_activate+0x180/0x180
[  135.111014]  [<ffffffff8110495f>] devm_request_threaded_irq+0x5f/0xb0
[  135.130804]  [<ffffffff81a3feb3>] ahci_host_activate+0xa3/0x180
[  135.131097]  [<ffffffff81a3d391>] ahci_init_one+0x9d1/0xac0
[  135.150841]  [<ffffffff8157d735>] local_pci_probe+0x45/0xa0
[  135.151127]  [<ffffffff810b8868>] work_for_cpu_fn+0x18/0x30
[  135.170843]  [<ffffffff810bbd24>] process_one_work+0x254/0x470
[  135.171103]  [<ffffffff810bbc89>] ? process_one_work+0x1b9/0x470
[  135.190846]  [<ffffffff810bce1b>] worker_thread+0x31b/0x4e0
[  135.191115]  [<ffffffff810ea3bd>] ? trace_hardirqs_on+0xd/0x10
[  135.210920]  [<ffffffff810bcb00>] ? pool_mayday_timeout+0x170/0x170
[  135.211215]  [<ffffffff810c1ff1>] kthread+0x101/0x110
[  135.230902]  [<ffffffff810ea3bd>] ? trace_hardirqs_on+0xd/0x10
[  135.231157]  [<ffffffff810c1ef0>] ? kthread_stop+0x100/0x100
[  135.250930]  [<ffffffff82015e6c>] ret_from_fork+0x7c/0xb0
[  135.251178]  [<ffffffff810c1ef0>] ? kthread_stop+0x100/0x100
[  135.270969] Code: ec 10 48 85 ff 0f 84 90 00 00 00 48 c7 c7 80 34
e0 82 49 89 f6 e8 21 54 16 00 0f b7 53 08 49 89 c5 0f b7 43 0a 4c 8b
23 8d 1c 02 <49> 8b 84 24 18 01 00 00 48 63 fb 48 c1 e7 04 48 03 38 49
8b 06
[  135.291699] RIP  [<ffffffff81eafe50>] modify_irte+0x40/0xd0
[  135.311051]  RSP <ffff8810252fba18>
[  135.311215] CR2: 0000000000000118
[  135.330856] ---[ end trace fee039719f1667df ]---
[  135.333024] BUG: unable to handle kernel paging request at ffffffffffffff98
[  135.350911] IP: [<ffffffff810c2530>] kthread_data+0x10/0x20
[  135.351230] PGD 2c1b067 PUD 2c1d067 PMD 0
[  135.351443] Oops: 0000 [#2] SMP
[  135.370998] Modules linked in:
[  135.371168] CPU: 0 PID: 2169 Comm: kworker/0:1 Tainted: G      D W
[  135.412423] task: ffff881024725240 ti: ffff8810252f8000 task.ti:
ffff8810252f8000
[  135.412798] RIP: 0010:[<ffffffff810c2530>]  [<ffffffff810c2530>]
kthread_data+0x10/0x20
[  135.431159] RSP: 0000:ffff8810252fb538  EFLAGS: 00010096
[  135.450891] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000f
[  135.451218] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff881024725240
[  135.471044] RBP: ffff8810252fb538 R08: ffff8810247252d0 R09: 0000000000000001
[  135.490873] R10: ffff881024725240 R11: 000000000000001a R12: ffff88103dfd2c40
[  135.491237] R13: 0000000000000000 R14: 0000000000000000 R15: ffff881024725240
[  135.511046] FS:  0000000000000000(0000) GS:ffff88103de00000(0000)
knlGS:0000000000000000
[  135.530882] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  135.531160] CR2: 0000000000000028 CR3: 0000000002c1a000 CR4: 00000000000007f0
[  135.550979] Stack:
[  135.551074]  ffff8810252fb558 ffffffff810bd065 ffff8810252fb558
ffff881024725240
[  135.570927]  ffff8810252fb678 ffffffff8200fc0b ffff881025ffec00
0000000000009000
[  135.571302]  ffff881024725240 ffff8810252fbfd8 ffff88103dfd3a40
ffff881024725240
[  135.591114] Call Trace:
[  135.591231]  [<ffffffff810bd065>] wq_worker_sleeping+0x15/0xb0
[  135.610996]  [<ffffffff8200fc0b>] __schedule+0x18b/0xa70
[  135.611237]  [<ffffffff810ea3bd>] ? trace_hardirqs_on+0xd/0x10
[  135.630988]  [<ffffffff810a634a>] ? do_exit+0x88a/0x9f0
[  135.631222]  [<ffffffff810a634a>] ? do_exit+0x88a/0x9f0
[  135.650932]  [<ffffffff82010555>] schedule+0x65/0x70
[  135.651186]  [<ffffffff810a6415>] do_exit+0x955/0x9f0
[  135.670899]  [<ffffffff81054a08>] oops_end+0xb8/0xd0
[  135.671136]  [<ffffffff81ffa88a>] no_context+0x309/0x352
[  135.671373]  [<ffffffff81ffaa98>] __bad_area_nosemaphore+0x1c5/0x1e4
[  135.691185]  [<ffffffff81ffaaca>] bad_area_nosemaphore+0x13/0x15
[  135.710934]  [<ffffffff81093f26>] __do_page_fault+0x266/0x590
[  135.711292]  [<ffffffff810c8d20>] ? task_rq_lock+0x50/0xb0
[  135.730941]  [<ffffffff810c8d20>] ? task_rq_lock+0x50/0xb0
[  135.731200]  [<ffffffff820150f2>] ? _raw_spin_lock+0x62/0x70
[  135.750949]  [<ffffffff810c8d20>] ? task_rq_lock+0x50/0xb0
[  135.751195]  [<ffffffff810ea166>] ? trace_hardirqs_on_caller+0x16/0x260
[  135.770989]  [<ffffffff810e7c6f>] ? trace_hardirqs_off_caller+0x1f/0x160
[  135.771309]  [<ffffffff81094296>] do_page_fault+0x46/0x80
[  135.791081]  [<ffffffff82017c72>] page_fault+0x22/0x30
[  135.791310]  [<ffffffff81eafe3f>] ? modify_irte+0x2f/0xd0
[  135.811037]  [<ffffffff81eafe50>] ? modify_irte+0x40/0xd0
[  135.811315]  [<ffffffff81eafe3f>] ? modify_irte+0x2f/0xd0
[  135.831150]  [<ffffffff81eaff26>] intel_irq_remapping_activate+0x16/0x20
[  135.831461]  [<ffffffff81106761>] irq_domain_activate_irq+0x41/0x50
[  135.851716]  [<ffffffff8110674b>] irq_domain_activate_irq+0x2b/0x50
[  135.852020]  [<ffffffff81103f19>] irq_startup+0x29/0x70
[  135.871401]  [<ffffffff81102857>] __setup_irq+0x327/0x590
[  135.871653]  [<ffffffff81a3d820>] ? ahci_bad_pmp_check_ready+0x70/0x70
[  135.891334]  [<ffffffff81102c42>] request_threaded_irq+0xf2/0x150
[  135.911099]  [<ffffffff81a3d820>] ? ahci_bad_pmp_check_ready+0x70/0x70
[  135.911416]  [<ffffffff81a3ff90>] ? ahci_host_activate+0x180/0x180
[  135.931274]  [<ffffffff8110495f>] devm_request_threaded_irq+0x5f/0xb0
[  135.931568]  [<ffffffff81a3feb3>] ahci_host_activate+0xa3/0x180
[  135.951093]  [<ffffffff81a3d391>] ahci_init_one+0x9d1/0xac0
[  135.951375]  [<ffffffff8157d735>] local_pci_probe+0x45/0xa0
[  135.971111]  [<ffffffff810b8868>] work_for_cpu_fn+0x18/0x30
[  135.971366]  [<ffffffff810bbd24>] process_one_work+0x254/0x470
[  135.991196]  [<ffffffff810bbc89>] ? process_one_work+0x1b9/0x470
[  135.991477]  [<ffffffff810bce1b>] worker_thread+0x31b/0x4e0
[  136.011132]  [<ffffffff810ea3bd>] ? trace_hardirqs_on+0xd/0x10
[  136.011393]  [<ffffffff810bcb00>] ? pool_mayday_timeout+0x170/0x170
[  136.031187]  [<ffffffff810c1ff1>] kthread+0x101/0x110
[  136.031420]  [<ffffffff810ea3bd>] ? trace_hardirqs_on+0xd/0x10
[  136.051244]  [<ffffffff810c1ef0>] ? kthread_stop+0x100/0x100
[  136.051494]  [<ffffffff82015e6c>] ret_from_fork+0x7c/0xb0
[  136.071210]  [<ffffffff810c1ef0>] ? kthread_stop+0x100/0x100
[  136.071495] Code: 00 48 89 e5 5d 48 8b 40 88 48 c1 e8 02 83 e0 01
c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 b8 08 00 00
55 48 89 e5 <48> 8b 40 98 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
66 90
[  136.111619] RIP  [<ffffffff810c2530>] kthread_data+0x10/0x20
[  136.131069]  RSP <ffff8810252fb538>
[  136.131253] CR2: ffffffffffffff98
[  136.131406] ---[ end trace fee039719f1667e0 ]---
[  136.151131] Fixing recursive fault but reboot is needed!

It is in tip/apic

Thanks

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020Ab3EBR4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:56:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53315 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3EBR4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:56:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130502154621.GA23990@redhat.com>
References: <20130430212007.GB18598@redhat.com>
	<20130430213719.GA14988@redhat.com>
	<alpine.LFD.2.02.1305021234510.3972@ionos>
	<20130502154621.GA23990@redhat.com>
Date: Thu, 2 May 2013 10:56:48 -0700
X-Google-Sender-Auth: TwRnedSmdTpjYwaDzbEXFsQlbrk
Message-ID: <CAE9FiQXE5BhtL3eHrvnbdDL+imEvS-rKv_71z53qHfyB4kdOBQ@mail.gmail.com>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 8:46 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, May 02, 2013 at 12:37:26PM +0200, Thomas Gleixner wrote:
>
>  > > On a second machine, I'm seeing an oops even earlier. As soon as I
>  > > exit grub, I get a blinking cursor.  If I boot with earlyprintk=vga
>  > > I can see..
>  > >
>  > > Call Trace:
>  > >  <IRQ>
>  > >   tick_check_oneshot_broadcast
>  > >   tick_check_idle
>  > >   irq_enter
>  > >   do_IRQ
>  > >   common_interrupt
>  > >  <EOI>
>  > >   x86_64_start_reservations
>  > >   x86_64_start_kernel
>  > > RIP: clockevents_set_mode+0x18
>  > >

trace:
[    3.394328] ------------[ cut here ]------------
[    3.394346] WARNING: at kernel/time/clockevents.c:209
clockevents_program_event+0x3b/0x100()
[    3.394349] Modules linked in:
[    3.394355] CPU: 10 PID: 0 Comm: swapper/10 Not tainted
3.9.0-yh-07884-g14d850d-dirty #1534
[    3.394357] Hardware name: Oracle Corporation  unknown       /
, BIOS 11016600    05/17/2011
[    3.394373]  0000000000000009 ffff88203e203ed8 ffffffff82091492
ffff88203e203f18
[    3.394381]  ffffffff81088990 ffff88203e203f08 80000000003d08ff
80000000003d08ff
[    3.394389]  000000000000000a ffff8810275e7fd8 0000000000000000
ffff88203e203f28
[    3.394390] Call Trace:
[    3.394405]  <IRQ>  [<ffffffff82091492>] dump_stack+0x19/0x1b
[    3.394415]  [<ffffffff81088990>] warn_slowpath_common+0x70/0xa0
[    3.394419]  [<ffffffff810889da>] warn_slowpath_null+0x1a/0x20
[    3.394422]  [<ffffffff810e312b>] clockevents_program_event+0x3b/0x100
[    3.394427]  [<ffffffff810e35ec>] tick_handle_periodic+0x4c/0x80
[    3.394434]  [<ffffffff820aed4d>] smp_apic_timer_interrupt+0x8d/0xa3
[    3.394444]  [<ffffffff820ae06f>] apic_timer_interrupt+0x6f/0x80
[    3.394453]  <EOI>  [<ffffffff810527f7>] ? default_idle+0x57/0xd0
[    3.394457]  [<ffffffff810527f5>] ? default_idle+0x55/0xd0
[    3.394461]  [<ffffffff81053078>] arch_cpu_idle+0x18/0x20
[    3.394465]  [<ffffffff810dbec5>] cpu_startup_entry+0x165/0x210
[    3.394473]  [<ffffffff8207f81d>] start_secondary+0x1df/0x1e6
[    3.394497] ---[ end trace d8b8ac23062f0bee ]---
[    3.660026] Initializing CPU#11
[    3.660229] CPU 11/26: logical apicid:00020040 in cluster 0002

then panic with cpu 64.


[   10.253249] smpboot: CPU64: Intel(R) Xeon(R) CPU           X7560  @
2.27GHz (fam: 06, model: 2e, stepping: 06)
[   10.269640] checking TSC synchronization [CPU#0 -> CPU#64]: passed.
[   10.272017] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000048
[   10.289803] IP: [<ffffffff810e3c46>] tick_do_broadcast+0x86/0xa0
[   10.309535] PGD 0
[   10.309683] Oops: 0000 [#1] SMP
[   10.309885] Modules linked in:
[   10.310069] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W
3.9.0-yh-07884-g14d850d-dirty #1534
[   10.340098] Hardware name: Oracle Corporation  unknown       /
, BIOS 11016600    05/17/2011
[   10.359764] task: ffff8810274f0000 ti: ffff8810274ee000 task.ti:
ffff8810274ee000
[   10.379412] RIP: 0010:[<ffffffff810e3c46>]  [<ffffffff810e3c46>]
tick_do_broadcast+0x86/0xa0
[   10.379871] RSP: 0000:ffff88103de03e68  EFLAGS: 00010002
[   10.399560] RAX: 0000000000000000 RBX: ffff88103d848000 RCX: 0000000000000002
[   10.399918] RDX: 0000000000000000 RSI: 0000000000000080 RDI: ffff88103d848000
[   10.419810] RBP: ffff88103de03e78 R08: 0000000000000040 R09: 0000000000000002
[   10.439551] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000d880
[   10.439918] R13: ffffffff82a20680 R14: 0000000000000000 R15: 0000000000000001
[   10.459717] FS:  0000000000000000(0000) GS:ffff88103de00000(0000)
knlGS:0000000000000000
[   10.479545] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   10.479853] CR2: 0000000000000048 CR3: 000000807ea14000 CR4: 00000000000007f0
[   10.499624] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   10.519441] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   10.519839] Stack:
[   10.519953]  ffffffff82a20680 ffffffff82a2d6c0 ffff88103de03e88
ffffffff810e3e41
[   10.539793]  ffff88103de03ea8 ffffffff810e3e64 ffffffff82a20680
0000000000000000
[   10.559593]  ffff88103de03eb8 ffffffff8104cc55 ffff88103de03f08
ffffffff81111b82
[   10.560012] Call Trace:
[   10.579490]  <IRQ>
[   10.579588]  [<ffffffff810e3e41>] tick_do_periodic_broadcast+0x41/0x50
[   10.579976]  [<ffffffff810e3e64>] tick_handle_periodic_broadcast+0x14/0x60
[   10.599726]  [<ffffffff8104cc55>] timer_interrupt+0x15/0x20
[   10.619453]  [<ffffffff81111b82>] handle_irq_event_percpu+0x62/0x1e0
[   10.619787]  [<ffffffff81111d48>] handle_irq_event+0x48/0x70
[   10.639517]  [<ffffffff811147de>] ? handle_edge_irq+0x1e/0x130
[   10.639830]  [<ffffffff811148b8>] handle_edge_irq+0xf8/0x130
[   10.659531]  [<ffffffff8104c4c2>] handle_irq+0x22/0x40
[   10.659802]  [<ffffffff820aec4a>] do_IRQ+0x5a/0xd0
[   10.679485]  [<ffffffff820a4eaf>] common_interrupt+0x6f/0x6f
[   10.679769]  <EOI>
[   10.679882]  [<ffffffff810eb086>] ? mark_held_locks+0x136/0x150
[   10.699615]  [<ffffffff8207fe7f>] ? native_cpu_up+0x5ad/0x62d
[   10.699958]  [<ffffffff82081179>] _cpu_up+0xc0/0x133
[   10.719594]  [<ffffffff820812c5>] cpu_up+0xd9/0xec
[   10.719860]  [<ffffffff82db4239>] smp_init+0x76/0xa6
[   10.739553]  [<ffffffff82d9423d>] kernel_init_freeable+0xcd/0x251
[   10.739879]  [<ffffffff82074850>] ? rest_init+0xd0/0xd0
[   10.759555]  [<ffffffff8207485e>] kernel_init+0xe/0xf0
[   10.759833]  [<ffffffff820ad29c>] ret_from_fork+0x7c/0xb0
[   10.779528]  [<ffffffff82074850>] ? rest_init+0xd0/0xd0
[   10.779779] Code: 85 c0 75 2a 48 63 35 5e f8 ac 01 48 89 df 49 c7
c4 80 d8 00 00 e8 cb 50 41 00 89 c0 48 89 df 48 8b 04 c5 e0 74 ba 82
4a 8b 04 20 <ff> 50 48 48 8b 5d f0 4c 8b 65 f8 c9 c3 66 66 66 66 2e 0f
1f 84
[   10.819807] RIP  [<ffffffff810e3c46>] tick_do_broadcast+0x86/0xa0
[   10.820147]  RSP <ffff88103de03e68>
[   10.839550] CR2: 0000000000000048
[   10.839723] ---[ end trace d8b8ac23062f0bef ]---
[   10.839952] Kernel panic - not syncing: Fatal exception in interrupt
[   11.907579] Shutting down cpus with NMI

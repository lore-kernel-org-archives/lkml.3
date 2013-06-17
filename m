Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3FQWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:48:18 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:34717 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3FQWsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:48:16 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <663668860.20130616103459@eikelenboom.it>
References: <663668860.20130616103459@eikelenboom.it>
Date: Tue, 18 Jun 2013 00:48:14 +0200
Message-ID: <CAJfpegs8Rq=4TOv=zD8QvytZxtL+WNyPT6HdhZKLAYuEgrc1vQ@mail.gmail.com>
Subject: Re: [fuse[[xen][3.10-rc5] kernel oops: BUG: unable to handle kernel
 NULL pointer dereference at 0000000000000008 IP: [<ffffffff81407597>] __list_add+0x17/0xd0
From: Miklos Szeredi <miklos@szeredi.hu>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 10:34 AM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
> Hi All,
>
> Tonight one of my PV guest kernels on Xen oopsed for the looks of it on some fuse activity (by glusterfs).
>
> --
> Sander
>
> Oops:
>
> [107481.132631] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [107481.132650] IP: [<ffffffff81407597>] __list_add+0x17/0xd0
> [107481.132660] PGD 0
> [107481.132664] Oops: 0000 [#1] PREEMPT SMP
> [107481.132670] Modules linked in:
> [107481.132676] CPU: 0 PID: 2851 Comm: glusterfs Not tainted 3.10.0-rc5-20130613-jens-konrad #1
> [107481.132684] task: ffff88000ed30000 ti: ffff88000ef34000 task.ti: ffff88000ef34000
> [107481.132691] RIP: e030:[<ffffffff81407597>]  [<ffffffff81407597>] __list_add+0x17/0xd0
> [107481.132699] RSP: e02b:ffff88000ef35988  EFLAGS: 00010086
> [107481.132703] RAX: ffff88000ec13ff8 RBX: ffff88000d4ca150 RCX: 0000000000000000
> [107481.132709] RDX: 0000000000000000 RSI: ffff88000ec13ff8 RDI: ffff88000d4ca150
> [107481.132716] RBP: ffff88000ef359a8 R08: 0000000000000000 R09: ffff88000ed30700
> [107481.132722] R10: 0000000000000000 R11: 0000000000038d60 R12: 0000000000000001
> [107481.132727] R13: ffff88000d4ca128 R14: ffff88000b7ae600 R15: 0000000000000000
> [107481.132735] FS:  00007f3fcb666700(0000) GS:ffff88000fc00000(0000) knlGS:0000000000000000
> [107481.132742] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [107481.132746] CR2: 0000000000000008 CR3: 000000000db0e000 CR4: 0000000000000660
> [107481.132752] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [107481.132758] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [107481.132763] Stack:
> [107481.132766]  ffff88000fc14140 ffff88000b7ae600 0000000000000001 ffff88000d4ca128
> [107481.132776]  ffff88000ef359c8 ffffffff810cc180 ffff88000d4ca128 ffff88000fc13700
> [107481.132784]  ffff88000ef35a28 ffffffff810cf241 ffff88000ef35a08 ffffffff810cac98
> [107481.132793] Call Trace:
> [107481.132799]  [<ffffffff810cc180>] account_entity_enqueue+0x80/0x90
> [107481.132806]  [<ffffffff810cf241>] enqueue_task_fair+0x211/0xbb0
> [107481.132813]  [<ffffffff810cac98>] ? sched_clock_cpu+0xb8/0x130
> [107481.132819]  [<ffffffff810c59a8>] enqueue_task+0x58/0x60
> [107481.132824]  [<ffffffff810c60bd>] activate_task+0x1d/0x20
> [107481.135844]  [<ffffffff810c63d6>] ttwu_do_activate.constprop.64+0x36/0x70
> [107481.135844]  [<ffffffff810c8917>] try_to_wake_up+0x257/0x320
> [107481.135844]  [<ffffffff810c89ed>] default_wake_function+0xd/0x10
> [107481.135844]  [<ffffffff810bc898>] autoremove_wake_function+0x18/0x40
> [107481.135844]  [<ffffffff810c427d>] __wake_up_common+0x4d/0x80
> [107481.135844]  [<ffffffff810c475b>] __wake_up+0x3b/0x60
> [107481.135844]  [<ffffffff812c0835>] request_end+0xc5/0x190
> [107481.135844]  [<ffffffff812c1d3f>] fuse_dev_do_write+0xa3f/0xd10
> [107481.135844]  [<ffffffff810e59ac>] ? __lock_acquire+0x3dc/0x2040
> [107481.135844]  [<ffffffff8183dc57>] ? sock_aio_read.part.23+0xe7/0x110
> [107481.135844]  [<ffffffff812c23b1>] fuse_dev_write+0x61/0x80
> [107481.135844]  [<ffffffff8117bc0e>] do_sync_readv_writev+0x6e/0xa0
> [107481.135844]  [<ffffffff8117d202>] do_readv_writev+0xe2/0x250
> [107481.135844]  [<ffffffff811bcfe7>] ? ep_poll+0x137/0x390
> [107481.135844]  [<ffffffff810e7a63>] ? lock_release+0x133/0x250
> [107481.135844]  [<ffffffff8117d3a0>] vfs_writev+0x30/0x60
> [107481.135844]  [<ffffffff8117d530>] SyS_writev+0x50/0xc0
> [107481.135844]  [<ffffffff819c12e9>] system_call_fastpath+0x16/0x1b
> [107481.135844] Code: 48 83 c4 08 5b 5d c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <4c> 8b 42 08 49 89 f5 49 89 d4 49 39 f0 75 31 4d 8b 45 00 4d 39

  14:   55                        push   %rbp
  15:   48 89 e5                  mov    %rsp,%rbp
  18:   48 83 ec 20               sub    $0x20,%rsp
  1c:   48 89 5d e8               mov    %rbx,-0x18(%rbp)
  20:   4c 89 65 f0               mov    %r12,-0x10(%rbp)
  24:   48 89 fb                  mov    %rdi,%rbx
  27:   4c 89 6d f8               mov    %r13,-0x8(%rbp)
  2b:   4c 8b 42 08               mov    0x8(%rdx),%r8   <=====

That is the third arg of __list_add (that is head->next) called from
account_entity_enqueue().  So rq_of(cfs_rq)->cfs_tasks.next == NULL.

CC-ing the sched guys.

Thanks,
Miklos


> [107481.135844] RIP  [<ffffffff81407597>] __list_add+0x17/0xd0
> [107481.135844]  RSP <ffff88000ef35988>
> [107481.135844] CR2: 0000000000000008
> [107481.135844] ---[ end trace d628d0543f7ba8cb ]---
> [107481.135844] BUG: spinlock lockup suspected on CPU#0, glusterfs/2851
> [107481.135844]  lock: 0xffff88000fc13700, .magic: dead4ead, .owner: glusterfs/2851, .owner_cpu: 0
> [107481.135844] CPU: 0 PID: 2851 Comm: glusterfs Tainted: G      D      3.10.0-rc5-20130613-jens-konrad #1
> [107481.135844]  ffff88000fc13700 ffff88000fc03ab8 ffffffff819b7f45 ffff88000fc03ad8
> [107481.135844]  ffffffff819b7fd3 ffff88000fc13700 00000000bebf63f0 ffff88000fc03b08
> [107481.135844]  ffffffff81406dd5 ffff88000fc13700 ffff88000fc13700 ffff88000ee0a708
> [107481.135844] Call Trace:
> [107481.135844]  <IRQ>  [<ffffffff819b7f45>] dump_stack+0x19/0x1b
> [107481.135844]  [<ffffffff819b7fd3>] spin_dump+0x8c/0x91
> [107481.135844]  [<ffffffff81406dd5>] do_raw_spin_lock+0x75/0x140
> [107481.135844]  [<ffffffff819bf94e>] _raw_spin_lock+0x3e/0x50
> [107481.135844]  [<ffffffff810c890c>] ? try_to_wake_up+0x24c/0x320
> [107481.135844]  [<ffffffff810c890c>] try_to_wake_up+0x24c/0x320
> [107481.135844]  [<ffffffff810c89ed>] default_wake_function+0xd/0x10
> [107481.135844]  [<ffffffff810bc898>] autoremove_wake_function+0x18/0x40
> [107481.135844]  [<ffffffff810c427d>] __wake_up_common+0x4d/0x80
> [107481.135844]  [<ffffffff810c475b>] __wake_up+0x3b/0x60
> [107481.135844]  [<ffffffff8109bd28>] wake_up_klogd_work_func+0x48/0x80
> [107481.135844]  [<ffffffff8111d52c>] __irq_work_run+0x7c/0xb0
> [107481.135844]  [<ffffffff810dfc80>] ? tick_sched_do_timer+0x40/0x40
> [107481.135844]  [<ffffffff8111d63e>] irq_work_run+0x1e/0x40
> [107481.135844]  [<ffffffff810a7b9d>] update_process_times+0x5d/0x80
> [107481.135844]  [<ffffffff810dfb4e>] tick_sched_handle.isra.12+0x1e/0x50
> [107481.135844]  [<ffffffff810dfcc7>] tick_sched_timer+0x47/0x70
> [107481.135844]  [<ffffffff810bf0df>] __run_hrtimer.isra.28+0x6f/0x120
> [107481.135844]  [<ffffffff810bf9d7>] hrtimer_interrupt+0xf7/0x230
> [107481.135844]  [<ffffffff81008caa>] xen_timer_interrupt+0x3a/0x1f0
> [107481.135844]  [<ffffffff81852dcd>] ? net_rps_action_and_irq_enable.isra.75+0x8d/0xb0
> [107481.135844]  [<ffffffff811111e7>] handle_irq_event_percpu+0x47/0x1a0
> [107481.135844]  [<ffffffff81492a79>] ? info_for_irq+0x9/0x20
> [107481.135844]  [<ffffffff81114422>] handle_percpu_irq+0x42/0x60
> [107481.135844]  [<ffffffff8149322d>] __xen_evtchn_do_upcall+0x33d/0x360
> [107481.135844]  [<ffffffff8111961f>] ? rcu_eqs_enter_common.isra.54+0x3f/0x1f0
> [107481.135844]  [<ffffffff8111a437>] ? rcu_irq_enter+0x97/0x120
> [107481.135844]  [<ffffffff81494c8a>] xen_evtchn_do_upcall+0x2a/0x40
> [107481.135844]  [<ffffffff819c279e>] xen_do_hypervisor_callback+0x1e/0x30
> [107481.135844]  <EOI>  [<ffffffff8100122a>] ? xen_hypercall_xen_version+0xa/0x20
> [107481.135844]  [<ffffffff8100122a>] ? xen_hypercall_xen_version+0xa/0x20
> [107481.135844]  [<ffffffff810e7c5c>] ? lock_acquire+0xdc/0x100
> [107481.135844]  [<ffffffff81008b0d>] ? xen_force_evtchn_callback+0xd/0x10
> [107481.135844]  [<ffffffff810094d2>] ? check_events+0x12/0x20
> [107481.135844]  [<ffffffff819c02fb>] ? _raw_spin_unlock_irq+0x2b/0x70
> [107481.135844]  [<ffffffff81009479>] ? xen_irq_enable_direct_reloc+0x4/0x4
> [107481.135844]  [<ffffffff819c030c>] ? _raw_spin_unlock_irq+0x3c/0x70
> [107481.135844]  [<ffffffff810ab81e>] ? exit_signals+0xae/0x120
> [107481.135844]  [<ffffffff810e7c5c>] ? lock_acquire+0xdc/0x100
> [107481.135844]  [<ffffffff8109e288>] ? do_exit+0xa8/0xa00
> [107481.135844]  [<ffffffff810e7a63>] ? lock_release+0x133/0x250
> [107481.135844]  [<ffffffff8109c409>] ? kmsg_dump+0xf9/0x110
> [107481.135844]  [<ffffffff8109c330>] ? kmsg_dump+0x20/0x110
> [107481.135844]  [<ffffffff810113e6>] ? oops_end+0xa6/0xf0
> [107481.135844]  [<ffffffff819b201e>] ? no_context+0x25f/0x28b
> [107481.135844]  [<ffffffff819b2400>] ? __bad_area_nosemaphore+0x1df/0x1fe
> [107481.135844]  [<ffffffff810e59ac>] ? __lock_acquire+0x3dc/0x2040
> [107481.135844]  [<ffffffff819b242d>] ? bad_area_nosemaphore+0xe/0x10
> [107481.135844]  [<ffffffff8103d976>] ? __do_page_fault+0x326/0x4c0
> [107481.135844]  [<ffffffff810e59ac>] ? __lock_acquire+0x3dc/0x2040
> [107481.135844]  [<ffffffff819c09b7>] ? retint_restore_args+0x13/0x13
> [107481.135844]  [<ffffffff810e1dc9>] ? trace_hardirqs_off_caller+0xb9/0x160
> [107481.135844]  [<ffffffff813ffc6d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [107481.135844]  [<ffffffff8103db39>] ? do_page_fault+0x9/0x10
> [107481.135844]  [<ffffffff819c0cb8>] ? page_fault+0x28/0x30
> [107481.135844]  [<ffffffff81407597>] ? __list_add+0x17/0xd0
> [107481.135844]  [<ffffffff810cc180>] ? account_entity_enqueue+0x80/0x90
> [107481.135844]  [<ffffffff810cf241>] ? enqueue_task_fair+0x211/0xbb0
> [107481.135844]  [<ffffffff810cac98>] ? sched_clock_cpu+0xb8/0x130
> [107481.135844]  [<ffffffff810c59a8>] ? enqueue_task+0x58/0x60
> [107481.135844]  [<ffffffff810c60bd>] ? activate_task+0x1d/0x20
> [107481.135844]  [<ffffffff810c63d6>] ? ttwu_do_activate.constprop.64+0x36/0x70
> [107481.135844]  [<ffffffff810c8917>] ? try_to_wake_up+0x257/0x320
> [107481.135844]  [<ffffffff810c89ed>] ? default_wake_function+0xd/0x10
> [107481.135844]  [<ffffffff810bc898>] ? autoremove_wake_function+0x18/0x40
> [107481.135844]  [<ffffffff810c427d>] ? __wake_up_common+0x4d/0x80
> [107481.135844]  [<ffffffff810c475b>] ? __wake_up+0x3b/0x60
> [107481.135844]  [<ffffffff812c0835>] ? request_end+0xc5/0x190
> [107481.135844]  [<ffffffff812c1d3f>] ? fuse_dev_do_write+0xa3f/0xd10
> [107481.135844]  [<ffffffff810e59ac>] ? __lock_acquire+0x3dc/0x2040
> [107481.135844]  [<ffffffff8183dc57>] ? sock_aio_read.part.23+0xe7/0x110
> [107481.135844]  [<ffffffff812c23b1>] ? fuse_dev_write+0x61/0x80
> [107481.135844]  [<ffffffff8117bc0e>] ? do_sync_readv_writev+0x6e/0xa0
> [107481.135844]  [<ffffffff8117d202>] ? do_readv_writev+0xe2/0x250
> [107481.135844]  [<ffffffff811bcfe7>] ? ep_poll+0x137/0x390
> [107481.135844]  [<ffffffff810e7a63>] ? lock_release+0x133/0x250
> [107481.135844]  [<ffffffff8117d3a0>] ? vfs_writev+0x30/0x60
> [107481.135844]  [<ffffffff8117d530>] ? SyS_writev+0x50/0xc0
> [107481.135844]  [<ffffffff819c12e9>] ? system_call_fastpath+0x16/0x1b
> [107481.135844] sending NMI to all CPUs:
>

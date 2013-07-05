Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3GEOio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab3GEOin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:38:43 -0400
Date: Fri, 5 Jul 2013 10:38:21 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@zytor.com>
Subject: Yet more softlockups.
Message-ID: <20130705143821.GB325@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Peter Anvin <hpa@zytor.com>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 07:49:18PM -0700, Linus Torvalds wrote:

 > Does trinity save enough pseudo-random state that it can be
 > repeatable, because if it's something repeatable it might be
 > interesting to see what the last few system calls and traps were...
 > 
 > > Box is wedged, and I won't be able to get to it until Friday to poke it.

Looks like nothing hit the disk but a bunch of zero byte log files.
I'll add some more syncing to todays runs to see if that helps.

A second almost identical machine (same cpu/chipset/ram) has been hitting
a bunch of different soft lockups btw. (What happened to the good
old days when kernels oopsed instead of locked up?)

These are the ones I sucked out of its logs this morning that looked unique.
They're all merge window builds, but I don't have a log of which git hash
corresponds to each build.


BUG: soft lockup - CPU#3 stuck for 22s! [trinity-child3:20119]
irq event stamp: 2453171
hardirqs last  enabled at (2453170): [<ffffffff816ec620>] restore_args+0x0/0x30
hardirqs last disabled at (2453171): [<ffffffff816f512a>] apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (262552): [<ffffffff810542e4>] __do_softirq+0x194/0x440
softirqs last disabled at (262555): [<ffffffff8105474d>] irq_exit+0xcd/0xe0
CPU: 3 PID: 20119 Comm: trinity-child3 Not tainted 3.10.0+ #16
task: ffff880228c22520 ti: ffff88021e8c8000 task.ti: ffff88021e8c8000
RIP: 0010:[<ffffffff8109bd05>]  [<ffffffff8109bd05>] run_rebalance_domains+0x185/0x1b0
RSP: 0018:ffff880244e03eb0  EFLAGS: 00000246
RAX: ffff880244e00000 RBX: ffffffff816ec620 RCX: 000000000000b910
RDX: 000000000000628a RSI: 0000000010000100 RDI: 0000000000000001
RBP: ffff880244e03ef8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff880244e03e28
R13: ffffffff816f512f R14: ffff880244e03ef8 R15: 0000000000000003
FS:  00007f8d790df740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feed4713010 CR3: 00000002208d6000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 00000000012169c0 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffff88021e8c9fd8 0000000000000003 ffff880244e03ec0 ffff880244e03ec0
 0000000000000007 0000000000000007 0000000000000001 ffffffff81c04138
 0000000000000005 ffff880244e03f70 ffffffff8105424f 0000000a00406040
Call Trace:
 <IRQ> 
 [<ffffffff8105424f>] __do_softirq+0xff/0x440
 [<ffffffff8105474d>] irq_exit+0xcd/0xe0
 [<ffffffff816f5fcb>] smp_apic_timer_interrupt+0x6b/0x9b
 [<ffffffff816f512f>] apic_timer_interrupt+0x6f/0x80
 <EOI> 
 [<ffffffff816e9640>] ? wait_for_completion_interruptible+0x170/0x170
 [<ffffffff816ea6e3>] ? preempt_schedule_irq+0x53/0x90
 [<ffffffff816ec736>] retint_kernel+0x26/0x30
 [<ffffffff811458a7>] ? user_enter+0x87/0xd0
 [<ffffffff8100f6a8>] syscall_trace_leave+0x78/0x140
 [<ffffffff816f47af>] int_check_syscall_exit_work+0x34/0x3d
Code: 85 28 09 00 00 48 89 05 ea 6e 06 01 48 8b 45 c0 48 8b 04 c5 40 51 cf 81 49 c7 c7 00 3f 1d 00 49 01 c7 f0 41 80 a7 88 00 00 00 fd <48> 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 89 7d b8 e8 23 



BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child2:26807]
Modules linked in: bridge 8021q garp stp snd_seq_dummy tun fuse hidp rfcomm ipt_ULOG can_raw nfnetlink scsi_transport_iscsi bnep can_bcm bluetooth ipx p8023 x25 p8022 irda netrom rose llc2 pppoe ax25 pppox ppp_generic appletalk slhc psnap llc can rds af_rxrpc caif_socket caif phonet crc_ccitt af_key atm nfc rfkill af_802154 snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer microcode pcspkr ptp snd pps_core soundcore
irq event stamp: 0
hardirqs last  enabled at (0): [<          (null)>]           (null)
hardirqs last disabled at (0): [<ffffffff8104b009>] copy_process.part.28+0x619/0x15a0
softirqs last  enabled at (0): [<ffffffff8104b009>] copy_process.part.28+0x619/0x15a0
softirqs last disabled at (0): [<          (null)>]           (null)
CPU: 0 PID: 26807 Comm: trinity-child2 Not tainted 3.10.0+ #18 
task: ffff8801cb21a520 ti: ffff8801e06da000 task.ti: ffff8801e06da000
RIP: 0010:[<ffffffff810570c1>]  [<ffffffff810570c1>] __do_softirq+0xb1/0x440
RSP: 0018:ffff880244803f10  EFLAGS: 00000246
RAX: ffff8801e06dbfd8 RBX: ffffffff816f56e0 RCX: 0000000000000001
RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffffffff810570b9
RBP: ffff880244803f78 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880244803e88
R13: ffffffff816fe46f R14: ffff880244803f78 R15: ffff8801cb21a520
FS:  00007f3ac43bd740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001ebb648 CR3: 000000022f70e000 CR4: 00000000001407f0
DR0: 0000000000b76000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 0000000a00406444 0000000100153dba ffff8801e06dbfd8 ffff8801e06dbfd8
 ffff8801e06dbfd8 ffff8801cb21a918 ffff8801e06dbfd8 ffffffff00000000
 ffff8801cb21a520 ffff880229fd8ba1 ffffea00074a15c0 ffff8801e06dbc38
Call Trace:
 <IRQ> 
 [<ffffffff8105760d>] irq_exit+0xcd/0xe0
 [<ffffffff816ff7e5>] smp_apic_timer_interrupt+0x45/0x60
 [<ffffffff816fe46f>] apic_timer_interrupt+0x6f/0x80
 <EOI> 
 [<ffffffff816f56e0>] ? retint_restore_args+0xe/0xe
 [<ffffffff81180aa8>] ? page_remove_rmap+0x18/0xa0
 [<ffffffff81180ae5>] ? page_remove_rmap+0x55/0xa0
 [<ffffffff81173e8d>] unmap_single_vma+0x3dd/0x850
 [<ffffffff811752a9>] unmap_vmas+0x49/0x90
 [<ffffffff8117db41>] exit_mmap+0xc1/0x170
 [<ffffffff8104a1af>] mmput+0x6f/0x100
 [<ffffffff810521dc>] do_exit+0x27c/0xcd0
 [<ffffffff81066371>] ? get_signal_to_deliver+0xb1/0x940
 [<ffffffff8105401c>] do_group_exit+0x4c/0xc0
 [<ffffffff810665a1>] get_signal_to_deliver+0x2e1/0x940
 [<ffffffff810ba51d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810024b8>] do_signal+0x48/0x5a0
 [<ffffffff8131198e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816f57f6>] ? retint_kernel+0x26/0x30
 [<ffffffff816f32f3>] ? preempt_schedule_irq+0x63/0x90
 [<ffffffff816f56e0>] ? retint_restore_args+0xe/0xe
 [<ffffffff810954f9>] ? vtime_account_user+0x69/0x70
 [<ffffffff8114a5f5>] ? user_exit+0x45/0x90
 [<ffffffff8114a5f7>] ? user_exit+0x47/0x90
 [<ffffffff81002a88>] do_notify_resume+0x78/0x90
 [<ffffffff816fdb0a>] int_signal+0x12/0x17
Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 57 34 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 


BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child1:14565]
Modules linked in: dlci snd_seq_dummy hidp tun fuse bnep rfcomm ipt_ULOG nfnetlink scsi_transport_iscsi af_802154 can_bcm af_rxrpc bluetooth irda af_key rose atm x25 netrom can_raw phonet caif_socket can caif crc_ccitt appletalk llc2 ipx nfc p8023 rds rfkill psnap pppoe p8022 llc ax25 pppox ppp_generic slhc snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec pcspkr snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd pps_core soundcore
irq event stamp: 0
hardirqs last  enabled at (0): [<          (null)>]           (null)
hardirqs last disabled at (0): [<ffffffff8104aa61>] copy_process.part.27+0x611/0x15b0
softirqs last  enabled at (0): [<ffffffff8104aa61>] copy_process.part.27+0x611/0x15b0
softirqs last disabled at (0): [<          (null)>]           (null)
CPU: 3 PID: 14565 Comm: trinity-child1 Not tainted 3.10.0+ #20
task: ffff88022caa0000 ti: ffff880212676000 task.ti: ffff880212676000
RIP: 0010:[<ffffffff81056ba1>]  [<ffffffff81056ba1>] __do_softirq+0xb1/0x440
RSP: 0000:ffff880244e03f10  EFLAGS: 00000246
RAX: ffff880212677fd8 RBX: ffffffff816fc660 RCX: 0000000010624dd3
RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffffffff81056b99
RBP: ffff880244e03f78 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880244e03e88
R13: ffffffff817053ef R14: ffff880244e03f78 R15: ffff88022caa0000
FS:  00007f959367e740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8c6657e968 CR3: 00000001cb73e000 CR4: 00000000001407e0
DR0: 0000000000a51000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 0000000a00406040 000000010003d260 ffff880212677fd8 ffff880212677fd8
 ffff880212677fd8 ffff88022caa03f8 ffff880212677fd8 ffffffff00000003
 ffff88022caa0000 ffff880212677fd8 0000000002461be8 ffff880212677f58
Call Trace:
 <IRQ> 
 [<ffffffff810570ed>] irq_exit+0xcd/0xe0
 [<ffffffff81706765>] smp_apic_timer_interrupt+0x45/0x60
 [<ffffffff817053ef>] apic_timer_interrupt+0x6f/0x80
 <EOI> 
 [<ffffffff816fc660>] ? retint_restore_args+0xe/0xe
 [<ffffffff816fc776>] ? retint_kernel+0x26/0x30
 [<ffffffff816fa24d>] ? preempt_schedule_irq+0x4d/0x90
 [<ffffffff816f9230>] ? wait_for_completion_interruptible+0x180/0x180
 [<ffffffff816fa253>] ? preempt_schedule_irq+0x53/0x90
 [<ffffffff816fc776>] retint_kernel+0x26/0x30
 [<ffffffff8117da38>] ? find_vma+0x58/0x60
 [<ffffffff816ffa79>] __do_page_fault+0x109/0x5d0
 [<ffffffff810b7a6d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff811106ef>] ? __acct_update_integrals+0x7f/0xf0
 [<ffffffff8108fc5d>] ? get_parent_ip+0xd/0x50
 [<ffffffff817004a1>] ? sub_preempt_count+0x71/0x100
 [<ffffffff816fb931>] ? _raw_spin_unlock+0x31/0x60
 [<ffffffff81095ab9>] ? vtime_account_user+0x69/0x70
 [<ffffffff816fff6c>] do_page_fault+0x2c/0x50
 [<ffffffff816fc8a2>] page_fault+0x22/0x30
Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0d 1d 00 00 00 00 00 e8 17 47 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
Bridge firewalling registered
perf samples too long (2519 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
INFO: NMI handler (perf_event_nmi_handler) took too long to run: 238147.002 msecs



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3LQS27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:28:59 -0500
Received: from mailout02.t-online.de ([194.25.134.17]:43344 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab3LQS2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:28:55 -0500
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 13:28:55 EST
Message-ID: <52B09446.7060809@t-online.de>
Date: Tue, 17 Dec 2013 19:13:26 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUG: 3.13.0-rc4] inconsistent lock state
Content-Type: multipart/mixed;
 boundary="------------080105030207090507030100"
X-ID: rXKS3+ZVghpauOLnyT-mvv9iTqZLH7uF1U6KAprhoOzdFlzeIk2xEB0dww7kLyqQc+
X-TOI-MSGID: b4f4a8d7-98e9-4c14-9097-536774a85825
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080105030207090507030100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Linus / everybody!

Booting openSuSE 13.1 with kernel 3.13.0-rc4 triggers the attached
warning.

cu,
  Knut



--------------080105030207090507030100
Content-Type: text/plain; charset=UTF-8;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages"

golem kernel: [   25.324096] 
golem kernel: [   25.326525] =================================
golem kernel: [   25.328009] [ INFO: inconsistent lock state ]
golem kernel: [   25.328009] 3.13.0-rc4-main #89 Not tainted
golem kernel: [   25.328009] ---------------------------------
golem kernel: [   25.328009] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
golem kernel: [   25.328009] SuSEfirewall2/1453 [HC0[0]:SC1[1]:HE1:SE0] takes:
golem kernel: [   25.328009]  (&(&sk->sk_dst_lock)->rlock){+.?...}, at: [<c0516fe1>] __udp4_lib_rcv+0x4db/0x6d2
golem kernel: [   25.328009] {SOFTIRQ-ON-W} state was registered at:
golem kernel: [   25.328009]   [<c0154319>] __lock_acquire+0x6d5/0x1556
golem kernel: [   25.328009]   [<c0155733>] lock_acquire+0x72/0xc9
golem kernel: [   25.328009]   [<c054e122>] _raw_spin_lock+0x2a/0x39
golem kernel: [   25.328009]   [<c04fdff3>] inet_csk_listen_start+0x7d/0xc1
golem kernel: [   25.328009]   [<c051cff2>] inet_listen+0x145/0x16b
golem kernel: [   25.328009]   [<c04c23d4>] SyS_listen+0x48/0x63
golem kernel: [   25.328009]   [<c04c3096>] SyS_socketcall+0xb4/0x1fc
golem kernel: [   25.328009]   [<c0553df4>] sysenter_do_call+0x12/0x32
golem kernel: [   25.328009] irq event stamp: 53738
golem kernel: [   25.328009] hardirqs last  enabled at (53738): [<c012dc10>] local_bh_enable+0x92/0xa4
golem kernel: [   25.328009] hardirqs last disabled at (53737): [<c012dbc2>] local_bh_enable+0x44/0xa4
golem kernel: [   25.328009] softirqs last  enabled at (41266): [<c012d9aa>] __do_softirq+0x168/0x21a
golem kernel: [   25.328009] softirqs last disabled at (53653): [<c0102bff>] do_softirq_own_stack+0x34/0x3a
golem kernel: [   25.328009] 
golem kernel: [   25.328009] other info that might help us debug this:
golem kernel: [   25.328009]  Possible unsafe locking scenario:
golem kernel: [   25.328009] 
golem kernel: [   25.328009]        CPU0
golem kernel: [   25.328009]        ----
golem kernel: [   25.328009]   lock(&(&sk->sk_dst_lock)->rlock);
golem kernel: [   25.328009]   <Interrupt>
golem kernel: [   25.328009]     lock(&(&sk->sk_dst_lock)->rlock);
golem kernel: [   25.328009] 
golem kernel: [   25.328009]  *** DEADLOCK ***
golem kernel: [   25.328009] 
golem kernel: [   25.328009] 5 locks held by SuSEfirewall2/1453:
golem kernel: [   25.328009]  #0:  (&dup_mmap_sem){.+.+.+}, at: [<c01ab8c4>] uprobe_start_dup_mmap+0x12/0x14
golem kernel: [   25.328009]  #1:  (&mm->mmap_sem){++++++}, at: [<c0128491>] dup_mm+0x8c/0x3a4
golem kernel: [   25.328009]  #2:  (&mm->mmap_sem/1){+.+.+.}, at: [<c01284aa>] dup_mm+0xa5/0x3a4
golem kernel: [   25.328009]  #3:  (rcu_read_lock){.+.+..}, at: [<c04cfe90>] __netif_receive_skb_core+0x136/0x5c2
golem kernel: [   25.328009]  #4:  (rcu_read_lock){.+.+..}, at: [<c04f3f4f>] ip_local_deliver_finish+0x2b/0x21b
golem kernel: [   25.328009] 
golem kernel: [   25.328009] stack backtrace:
golem kernel: [   25.328009] CPU: 0 PID: 1453 Comm: SuSEfirewall2 Not tainted 3.13.0-rc4-main #89
golem kernel: [   25.328009] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 09/14/2005
golem kernel: [   25.328009]  00000000 f02d0110 f600bd60 c0548f1f f600bd80 c054714f c06d12e1 c06d11e0
golem kernel: [   25.328009]  c06d1fe2 f02d05ec f02d0110 c0152caa f600bda4 c015361e 00000004 00000000
golem kernel: [   25.328009]  00000006 00000004 f02d05e8 00000002 f02d05ec f600be04 c01542a6 c0153a54
golem kernel: [   25.328009] Call Trace:
golem kernel: [   25.328009]  [<c0548f1f>] dump_stack+0x16/0x18
golem kernel: [   25.328009]  [<c054714f>] print_usage_bug+0x21f/0x22b
golem kernel: [   25.328009]  [<c0152caa>] ? check_usage_backwards+0xda/0xda
golem kernel: [   25.328009]  [<c015361e>] mark_lock+0x2c4/0x4c2
golem kernel: [   25.328009]  [<c01542a6>] __lock_acquire+0x662/0x1556
golem kernel: [   25.328009]  [<c0153a54>] ? trace_hardirqs_on+0xb/0xd
golem kernel: [   25.328009]  [<fa07d588>] ? nf_conntrack_seqadj_fini+0x15/0x15 [nf_conntrack]
golem kernel: [   25.328009]  [<c0154363>] ? __lock_acquire+0x71f/0x1556
golem kernel: [   25.328009]  [<c0155733>] lock_acquire+0x72/0xc9
golem kernel: [   25.328009]  [<c0516fe1>] ? __udp4_lib_rcv+0x4db/0x6d2
golem kernel: [   25.328009]  [<c054e122>] _raw_spin_lock+0x2a/0x39
golem kernel: [   25.328009]  [<c0516fe1>] ? __udp4_lib_rcv+0x4db/0x6d2
golem kernel: [   25.328009]  [<c0516fe1>] __udp4_lib_rcv+0x4db/0x6d2
golem kernel: [   25.328009]  [<c05175e7>] udp_rcv+0x17/0x19
golem kernel: [   25.328009]  [<c04f4027>] ip_local_deliver_finish+0x103/0x21b
golem kernel: [   25.328009]  [<c04f45bd>] ip_local_deliver+0x75/0x7a
golem kernel: [   25.328009]  [<c04f43e3>] ip_rcv_finish+0x2a4/0x332
golem kernel: [   25.328009]  [<c04f481d>] ip_rcv+0x25b/0x2ba
golem kernel: [   25.328009]  [<c04d0291>] __netif_receive_skb_core+0x537/0x5c2
golem kernel: [   25.328009]  [<c04d0ada>] __netif_receive_skb+0x1b/0x57
golem kernel: [   25.328009]  [<c04d0b4d>] netif_receive_skb+0x37/0x3a
golem kernel: [   25.328009]  [<c04d12a3>] napi_gro_receive+0x36/0x72
golem kernel: [   25.328009]  [<c045a5d3>] sky2_poll+0x6c1/0x98c
golem kernel: [   25.328009]  [<c01539fb>] ? trace_hardirqs_on_caller+0x11d/0x16b
golem kernel: [   25.328009]  [<c04d0d71>] net_rx_action+0xaa/0x19e
golem kernel: [   25.328009]  [<c012d900>] __do_softirq+0xbe/0x21a
golem kernel: [   25.328009]  [<c012d842>] ? __tasklet_hrtimer_trampoline+0x33/0x33
golem kernel: [   25.328009]  <IRQ>  [<c012dcc0>] ? irq_exit+0x46/0x81
golem kernel: [   25.328009]  [<c011ccba>] ? smp_apic_timer_interrupt+0x36/0x3f
golem kernel: [   25.328009]  [<c054ee6b>] ? apic_timer_interrupt+0x2f/0x34
golem kernel: [   25.328009]  [<c01c007b>] ? bdi_has_dirty_io+0x37/0x46
golem kernel: [   25.328009]  [<c0128626>] ? dup_mm+0x221/0x3a4
golem kernel: [   25.328009]  [<c01293d0>] ? copy_process.part.34+0xc02/0x104e
golem kernel: [   25.328009]  [<c0129981>] ? do_fork+0xab/0x263
golem kernel: [   25.328009]  [<c02f7b6a>] ? _copy_to_user+0x41/0x4c
golem kernel: [   25.328009]  [<c02f7764>] ? trace_hardirqs_on_thunk+0xc/0x10
golem kernel: [   25.328009]  [<c0553e23>] ? sysenter_exit+0xf/0x16
golem kernel: [   25.328009]  [<c0129bb0>] ? SyS_clone+0x1b/0x1d
golem kernel: [   25.328009]  [<c0553df4>] ? sysenter_do_call+0x12/0x32

--------------080105030207090507030100--

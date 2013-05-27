Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3E0LqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:46:24 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:43810 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3E0LqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:46:23 -0400
Message-ID: <51A34788.5080204@profitbricks.com>
Date: Mon, 27 May 2013 13:46:16 +0200
From: Jack Wang <jinpu.wang@profitbricks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel tried to execute NX-protected page - exploit attempt? (uid:
 998)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We saw below bug in our production.

Kernel is linux 3.4.23, as I know it means control was transferred to a
data page. This could happen because of a stack overflow (overwrite
return address with bogus pointer into data pages), or by calling a
function pointer which isn't pointing where it's supposed to be pointing?
>From the back trace it seems code BUG at VFS layer, I checked commit
history in file fs/namei.c, not found any clue, I also checked commit
history from 3.4.23 to 3.4.47, haven't find possible fix.

Anyone can give some suggestion or clue about this bug?


May 26 02:17:27 pserver107 pbmonitor: List sent (264 entries out of 616
total, 616 allocated)
May 26 02:18:02 pserver107 slog[3485]: vcb: VM (UUID
724a9458-ae76-b9c7-3434-ea9800effcff) not running.
May 26 02:18:03 pserver107 slog[3485]: vcb: VM (UUID
b62739d1-738f-d02d-b35d-ffadcf9251a8) not running.
May 26 02:18:04 pserver107 slog[3485]: vcb: VM (UUID
5b378a75-5512-4ea1-99ba-933c2d2c1716) not running.
May 26 02:19:04 pserver107 [736175.109085] kernel tried to execute
NX-protected page - exploit attempt? (uid: 998)
May 26 02:19:04 pserver107 [736175.109310] BUG: unable to handle kernel
May 26 02:19:04 pserver107  at ffff8807f9287e08
May 26 02:19:04 pserver107 [736175.109429] IP:
May 26 02:19:04 pserver107  [<ffff8807f9287e08>] 0xffff8807f9287e07
May 26 02:19:04 pserver107 [736175.109545] PGD 1a0c063
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.109664] Oops: 0011 [#1]
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.109782] CPU 50
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.109796] Modules linked in:
May 26 02:19:04 pserver107  fuse
May 26 02:19:04 pserver107  bridge
May 26 02:19:04 pserver107  stp
May 26 02:19:04 pserver107  llc
May 26 02:19:04 pserver107  nf_conntrack_ipv6
May 26 02:19:04 pserver107  nf_defrag_ipv6
May 26 02:19:04 pserver107  ip6table_filter
May 26 02:19:04 pserver107  ip6_tables
May 26 02:19:04 pserver107  dm_round_robin
May 26 02:19:04 pserver107  sd_mod
May 26 02:19:04 pserver107  crc_t10dif
May 26 02:19:04 pserver107  ib_srp
May 26 02:19:04 pserver107  scsi_transport_srp
May 26 02:19:04 pserver107  scsi_tgt
May 26 02:19:04 pserver107  xt_ETHOIP6(O)
May 26 02:19:04 pserver107  x_tables
May 26 02:19:04 pserver107  vhost_net(O)
May 26 02:19:04 pserver107  macvtap
May 26 02:19:04 pserver107  macvlan
May 26 02:19:04 pserver107  tun(O)
May 26 02:19:04 pserver107  nf_conntrack_ipv4
May 26 02:19:04 pserver107  nf_conntrack
May 26 02:19:04 pserver107  nf_defrag_ipv4
May 26 02:19:04 pserver107  rdma_ucm
May 26 02:19:04 pserver107  rdma_cm
May 26 02:19:04 pserver107  iw_cm
May 26 02:19:04 pserver107  ib_addr
May 26 02:19:04 pserver107  ib_ipoib
May 26 02:19:04 pserver107  ib_cm
May 26 02:19:04 pserver107  ib_sa
May 26 02:19:04 pserver107  ib_uverbs
May 26 02:19:04 pserver107  ib_umad
May 26 02:19:04 pserver107  ib_qib
May 26 02:19:04 pserver107  mlx4_ib
May 26 02:19:04 pserver107  ib_mthca
May 26 02:19:04 pserver107  ib_mad
May 26 02:19:04 pserver107  ib_core
May 26 02:19:04 pserver107  dm_multipath
May 26 02:19:04 pserver107  scsi_dh
May 26 02:19:04 pserver107  kvm_amd
May 26 02:19:04 pserver107  kvm
May 26 02:19:04 pserver107  sg
May 26 02:19:04 pserver107  powernow_k8
May 26 02:19:04 pserver107  psmouse
May 26 02:19:04 pserver107  mperf
May 26 02:19:04 pserver107  crc32c_intel
May 26 02:19:04 pserver107  microcode
May 26 02:19:04 pserver107  tpm_tis
May 26 02:19:04 pserver107  tpm
May 26 02:19:04 pserver107  tpm_bios
May 26 02:19:04 pserver107  serio_raw
May 26 02:19:04 pserver107  evdev
May 26 02:19:04 pserver107  usb_storage
May 26 02:19:04 pserver107  scsi_mod
May 26 02:19:04 pserver107  amd64_edac_mod
May 26 02:19:04 pserver107  edac_core
May 26 02:19:04 pserver107  edac_mce_amd
May 26 02:19:04 pserver107  i2c_piix4
May 26 02:19:04 pserver107  button
May 26 02:19:04 pserver107  processor
May 26 02:19:04 pserver107  thermal_sys
May 26 02:19:04 pserver107  mlx4_core
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.111104]
May 26 02:19:04 pserver107 [736175.111202] Pid: 3485, comm: vcb Tainted:
G           O 3.4.23-pserver #1
May 26 02:19:04 pserver107  Supermicro H8QG6
May 26 02:19:04 pserver107 /H8QG6
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.111423] RIP: 0010:[<ffff8807f9287e08>]
May 26 02:19:04 pserver107  [<ffff8807f9287e08>] 0xffff8807f9287e07
May 26 02:19:04 pserver107 [736175.111626] RSP: 0018:ffff8807f9287cf0
EFLAGS: 00010286
May 26 02:19:04 pserver107 [736175.111737] RAX: ffffffff81345cb0 RBX:
ffff88080740e910 RCX: 0000000000000038
May 26 02:19:04 pserver107 [736175.111938] RDX: 0000000000000125 RSI:
ffff882ffeef6630 RDI: ffff882ffeef6630
May 26 02:19:04 pserver107 [736175.112147] RBP: ffffffff811923c9 R08:
0000000000000007 R09: ffff880803b07d78
May 26 02:19:04 pserver107 [736175.112364] R10: 0000000030303532 R11:
ffff8807f9287d90 R12: ffff880803b07d40
May 26 02:19:04 pserver107 [736175.112563] R13: ffff8830044c3ec0 R14:
ffff881804288020 R15: ffff880803b07d40
May 26 02:19:04 pserver107 [736175.112765] FS:  00007f8ea805b840(0000)
GS:ffff883807c80000(0000) knlGS:0000000000000000
May 26 02:19:04 pserver107 [736175.112966] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
May 26 02:19:04 pserver107 [736175.113082] CR2: ffff8807f9287e08 CR3:
00000007f4ca5000 CR4: 00000000000407e0
May 26 02:19:04 pserver107 [736175.113286] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 26 02:19:04 pserver107 [736175.113484] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 26 02:19:04 pserver107 [736175.113716] Process vcb (pid: 3485,
threadinfo ffff8807f9286000, task ffff8807f8f5ed00)
May 26 02:19:04 pserver107 [736175.113914] Stack:
May 26 02:19:04 pserver107 [736175.114009]  ffff8807f9287e68
May 26 02:19:04 pserver107  ffff8807f9287d90
May 26 02:19:04 pserver107  ffffffff811402f8
May 26 02:19:04 pserver107  ffff8807f9287e68
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.114234]  ffff883803caa00b
May 26 02:19:04 pserver107  00000001f9287e68
May 26 02:19:04 pserver107  ffff8807f9287e78
May 26 02:19:04 pserver107  000000000740da70
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.114455]  ffff8807f8f5ed00
May 26 02:19:04 pserver107  ffff8807f8f5ed00
May 26 02:19:04 pserver107  ffff8807f9287e68
May 26 02:19:04 pserver107  0000000000000000
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.114668] Call Trace:
May 26 02:19:04 pserver107 [736175.114784]  [<ffffffff811402f8>] ?
do_lookup+0x1e8/0x300
May 26 02:19:04 pserver107 [736175.114897]  [<ffffffff81140f4e>] ?
do_last+0xee/0x810
May 26 02:19:04 pserver107 [736175.115007]  [<ffffffff8114201c>] ?
path_openat+0xdc/0x400
May 26 02:19:04 pserver107 [736175.115119]  [<ffffffff8114246d>] ?
do_filp_open+0x4d/0xc0
May 26 02:19:04 pserver107 [736175.115242]  [<ffffffff8114eb73>] ?
alloc_fd+0x43/0x110
May 26 02:19:04 pserver107 [736175.115358]  [<ffffffff811337e8>] ?
do_sys_open+0x108/0x1f0
May 26 02:19:04 pserver107 [736175.115470]  [<ffffffff8167d6f9>] ?
system_call_fastpath+0x16/0x1b
May 26 02:19:04 pserver107 [736175.115582] Code:
May 26 02:19:04 pserver107
May 26 02:19:04 pserver107 [736175.116307] RIP
May 26 02:19:04 pserver107  [<ffff8807f9287e08>] 0xffff8807f9287e07
May 26 02:19:04 pserver107 [736175.116424]  RSP <ffff8807f9287cf0>
May 26 02:19:04 pserver107 [736175.116524] CR2: ffff8807f9287e08
May 26 02:19:04 pserver107 [736175.117066] ---[ end trace
647706783ef79f30 ]---
May 26 02:24:07 pserver107 [736477.198178] INFO: rcu_sched self-detected
stall on CPU
May 26 02:24:07 pserver107  {
May 26 02:24:07 pserver107  60
May 26 02:24:07 pserver107 }
May 26 02:24:07 pserver107  (t=30001 jiffies)
May 26 02:24:07 pserver107 [736477.200278] Pid: 2411, comm: pbmonitor
Tainted: G      D    O 3.4.23-pserver #1
May 26 02:24:07 pserver107 [736477.200535] Call Trace:
May 26 02:24:07 pserver107 [736477.200695]  <IRQ>
May 26 02:24:07 pserver107  [<ffffffff810b3451>] ? __rcu_pending+0x1a1/0x4d0
May 26 02:24:07 pserver107 [736477.200940]  [<ffffffff81084d50>] ?
tick_nohz_handler+0xe0/0xe0
May 26 02:24:07 pserver107 [736477.201105]  [<ffffffff810b3828>] ?
rcu_check_callbacks+0xa8/0x150
May 26 02:24:07 pserver107 [736477.201275]  [<ffffffff81046d1f>] ?
update_process_times+0x3f/0x80
May 26 02:24:07 pserver107 [736477.201446]  [<ffffffff81084dab>] ?
tick_sched_timer+0x5b/0xb0
May 26 02:24:07 pserver107 [736477.201619]  [<ffffffff8105d6e7>] ?
__run_hrtimer+0x77/0x1c0
May 26 02:24:07 pserver107 [736477.201786]  [<ffffffff8105da9f>] ?
hrtimer_interrupt+0xef/0x260
May 26 02:24:07 pserver107 [736477.201960]  [<ffffffff81020cc3>] ?
smp_apic_timer_interrupt+0x63/0xa0
May 26 02:24:07 pserver107 [736477.202130]  [<ffffffff8167e18a>] ?
apic_timer_interrupt+0x6a/0x70
May 26 02:24:07 pserver107 [736477.202297]  <EOI>
May 26 02:24:07 pserver107  [<ffffffff81675eea>] ? _raw_spin_lock+0x1a/0x30
May 26 02:24:07 pserver107 [736477.202537]  [<ffffffff811904a0>] ?
task_dumpable+0x10/0x40
May 26 02:24:07 pserver107 [736477.202704]  [<ffffffff811923c9>] ?
pid_revalidate+0x49/0xe0
May 26 02:24:07 pserver107 [736477.202871]  [<ffffffff811402f8>] ?
do_lookup+0x1e8/0x300
May 26 02:24:07 pserver107 [736477.203033]  [<ffffffff81140f4e>] ?
do_last+0xee/0x810
May 26 02:24:07 pserver107 [736477.203198]  [<ffffffff8114201c>] ?
path_openat+0xdc/0x400
May 26 02:24:07 pserver107 [736477.203363]  [<ffffffff8114246d>] ?
do_filp_open+0x4d/0xc0
May 26 02:24:07 pserver107 [736477.203530]  [<ffffffff8114eb73>] ?
alloc_fd+0x43/0x110
May 26 02:24:07 pserver107 [736477.203697]  [<ffffffff811337e8>] ?
do_sys_open+0x108/0x1f0
May 26 02:24:07 pserver107 [736477.203871]  [<ffffffff8167d6f9>] ?
system_call_fastpath+0x16/0x1b
May 26 02:39:07 pserver107 [737375.334632] INFO: rcu_sched self-detected
stall on CPU
May 26 02:39:07 pserver107  {
May 26 02:39:07 pserver107  60
May 26 02:39:07 pserver107 }
May 26 02:39:07 pserver107  (t=120005 jiffies)
May 26 02:39:07 pserver107 [737375.335198] Pid: 2411, comm: pbmonitor
Tainted: G      D    O 3.4.23-pserver #1
May 26 02:39:07 pserver107 [737375.335487] Call Trace:
May 26 02:39:07 pserver107 [737375.335646]  <IRQ>
May 26 02:39:07 pserver107  [<ffffffff810b3451>] ? __rcu_pending+0x1a1/0x4d0
May 26 02:39:07 pserver107 [737375.335899]  [<ffffffff81084d50>] ?
tick_nohz_handler+0xe0/0xe0
May 26 02:39:07 pserver107 [737375.336069]  [<ffffffff810b3828>] ?
rcu_check_callbacks+0xa8/0x150
May 26 02:39:07 pserver107 [737375.336241]  [<ffffffff81046d1f>] ?
update_process_times+0x3f/0x80
May 26 02:39:07 pserver107 [737375.336405]  [<ffffffff81084dab>] ?
tick_sched_timer+0x5b/0xb0
May 26 02:39:07 pserver107 [737375.336581]  [<ffffffff8105d6e7>] ?
__run_hrtimer+0x77/0x1c0
May 26 02:39:07 pserver107 [737375.336748]  [<ffffffff8105da9f>] ?
hrtimer_interrupt+0xef/0x260
May 26 02:39:07 pserver107 [737375.336916]  [<ffffffff81020cc3>] ?
smp_apic_timer_interrupt+0x63/0xa0
May 26 02:39:07 pserver107 [737375.337088]  [<ffffffff8167e18a>] ?
apic_timer_interrupt+0x6a/0x70
May 26 02:39:07 pserver107 [737375.337256]  <EOI>
May 26 02:39:07 pserver107  [<ffffffff81675eea>] ? _raw_spin_lock+0x1a/0x30
May 26 02:39:07 pserver107 [737375.337498]  [<ffffffff811904a0>] ?
task_dumpable+0x10/0x40
May 26 02:39:07 pserver107 [737375.337665]  [<ffffffff811923c9>] ?
pid_revalidate+0x49/0xe0
May 26 02:39:07 pserver107 [737375.337835]  [<ffffffff811402f8>] ?
do_lookup+0x1e8/0x300
May 26 02:39:07 pserver107 [737375.338008]  [<ffffffff81140f4e>] ?
do_last+0xee/0x810
May 26 02:39:07 pserver107 [737375.338175]  [<ffffffff8114201c>] ?
path_openat+0xdc/0x400
May 26 02:39:07 pserver107 [737375.338348]  [<ffffffff8114246d>] ?
do_filp_open+0x4d/0xc0
May 26 02:39:07 pserver107 [737375.338514]  [<ffffffff8114eb73>] ?
alloc_fd+0x43/0x110
May 26 02:39:07 pserver107 [737375.338677]  [<ffffffff811337e8>] ?
do_sys_open+0x108/0x1f0
May 26 02:39:07 pserver107 [737375.338847]  [<ffffffff8167d6f9>] ?
system_call_fastpath+0x16/0x1b
May 26 02:54:07 pserver107 [738273.461104] INFO: rcu_sched self-detected
stall on CPU
May 26 02:54:07 pserver107  {
May 26 02:54:07 pserver107  60
May 26 02:54:07 pserver107 }
May 26 02:54:07 pserver107  (t=210008 jiffies)

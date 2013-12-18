Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3LRVq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:46:57 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:56224 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3LRVq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:46:29 -0500
MIME-Version: 1.0
Date: Wed, 18 Dec 2013 13:46:28 -0800
Message-ID: <CAK3+h2xfUzLJ2bTiFkQsQFmU-MqA36aehBiPyg330iWYCNN3yQ@mail.gmail.com>
Subject: BUG: scheduling while atomic: java/9378/0x10000101
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

custom build kernel with in-house modules based on centos 6, userspace
process appears triggered kernel bug, full console log below, anyone
has seen similar kernel panic before?

 # BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff813022a3>] _spin_lock_irqsave+0x7/0x1f
PGD d50ac067 PUD d526d067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:01.2/0000:05:00.3/irq
CPU 0
Modules linked in: ipip tunnel4 8021q garp stp llc iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT iptable_filter xt_NOTRACK
nf_conntrack iptable_raw ip_tables igb(U) ixgbe(U) loop ext2
binfmt_misc womdict(U) vnic(U) parport_pc lp parport aes_generic
sha512_generic sha256_generic icp_qa_al(U) lasthop(U) ipv6 toggler
vhost_net tun kvm_intel kvm jiffies(U) sysstats hrsleep i2c_dev
i2c_core datastor(U) linux_user_bde(P)(U) linux_kernel_bde(P)(U)
ti_usb_3410_5052 usbserial tg3 libphy ehci_hcd raid1 raid0 virtio_pci
virtio_blk virtio virtio_ring mvsas mptspi mptscsih mptbase
scsi_transport_spi 3w_9xxx sata_svw(U) isci libsas scsi_transport_sas
ahci serverworks sata_sil ata_piix libata sd_mod crc_t10dif amd74xx
piix ide_gd_mod ide_core dm_snapshot dm_mirror dm_region_hash dm_log
dm_mod ext3 jbd mbcache

Pid: 7042, comm: mcpd Tainted: P           ----------------
2.6.32-220.el6.f5.x86_64 #1
RIP: 0010:[<ffffffff813022a3>]  [<ffffffff813022a3>] _spin_lock_irqsave+0x7/0x1f
RSP: 0018:ffff8800d5707980  EFLAGS: 00210082
RAX: 0000000000200282 RBX: ffff8801463d01a8 RCX: 0000000000000099
RDX: ffffea0000f80100 RSI: ffff8801463d01a8 RDI: 0000000000000000
RBP: ffff8800d5707a88 R08: 0000000000000008 R09: ffff880028402200
R10: 0000000000000002 R11: ffffffff812e9fd1 R12: ffff8800464f7000
R13: 0000000000000000 R14: ffff8800d5707e68 R15: 0000000000000059
FS:  0000000000000000(0000) GS:ffff880028200000(0063) knlGS:000000005953e770
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000d50f6000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mcpd (pid: 7042, threadinfo ffff8800d5706000, task ffff8800452c6040)
Stack:
 ffffffff8105a4b2 ffff8801463d0198 ffff8800464f7000 0000000000000009
<0> ffffffff810ff17a ffff8801463d0198 ffffffff810ff1c5 ffff8800d53332c0
<0> 0000000000000300 ffff8800d53332c0 0000000000000000 0000000001000000
Call Trace:
 [<ffffffff8105a4b2>] ? remove_wait_queue+0x10/0x2e
 [<ffffffff810ff17a>] ? free_poll_entry+0x11/0x1a
 [<ffffffff810ff1c5>] ? poll_freewait+0x42/0x6a
 [<ffffffff810ffade>] ? do_select+0x492/0x4ed
 [<ffffffff810ffe76>] ? __pollwait+0x0/0xd8
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff810fff4e>] ? pollwake+0x0/0x5a
 [<ffffffff81125e19>] ? compat_core_sys_select+0x18a/0x227
 [<ffffffff8115419d>] ? file_has_perm+0x49/0xac
 [<ffffffff81046a2f>] ? timespec_add_safe+0x37/0x66
 [<ffffffff81125fdd>] ? compat_sys_pselect6+0x127/0x1af
 [<ffffffff8100c68a>] ? syscall_trace_enter+0x146/0x15b
 [<ffffffff8102aa3e>] ? ia32_sysret+0x0/0x5
Code: 0f 94 c0 84 c0 ba 01 00 00 00 75 09 f0 81 07 00 00 00 01 30 d2
89 d0 c3 f0 83 2f 01 79 05 e8 75 a4 e9 ff c3 9c 58 fa 66 ba 00 01 <f0>
66 0f c1 17 38 f2 74 0e f3 90 8a 17 eb f6 66 83 3f 00 75 f4
RIP  [<ffffffff813022a3>] _spin_lock_irqsave+0x7/0x1f
 RSP <ffff8800d5707980>
CR2: 0000000000000000
---[ end trace b1d1d6e35d70a74b ]---
BUG: scheduling while atomic: java/9378/0x10000101
Modules linked in: ipip tunnel4 8021q garp stp llc iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT iptable_filter xt_NOTRACK
nf_conntrack iptable_raw ip_tables igb(U) ixgbe(U) loop ext2
binfmt_misc womdict(U) vnic(U) parport_pc lp parport aes_generic
sha512_generic sha256_generic icp_qa_al(U) lasthop(U) ipv6 toggler
vhost_net tun kvm_intel kvm jiffies(U) sysstats hrsleep i2c_dev
i2c_core datastor(U) linux_user_bde(P)(U) linux_kernel_bde(P)(U)
ti_usb_3410_5052 usbserial tg3 libphy ehci_hcd raid1 raid0 virtio_pci
virtio_blk virtio virtio_ring mvsas mptspi mptscsih mptbase
scsi_transport_spi 3w_9xxx sata_svw(U) isci libsas scsi_transport_sas
ahci serverworks sata_sil ata_piix libata sd_mod crc_t10dif amd74xx
piix ide_gd_mod ide_core dm_snapshot dm_mirror dm_region_hash dm_log
dm_mod ext3 jbd mbcache
Pid: 9378, comm: java Tainted: P      D    ----------------
2.6.32-220.el6.f5.x86_64 #1
Call Trace:
 <IRQ>  [<ffffffff813001a2>] ? schedule+0x87/0x93c
 [<ffffffff8105d240>] ? hrtimer_interrupt+0xe6/0x190
 [<ffffffff810a052a>] ? cpupri_set+0xbc/0xcb
 [<ffffffff81156809>] ? selinux_ip_postroute+0x7c/0x2a7
 [<ffffffff810a052a>] ? cpupri_set+0xbc/0xcb
 [<ffffffff810318c3>] ? task_rq_lock+0x17/0x65
 [<ffffffff8103f1d3>] ? __cond_resched+0x1d/0x26
 [<ffffffff810318c3>] ? task_rq_lock+0x17/0x65
 [<ffffffff81300d5f>] ? _cond_resched+0x24/0x2f
 [<ffffffff81005029>] ? is_valid_bugaddr+0x9/0x22
 [<ffffffff81192fc6>] ? report_bug+0xf/0xb9
 [<ffffffff81005f4b>] ? die+0x33/0x5c
 [<ffffffff8130261f>] ? general_protection+0x1f/0x30
 [<ffffffff8127b2a1>] ? sock_def_readable+0x0/0x69
 [<ffffffff810318c3>] ? task_rq_lock+0x17/0x65
 [<ffffffff81036e91>] ? try_to_wake_up+0x2d/0x2fc
 [<ffffffff810fffa3>] ? pollwake+0x55/0x5a
 [<ffffffff81037160>] ? default_wake_function+0x0/0x9
 [<ffffffff8102d3ae>] ? __wake_up_common+0x3f/0x71
 [<ffffffff810313ba>] ? __wake_up_sync_key+0x3a/0x56
 [<ffffffff8127b2e0>] ? sock_def_readable+0x3f/0x69
 [<ffffffff812bb474>] ? tcp_rcv_established+0x4fd/0x5a5
 [<ffffffff812c0a2b>] ? tcp_v4_do_rcv+0x190/0x34c
 [<ffffffff812c2c11>] ? tcp_v4_rcv+0x521/0x81c
 [<ffffffff812a72a0>] ? ip_local_deliver_finish+0x0/0x24b
 [<ffffffff812a7419>] ? ip_local_deliver_finish+0x179/0x24b
 [<ffffffff812a7286>] ? ip_rcv_finish+0x396/0x3b0
 [<ffffffff812a7894>] ? ip_rcv+0x2a9/0x2f8
 [<ffffffff81288497>] ? process_backlog+0x80/0xbc
 [<ffffffff81287e5b>] ? net_rx_action+0xa9/0x220
 [<ffffffff810480ac>] ? __do_softirq+0xc5/0x17a
 [<ffffffff81003a5c>] ? call_softirq+0x1c/0x28
 <EOI>  [<ffffffff81004feb>] ? do_softirq+0x31/0x66
 [<ffffffff81048459>] ? local_bh_enable+0x78/0x89
 [<ffffffff8128900a>] ? dev_queue_xmit+0x495/0x4d7
 [<ffffffff812abaa1>] ? ip_queue_xmit+0x2d4/0x330
 [<ffffffff8100342e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff811574b1>] ? selinux_socket_recvmsg+0x0/0x19
 [<ffffffff812bc3e9>] ? tcp_transmit_skb+0x67d/0x6ba
 [<ffffffff812bd95e>] ? tcp_write_xmit+0x84c/0x926
 [<ffffffff812bda5a>] ? __tcp_push_pending_frames+0x22/0x77
 [<ffffffff812b33d8>] ? tcp_sendmsg+0x868/0x964
 [<ffffffff81275f16>] ? sock_sendmsg+0xe6/0x105
 [<ffffffff811ec97b>] ? extract_buf+0xa0/0x105
 [<ffffffff8105a256>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81277c69>] ? sys_sendto+0x10f/0x143
 [<ffffffff81300a98>] ? thread_return+0x41/0xfb
 [<ffffffff811ec6e0>] ? account+0xd7/0xe6
 [<ffffffff81299960>] ? compat_sys_socketcall+0xd0/0x1ad
 [<ffffffff8102a564>] ? sysenter_dispatch+0x1e/0x42
general protection fault: 0000 [#2] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:01.2/0000:05:00.3/irq
CPU 5
Modules linked in: ipip tunnel4 8021q garp stp llc iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT iptable_filter xt_NOTRACK
nf_conntrack iptable_raw ip_table

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab3LMHPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 02:15:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3LMHPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 02:15:30 -0500
Date: Fri, 13 Dec 2013 02:14:07 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com
Subject: XFS / writeback invoking soft lockup.
Message-ID: <20131213071407.GA6527@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can hit this pretty reliably on one of my slower test machines.
(8gb ram, 1 slow sata disk)

the machine is pretty responsive, and recovers after a while.
anything we can do to shut it up ?

BUG: soft lockup - CPU#2 stuck for 22s! [kworker/u8:2:8479]
Modules linked in: rfcomm l2tp_ppp l2tp_netlink l2tp_core scsi_transport_iscsi can_bcm nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 p8022 psnap llc ax25 cfg80211 rfkill nouveau video backlight mxm_wmi wmi i2c_algo_bit ttm drm_kms_helper tg3 drm kvm_intel kvm ptp i2c_core pps_core libphy lpc_ich mfd_core serio_raw pcspkr microcode parport_pc parport shpchp floppy rtc_cmos xfs libcrc32c raid0
irq event stamp: 510442980
hardirqs last  enabled at (510442979): [<c15c47d9>] _raw_spin_unlock_irq+0x27/0x46
hardirqs last disabled at (510442980): [<c15c5667>] apic_timer_interrupt+0x2f/0x3c
softirqs last  enabled at (510441282): [<c1045d01>] __do_softirq+0x14b/0x38d
softirqs last disabled at (510441277): [<c100418b>] do_softirq_own_stack+0x2e/0x34
CPU: 2 PID: 8479 Comm: kworker/u8:2 Not tainted 3.13.0-rc3+ #1 
Hardware name: Dell Inc.                 Precision WorkStation 490    /0DT031, BIOS A08 04/25/2008
Workqueue: writeback bdi_writeback_workfn (flush-9:127)
task: e9e458c0 ti: e4214000 task.ti: e4214000
EIP: 0060:[<c112f797>] EFLAGS: 00000286 CPU: 2
EIP is at lru_add_drain_cpu+0x19/0xc0
EAX: c1a988c0 EBX: 00000002 ECX: 00000001 EDX: 2ff6c000
ESI: 00000000 EDI: 00000001 EBP: e4215c54 ESP: e4215c48
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 29ed5000 CR4: 000007f0
Stack:
 e4215cb8 00000000 00000001 e4215c5c c112f8f8 e4215c68 c112f934 00000001
 e4215d04 c112baba 00000000 0000000e 00000000 00000000 00000001 00000000
 c1a9c980 f1a08980 c112ad83 00000000 e4215da4 00000067 00000003 00000001
Call Trace:
 [<c112f8f8>] lru_add_drain+0x1c/0x39
 [<c112f934>] __pagevec_release+0x10/0x26
 [<c112baba>] write_cache_pages+0x2f9/0x486
 [<c112ad83>] ? global_dirtyable_memory+0x73/0x73
 [<c108c940>] ? get_lock_stats+0x1b/0x43
 [<c108cf5c>] ? put_lock_stats.isra.30+0xd/0x22
 [<c108d3a2>] ? lock_release_holdtime.part.31+0xa0/0xd5
 [<c112bc7e>] generic_writepages+0x37/0x51
 [<f8616158>] xfs_vm_writepages+0x3a/0x42 [xfs]
 [<c112d1d9>] do_writepages+0x1d/0x2c
 [<c11a86ff>] __writeback_single_inode+0x3f/0x4d7
 [<c11a8f55>] ? writeback_sb_inodes+0x178/0x3d9
 [<c11a8fb2>] writeback_sb_inodes+0x1d5/0x3d9
 [<c11a9235>] __writeback_inodes_wb+0x7f/0xae
 [<c11a94ad>] wb_writeback+0x249/0x4c5
 [<c11a9bed>] bdi_writeback_workfn+0x321/0x594
 [<c105c9e7>] process_one_work+0x1ad/0x5ff
 [<c105c9af>] ? process_one_work+0x175/0x5ff
 [<c105cf2f>] worker_thread+0xf6/0x31b
 [<c105ce39>] ? process_one_work+0x5ff/0x5ff
 [<c106398e>] kthread+0xb5/0xc8
 [<c108f8aa>] ? trace_hardirqs_on+0xb/0xd
 [<c15cbe37>] ret_from_kernel_thread+0x1b/0x28
 [<c10638d9>] ? insert_kthread_work+0x63/0x63
Code: e8 41 50 49 00 83 c4 04 5b 5e 5f 5d c3 e8 25 ad 48 00 55 89 e5 57 56 53 66 66 66 66 90 89 c3 b8 c0 88 a9 c1 8b 14 9d 80 33 8b c1 <01> d0 8b 08 85 c9 75 74 b8 80 88 a9 c1 8d 34 02 8b 3e 85 ff 75


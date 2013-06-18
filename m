Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3FRBgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:36:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3FRBgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:36:13 -0400
Date: Mon, 17 Jun 2013 21:36:02 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: airlied@redhat.com, bskeggs@redhat.com
Subject: [3.10rc6] /proc/dri/0/vma broken on nouveau.
Message-ID: <20130618013602.GC2200@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, airlied@redhat.com,
	bskeggs@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading /proc/dri/0/vma causes bad things to happen on a box with nouveau loaded.
(Note, no X running on that box)

Trace below shows trinity, but I can reproduce it with just cat /proc/dri/0/vma

------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:79!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: tun cmtp kernelcapi rfcomm l2tp_ppp l2tp_netlink l2tp_core ipt_ULOG bnep can_bcm scsi_transport_iscsi nfnetlink rds atm bluetooth can_raw appletalk netrom pppoe af_key ipx rose p8023 pppox p8022 psnap ppp_generic ax25 llc slhc af_802154 nfc can rfkill irda crc_ccitt phonet nfsv3 nfs_acl nfs lockd sunrpc fscache nouveau video mxm_wmi wmi i2c_algo_bit ttm drm_kms_helper drm i5000_edac edac_core tg3 iTCO_wdt iTCO_vendor_support lpc_ich ppdev pcspkr microcode mfd_core i2c_i801 i2c_core dcdbas serio_raw ptp i5k_amb pps_core shpchp parport_pc floppy parport xfs libcrc32c raid0
CPU: 3 PID: 26586 Comm: trinity-child3 Tainted: G        W    3.10.0-rc6+ #1 
Hardware name: Dell Inc.                 Precision WorkStation 490    /0DT031, BIOS A08 04/25/2008
task: f12041a0 ti: eace4000 task.ti: eace4000
EIP: 0060:[<c102e2a6>] EFLAGS: 00010206 CPU: 3
EIP is at __phys_addr+0x72/0x76
EAX: 37bfe000 EBX: 37bfe000 ECX: 0000000c EDX: 37bfe000
ESI: eacc7870 EDI: eacc7870 EBP: eace5e98 ESP: eace5e94
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 80050033 CR2: 0a24116c CR3: 2cc22000 CR4: 000007f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Stack:
 ee11ce30 eace5efc f868c42f c106a0ff 80070007 e6266700 00000282 eace5efc
 c15a6ea6 000000d0 f2403680 f2403680 eace5efc c115054d f2d40e50 ee11ce68
 f12041a0 eacc7870 000010b0 eace4000 00001000 c11841cf 000000d0 eacc7870
Call Trace:
 [<f868c42f>] drm_vma_info+0x39/0x26e [drm]
 [<c106a0ff>] ? __might_sleep+0x19/0x1ac
 [<c15a6ea6>] ? mutex_lock_nested+0x286/0x39c
 [<c115054d>] ? kmem_cache_alloc_trace+0x282/0x2cc
 [<c11841cf>] ? seq_read+0x24d/0x438
 [<c1184068>] seq_read+0xe6/0x438
 [<c1183f82>] ? traverse.isra.6+0x256/0x256
 [<c11b9ff6>] proc_reg_read+0x48/0x71
 [<c11b9fae>] ? proc_reg_write+0x71/0x71
 [<c11644c8>] vfs_read+0x80/0x148
 [<c1164b5f>] SyS_read+0x49/0x7d
 [<c15b19c1>] sysenter_do_call+0x12/0x32
Code: 27 11 c2 8d 91 00 00 80 00 39 d0 72 cb 8b 0d 2c 27 81 c1 8d 91 00 00 c1 ff 81 e2 00 00 e0 ff 81 ea 00 20 00 00 39 d0 73 af 0f 0b <0f> 0b 0f 0b 55 89 e5 53 66 66 66 66 90 89 c2 31 c0 81 fa ff ff


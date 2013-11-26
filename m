Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3KZD07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:26:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3KZD0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:26:54 -0500
Date: Mon, 25 Nov 2013 22:26:45 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: kmo@daterainc.com
Subject: GPF in aio_migratepage
Message-ID: <20131126032645.GA32301@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kmo@daterainc.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

I hit the GPF below on a tree based on 8e45099e029bb6b369b27d8d4920db8caff5ecce
which has your commit e34ecee2ae791df674dfb466ce40692ca6218e43
("aio: Fix a trinity splat").  Is this another path your patch missed, or
a completely different bug to what you were chasing ?

	Dave

general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: snd_seq_dummy bridge stp tun fuse hidp bnep rfcomm ipt_ULOG can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds nfnetlink af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c coretemp hwmon x86_pkg_temp_thermal kvm_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec kvm snd_hwdep snd_seq snd_seq_device crct10dif_pclmul snd_pcm snd_page_alloc snd_timer snd crc32c_intel ghash_clmulni_intel shpchp usb_debug e1000e soundcore microcode pcspkr ptp pps_core serio_raw
CPU: 3 PID: 1840 Comm: trinity-child3 Not tainted 3.13.0-rc1+ #9 
task: ffff88003b3a15d0 ti: ffff88001f208000 task.ti: ffff88001f208000
RIP: 0010:[<ffffffff810ad3d1>]  [<ffffffff810ad3d1>] __lock_acquire+0x1b1/0x19f0
RSP: 0018:ffff88001f209740  EFLAGS: 00010002
RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000000002 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001fbf3760
RBP: ffff88001f2097e8 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003b3a15d0
R13: 6b6b6b6b6b6b6b6b R14: ffff88001fbf3760 R15: 0000000000000000
FS:  00007faab2396740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4e589ba36c CR3: 000000001f2fa000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 0000000000000006 ffffffff810a970f 0000000000000006 0000050b04f1418f
 ffff88001f209778 ffffffff8100b164 ffffffff824cb6a0 ffffffff810a970f
 0000000000000000 ffff88003b3a1cd8 0000000000000007 0000000000000006
Call Trace:
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff8100b164>] ? native_sched_clock+0x24/0x80
 [<ffffffff810a970f>] ? trace_hardirqs_off_caller+0x1f/0xc0
 [<ffffffff810acccb>] ? mark_held_locks+0xbb/0x140
 [<ffffffff810af3c3>] lock_acquire+0x93/0x1c0
 [<ffffffff81210596>] ? aio_migratepage+0xa6/0x150
 [<ffffffff81744b4b>] _raw_spin_lock_irqsave+0x4b/0x90
 [<ffffffff81210596>] ? aio_migratepage+0xa6/0x150
 [<ffffffff81210596>] aio_migratepage+0xa6/0x150
 [<ffffffff811abe29>] move_to_new_page+0x79/0x240
 [<ffffffff811ac8d5>] migrate_pages+0x7a5/0x850
 [<ffffffff81173c50>] ? isolate_freepages_block+0x440/0x440
 [<ffffffff81174bda>] compact_zone+0x2ba/0x510
 [<ffffffff81174ec4>] compact_zone_order+0x94/0xe0
 [<ffffffff81175201>] try_to_compact_pages+0xe1/0x110
 [<ffffffff817388bd>] __alloc_pages_direct_compact+0xac/0x1d0
 [<ffffffff81159946>] __alloc_pages_nodemask+0x996/0xb50
 [<ffffffff8119d6b1>] alloc_pages_vma+0xf1/0x1b0
 [<ffffffff811b121d>] ? do_huge_pmd_anonymous_page+0xfd/0x3a0
 [<ffffffff811b121d>] do_huge_pmd_anonymous_page+0xfd/0x3a0
 [<ffffffff810aa4a6>] ? lock_release_holdtime.part.29+0xe6/0x160
 [<ffffffff8117c279>] handle_mm_fault+0x479/0xbb0
 [<ffffffff810a9f27>] ? __lock_is_held+0x57/0x80
 [<ffffffff8117cb5e>] __get_user_pages+0x1ae/0x5f0
 [<ffffffff8117ebec>] __mlock_vma_pages_range+0x8c/0xa0
 [<ffffffff8117f360>] __mm_populate+0xc0/0x150
 [<ffffffff8116d786>] vm_mmap_pgoff+0xb6/0xc0
 [<ffffffff81181676>] SyS_mmap_pgoff+0x116/0x270
 [<ffffffff8174fa29>] ia32_do_call+0x13/0x13
Code: c2 b6 75 a2 81 31 c0 be fb 0b 00 00 48 c7 c7 00 b6 a2 81 e8 b2 6d fa ff eb a8 44 89 fa 4d 8b 6c d6 08 4d 85 ed 0f 84 cb fe ff ff <f0> 41 ff 85 98 01 00 00 8b 05 b9 28 9b 01 45 8b bc 24 00 07 00 


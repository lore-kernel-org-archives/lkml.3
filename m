Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3JNPqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:46:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab3JNPqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:46:38 -0400
Date: Mon, 14 Oct 2013 11:46:27 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: epoll oops.
Message-ID: <20131014154627.GA9525@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Machine is wedged and I can't get to it until tomorrow, but this is what was on serial console.
kernel running was from some time last Friday, I can get exact info tomorrow, though
I don't think there's anything epoll related recently that could explain this.

	Dave

Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: bridge 8021q garp stp sctp dlci mpoa snd_seq_dummy tun fuse hidp bnep ipt_ULOG rfcomm scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth can_bcm rfkill can_raw can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds nfnetlink af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode serio_raw pcspkr usb_debug shpchp snd_page_alloc e1000e snd_timer snd ptp pps_core soundcore
CPU: 3 PID: 449 Comm: trinity-main Not tainted 3.12.0-rc4+ #98 
task: ffff88023e239560 ti: ffff880083082000 task.ti: ffff880083082000
RIP: 0010:[<ffffffff810c9f98>]  [<ffffffff810c9f98>] __lock_acquire+0x58/0x1be0
RSP: 0018:ffff880083083c18  EFLAGS: 00010046
RAX: 0000000000000046 RBX: 0000000000000046 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801654cec98
RBP: ffff880083083cc8 R08: 0000000000000002 R09: 0000000000000001
R10: ffff88023e239560 R11: 0000000000000000 R12: 0000000000000002
R13: ffff8801654cec98 R14: 0000000000000002 R15: 0000000000000000
FS:  00007fe8df704740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8801654cec98 CR3: 0000000001c0b000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Stack:
 0000000000000006 00004f44c1dd11e9 ffff880083083c38 0000000000000017
 0000000000000001 ffffffff81c410e0 0000000000000002 ffff88023e239c98
 ffff880083083d20 ffffffff810ca22d ffff880083083c88 ffffffff810c9b85
Call Trace:
 [<ffffffff810ca22d>] ? __lock_acquire+0x2ed/0x1be0
 [<ffffffff810c9b85>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810c9c5d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810cc2d3>] lock_acquire+0x93/0x200
 [<ffffffff810848d9>] ? remove_wait_queue+0x19/0x40
 [<ffffffff81732c3b>] _raw_spin_lock_irqsave+0x4b/0x90
 [<ffffffff810848d9>] ? remove_wait_queue+0x19/0x40
 [<ffffffff810848d9>] remove_wait_queue+0x19/0x40
 [<ffffffff812120eb>] ep_unregister_pollwait.isra.14+0x5b/0x1e0
 [<ffffffff8121213a>] ? ep_unregister_pollwait.isra.14+0xaa/0x1e0
 [<ffffffff81212786>] ep_remove+0x26/0x140
 [<ffffffff81213391>] eventpoll_release_file+0x71/0xa0
 [<ffffffff811c4faa>] __fput+0x2aa/0x2d0
 [<ffffffff811c501e>] ____fput+0xe/0x10
 [<ffffffff8107d67c>] task_work_run+0xac/0xe0
 [<ffffffff81056bd7>] do_exit+0x2c7/0xcc0
 [<ffffffff810c9b85>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff810c9c5d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810589cc>] do_group_exit+0x4c/0xc0
 [<ffffffff81058a54>] SyS_exit_group+0x14/0x20
 [<ffffffff8173bf64>] tracesys+0xdd/0xe2
Code: 85 c0 8b 05 4b d6 bc 00 45 0f 45 e0 85 c0 0f 84 07 01 00 00 8b 05 31 af 00 01 49 89 fd 41 89 f7 41 89 d3 85 c0 0f 84 08 01 00 00 <49> 8b 45 00 ba 01 00 00 00 48 3d 60 6a 13 82 44 0f 44 e2 41 83 
RIP  [<ffffffff810c9f98>] __lock_acquire+0x58/0x1be0
 RSP <ffff880083083c18>
CR2: ffff8801654cec98
---[ end trace 044e98c2d3aab216 ]---


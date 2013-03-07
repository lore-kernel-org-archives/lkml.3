Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab3CGXPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:15:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758308Ab3CGXPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:15:07 -0500
Date: Thu, 7 Mar 2013 18:14:42 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: fasync_remove_entry oops
Message-ID: <20130307231442.GA4806@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307223610.GA2494@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And.. More fun with pipes.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
IP: [<ffffffff811c3c10>] fasync_remove_entry+0x30/0xd0
PGD 1225c5067 PUD 11a133067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: rfcomm bnep nfnetlink can_bcm l2tp_ppp l2tp_core scsi_transport_iscsi fuse nfc x25 llc2 can_raw can ipt_ULOG ipx p8023 p8022 phonet rds netrom decnet appletalk psnap llc af_rxrpc caif_socket caif irda crc_ccitt af_key rose ax25 atm pppoe pppox ppp_generic slhc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb snd_hda_codec_realtek bluetooth snd_hda_intel snd_hda_codec snd_pcm rfkill snd_page_alloc microcode usb_debug snd_timer vhost_net snd tun soundcore r8169 macvtap pcspkr macvlan serio_raw mii edac_core kvm_amd kvm
CPU 1 
Pid: 17682, comm: trinity-child1 Not tainted 3.9.0-rc1+ #71 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff811c3c10>]  [<ffffffff811c3c10>] fasync_remove_entry+0x30/0xd0
RSP: 0018:ffff8801004b7d58  EFLAGS: 00010282
RAX: ffff880087894920 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff81c64918 RDI: 0000000000000001
RBP: ffff8801004b7d78 R08: ffd9df0b804b81fd R09: 0000000000000000
R10: ffff880087894920 R11: 0000000000000000 R12: ffff880086fe2940
R13: ffff880086fe2970 R14: 0000000000000080 R15: 0000000000000000
FS:  00007feb12d57740(0000) GS:ffff88012a800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000080 CR3: 0000000126e46000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child1 (pid: 17682, threadinfo ffff8801004b6000, task ffff880087894920)
Stack:
 ffff880086fe2940 ffff880086fe2940 0000000000000080 0000000000000000
 ffff8801004b7db8 ffffffff811c3e43 0000000028a84b60 ffff880086fe2940
 ffff88007e179608 ffff880086fe2940 ffff88007e179608 00000000ffffffff
Call Trace:
 [<ffffffff811c3e43>] fasync_helper+0x73/0x90
 [<ffffffff811b9957>] pipe_rdwr_fasync+0x67/0xd0
 [<ffffffff811b29ab>] __fput+0x27b/0x2d0
 [<ffffffff811b2a0e>] ____fput+0xe/0x10
 [<ffffffff8106c5e5>] task_work_run+0xa5/0xd0
 [<ffffffff8104ad30>] do_exit+0x2c0/0xce0
 [<ffffffff816c5d8d>] ? retint_swapgs+0xe/0x13
 [<ffffffff8104b7ec>] do_group_exit+0x4c/0xc0
 [<ffffffff8104b877>] sys_exit_group+0x17/0x20
 [<ffffffff816cdbc2>] system_call_fastpath+0x16/0x1b
Code: 55 48 89 e5 41 56 49 89 f6 41 55 4c 8d 6f 30 41 54 49 89 fc 4c 89 ef 53 31 db e8 6c 10 50 00 48 c7 c7 00 49 c6 81 e8 60 10 50 00 <49> 8b 06 48 85 c0 74 22 4c 39 60 58 48 89 c3 75 10 eb 41 0f 1f 
RIP  [<ffffffff811c3c10>] fasync_remove_entry+0x30/0xd0
 RSP <ffff8801004b7d58>
CR2: 0000000000000080



        for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
    1650:       49 8b 06                mov    (%r14),%rax

So we got to fasync_remove_entry with a NULL fa struct.

Can we just add more NULL checks here, or does that need to happen
at a higher level ?

	Dave


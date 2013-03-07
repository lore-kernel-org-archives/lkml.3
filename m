Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3CGCQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:16:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab3CGCQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:16:50 -0500
Date: Wed, 6 Mar 2013 21:16:45 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Subject: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130307021645.GA10173@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fuzz tester just hit this.

	Dave


[11235.974332] ------------[ cut here ]------------
[11235.975039] kernel BUG at fs/namei.c:1441!
[11235.975661] invalid opcode: 0000 [#1] PREEMPT SMP 
[11235.976433] Modules linked in: bnep vmw_vsock_vmci_transport vmw_vmci vsock fuse l2tp_ppp l2tp_core hidp 8021q garp mrp llc2 netrom phonet bridge dlci stp caif_socket caif af_key pppoe pppox ppp_generic slhc af_rxrpc ipt_ULOG can_bcm can_raw nfnetlink scsi_transport_iscsi rfcomm rose can x25 decnet ipx p8023 p8022 nfc ax25 appletalk psnap llc irda atm rds crc_ccitt lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb snd_pcm microcode bluetooth pcspkr serio_raw edac_core snd_page_alloc rfkill snd_timer usb_debug snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
[11235.988144] CPU 2 
[11235.988462] Pid: 8737, comm: trinity-child0 Not tainted 3.9.0-rc1+ #69 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
[11235.990193] RIP: 0010:[<ffffffff816bc622>]  [<ffffffff816bc622>] lookup_slow+0x25/0xab
[11235.991392] RSP: 0018:ffff8800ad2cbc98  EFLAGS: 00010293
[11235.992196] RAX: 0000000000000001 RBX: ffff8800ad2cbde8 RCX: 0000000000000000
[11235.993266] RDX: 00000000000018ac RSI: ffff8800ad2cbd18 RDI: ffff88010b080040
[11235.994280] RBP: ffff8800ad2cbcc8 R08: 0000000000000001 R09: 0000000000000000
[11235.995315] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000011
[11235.996334] R13: ffff8800cebf9bc0 R14: ffff8800ad2cbde8 R15: ffff8800cfb13178
[11235.997379] FS:  00007f98b7830740(0000) GS:ffff88012b200000(0000) knlGS:0000000000000000
[11235.998548] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11235.999375] CR2: 0000000000000008 CR3: 00000000baffd000 CR4: 00000000000007e0
[11236.000403] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[11236.001421] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[11236.002457] Process trinity-child0 (pid: 8737, threadinfo ffff8800ad2ca000, task ffff880104ea4920)
[11236.003761] Stack:
[11236.004091]  0000000000000092 0000000000000000 0000000000000001 0000000000000011
[11236.005337]  0000000000000000 ffff8800ad2cbde8 ffff8800ad2cbd68 ffffffff811be75e
[11236.006570]  ffff880104ea5040 0000000000000002 ffff8800ad2cbd08 ffffffff8100a196
[11236.015665] Call Trace:
[11236.023527]  [<ffffffff811be75e>] path_lookupat+0x71e/0x740
[11236.032165]  [<ffffffff8100a196>] ? native_sched_clock+0x26/0x90
[11236.040991]  [<ffffffff810b2118>] ? trace_hardirqs_off_caller+0x28/0xc0
[11236.049559]  [<ffffffff811be7b4>] filename_lookup+0x34/0xc0
[11236.058095]  [<ffffffff811be8f2>] do_path_lookup+0x32/0x40
[11236.066609]  [<ffffffff811beb7a>] kern_path+0x2a/0x50
[11236.074848]  [<ffffffff811648f3>] ? might_fault+0x53/0xb0
[11236.082790]  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
[11236.091059]  [<ffffffff8116493c>] ? might_fault+0x9c/0xb0
[11236.099271]  [<ffffffff811648f3>] ? might_fault+0x53/0xb0
[11236.107711]  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
[11236.116287]  [<ffffffff811d569d>] do_mount+0x8d/0xa00
[11236.124378]  [<ffffffff811591ab>] ? memdup_user+0x4b/0x90
[11236.132666]  [<ffffffff81159243>] ? strndup_user+0x53/0x70
[11236.140733]  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
[11236.149090]  [<ffffffff811d609e>] sys_mount+0x8e/0xe0
[11236.157394]  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
[11236.166112]  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
[11236.174800]  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
[11236.183799] Code: 55 48 89 e5 0f 0b 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb 48 83 ec 10 4c 8b 6f 08 48 8b 7f 30 49 3b 7d 30 74 02 <0f> 0b 48 81 c7 e8 00 00 00 49 89 f4 31 f6 e8 7b 52 00 00 8b 53 
[11236.204106] RIP  [<ffffffff816bc622>] lookup_slow+0x25/0xab
[11236.212308]  RSP <ffff8800ad2cbc98>
[11236.223021] ---[ end trace 9b541228773df23c ]---


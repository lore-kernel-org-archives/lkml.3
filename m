Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab3CGPbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:31:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3CGPa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:30:58 -0500
Date: Thu, 7 Mar 2013 10:30:52 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: BUG_ON(nd->inode->i_op->follow_link);
Message-ID: <20130307153052.GA18246@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130307021645.GA10173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307021645.GA10173@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:16:45PM -0500, Dave Jones wrote:
 
 >  kernel BUG at fs/namei.c:1441!
 >  invalid opcode: 0000 [#1] PREEMPT SMP 
 >  Modules linked in: bnep vmw_vsock_vmci_transport vmw_vmci vsock fuse l2tp_ppp l2tp_core hidp 8021q garp mrp llc2 netrom phonet bridge dlci stp caif_socket caif af_key pppoe pppox ppp_generic slhc af_rxrpc ipt_ULOG can_bcm can_raw nfnetlink scsi_transport_iscsi rfcomm rose can x25 decnet ipx p8023 p8022 nfc ax25 appletalk psnap llc irda atm rds crc_ccitt lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb snd_pcm microcode bluetooth pcspkr serio_raw edac_core snd_page_alloc rfkill snd_timer usb_debug snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
 >  CPU 2 
 >  Pid: 8737, comm: trinity-child0 Not tainted 3.9.0-rc1+ #69 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
 >  RIP: 0010:[<ffffffff816bc622>]  [<ffffffff816bc622>] lookup_slow+0x25/0xab
 >  RSP: 0018:ffff8800ad2cbc98  EFLAGS: 00010293
 >  RAX: 0000000000000001 RBX: ffff8800ad2cbde8 RCX: 0000000000000000
 >  RDX: 00000000000018ac RSI: ffff8800ad2cbd18 RDI: ffff88010b080040
 >  RBP: ffff8800ad2cbcc8 R08: 0000000000000001 R09: 0000000000000000
 >  R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000011
 >  R13: ffff8800cebf9bc0 R14: ffff8800ad2cbde8 R15: ffff8800cfb13178
 >  FS:  00007f98b7830740(0000) GS:ffff88012b200000(0000) knlGS:0000000000000000
 >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 >  CR2: 0000000000000008 CR3: 00000000baffd000 CR4: 00000000000007e0
 >  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 >  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 >  Process trinity-child0 (pid: 8737, threadinfo ffff8800ad2ca000, task ffff880104ea4920)
 >  Stack:
 >   0000000000000092 0000000000000000 0000000000000001 0000000000000011
 >   0000000000000000 ffff8800ad2cbde8 ffff8800ad2cbd68 ffffffff811be75e
 >   ffff880104ea5040 0000000000000002 ffff8800ad2cbd08 ffffffff8100a196
 >  Call Trace:
 >   [<ffffffff811be75e>] path_lookupat+0x71e/0x740
 >   [<ffffffff8100a196>] ? native_sched_clock+0x26/0x90
 >   [<ffffffff810b2118>] ? trace_hardirqs_off_caller+0x28/0xc0
 >   [<ffffffff811be7b4>] filename_lookup+0x34/0xc0
 >   [<ffffffff811be8f2>] do_path_lookup+0x32/0x40
 >   [<ffffffff811beb7a>] kern_path+0x2a/0x50
 >   [<ffffffff811648f3>] ? might_fault+0x53/0xb0
 >   [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >   [<ffffffff8116493c>] ? might_fault+0x9c/0xb0
 >   [<ffffffff811648f3>] ? might_fault+0x53/0xb0
 >   [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >   [<ffffffff811d569d>] do_mount+0x8d/0xa00
 >   [<ffffffff811591ab>] ? memdup_user+0x4b/0x90
 >   [<ffffffff81159243>] ? strndup_user+0x53/0x70
 >   [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >   [<ffffffff811d609e>] sys_mount+0x8e/0xe0
 >   [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >   [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
 >   [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >  Code: 55 48 89 e5 0f 0b 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb 48 83 ec 10 4c 8b 6f 08 48 8b 7f 30 49 3b 7d 30 74 02 <0f> 0b 48 81 c7 e8 00 00 00 49 89 f4 31 f6 e8 7b 52 00 00 8b 53 
 >  RIP  [<ffffffff816bc622>] lookup_slow+0x25/0xab
 >   RSP <ffff8800ad2cbc98>


More VFS fun, this time on something in /proc.


kernel BUG at fs/namei.c:693!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: appletalk irda can_bcm atm netrom phonet ipx p8023 psnap p8022 llc rds rose ax25 decnet caif_socket caif af_rxrpc crc_ccitt can pppoe pppox ppp_generic slhc nfc af_key x25 lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm btusb bluetooth snd_page_alloc snd_timer snd microcode edac_core usb_debug rfkill serio_raw pcspkr soundcore vhost_net r8169 tun macvtap mii macvlan kvm_amd kvm
CPU 0 
Pid: 829, comm: trinity-main Not tainted 3.9.0-rc1+ #69 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff811c1414>]  [<ffffffff811c1414>] nd_jump_link+0x54/0x60
RSP: 0018:ffff880112e31c78  EFLAGS: 00010286
RAX: ffffffff8181ed80 RBX: ffff880112e31dc8 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff81089183 RDI: 0000000000000001
RBP: ffff880112e31c88 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff880112e31c98
R13: ffff880112e31dc8 R14: ffff880112e31dc8 R15: ffff880104efd030
FS:  00007f9c237f5740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003e29ebb750 CR3: 0000000112d59000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-main (pid: 829, threadinfo ffff880112e30000, task ffff880112c6a490)
Stack:
 ffff88010a14de48 ffff880104efd030 ffff880112e31cc8 ffffffff8122475c
 ffff880129284fe0 ffff880113eab780 000000005138b1bc 0000000000000000
 ffff880112c6a490 ffff880112e31d28 ffff880112e31d68 ffffffff811be311
Call Trace:
 [<ffffffff8122475c>] proc_pid_follow_link+0x6c/0x70
 [<ffffffff811be311>] path_lookupat+0x2d1/0x740
 [<ffffffff811be7b4>] filename_lookup+0x34/0xc0
 [<ffffffff811c15ae>] user_path_at_empty+0x8e/0x110
 [<ffffffff811b6085>] ? cp_new_stat+0x155/0x170
 [<ffffffff811c1641>] user_path_at+0x11/0x20
 [<ffffffff811b62f9>] vfs_fstatat+0x49/0xa0
 [<ffffffff811b664a>] sys_newfstatat+0x1a/0x40
 [<ffffffff810b8685>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff81341a6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
Code: 44 24 08 48 89 43 08 48 8b 40 30 81 4b 38 00 10 00 00 48 89 43 30 48 8b 40 20 48 83 78 08 00 75 0a 48 8b 5d f0 4c 8b 65 f8 c9 c3 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 ba 10 00 
RIP  [<ffffffff811c1414>] nd_jump_link+0x54/0x60
 RSP <ffff880112e31c78>


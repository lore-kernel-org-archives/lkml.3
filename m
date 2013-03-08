Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab3CHPEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:04:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836Ab3CHPEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:04:12 -0500
Date: Fri, 8 Mar 2013 10:04:08 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308150408.GA25399@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
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

 > kernel BUG at fs/namei.c:1441!
 > invalid opcode: 0000 [#1] PREEMPT SMP 
 > Modules linked in: bnep vmw_vsock_vmci_transport vmw_vmci vsock fuse l2tp_ppp l2tp_core hidp 8021q garp mrp llc2 netrom phonet bridge dlci stp caif_socket caif af_key pppoe pppox ppp_generic slhc af_rxrpc ipt_ULOG can_bcm can_raw nfnetlink scsi_transport_iscsi rfcomm rose can x25 decnet ipx p8023 p8022 nfc ax25 appletalk psnap llc irda atm rds crc_ccitt lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb snd_pcm microcode bluetooth pcspkr serio_raw edac_core snd_page_alloc rfkill snd_timer usb_debug snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
 > CPU 2 
 > Pid: 8737, comm: trinity-child0 Not tainted 3.9.0-rc1+ #69 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
 > RIP: 0010:[<ffffffff816bc622>]  [<ffffffff816bc622>] lookup_slow+0x25/0xab
 > RSP: 0018:ffff8800ad2cbc98  EFLAGS: 00010293
 > RAX: 0000000000000001 RBX: ffff8800ad2cbde8 RCX: 0000000000000000
 > RDX: 00000000000018ac RSI: ffff8800ad2cbd18 RDI: ffff88010b080040
 > RBP: ffff8800ad2cbcc8 R08: 0000000000000001 R09: 0000000000000000
 > R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000011
 > R13: ffff8800cebf9bc0 R14: ffff8800ad2cbde8 R15: ffff8800cfb13178
 > FS:  00007f98b7830740(0000) GS:ffff88012b200000(0000) knlGS:0000000000000000
 > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > CR2: 0000000000000008 CR3: 00000000baffd000 CR4: 00000000000007e0
 > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 > Process trinity-child0 (pid: 8737, threadinfo ffff8800ad2ca000, task ffff880104ea4920)
 > Stack:
 >  0000000000000092 0000000000000000 0000000000000001 0000000000000011
 >  0000000000000000 ffff8800ad2cbde8 ffff8800ad2cbd68 ffffffff811be75e
 >  ffff880104ea5040 0000000000000002 ffff8800ad2cbd08 ffffffff8100a196
 > Call Trace:
 >  [<ffffffff811be75e>] path_lookupat+0x71e/0x740
 >  [<ffffffff8100a196>] ? native_sched_clock+0x26/0x90
 >  [<ffffffff810b2118>] ? trace_hardirqs_off_caller+0x28/0xc0
 >  [<ffffffff811be7b4>] filename_lookup+0x34/0xc0
 >  [<ffffffff811be8f2>] do_path_lookup+0x32/0x40
 >  [<ffffffff811beb7a>] kern_path+0x2a/0x50
 >  [<ffffffff811648f3>] ? might_fault+0x53/0xb0
 >  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >  [<ffffffff8116493c>] ? might_fault+0x9c/0xb0
 >  [<ffffffff811648f3>] ? might_fault+0x53/0xb0
 >  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >  [<ffffffff811d569d>] do_mount+0x8d/0xa00
 >  [<ffffffff811591ab>] ? memdup_user+0x4b/0x90
 >  [<ffffffff81159243>] ? strndup_user+0x53/0x70
 >  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >  [<ffffffff811d609e>] sys_mount+0x8e/0xe0
 >  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 >  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
 >  [<ffffffffa0001000>] ? ftrace_raw_event_kvm_age_page+0x70/0xd0 [kvm]
 > Code: 55 48 89 e5 0f 0b 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb 48 83 ec 10 4c 8b 6f 08 48 8b 7f 30 49 3b 7d 30 74 02 <0f> 0b 48 81 c7 e8 00 00 00 49 89 f4 31 f6 e8 7b 52 00 00 8b 53 
 > RIP  [<ffffffff816bc622>] lookup_slow+0x25/0xab
 >  RSP <ffff8800ad2cbc98>
 
Managed to trigger this one from a different path..

kernel BUG at fs/namei.c:1439!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: atm x25 af_key lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek btusb snd_hda_intel bluetooth snd_hda_codec snd_pcm microcode rfkill usb_debug snd_page_alloc serio_raw snd_timer pcspkr snd edac_core soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
CPU 1 
Pid: 3025, comm: trinity-child1 Not tainted 3.9.0-rc1+ #77 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff816bfe24>]  [<ffffffff816bfe24>] lookup_slow+0x25/0xab
RSP: 0018:ffff88010316dd18  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88010316de48 RCX: 0000000000000000
RDX: 0000000000001078 RSI: ffff88010316dd98 RDI: ffff8801053026f8
RBP: ffff88010316dd48 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000010
R13: ffff880104e95720 R14: ffff88010316de48 R15: 0000000001412d30
FS:  00007f80b9bb9740(0000) GS:ffff88012a800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003e29e93880 CR3: 0000000108c39000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child1 (pid: 3025, threadinfo ffff88010316c000, task ffff8801048b2490)
Stack:
 ffff8801048b2bb0 0000000000000000 0000000000000001 0000000000000010
 0000000000000000 ffff88010316de48 ffff88010316dde8 ffffffff811c973e
 ffff88010316dd88 00000000000000d0 00000000000000d0 ffff8801224a2300
Call Trace:
 [<ffffffff811c973e>] path_lookupat+0x71e/0x740
 [<ffffffff8119dbb1>] ? kmem_cache_alloc+0x111/0x330
 [<ffffffff811c7dd0>] ? getname_flags.part.33+0x30/0x150
 [<ffffffff810b32df>] ? lock_release_holdtime.part.24+0x8f/0x130
 [<ffffffff811c9794>] filename_lookup+0x34/0xc0
 [<ffffffff811cc58e>] user_path_at_empty+0x8e/0x110
 [<ffffffff810b2868>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff811cc621>] user_path_at+0x11/0x20
 [<ffffffff811e4347>] sys_lgetxattr+0x37/0xa0
 [<ffffffff8134b6ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816d11c2>] system_call_fastpath+0x16/0x1b
Code: 55 48 89 e5 0f 0b 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb 48 83 ec 10 4c 8b 6f 08 48 8b 7f 30 49 3b 7d 30 74 02 <0f> 0b 48 81 c7 e8 00 00 00 49 89 f4 31 f6 e8 d9 52 00 00 8b 53 
RIP  [<ffffffff816bfe24>] lookup_slow+0x25/0xab
 RSP <ffff88010316dd18>

What can I dump here that might give us more clues ?

The only clue I have on this one so far is that it's something in /proc.
(I have to run trinity with -V /proc right now, because of all those
 weird sysfs corruption bugs until someone gets a handle on those).

	Dave


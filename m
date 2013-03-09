Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3CIDvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:51:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304Ab3CIDu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:50:59 -0500
Date: Fri, 8 Mar 2013 22:50:53 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130309035053.GA1396@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <20130309003617.GB6743@redhat.com>
 <CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
 <20130309020318.GA11449@redhat.com>
 <CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
 <20130309022623.GB11449@redhat.com>
 <20130309025631.GA13188@redhat.com>
 <20130309025752.GA13913@redhat.com>
 <CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
 <20130309032530.GA19839@redhat.com>
 <CA+55aFweyfew3VU79ZQV4otJcWiF0=xKXxDtADXcccNxGaqMwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFweyfew3VU79ZQV4otJcWiF0=xKXxDtADXcccNxGaqMwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:36:34PM -0800, Linus Torvalds wrote:
 > Note that my tree does not have the pipe changes. Um still not sure about
 > the cause, see the patch with a warn-on-once in it. I don't like just
 > adding the NULL pointer checks willy nilly without understanding why they
 > made...

Yeah, understood. I still have that patched.

 > > To be honest I've lost track of the whole collection.
 > > Let me repull your latest tree, and see what falls out.
 > > (I'll turn off CONFIG_USER_NS for now too until that gets fixed)
 > >
 > > I have a feeling there were some sysfs ones that may still be unfixed.

I was right..

[  425.836722] general protection fault: 0000 [#1] PREEMPT SMP 
[  425.837529] Modules linked in: hidp l2tp_ppp l2tp_netlink l2tp_core cmtp kernelcapi bnep rfcomm scsi_transport_iscsi can_raw ipt_ULOG nfnetlink irda can_bcm ipx caif_socket appletalk x25 p8023 af_key caif psnap p8022 crc_ccitt phonet netrom rose rds llc2 nfc llc af_802154 can ax25 pppoe decnet af_rxrpc pppox ppp_generic slhc atm lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb bluetooth snd_pcm snd_page_alloc snd_timer snd usb_debug microcode rfkill pcspkr serio_raw soundcore edac_core vhost_net tun macvtap macvlan kvm_amd r8169 kvm mii radeon backlight drm_kms_helper ttm
[  425.846148] CPU 2 
[  425.846387] Pid: 15263, comm: trinity-child3 Not tainted 3.9.0-rc1+ #88 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
[  425.847859] RIP: 0010:[<ffffffff8123f657>]  [<ffffffff8123f657>] sysfs_find_dirent+0x47/0xf0
[  425.848919] RSP: 0018:ffff88011aab5d38  EFLAGS: 00010202
[  425.849581] RAX: 000000000ad55669 RBX: 6b6b6b6b6b6b6b6b RCX: 000000006b6b6b6b
[  425.850468] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  425.851356] RBP: ffff88011aab5d58 R08: 0000000000000000 R09: 0000000000000000
[  425.852237] R10: 0000000000000000 R11: 0000000000000000 R12: 000000007640c1d4
[  425.853119] R13: ffff880105b41e48 R14: 0000000000000000 R15: ffff880127110000
[  425.854001] FS:  00007f7cdb71d740(0000) GS:ffff88012b200000(0000) knlGS:0000000000000000
[  425.855000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  425.855712] CR2: 0000000000000001 CR3: 0000000102df4000 CR4: 00000000000007e0
[  425.856599] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  425.857486] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  425.858368] Process trinity-child3 (pid: 15263, threadinfo ffff88011aab4000, task ffff880127110000)
[  425.859490] Stack:
[  425.859747]  ffff880113228d58 ffff880105b41e10 fffffffffffffffe ffff88010887eee8
[  425.860718]  ffff88011aab5d88 ffffffff8123f76d ffff880105b41e10 ffff8801088804a0
[  425.861683]  ffff88011aab5f28 0000000000000000 ffff88011aab5db8 ffffffff811c5b7d
[  425.862648] Call Trace:
[  425.862960]  [<ffffffff8123f76d>] sysfs_lookup+0x6d/0xe0
[  425.863623]  [<ffffffff811c5b7d>] lookup_real+0x1d/0x60
[  425.864274]  [<ffffffff811c5d98>] __lookup_hash+0x38/0x50
[  425.864951]  [<ffffffff811c5dc9>] lookup_hash+0x19/0x20
[  425.865607]  [<ffffffff811c9275>] kern_path_create+0x95/0x170
[  425.866322]  [<ffffffff811c7726>] ? getname_flags.part.33+0x86/0x150
[  425.868909]  [<ffffffff811c939a>] user_path_create+0x4a/0x70
[  425.871401]  [<ffffffff811cc668>] sys_linkat+0x88/0x230
[  425.873841]  [<ffffffff8134b06e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  425.876433]  [<ffffffff811cc82e>] sys_link+0x1e/0x20
[  425.878839]  [<ffffffff816d0d42>] system_call_fastpath+0x16/0x1b
[  425.881364] Code: 00 48 8b 9f 88 00 00 00 f6 c4 0f 0f 95 c0 48 85 f6 0f 95 c2 38 d0 75 79 4c 89 ee 4c 89 f7 e8 91 ef ff ff 41 89 c4 48 85 db 74 1d <8b> 4b 28 41 39 cc 74 21 44 89 e0 29 c8 83 f8 00 7c 2c 74 45 48 


I'll try some more divide and conquer debugging in a while.

	Dave


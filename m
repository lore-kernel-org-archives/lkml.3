Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3CGWgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:36:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab3CGWgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:36:49 -0500
Date: Thu, 7 Mar 2013 17:36:10 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: pipe_release oops.
Message-ID: <20130307223610.GA2494@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307220333.GA31039@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 05:03:33PM -0500, Dave Jones wrote:
 
 >  > I seem to have a dim memory of you usually doing your
 >  > trinity runs with more debugging options, but based on just the oops
 >  > message you don't have DEBUG_PAGEALLOC enabled, for example. Maybe
 >  > that and SLUB debugging might turn up the culprit more quickly..
 > 
 > My kernel-hacker hive-mind implant is working. Just started a rebuild with that enabled.
 > Had slub debug already.

The hits keep on coming..

[  255.609172] BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
[  255.610393] IP: [<ffffffff811bad62>] pipe_release+0x42/0xd0
[  255.611235] PGD 0 
[  255.611552] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  255.612406] Modules linked in: nfnetlink can_bcm hidp af_rxrpc netrom pppoe pppox ppp_generic slhc appletalk phonet can_raw can decnet ipx rose irda ax25 x25 p8023 nfc psnap p8022 caif_socket caif crc_ccitt llc2 rds ipt_ULOG af_key atm llc fuse binfmt_misc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm btusb microcode bluetooth usb_debug snd_page_alloc snd_timer rfkill edac_core pcspkr snd serio_raw soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm
[  255.621785] CPU 3 
[  255.622074] Pid: 4645, comm: trinity-child3 Not tainted 3.9.0-rc1+ #71 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
[  255.623791] RIP: 0010:[<ffffffff811bad62>]  [<ffffffff811bad62>] pipe_release+0x42/0xd0
[  255.625008] RSP: 0018:ffff88010cad7dc8  EFLAGS: 00010296
[  255.625797] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000006
[  255.626840] RDX: 0000000000002630 RSI: 2222222222222222 RDI: 0000000000000001
[  255.627881] RBP: ffff88010cad7df8 R08: 2222222222222222 R09: 2222222222222222
[  255.628927] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88010b13cad8
[  255.629969] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88010b13c9f0
[  255.631020] FS:  00007fded3c44740(0000) GS:ffff88012ac00000(0000) knlGS:0000000000000000
[  255.632204] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  255.633053] CR2: 0000000000000064 CR3: 0000000001c0b000 CR4: 00000000000007e0
[  255.634101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  255.635150] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  255.636189] Process trinity-child3 (pid: 4645, threadinfo ffff88010cad6000, task ffff88010ff10000)
[  255.637495] Stack:
[  255.637780]  0000000000000000 ffff880108b07700 0000000000000010 ffff8801143b8940
[  255.638977]  ffff88010b13c9f0 ffff880128a873e0 ffff88010cad7e08 ffffffff811bae0e
[  255.640171]  ffff88010cad7e58 ffffffff811b2825 ffff88010b13c9f0 ffff880108b07710
[  255.641366] Call Trace:
[  255.641743]  [<ffffffff811bae0e>] pipe_rdwr_release+0x1e/0x20
[  255.642591]  [<ffffffff811b2825>] __fput+0xf5/0x2d0
[  255.643313]  [<ffffffff811b2a0e>] ____fput+0xe/0x10
[  255.644040]  [<ffffffff8106c5e5>] task_work_run+0xa5/0xd0
[  255.644819]  [<ffffffff8104ad30>] do_exit+0x2c0/0xce0
[  255.645558]  [<ffffffff816c5d8d>] ? retint_swapgs+0xe/0x13
[  255.646347]  [<ffffffff8104b7ec>] do_group_exit+0x4c/0xc0
[  255.647128]  [<ffffffff8104b877>] sys_exit_group+0x17/0x20
[  255.647920]  [<ffffffff816cdbc2>] system_call_fastpath+0x16/0x1b
[  255.648778] Code: 00 4c 89 6d e8 4c 89 7d f8 41 89 f5 49 89 ff 31 f6 4c 89 e7 48 89 5d d8 4c 89 75 f0 41 89 d6 e8 f5 6d 50 00 49 8b 9f e0 03 00 00 <8b> 43 64 8b 4b 68 44 29 e8 44 29 f1 85 c0 89 43 64 89 4b 68 75 
[  255.652944] RIP  [<ffffffff811bad62>] pipe_release+0x42/0xd0
[  255.653805]  RSP <ffff88010cad7dc8>
[  255.654316] CR2: 0000000000000064
[  255.655087] ---[ end trace 3b502614b99324e0 ]---

        pipe->readers -= decr;
    1642:       8b 43 64                mov    0x64(%rbx),%eax

I'm at the point where *I'm* starting to question what I'm seeing.
I don't have another test machine right now, so I can't see if I can
duplicate these results on another machine, so I'd be interested in 
confirmation that I'm not going crazy debugging a broken machine.

	Dave
 

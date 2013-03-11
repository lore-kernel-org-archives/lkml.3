Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3CKS03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:26:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3CKS02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:26:28 -0400
Date: Mon, 11 Mar 2013 14:26:21 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ipc/testmsg GPF.
Message-ID: <20130311182621.GA24965@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130307213819.GB19543@redhat.com>
 <1362788821.7755.12.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362788821.7755.12.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:27:01PM -0500, Peter Hurley wrote:
 
 > On Thu, 2013-03-07 at 16:38 -0500, Dave Jones wrote:
 > Dave,
 > I thought I copied you on the 'ipc MSG_COPY fixes' patchset that fixes
 > this. Or is this gp fault happening with that patchset?
 > 
 > Linus,
 > The fixes should be in your inbox (from Andrew) titled:
 > [patch 01/11] ipc: fix potential oops when src msg > 4k w/ MSG_COPY
 > [patch 02/11] ipc: don't allocate a copy larger than max
 > 
 > > general protection fault: 0000 [#1] PREEMPT SMP 
 > > Modules linked in: rose ax25 phonet lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec bluetooth snd_pcm snd_page_alloc snd_timer snd vhost_net rfkill tun macvtap usb_debug macvlan microcode serio_raw pcspkr kvm_amd soundcore edac_core r8169 mii kvm
 > > CPU 0 
 > > Pid: 845, comm: trinity-child14 Not tainted 3.9.0-rc1+ #70 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
 > > RIP: 0010:[<ffffffff812b7b00>]  [<ffffffff812b7b00>] testmsg.isra.1+0x40/0x60
 > > RSP: 0018:ffff880122b0fe78  EFLAGS: 00010246
 > > RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
 > > RDX: 0000000000000002 RSI: 000000002c24a9b2 RDI: 697665642d737983
 > > RBP: ffff880122b0fe78 R08: fffffff3f14b03ae R09: 0000000000000000
 > > R10: ffff880127bd8000 R11: 0000000000000000 R12: 000000002c24a9b2
 > > R13: ffff880123360798 R14: ffff8801233606e8 R15: 697665642d737973
 > > FS:  00007f2672bd3740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
 > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > > CR2: 00007f2672b96068 CR3: 0000000127bc1000 CR4: 00000000000007f0
 > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 > > Process trinity-child14 (pid: 845, threadinfo ffff880122b0e000, task ffff880127bd8000)
 > > Stack:
 > >  ffff880122b0ff68 ffffffff812b8e7e ffff8801276d5b90 ffff880127bd8000
 > >  ffff880127bd8000 ffff880127bd8000 0000000000000000 ffffffff812b78c0
 > >  0000000000000000 ffffffff81c7a260 0000000000000000 0000000000001000
 > > Call Trace:
 > >  [<ffffffff812b8e7e>] do_msgrcv+0x1de/0x670
 > >  [<ffffffff812b78c0>] ? load_msg+0x180/0x180
 > >  [<ffffffff810b8685>] ? trace_hardirqs_on_caller+0x115/0x1a0
 > >  [<ffffffff81341aae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 > >  [<ffffffff812b9325>] sys_msgrcv+0x15/0x20
 > >  [<ffffffff816cd982>] system_call_fastpath+0x16/0x1b
 > > Code: 83 fa 04 74 16 31 c0 5d c3 66 90 ff ca b8 01 00 00 00 74 f3 31 c0 eb ef 0f 1f 00 48 39 37 b8 01 00 00 00 7e e2 31 c0 eb de 66 90 <48> 3b 37 75 d5 b8 01 00 00 00 5d c3 0f 1f 40 00 48 3b 37 74 c5 
 > > 
 > > 0000000000000000 <.text>:
 > >    0:	48 3b 37             	cmp    (%rdi),%rsi
 > >    3:	75 d5                	jne    0xffffffffffffffda
 > >    5:	b8 01 00 00 00       	mov    $0x1,%eax
 > >    a:	5d                   	pop    %rbp
 > >    b:	c3                   	retq   
 > >    c:	0f 1f 40 00          	nopl   0x0(%rax)
 > >   10:	48 3b 37             	cmp    (%rdi),%rsi
 > >   13:	74 c5                	je     0xffffffffffffffda
 > > 
 > > rdi is ascii. "ived-sy�" Curious.
 > > 
 > > EIP is here in testmsg.
 > > 
 > >                 case SEARCH_EQUAL:
 > >                         if (msg->m_type == type)
 > >      240:       48 3b 37                cmp    (%rdi),%rsi
 > >      243:       75 d5                   jne    21a <testmsg.isra.1+0x1a>
 > >         {

I just hit this again on rc2 which looks like it has the fixes that
Peter mentions above.  This time rdi was 6b6b6b6b6b6b6b7b

	Dave

[  106.010425] general protection fault: 0000 [#1] PREEMPT SMP 
[  106.010521] Modules linked in: pppoe pppox ppp_generic slhc scsi_transport_iscsi appletalk rose decnet af_rxrpc nfc netrom can_raw af_802154 can llc2 phonet irda atm rds x25 ax25 caif_socket ipx p8023 caif psnap p8022 llc crc_ccitt af_key lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb bluetooth snd_pcm microcode usb_debug rfkill serio_raw pcspkr edac_core snd_page_alloc snd_timer snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
[  106.011028] CPU 0 
[  106.011045] Pid: 794, comm: trinity-child0 Not tainted 3.9.0-rc2+ #90 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
[  106.011115] RIP: 0010:[<ffffffff812c15b0>]  [<ffffffff812c15b0>] testmsg.isra.5+0x30/0x60
[  106.011172] RSP: 0018:ffff880114cf9e78  EFLAGS: 00010246
[  106.011205] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000000004 RCX: 7ffffffffffff001
[  106.011248] RDX: 0000000000000004 RSI: 6b6b6b6b6b6b6b6a RDI: 6b6b6b6b6b6b6b7b
[  106.011290] RBP: ffff880114cf9e78 R08: 0000000000000004 R09: 0000000000000000
[  106.011333] R10: ffff880114f62490 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b6a
[  106.011375] R13: ffff88010fd69300 R14: ffff88010fd69250 R15: 6b6b6b6b6b6b6b6b
[  106.011417] FS:  00007f9dd9637740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
[  106.011465] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.011500] CR2: 0000000002851320 CR3: 0000000114cea000 CR4: 00000000000007f0
[  106.011542] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  106.011584] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  106.011627] Process trinity-child0 (pid: 794, threadinfo ffff880114cf8000, task ffff880114f62490)
[  106.011680] Stack:
[  106.011695]  ffff880114cf9f68 ffffffff812c28b6 ffff880114cf9eb8 ffff880114f62490
[  106.011752]  ffff880114f62490 ffff880114f62490 0000000000000000 ffffffff812c13c0
[  106.011808]  0000000000000001 0000000000000000 ffffffff81c7aa40 0000000000000001
[  106.011862] Call Trace:
[  106.011881]  [<ffffffff812c28b6>] do_msgrcv+0x1d6/0x660
[  106.011916]  [<ffffffff812c13c0>] ? load_msg+0x180/0x180
[  106.011951]  [<ffffffff810b8d55>] ? trace_hardirqs_on_caller+0x115/0x1a0
[  106.011993]  [<ffffffff8134a8de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  106.012034]  [<ffffffff812c2d55>] sys_msgrcv+0x15/0x20
[  106.012070]  [<ffffffff816d05c2>] system_call_fastpath+0x16/0x1b
[  106.012107] Code: 55 83 fa 02 48 89 e5 74 32 7e 10 83 fa 03 74 3b 83 fa 04 74 16 31 c0 5d c3 66 90 ff ca b8 01 00 00 00 74 f3 31 c0 eb ef 0f 1f 00 <48> 39 37 b8 01 00 00 00 7e e2 31 c0 eb de 66 90 48 3b 37 75 d5 
[  106.012405] RIP  [<ffffffff812c15b0>] testmsg.isra.5+0x30/0x60
[  106.012444]  RSP <ffff880114cf9e78>


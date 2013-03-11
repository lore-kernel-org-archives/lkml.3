Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3CKTDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:03:35 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:50783 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3CKTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:03:33 -0400
Message-ID: <1363028602.3234.38.camel@thor.lan>
Subject: Re: ipc/testmsg GPF.
From: Peter Hurley <peter@hurleysoftware.com>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 11 Mar 2013 15:03:22 -0400
In-Reply-To: <20130311182621.GA24965@redhat.com>
References: <20130307213819.GB19543@redhat.com>
	 <1362788821.7755.12.camel@thor.lan> <20130311182621.GA24965@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 14:26 -0400, Dave Jones wrote:
> On Fri, Mar 08, 2013 at 07:27:01PM -0500, Peter Hurley wrote:
>  
>  > On Thu, 2013-03-07 at 16:38 -0500, Dave Jones wrote:
>  > Dave,
>  > I thought I copied you on the 'ipc MSG_COPY fixes' patchset that fixes
>  > this. Or is this gp fault happening with that patchset?
>  > 
>  > Linus,
>  > The fixes should be in your inbox (from Andrew) titled:
>  > [patch 01/11] ipc: fix potential oops when src msg > 4k w/ MSG_COPY
>  > [patch 02/11] ipc: don't allocate a copy larger than max
>  > 
>  > > general protection fault: 0000 [#1] PREEMPT SMP 
>  > > Modules linked in: rose ax25 phonet lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec bluetooth snd_pcm snd_page_alloc snd_timer snd vhost_net rfkill tun macvtap usb_debug macvlan microcode serio_raw pcspkr kvm_amd soundcore edac_core r8169 mii kvm
>  > > CPU 0 
>  > > Pid: 845, comm: trinity-child14 Not tainted 3.9.0-rc1+ #70 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
>  > > RIP: 0010:[<ffffffff812b7b00>]  [<ffffffff812b7b00>] testmsg.isra.1+0x40/0x60
>  > > RSP: 0018:ffff880122b0fe78  EFLAGS: 00010246
>  > > RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
>  > > RDX: 0000000000000002 RSI: 000000002c24a9b2 RDI: 697665642d737983
>  > > RBP: ffff880122b0fe78 R08: fffffff3f14b03ae R09: 0000000000000000
>  > > R10: ffff880127bd8000 R11: 0000000000000000 R12: 000000002c24a9b2
>  > > R13: ffff880123360798 R14: ffff8801233606e8 R15: 697665642d737973
>  > > FS:  00007f2672bd3740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
>  > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  > > CR2: 00007f2672b96068 CR3: 0000000127bc1000 CR4: 00000000000007f0
>  > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  > > Process trinity-child14 (pid: 845, threadinfo ffff880122b0e000, task ffff880127bd8000)
>  > > Stack:
>  > >  ffff880122b0ff68 ffffffff812b8e7e ffff8801276d5b90 ffff880127bd8000
>  > >  ffff880127bd8000 ffff880127bd8000 0000000000000000 ffffffff812b78c0
>  > >  0000000000000000 ffffffff81c7a260 0000000000000000 0000000000001000
>  > > Call Trace:
>  > >  [<ffffffff812b8e7e>] do_msgrcv+0x1de/0x670
>  > >  [<ffffffff812b78c0>] ? load_msg+0x180/0x180
>  > >  [<ffffffff810b8685>] ? trace_hardirqs_on_caller+0x115/0x1a0
>  > >  [<ffffffff81341aae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  > >  [<ffffffff812b9325>] sys_msgrcv+0x15/0x20
>  > >  [<ffffffff816cd982>] system_call_fastpath+0x16/0x1b
>  > > Code: 83 fa 04 74 16 31 c0 5d c3 66 90 ff ca b8 01 00 00 00 74 f3 31 c0 eb ef 0f 1f 00 48 39 37 b8 01 00 00 00 7e e2 31 c0 eb de 66 90 <48> 3b 37 75 d5 b8 01 00 00 00 5d c3 0f 1f 40 00 48 3b 37 74 c5 
>  > > 
>  > > 0000000000000000 <.text>:
>  > >    0:	48 3b 37             	cmp    (%rdi),%rsi
>  > >    3:	75 d5                	jne    0xffffffffffffffda
>  > >    5:	b8 01 00 00 00       	mov    $0x1,%eax
>  > >    a:	5d                   	pop    %rbp
>  > >    b:	c3                   	retq   
>  > >    c:	0f 1f 40 00          	nopl   0x0(%rax)
>  > >   10:	48 3b 37             	cmp    (%rdi),%rsi
>  > >   13:	74 c5                	je     0xffffffffffffffda
>  > > 
>  > > rdi is ascii. "ived-sy�" Curious.
>  > > 
>  > > EIP is here in testmsg.
>  > > 
>  > >                 case SEARCH_EQUAL:
>  > >                         if (msg->m_type == type)
>  > >      240:       48 3b 37                cmp    (%rdi),%rsi
>  > >      243:       75 d5                   jne    21a <testmsg.isra.1+0x1a>
>  > >         {
> 
> I just hit this again on rc2 which looks like it has the fixes that
> Peter mentions above.  This time rdi was 6b6b6b6b6b6b6b7b
> 
> 	Dave

Sorry, Dave. The fix must be in the other 8 patches that Andrew didn't
want to apply. I run trinity 10 or more times a day and can't get this
to trigger with the whole series.

Regards,
Peter Hurley


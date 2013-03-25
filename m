Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab3CYQhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655Ab3CYQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:37:11 -0400
Date: Mon, 25 Mar 2013 12:37:03 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ipc/testmsg GPF.
Message-ID: <20130325163703.GA19064@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130307213819.GB19543@redhat.com>
 <1362788821.7755.12.camel@thor.lan>
 <20130311182621.GA24965@redhat.com>
 <1363028602.3234.38.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363028602.3234.38.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 03:03:22PM -0400, Peter Hurley wrote:
 > On Mon, 2013-03-11 at 14:26 -0400, Dave Jones wrote:
 > > On Fri, Mar 08, 2013 at 07:27:01PM -0500, Peter Hurley wrote:
 > >  
 > >  > On Thu, 2013-03-07 at 16:38 -0500, Dave Jones wrote:
 > >  > 
 > >  > > general protection fault: 0000 [#1] PREEMPT SMP 
 > >  > > Modules linked in: rose ax25 phonet lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec bluetooth snd_pcm snd_page_alloc snd_timer snd vhost_net rfkill tun macvtap usb_debug macvlan microcode serio_raw pcspkr kvm_amd soundcore edac_core r8169 mii kvm
 > >  > > CPU 0 
 > >  > > Pid: 845, comm: trinity-child14 Not tainted 3.9.0-rc1+ #70 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
 > >  > > RIP: 0010:[<ffffffff812b7b00>]  [<ffffffff812b7b00>] testmsg.isra.1+0x40/0x60
 > >  > > RSP: 0018:ffff880122b0fe78  EFLAGS: 00010246
 > >  > > RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
 > >  > > RDX: 0000000000000002 RSI: 000000002c24a9b2 RDI: 697665642d737983
 > >  > > RBP: ffff880122b0fe78 R08: fffffff3f14b03ae R09: 0000000000000000
 > >  > > R10: ffff880127bd8000 R11: 0000000000000000 R12: 000000002c24a9b2
 > >  > > R13: ffff880123360798 R14: ffff8801233606e8 R15: 697665642d737973
 > >  > > FS:  00007f2672bd3740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
 > >  > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > >  > > CR2: 00007f2672b96068 CR3: 0000000127bc1000 CR4: 00000000000007f0
 > >  > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 > >  > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 > >  > > Process trinity-child14 (pid: 845, threadinfo ffff880122b0e000, task ffff880127bd8000)
 > >  > > Stack:
 > >  > >  ffff880122b0ff68 ffffffff812b8e7e ffff8801276d5b90 ffff880127bd8000
 > >  > >  ffff880127bd8000 ffff880127bd8000 0000000000000000 ffffffff812b78c0
 > >  > >  0000000000000000 ffffffff81c7a260 0000000000000000 0000000000001000
 > >  > > Call Trace:
 > >  > >  [<ffffffff812b8e7e>] do_msgrcv+0x1de/0x670
 > >  > >  [<ffffffff812b78c0>] ? load_msg+0x180/0x180
 > >  > >  [<ffffffff810b8685>] ? trace_hardirqs_on_caller+0x115/0x1a0
 > >  > >  [<ffffffff81341aae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 > >  > >  [<ffffffff812b9325>] sys_msgrcv+0x15/0x20
 > >  > >  [<ffffffff816cd982>] system_call_fastpath+0x16/0x1b
 > >  > > Code: 83 fa 04 74 16 31 c0 5d c3 66 90 ff ca b8 01 00 00 00 74 f3 31 c0 eb ef 0f 1f 00 48 39 37 b8 01 00 00 00 7e e2 31 c0 eb de 66 90 <48> 3b 37 75 d5 b8 01 00 00 00 5d c3 0f 1f 40 00 48 3b 37 74 c5 
 > >  > > 
 > >  > > 0000000000000000 <.text>:
 > >  > >    0:	48 3b 37             	cmp    (%rdi),%rsi
 > >  > >    3:	75 d5                	jne    0xffffffffffffffda
 > >  > >    5:	b8 01 00 00 00       	mov    $0x1,%eax
 > >  > >    a:	5d                   	pop    %rbp
 > >  > >    b:	c3                   	retq   
 > >  > >    c:	0f 1f 40 00          	nopl   0x0(%rax)
 > >  > >   10:	48 3b 37             	cmp    (%rdi),%rsi
 > >  > >   13:	74 c5                	je     0xffffffffffffffda
 > >  > > 
 > >  > > rdi is ascii. "ived-sy�" Curious.
 > >  > > 
 > >  > > EIP is here in testmsg.
 > >  > > 
 > >  > >                 case SEARCH_EQUAL:
 > >  > >                         if (msg->m_type == type)
 > >  > >      240:       48 3b 37                cmp    (%rdi),%rsi
 > >  > >      243:       75 d5                   jne    21a <testmsg.isra.1+0x1a>
 > >  > >         {
 > > 
 > > I just hit this again on rc2 which looks like it has the fixes that
 > > Peter mentions above.  This time rdi was 6b6b6b6b6b6b6b7b
 > > 
 > > 	Dave
 > 
 > Sorry, Dave. The fix must be in the other 8 patches that Andrew didn't
 > want to apply. I run trinity 10 or more times a day and can't get this
 > to trigger with the whole series.

bad news: Turns out my recent testing where I thought your patches fixed
this was incorrect.  I had excluded fuzz testing of msgrcv, so it was never
getting exercised.

When I put that back, rc4 + your patches still crashes.
However the crash looks slightly different..
(That may be because I upgraded the compiler from 4.7->4.8 last week)


general protection fault: 0000 [#1] PREEMPT SMP 
Modules linked in: af_key phonet cmtp rose kernelcapi l2tp_ppp l2tp_netlink l2tp_core pppoe pppox hidp can_raw ppp_generic slhc nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can irda appletalk ipx rds p8023 p8022 atm decnet crc_ccitt x25 psnap af_802154 ax25 llc nfc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb bluetooth snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc rfkill vhost_net tun macvtap microcode macvlan edac_core snd_timer kvm_amd snd serio_raw kvm r8169 pcspkr soundcore mii radeon backlight drm_kms_helper ttm
CPU 1 
Pid: 1067, comm: trinity-child1 Not tainted 3.9.0-rc4+ #120 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff812c2e9e>]  [<ffffffff812c2e9e>] do_msgrcv+0x1ee/0x5f0
RSP: 0018:ffff8800be6dde98  EFLAGS: 00010297
RAX: 0000000001868405 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8800be68c920 RSI: 0000000000004000 RDI: ffff8800cfb206e8
RBP: ffff8800be6ddf68 R08: 0000000000000001 R09: 0000000000000001
R10: ffff8800be68c920 R11: 0000000000000001 R12: 0000000000000000
R13: ffff8800cfb20798 R14: ffff8800cfb206e8 R15: 6b6b6b6b6b6b6b6b
FS:  00007f1bf1243740(0000) GS:ffff88012b000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1bf1206068 CR3: 00000000be5e0000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child1 (pid: 1067, threadinfo ffff8800be6dc000, task ffff8800be68c920)
Stack:
 ffff8800bb674f50 ffff8800be68c920 ffff8800be68c920 ffff8800be68c920
 ffffffff812c1b40 0000000000afb000 ffffffff81c7ad20 0000000001868405
 0000000000000000 000040002e16f9d4 0000000000000001 ffff8800be68c920
Call Trace:
 [<ffffffff812c1b40>] ? msg_security+0x10/0x10
 [<ffffffff810b6bc5>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134aa6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812c32b5>] sys_msgrcv+0x15/0x20
 [<ffffffff816cda02>] system_call_fastpath+0x16/0x1b
Code: cc 83 fb 04 0f 84 f3 00 00 00 8b 74 24 4c 85 f6 0f 84 18 02 00 00 48 8b 44 24 38 48 39 44 24 50 0f 84 12 02 00 00 4c 89 7c 24 60 <4d> 8b 3f 48 ff 44 24 50 4d 39 ef 75 9d 0f 1f 44 00 00 48 81 7c 


  2b:*	4d 8b 3f             	mov    (%r15),%r15     <-- trapping instruction
  2e:	48 ff 44 24 50       	incq   0x50(%rsp)
  33:	4d 39 ef             	cmp    %r13,%r15
  36:	75 9d                	jne    0xffffffffffffffd5
  38:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  3d:	48                   	rex.W
  3e:	81                   	.byte 0x81
  3f:	7c                   	.byte 0x7c

objdump -S output shows that this is here in do_msgrcv() 

 875                                 } else
 876                                         break;
 877                                 msg_counter++;
 878                         }
 879                         tmp = tmp->next;
 880                 }
 881                 if (!IS_ERR(msg)) {

the tmp->next deref goes chasing a freed pointer.

	Dave


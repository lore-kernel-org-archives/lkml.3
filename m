Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3C2QS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:18:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab3C2QSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:18:24 -0400
Date: Fri, 29 Mar 2013 12:17:46 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130329161746.GA8391@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
	davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
	hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
	lwoodman@redhat.com, chegu_vinod@hp.com,
	Peter Hurley <peter@hurleysoftware.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
 <20130326192852.GA25899@redhat.com>
 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 12:43:09PM -0700, Andrew Morton wrote:
 > On Tue, 26 Mar 2013 15:28:52 -0400 Dave Jones <davej@redhat.com> wrote:
 > 
 > > On Thu, Mar 21, 2013 at 02:10:58PM -0700, Andrew Morton wrote:
 > > 
 > >  > Whichever way we go, we should get a wiggle on - this has been hanging
 > >  > around for too long.  Dave, do you have time to determine whether
 > >  > reverting 88b9e456b1649722673ff ("ipc: don't allocate a copy larger
 > >  > than max") fixes things up?
 > > 
 > > Ok, with that reverted it's been grinding away for a few hours without incident.
 > > Normally I see the oops within a minute or so.
 > 
 > OK, thanks, I queued a revert:
 > 
 > From: Andrew Morton <akpm@linux-foundation.org>
 > Subject: revert "ipc: don't allocate a copy larger than max"
 > 
 > Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
 > during trinity testing.

Now that I have that reverted, I'm not seeing msgrcv traces any more, but 
I've started seeing this..

general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: l2tp_ppp l2tp_netlink l2tp_core llc2 phonet netrom rose af_key af_rxrpc caif_socket caif can_raw cmtp kernelcapi can_bcm can nfnetlink ipt_ULOG scsi_transport_iscsi af_802154 ax25 atm ipx pppoe pppox x25 nfc irda ppp_generic p8023 slhc p8022 appletalk decnet crc_ccitt rds psnap llc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek btusb snd_hda_intel bluetooth snd_hda_codec raid0 snd_pcm rfkill microcode serio_raw pcspkr snd_page_alloc edac_core snd_timer snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
CPU 3 
Pid: 1850, comm: trinity-child37 Tainted: G    B        3.9.0-rc4+ #7 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff812c20fb>]  [<ffffffff812c20fb>] free_msg+0x2b/0x40
RSP: 0018:ffff8800a1d3bdd0  EFLAGS: 00010202
RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff810b6ced
RBP: ffff8800a1d3bde0 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88009997e620
R13: ffffffff81c7ace0 R14: ffff8800caf359d8 R15: ffffffff81c7b024
FS:  00007f2d7be64740(0000) GS:ffff88012ac00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f8bd7bb6000 CR3: 00000000a1f0a000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child37 (pid: 1850, threadinfo ffff8800a1d3a000, task ffff8800a1e62490)
Stack:
 6b6b6b6b6b6b6b6b ffff8800caf35928 ffff8800a1d3be18 ffffffff812c289f
 0000000000000000 ffffffff81c7ace0 ffff8800caf35928 0000000000000000
 ffff8800a1d3be28 ffff8800a1d3bec8 ffffffff812c2a93 ffff8800a1d3be40
Call Trace:
 [<ffffffff812c289f>] freeque+0xcf/0x140
 [<ffffffff812c2a93>] msgctl_down.constprop.9+0x183/0x200
 [<ffffffff810767cf>] ? up_read+0x1f/0x40
 [<ffffffff816c8f94>] ? __do_page_fault+0x214/0x5b0
 [<ffffffff810b94be>] ? lock_release_non_nested+0x23e/0x320
 [<ffffffff812c2da9>] sys_msgctl+0x139/0x400
 [<ffffffff816c5d4d>] ? retint_swapgs+0xe/0x13
 [<ffffffff810b6c55>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134b39e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
Code: 66 66 66 66 90 55 48 89 e5 41 54 49 89 fc 53 e8 fc 5e 01 00 49 8b 5c 24 20 4c 89 e7 e8 8f af ed ff 48 85 db 75 05 eb 13 4c 89 e3 <4c> 8b 23 48 89 df e8 7a af ed ff 4d 85 e4 75 ed 5b 41 5c 5d c3 


(Taint is from an ext4 double-free I just reported in a separate thread)

decoded..

   0:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax
   5:	55                   	push   %rbp
   6:	48 89 e5             	mov    %rsp,%rbp
   9:	41 54                	push   %r12
   b:	49 89 fc             	mov    %rdi,%r12
   e:	53                   	push   %rbx
   f:	e8 fc 5e 01 00       	callq  0x15f10
  14:	49 8b 5c 24 20       	mov    0x20(%r12),%rbx
  19:	4c 89 e7             	mov    %r12,%rdi
  1c:	e8 8f af ed ff       	callq  0xffffffffffedafb0
  21:	48 85 db             	test   %rbx,%rbx
  24:	75 05                	jne    0x2b
  26:	eb 13                	jmp    0x3b
  28:	4c 89 e3             	mov    %r12,%rbx
  2b:*	4c 8b 23             	mov    (%rbx),%r12     <-- trapping instruction
  2e:	48 89 df             	mov    %rbx,%rdi
  31:	e8 7a af ed ff       	callq  0xffffffffffedafb0
  36:	4d 85 e4             	test   %r12,%r12
  39:	75 ed                	jne    0x28
  3b:	5b                   	pop    %rbx
  3c:	41 5c                	pop    %r12
  3e:	5d                   	pop    %rbp
  3f:	c3                   	retq   

Disassembly of free_msg shows..

        seg = msg->next;
        kfree(msg);
        while (seg != NULL) {
                struct msg_msgseg *tmp = seg->next;
 30b:   4c 8b 23                mov    (%rbx),%r12
                kfree(seg);
 30e:   48 89 df                mov    %rbx,%rdi
 311:   e8 00 00 00 00          callq  316 <free_msg+0x36>


Looks like seg was already kfree'd.

	Dave


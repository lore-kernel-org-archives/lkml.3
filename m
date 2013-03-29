Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3C2TCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab3C2TCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:02:45 -0400
Date: Fri, 29 Mar 2013 15:01:35 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130329190135.GB23893@redhat.com>
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
 > > 
 > 
 > OK, thanks, I queued a revert:
 > 
 > From: Andrew Morton <akpm@linux-foundation.org>
 > Subject: revert "ipc: don't allocate a copy larger than max"
 > 
 > Revert 88b9e456b164.  Dave has confirmed that this was causing oopses
 > during trinity testing.

I owe Peter an apology. I just hit it again with that backed out.
Andrew, might as well drop that revert.

BUG: unable to handle kernel NULL pointer dereference at 000000000000000f
IP: [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60
PGD 10fd95067 PUD 10f767067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: phonet netrom llc2 af_key rose af_rxrpc caif_socket caif can_raw cmtp kernelcapi ipt_ULOG nfnetlink can_bcm can scsi_transport_iscsi af_802154 irda ax25 atm ipx x25 p8023 p8022 appletalk pppoe decnet pppox ppp_generic nfc rds slhc psnap crc_ccitt llc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables raid0 snd_hda_codec_realtek snd_hda_intel btusb snd_hda_codec bluetooth microcode serio_raw snd_pcm edac_core pcspkr snd_page_alloc rfkill snd_timer snd soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
CPU 2 
Pid: 958, comm: trinity-child20 Not tainted 3.9.0-rc4+ #7 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<ffffffff812c24ca>]  [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60
RSP: 0018:ffff880117bb5e88  EFLAGS: 00010246
RAX: ffffffffffffffff RBX: 0000000000000004 RCX: 0000000000000078
RDX: 0000000000000004 RSI: fffffffffffffffe RDI: 000000000000000f
RBP: ffff880117bb5e88 R08: 0000000000000004 R09: 0000000000000001
R10: ffff880117bb8000 R11: 0000000000000001 R12: fffffffffffffffe
R13: ffff88010fd10308 R14: ffff88010fd10258 R15: ffffffffffffffff
FS:  00007fa89c256740(0000) GS:ffff88012aa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000000f CR3: 000000010f76c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child20 (pid: 958, threadinfo ffff880117bb4000, task ffff880117bb8000)
Stack:
 ffff880117bb5f68 ffffffff812c3746 0000000000000000 ffff880117bb8000
 ffff880117bb8000 ffff880117bb8000 ffffffff81c7ace0 ffffffff812c2430
 0000000000000004 0000000000000000 000000000000ffff 00000000652a928e
Call Trace:
 [<ffffffff812c3746>] do_msgrcv+0x1a6/0x5f0
 [<ffffffff812c2430>] ? msg_security+0x10/0x10
 [<ffffffff810b6c55>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134b39e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff812c3ba5>] sys_msgrcv+0x15/0x20
 [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
Code: c3 48 c7 c0 f2 ff ff ff eb e5 0f 1f 80 00 00 00 00 66 66 66 66 90 55 83 fa 02 48 89 e5 74 3a 7e 28 83 fa 03 74 13 83 fa 04 75 0a <48> 39 37 b8 01 00 00 00 7e 02 31 c0 5d c3 48 3b 37 74 f7 b8 01 
RIP  [<ffffffff812c24ca>] testmsg.isra.5+0x1a/0x60

I think I wasn't seeing that this last week because I had inadvertantly disabled DEBUG_PAGEALLOC

and.. we're back to square one.

	Dave


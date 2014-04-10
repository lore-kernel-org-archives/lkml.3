Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbaDJHyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:54:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:35831 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbaDJHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:54:16 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2014 03:54:15 EDT
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 10 Apr 2014 16:39:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: ak@linux.intel.com, penberg@iki.fi, linux-kernel@vger.kernel.org
Subject: Re: [3.15-rc1 slab] Oops when reading /proc/slab_allocators
Message-ID: <20140410073918.GB8204@js1304-P5Q-DELUXE>
References: <201404092036.CEF21247.VFSQFFMLOJOOtH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404092036.CEF21247.VFSQFFMLOJOOtH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 08:36:10PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I found that
> 
>   $ cat /proc/slab_allocators
> 
> causes an oops.
> 
> ---------- dmesg start ----------
> [   22.719620] BUG: unable to handle kernel paging request at ffff8800389b7ff8
> [   22.719742] IP: [<ffffffff811b751d>] handle_slab+0x8d/0x1a0
> [   22.719742] PGD 2d64067 PUD 2d65067 PMD 3fc20067 PTE 80000000389b7060
> [   22.719742] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [   22.719742] Modules linked in:
> [   22.719742] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-12041-g75ff24f #297
> [   22.719742] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> [   22.719742] task: ffff88003decc010 ti: ffff88003ded0000 task.ti: ffff88003ded0000
> [   22.719742] RIP: 0010:[<ffffffff811b751d>]  [<ffffffff811b751d>] handle_slab+0x8d/0x1a0
> [   22.719742] RSP: 0018:ffff88003ded1d88  EFLAGS: 00000002
> [   22.719742] RAX: 0000000000000001 RBX: 0000000000000001 RCX: ffff88003f625c80
> [   22.719742] RDX: ffffea0000e26dc0 RSI: 0000000000000000 RDI: ffff88001763f000
> [   22.719742] RBP: ffff88003ded1dd8 R08: ffff88001763f000 R09: ffff88001763f008
> [   22.719742] R10: ffff88001763f010 R11: 0000000000001000 R12: ffff880017616f00
> [   22.719742] R13: 0000000000000000 R14: ffff8800389b7000 R15: ffffea0000e26dc0
> [   22.719742] FS:  00000000015b7860(0063) GS:ffff88003fa00000(0000) knlGS:0000000000000000
> [   22.719742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   22.719742] CR2: ffff8800389b7ff8 CR3: 0000000017619000 CR4: 00000000000006f0
> [   22.719742] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   22.719742] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [   22.719742] Stack:
> [   22.719742]  ffff88001763f010 ffff88003f625c80 ffff88001763f000 ffff88001763f008
> [   22.719742]  ffff88003ded1dd8 ffff88001763f000 ffff880017616f00 ffff88003f625c80
> [   22.719742]  0000000000000400 ffffea0000e26dc0 ffff88003ded1e48 ffffffff811bcbd6
> [   22.719742] Call Trace:
> [   22.719742]  [<ffffffff811bcbd6>] leaks_show+0xf6/0x270
> [   22.719742]  [<ffffffff811f529f>] seq_read+0x2af/0x440
> [   22.719742]  [<ffffffff8123e213>] proc_reg_read+0x43/0x70
> [   22.719742]  [<ffffffff811ccdcd>] vfs_read+0xad/0x190
> [   22.719742]  [<ffffffff811ccf99>] SyS_read+0x59/0xd0
> [   22.719742]  [<ffffffff81658412>] system_call_fastpath+0x16/0x1b
> [   22.719742] Code: 75 18 e9 df 00 00 00 0f 1f 80 00 00 00 00 48 63 d0 3b 34 97 0f 84 cc 00 00 00 83 c0 01 39 c3 77 ed f6 41 1a 01 0f 84 02 01 00 00 <4f> 8b 64 1e f8 4d 85 e4 0f 84 ad 00 00 00 49 8b 39 4c 89 d3 89
> [   22.719742] RIP  [<ffffffff811b751d>] handle_slab+0x8d/0x1a0
> [   22.719742]  RSP <ffff88003ded1d88>
> [   22.719742] CR2: ffff8800389b7ff8
> [   22.719742] ---[ end trace b3602f55c39df20e ]---
> ---------- dmesg end ----------
> 
> Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-pre-3.15-rc1 .
> 
> The location is
> 
>   if (!add_caller(n, (unsigned long)*dbg_userword(c, p)))
> 
> in handle_slab() in mm/slab.c , and dbg_userword(c, p) is returning
> an undereferencable value (0xffff8800389b7ff8) when
> n=ffff880017645000, c=ffff88003f625c80, p=ffff8800389b7000,
> c->flags=0x80010c00 and c->size=4096.
> 
>   static void **dbg_userword(struct kmem_cache *cachep, void *objp)
>   {
>           BUG_ON(!(cachep->flags & SLAB_STORE_USER));
>           return (void **)(objp + cachep->size - BYTES_PER_WORD);
>   }
> 
> Bisection reached commit b1cb0982 "slab: change the management method
> of free objects of the slab".
> 
>   bad commit b1cb0982bdd6f57fed690f796659733350bb2cae
>   good commit a57a49887eb3398d31bfaa8009531f7121d6537d
>   untestable commit 56f295ef0dfa7e1d0be18deebe0c15fb6b2d9d5b
>   untestable commit 0c3aa83e00a9cd93f08e7aa42fba01924aa5f2fc
>   good commit 73293c2f900d0adbb6a415b312cd57976d5ae242

Hello,

Thanks for reporting.

There was another report about this problem and I have already fixed
it, although it wasn't reviewed and merged. See following link.

https://lkml.org/lkml/2014/3/11/119

In that time, I thought that this problem wasn't related to my patches,
but your bisect report say that it is from my patches. I will dig into
the problem more deeply as soon as possible and make proper fix.

Thanks.



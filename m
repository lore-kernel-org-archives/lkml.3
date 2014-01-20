Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaATOUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:20:05 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:61298 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaATOUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:20:00 -0500
Date: Mon, 20 Jan 2014 15:19:47 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zenic.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Linux 3.13
Message-ID: <20140120141947.GA20249@glitch>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zenic.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
References: <CA+55aFy1bG918OpEaydy+f8GetF267Ykz_3-H_sBjTVWsMe1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy1bG918OpEaydy+f8GetF267Ykz_3-H_sBjTVWsMe1Fg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 07:13:30PM -0800, Linus Torvalds wrote:
> The release got delayed by a week due to travels, but I suspect that's
> just as well. We had a few fixes come in, and while it wasn't a lot, I
> think we're better off for it. At least I hope so - I'll be very
> disappointed if any of them cause more problems than they fix..
> 
> Anyway, the patch from rc8 is fairly small, with mainly some small
> arch updates (arm, mips, powerpc, s390, sparc, x86 all had some minor
> changes, some of them due to a networking fix for the bpf jit). And
> drivers (mainly gpu and networking). And some generic networking
> fixes. The appended shortlog gives more details.
> 
> Anyway, with this, the merge window for 3.14 is obviously open.
> 
>                 Linus
> 

Hi,

  is this interesting to anybody? I'm not sure I can reproduce it, I'm
receiving quite a few issues from my dodgy USB storage devices (under
investigation in order to remove the "dodgy") but I think it's the first
time I see this.  It comes from a brand new v3.13.

[ 5523.010247] blkid           D ffff8801e1360ce0     0 14143      1 0x20020004
[ 5523.010250]  ffff88015cd59ab8 0000000000000086 0000000000000002 ffff8801e1360ce0
[ 5523.010252]  ffff88015cd59fd8 0000000000011800 0000000000011800 ffff8801e1360ce0
[ 5523.010253]  ffff88021e5f4c00 ffff880100000002 ffff88015cd59a58 ffffffff810b4731
[ 5523.010254] Call Trace:
[ 5523.010261]  [<ffffffff810b4731>] ? filemap_fault+0x71/0x3c0
[ 5523.010263]  [<ffffffff810bf4a9>] ? lru_cache_add+0x9/0x10
[ 5523.010265]  [<ffffffff810b2d62>] ? unlock_page+0x22/0x30
[ 5523.010268]  [<ffffffff8161ad44>] schedule+0x24/0x70
[ 5523.010270]  [<ffffffff8161b111>] schedule_preempt_disabled+0x11/0x20
[ 5523.010272]  [<ffffffff8161c5ec>] __mutex_lock_slowpath+0x11c/0x1f0
[ 5523.010273]  [<ffffffff8161c6d6>] mutex_lock+0x16/0x2a
[ 5523.010277]  [<ffffffff811308a3>] __blkdev_get+0x43/0x450
[ 5523.010278]  [<ffffffff81131020>] ? blkdev_get_by_dev+0x50/0x50
[ 5523.010280]  [<ffffffff81130e65>] blkdev_get+0x1b5/0x320
[ 5523.010282]  [<ffffffff81131020>] ? blkdev_get_by_dev+0x50/0x50
[ 5523.010283]  [<ffffffff8113107a>] blkdev_open+0x5a/0x80
[ 5523.010285]  [<ffffffff810fb0b2>] do_dentry_open.isra.18+0x1a2/0x2a0
[ 5523.010288]  [<ffffffff811079d2>] ? __inode_permission+0x22/0x70
[ 5523.010289]  [<ffffffff810fb29d>] finish_open+0x1d/0x30
[ 5523.010291]  [<ffffffff8110a33a>] do_last.isra.64+0x4aa/0xc50
[ 5523.010292]  [<ffffffff810b2d62>] ? unlock_page+0x22/0x30
[ 5523.010294]  [<ffffffff8110ab8b>] path_openat+0xab/0x620
[ 5523.010296]  [<ffffffff810d6572>] ? handle_mm_fault+0x272/0xa50
[ 5523.010297]  [<ffffffff8110c125>] do_filp_open+0x35/0x90
[ 5523.010299]  [<ffffffff8111841f>] ? __alloc_fd+0x9f/0x130
[ 5523.010301]  [<ffffffff810fc354>] do_sys_open+0x124/0x220
[ 5523.010304]  [<ffffffff811475f6>] compat_SyS_open+0x16/0x20
[ 5523.010306]  [<ffffffff8161f991>] sysenter_dispatch+0x7/0x1e

KRs,
Domenico

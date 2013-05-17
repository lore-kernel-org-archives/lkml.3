Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3EQIZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:25:47 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3425 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3EQIZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:25:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [media] cx25821 regression from 3.9: BUG: bad unlock balance detected!
Date: Fri, 17 May 2013 10:25:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc5-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1139404719.20130516194142@eikelenboom.it>
In-Reply-To: <1139404719.20130516194142@eikelenboom.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305171025.24166.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu May 16 2013 19:41:42 Sander Eikelenboom wrote:
> Hi Hans / Mauro,
> 
> With 3.10.0-rc1 (including the cx25821 changes from Hans), I get the bug below which wasn't present with 3.9.

How do I reproduce this? I've tried to, but I can't make this happen.

Looking at the code I can't see how it could hit this bug anyway.

Regards,

	Hans

> 
> --
> Sander
> 
> 
> [   53.004968] =====================================
> [   53.004968] [ BUG: bad unlock balance detected! ]
> [   53.004968] 3.10.0-rc1-20130516-jens+ #1 Not tainted
> [   53.004968] -------------------------------------
> [   53.004968] motion/3328 is trying to release lock (&dev->lock) at:
> [   53.004968] [<ffffffff819be5f9>] mutex_unlock+0x9/0x10
> [   53.004968] but there are no more locks to release!
> [   53.004968]
> [   53.004968] other info that might help us debug this:
> [   53.004968] 1 lock held by motion/3328:
> [   53.004968]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81156cae>] vm_munmap+0x3e/0x70
> [   53.004968]
> [   53.004968] stack backtrace:
> [   53.004968] CPU: 1 PID: 3328 Comm: motion Not tainted 3.10.0-rc1-20130516-jens+ #1
> [   53.004968] Hardware name: Xen HVM domU, BIOS 4.3-unstable 05/16/2013
> [   53.004968]  ffffffff819be5f9 ffff88002ac35c58 ffffffff819b9029 ffff88002ac35c88
> [   53.004968]  ffffffff810e615e ffff88002ac35cb8 ffff88002b7c18a8 ffffffff819be5f9
> [   53.004968]  00000000ffffffff ffff88002ac35d28 ffffffff810eb17e ffffffff810e7ba5
> [   53.004968] Call Trace:
> [   53.004968]  [<ffffffff819be5f9>] ? mutex_unlock+0x9/0x10
> [   53.004968]  [<ffffffff819b9029>] dump_stack+0x19/0x1b
> [   53.004968]  [<ffffffff810e615e>] print_unlock_imbalance_bug+0xfe/0x110
> [   53.004968]  [<ffffffff819be5f9>] ? mutex_unlock+0x9/0x10
> [   53.004968]  [<ffffffff810eb17e>] lock_release_non_nested+0x1ce/0x320
> [   53.004968]  [<ffffffff810e7ba5>] ? debug_check_no_locks_freed+0x105/0x1b0
> [   53.353529]  [<ffffffff819be5f9>] ? mutex_unlock+0x9/0x10
> [   53.353529]  [<ffffffff810eb3cc>] lock_release+0xfc/0x250
> [   53.353529]  [<ffffffff819be4b2>] __mutex_unlock_slowpath+0xb2/0x1f0
> [   53.353529]  [<ffffffff819be5f9>] mutex_unlock+0x9/0x10
> [   53.353529]  [<ffffffff81711105>] videobuf_waiton+0x55/0x230
> [   53.353529]  [<ffffffff8114d052>] ? tlb_finish_mmu+0x32/0x50
> [   53.353529]  [<ffffffff81154a46>] ? unmap_region+0xc6/0x100
> [   53.353529]  [<ffffffff81172e05>] ? kmem_cache_free+0x195/0x230
> [   53.353529]  [<ffffffff8172d3d9>] cx25821_free_buffer+0x49/0xa0
> [   53.353529]  [<ffffffff8172f939>] cx25821_buffer_release+0x9/0x10
> [   53.353529]  [<ffffffff81712c35>] videobuf_vm_close+0xc5/0x160
> [   53.353529]  [<ffffffff81154aa5>] remove_vma+0x25/0x60
> [   53.353529]  [<ffffffff81156b67>] do_munmap+0x307/0x410
> [   53.353529]  [<ffffffff81156cbc>] vm_munmap+0x4c/0x70
> [   53.353529]  [<ffffffff81157c09>] SyS_munmap+0x9/0x10
> [   53.353529]  [<ffffffff819c20a9>] system_call_fastpath+0x16/0x1b
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3J1K0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:26:10 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55543 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3J1K0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:26:08 -0400
Date: Mon, 28 Oct 2013 11:26:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20131028102604.GA6127@gmail.com>
References: <20131028202442.5033ddf42639863d5f1dcf67@canb.auug.org.au>
 <20131028101823.GA3512@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028101823.GA3512@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thierry Reding <thierry.reding@gmail.com> wrote:

> On Mon, Oct 28, 2013 at 08:24:42PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the tip tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > In file included from /scratch/sfr/next/include/linux/mmzone.h:9:0,
> >                  from /scratch/sfr/next/include/linux/gfp.h:4,
> >                  from /scratch/sfr/next/include/linux/kmod.h:22,
> >                  from /scratch/sfr/next/include/linux/module.h:13,
> >                  from /scratch/sfr/next/block/blk-mq.c:2:
> > /scratch/sfr/next/block/blk-mq.c: In function 'blk_mq_queue_enter':
> > /scratch/sfr/next/include/linux/wait.h:772:2: error: expected ';' before '__ret'
> >   __ret;        \
> >   ^
> > /scratch/sfr/next/block/blk-mq.c:108:8: note: in expansion of macro 'wait_event_interruptible_lock_irq'
> >   ret = wait_event_interruptible_lock_irq(q->mq_freeze_wq,
> >         ^
> > /scratch/sfr/next/block/blk-mq.c:108:6: error: void value not ignored as it ought to be
> >   ret = wait_event_interruptible_lock_irq(q->mq_freeze_wq,
> >       ^
> > 
> > Caused by commit 35a2af94c7ce ("sched/wait: Make the __wait_event*()
> > interface more friendly").
> > 
> > Since this was also in next-20131025, I applied the following merge fix
> > commit for today, please fix this in the tip tree.
> 
> FWIW I got confirmation on Oct 23 that this had been committed to the
> tip tree. So I guess it just wasn't pushed yet.

I merged the fix intoo the linux-next branch earlier today so it 
should be resolved soon.

Thanks,

	Ingo

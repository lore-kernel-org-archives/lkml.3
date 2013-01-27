Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3A0W5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:57:12 -0500
Received: from trent.utfs.org ([94.185.90.103]:39898 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab3A0W5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:57:10 -0500
Date: Sun, 27 Jan 2013 14:56:49 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org, benh@kernel.crashing.org
Subject: Re: 3.7-rc7: BUG: MAX_STACK_TRACE_ENTRIES too low!
In-Reply-To: <1358233164.15371.2.camel@ThinkPad-T5421.cn.ibm.com>
Message-ID: <alpine.DEB.2.01.1301271451390.7378@trent.utfs.org>
References: <alpine.DEB.2.01.1211271824120.7378@trent.utfs.org>  <alpine.DEB.2.01.1211271916160.7378@trent.utfs.org>  <1354092082.3054.19.camel@ThinkPad-T5421.cn.ibm.com>  <alpine.DEB.2.01.1301121241340.7378@trent.utfs.org>
 <1358233164.15371.2.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 at 14:59, Li Zhong wrote:
> FYI, it is already in the next of ppc tree 
> http://git.kernel.org/?p=linux/kernel/git/benh/powerpc.git;a=shortlog;h=refs/heads/next
> 
> I guess it would get into 3.9, at least. 

Hm, is there no chance to get this into 3.8? I've been running with this 
patch applied since 3.7-rc7 and it got rid of this 
"MAX_STACK_TRACE_ENTRIES too low" message. I've just upgraded to 3.8-rc5 
and it's still not in mainline :-\

Christian.

[0] http://lkml.indiana.edu/hypermail/linux/kernel/1211.3/01836.html

> > > ==============================================
> > > diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
> > > index 9499385..cadebfd 100644
> > > --- a/arch/powerpc/kernel/entry_32.S
> > > +++ b/arch/powerpc/kernel/entry_32.S
> > > @@ -439,6 +439,8 @@ ret_from_fork:
> > >  ret_from_kernel_thread:
> > >  	REST_NVGPRS(r1)
> > >  	bl	schedule_tail
> > > +	li	r3,0
> > > +	stw	r3,0(r1)
> > >  	mtlr	r14
> > >  	mr	r3,r15
> > >  	PPC440EP_ERR42
> > > ==============================================
> > > 
> > > > 
> > > > Christian.
> > > > 
> > > > > [40007.339487] [sched_delayed] sched: RT throttling activated
> > > > > [69731.388717] BUG: MAX_STACK_TRACE_ENTRIES too low!
> > > > > [69731.390371] turning off the locking correctness validator.
> > > > > [69731.391942] Call Trace:
> > > > > [69731.393525] [c9a61c10] [c0009064] show_stack+0x70/0x1bc (unreliable)
> > > > > [69731.395152] [c9a61c50] [c0077460] save_trace+0xfc/0x114
> > > > > [69731.396735] [c9a61c60] [c007be20] __lock_acquire+0x1568/0x19b8
> > > > > [69731.398296] [c9a61d00] [c007c2c0] lock_acquire+0x50/0x70
> > > > > [69731.399857] [c9a61d20] [c0550e28] _raw_spin_lock_irq+0x5c/0x78
> > > > > [69731.401419] [c9a61d40] [c054fb58] __schedule+0xd8/0x534
> > > > > [69731.402972] [c9a61da0] [c0550094] _cond_resched+0x50/0x68
> > > > > [69731.404527] [c9a61db0] [c0479908] dst_gc_task+0xbc/0x258
> > > > > [69731.406070] [c9a61e40] [c004eeb8] process_one_work+0x1f4/0x49c
> > > > > [69731.407585] [c9a61e80] [c004f644] worker_thread+0x14c/0x400
> > > > > [69731.409075] [c9a61eb0] [c0057634] kthread+0xbc/0xc0
> > > > > [69731.410521] [c9a61f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
> > > > > [...repeated 54 times...]
> > > > > 
> > > > > Anyone knows what this is about?
> > > > > 
> > > > > Thanks,
> > > > > Christian.
> > > > > 
> > > > > [0] http://lkml.indiana.edu/hypermail/linux/kernel/1211.0/03025.html

-- 
BOFH excuse #238:

You did wha... oh _dear_....

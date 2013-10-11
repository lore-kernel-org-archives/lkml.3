Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3JKGv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:51:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:47584 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab3JKGvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:51:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="409271475"
Date: Fri, 11 Oct 2013 14:51:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131011065149.GA16470@localhost>
References: <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
 <20131010142703.GI30970@tucnak.zalov.cz>
 <20131010151219.GC5167@gmail.com>
 <20131011043553.GA9015@localhost>
 <20131011054655.GA28077@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011054655.GA28077@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 07:46:55AM +0200, Ingo Molnar wrote:
> 
> * Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > > Indeed. Something like the updated version below?
> > > 
> > > [ I kept the asm_volatile_goto() naming to make sure the implicit volatile 
> > >   is visible. ]
> > 
> > Ingo, I applied this patch (as commit c015a7f0b746) on top of 
> > tip/sched/core
> > 
> >         3354781a2184 "sched/numa: Reflow task_numa_group() to avoid a compiler warning"
> > 
> > The below results show that it does fixed the many oops:
> 
> Thanks Fengguang!
> 
> I've added your Tested-by tag as well and have split the patch in two 
> parts: the upstream part with a -stable tag and the rmwcc.h part that goes 
> into the scheduler tree.
> 
> If there are no objections I will send a pull request for the upstream 
> part to Linus later today.

Ingo, sorry I'm still waiting for more results to arrive so as to confirm
whether the below "kernel_early_hang_without_any_printk_output" is a noise or
reliably caused by the gcc patch:

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| good_boots                                      | 9            | 8            |
| BUG:kernel_early_hang_without_any_printk_output | 0            | 1            |
+-------------------------------------------------+--------------+--------------+

Thanks,
Fengguang

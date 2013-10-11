Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3JKFrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:47:02 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:51484 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3JKFrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:47:00 -0400
Date: Fri, 11 Oct 2013 07:46:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131011054655.GA28077@gmail.com>
References: <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
 <20131010142703.GI30970@tucnak.zalov.cz>
 <20131010151219.GC5167@gmail.com>
 <20131011043553.GA9015@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011043553.GA9015@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fengguang Wu <fengguang.wu@intel.com> wrote:

> > Indeed. Something like the updated version below?
> > 
> > [ I kept the asm_volatile_goto() naming to make sure the implicit volatile 
> >   is visible. ]
> 
> Ingo, I applied this patch (as commit c015a7f0b746) on top of 
> tip/sched/core
> 
>         3354781a2184 "sched/numa: Reflow task_numa_group() to avoid a compiler warning"
> 
> The below results show that it does fixed the many oops:

Thanks Fengguang!

I've added your Tested-by tag as well and have split the patch in two 
parts: the upstream part with a -stable tag and the rmwcc.h part that goes 
into the scheduler tree.

If there are no objections I will send a pull request for the upstream 
part to Linus later today.

Thanks,

	Ingo

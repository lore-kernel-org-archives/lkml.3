Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaFVJUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 05:20:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:38125 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaFVJUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 05:20:51 -0400
Date: Sun, 22 Jun 2014 11:20:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V4 00/10] rtmutex: Code clarification and optimization
In-Reply-To: <20140622084507.GB13974@gmail.com>
Message-ID: <alpine.DEB.2.10.1406221118570.5170@nanos>
References: <20140611182944.108526809@linutronix.de> <20140622084507.GB13974@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2014, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Hopefully the last iteration of this.
> > 
> > I addressed all the review comments and added the following new ones:
> > 
> > 1/n: plug unlock race.
> >    
> > 	Patch was separately posted already in the safety of
> >    	*mutex_unlock() thread.
> > 
> > 2/n: Document and simplify the trylock path
> > 
> > 3/n: Document and simplify try_to_take_rtmutex()
> 
> JFYI, the Blackfin cross-build fails with:
> 
> /home/mingo/tip/kernel/locking/rtmutex.c: In function 'rt_mutex_adjust_prio_chain':
> /home/mingo/tip/kernel/locking/rtmutex.c:739: error: unable to find a register to spill in class 'CCREGS'
> /home/mingo/tip/kernel/locking/rtmutex.c:739: error: this is the insn:
> (insn 82 75 107 2 /home/mingo/tip/kernel/locking/rtmutex.c:487 (set 
> (reg:BI 186)
>         (eq:BI (reg/v/f:SI 9 P1 [orig:85 top_waiter ] [85])
>             (const_int 0 [0x0]))) 111 {compare_eq} (nil))
> /home/mingo/tip/kernel/locking/rtmutex.c:739: confused by earlier errors, bailing out

https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/x86_64-gcc-4.6.3-nolibc_bfin-uclinux.tar.xz

compiles that file nicely.

Thanks,

	tglx

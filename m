Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaFVIpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:45:21 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53690 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaFVIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:45:12 -0400
Date: Sun, 22 Jun 2014 10:45:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V4 00/10] rtmutex: Code clarification and optimization
Message-ID: <20140622084507.GB13974@gmail.com>
References: <20140611182944.108526809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611182944.108526809@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Hopefully the last iteration of this.
> 
> I addressed all the review comments and added the following new ones:
> 
> 1/n: plug unlock race.
>    
> 	Patch was separately posted already in the safety of
>    	*mutex_unlock() thread.
> 
> 2/n: Document and simplify the trylock path
> 
> 3/n: Document and simplify try_to_take_rtmutex()

JFYI, the Blackfin cross-build fails with:

/home/mingo/tip/kernel/locking/rtmutex.c: In function 'rt_mutex_adjust_prio_chain':
/home/mingo/tip/kernel/locking/rtmutex.c:739: error: unable to find a register to spill in class 'CCREGS'
/home/mingo/tip/kernel/locking/rtmutex.c:739: error: this is the insn:
(insn 82 75 107 2 /home/mingo/tip/kernel/locking/rtmutex.c:487 (set 
(reg:BI 186)
        (eq:BI (reg/v/f:SI 9 P1 [orig:85 top_waiter ] [85])
            (const_int 0 [0x0]))) 111 {compare_eq} (nil))
/home/mingo/tip/kernel/locking/rtmutex.c:739: confused by earlier errors, bailing out

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbaCTSgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:36:45 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:56047 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbaCTSgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	<20140319154705.GB8557@laptop.programming.kicks-ass.net>
	<20140319170829.GD8557@laptop.programming.kicks-ass.net>
	<20140320053350.GB30295@linux.vnet.ibm.com>
	<1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	<1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 20 Mar 2014 11:36:42 -0700
X-Google-Sender-Auth: fd4XxaTMSUo2DMztqtpwwP2vrDY
Message-ID: <CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 10:18 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Comparing with the patch I sent earlier this morning, looks equivalent,
> and fwiw, passes my initial qemu bootup, which is the first way of
> detecting anything stupid going on.
>
> So, Srikar, please try this patch out, as opposed to mine, you don't
> have to first revert the commit in question.

Ok, so it boots for me too, so hopefully it isn't totally broken.

However, since it's just closing a race, and since getting the counts
wrong should easily result in it *working* but always taking the slow
path (for example), I'd really like people to also verify that it
fixes the actual performance issue (ie assuming it fixes powerpc
behavior for Srikar, I'd like to get it double-checked that it also
avoids the spinlock in the common case). Because if the
increment/decrement pairings end up being wrong, we could have a
situation where the waiter count just ends up bogus, and it all works
from a correctness standpoint but not from the intended performance
optimization.

No way I can test that sanely on my single-socket machine. Davidlohr?

                  Linus

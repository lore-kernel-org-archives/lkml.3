Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3BZMPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:15:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:48082 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3BZMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:15:17 -0500
Date: Tue, 26 Feb 2013 13:15:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in
 irq_exit()
In-Reply-To: <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302261308550.22263@ionos>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com> <1361496971-16939-3-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.02.1302221528470.22263@ionos> <20130222150444.GD18149@somewhere.redhat.com> <alpine.LFD.2.02.1302221605520.22263@ionos>
 <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Linus Torvalds wrote:
> On Fri, Feb 22, 2013 at 7:06 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> I prefer to let you guys have the final word on this patch. Whether you
> >> apply it or not, I fear I'll never be entirely happy either way :)
> >> That's the sad fate of dealing with circular dependencies...
> >
> > plus the butt ugly softirq semantics or the lack thereof ...
> 
> The softirq semantics are perfectly fine. Don't blame softirq for the
> fact that irq_exit() has had shit-for-brains for a long time.
> 
> Just move the whole "invoke_softirq()" thing down to *after* the
> tick_nohz_irq_exit() stuff.

We can't move tick_nohz_irq_exit() before invoke_softirq() simply
because we need to take the timers into account for NOHZ and those can
change when the softirq code runs.

So no, we need an extra check after invoke_softirq() and the same is
true for RCU.

Thanks,

	tglx



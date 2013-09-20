Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3ITRaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:30:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:42892 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3ITRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:30:20 -0400
Date: Fri, 20 Sep 2013 19:30:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
In-Reply-To: <20130920162603.GA30381@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1309201926440.4089@ionos.tec.linutronix.de>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com> <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com> <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de> <20130920162603.GA30381@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Sep 2013, Frederic Weisbecker wrote:

> Now just for clarity, what do we then do with inline sofirq
> executions: on local_bh_enable() for example, or explicit calls to
> do_softirq() other than irq exit?  Should we keep the current switch
> to a different softirq stack? If we have a generic irq stack (used
> for both hard and soft) that is big enough, perhaps we can also
> switch to this generic irq stack for inline softirqs executions?
> After all there is no much point in keeping a separate stack for
> that: this result in cache misses if the inline softirq is
> interrupted by a hardirq, also inlined softirqs can't happen in
> hardirq, so there should be no much risk of overruns.

We can use the same irqstack for this because from the irqstack point
of view, thats the same as if softirqs get executed from
irq_exit().

Thanks,

	tglx

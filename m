Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3ITLMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:12:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3ITLMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:12:13 -0400
Date: Fri, 20 Sep 2013 13:11:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130920111151.GR12926@twins.programming.kicks-ass.net>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 01:03:17PM +0200, Thomas Gleixner wrote:
> On Thu, 19 Sep 2013, Linus Torvalds wrote:
> 
> > On Thu, Sep 19, 2013 at 2:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > >
> > > It fixes stacks overruns reported by Benjamin Herrenschmidt:
> > > http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
> > 
> > So I don't really dislike this patch-series, but isn't "irq_exit()"
> > (which calls the new softirq_on_stack()) already running in the
> > context of the irq stack? And it's run at the very end of the irq
> > processing, so the irq stack should be empty too at that point.
> 
> Right, but most of the implementations are braindamaged.
> 
>       irq_enter();
>       handle_irq_on_hardirq_stack();
>       irq_exit();

I was only just staring at i386 and found it did exactly that. It had to
jump through preempt_count hoops to make that work and obviously I
hadn't test-build the preempt patches on i386.

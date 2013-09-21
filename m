Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3IUA5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 20:57:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:33789 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab3IUA5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 20:57:11 -0400
Message-ID: <1379724942.22775.8.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 21 Sep 2013 10:55:42 +1000
In-Reply-To: <20130920111151.GR12926@twins.programming.kicks-ass.net>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920111151.GR12926@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-20 at 13:11 +0200, Peter Zijlstra wrote:
> On Fri, Sep 20, 2013 at 01:03:17PM +0200, Thomas Gleixner wrote:
> > On Thu, 19 Sep 2013, Linus Torvalds wrote:
> > 
> > > On Thu, Sep 19, 2013 at 2:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > >
> > > > It fixes stacks overruns reported by Benjamin Herrenschmidt:
> > > > http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
> > > 
> > > So I don't really dislike this patch-series, but isn't "irq_exit()"
> > > (which calls the new softirq_on_stack()) already running in the
> > > context of the irq stack? And it's run at the very end of the irq
> > > processing, so the irq stack should be empty too at that point.
> > 
> > Right, but most of the implementations are braindamaged.
> > 
> >       irq_enter();
> >       handle_irq_on_hardirq_stack();
> >       irq_exit();
> 
> I was only just staring at i386 and found it did exactly that. It had to
> jump through preempt_count hoops to make that work and obviously I
> hadn't test-build the preempt patches on i386.

Right and powerpc does the switch even later when calling the individual
handlers.

Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbbAXQZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:25:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:40723 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbbAXQZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:25:37 -0500
Date: Sat, 24 Jan 2015 17:25:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torvald Riegel <triegel@redhat.com>
cc: Darren Hart <dvhart@linux.intel.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Carlos O'Donell" <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>,
        Eric Dumazet <edumazet@google.com>,
        bill o gallmeister <bgallmeister@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>,
        Rich Felker <dalias@libc.org>
Subject: Re: futex(2) man page update help request
In-Reply-To: <1422104287.29655.13.camel@triegel.csb>
Message-ID: <alpine.DEB.2.11.1501241719550.5526@nanos>
References: <537346E5.4050407@gmail.com>  <CF98E3EF.90564%dvhart@linux.intel.com>  <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>  <5373D0CA.2050204@redhat.com>  <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> 
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>  <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>  <54B7D87C.3090901@gmail.com> <alpine.DEB.2.11.1501152313330.5526@nanos>  <54B92B71.2090509@gmail.com> <alpine.DEB.2.11.1501161618080.5526@nanos>
  <54B97A72.2050205@gmail.com>  <D0DEECA2.B7EAD%dvhart@linux.intel.com>  <1422037145.27573.0.camel@triegel.csb>  <alpine.DEB.2.11.1501241102450.5526@nanos> <1422104287.29655.13.camel@triegel.csb>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015, Torvald Riegel wrote:
> On Sat, 2015-01-24 at 11:05 +0100, Thomas Gleixner wrote:
> > On Fri, 23 Jan 2015, Torvald Riegel wrote:
> > 
> > > On Fri, 2015-01-16 at 16:46 -0800, Darren Hart wrote:
> > > > On 1/16/15, 12:54 PM, "Michael Kerrisk (man-pages)"
> > > > <mtk.manpages@gmail.com> wrote:
> > > > 
> > > > >Color me stupid, but I can't see this in futex_requeue(). Where is that
> > > > >check that is "independent of the requeue type (normal/pi)"?
> > > > >
> > > > >When I look through futex_requeue(), all the likely looking sources
> > > > >of EINVAL are governed by a check on the 'requeue_pi' argument.
> > > > 
> > > > 
> > > > Right, in the non-PI case, I believe there are valid use cases: move to
> > > > the back of the FIFO, for example (OK, maybe the only example?).
> > > 
> > > But we never guarantee a futex is a FIFO, or do we?  If we don't, then
> > > such a requeue could be implemented as a no-op by the kernel, which
> > > would sort of invalidate the use case.
> > > 
> > > (And I guess we don't want to guarantee FIFO behavior for futexes.)
> > 
> > The (current) behaviour is:
> > 
> >     real-time threads:   FIFO per priority level
> >     sched-other threads: FIFO independent of nice level
> > 
> > The wakeup is priority ordered. Highest priority level first.
> 
> OK.
> 
> But, just to be clear, do I correctly understand that you do not want to
> guarantee FIFO behavior in the specified futex semantics?  I think there
> are cases where being able to *rely* on FIFO (now and on all future
> kernels) would be helpful for users (e.g., on POSIX/C++11 condvars and I
> assume in other ordered-wakeup cases too) -- but at the same time, this
> would constrain future futex implementations.

It would be a constraint, but I don't think it would be a horrible
one. Though I have my doubts, that we can actually guarantee it under
all circumstances.

One thing comes to my mind right away: spurious wakeups. There is no
way that we can guarantee FIFO ordering in the context of those. And
we cannot prevent them either.

Thanks,

	tglx



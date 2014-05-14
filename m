Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaENXex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:34:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:48899 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaENXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:34:51 -0400
Date: Thu, 15 May 2014 01:34:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Carlos O'Donell" <carlos@redhat.com>
cc: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
In-Reply-To: <5373D0CA.2050204@redhat.com>
Message-ID: <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Carlos O'Donell wrote:

> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
> >> However, unless I'm sorely mistaken, the larger problem is that glibc
> >> removed the futex() call entirely, so these man pages don't describe
> > 
> > I don't think futex() ever was in glibc--that's by design, and
> > completely understandable: no user-space application would want to
> > directly use futex(). (BTW, I mispoke in my earlier mail when I said I
> > wanted documentation suitable for "writers of library functions" -- I
> > meant suitable for "writers of *C library*".)
> 
> I fully agree with Michael here.
> 
> The futex() syscall was never exposed to userspace specifically because
> it was an interface we did not want to support forever with a stable ABI.
> The futex() syscall is an implementation detail that is shared between
> the kernel and the writers of core runtimes for Linux.

Nonsense. 

If we change that interface (aside of adding functionality or some new
error return) it would break the world and some more, simply because
out of the blue glibc-2.xx would stop to work on linux-3.yy.

Aside of that the futex syscall is used as a bare interface without
any glibc interaction:

 - It's handy to implement user space wait queues

 - It's (ab)used in very interesting ways by data base apps

 - It's (ab)used by some Java monstrosities.

Nothing you care about and you really don't want to see the gory
details, but you have to accept that there is an universe which is
happy to deal with the raw syscalls instead of going through some ill
defined posix interfaces.

Thanks,

	tglx
 

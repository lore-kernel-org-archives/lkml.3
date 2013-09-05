Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3IEWT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:19:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:41532 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab3IEWTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:19:54 -0400
Message-ID: <1378419504.4321.194.camel@pasglop>
Subject: Re: [RFC PATCH 0/3] irq: Fix stack overflow due to softirq called
 on current stack
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@au1.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 06 Sep 2013 08:18:24 +1000
In-Reply-To: <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
References: <1378330796.4321.50.camel@pasglop>
	 <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 17:33 +0200, Frederic Weisbecker wrote:
> Hi,
> 
> This series is a proposition to fix the crash reported here: http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
> And it has the upside to also consolidate a bit the arch do_softirq overriden implementation.
> 
> Only tested in x86-64 for now.

Thanks. I'm off for a few days, Paul can you give that a spin ? My
understanding is that the crash was fairly reproduceable... which makes
me wonder what are the chances to get RH to pick that series up for
RHEL7...

Cheers,
Ben.

> Thanks.
> 
> Frederic Weisbecker (3):
>   irq: Consolidate do_softirq() arch overriden implementations
>   irq: Execute softirq on its own stack on irq exit
>   irq: Comment on the use of inline stack for ksoftirq
> 
>  arch/metag/kernel/irq.c    |   56 +++++++++++++++++------------------------
>  arch/parisc/kernel/irq.c   |   17 +-----------
>  arch/powerpc/kernel/irq.c  |   17 +-----------
>  arch/s390/kernel/irq.c     |   52 +++++++++++++++----------------------
>  arch/sh/kernel/irq.c       |   60 ++++++++++++++++++-------------------------
>  arch/sparc/kernel/irq_64.c |   31 +++++++---------------
>  arch/x86/kernel/irq_32.c   |   34 +++++++++----------------
>  arch/x86/kernel/irq_64.c   |   18 ++-----------
>  include/linux/interrupt.h  |   11 ++++++++
>  kernel/softirq.c           |   10 +++----
>  10 files changed, 112 insertions(+), 194 deletions(-)
> 



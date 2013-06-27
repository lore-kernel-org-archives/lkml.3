Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3F0ORZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:17:25 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57653 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3F0ORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:17:23 -0400
Date: Thu, 27 Jun 2013 16:17:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, konrad.wilk@oracle.com,
        catalin.marinas@arm.com, arnd@arndb.de, olof@lixom.net,
        linux@arm.linux.org.uk, Ian.Campbell@citrix.com, will.deacon@arm.com,
        marc.zyngier@arm.com, mingo@redhat.com
Subject: Re: [PATCH v6 2/5] kernel: missing include in cputime.c
Message-ID: <20130627141718.GA10056@gmail.com>
References: <alpine.DEB.2.02.1306271446570.4782@kaball.uk.xensource.com>
 <1372341272-12512-2-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130627141209.GB29209@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627141209.GB29209@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jun 27, 2013 at 02:54:29PM +0100, Stefano Stabellini wrote:
> > steal_account_process_tick calls paravirt_steal_clock, but paravirt.h is
> > currently missing amoung the included header files.
> > Add include asm/paravirt.h ifdef CONFIG_PARAVIRT.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: mingo@redhat.com
> > CC: peterz@infradead.org
> > 
> > Changes in v5:
> > - add ifdef CONFIG_PARAVIRT.
> > ---
> >  kernel/sched/cputime.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> > index cc2dc3ee..317a578 100644
> > --- a/kernel/sched/cputime.c
> > +++ b/kernel/sched/cputime.c
> > @@ -5,7 +5,9 @@
> >  #include <linux/static_key.h>
> >  #include <linux/context_tracking.h>
> >  #include "sched.h"
> > -
> > +#ifdef CONFIG_PARAVIRT
> > +#include <asm/paravirt.h>
> > +#endif
> 
> Why isn't that CONFIG stuff inside the header instead of around it?

Indeed.

Once that is fixed then the #ifdef around asm/paravirt.h in 
kernel/sched/core.c could be removed as well.

Thanks,

	Ingo

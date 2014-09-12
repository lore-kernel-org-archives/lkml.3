Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaILJxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaILJxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:53:08 -0400
Date: Fri, 12 Sep 2014 10:50:21 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: peterz@infradead.org, dzickus@redhat.com, jcastillo@redhat.com,
        riel@redhat.com, x86@kernel.org, akpm@linux-foundation.org,
        minchan@kernel.org, bmr@redhat.com, prarit@redhat.com, oleg@redhat.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mingo@redhat.com, aneesh.kumar@linux.vnet.ibm.com, akpm@google.com,
        jgh@redhat.com, linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de
Subject: Re: [PATCH v3 3/3] sched: BUG when stack end location is over written
Message-ID: <20140912095021.GE1873@atomlin.usersys.redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-4-git-send-email-atomlin@redhat.com>
 <1410501891.17540.6.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410501891.17540.6.camel@concordia>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 04:04:51PM +1000, Michael Ellerman wrote:
> On Thu, 2014-09-11 at 16:41 +0100, Aaron Tomlin wrote:
> > Currently in the event of a stack overrun a call to schedule()
> > does not check for this type of corruption. This corruption is
> > often silent and can go unnoticed. However once the corrupted
> > region is examined at a later stage, the outcome is undefined
> > and often results in a sporadic page fault which cannot be
> > handled.
> > 
> > This patch checks for a stack overrun and takes appropriate
> > action since the damage is already done, there is no point
> > in continuing.
> > 
> > Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> > ---
> >  kernel/sched/core.c |  3 +++
> >  lib/Kconfig.debug   | 12 ++++++++++++
> >  2 files changed, 15 insertions(+)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index ec1a286..0b70b73 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2660,6 +2660,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
> >   */
> >  static inline void schedule_debug(struct task_struct *prev)
> >  {
> > +#ifdef CONFIG_SCHED_STACK_END_CHECK
> > +	BUG_ON(unlikely(task_stack_end_corrupted(prev)))
> > +#endif
> 
> Spot the bug? Please compile your code in future.

Oops! Sorry about that.

-- 
Aaron Tomlin

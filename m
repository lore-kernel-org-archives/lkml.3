Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbaKCH5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:57:12 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:57014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaKCH5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:57:11 -0500
Date: Mon, 3 Nov 2014 08:56:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peter@hurleysoftware.com,
        rjw@rjwysocki.net, torvalds@linux-foundation.org, tglx@linutronix.de,
        eparis@redhat.com, umgwanakikbuti@gmail.com, marcel@holtmann.org,
        ebiederm@xmission.com, davem@davemloft.net, fengguang.wu@intel.com
Subject: Re: [PATCH 7/7] sched: Use WARN_ONCE for the might_sleep()
 TASK_RUNNING test
Message-ID: <20141103075657.GU10501@worktop.programming.kicks-ass.net>
References: <20141031111037.936236584@infradead.org>
 <20141031111549.857381983@infradead.org>
 <20141031224237.GA29704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031224237.GA29704@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:42:37PM +0100, Oleg Nesterov wrote:
> On 10/31, Peter Zijlstra wrote:
> >
> > In some cases this can trigger a true flood of output.
> >
> > Requested-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  kernel/sched/core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -7301,7 +7301,7 @@ void __might_sleep(const char *file, int
> >  	 * since we will exit with TASK_RUNNING make sure we enter with it,
> >  	 * otherwise we will destroy state.
> >  	 */
> > -	if (WARN(current->state != TASK_RUNNING,
> > +	if (WARN_ONCE(current->state != TASK_RUNNING,
> 
> Agreed, but sorry for off-topic, can't resist.
> 
> Sometimes I hate WARN_ONCE() because you can't reproduce the problem
> once again without reboot.

Yes, and the fact that you can only see the first fail, even if more are
present.

> Perhaps WARN_ON_RATELIMIT() should be used more often (not sure about
> this particular case). Or, perhaps, we can add a special section for
> these "__warned" variables and add, say, sysctl which clears that
> section ?

Yeah, maybe, /debug/warn_once/file/line/enable or whatnot. For now I'll
continue removing ONCEs whenever I feel like it though ;-)

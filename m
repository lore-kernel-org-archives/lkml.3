Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaLWKxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:53:12 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37834 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaLWKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:53:08 -0500
Date: Tue, 23 Dec 2014 11:52:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net,
        mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com,
        atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org,
        serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com,
        vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org,
        yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com,
        axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing a
 timeslice
Message-ID: <20141223105251.GB22203@gmail.com>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com>
 <20141218222846.GH30905@twins.programming.kicks-ass.net>
 <54935842.5020507@oracle.com>
 <alpine.DEB.2.11.1412182355020.17382@nanos>
 <54936562.5070502@oracle.com>
 <alpine.DEB.2.11.1412190045590.17382@nanos>
 <54949BF0.8030403@oracle.com>
 <alpine.DEB.2.11.1412200041220.17382@nanos>
 <5498498B.90703@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5498498B.90703@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Khalid Aziz <khalid.aziz@oracle.com> wrote:

> On 12/19/2014 04:57 PM, Thomas Gleixner wrote:
> >On Fri, 19 Dec 2014, Khalid Aziz wrote:
> >>The queuing problem caused by a task taking a contended lock just before its
> >>current timeslice is up which userspace app wouldn't know about, is a real
> >>problem nevertheless.
> >
> >We know that already.
> >
> >>My patch attempts to avoid the contention in the first
> >>place. futex with adaptive spinning is a post-contention solution that tries
> >>to minimize the cost of contention but does nothing to avoid the contention.
> >
> >I never said that adaptive spinning can solve that problem.
> >
> >If you would have carefuly read what I wrote, you might have noticed,
> >that I said:
> >
> >      a proper futex like spin mechanism
> >
> >Can you spot the subtle difference between that phrase and 'futex with
> >adaptive spinning'?
> >
> >>Solving this problem using futex can help only if the userspace lock uses
> >>futex.
> >
> >A really fundamentally new and earth shattering insight.
> >
> >If you would spend your time to actually digest what maintainers are
> >telling you, we might make progress on that matter.
> >
> >But you prefer to spend your time by repeating yourself and providing
> >completely useless information.
> >
> >What you are missing completely here is that neither me nor other
> >maintainers involved care about how you spend your time. But we very
> >much care about the time WE waste with your behaviour.
> 
> I am sorry that you feel the need to continue to resort to 
> personal attacks [...]

Thomas did not attack your person AFAICS - he criticised your 
arguments with increasing volume, because he did not see you 
respond to his arguments in substance.

> even after I made it clear in my last response that I was not 
> going to pursue this patch. There is no possibility of a 
> productive discussion of a solution at this point. [...]

I think there is very much a possibility of a productive 
discussion:

> [...] I hope someone else can find a solution you find 
> acceptable.

to implement what Thomas suggested in the discussion: a proper 
futex like spin mechanism? That looks like a totally acceptable 
solution to me, without the disadvantages of your proposed 
solution.

Thanks,

	Ingo

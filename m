Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab3B1JSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:18:45 -0500
Received: from mout.gmx.net ([212.227.15.18]:63366 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3B1JSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:18:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1895XcWcHs9PQqmTOYa5MoVl1TeNJiD3NGwdINPFK
	t9HtGPlHF/fTwz
Message-ID: <1362043112.4460.163.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 28 Feb 2013 10:18:32 +0100
In-Reply-To: <512F1A15.2000609@linux.vnet.ibm.com>
References: <512EFB4B.5040204@linux.vnet.ibm.com>
	 <1362035917.4460.105.camel@marge.simpson.net>
	 <512F09D4.1020307@linux.vnet.ibm.com>
	 <1362038652.4460.124.camel@marge.simpson.net>
	 <512F11E6.8060807@linux.vnet.ibm.com>
	 <1362039862.4460.132.camel@marge.simpson.net>
	 <512F1A15.2000609@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 16:49 +0800, Michael Wang wrote: 
> On 02/28/2013 04:24 PM, Mike Galbraith wrote:
> > On Thu, 2013-02-28 at 16:14 +0800, Michael Wang wrote: 
> >> On 02/28/2013 04:04 PM, Mike Galbraith wrote:
> > 
> >>> It would be nice if it _were_ a promise, but it is not, it's a hint.
> >>
> >> Bad to know :(
> >>
> >> Should we fix it or this is by designed? The comments after WF_SYNC
> >> cheated me...
> > 
> > You can't fix it, because it's not busted.  You can say "Ok guys, I'm
> > off for a nap RSN" all you want, but that won't guarantee that nobody
> > pokes you, and hands you something more useful to do than snoozing.
> 
> So sync still means current is going to sleep, what you concerned is
> this promise will be easily broken by other waker, correct?

That makes it a lie, and it can already have been one with no help.
Just because you wake one sync does not mean you're not going to find
another to wake.  Smart tasks are taught to look before they leap.

> Hmm.. may be you are right, if 'perf bench sched pipe' is not the one we
> should care, I have no reason to add this logical currently.

Well, there is reason to identify task relationships methinks, you just
can't rely on the fact that you're alone on the rq at the moment, and
doing a sync wakeup to bind tasks.  They _will_ lie to you :)

> I will remove this plus branch, unless I found other benchmark could
> benefit a lot from it.
> 
> Besides this, how do you think about this idea?

I like the idea of filtering true buddy pairs, and automagically
detecting the point when 1:N wants spreading rather a lot (fwtw).  I'll
look closer at your method, but when it comes to implementation
opinions, the only one I trust comes out of a box in front of me.

I'm somewhat.. "taste challenged", Peter and Ingo have some though :)

-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222Ab3ECGOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:14:46 -0400
Received: from mout.gmx.net ([212.227.15.18]:58584 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760548Ab3ECGOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:14:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/th0dUDsrtIygF4JH53Od6K95JP630+8YYbCxrGo
	sndvBLWauHWpPH
Message-ID: <1367561676.5907.50.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wake-affine throttle
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Fri, 03 May 2013 08:14:36 +0200
In-Reply-To: <518351CF.6090500@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
	 <51833302.6090208@linux.vnet.ibm.com>
	 <1367557300.5907.30.camel@marge.simpson.net>
	 <518351CF.6090500@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 13:57 +0800, Michael Wang wrote: 
> Hi, Mike
> 
> Thanks for your reply.
> 
> On 05/03/2013 01:01 PM, Mike Galbraith wrote:
> [snip]
> >>
> >> If this approach caused any concerns, please let me know ;-)
> > 
> > I wonder if throttling on failure is the way to go.  Note the minimal
> > gain for pgbench with the default 1ms throttle interval.  It's not very
> > effective out of the box for the load type it's targeted to help, and
> > people generally don't twiddle scheduler knobs.  If you throttle on
> > success, you directly restrict migration frequency without that being
> > affected by what other tasks are doing.  Seems that would be a bit more
> > effective.
> 
> This is a good timing to make some conclusion for this problem ;-)
> 
> Let's suppose when wake-affine failed, next time slice got a higher
> failure chance, then whether throttle on failure could be the question like:
> 
> 	throttle interval should cover more failure timing
> 	or more success timing?
> 
> Obviously we should cover more failure timing, since it's just wasting
> cycle and change nothing.
> 
> However, I used to concern about the damage of succeed wake-affine at
> that rapid, sure it also contain the benefit, but which one is bigger?
> 
> Now if we look at the RFC version which throttle on succeed, for
> pgbench, we could find that the default 1ms benefit is < 5%, while the
> current version which throttle on failure bring 7% at most.

OK, so scratch that thought.  Would still be good to find a dirt simple
dirt cheap way to increase effectiveness a bit, and eliminate the knob.
Until a better idea comes along, this helps pgbench some, and will also
help fast movers ala tbench on AMD, where select_idle_sibling() wasn't
particularly wonderful per my measurements.

-Mike


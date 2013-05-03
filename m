Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3ECFBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:01:53 -0400
Received: from mout.gmx.net ([212.227.15.15]:63881 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3ECFBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:01:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Xm04wgI2Xv9L8MagJZQSlTW527WrkMx2U8/EzAS
	+3XsuI76I0KIb7
Message-ID: <1367557300.5907.30.camel@marge.simpson.net>
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
Date: Fri, 03 May 2013 07:01:40 +0200
In-Reply-To: <51833302.6090208@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
	 <51833302.6090208@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 11:46 +0800, Michael Wang wrote: 
> On 04/10/2013 11:30 AM, Michael Wang wrote:
> 
> Now long time has been passed since the first version, I'd like to 
> do some summary about current states:
> 
> On a 12 cpu box with tip 3.9.0-rc7, test show that:
> 
> 1. remove wake-affine stuff cause regression on hackbench (could be 15%).
> 2. reserve wake-affine stuff cause regression on pgbench (could be 45%).
> 
> And since neither remove or reserve is acceptable, this patch introduced a
> knob to throttle wake-affine stuff.
> 
> By turning the knob, we could benefit both hackbench and pgbench, or sacrifice
> one to significantly benefit another.
> 
> All similar workload which prefer or hate wake-affine behaviour could
> been cared.
> 
> If this approach caused any concerns, please let me know ;-)

I wonder if throttling on failure is the way to go.  Note the minimal
gain for pgbench with the default 1ms throttle interval.  It's not very
effective out of the box for the load type it's targeted to help, and
people generally don't twiddle scheduler knobs.  If you throttle on
success, you directly restrict migration frequency without that being
affected by what other tasks are doing.  Seems that would be a bit more
effective.

(I still like the wakeup buddy thing, it's more effective because it
adds and uses knowledge, though without the knob, cache domain size.
Peter is right about the interrupt wakeups though, that could very
easily cause regressions, dirt simple throttle is much safer).

-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3EBHK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:10:57 -0400
Received: from mout.gmx.net ([212.227.15.18]:64016 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3EBHKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:10:55 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/bUj8WQFHb1hoxowemZ108G11t0uPtL+93wALPSg
	LfGtMMfTozE259
Message-ID: <1367478643.5808.71.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wake-affine throttle
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 02 May 2013 09:10:43 +0200
In-Reply-To: <5181FE1B.6010508@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
	 <1366626208.2721.12.camel@laptop> <5181FE1B.6010508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 13:48 +0800, Michael Wang wrote: 
> On 04/22/2013 06:23 PM, Peter Zijlstra wrote:
> > 
> > OK,.. Ingo said that pipe-test was the original motivation for
> > wake_affine() and since that's currently broken to pieces due to
> > select_idle_sibling() is there still a benefit to having it at all?
> > 
> > Can anybody find any significant regression when simply killing
> > wake_affine()?
> 
> I got the proof that we could not simply killing the stuff (finally...).
> 
> It's the hackbench with a high pipe number, still on 12 cpu box, the
> result of "./hackbench 48 process 10000" is:
> 
> 	Running with 48*40 (== 1920) tasks.
> 	Time: 33.372
> 
> After killed the wake-affine, the result is:
> 
> 	Running with 48*40 (== 1920) tasks.
> 	Time: 38.205
> 
> About 14.48% performance dropped without wake-affine, I guess it was
> caused by the missing spread behaviour.
> 
> I've done the test for several times, also compared with the throttle
> approach, default 1ms interval still works very well, the regression on
> hackbench start to exceed 2% when interval become 100ms on my box, but
> please note the pgbench already gain a lot benefit at that time.
> 
> I think now we could say that wake-affine is useful, and we could not
> simply kill it.

Oh, it's definitely useful.  Communicating tasks deeply resent talking
over interconnects (advanced tin cans and string).  My little Q6600 box
can even be described as dinky-numa given enough imagination.. place
communicating tasks on different core2 "nodes" if you will, throughput
falls through the floor.  Shared L2 is quick like bunny, dram ain't.

-Mike


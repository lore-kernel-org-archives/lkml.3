Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3FCGFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:05:31 -0400
Received: from mout.gmx.net ([212.227.15.15]:57483 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab3FCGFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:05:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wGNJBNNWw1O3O2izXjRBRKJdmksdOM2uGMA11A+
	d/iiYvo/JamXd1
Message-ID: <1370239514.5988.117.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 03 Jun 2013 08:05:14 +0200
In-Reply-To: <51AC2EA2.7030106@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51ABFF6A.60206@linux.vnet.ibm.com>
	 <1370228941.5988.66.camel@marge.simpson.net>
	 <51AC0CD4.9070302@linux.vnet.ibm.com>
	 <1370231597.5988.79.camel@marge.simpson.net>
	 <51AC2121.1060903@linux.vnet.ibm.com>
	 <1370236944.5988.108.camel@marge.simpson.net>
	 <51AC2EA2.7030106@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 13:50 +0800, Michael Wang wrote: 
> On 06/03/2013 01:22 PM, Mike Galbraith wrote:
> [snip]
> >>
> >> I agree that this idea, in other work, 'stop wake-affine when current is
> >> busy with wakeup' may miss the chance to bring benefit, although I could
> >> not find such workload, but I can't do promise...
> > 
> > Someday we'll find the perfect balance... likely the day before the sun
> > turns into a red giant and melts the earth.
> 
> Won't take so long ;-)
> 
> I would like to stop the regression on pgbench firstly, as PeterZ
> mentioned, if someone reported other regressions, we will know what is
> missing, if fix is possible, we fix it, if cost is too high, then I say
> we ignore the illegal income, after all, we could not benefit one in the
> cost of sacrifice others...
> 
> I'd like to fix the problem ASAP, it's really a big, urgent problem on
> my point of view, but doesn't win enough attentions as I thought it will...

I fully agree that it's a problem, but not that it's a regression.  The
"we became too buddy-centric" problem has existed for a long time, it's
just that pgbench in 1:N mode shows us how much that pull pull pull can
cost us in scalability.

A much more interesting pgbench test (imho) would be with one server per
socket.  1 server (mother of all work) driving a multi-socket sized load
is just silly, can't possibly scale, so it's important that improving
1:N pgbench (we can, and need to) doesn't harm sane loads.

-Mike


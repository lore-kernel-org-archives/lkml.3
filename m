Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab3CGJnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:43:50 -0500
Received: from mout.gmx.net ([212.227.17.22]:50710 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab3CGJnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:43:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/lI+cEJHLlfzkwdN2MD7+xHTwnQwXfnfwgC9QGTb
	Ar/itjc14FrqIq
Message-ID: <1362649419.4652.12.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 07 Mar 2013 10:43:39 +0100
In-Reply-To: <1362645372.2606.11.camel@laptop>
References: <5136EB06.2050905@linux.vnet.ibm.com>
	 <1362645372.2606.11.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 09:36 +0100, Peter Zijlstra wrote: 
> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
> 
> > wake_affine() stuff is trying to bind related tasks closely, but it doesn't
> > work well according to the test on 'perf bench sched pipe' (thanks to Peter).
> 
> so sched-pipe is a poor benchmark for this.. 
> 
> Ideally we'd write a new benchmark that has some actual data footprint
> and we'd measure the cost of tasks being apart on the various cache
> metrics and see what affine wakeup does for it.
> 
> Before doing something like what you're proposing, I'd have a hard look
> at WF_SYNC, it is possible we should disable/fix select_idle_sibling
> for sync wakeups.

If nobody beats me to it, I'm going to try tracking shortest round trip
to idle, and use a multiple of that to shut select_idle_sibling() down.
If avg_idle approaches round trip time, there's no win to be had, we're
just wasting cycles.

-Mike


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3BVOmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:42:32 -0500
Received: from mout.gmx.net ([212.227.15.18]:61868 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab3BVOma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:42:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19IG1ofwwxIa02/6VpfavlZhDUUPgh3CmLuVA0ZVJ
	m2lhW3iLDCEdwx
Message-ID: <1361544142.1340.47.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 15:42:22 +0100
In-Reply-To: <1361543459.1340.43.camel@marge.simpson.net>
References: <20130220104958.GA9152@gmail.com>
	 <5125A7C8.8020308@linux.vnet.ibm.com> <1361442055.26780.3.camel@laptop>
	 <5126D9E0.7040108@linux.vnet.ibm.com> <1361522197.26780.39.camel@laptop>
	 <1361526022.5817.115.camel@marge.simpson.net>
	 <20130222095416.GA4450@gmail.com>
	 <1361527288.5817.121.camel@marge.simpson.net>
	 <20130222121123.GA6473@gmail.com>
	 <1361536534.1340.12.camel@marge.simpson.net>
	 <20130222130647.GA6946@gmail.com>
	 <1361543459.1340.43.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 15:30 +0100, Mike Galbraith wrote: 
> On Fri, 2013-02-22 at 14:06 +0100, Ingo Molnar wrote: 

> > I think it might be better to measure the scheduling rate all 
> > the time, and save the _shortest_ cross-cpu-wakeup and 
> > same-cpu-wakeup latencies (since bootup) as a reference number. 
> > 
> > We might be able to pull this off pretty cheaply as the 
> > scheduler clock is running all the time and we have all the 
> > timestamps needed.
> 
> Yeah, that might work.  We have some quick kthreads, so saving ctx
> distance may get close enough to scheduler cost to be good enough.

Or better, shortest idle to idle, that would include the current (bad)
nohz cost, and automatically shrink away when that cost shrinks.

-Mike


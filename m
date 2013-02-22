Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3BVObN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:31:13 -0500
Received: from mout.gmx.net ([212.227.15.18]:60934 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756863Ab3BVObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:31:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19PXIV6kVJPHE9y+78ey2yLbtWQWSyWOTgMSc08SH
	jXb6K0zaXFgkvW
Message-ID: <1361543459.1340.43.camel@marge.simpson.net>
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
Date: Fri, 22 Feb 2013 15:30:59 +0100
In-Reply-To: <20130222130647.GA6946@gmail.com>
References: <20130220104958.GA9152@gmail.com>
	 <5125A7C8.8020308@linux.vnet.ibm.com> <1361442055.26780.3.camel@laptop>
	 <5126D9E0.7040108@linux.vnet.ibm.com> <1361522197.26780.39.camel@laptop>
	 <1361526022.5817.115.camel@marge.simpson.net>
	 <20130222095416.GA4450@gmail.com>
	 <1361527288.5817.121.camel@marge.simpson.net>
	 <20130222121123.GA6473@gmail.com>
	 <1361536534.1340.12.camel@marge.simpson.net>
	 <20130222130647.GA6946@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 14:06 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > > No, that's too high, you loose too much of the pretty 
> > > > face. [...]
> > > 
> > > Then a logical proportion of it - such as half of it?
> > 
> > Hm.  Better would maybe be a quick boot time benchmark, and 
> > use some multiple of your cross core pipe ping-pong time?  
> > That we know is a complete waste of cycles, because almost all 
> > cycles are scheduler cycles with no other work to be done, 
> > making firing up another scheduler rather pointless.  If we're 
> > approaching that rate, we're approaching bad idea.
> 
> Well, one problem with such dynamic boot time measurements is 
> that it introduces a certain amount of uncertainty that persists 
> for the whole lifetime of the booted up box - and it also sucks 
> in any sort of non-deterministic execution environment, such as 
> virtualized systems.

Ok, bad idea.

> I think it might be better to measure the scheduling rate all 
> the time, and save the _shortest_ cross-cpu-wakeup and 
> same-cpu-wakeup latencies (since bootup) as a reference number. 
> 
> We might be able to pull this off pretty cheaply as the 
> scheduler clock is running all the time and we have all the 
> timestamps needed.

Yeah, that might work.  We have some quick kthreads, so saving ctx
distance may get close enough to scheduler cost to be good enough.

> Pretty quickly after bootup this 'shortest latency' would settle 
> down to a very system specific (and pretty accurate) value.
> 
> [ One downside would be an increased sensitivity to the accuracy
>   and monotonicity of the scheduler clock - but that's something 
>   we want to improve on anyway - and 'worst case' we get too 
>   short latencies and we are where we are today. So it can only 
>   improve the situation IMO. ]
> 
> Would you be interested in trying to hack on an auto-tuning 
> feature like this?

Yeah, should be easy, but rainy day has to happen so I have time to
measure twiddle measure measure <curse> tweak.. ;-)

-Mike


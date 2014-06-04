Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaFDJoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:44:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44545 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751340AbaFDJox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:44:53 -0400
Date: Wed, 4 Jun 2014 10:44:47 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140604094447.GI29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
 <20140604080809.GK30445@twins.programming.kicks-ass.net>
 <20140604085542.GH29593@e103034-lin>
 <20140604092313.GB11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604092313.GB11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:23:13AM +0100, Peter Zijlstra wrote:
> > f you had five tasks on one cpu that each have a 25% requirement you can
> > get individual task runnable_avgs of up to 100% (cpu unweighted
> > runnable_load_avg can get up 500%, I think), but the task running_avgs
> > would be 20% each (total of 100%). 
> 
> Yeah, more or less so indeed. I had not considered the queueing effects
> on runnable_avg yesterday, so good that that got raised.
> 
> That does indeed invalidate my: runnable - running := extra cpu required
> thing. It ends up being the extra cpu required for 0 latency but gobs of
> idle time, which is something else entirely.

Agreed, but I think it is still a useful estimate of the required
compute capacity. If there is a significant difference between runnable
and running on a cpu, the current mix of tasks is not good for latency.
However, we need to treat it as a worst case estimate and not necessarily
try to move exactly runnable-running worth of tasks to another cpu.

So far I haven't been able to come up with something better.

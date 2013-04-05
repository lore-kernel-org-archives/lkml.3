Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161268Ab3DECGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 22:06:22 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48149 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161134Ab3DECGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 22:06:21 -0400
X-AuditID: 9c930179-b7b2aae000000518-80-515e319b8edb
Date: Fri, 5 Apr 2013 11:06:43 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
Message-ID: <20130405020643.GC13624@lge.com>
References: <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
 <51553EF5.90702@linux.vnet.ibm.com>
 <20130401040820.GA12015@lge.com>
 <5159320C.4050903@linux.vnet.ibm.com>
 <20130402022556.GD16699@lge.com>
 <515A64BB.5050005@linux.vnet.ibm.com>
 <20130402092647.GE16699@lge.com>
 <515B163B.8050509@linux.vnet.ibm.com>
 <20130404004231.GA10683@lge.com>
 <515D2240.9060501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515D2240.9060501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Preeti.

On Thu, Apr 04, 2013 at 12:18:32PM +0530, Preeti U Murthy wrote:
> Hi Joonsoo,
> 
> On 04/04/2013 06:12 AM, Joonsoo Kim wrote:
> > Hello, Preeti.
> 
> > 
> > So, how about extending a sched_period with rq->nr_running, instead of
> > cfs_rq->nr_running? It is my quick thought and I think that we can ensure
> > to run atleast once in this extending sched_period.
> 
> Yeah this seems to be correct.This would ensure sched_min_granularity
> also. So then in the scenarion where there are 2 tgs in a runqueue with
> 10 tasks each,when we calculate the sched_slice of any task,the
> __sched_period() would return 4*20 = 80ms.
> 
> The sched_slice of each of the task would be 80/20 = 4ms. But what about
> the sched_slice of each task group? How would that be calculated then?

Ah... Okay.
I will think more deeply about this issue.

> 
> Let us take the above example and walk through this problem.This would
> probably help us spot the issues involved with this.
> 
> > And, do we leave a problem if we cannot guaranteed atleast once property?
> 
> This would depend on the results of the benchmarks with the changes.I am
> unable to comment on this off the top of my head.

Okay. :)

Thanks for your kind review!!

> 
> Thank you
> 
> Regards
> Preeti U Murthy
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

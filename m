Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab3DDGu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:50:59 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51663 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3DDGu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:50:58 -0400
Message-ID: <515D2240.9060501@linux.vnet.ibm.com>
Date: Thu, 04 Apr 2013 12:18:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 4/5] sched: don't consider upper se in sched_slice()
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com> <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com> <51553EF5.90702@linux.vnet.ibm.com> <20130401040820.GA12015@lge.com> <5159320C.4050903@linux.vnet.ibm.com> <20130402022556.GD16699@lge.com> <515A64BB.5050005@linux.vnet.ibm.com> <20130402092647.GE16699@lge.com> <515B163B.8050509@linux.vnet.ibm.com> <20130404004231.GA10683@lge.com>
In-Reply-To: <20130404004231.GA10683@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 13040406-5490-0000-0000-00000338FF21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 04/04/2013 06:12 AM, Joonsoo Kim wrote:
> Hello, Preeti.

> 
> So, how about extending a sched_period with rq->nr_running, instead of
> cfs_rq->nr_running? It is my quick thought and I think that we can ensure
> to run atleast once in this extending sched_period.

Yeah this seems to be correct.This would ensure sched_min_granularity
also. So then in the scenarion where there are 2 tgs in a runqueue with
10 tasks each,when we calculate the sched_slice of any task,the
__sched_period() would return 4*20 = 80ms.

The sched_slice of each of the task would be 80/20 = 4ms. But what about
the sched_slice of each task group? How would that be calculated then?

Let us take the above example and walk through this problem.This would
probably help us spot the issues involved with this.

> And, do we leave a problem if we cannot guaranteed atleast once property?

This would depend on the results of the benchmarks with the changes.I am
unable to comment on this off the top of my head.

Thank you

Regards
Preeti U Murthy





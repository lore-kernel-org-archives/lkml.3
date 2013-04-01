Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3DAHJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:09:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54246 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3DAHI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:08:59 -0400
Message-ID: <5159320C.4050903@linux.vnet.ibm.com>
Date: Mon, 01 Apr 2013 12:36:52 +0530
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
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com> <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com> <51553EF5.90702@linux.vnet.ibm.com> <20130401040820.GA12015@lge.com>
In-Reply-To: <20130401040820.GA12015@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 13040107-0260-0000-0000-000002BEC9BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 04/01/2013 09:38 AM, Joonsoo Kim wrote:
> Hello, Preeti.
> 

>>
>> Ideally the children's cpu share must add upto the parent's share.
>>
> 
> I don't think so.
> 
> We should schedule out the parent tg if 5ms is over. As we do so, we can
> fairly distribute time slice to every tg within short term. If we add
> the children's cpu share upto the parent's, the parent tg may have
> large time slice, so it cannot be preempted easily. There may be a latency
> problem if there are many tgs.

In the case where the #running < sched_nr_latency, the children's
sched_slices add up to the parent's.

A rq with two tgs,each with 3 tasks.

Each of these tasks have a sched slice of
[(sysctl_sched_latency / 3) / 2] as of the present implementation.

The sum of the above sched_slice of all tasks of a tg will lead to the
sched_slice of its parent: sysctl_sched_latency / 2

This breaks when the nr_running on each tg > sched_nr_latency. However I
don't know if this is a good thing or a bad thing.

Regards
Preeti U Murthy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3HEEZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:25:01 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:57890 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3HEEZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:25:00 -0400
Message-ID: <51FF2884.4000802@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 09:52:28 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: =?UTF-8?B?6rmA7KSA7IiY?= <iamjoonsoo.kim@lge.com>,
        "'Ingo Molnar'" <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "'Mike Galbraith'" <efault@gmx.de>, "'Paul Turner'" <pjt@google.com>,
        "'Alex Shi'" <alex.shi@intel.com>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Morten Rasmussen'" <morten.rasmussen@arm.com>,
        "'Namhyung Kim'" <namhyung@kernel.org>,
        "'Joonsoo Kim'" <js1304@gmail.com>
Subject: Re: [PATCH v2 2/3] sched: factor out code to should_we_balance()
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com> <1375408223-10934-3-git-send-email-iamjoonsoo.kim@lge.com> <51FB341B.7060104@linux.vnet.ibm.com> <001601ce8f5f$7cbe1460$763a3d20$@lge.com> <51FB7B36.8030909@linux.vnet.ibm.com> <20130802103247.GL27162@twins.programming.kicks-ass.net>
In-Reply-To: <20130802103247.GL27162@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080504-8256-0000-0000-000008A71DE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 04:02 PM, Peter Zijlstra wrote:
> On Fri, Aug 02, 2013 at 02:56:14PM +0530, Preeti U Murthy wrote:
>>>> You need to iterate over all the groups of the sched domain env->sd and
>>>> not just the first group of env->sd like you are doing above. This is to
>>>
>>> I don't think so.
>>> IIRC, env->sd->groups always means local group,
>>> so we don't need to find our group by iterating over all the groups.
>>
>> Take a look at update_sd_lb_stats(). That should clarify this. There is
>> an exclusive
>> local_group check there.
>>
>> sd->groups points to the first group in the list of groups under this sd.
> 
> Take a look at: 88b8dac0a
> 
Ah ok! Thanks for this pointer.

Apologies for having overlooked the fact that the sd->groups always
points to the group to which the balance_cpu belongs. And subsequent
dst_cpus for retries of load balancing also belong to the same group as
the balance_cpu.

This patch thus looks fine to me.

Regards
Preeti U Murthy


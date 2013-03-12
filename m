Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3CLGAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:00:42 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38781 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3CLGAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:00:41 -0400
Message-ID: <513EC47E.9040602@linux.vnet.ibm.com>
Date: Tue, 12 Mar 2013 14:00:30 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362645372.2606.11.camel@laptop> <20130311082105.GB12742@gmail.com> <513DA076.80009@linux.vnet.ibm.com> <20130311094031.GA14221@gmail.com>
In-Reply-To: <20130311094031.GA14221@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031205-6102-0000-0000-00000323D06F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 05:40 PM, Ingo Molnar wrote:
> 
> * Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> 
>> Hi, Ingo
>>
>> On 03/11/2013 04:21 PM, Ingo Molnar wrote:
>> [snip]
>>>
>>> I have actually written the prctl() approach before, for instrumentation 
>>> purposes, and it does wonders to system analysis.
>>
>> The idea sounds great, we could get many new info to implement more
>> smart scheduler, that's amazing :)
>>
>>>
>>> Any objections?
>>
>> Just one concern, may be I have misunderstand you, but will it cause 
>> trouble if the prctl() was indiscriminately used by some applications, 
>> will we get fake data?
> 
> It's their problem: overusing it will increase their CPU overhead. The two 
> boundary worst-cases are that they either call it too frequently or too 
> rarely:
> 
>  - too frequently: it approximates the current cpu-runtime work metric
> 
>  - too infrequently: we just ignore it and fall back to a runtime metric
>    if it does not change.
> 
> It's not like it can be used to get preferential treatment - we don't ever 
> balance other tasks against these tasks based on work throughput, we try 
> to maximize this workload's work throughput.
> 
> What could happen is if an app is 'optimized' for a buggy scheduler by 
> changing the work metric frequency. We offer no guarantee - apps will be 
> best off (and users will be least annoyed) if apps honestly report their 
> work metric.
> 
> Instrumentation/stats/profiling will also double check the correctness of 
> this data: if developers/users start relying on the work metric as a 
> substitute benchmark number, then app writers will have an additional 
> incentive to make them correct.

I see, I could not figure out how to wisely using the info currently,
but I have the feeling that it will make scheduler very different ;-)

May be we could implement the API and get those info ready firstly
(along with the new sched-pipe which provide work tick info), then think
about the way to use them in scheduler, is there any patches on the way?

Regards,
Michael Wang

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


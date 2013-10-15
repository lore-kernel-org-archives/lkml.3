Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab3JOLgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:36:03 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:63756 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3JOLgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:36:01 -0400
Message-ID: <525D289C.1020402@gmail.com>
Date: Tue, 15 Oct 2013 13:35:56 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 12/14] sched: make dl_bw a sub-quota of rt_bw
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-13-git-send-email-juri.lelli@gmail.com> <20131014140618.GA26604@gmail.com> <525D1234.5060001@gmail.com> <20131015102621.GE10651@twins.programming.kicks-ass.net>
In-Reply-To: <20131015102621.GE10651@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 12:26 PM, Peter Zijlstra wrote:
> On Tue, Oct 15, 2013 at 12:00:20PM +0200, Juri Lelli wrote:
>> On 10/14/2013 04:06 PM, Ingo Molnar wrote:
>>>
>>> * Juri Lelli <juri.lelli@gmail.com> wrote:
>>>
>>>> +#ifdef CONFIG_SMP
>>>> +		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
>>>> +#else
>>>> +		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
>>>> +#endif
>>>
>>>> +#ifdef CONFIG_SMP
>>>> +		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
>>>> +#else
>>>> +		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
>>>> +#endif
>>>
>>> Btw., this kind of SMP/UP assymetry pattern really sucks. Why not make UP 
>>> use the SMP data structure, even if it's degenerate?
>>>
>>
>> Yes, I don't like it either, but that comes from the fact that it seemed to me
>> that, semantically, bandwidth for -deadline tasks has to be associated to the
>> single runqueue in UP and to the root_domain for SMP. In UP root_domain is
>> compiled out, so I'm not sure to understand what you suggest. I could probably
>> let dl_bw live on runqueues with the assumption that all the runqueues from the
>> same root_domain have the same dl_bw, that represents the dl_bw of the
>> root_domain. But I don't like this replication either :(.
> 
> #ifdef CONFIG_SMP
> 
> static inline struct dl_bw *dl_bw_of(int i)
> {
> 	return &cpu_rq(i)->rd->dl_bw;
> }
> 
> #else
> 
> static inline struct dl_bw *dl_bw_of(int i)
> {
> 	return &cpu_rq(i)->dl.dl_bw;
> }
> 
> #endif
> 
> ?
> 

Yes, way better.

Thanks,

- Juri

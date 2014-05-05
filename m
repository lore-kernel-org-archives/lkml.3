Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaEEEm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:42:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47420 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaEEEm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:42:57 -0400
Message-ID: <536715C7.9010603@linux.vnet.ibm.com>
Date: Mon, 05 May 2014 10:08:31 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        george.mccollister@gmail.com, ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com> <1399011219.5233.55.camel@marge.simpson.net> <53633B81.1080403@redhat.com> <CAM4v1pPwe4B0K8MPpf183LqabRoRKRPi_R7n8-Y02aR43M8iQQ@mail.gmail.com> <1399205073.5180.42.camel@marge.simpson.net>
In-Reply-To: <1399205073.5180.42.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050504-5806-0000-0000-000024CA5E17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 05:34 PM, Mike Galbraith wrote:
> On Sun, 2014-05-04 at 17:14 +0530, Preeti Murthy wrote: 
>> Hi Rik, Mike
>>
>> On Fri, May 2, 2014 at 12:00 PM, Rik van Riel <riel@redhat.com> wrote:
>>> On 05/02/2014 02:13 AM, Mike Galbraith wrote:
>>>> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote:
>>>>
>>>>> Whether or not this is the right thing to do remains to be seen,
>>>>> but it does allow us to verify whether or not the wake_affine
>>>>> strategy of always doing affine wakeups and only disabling them
>>>>> in a specific circumstance is sound, or needs rethinking...
>>>>
>>>> Yes, it needs rethinking.
>>>>
>>>> I know why you want to try this, yes, select_idle_sibling() is very much
>>>> a two faced little bitch.
>>>
>>> My biggest problem with select_idle_sibling and wake_affine in
>>> general is that it will override NUMA placement, even when
>>> processes only wake each other up infrequently...
>>
>> As far as my understanding goes, the logic in select_task_rq_fair()
>> does wake_affine() or calls select_idle_sibling() only at those
>> levels of sched domains where the flag SD_WAKE_AFFINE is set.
>> This flag is not set at the numa domain and hence they will not be
>> balancing across numa nodes. So I don't understand how
>> *these functions* are affecting NUMA placements.
> 
> Depends on how far away node yonder is I suppose.
> 
> static inline int sd_local_flags(int level)
> {
>         if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
>                 return 0;
> 
>         return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
> }
> 
> 

Hmm thanks Mike, I totally missed this!

Regards
Preeti U Murthy


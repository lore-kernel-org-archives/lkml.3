Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJJIRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:17:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46119 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaJJIRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:17:32 -0400
Message-ID: <54379618.9050305@monom.org>
Date: Fri, 10 Oct 2014 10:17:28 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Do not try to replenish from a non deadline tasks
References: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de> <5433B5B9.70006@arm.com> <5433D654.2020108@monom.org> <5433D84F.3040003@monom.org> <5433E8B3.6040708@monom.org> <5436599C.9000207@monom.org> <543692DF.9020705@arm.com>
In-Reply-To: <543692DF.9020705@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good Morning Juri,

On 10/09/2014 03:51 PM, Juri Lelli wrote:
> Hi Daniel,
> 
> On 09/10/14 10:47, Daniel Wagner wrote:
>> Hi Juri,
>>
>> On 10/07/2014 03:20 PM, Daniel Wagner wrote:
>>> On 10/07/2014 02:10 PM, Daniel Wagner wrote:
>>>> [   36.689416] pthread_-1555    0d..5 18486408us : sched_stat_sleep: comm=pthread_test pid=1554 delay=143975 [ns]
>>>> [   36.689416] pthread_-1555    0d..5 18486408us : sched_wakeup: comm=pthread_test pid=1554 prio=120 success=1 target_cpu=000
>>>> [   36.689416] pthread_-1555    0d..4 18486420us : sched_pi_setprio: comm=pthread_test pid=1555 oldprio=-1 newprio=-1
>>>> [   36.689416] pthread_-1555    0d..4 18486421us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
>>>> [   36.689416] pthread_-1555    0d..4 18486421us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=8
>>>> [   36.689416] pthread_-1555    0d..4 18486421us : sched_dequeue_dl_entity: comm=pthread_test pid=1555 flags=0
>>>> [   36.689416] pthread_-1555    0d..4 18486422us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=0
>>>> [   36.689416] pthread_-1555    0d.H4 18486539us : sched_enqueue_dl_entity: comm=pthread_test pid=1555 pi_comm=pthread_test pi_pid=1555 flags=8
>>>
>>> I noticed that the last two lines are different. Maybe that is yet
>>> another path into enqueue_task_dl().
>>
>> So more testing revealed that the patch also starve both task
>> eventually. Both process make no progress at all.
>>
> 
> Mmm, that's bad.
> 
> Can you give a try to this different patch (after applying
> the other one I sent out)?
> 
> This thing is looking good on my box. I'd like to do more
> testing, but I have to context switch for a bit now :/.

I'll applied both patches and my test program runs fine since a couple
hours. Before that a panic triggered within minutes.

cheers,
daniel

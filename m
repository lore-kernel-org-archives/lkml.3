Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3HZCW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:22:27 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47972 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3HZCW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:22:26 -0400
Message-ID: <521ABB9E.1050209@gmail.com>
Date: Mon, 26 Aug 2013 10:21:18 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Chen Gang <gang.chen@asianux.com>, dipankar@in.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no callbacks.
References: <5212E76A.40903@asianux.com> <5212E7BB.4020602@asianux.com> <20130820041832.GY29406@linux.vnet.ibm.com> <5212F3E5.7080700@asianux.com> <5212F467.8090407@asianux.com> <52145741.7000008@asianux.com> <20130821142301.GX29406@linux.vnet.ibm.com> <52157F21.5080200@asianux.com> <20130825191839.GA22515@linux.vnet.ibm.com>
In-Reply-To: <20130825191839.GA22515@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly, thank you for your reply with these details. 

On 08/26/2013 03:18 AM, Paul E. McKenney wrote:
> On Thu, Aug 22, 2013 at 11:01:53AM +0800, Chen Gang wrote:
>> On 08/21/2013 10:23 PM, Paul E. McKenney wrote:
>>> On Wed, Aug 21, 2013 at 01:59:29PM +0800, Chen Gang wrote:
> 
> [ . . . ]
> 
>>> Don't get me wrong, I do welcome appropriate patches.  In fact, if
>>> you look at RCU's git history, you will see that I frequently accept
>>> patches from a fair number of people.  And if you were willing to
>>> invest some time and thought, you might eventually be able to generate
>>> an appropriate (albeit low priority) patch to this function.  However,
>>> you seem to be motivated to submit small patches with a minimum of
>>> thought and preparation, perhaps because you need to meet some external
>>> or self-imposed quota of accepted patches.  And if you are in fact driven
>>> by a quota that prevents you from taking the time required to carefully
>>> think things through, you are wasting your time with RCU.
>>
>> Hmm... at least, some contents you said above is correct to me.
>>
>> At least, I should provide 10 patches per month, it is a necessary
>> basic requirement to me.
> 
> OK, that does help explain the otherwise inexplicable approach you have
> been taking.  Let's see how you have been doing, based on committer date
> in Linus's tree:
> 
>       1 2012-11
>      15 2013-01
>       7 2013-02
>      20 2013-03
>      21 2013-04
>      12 2013-05
>      17 2013-06
>      10 2013-07
> 
> The last few months might be understated a bit due to patches
> still being in maintainer trees.  This is a nice contrast from my
> first impression of you from https://lkml.org/lkml/2013/6/9/64 and
> https://lkml.org/lkml/2013/8/19/650, neither of which gave me any
> reason to trust your work, to put it mildly.  And if I cannot trust
> your work, I obviously cannot accept your patches.
> 

Hmm... better to check patches independent personal feelings (trust
some one, or not).

;-)


> You do seem to select for localized bug fixes, which require less work
> than the performance-motivated patches you were putting forward earlier
> in this thread.  With a localized bug, you demonstrate the bug, show the
> fix, and that is that.  From what I can see, part of the problem with
> your patches in this email thread is that you are trying to move from
> localized bug fixes to performance issues without doing the additional
> work required.  Please see below for a rough outline of this additional
> work.
> 

Hmm... it seems I need describe my work flow for fixing bugs in details.

  1. Is it a bug ?
     if so, I can be marked as Reported-by and continue to 2nd.
     else, it is a waste mail.

  2. Try to fix it in simple ways (so can save the maintainers time resource).
     if it can be accepted by maintainers, it is OK (I can be Signed-off-by).
     else need continue to 3rd.

       exception: if I can not find a simple way to fix it, I will send [Suggestion] mail.

  3. Do the maintainers know how to fix it ?
     if yes, fix it together with maintainers (may mark me only as Reported-by).
     else need continue to Last.

  Last: I should analyze it and fix it (it is my duty to fix it).


How do you feel about this work flow ? welcome any suggestions or
completions.

Thanks.

>> And what my focus is efficiency: let appliers and maintainers together
>> to provide contributes to outside with efficiency.
> 
> Sounds great, but there are many possible definitions of "efficiency".
> Given your quota, I would expect your definition to involve number of
> patches accepted.  In contrast, my definition for RCU instead involves
> maintainability, robustness, scalability, and, for a few critical
> code paths, performance.  I therefore need you to have thought through
> and carefully tested your patch.
> 

Hmm... it seems I need give more description for the 'efficiency' which
I point to.

If it is no negative effect with the quality, we need try to use less
resources (e.g. time resources) to provide more contributions (e.g. fix
issue).


>> If you already know about it, why need I continue ?  but if you don't
>> know either, I should try.
> 
> What I need you to do in future RCU performance patch submissions is:
> 
> 1.	Think through your patch and the code that it is modifying.
> 	If you submit a patch to me, you should be able to answer the
> 	sorts of questions that I was asking in this thread.
> 
> 2.	Tell me what situations your patch helps and not.
> 
> 3.	Tell me how much your patch improves performance in the
> 	situations where it helps.
> 
> 4.	Test the code.  If it makes a measurable difference, present
> 	the performance results.  (It would be very surprising if your
> 	early-loop exit patch made a significant difference, expecially
> 	on a CONFIG_PREEMPT=n kernel.)
> 
> 5.	Rather than randomly dropping into the code, use actual measurements
> 	to determine where to focus your performance-improvement efforts.
> 	Developers, even experienced ones, are really bad at guessing
> 	where the most important performance problems are.
> 
> 6.	Use your judgement.  For example, 1000-line patch to improve a
> 	slowpath by 0.1% simply isn't worth it.  A high risk of adding
> 	bugs for a microscopic benefit?  Thanks, but no thanks!!!
> 
> For your patch https://lkml.org/lkml/2013/8/19/651, which was closest
> of the three to being useful, here are some things about RCU that you
> should have taken the time to learn -before- submitting the patch:
> 
> a.	Q:  How many iterations for the for_each_rcu_flavor() loop?
> 	A:  On CONFIG_PREEMPT=n kernels, only two iterations.
> 	    On CONFIG_PREEMPT=y kernels, only three iterations.
> 
> b.	Q:  Which flavor of RCU is most likely to have non-lazy callbacks
> 	    queued?
> 	    
> 	A:  On CONFIG_PREEMPT=y kernels, the first one in the list.
> 	    For CONFIG_PREEMPT=n kernels, it is last in the list.
> 	    (In other words, for CONFIG_PREEMPT=n kernels, this change
> 	    won't help at all, at least not without also changing the
> 	    order of the list.)
> 
> c.	Q:  Do any of the other for_each_rcu_flavor() loops care what order
> 	    the flavors are in?
> 
> 	A:  No.  (In other words, it is OK to reorder the list to improve
> 	    the performance.)
> 
> d.	Q:  What is the performance benefit of this change?
> 
> 	A:  Quite small, for example, much less than an atomic operation
> 	    on a shared data item.  It is probably not possible to
> 	    measure the performance difference.
> 
> e.	Q:  Is the change on a hotpath?
> 
> 	A:  Somewhat.  It is not on the read side, but it is on the path
> 	    to and from idle, which can be important for latency-sensitive
> 	    workloads.
> 
> f.	Q:  How did you test this patch?
> 
> 	A:  As far as I can see, you did no testing.
> 
> If I receive a future patch from you that does not convince me that you
> know the answer to questions like these, I will most likely ignore it.
> 

Hmm... it sounds reasonable for some cases.

e.g.

  when neither you nor me know about how to fix it.

  As a patch maker, I should continue trying to fix it.
    (what you said above is valuable reference to me).

  As an integrator, you should give a necessary check for it.
    (what you said above is the necessary check for it).


If the integrator already know about how to fix it, it seems what you
said above is not quite efficient.


> Just for practice, let's rework your second patch to make it something
> that I might accept.  Here is what you had:
> 
> 		for_each_rcu_flavor(rsp) {
> 			rdp = per_cpu_ptr(rsp->rda, cpu);
> 	-		if (rdp->qlen != rdp->qlen_lazy)
> 	-			al = false;
> 	-		if (rdp->nxtlist)
> 	+		if (rdp->nxtlist) {
> 				hc = true;
> 	+			if (rdp->qlen != rdp->qlen_lazy) {
> 	+				al = false;
> 	+				break;
> 	+			}
> 	+		}
> 		}
> 		if (all_lazy)
> 			*all_lazy = al;
> 
> We need to do something about the indentation, perhaps as follows:
> 
> 		for_each_rcu_flavor(rsp) {
> 			rdp = per_cpu_ptr(rsp->rda, cpu);
> 			if (!rdp->nxtlist)
> 				continue;
> 			hc = true;
> 			if (rdp->qlen != rdp->qlen_lazy) {
> 				al = false;
> 				break;
> 			}
> 		}
> 		if (all_lazy)
> 			*all_lazy = al;
> 
> 
> We also need to change the following code in rcu_init() in the file
> kernel/rcutree.c:
> 
> 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
> 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
> 	__rcu_init_preempt();
> 
> So that it gets rcu_sched_state in the right place, which I believe is
> like this:
> 
> 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
> 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
> 	__rcu_init_preempt();
> 
> 

At least for me, it sounds reasonable. It seems you have already know
about how to fix it (you never directly say you know about it, so I use
'seems').


> If you make these changes, test them with RCU_FAST_NO_HZ both set and
> not set, and verify that rcu_sched_state is first in the flavor list
> for kernels with PREEMPT=n and that rcu_preempt_state is first in flavor
> list for kernels with PREEMPT=y, and send me a the resulting patch by end
> of day Friday, China time, I will seriously consider it for acceptance.
> Otherwise, I will author the patch myself with your Reported-by.
> 

If you have already know about how to fix it, please fix it as soon as
possible when you have time (mark me as Reported-by is OK).

If you need additional help from me for this issue, please let me know,
I should try.


:-)


Thanks.

> Again, good luck!
> 
> 							Thanx, Paul
> 
>>> Good luck!
>>>
>>
>> Thanks.
>>
>>> 							Thanx, Paul
>>>
>>>> -------------------------------diff begin-------------------------------
>>>>
>>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>>> index dbf74b5..1d02659 100644
>>>> --- a/kernel/rcutree.c
>>>> +++ b/kernel/rcutree.c
>>>> @@ -2728,6 +2728,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>>>>  		if (rdp->nxtlist)
>>>>  			hc = true;
>>>>  	}
>>>> +	BUG_ON(!hc && !al);
>>>>  	if (all_lazy)
>>>>  		*all_lazy = al;
>>>>  	return hc;
>>>>
>>>> -------------------------------diff end---------------------------------
>>>>
>>>> Thanks.
>>>>
>>>>
>>>> On 08/20/2013 12:45 PM, Chen Gang wrote:
>>>>> On 08/20/2013 12:43 PM, Chen Gang wrote:
>>>>>> On 08/20/2013 12:18 PM, Paul E. McKenney wrote:
>>>>>>> On Tue, Aug 20, 2013 at 11:51:23AM +0800, Chen Gang wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> If 'hc' is false, 'al' will never be false, either (only need check
>>>>>>>> "irdp->qlen != rdp->qlen_lazy' when 'rdp->nxtlist' existance).
>>>>>>>>
>>>>>>>> Recommend to improve the related code, like the diff below.
>>>>>>>
>>>>>>> Are you sure that this represents an improvement?  If so, why?
>>>>>>>
>>>>>>
>>>>>> If 'hc' and 'al' really has relationships, better to let 'C code'
>>>>>> express it, that will make the code clearer.
>>>>>>
>>>>>>> Or to put it another way, I see a patch that increases the size of the
>>>>>>> kernel by three lines.  What is the corresponding benefit given common
>>>>>>> kernel workloads?
>>>>>>>
>>>>>>
>>>>>> For 'al', need not check for each looping, and for 'hc', may save the
>>>>>> useless looping (so it can make performance better).
>>>>>>
>>>>>> For C code, it really increases 3 lines, but may not for assembly code
>>>>>> (excuse me, I am not check it, I think it is not important, although it
>>>>>> is easy to give a comparing for binary).
>>>>>>
>>>>>
>>>>> Oh, sorry, I mean: only for our case, "it is not important".
>>>>>
>>>>>
>>>>>>> 							Thanx, Paul
>>>>>>>
>>>>>>>> ----------------------------------diff begin------------------------------------
>>>>>>>>
>>>>>>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>>>>>>> index 5b53a89..421caf0 100644
>>>>>>>> --- a/kernel/rcutree.c
>>>>>>>> +++ b/kernel/rcutree.c
>>>>>>>> @@ -2719,10 +2719,13 @@ static int rcd'_cpu_has_callbacks(int cpu, bool *all_lazy)
>>>>>>>>
>>>>>>>>  	for_each_rcu_flavor(rsp) {
>>>>>>>>  		rdp = per_cpu_ptr(rsp->rda, cpu);
>>>>>>>> -		if (rdp->qlen != rdp->qlen_lazy)
>>>>>>>> -			al = false;
>>>>>>>> -		if (rdp->nxtlist)
>>>>>>>> +		if (rdp->nxtlist) {
>>>>>>>>  			hc = true;
>>>>>>>> +			if (rdp->qlen != rdp->qlen_lazy) {
>>>>>>>> +				al = false;
>>>>>>>> +				break;
>>>>>>>> +			}
>>>>>>>> +		}
>>>>>>>>  	}
>>>>>>>>  	if (all_lazy)
>>>>>>>>  		*all_lazy = al;
>>>>>>>>
>>>>>>>> ----------------------------------diff end--------------------------------------
>>>>>>>>
>>>>>>>>
>>>>>>>> On 08/20/2013 11:50 AM, Chen Gang wrote:
>>>>>>>>> According to the comment above rcu_cpu_has_callbacks(): "If there are
>>>>>>>>> no callbacks, all of them are deemed to be lazy".
>>>>>>>>>
>>>>>>>>> So when both 'hc' and 'al' are false, '*all_lazy' should be true, not
>>>>>>>>> false.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>>>>>> ---
>>>>>>>>>  kernel/rcutree.c |    2 +-
>>>>>>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>>>>>>>> index 5b53a89..9ee9565 100644
>>>>>>>>> --- a/kernel/rcutree.c
>>>>>>>>> +++ b/kernel/rcutree.c
>>>>>>>>> @@ -2725,7 +2725,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>>>>>>>>>  			hc = true;
>>>>>>>>>  	}
>>>>>>>>>  	if (all_lazy)
>>>>>>>>> -		*all_lazy = al;
>>>>>>>>> +		*all_lazy = !hc ? true : al;
>>>>>>>>>  	return hc;
>>>>>>>>>  }
>>>>>>>>>  
>>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> -- 
>>>>>>>> Chen Gang
>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>> -- 
>>>> Chen Gang
>>>>
>>>
>>>
>>>
>>
>>
>> -- 
>> Chen Gang
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Chen Gang

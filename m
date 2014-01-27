Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaA0Mwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 07:52:37 -0500
Received: from mail3.unitn.it ([193.205.206.24]:62628 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaA0Mwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 07:52:36 -0500
Message-ID: <52E6568F.9040802@unitn.it>
Date: Mon, 27 Jan 2014 13:52:31 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com> <20140127115316.GA16595@austad.us> <52E65172.6070809@unitn.it> <20140127124011.GA16809@austad.us>
In-Reply-To: <20140127124011.GA16809@austad.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 01:40 PM, Henrik Austad wrote:
[...]
>>> Current runtime: time spent running _this_ period? or is _remaining_
>>> runtime this period? I get the feeling it's the latter.
>>>
>>> So, roughly, it is the ration
>>>
>>>        remaining_runtime / relative_time_to_deadline
>>>
>>> which needs to be greater than the assigned CPU bandwidth, and if so, the
>>> budget should be replensihed?
>>>
>>> Shouldn't there be something about not refilling the budget before a new
>>> period has started?
>> Uh... Maybe the description above can be improved :)
>> Do you think that using "remaining runtime" instead of "current runtime"
>> would help? If yes, I'll make this change.
>
> Yes, in my vocabularly, "remaining" != "current" :), so changing to
> 'remaining runtime' would be nice.
Ok; I'll make this change.


>> Also, I see that some of your questions are answered by some items below...
>
> Yes, but I left the comments to indicate that the order was a bit
> confusing.
>
>> Do you think that changing the order of the items in the presentation would
>> improve the readability? If you suggest a better ordering, I'll try to
>> rewrite the algorithm's description according to it.
>
> Could be, at least the ratio-caclulation was a bit confusing until I'd read
> the entire section.
>
> My preferred order (I've just cut'n'pased from the original email here)
>
> +  - The state of the task is described by a "scheduling deadline", and
> +    a "current runtime". These two parameters are initially set to 0;
BTW, maybe some of the confusion can be avoided by explaining what the
"remaining runtime" is here... Something like:
- The state of the task is described by a "scheduling deadline", and
   a "current runtime" (representing the amount of execution time that
   the task can use before the scheduling deadline). These two parameters
   are initially set to 0;

Can something like this help? If yes, I'll update the document.


[...]
> +  - When a SCHED_DEADLINE task wakes up (becomes ready for execution),
> +    the scheduler checks if
> +
> +                    current runtime                runtime
> +         ---------------------------------- > ----------------
> +         scheduling deadline - current time         period
> +
> +    then, if the scheduling deadline is smaller than the current time, or
> +    this condition is verified, the scheduling deadline and the
> +    current budget are re-initialised as
> +
> +         scheduling deadline = current time + deadline
> +         current runtime = runtime
> +
> +    otherwise, the scheduling deadline and the current runtime are
> +    left unchanged;
> +
>
> Emphasis on -my- preferred order. :)
Ok; let's see what other people think, and then we decide the items'
order.


> Either way, I'm quite happy with this documentation-update, this is just
> nitpick :)
Ok, good.


			Thanks,
				Luca


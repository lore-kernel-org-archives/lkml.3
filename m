Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3EVJ0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:26:18 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42987 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3EVJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:26:17 -0400
Message-ID: <519C8F24.5060207@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 17:25:56 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <519AE7F2.706@linux.vnet.ibm.com> <20130522084947.GQ26912@twins.programming.kicks-ass.net>
In-Reply-To: <20130522084947.GQ26912@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052209-0260-0000-0000-00000309D08F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 04:49 PM, Peter Zijlstra wrote:
[snip]
>>
>> CC: Ingo Molnar <mingo@kernel.org>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Mike Galbraith <efault@gmx.de>
>> CC: Alex Shi <alex.shi@intel.com>
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

Thanks for your reply, I've looking forward it for a long time...

> 
> So I utterly hate this patch. I hate it worse than your initial buddy
> patch :/

Then we nuke it, and figure out the better one ;-)

> 
> And I know its got a Suggested-by there; but that was when you led me to
> believe that wake_affine() itself was expensive to run; its not, its the
> result of those runs you don't like.

Both are the reason, it's just the game between gain & lost & cost, your
suggestion definitely is a good choice, otherwise I won't pay time on
it, and I will call it's the best one if we are searching for a quick fix.

> 
> While we have a ton (too many to be sure) scheduler tunables, users
> shouldn't ever need to actually touch those. Its just that every time we
> have to make a random choice its as easy to make it a debug knob as to
> hardcode it.
> 
> The problem with this patch is that users _have_ to frob knobs and while
> doing so potentially wreck other workloads.
> 
> To make it worse, the knob isn't anything fundamental, its a random
> hack.

So we discard.

> 
> So I would really either improve the smarts of wake_affine, with for
> example your wake buddy relation thing (and simply exempt [Soft]IRQs) or
> kill wake_affine and be done with it.

No kill...we show mercy, I will back to the wakeup-buddy and let's
forgot the IRQ case temporarily unless some regression report appear.

> 
> Either avenue has the risk of regressing some workload, but at least
> when that happens (and people report it) we'll have a counter-example to
> learn from and incorporate.

I've not test the hackbench with wakeup-buddy before, will do it this
time, I suppose the 15% illegal income will suffered, anyway, it's
illegal :)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


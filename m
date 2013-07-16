Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000Ab3GPUrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:47:20 -0400
Received: from mail.lang.hm ([64.81.33.126]:48361 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933670Ab3GPUrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:47:19 -0400
Date: Tue, 16 Jul 2013 13:45:53 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
In-Reply-To: <51E47BAF.7020209@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1307161343560.15520@nftneq.ynat.uz>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net> <51E45D98.7040404@linux.intel.com>
 <20130715210316.GE23818@dyad.programming.kicks-ass.net> <51E47BAF.7020209@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Arjan van de Ven wrote:

> On 7/15/2013 2:03 PM, Peter Zijlstra wrote:
>> Well, if you ever want to go faster there must've been a moment to slow 
>> down.
>> Without means and reason to slow down the entire 'can I go fast noaw pls?'
>> thing simply doesn't make sense.
>
> I kind of tried to hint at this
>
> there's either
>
> go_fastest_now()
>
> with the contract that the policy drivers can override this after some time 
> (few ms)
>
> or you have to treat it as a lease:
>
> go_fastest()
>
> and then
>
> no_need_to_go_fastest_anymore_so_forget_I_asked()
>
> this is NOT the same as
>
> go_slow_now()
>
> the former has a specific request, and then an end to that specific request,
> the later is just a new unbounded command
>
> if you have requests (that either time out or get canceled), you can have
> requests from multiple parts of the kernel (and potentially even from
> hardware in the thermal case), and some arbiter
> who resolves multiple requests existing.
>
> if you only have unbounded commands, you cannot really have such an arbiter.

Sometimes the user has something running that they want to keep running, but 
they don't need it to be going fast.

An example is if you are monitoring something.

Unless you can go to sleep between monitoring polls, it makes more sense to run 
slowly than to run at full speed with lots of idle cycles.

David Lang

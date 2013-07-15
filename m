Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3GOUl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:41:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:14648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab3GOUlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:41:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,671,1367996400"; 
   d="scan'208";a="370671877"
Message-ID: <51E45E8B.705@linux.intel.com>
Date: Mon, 15 Jul 2013 13:41:47 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130715195914.GC23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/2013 12:59 PM, Peter Zijlstra wrote:
> On Sat, Jul 13, 2013 at 07:40:08AM -0700, Arjan van de Ven wrote:
>> On 7/12/2013 11:49 PM, Peter Zijlstra wrote:
>>>
>>> Arjan; from reading your emails you're mostly busy explaining what cannot be
>>> done. Please explain what _can_ be done and what Intel wants. From what I can
>>> see you basically promote a max P state max concurrency race to idle FTW.
>>
>>>
>>> Since you can't say what the max P state is; and I think I understand the
>>> reasons for that, and the hardware might not even respect the P state you tell
>>> it to run at, does it even make sense to talk about Intel P states? When would
>>> you not program the max P state?
>>
>> this is where it gets complicated ;-( the race-to-idle depends on the type of
>> code that is running, if things are memory bound it's outright not true, but
>> for compute bound it often is.
>
> So you didn't actually answer the question about when you'd program a less than
> max P state.
(oops missed this part in my previous reply)

so race to halt is all great, but it has a core limitation, it is fundamentally
assuming that if you go at a higher clock frequency, the code actually finishes sooner.
This is generally true for the normal "compute" kind of instructions, but
if you have an instruction that goes to memory (and misses caches), that is not the
case because memory itself does not go faster or slower with the CPU frequency.

so depending of the mix of compute and memory instructions, different tradeoffs
might be needed.

(for an example of this, AMD exposes a CPU counter for this as of recently and added
patches to "ondemand" to use it)



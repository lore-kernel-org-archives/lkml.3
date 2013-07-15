Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3GOWqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:46:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:57573 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab3GOWqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:46:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,672,1367996400"; 
   d="scan'208";a="331828170"
Message-ID: <51E47BAF.7020209@linux.intel.com>
Date: Mon, 15 Jul 2013 15:46:07 -0700
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
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net> <51E45D98.7040404@linux.intel.com> <20130715210316.GE23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130715210316.GE23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/2013 2:03 PM, Peter Zijlstra wrote:
> Well, if you ever want to go faster there must've been a moment to slow down.
> Without means and reason to slow down the entire 'can I go fast noaw pls?'
> thing simply doesn't make sense.

I kind of tried to hint at this

there's either

go_fastest_now()

with the contract that the policy drivers can override this after some time (few ms)

or you have to treat it as a lease:

go_fastest()

and then

no_need_to_go_fastest_anymore_so_forget_I_asked()

this is NOT the same as

go_slow_now()

the former has a specific request, and then an end to that specific request,
the later is just a new unbounded command

if you have requests (that either time out or get canceled), you can have
requests from multiple parts of the kernel (and potentially even from
hardware in the thermal case), and some arbiter
who resolves multiple requests existing.

if you only have unbounded commands, you cannot really have such an arbiter.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab3FRTgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:36:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:5478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933370Ab3FRTgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:36:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,890,1363158000"; 
   d="scan'208";a="351933685"
Message-ID: <51C0B6CA.5030606@linux.intel.com>
Date: Tue, 18 Jun 2013 12:36:42 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, catalin.marinas@arm.com
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin> <51C07ABC.2080704@linux.intel.com> <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/2013 10:47 AM, David Lang wrote:

>
> so this sounds to me like the process for changing settings on this Intel hardware is a two phase process
>
> something looks up what should be possible and says "switch to mode X"

more a case of "I would like to request X"
it's not a mandate, it's a polite request/suggestion

> after mode switch happens it then looks and finds "it's now in mode Y"

you don't really know what you are in, you can only really know on average what you were in over
some time in the past.
As such, Y is not really discrete/enumeratable (well since it's all fixed point math, it is, sure, in steps if 1 Hz)

the "current" thing is changing all the time on a very fine grained timescale, depending on
what the other cores in the system are doing, what graphics is doing, what the temperature is etc etc.


> And if you can't tell what mode you are in, or what the expected performance characteristics are, then you can't possibly do any intellegant allocations.

you can tell what you were in looking in the rear-view mirror. you have no idea what it'll be going forward.
>
> If Intel is doing this for current CPUs, I expect that they will fix this before too much longer.

I'm pretty sure that won't happen, and I'm also pretty sure the other CPU vendors are either there today (AMD) or
will be there in the next few years (ARM).
It's the nature of how CPUs do power and thermal management and the physics behind that.

>> You can look in hindsight what kind of performance you got (from some basic counters in MSRs), and the scheduler can use that to account backwards to what some process
>> got. But to predict what you will get in the future...... that's near impossible on any realistic system nowadays (and even more so in the future).
>
> If you have no way of knowing how much processing power you should expect to have on each core in the near future, then you have no way of allocating processes
> appropriately between the cores.
>
> It's bad enough trying to guess the needs of the processes, but if you also are reduced to guessing the capabilities of the cores, how can anything be made to work?

you can give some suggestions to the hardware. But how much you actually get can be off by 2x or more in either direction.
And most of that will depend on what other cores/graphics in the system are doing
(in terms of idle or their own requests and the amount of the total power budget they are consuming)



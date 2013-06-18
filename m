Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab3FRSuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:50:03 -0400
Received: from mail.lang.hm ([64.81.33.126]:33523 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab3FRSuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:50:00 -0400
Date: Tue, 18 Jun 2013 10:47:21 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Morten Rasmussen <morten.rasmussen@arm.com>,
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
In-Reply-To: <51C07ABC.2080704@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin> <51C07ABC.2080704@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Arjan van de Ven wrote:

> On 6/14/2013 9:05 AM, Morten Rasmussen wrote:
>
>> Looking at the discussion it seems that people have slightly different
>> views, but most agree that the goal is an integrated scheduling,
>> frequency, and idle policy like you pointed out from the beginning.
>
>
> ... except that such a solution does not really work for Intel hardware.
>
> The OS does not get to really pick the CPU "frequency" (never mind that
> frequency is not what gets controlled), the hardware picks the frequency.
> The OS can do some level of requests (best to think of this as a percentage
> more than frequency) but what you actually get is more often than not
> what you asked for.

so this sounds to me like the process for changing settings on this Intel 
hardware is a two phase process

something looks up what should be possible and says "switch to mode X"
after mode switch happens it then looks and finds "it's now in mode Y"

As long as there is some table to list the possible X modes to switch to, and 
some table to lookup the characteristics of the possible Y modes that you are in 
(and the list of modes you can change to may be different depending on what mode 
you are in), this doesn't seem to be a huge problem.

And if you can't tell what mode you are in, or what the expected performance 
characteristics are, then you can't possibly do any intellegant allocations.

If Intel is doing this for current CPUs, I expect that they will fix this before 
too much longer.

> You can look in hindsight what kind of performance you got (from some basic 
> counters in MSRs), and the scheduler can use that to account backwards to what 
> some process got. But to predict what you will get in the future...... that's 
> near impossible on any realistic system nowadays (and even more so in the 
> future).

If you have no way of knowing how much processing power you should expect to 
have on each core in the near future, then you have no way of allocating 
processes appropriately between the cores.

It's bad enough trying to guess the needs of the processes, but if you also are 
reduced to guessing the capabilities of the cores, how can anything be made to 
work?

David Lang

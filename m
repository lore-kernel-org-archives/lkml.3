Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab3FRPUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:20:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:17689 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab3FRPUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:20:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,890,1363158000"; 
   d="scan'208";a="318880027"
Message-ID: <51C07ABC.2080704@linux.intel.com>
Date: Tue, 18 Jun 2013 08:20:28 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>, "alex.shi@intel.com" <alex.shi@intel.com>,
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
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin>
In-Reply-To: <20130614160522.GG32728@e103034-lin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 9:05 AM, Morten Rasmussen wrote:

> Looking at the discussion it seems that people have slightly different
> views, but most agree that the goal is an integrated scheduling,
> frequency, and idle policy like you pointed out from the beginning.


... except that such a solution does not really work for Intel hardware.

The OS does not get to really pick the CPU "frequency" (never mind that
frequency is not what gets controlled), the hardware picks the frequency.
The OS can do some level of requests (best to think of this as a percentage
more than frequency) but what you actually get is more often than not
what you asked for.

You can look in hindsight what kind of performance you got (from some basic
counters in MSRs), and the scheduler can use that to account backwards to what some process
got. But to predict what you will get in the future...... that's near impossible
on any realistic system nowadays (and even more so in the future).

Treating "frequency" (well "performance) and idle separately is also a false thing to do
(yes I know in 3.9/3.10 we still do that for Intel hw, but we're working
on fixing that). They are by no means separate things. One guy's idle state
is the other guys power budget (and thus performance)!.




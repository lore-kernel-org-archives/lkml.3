Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037Ab3GLPhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:37:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:36977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938Ab3GLPhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:37:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,653,1367996400"; 
   d="scan'208";a="364336699"
Message-ID: <51E022BA.9030005@linux.intel.com>
Date: Fri, 12 Jul 2013 08:37:30 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 8/9] sched: power: Add initial frequency scaling
 support to power scheduler
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <1373385338-12983-9-git-send-email-morten.rasmussen@arm.com> <51DD5D63.7000602@linux.intel.com> <20130712125113.GF20960@e103034-lin>
In-Reply-To: <20130712125113.GF20960@e103034-lin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2013 5:51 AM, Morten Rasmussen wrote:
> On Wed, Jul 10, 2013 at 02:10:59PM +0100, Arjan van de Ven wrote:
>> On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
>>> Extends the power scheduler capacity management algorithm to handle
>>> frequency scaling and provide basic frequency/P-state selection hints
>>> to the power driver.
>>>
>>> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
>>> CC: Ingo Molnar <mingo@kernel.org>
>>> CC: Peter Zijlstra <peterz@infradead.org>
>>> CC: Catalin Marinas <catalin.marinas@arm.com>
>>> ---
>>>    kernel/sched/power.c |   33 ++++++++++++++++++++++++++++-----
>>>    1 file changed, 28 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/kernel/sched/power.c b/kernel/sched/power.c
>>> index 9e44c0e..5fc32b0 100644
>>> --- a/kernel/sched/power.c
>>> +++ b/kernel/sched/power.c
>>> @@ -21,6 +21,8 @@
>>>
>>>    #define INTERVAL 5 /* ms */
>>>    #define CPU_FULL 90 /* Busy %-age - TODO: Make tunable */
>>> +#define CPU_TARGET 80 /* Target busy %-age - TODO: Make tunable */
>>> +#define CPU_EMPTY 5 /* Idle noise %-age - TODO: Make tunable */
>>>
>>
>> to be honest, this is the policy part that really should be in the hardware specific driver
>> and not in the scheduler.
>> (even if said driver is sort of a "generic library" kind of thing)
>
> I agree that the values should be set by a hardware specific power
> driver. Or do you mean that algorithms using this sort of values should
> be in the driver?

the later.
the algorithm you have makes assumptions about how the hardware behaves to a degree that
is really problematic. It sort of seems to resemble the ondemand kind of thing....
... and there's some very good reasons we ran away screaming from ondemand for Intel.

>


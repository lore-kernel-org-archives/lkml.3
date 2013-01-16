Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3APGK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:10:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:65278 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3APGKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:10:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="191649673"
Message-ID: <50F644A9.3080509@intel.com>
Date: Wed, 16 Jan 2013 14:11:53 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/22] sched: packing small tasks in wake/exec balancing
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-18-git-send-email-alex.shi@intel.com> <20130110171728.GG2046@e103034-lin> <50EF8B37.7050404@intel.com> <87pq18nsnk.fsf@sejong.aot.lge.com>
In-Reply-To: <87pq18nsnk.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 03:13 PM, Namhyung Kim wrote:
> On Fri, 11 Jan 2013 11:47:03 +0800, Alex Shi wrote:
>> On 01/11/2013 01:17 AM, Morten Rasmussen wrote:
>>> On Sat, Jan 05, 2013 at 08:37:46AM +0000, Alex Shi wrote:
>>>> If the wake/exec task is small enough, utils < 12.5%, it will
>>>> has the chance to be packed into a cpu which is busy but still has space to
>>>> handle it.
>>>>
>>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>>> ---
> [snip]
>>> I may be missing something, but could the expression be something like
>>> the below instead?
>>>
>>> Create a putil < 12.5% check before the loop. There is no reason to
>>> recheck it every iteration. Then:
> 
> Agreed.  Also suggest that the checking local cpu can also be moved
> before the loop so that it can be used without going through the loop if
> it's vacant enough.

Yes, thanks for suggestion!
> 
>>>
>>> vacancy = FULL_UTIL - (rq->util + putil)
>>>
>>> should be enough?
>>>
>>>> +
>>>> +		/* bias toward local cpu */
>>>> +		if (vacancy > 0 && (i == this_cpu))
>>>> +			return i;
>>>> +
>>>> +		if (vacancy > 0 && vacancy < min_vacancy) {
>>>> +			min_vacancy = vacancy;
>>>> +			idlest = i;
>>>
>>> "idlest" may be a bit misleading here as you actually select busiest cpu
>>> that have enough spare capacity to take the task.
>>
>> Um, change to leader_cpu?
> 
> vacantest? ;-)

hard to the ward in google. are you sure it is better than leader_cpu?  :)
> 
> Thanks,
> Namhyung
> 


-- 
Thanks Alex

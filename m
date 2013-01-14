Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3ANHNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:13:54 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60269 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3ANHNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:13:53 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-18-50f3b02fca33
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan\@linux.intel.com" <arjan@linux.intel.com>,
        "bp\@alien8.de" <bp@alien8.de>, "pjt\@google.com" <pjt@google.com>,
        "efault\@gmx.de" <efault@gmx.de>,
        "vincent.guittot\@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti\@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/22] sched: packing small tasks in wake/exec balancing
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	<1357375071-11793-18-git-send-email-alex.shi@intel.com>
	<20130110171728.GG2046@e103034-lin> <50EF8B37.7050404@intel.com>
Date: Mon, 14 Jan 2013 16:13:51 +0900
In-Reply-To: <50EF8B37.7050404@intel.com> (Alex Shi's message of "Fri, 11 Jan
	2013 11:47:03 +0800")
Message-ID: <87pq18nsnk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 11:47:03 +0800, Alex Shi wrote:
> On 01/11/2013 01:17 AM, Morten Rasmussen wrote:
>> On Sat, Jan 05, 2013 at 08:37:46AM +0000, Alex Shi wrote:
>>> If the wake/exec task is small enough, utils < 12.5%, it will
>>> has the chance to be packed into a cpu which is busy but still has space to
>>> handle it.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>> ---
[snip]
>> I may be missing something, but could the expression be something like
>> the below instead?
>> 
>> Create a putil < 12.5% check before the loop. There is no reason to
>> recheck it every iteration. Then:

Agreed.  Also suggest that the checking local cpu can also be moved
before the loop so that it can be used without going through the loop if
it's vacant enough.

>> 
>> vacancy = FULL_UTIL - (rq->util + putil)
>> 
>> should be enough?
>> 
>>> +
>>> +		/* bias toward local cpu */
>>> +		if (vacancy > 0 && (i == this_cpu))
>>> +			return i;
>>> +
>>> +		if (vacancy > 0 && vacancy < min_vacancy) {
>>> +			min_vacancy = vacancy;
>>> +			idlest = i;
>> 
>> "idlest" may be a bit misleading here as you actually select busiest cpu
>> that have enough spare capacity to take the task.
>
> Um, change to leader_cpu?

vacantest? ;-)

Thanks,
Namhyung

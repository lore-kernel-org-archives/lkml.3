Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaEASmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:42:12 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34234 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaEASmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:42:08 -0400
Message-ID: <5362957D.3060101@gmail.com>
Date: Thu, 01 May 2014 11:42:05 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stratos Karafotis <stratosk@semaphore.gr>
CC: dirk.brandewie@gmail.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: intel_pstate: Change the calculation of next
 pstate
References: <535D80C8.9090906@semaphore.gr> <CAKohpomhUk7RQ3YL3=wpVKSbK_oSkyYBRUZiqnHzWqrZ2DjRRA@mail.gmail.com> <535FD4A6.3050905@semaphore.gr> <25001203.glgeYCc6ZZ@vostro.rjw.lan>
In-Reply-To: <25001203.glgeYCc6ZZ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 02:52 PM, Rafael J. Wysocki wrote:
> On Tuesday, April 29, 2014 07:34:46 PM Stratos Karafotis wrote:
>> On 29/04/2014 07:58 πμ, Viresh Kumar wrote:
>>> Cc'd Dirk,
>>>
>>> On 28 April 2014 03:42, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>>>> Currently the driver calculates the next pstate proportional to
>>>> core_busy factor and reverse proportional to current pstate.
>>>>
>>>> Change the above method and calculate the next pstate independently
>>>> of current pstate.
>>>
>>> We must mention why the change is required.
>>>
>>
>> Hi Viresh,
>>
>> Actually, I can't say that it's required. :)
>> I just believe that calculation of next p-state should be independent
>> from current one. In my opinion we can't scale the load across different
>> p-states, because it's not always equivalent.
>>
>> For example suppose a load of 100% because of a tight for loop in the
>> current p-state. It will be also a 100% load in any other p-state.
>> It will be wrong if we scale the load in the calculation formula
>> according to the current p-state.
>>
>> I included the test results in the change log to point out an improvement
>> because of this patch.
>>
>> I will enrich more the change log as you suggested.
>
> Please do so.
>
> Also, we need to take your patch to our power lab and see if we can reproduce
> your results in other workloads.
>
> And I'm waiting for the intel_pstate developer Dirk Brandewie to comment.

Sorry I just returned from dealing with a family emergency and am digging
out of my inbox.

I will run this patch through some tests.


>
> Thanks!
>


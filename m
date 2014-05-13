Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbaEMNji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:39:38 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:43140 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754282AbaEMNjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:39:36 -0400
Message-ID: <53722094.5070805@semaphore.gr>
Date: Tue, 13 May 2014 16:39:32 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yuyang Du <yuyang.du@intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Doug Smythies <dsmythies@telus.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH] cpufreq: intel_pstate: Change the calculation of
 next pstate
References: <bf3034d0-5c89-4ddb-921a-a92a4aed39f8@fmsmsx105.amr.corp.intel.com> <20140512215956.GC10676@intel.com>
In-Reply-To: <20140512215956.GC10676@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/2014 12:59 πμ, Yuyang Du wrote:
>>>> Maybe, in some cases yes. But not always. 
>>>> For example, please consider a CPU running a tight "for" loop in 100MHz 
>>>> for a couple of seconds. This produces a load of 100%. 
>>>> It will produce the same load (100%) in any other frequency. 
>>>
>>> Still fundamentally wrong, because you are not making a fair 
>>> comparison ("load" in 100MHz vs. any other freq). 
>>>
>>
>> I'm sorry, I didn't understand you. What do you mean it's not fair?
>>
>> In the above example (considering a CPU with min freq 100MHz and max freq 1000Mhz) a load of 100% should also be 100 in other next frequency.
>>
>> If we scale the load we will calculate the load in 100Mhz to 10%. I believe that this is not true.
> 
> The amount of work @100MHz is the same as the amount of work @1000MHZ, in your
> example? Put another way, your proposed method does not do any extra better,
> but do worse in other cases (what if @1000MHz, the load drops to 10%).
> 
> That said, your case cannot be used against associating freq with load. That also
> said, by associating freq with load, we will finally get highest freq as well
> (in your case).
> 
> Yuyang
> 

[I rewrite my last post, because I think something happened with my email server
and the message haven't delivered properly]

I mean that if a CPU was busy 100% at 100MHz it would be most probably (or we
should consider that would be) busy 100% at 1000MHz.

We don't know the amount of load in next sampling period. We also
don't know the type of load. A mathematical calculation that started in
previous sampling period and kept the CPU 100% busy, will most probably
keep the CPU also 100% busy in the next sampling period.

Scaling the load will be wrong in this case.

Of course, I don't say that the "amount" of load in these 2 periods are the same.

If @1000Mhz the load drops to 10%, the proposed method will select as target freq
190MHz.


Stratos

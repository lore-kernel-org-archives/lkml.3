Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966570Ab3E2PQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:16:09 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:34298 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966303Ab3E2PQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:16:06 -0400
Message-ID: <51A61BAC.2050203@semaphore.gr>
Date: Wed, 29 May 2013 18:15:56 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] cpufreq: ondemand: Increase frequency to any value
 proportional to load
References: <51A3C6CF.6080104@semaphore.gr> <1733890.jTHBU7EacK@vostro.rjw.lan> <51A4E357.5020509@semaphore.gr> <1567913.u8NiyqJmvF@vostro.rjw.lan>
In-Reply-To: <1567913.u8NiyqJmvF@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 11:54 PM, Rafael J. Wysocki wrote:
> On Tuesday, May 28, 2013 08:03:19 PM Stratos Karafotis wrote:
>> I mean any value of freq table. Please let me know if you want me to rephrase
>> it in description.
> 
> Yes, it would be nice to be more precise.

OK sure, I will add a more precise description.


> Which is equivalent to saying that __cpufreq_driver_getavg() is not useful and
> may be removed (but the patch doesn't do that and I wonder why?), but surely
> the developer who added it wouldn't agree.
> 
> So, please explain: why can we drop __cpufreq_driver_getavg()?
> 

With the new proposed method the next frequency is not dependent from current
or average frequency. The next frequency is dependent only from load.
So, we don't need support for freq feedback from hardware anymore.
Even if, due to underlying hardware coordination mechanism, CPU runs in different 
frequency than the actual, the calculation of load and of target frequency will
remain the unaffected, with this patch.

With full respect to ondemand coauthor, and if the new method is acceptable,
I could send a patch to revert the original one about the IA32_APERF and
IA32_MPERF MSR support.


>> Thus, in the comparison with up_threshold to increase frequency we actually
>> do this (in cases that getavg is not implemented):
>> if (load > up_theshold)
>> 	increase to max
>>
>> So, after the patch we keep the same comparison to decide about the max frequency.
>> I thought, that below up_threshold is 'fair' to decide about the next
>> frequency with formula that frequency is proportional to load.
>> For example in a CPU with min freq 100MHz and max 1000MHz with a
>> load 50 target frequency should be 500MHz.
> 
> Well, that sounds reasonable, but the patch actually does more than that.

I'm sorry, but I didn't understand your last point.


Thanks for your comments,
Stratos


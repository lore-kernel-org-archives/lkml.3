Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbaD2Qeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:34:50 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:41703 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933428AbaD2Qes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:34:48 -0400
Message-ID: <535FD4A6.3050905@semaphore.gr>
Date: Tue, 29 Apr 2014 19:34:46 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: intel_pstate: Change the calculation of next
 pstate
References: <535D80C8.9090906@semaphore.gr> <CAKohpomhUk7RQ3YL3=wpVKSbK_oSkyYBRUZiqnHzWqrZ2DjRRA@mail.gmail.com>
In-Reply-To: <CAKohpomhUk7RQ3YL3=wpVKSbK_oSkyYBRUZiqnHzWqrZ2DjRRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/04/2014 07:58 πμ, Viresh Kumar wrote:
> Cc'd Dirk,
> 
> On 28 April 2014 03:42, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> Currently the driver calculates the next pstate proportional to
>> core_busy factor and reverse proportional to current pstate.
>>
>> Change the above method and calculate the next pstate independently
>> of current pstate.
> 
> We must mention why the change is required.
> 

Hi Viresh,

Actually, I can't say that it's required. :)
I just believe that calculation of next p-state should be independent
from current one. In my opinion we can't scale the load across different
p-states, because it's not always equivalent.

For example suppose a load of 100% because of a tight for loop in the
current p-state. It will be also a 100% load in any other p-state.
It will be wrong if we scale the load in the calculation formula
according to the current p-state.

I included the test results in the change log to point out an improvement
because of this patch.

I will enrich more the change log as you suggested.

Thanks,
Stratos Karafotis


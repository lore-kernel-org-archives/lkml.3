Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3H0PqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:46:07 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:46964 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751570Ab3H0PqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:46:05 -0400
Message-ID: <521CC9B8.2020801@semaphore.gr>
Date: Tue, 27 Aug 2013 18:46:00 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: governors: Remove duplicate check of target
 freq in supported range
References: <521BA068.8030003@semaphore.gr> <CAKohpo=xBmpEv=oN1qEnq9RKhfjtc4wZayVYyVzjWOU8BnwVJQ@mail.gmail.com>
In-Reply-To: <CAKohpo=xBmpEv=oN1qEnq9RKhfjtc4wZayVYyVzjWOU8BnwVJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 08:57 AM, Viresh Kumar wrote:
> On 27 August 2013 00:07, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>>   drivers/cpufreq/cpufreq_conservative.c | 4 ----
> 
> Get rid of few more checks..
> 
> /* if we are already at full speed then break out early */
> if (dbs_info->requested_freq == policy->max)
> return;
> 
> 
> /*
> * if we cannot reduce the frequency anymore, break out early
> */
> if (policy->cur == policy->min)
> return;
> 

I think we should keep these checks because:

1) They shorten the execution code (there is no unnecessary call of
__cpufreq_driver_target)
2) In case my patch will be accepted, we need them to avoid continuously
increase of dbs_info->requested_freq.With my patch the requested_freq
can temporarily overcome policy->min and policy->max. __cpufreq_driver_target
will select the correct frequency (within policy->min and policy->max).
Then, dbs_cpufreq_notifier will adjust requested_freq.

I hope the logic in 2) to be acceptable.


Thanks,
Stratos

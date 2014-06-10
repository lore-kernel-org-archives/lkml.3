Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaFJOnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:43:32 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:57260 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752290AbaFJOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:43:28 -0400
Message-ID: <5397198B.7070407@semaphore.gr>
Date: Tue, 10 Jun 2014 17:43:23 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] cpufreq: intel_pstate: Trivial code cleanup
References: <5396208F.6070400@semaphore.gr> <1402348962.3142.32.camel@joe-AO725>
In-Reply-To: <1402348962.3142.32.camel@joe-AO725>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 12:22 πμ, Joe Perches wrote:
> On Tue, 2014-06-10 at 00:01 +0300, Stratos Karafotis wrote:
>> Remove unnecessary braces.
> 
> []
> 
>> @@ -204,20 +203,16 @@ static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
> 
>>  static inline void intel_pstate_reset_all_pid(void)
>>  {
>>  	unsigned int cpu;
>> -	for_each_online_cpu(cpu) {
>> +
>> +	for_each_online_cpu(cpu)
>>  		if (all_cpu_data[cpu])
>>  			intel_pstate_busy_pid_reset(all_cpu_data[cpu]);
>> -	}
> 
> It's pretty traditional to keep the braces here
> as it generally makes it clearer for the reader.
> 
> 	for (...) {
> 		if (foo)
> 			bar();
> 	}
> 
> is generally used over
> 
> 	for (...)
> 		if (foo)
> 			bar();
> 
> Just like using
> 
> 	if (foo) {
> 		/* commment */
> 		bar();
> 	}

OK, I will revert these changes in v2.

>> @@ -748,15 +744,14 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
> []
>> -	pr_info("Intel pstate controlling: cpu %d\n", cpunum);
>> +	pr_info("Intel pstate controlling: CPU %d\n", cpunum);
> 
> cpu is very slightly preferred lower case.
> 
> $ git grep -E -i '^[^"]*"[^"]*\bcpu\b'|grep -w -i -o cpu | sort |uniq -c | sort -rn
>    2705 cpu
>    2084 CPU
>      17 Cpu
> 

Although, I believe that the term 'CPU' is more appropriate, I'll revert this
as the majority and Dirk prefer it. :)

Thanks for your comments!
Stratos


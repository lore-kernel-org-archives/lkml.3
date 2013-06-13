Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab3FMWE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:04:29 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:42414 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756798Ab3FMWE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:04:27 -0400
Message-ID: <51BA41E9.8020004@semaphore.gr>
Date: Fri, 14 Jun 2013 01:04:25 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <7661669.NhG4BEI8zO@vostro.rjw.lan> <51B64BC6.6040400@semaphore.gr> <16929930.1G36b4NkSe@vostro.rjw.lan> <51BA380A.1040009@semaphore.gr> <20130613214007.GA32127@pd.tnic>
In-Reply-To: <20130613214007.GA32127@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 12:40 AM, Borislav Petkov wrote:
> On Fri, Jun 14, 2013 at 12:22:18AM +0300, Stratos Karafotis wrote:
>> Please let me share some more test results using aim9 benchmark suite:
>> https://docs.google.com/spreadsheet/ccc?key=0AnMfNYUV1k0ddDdGdlJyUHpqT2xGY1lBOEt2UEVnNlE&usp=sharing
>>
>> Each test was running for 10sec.
>> Total execution time with and without the patch was almost identical, which is
>> expected since the tests in aim9 run for a specific period.
>> The energy during the test run was increased by 0.43% with the patch.
>> The performance was increased by 1.25% (average) with this patch.
> 
> Not bad. However, exec_test and fork_test are kinda unexpected with such
> a high improvement percentage. Happen to have an explanation?
> 
> FWIW, if we don't find any serious perf/power regressions with
> this patch, I'd say it is worth applying even solely for the code
> simplification it brings.
> 

Although, I'm not sure about the unexpected improvement, I confirm this 
(run again the test). Also, there is important improvement in 
Directory searches (+5.79%), Disk Copies (+1.19%), shell scripts 
(1.20%, 1.51%, 2.38%) and tcp/udp tests (3.62%, 1.41%).

I believe that ondemand has better performance with this patch in 
medium loads. Maybe these operations produce small to medium loads (lower
than up_threshold) and push the CPU to medium frequencies. Without the
patch CPU stays longer to min frequency.

Thanks,
Stratos


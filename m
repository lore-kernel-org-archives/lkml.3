Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3JUWn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:43:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65161 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3JUWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:53 -0400
Message-ID: <5265AE27.90600@gmail.com>
Date: Mon, 21 Oct 2013 15:43:51 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "open list:CPU FREQUENCY DRI..." <cpufreq@vger.kernel.org>,
        "open list:CPU FREQUENCY DRI..." <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: intel_pstate: fix possible integer overflow
References: <1382239876-12688-1-git-send-email-geyslan@gmail.com> <52654EA6.6020805@gmail.com> <1734089.XZ0ga7sQd1@vostro.rjw.lan>
In-Reply-To: <1734089.XZ0ga7sQd1@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 03:47 PM, Rafael J. Wysocki wrote:
> On Monday, October 21, 2013 08:56:22 AM Dirk Brandewie wrote:
>> On 10/19/2013 08:31 PM, Geyslan G. Bem wrote:
>>> The expression 'pstate << 8' is evaluated using 32-bit arithmetic while
>>> 'val' expects an expression of type u64.
>>>
>>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> Actually, isn't (pstate << 8) guaranteed not to overflow?
>

Yes, I was assuming this was caught by a static checking tool. I
didn't see a downside to giving the compilier complete information.

>>> ---
>>>    drivers/cpufreq/intel_pstate.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>>> index badf620..43446b5 100644
>>> --- a/drivers/cpufreq/intel_pstate.c
>>> +++ b/drivers/cpufreq/intel_pstate.c
>>> @@ -395,7 +395,7 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
>>>    	trace_cpu_frequency(pstate * 100000, cpu->cpu);
>>>
>>>    	cpu->pstate.current_pstate = pstate;
>>> -	val = pstate << 8;
>>> +	val = (u64)pstate << 8;
>>>    	if (limits.no_turbo)
>>>    		val |= (u64)1 << 32;
>>>
>>>
>>


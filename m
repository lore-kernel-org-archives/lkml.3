Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaKHKkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:40:22 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41240 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaKHKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:40:20 -0500
Message-ID: <545DF30B.1050305@linux.vnet.ibm.com>
Date: Sat, 08 Nov 2014 16:10:11 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, rjw@rjwysocki.net
CC: nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req before
 idle
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110810-0013-0000-0000-00000619EBFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 08:01 PM, Daniel Lezcano wrote:
> When the pmqos latency requirement is set to zero that means "poll in all the
> cases".
> 
> That is correctly implemented on x86 but not on the other archs.
> 
> As how is written the code, if the latency request is zero, the governor will
> return zero, so corresponding, for x86, to the poll function, but for the
> others arch the default idle function. For example, on ARM this is wait-for-
> interrupt with a latency of '1', so violating the constraint.
> 
> In order to fix that, do the latency requirement check *before* calling the
> cpuidle framework in order to jump to the poll function without entering
> cpuidle. That has several benefits:
> 
>  1. It clarifies and unifies the code
>  2. It fixes x86 vs other archs behavior
>  3. Factors out the call to the same function
>  4. Prevent to enter the cpuidle framework with its expensive cost in
>     calculation
> 
> As the latency_req is needed in all the cases, change the select API to take
> the latency_req as parameter in case it is not equal to zero.
> 
> As a positive side effect, it introduces the latency constraint specified
> externally, so one more step to the cpuidle/scheduler integration.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Len Brown <len.brown@intel.com>
> ---

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Regards
Preeti U Murthy


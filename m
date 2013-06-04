Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3FDCdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:33:31 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49620 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3FDCd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:33:29 -0400
Message-ID: <51AD51E3.6060307@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 10:33:07 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [DISCUSSION] removing variety rq->cpu_load ?
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com> <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com> <20130506101936.GE13861@dyad.programming.kicks-ass.net> <CAPM31RJg87C0nO_tAaOGLaDCUAB+QmfV4LkNcwnk9j9voNocfg@mail.gmail.com> <20130506111041.GA15446@dyad.programming.kicks-ass.net> <51889C8A.5000806@intel.com> <51AD46CA.9020609@intel.com> <51AD4808.6020507@intel.com>
In-Reply-To: <51AD4808.6020507@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060402-1618-0000-0000-00000402DDBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alex

On 06/04/2013 09:51 AM, Alex Shi wrote:
> resend with a new subject.

Forgive me but I'm a little lost on this thread...

So we are planing to rely on instant 'cpu_load[0]' and decayed
'runnable_load_avg' only, do we?

Regards,
Michael Wang

> 
>> Peter,
>>
>> I just tried to remove the variety rq.cpu_load, by the following patch. 
>> Because forkexec_idx and busy_idx are all zero, after the patch system just keep cpu_load[0]
>> and remove other values.
>> I tried the patch base 3.10-rc3 and latest tip/sched/core with benchmark dbench,tbench,
>> aim7,hackbench. and oltp of sysbench. Seems performance doesn't change clear.
>> So, for my tested machines, core2, NHM, SNB, with 2 or 4 CPU sockets, and above tested
>> benchmark. We are fine to remove the variety cpu_load. 
>> Don't know if there some other concerns on other scenarios.
>>
>> ---
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 590d535..f0ca983 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4626,7 +4626,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
>>         if (child && child->flags & SD_PREFER_SIBLING)
>>                 prefer_sibling = 1;
>>  
>> -       load_idx = get_sd_load_idx(env->sd, env->idle);
>> +       load_idx = 0; //get_sd_load_idx(env->sd, env->idle);
>>  
>>         do {
>>                 int local_group;
>>
>>
> 
> 


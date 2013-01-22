Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3AVSsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:48:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:32936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3AVSsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:48:36 -0500
Message-ID: <50FEDF43.1000703@infradead.org>
Date: Tue, 22 Jan 2013 10:49:39 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: mmotm 2013-01-18-15-48 uploaded (sched/stats.c)
References: <20130118234944.5C99C31C240@corp2gmr1-1.hot.corp.google.com> <50FAF661.4070801@infradead.org> <20130122161037.GA24669@gulag1.americas.sgi.com>
In-Reply-To: <20130122161037.GA24669@gulag1.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/13 08:10, Nathan Zimmer wrote:
> On Sat, Jan 19, 2013 at 11:39:13AM -0800, Randy Dunlap wrote:
>> On 01/18/13 15:49, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2013-01-18-15-48 has been uploaded to
>>>
>>>    http://www.ozlabs.org/~akpm/mmotm/
>>>
>>> mmotm-readme.txt says
>>>
>>> README for mm-of-the-moment:
>>>
>>> http://www.ozlabs.org/~akpm/mmotm/
>>>
>>> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>>> more than once a week.
>>>
>>
>> on i386 or x86_64:
>>
>> kernel/sched/stats.c:31:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
>>
>>
>>
>> -- 
>> ~Randy
> 
> Sorry about that.
> Here is the correction.
> 
> From c832132ade12e28cd09d3c13d412fc14a7b9ab87 Mon Sep 17 00:00:00 2001
> From: Nathan Zimmer <nzimmer@sgi.com>
> Date: Tue, 22 Jan 2013 09:09:17 -0600
> Subject: [PATCH] on i386 or x86_64:
> 
> kernel/sched/stats.c:31:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
> 
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>

Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  kernel/sched/stats.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
> index bae2757..3cbfc46 100644
> --- a/kernel/sched/stats.c
> +++ b/kernel/sched/stats.c
> @@ -25,14 +25,13 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
>  		seq_printf(seq, "timestamp %lu\n", jiffies);
>  	} else {
> -
> -		cpu = (unsigned long)(v - 2);
> -
> -		struct rq *rq = cpu_rq(cpu);
> +		struct rq *rq; 
>  #ifdef CONFIG_SMP
>  		struct sched_domain *sd;
>  		int dcount = 0;
>  #endif
> +		cpu = (unsigned long)(v - 2);
> +		rq = cpu_rq(cpu);
>  
>  		/* runqueue-specific stats */
>  		seq_printf(seq,
> 


-- 
~Randy

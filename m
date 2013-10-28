Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3J1Cl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 22:41:58 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53312 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3J1Cl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 22:41:56 -0400
Message-ID: <526DCEEC.1090308@linux.vnet.ibm.com>
Date: Mon, 28 Oct 2013 10:41:48 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: remove extra put_online_cpus() inside sched_setaffinity()
References: <52673C57.1050607@linux.vnet.ibm.com> <20131025114857.GB6374@gmail.com>
In-Reply-To: <20131025114857.GB6374@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102802-3864-0000-0000-00000AC7035D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

On 10/25/2013 07:48 PM, Ingo Molnar wrote:
[snip]
>> ---
>>  kernel/sched/core.c |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index c06b8d3..7c61f31 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
>>         p = find_process_by_pid(pid);
>>         if (!p) {
>>                 rcu_read_unlock();
>> -               put_online_cpus();
>>                 return -ESRCH;
>>         }
> 
> The patch is whitespace damaged.

Forgive me for the silly mistake... the line may be cursed... will
recheck and send out the right format, thanks for the notify :)

Regards,
Michael Wang

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


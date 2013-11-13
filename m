Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3KMCSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:18:39 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38859 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab3KMCSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:18:31 -0500
Message-ID: <5282E16F.5010407@linux.vnet.ibm.com>
Date: Wed, 13 Nov 2013 10:18:23 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [sched/get_online_cpus] INFO: task swapper/0:1 blocked for more
 than 120 seconds.
References: <20131110101612.GC21916@localhost> <52808B7F.6000309@linux.vnet.ibm.com> <20131111162022.GB21461@twins.programming.kicks-ass.net> <20131112095516.GB32441@localhost>
In-Reply-To: <20131112095516.GB32441@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111302-2000-0000-0000-00000E82AAA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 05:55 PM, Fengguang Wu wrote:
[snip]
>>
>> Good thinking.. Wu did this cure stuff?

Thanks for the confirm :)

> 
> Yes, it fixed the problem.

Thanks for the testing :)

> 
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> 

Will send out a formal patch later.

Regards,
Michael Wang

> 
> /kernel/i386-randconfig-j3-11101308/484f4e66a6a1102edf02407479f6f7632aade0f3
> 
> +--------------------------------------------------+--------------+--------------+
> |                                                  | e5137b50a064 | 484f4e66a6a1 |
> +--------------------------------------------------+--------------+--------------+
> | boot_successes                                   | 42           | 100          |
> | boot_failures                                    | 58           |              |
> | INFO:task_blocked_for_more_than_seconds          | 58           |              |
> | Kernel_panic-not_syncing:hung_task:blocked_tasks | 58           |              |
> +--------------------------------------------------+--------------+--------------+
> 
> /kernel/x86_64-randconfig-x4-1108/484f4e66a6a1102edf02407479f6f7632aade0f3
> 
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> |                                                                                    | v3.12-rc7 | e5137b50a064 | 484f4e66a6a1 |
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> | boot_successes                                                                     | 59        | 34           | 100          |
> | has_kernel_error_warning                                                           | 4         |              |              |
> | BUG:kernel_early_hang_without_any_printk_output                                    | 4         |              |              |
> | boot_failures                                                                      | 0         | 66           |              |
> | INFO:task_blocked_for_more_than_seconds                                            | 0         | 66           |              |
> | INFO:NMI_handler(arch_trigger_all_cpu_backtrace_handler)took_too_long_to_run:msecs | 0         | 55           |              |
> | Kernel_panic-not_syncing:hung_task:blocked_tasks                                   | 0         | 66           |              |
> +------------------------------------------------------------------------------------+-----------+--------------+--------------+
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


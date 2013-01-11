Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3AKE6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:58:25 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43583 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3AKE6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:58:24 -0500
Message-ID: <50EF9BA4.1070108@linux.vnet.ibm.com>
Date: Fri, 11 Jan 2013 10:27:08 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/22] sched: select_task_rq_fair clean up
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-3-git-send-email-alex.shi@intel.com>
In-Reply-To: <1357375071-11793-3-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011104-3568-0000-0000-00000302DC6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 02:07 PM, Alex Shi wrote:
> It is impossible to miss a task allowed cpu in a eligible group.
> 
> And since find_idlest_group only return a different group which
> excludes old cpu, it's also imporissible to find a new cpu same as old
> cpu.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5eea870..6d3a95d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3378,11 +3378,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		}
> 
>  		new_cpu = find_idlest_cpu(group, p, cpu);
> -		if (new_cpu == -1 || new_cpu == cpu) {
> -			/* Now try balancing at a lower domain level of cpu */
> -			sd = sd->child;
> -			continue;
> -		}
> 
>  		/* Now try balancing at a lower domain level of new_cpu */
>  		cpu = new_cpu;
> 
Reviewed-by:Preeti U Murthy


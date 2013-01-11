Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3AKFDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:03:40 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42077 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3AKFDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:03:39 -0500
Message-ID: <50EF9CDB.60901@linux.vnet.ibm.com>
Date: Fri, 11 Jan 2013 10:32:19 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/22] sched: don't need go to smaller sched domain
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-5-git-send-email-alex.shi@intel.com>
In-Reply-To: <1357375071-11793-5-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011105-4790-0000-0000-000006655A79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 02:07 PM, Alex Shi wrote:
> If parent sched domain has no task allowed cpu find. neither find in
> it's child. So, go out to save useless checking.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3c7b09a..ecfbf8e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3378,10 +3378,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  			load_idx = sd->wake_idx;
> 
>  		group = find_idlest_group(sd, p, cpu, load_idx);
> -		if (!group) {
> -			sd = sd->child;
> -			continue;
> -		}
> +		if (!group)
> +			goto unlock;
> 
>  		new_cpu = find_idlest_cpu(group, p, cpu);
> 
Reviewed-by:Preeti U Murthy


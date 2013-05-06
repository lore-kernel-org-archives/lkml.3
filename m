Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3EFD2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:28:47 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59294 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3EFD2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:28:44 -0400
Message-ID: <51872300.9000801@linux.vnet.ibm.com>
Date: Mon, 06 May 2013 08:56:56 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch v7 16/21] sched: no balance for prefer_sibling in power
 scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <1365040862-8390-17-git-send-email-alex.shi@intel.com>
In-Reply-To: <1365040862-8390-17-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050603-4790-0000-0000-0000082B0797
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

You can add my Reviewed-by for the below patch.

Thanks

Regards
Preeti U Murthy

On 04/04/2013 07:30 AM, Alex Shi wrote:
> In power aware scheduling, we don't want to balance 'prefer_sibling'
> groups just because local group has capacity.
> If the local group has no tasks at the time, that is the power
> balance hope so.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0dd29f4..86221e7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4762,8 +4762,12 @@ static inline void update_sd_lb_stats(struct lb_env *env,
>  		 * extra check prevents the case where you always pull from the
>  		 * heaviest group when it is already under-utilized (possible
>  		 * with a large weight task outweighs the tasks on the system).
> +		 *
> +		 * In power aware scheduling, we don't care load weight and
> +		 * want not to pull tasks just because local group has capacity.
>  		 */
> -		if (prefer_sibling && !local_group && sds->this_has_capacity)
> +		if (prefer_sibling && !local_group && sds->this_has_capacity
> +				&& env->flags & LBF_PERF_BAL)
>  			sgs.group_capacity = min(sgs.group_capacity, 1UL);
> 
>  		if (local_group) {
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbaIXEuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 00:50:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:7539 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaIXEuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 00:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,586,1406617200"; 
   d="scan'208";a="479610597"
From: Andi Kleen <andi@firstfloor.org>
To: John Blackwood <john.blackwood@ccur.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [ PATCH ] Remove numa_balancing sysctl dependence on CONFIG_SCHED_DEBUG
References: <5421B992.6050500@ccur.com>
Date: Tue, 23 Sep 2014 21:50:38 -0700
In-Reply-To: <5421B992.6050500@ccur.com> (John Blackwood's message of "Tue, 23
	Sep 2014 13:18:58 -0500")
Message-ID: <87d2al7hb5.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Blackwood <john.blackwood@ccur.com> writes:

> numa: numa_balancing sysctl scope change
>
> Make the 'numa_balancing' sysctl parameter no longer dependent upon
> CONFIG_SCHED_DEBUG so it can be used in non-debug kernels.

Looks good.
-Andi

>
> Signed-off-by: John Blackwood <john.blackwood@ccur.com>
>
> Index: b/kernel/sysctl.c
> ===================================================================
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -389,6 +389,9 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +#endif /* CONFIG_NUMA_BALANCING */
> +#endif /* CONFIG_SCHED_DEBUG */
> +#ifdef CONFIG_NUMA_BALANCING
>  	{
>  		.procname	= "numa_balancing",
>  		.data		= NULL, /* filled in by handler */
> @@ -399,7 +402,6 @@ static struct ctl_table kern_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif /* CONFIG_NUMA_BALANCING */
> -#endif /* CONFIG_SCHED_DEBUG */
>  	{
>  		.procname	= "sched_rt_period_us",
>  		.data		= &sysctl_sched_rt_period,

-- 
ak@linux.intel.com -- Speaking for myself only

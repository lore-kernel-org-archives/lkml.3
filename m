Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaA3BtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 20:49:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:46518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaA3BtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 20:49:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,746,1384329600"; 
   d="scan'208";a="474837923"
Date: Wed, 29 Jan 2014 17:49:14 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20140130014914.GC9804@tassilo.jf.intel.com>
References: <20140130124201.d24b784b6483a11fe3057bd9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130124201.d24b784b6483a11fe3057bd9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

I don't think the fix is correct, both sysctls need to be kept. They
do different things.

-Andi

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc kernel/sysctl.c
> index 096db7452cbd,2a4a4fc89cd1..000000000000
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@@ -383,22 -386,6 +385,15 @@@ static struct ctl_table kern_table[] = 
>   		.mode		= 0644,
>   		.proc_handler	= proc_dointvec,
>   	},
>  +	{
> - 		.procname       = "numa_balancing_migrate_deferred",
> - 		.data           = &sysctl_numa_balancing_migrate_deferred,
> - 		.maxlen         = sizeof(unsigned int),
> - 		.mode           = 0644,
> - 		.proc_handler   = proc_dointvec,
> - 	},
> - 	{
>  +		.procname	= "numa_balancing",
>  +		.data		= NULL, /* filled in by handler */
>  +		.maxlen		= sizeof(unsigned int),
>  +		.mode		= 0644,
>  +		.proc_handler	= sysctl_numa_balancing,
>  +		.extra1		= &zero,
>  +		.extra2		= &one,
>  +	},
>   #endif /* CONFIG_NUMA_BALANCING */
>   #endif /* CONFIG_SCHED_DEBUG */
>   	{



-- 
ak@linux.intel.com -- Speaking for myself only
